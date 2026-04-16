USE EventTicketing;
GO

-- Add missing quantity_sold column to TICKETTYPE (if not exists)
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('TICKETTYPE') AND name = 'quantity_sold')
BEGIN
    ALTER TABLE TICKETTYPE ADD quantity_sold INT NOT NULL DEFAULT 0;
END
GO

-- Verify column names (optional)
SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TICKETTYPE';
GO


-- ============================================================
-- TRIGGERS TO ENFORCE BUSINESS RULES
-- ============================================================

-- 1. AFTER INSERT on TICKET: Update quantity_sold in TICKETTYPE
-- Business rule: When tickets are issued, increase the sold count.
CREATE OR ALTER TRIGGER trg_Ticket_UpdateSold
ON Ticket
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE tt
    SET quantity_sold = ISNULL(tt.quantity_sold, 0) + ins.ticket_count
    FROM TicketType tt
    INNER JOIN (
        SELECT oi.ticket_type_id, COUNT(*) AS ticket_count
        FROM INSERTED i
        INNER JOIN OrderItem oi ON i.order_item_id = oi.order_item_id
        GROUP BY oi.ticket_type_id
    ) ins ON tt.ticket_type_id = ins.ticket_type_id;
END;
GO

-- 2. INSTEAD OF INSERT on EVENT: Prevent overlapping events at the same venue
-- Business rule: No two events can be scheduled at the same venue with overlapping time.
CREATE OR ALTER TRIGGER trg_Event_NoOverlap
ON Event
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (
        SELECT 1
        FROM Event e
        INNER JOIN INSERTED i ON e.venue_id = i.venue_id
        WHERE (i.start_date_time BETWEEN e.start_date_time AND e.end_date_time)
           OR (i.end_date_time BETWEEN e.start_date_time AND e.end_date_time)
           OR (e.start_date_time BETWEEN i.start_date_time AND i.end_date_time)
    )
    BEGIN
        RAISERROR('Venue already booked for overlapping time period.', 16, 1);
        ROLLBACK;
        RETURN;
    END
    ELSE
    BEGIN
        INSERT INTO Event (event_id, title, description, start_date_time, end_date_time, status, created_at, cancellation_policy, category_, image_url, organizer_id, venue_id)
        SELECT event_id, title, description, start_date_time, end_date_time, status, created_at, cancellation_policy, category_, image_url, organizer_id, venue_id
        FROM INSERTED;
    END
END;
GO

-- 3. AFTER INSERT on PAYMENT: Automatically mark order as paid when payment is successful
-- Business rule: Payment completion changes order status to 'paid'.
CREATE OR ALTER TRIGGER trg_Payment_OrderPaid
ON Payment
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE o
    SET status_ = 'paid'
    FROM Orders o
    INNER JOIN INSERTED i ON o.order_id = i.order_id
    WHERE i.status = 'success';
END;
GO

-- 4. AFTER UPDATE on TICKET: Prevent marking a ticket as 'used' more than once
-- Business rule: A ticket can be used only once (status changes from 'valid' to 'used' only if not already used).
CREATE OR ALTER TRIGGER trg_Ticket_CheckUsed
ON Ticket
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (
        SELECT 1
        FROM INSERTED i
        INNER JOIN DELETED d ON i.ticket_id = d.ticket_id
        WHERE i.status_ = 'used' AND d.status_ = 'used'
    )
    BEGIN
        RAISERROR('Ticket already marked as used. Cannot change again.', 16, 1);
        ROLLBACK;
    END
END;
GO

-- 5. BEFORE INSERT on ORDERITEM: Check that ticket type still has available quantity (optional, but good)
-- This requires that TICKETTYPE.quantity_total and quantity_sold are maintained.
CREATE OR ALTER TRIGGER trg_OrderItem_CheckAvailability
ON OrderItem
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;
    -- Check each inserted row against available quantity
    IF EXISTS (
        SELECT 1
        FROM INSERTED i
        INNER JOIN TicketType tt ON i.ticket_type_id = tt.ticket_type_id
        WHERE (tt.quantity_total_ - ISNULL(tt.quantity_sold,0)) < i.quantity
    )
    BEGIN
        RAISERROR('Insufficient tickets available for the requested ticket type.', 16, 1);
        ROLLBACK;
        RETURN;
    END
    ELSE
    BEGIN
        INSERT INTO OrderItem (order_item_id, order_id, ticket_type_id, quantity, price_at_purchase)
        SELECT order_item_id, order_id, ticket_type_id, quantity, price_at_purchase
        FROM INSERTED;
    END
END;
GO

-- 6. AFTER DELETE on ORDERITEM: Optionally update quantity_sold if tickets are refunded/removed
-- This is more complex; for simplicity, we might handle refunds via application logic.
-- But a trigger could reduce quantity_sold when tickets are deleted (if order cancelled).
CREATE OR ALTER TRIGGER trg_OrderItem_DeleteUpdateSold
ON OrderItem
AFTER DELETE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE tt
    SET quantity_sold = ISNULL(tt.quantity_sold,0) - del.ticket_count
    FROM TicketType tt
    INNER JOIN (
        SELECT oi.ticket_type_id, SUM(oi.quantity) AS ticket_count
        FROM DELETED oi
        GROUP BY oi.ticket_type_id
    ) del ON tt.ticket_type_id = del.ticket_type_id;
END;
GO

-- Verify triggers exist
SELECT name, is_instead_of_trigger, is_disabled
FROM sys.triggers
WHERE parent_class = 1  -- object-level triggers
ORDER BY name;
GO