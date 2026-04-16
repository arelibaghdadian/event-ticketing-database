-- ============================================================
-- 25 DQL QUERIES (SQL) WITH THEIR RELATIONAL ALGEBRA EQUIVALENTS
-- ============================================================
-- Each query is commented out. Remove the '/*' and '*/' to run.
-- ============================================================

USE EventTicketing;
GO

/* ----------------------------------------------------------------------
1. Selection (σ) – Active events
   Relational Algebra: σ_status = 'active' (Event)
   ---------------------------------------------------------------------- */
/*
SELECT * FROM Event WHERE status = 'active';
*/

/* ----------------------------------------------------------------------
2. Projection (π) – Event titles and start dates
   Relational Algebra: π_title, start_date_time (Event)
   ---------------------------------------------------------------------- */
/*
SELECT title, start_date_time FROM Event;
*/

/* ----------------------------------------------------------------------
3. Simple Join (⨝) – Ticket with its order item
   Relational Algebra: Ticket ⨝ OrderItem
   ---------------------------------------------------------------------- */
/*
SELECT t.ticket_id, t.unique_code_, oi.order_id
FROM Ticket t
JOIN OrderItem oi ON t.order_item_id = oi.order_item_id;
*/

/* ----------------------------------------------------------------------
4. Natural Join – Attendee order details
   Relational Algebra: Attendee ⨝ Orders ⨝ OrderItem
   ---------------------------------------------------------------------- */
/*
SELECT a.attendee_id, o.order_id, oi.quantity
FROM Attendee a
JOIN Orders o ON a.attendee_id = o.attendee_id
JOIN OrderItem oi ON o.order_id = oi.order_id;
*/

/* ----------------------------------------------------------------------
5. Selection + Projection – Organizer names and emails
   Relational Algebra: π_first_name, last_name, email ( σ_role='organizer' (User) )
   ---------------------------------------------------------------------- */
/*
SELECT first_name, last_name, email
FROM [User]
WHERE role = 'organizer';
*/

/* ----------------------------------------------------------------------
6. Union (∪) – All attendee first names ∪ all ticket attendee first names
   Relational Algebra: π_first_name (User ⨝ Attendee) ∪ π_attendee_first_name (Ticket)
   ---------------------------------------------------------------------- */
/*
SELECT u.first_name FROM [User] u JOIN Attendee a ON u.user_id = a.user_id
UNION
SELECT attendee_first_name_ FROM Ticket WHERE attendee_first_name_ IS NOT NULL;
*/

/* ----------------------------------------------------------------------
7. Intersection (∩) – First names that appear as both user and ticket attendee
   Relational Algebra: π_first_name (User) ∩ π_attendee_first_name (Ticket)
   ---------------------------------------------------------------------- */
/*
SELECT first_name FROM [User]
INTERSECT
SELECT attendee_first_name_ FROM Ticket WHERE attendee_first_name_ IS NOT NULL;
*/

/* ----------------------------------------------------------------------
8. Difference (−) – Venues that have never hosted an event
   Relational Algebra: π_venue_id (Venue) − π_venue_id (Event)
   ---------------------------------------------------------------------- */
/*
SELECT v.venue_id, v.name, v.city
FROM Venue v
WHERE NOT EXISTS (
    SELECT 1 FROM Event e WHERE e.venue_id = v.venue_id
);
*/


/* ----------------------------------------------------------------------
9. Join with condition – Events at venue with capacity > 15000
   Relational Algebra: π_title, name, capacity ( σ_capacity>15000 (Event ⨝ Venue) )
   ---------------------------------------------------------------------- */
/*
SELECT e.title, v.name, v.capacity
FROM Event e
JOIN Venue v ON e.venue_id = v.venue_id
WHERE v.capacity > 15000;
*/

/* ----------------------------------------------------------------------
10. Self‑join – Pairs of events at the same venue
    Relational Algebra: ρ_E1(Event) ⨝_E1.venue_id=E2.venue_id ∧ E1.event_id<E2.event_id ρ_E2(Event)
    ---------------------------------------------------------------------- */
/*
SELECT e1.title AS event1, e2.title AS event2, e1.venue_id
FROM Event e1, Event e2
WHERE e1.venue_id = e2.venue_id AND e1.event_id < e2.event_id;
*/

/* ----------------------------------------------------------------------
11. Aggregation with grouping – Tickets sold per event
    Relational Algebra: 𝒢_event_id; SUM(quantity)→tickets_sold (TicketType ⨝ OrderItem)
    ---------------------------------------------------------------------- */
/*
SELECT tt.event_id, SUM(oi.quantity) AS tickets_sold
FROM TicketType tt
JOIN OrderItem oi ON tt.ticket_type_id = oi.ticket_type_id
GROUP BY tt.event_id;
*/

/* ----------------------------------------------------------------------
12. Aggregation with HAVING – Events with at least 1 ticket sold
    (Changed from >100 to >0 because test data has fewer tickets)
    Relational Algebra: σ_tickets_sold>0 ( 𝒢_event_id; SUM(quantity)→tickets_sold (TicketType⨝OrderItem) )
    ---------------------------------------------------------------------- */
/*
SELECT e.event_id, e.title, SUM(oi.quantity) AS tickets_sold
FROM Event e
JOIN TicketType tt ON e.event_id = tt.event_id
JOIN OrderItem oi ON tt.ticket_type_id = oi.ticket_type_id
GROUP BY e.event_id, e.title
HAVING SUM(oi.quantity) > 0;
*/

/* ----------------------------------------------------------------------
13. Division (÷) – Attendees who have bought both 'General Admission' AND 'VIP' tickets
    (any event). This is equivalent to:
    π_attendee_id, ticket_type_name (Orders⨝OrderItem⨝TicketType) ÷ π_name (σ_name IN ('General Admission','VIP') (TicketType))
    ---------------------------------------------------------------------- */
/*
SELECT o.attendee_id
FROM Orders o
WHERE NOT EXISTS (
    SELECT tt.name
    FROM TicketType tt
    WHERE tt.name IN ('General Admission', 'VIP')
    EXCEPT
    SELECT tt2.name
    FROM OrderItem oi
    JOIN TicketType tt2 ON oi.ticket_type_id = tt2.ticket_type_id
    WHERE oi.order_id IN (SELECT order_id FROM Orders WHERE attendee_id = o.attendee_id)
);
*/


/* ----------------------------------------------------------------------
14. Cartesian product (×) – All combinations of venues and event categories
    Relational Algebra: π_name, category_ (Venue × π_category_ (Event))
    ---------------------------------------------------------------------- */
/*
SELECT v.name, e.category_
FROM Venue v
CROSS JOIN (SELECT DISTINCT category_ FROM Event) e;
*/

/* ----------------------------------------------------------------------
15. Rename (ρ) – Self‑join with aliases (trivial example)
    Relational Algebra: ρ_O1(Orders) ⨝_O1.order_id=O2.order_id ρ_O2(Orders)
    ---------------------------------------------------------------------- */
/*
SELECT *
FROM Orders O1, Orders O2
WHERE O1.order_id = O2.order_id;   -- trivial, only for demo
*/

/* ----------------------------------------------------------------------
16. Outer join – All venues even if no event
    Relational Algebra: Venue ⟕ Event
    ---------------------------------------------------------------------- */
/*
SELECT v.name, e.title
FROM Venue v
LEFT JOIN Event e ON v.venue_id = e.venue_id;
*/

/* ----------------------------------------------------------------------
17. Subquery in WHERE – Events with any ticket price > 100
    Relational Algebra: π_title ( Event ⨝ ( σ_price>100 (TicketType) ) )
    ---------------------------------------------------------------------- */
/*
SELECT title FROM Event
WHERE event_id IN (SELECT event_id FROM TicketType WHERE price > 100);
*/

/* ----------------------------------------------------------------------
18. Correlated subquery (grouped) – Attendees who placed more than 1 order
    Relational Algebra: σ_order_count>1 ( 𝒢_attendee_id; COUNT(order_id)→order_count (Orders) )
    ---------------------------------------------------------------------- */
/*
SELECT attendee_id
FROM Orders
GROUP BY attendee_id
HAVING COUNT(order_id) > 1;
*/

/* ----------------------------------------------------------------------
19. Set union – Emails of users and contact emails of organizers
    Relational Algebra: π_email (User) ∪ π_contact_email (Organizer)
    ---------------------------------------------------------------------- */
/*
SELECT email FROM [User]
UNION
SELECT contact_email FROM Organizer WHERE contact_email IS NOT NULL;
*/

/* ----------------------------------------------------------------------
20. Set difference – Events that have no tickets sold
    Relational Algebra: π_event_id (Event) − π_event_id (TicketType ⨝ OrderItem)
    Modified to show event titles instead of just IDs.
    ---------------------------------------------------------------------- */
/*
SELECT e.event_id, e.title, e.start_date_time
FROM Event e
WHERE NOT EXISTS (
    SELECT 1
    FROM TicketType tt
    JOIN OrderItem oi ON tt.ticket_type_id = oi.ticket_type_id
    WHERE tt.event_id = e.event_id
);
*/

/* ----------------------------------------------------------------------
21. Aggregation with HAVING – Attendees who have bought tickets for at least two different events.
    Relational Algebra: 
    π_attendee_id, COUNT(DISTINCT event_id) → events_bought (Orders ⨝ OrderItem ⨝ TicketType)
    then σ_events_bought >= 2
    ---------------------------------------------------------------------- */
/*
SELECT o.attendee_id, COUNT(DISTINCT tt.event_id) AS events_bought
FROM Orders o
JOIN OrderItem oi ON o.order_id = oi.order_id
JOIN TicketType tt ON oi.ticket_type_id = tt.ticket_type_id
GROUP BY o.attendee_id
HAVING COUNT(DISTINCT tt.event_id) >= 2;
*/

/* ----------------------------------------------------------------------
22. Aggregation without grouping – Total revenue from all paid orders
    Relational Algebra: 𝒢_SUM(amount)→total_revenue (Payment)
    ---------------------------------------------------------------------- */
/*
SELECT SUM(amount) AS total_revenue FROM Payment WHERE status = 'success';
*/

/* ----------------------------------------------------------------------
23. Join with ordering – Top 3 most expensive ticket types
    Relational Algebra: τ_price DESC (π_name, price (TicketType)) limit 3
    ---------------------------------------------------------------------- */
/*
SELECT TOP 3 name, price FROM TicketType ORDER BY price DESC;
*/

/* ----------------------------------------------------------------------
24. Complex join – For each ticket, show event title and attendee name
    (handles optional attendee_first_name – if NULL, shows 'Purchaser')
    Relational Algebra: π_ticket_id, title, attendee_first_name ( Ticket ⨝ OrderItem ⨝ TicketType ⨝ Event )
    ---------------------------------------------------------------------- */
/*
-- Show NULL when no attendee name is stored
SELECT t.ticket_id, e.title, t.attendee_first_name_
FROM Ticket t
JOIN OrderItem oi ON t.order_item_id = oi.order_item_id
JOIN TicketType tt ON oi.ticket_type_id = tt.ticket_type_id
JOIN Event e ON tt.event_id = e.event_id;
*/


/* ----------------------------------------------------------------------
25. Selection with multiple conditions – Paid orders in 2025 with amount > 200
    Relational Algebra: σ_status='success' ∧ YEAR(payment_date)=2025 ∧ amount>200 (Payment)
    ---------------------------------------------------------------------- */
/*
SELECT * FROM Payment
WHERE status = 'success'
  AND YEAR(payment_date) = 2025
  AND amount > 200;
*/