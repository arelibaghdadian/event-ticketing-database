USE EventTicketing;
GO

-- ============================================================
-- INDEXES TO OPTIMIZE QUERY PERFORMANCE
-- ============================================================

-- 1. Foreign key indexes (speed up JOINs)
CREATE INDEX IX_Event_Organizer ON Event(organizer_id);
CREATE INDEX IX_Event_Venue ON Event(venue_id);
CREATE INDEX IX_TicketType_Event ON TicketType(event_id);
CREATE INDEX IX_Order_Attendee ON Orders(attendee_id);
CREATE INDEX IX_OrderItem_Order ON OrderItem(order_id);
CREATE INDEX IX_OrderItem_TicketType ON OrderItem(ticket_type_id);
CREATE INDEX IX_Ticket_OrderItem ON Ticket(order_item_id);
CREATE INDEX IX_Payment_Order ON Payment(order_id);

-- 2. Indexes on columns frequently used in WHERE clauses
CREATE INDEX IX_User_Email ON [User](email);               -- login lookups
CREATE INDEX IX_User_Role ON [User](role);                 -- filter by role
CREATE INDEX IX_Event_Status ON Event(status);             -- filter active/completed
CREATE INDEX IX_Event_Dates ON Event(start_date_time, end_date_time); -- date range searches
CREATE INDEX IX_Order_Status ON Orders(status_);           -- filter by order status
CREATE INDEX IX_Ticket_Status ON Ticket(status_);          -- filter valid/used/refunded
CREATE INDEX IX_Payment_Status ON Payment(status);         -- filter payment status
CREATE INDEX IX_Payment_Date ON Payment(payment_date);     -- date range reports

-- 3. Indexes on columns used in sorting or grouping
CREATE INDEX IX_Order_OrderDate ON Orders(order_date);
CREATE INDEX IX_Ticket_IssuedDate ON Ticket(issued_date);
CREATE INDEX IX_Event_Category ON Event(category_);

-- 4. Covering index for common sales report query
-- (includes all columns needed without touching the table)
CREATE INDEX IX_OrderItem_PriceQuantity ON OrderItem(order_id, ticket_type_id) 
    INCLUDE (quantity, price_at_purchase);
GO

-- Optional: Display existing indexes for verification
SELECT 
    t.name AS TableName,
    i.name AS IndexName,
    i.type_desc
FROM sys.indexes i
JOIN sys.tables t ON i.object_id = t.object_id
WHERE t.name IN ('Event', 'Orders', 'OrderItem', 'Ticket', 'Payment', 'User')
ORDER BY t.name, i.name;
GO