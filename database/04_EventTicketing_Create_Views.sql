USE EventTicketing;
GO

-- ============================================================
-- VIEW 1: Active events with venue details
-- ============================================================
CREATE OR ALTER VIEW v_ActiveEvents AS
SELECT 
    e.event_id,
    e.title,
    e.start_date_time,
    e.end_date_time,
    v.name AS venue_name,
    v.city,
    v.capacity
FROM Event e
JOIN Venue v ON e.venue_id = v.venue_id
WHERE e.status = 'active';
GO

-- ============================================================
-- VIEW 2: Sales summary per event (paid orders only)
-- ============================================================
CREATE OR ALTER VIEW v_EventSales AS
SELECT 
    e.event_id,
    e.title,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(oi.quantity) AS tickets_sold,
    SUM(oi.price_at_purchase * oi.quantity) AS total_revenue
FROM Event e
JOIN TicketType tt ON e.event_id = tt.event_id
JOIN OrderItem oi ON tt.ticket_type_id = oi.ticket_type_id
JOIN Orders o ON oi.order_id = o.order_id
WHERE o.status_ = 'paid'
GROUP BY e.event_id, e.title;
GO

-- ============================================================
-- VIEW 3: Attendee purchase history (with fallback to purchaser name)
-- ============================================================
CREATE OR ALTER VIEW v_AttendeeHistory AS
SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    o.order_id,
    o.order_date,
    o.status_,
    SUM(oi.quantity) AS total_tickets,
    SUM(oi.price_at_purchase * oi.quantity) AS total_spent
FROM [User] u
JOIN Attendee a ON u.user_id = a.user_id
JOIN Orders o ON a.attendee_id = o.attendee_id
JOIN OrderItem oi ON o.order_id = oi.order_id
GROUP BY u.user_id, u.first_name, u.last_name, o.order_id, o.order_date, o.status_;
GO

-- ============================================================
-- VIEW 4: Venue utilization (events hosted and total hours booked)
-- ============================================================
CREATE OR ALTER VIEW v_VenueUtilization AS
SELECT 
    v.venue_id,
    v.name,
    v.city,
    COUNT(e.event_id) AS events_hosted,
    ISNULL(SUM(DATEDIFF(HOUR, e.start_date_time, e.end_date_time)), 0) AS total_hours_booked
FROM Venue v
LEFT JOIN Event e ON v.venue_id = e.venue_id
GROUP BY v.venue_id, v.name, v.city;
GO

-- ============================================================
-- VIEW 5: Valid tickets (not used or refunded) with event and attendee names
-- ============================================================
CREATE OR ALTER VIEW v_ValidTickets AS
SELECT 
    t.ticket_id,
    t.unique_code_,
    t.issued_date,
    t.seat_number,
    e.title AS event_title,
    COALESCE(
        t.attendee_first_name_ + ' ' + t.attendee_last_name_, 
        u.first_name + ' ' + u.last_name,
        'Unknown'
    ) AS attendee_name
FROM Ticket t
JOIN OrderItem oi ON t.order_item_id = oi.order_item_id
JOIN TicketType tt ON oi.ticket_type_id = tt.ticket_type_id
JOIN Event e ON tt.event_id = e.event_id
JOIN Orders o ON oi.order_id = o.order_id
JOIN Attendee a ON o.attendee_id = a.attendee_id
JOIN [User] u ON a.user_id = u.user_id
WHERE t.status_ = 'valid';
GO



-- ============================================================
-- VIEW 6: EventSummary
-- ============================================================
CREATE OR ALTER VIEW EventSummary AS
SELECT 
    e.event_id,
    e.title,
    e.start_date_time,
    e.end_date_time,
    e.status,
    v.name AS venue_name,
    v.city,
    o.organizer_id
FROM EVENT e
JOIN VENUE v ON e.venue_id = v.venue_id
JOIN ORGANIZER o ON e.organizer_id = o.organizer_id;
GO

-- ============================================================
-- Verify views exist
-- ============================================================
SELECT name FROM sys.views WHERE name IN (
    'v_ActiveEvents', 'v_EventSales', 'v_AttendeeHistory', 
    'v_VenueUtilization', 'v_ValidTickets', 'EventSummary'
);
GO