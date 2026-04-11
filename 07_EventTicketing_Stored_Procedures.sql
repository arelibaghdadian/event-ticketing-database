USE EventTicketing;
GO

-- ============================================================
-- ENSURE TABLE TYPES EXIST
-- ============================================================
IF TYPE_ID('TicketTypeTableType') IS NULL
    CREATE TYPE TicketTypeTableType AS TABLE (
        name VARCHAR(50),
        price DECIMAL(10,2),
        quantity_total_ INT,
        description VARCHAR(200),
        sales_start_date DATE,
        sales_end_date DATE
    );
GO

IF TYPE_ID('OrderItemTableType') IS NULL
    CREATE TYPE OrderItemTableType AS TABLE (
        ticket_type_id INT,
        quantity INT
    );
GO

-- ============================================================
-- 1. usp_RegisterUser (fixed)
-- ============================================================
CREATE OR ALTER PROCEDURE usp_RegisterUser
    @first_name VARCHAR(30),
    @last_name VARCHAR(50),
    @email VARCHAR(100),
    @password_hash VARCHAR(255),
    @role VARCHAR(20),
    @phone VARCHAR(20) = NULL,
    @address VARCHAR(100) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        IF EXISTS (SELECT 1 FROM [User] WHERE email = @email)
        BEGIN
            RAISERROR('Email already exists.', 16, 1);
            RETURN;
        END;
        DECLARE @user_id INT;
        SELECT @user_id = ISNULL(MAX(user_id), 0) + 1 FROM [User];
        INSERT INTO [User] (user_id, first_name, last_name, email, password_hash, role, registration_date, phone_, address_)
        VALUES (@user_id, @first_name, @last_name, @email, @password_hash, @role, GETDATE(), @phone, @address);
        IF @role = 'attendee'
        BEGIN
            DECLARE @attendee_id INT;
            SELECT @attendee_id = ISNULL(MAX(attendee_id), 0) + 1 FROM Attendee;
            INSERT INTO Attendee (attendee_id, user_id) VALUES (@attendee_id, @user_id);
        END;
        IF @role = 'organizer'
        BEGIN
            DECLARE @organizer_id INT;
            SELECT @organizer_id = ISNULL(MAX(organizer_id), 0) + 1 FROM Organizer;
            INSERT INTO Organizer (organizer_id, user_id, company_name, contact_person, contact_email)
            VALUES (@organizer_id, @user_id, NULL, @first_name + ' ' + @last_name, @email);
        END;
        COMMIT TRANSACTION;
        SELECT @user_id AS UserID, 'User registered successfully.' AS Message;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO

-- ============================================================
-- 2. usp_CreateEvent (fixed – generates event_id)
-- ============================================================
CREATE OR ALTER PROCEDURE usp_CreateEvent
    @title VARCHAR(50),
    @description VARCHAR(500),
    @start_date_time DATETIME,
    @end_date_time DATETIME,
    @category VARCHAR(50),
    @organizer_id INT,
    @venue_id INT,
    @ticket_types TicketTypeTableType READONLY
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Check venue availability
        IF EXISTS (
            SELECT 1 FROM Event
            WHERE venue_id = @venue_id
              AND ( (@start_date_time BETWEEN start_date_time AND end_date_time)
                 OR (@end_date_time BETWEEN start_date_time AND end_date_time)
                 OR (start_date_time BETWEEN @start_date_time AND @end_date_time) )
        )
        BEGIN
            RAISERROR('Venue is already booked for the given time.', 16, 1);
            RETURN;
        END;
        
        DECLARE @event_id INT;
        SELECT @event_id = ISNULL(MAX(event_id), 0) + 1 FROM Event;
        
        INSERT INTO Event (event_id, title, description, start_date_time, end_date_time, status, created_at, category_, organizer_id, venue_id)
        VALUES (@event_id, @title, @description, @start_date_time, @end_date_time, 'active', GETDATE(), @category, @organizer_id, @venue_id);
        
        -- Generate new ticket_type_ids
        DECLARE @max_tt_id INT;
        SELECT @max_tt_id = ISNULL(MAX(ticket_type_id), 0) FROM TicketType;
        
        INSERT INTO TicketType (ticket_type_id, name, price, quantity_total_, description, sales_start_date, sales_end_date, event_id)
        SELECT 
            @max_tt_id + ROW_NUMBER() OVER (ORDER BY (SELECT NULL)),
            name, price, quantity_total_, description, sales_start_date, sales_end_date, @event_id
        FROM @ticket_types;
        
        COMMIT TRANSACTION;
        SELECT @event_id AS EventID, 'Event created successfully.' AS Message;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO

-- ============================================================
-- 3. usp_PurchaseTickets (fully fixed – generates all IDs)
-- ============================================================
CREATE OR ALTER PROCEDURE usp_PurchaseTickets
    @attendee_id INT,
    @items OrderItemTableType READONLY,
    @payment_method VARCHAR(30)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        DECLARE @order_id INT;
        SELECT @order_id = ISNULL(MAX(order_id), 0) + 1 FROM Orders;
        INSERT INTO Orders (order_id, order_date, status_, attendee_id)
        VALUES (@order_id, GETDATE(), 'pending', @attendee_id);
        DECLARE @total_amount DECIMAL(10,2) = 0;
        DECLARE @ticket_type_id INT, @quantity INT, @price DECIMAL(10,2), @order_item_id INT;
        DECLARE item_cursor CURSOR FOR SELECT ticket_type_id, quantity FROM @items;
        OPEN item_cursor;
        FETCH NEXT FROM item_cursor INTO @ticket_type_id, @quantity;
        WHILE @@FETCH_STATUS = 0
        BEGIN
            SELECT @price = price FROM TicketType WHERE ticket_type_id = @ticket_type_id;
            SELECT @order_item_id = ISNULL(MAX(order_item_id), 0) + 1 FROM OrderItem;
            INSERT INTO OrderItem (order_item_id, order_id, ticket_type_id, quantity, price_at_purchase)
            VALUES (@order_item_id, @order_id, @ticket_type_id, @quantity, @price);
            DECLARE @i INT = 1;
            WHILE @i <= @quantity
            BEGIN
                DECLARE @ticket_id INT;
                SELECT @ticket_id = ISNULL(MAX(ticket_id), 0) + 1 FROM Ticket;
                INSERT INTO Ticket (ticket_id, unique_code_, issued_date, status_, order_item_id, seat_number)
                VALUES (@ticket_id, ABS(CHECKSUM(NEWID())) % 1000000, GETDATE(), 'valid', @order_item_id, @ticket_id);
                SET @i = @i + 1;
            END;
            SET @total_amount = @total_amount + (@price * @quantity);
            FETCH NEXT FROM item_cursor INTO @ticket_type_id, @quantity;
        END;
        CLOSE item_cursor;
        DEALLOCATE item_cursor;
        DECLARE @payment_id INT;
        SELECT @payment_id = ISNULL(MAX(payment_id), 0) + 1 FROM Payment;
        DECLARE @transaction_id INT = ABS(CHECKSUM(NEWID())) % 999999;
        INSERT INTO Payment (payment_id, amount, payment_date, transaction_id_, status, payment_method_, order_id)
        VALUES (@payment_id, @total_amount, GETDATE(), @transaction_id, 'pending', @payment_method, @order_id);
        UPDATE Payment SET status = 'success' WHERE payment_id = @payment_id;
        UPDATE Orders SET status_ = 'paid' WHERE order_id = @order_id;
        COMMIT TRANSACTION;
        SELECT @order_id AS OrderID, @total_amount AS TotalAmount, 'Purchase completed successfully.' AS Message;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO

-- ============================================================
-- 4. usp_CancelOrder (no ID generation needed, but uses order_id)
-- ============================================================
CREATE OR ALTER PROCEDURE usp_CancelOrder
    @order_id INT,
    @reason VARCHAR(200) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        DECLARE @status VARCHAR(20);
        SELECT @status = status_ FROM Orders WHERE order_id = @order_id;
        IF @status IS NULL
        BEGIN
            RAISERROR('Order not found.', 16, 1);
            RETURN;
        END;
        IF @status IN ('cancelled', 'refunded')
        BEGIN
            RAISERROR('Order is already cancelled or refunded.', 16, 1);
            RETURN;
        END;
        UPDATE Orders SET status_ = 'cancelled' WHERE order_id = @order_id;
        UPDATE t SET status_ = 'refunded'
        FROM Ticket t
        JOIN OrderItem oi ON t.order_item_id = oi.order_item_id
        WHERE oi.order_id = @order_id;
        UPDATE Payment SET status = 'failed' WHERE order_id = @order_id;
        COMMIT TRANSACTION;
        SELECT @order_id AS OrderID, 'Order cancelled successfully.' AS Message;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO

-- ============================================================
-- 5. usp_GenerateOrganizerReport (no ID generation)
-- ============================================================
CREATE OR ALTER PROCEDURE usp_GenerateOrganizerReport
    @organizer_id INT,
    @start_date DATE = NULL,
    @end_date DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;
    IF @start_date IS NULL SET @start_date = '1900-01-01';
    IF @end_date IS NULL SET @end_date = GETDATE();
    SELECT 
        e.event_id,
        e.title,
        e.start_date_time,
        COUNT(DISTINCT o.order_id) AS total_orders,
        SUM(oi.quantity) AS tickets_sold,
        SUM(oi.price_at_purchase * oi.quantity) AS total_revenue
    FROM Event e
    JOIN TicketType tt ON e.event_id = tt.event_id
    JOIN OrderItem oi ON tt.ticket_type_id = oi.ticket_type_id
    JOIN Orders o ON oi.order_id = o.order_id
    WHERE e.organizer_id = @organizer_id
      AND o.status_ = 'paid'
      AND o.order_date BETWEEN @start_date AND @end_date
    GROUP BY e.event_id, e.title, e.start_date_time
    ORDER BY e.start_date_time DESC;
END;
GO

-- ============================================================
-- 6. usp_GetAvailableTickets (no ID generation)
-- ============================================================
CREATE OR ALTER PROCEDURE usp_GetAvailableTickets
    @event_id INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT 
        tt.ticket_type_id,
        tt.name,
        tt.price,
        tt.quantity_total_ - ISNULL(tt.quantity_sold, 0) AS available_quantity,
        tt.sales_start_date,
        tt.sales_end_date
    FROM TicketType tt
    WHERE tt.event_id = @event_id
      AND (tt.sales_start_date IS NULL OR tt.sales_start_date <= GETDATE())
      AND (tt.sales_end_date IS NULL OR tt.sales_end_date >= GETDATE())
    ORDER BY tt.price;
END;
GO

-- ============================================================
-- 7. usp_UpdateEventStatus (no ID generation)
-- ============================================================
CREATE OR ALTER PROCEDURE usp_UpdateEventStatus
    @event_id INT,
    @new_status VARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        DECLARE @current_status VARCHAR(20), @start_date DATETIME;
        SELECT @current_status = status, @start_date = start_date_time
        FROM Event WHERE event_id = @event_id;
        IF @current_status IS NULL
        BEGIN
            RAISERROR('Event not found.', 16, 1);
            RETURN;
        END;
        IF @new_status = 'cancelled' AND @start_date < GETDATE()
        BEGIN
            RAISERROR('Cannot cancel an event that has already started.', 16, 1);
            RETURN;
        END;
        IF @new_status = 'active' AND @current_status IN ('cancelled', 'completed')
        BEGIN
            RAISERROR('Cannot reactivate a cancelled or completed event.', 16, 1);
            RETURN;
        END;
        UPDATE Event SET status = @new_status WHERE event_id = @event_id;
        COMMIT TRANSACTION;
        SELECT @event_id AS EventID, @new_status AS NewStatus, 'Event status updated.' AS Message;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO

-- ============================================================
-- 8. usp_CheckInTicket (no ID generation)
-- ============================================================
CREATE OR ALTER PROCEDURE usp_CheckInTicket
    @unique_code VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        DECLARE @ticket_id INT, @current_status VARCHAR(20);
        SELECT @ticket_id = ticket_id, @current_status = status_
        FROM Ticket WHERE unique_code_ = @unique_code;
        IF @ticket_id IS NULL
        BEGIN
            RAISERROR('Ticket not found.', 16, 1);
            RETURN;
        END;
        IF @current_status != 'valid'
        BEGIN
            RAISERROR('Ticket is not valid (status: %s).', 16, 1, @current_status);
            RETURN;
        END;
        UPDATE Ticket SET status_ = 'used' WHERE ticket_id = @ticket_id;
        COMMIT TRANSACTION;
        SELECT @ticket_id AS TicketID, 'Check-in successful.' AS Message;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO

PRINT 'All stored procedures have been updated.';



PRINT 'All stored procedures have been updated.';
GO

-- ============================================================
-- 9. usp_Login
-- ============================================================
CREATE OR ALTER PROCEDURE usp_Login
    @email VARCHAR(100),
    @password VARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        u.user_id,
        u.first_name,
        u.last_name,
        u.email,
        u.role,
        u.registration_date,          -- added this line
        CASE 
            WHEN u.role = 'attendee' THEN a.attendee_id
            ELSE NULL
        END AS attendee_id,
        CASE 
            WHEN u.role = 'organizer' THEN o.organizer_id
            ELSE NULL
        END AS organizer_id
    FROM [User] u
    LEFT JOIN Attendee a ON u.user_id = a.user_id
    LEFT JOIN Organizer o ON u.user_id = o.user_id
    WHERE u.email = @email 
      AND u.password_hash = @password;   -- plain text compare
END;
GO



-- ============================================================
-- 9. usp_BrowseEvents
-- ============================================================
CREATE OR ALTER PROCEDURE usp_BrowseEvents
    @status VARCHAR(20) = 'active'   -- optional: filter by status (active, cancelled, completed)
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        e.event_id,
        e.title,
        e.description,
        e.start_date_time,
        e.end_date_time,
        e.category_ AS category,
        e.status,
        v.name AS venue,              -- venue name from Venue table
        v.city,
        v.address AS venue_address,
        u.first_name + ' ' + u.last_name AS organizer_name
    FROM Event e
    INNER JOIN Venue v ON e.venue_id = v.venue_id
    INNER JOIN Organizer o ON e.organizer_id = o.organizer_id
    INNER JOIN [User] u ON o.user_id = u.user_id
    WHERE e.status = @status
    ORDER BY e.start_date_time ASC;
END;
GO