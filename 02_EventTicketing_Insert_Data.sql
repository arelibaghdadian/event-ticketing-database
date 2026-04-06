USE EventTicketing;
GO

-- ============================================================
-- 1. USER (50 records – real names)
-- ============================================================
INSERT INTO [USER] (user_id, first_name, last_name, email, password_hash, role, registration_date, phone_, address_)
VALUES
(1, 'John', 'Smith', 'john.smith@example.com', 'hash1', 'attendee', '2024-01-15', 1234567890, '12 Main St, New York'),
(2, 'Emma', 'Johnson', 'emma.j@example.com', 'hash2', 'attendee', '2024-02-20', 1234567891, '45 Oak Ave, Los Angeles'),
(3, 'Michael', 'Brown', 'michael.b@example.com', 'hash3', 'attendee', '2024-03-10', 1234567892, '78 Pine Rd, Chicago'),
(4, 'Sarah', 'Davis', 'sarah.davis@example.com', 'hash4', 'attendee', '2024-04-05', 1234567893, '90 Elm St, Houston'),
(5, 'David', 'Wilson', 'david.w@example.com', 'hash5', 'attendee', '2024-05-12', 1234567894, '34 Maple Dr, Phoenix'),
(6, 'Laura', 'Martinez', 'laura.m@example.com', 'hash6', 'attendee', '2024-06-18', 1234567895, '56 Cedar Ln, Philadelphia'),
(7, 'James', 'Anderson', 'james.a@example.com', 'hash7', 'attendee', '2024-07-22', 1234567896, '23 Birch Blvd, San Antonio'),
(8, 'Maria', 'Taylor', 'maria.t@example.com', 'hash8', 'attendee', '2024-08-30', 1234567897, '67 Spruce Way, San Diego'),
(9, 'Robert', 'Thomas', 'robert.t@example.com', 'hash9', 'attendee', '2024-09-14', 1234567898, '89 Willow Ct, Dallas'),
(10, 'Linda', 'Jackson', 'linda.j@example.com', 'hash10', 'attendee', '2024-10-01', 1234567899, '12 Aspen St, Austin'),
(11, 'Patricia', 'White', 'patricia.w@example.com', 'hash11', 'attendee', '2024-01-25', 1234567900, '34 Fir Ave, Fort Worth'),
(12, 'Charles', 'Harris', 'charles.h@example.com', 'hash12', 'attendee', '2024-02-28', 1234567901, '56 Poplar Dr, Columbus'),
(13, 'Susan', 'Martin', 'susan.m@example.com', 'hash13', 'attendee', '2024-03-15', 1234567902, '78 Magnolia Ln, Charlotte'),
(14, 'Daniel', 'Thompson', 'daniel.t@example.com', 'hash14', 'attendee', '2024-04-20', 1234567903, '90 Laurel St, Detroit'),
(15, 'Karen', 'Garcia', 'karen.g@example.com', 'hash15', 'attendee', '2024-05-05', 1234567904, '23 Cypress Rd, El Paso'),
(16, 'Matthew', 'Martinez', 'matthew.m@example.com', 'hash16', 'attendee', '2024-06-10', 1234567905, '45 Beech Pl, Seattle'),
(17, 'Nancy', 'Robinson', 'nancy.r@example.com', 'hash17', 'attendee', '2024-07-19', 1234567906, '67 Ash Dr, Denver'),
(18, 'Donald', 'Clark', 'donald.c@example.com', 'hash18', 'attendee', '2024-08-23', 1234567907, '89 Hickory Way, Washington'),
(19, 'Betty', 'Rodriguez', 'betty.r@example.com', 'hash19', 'attendee', '2024-09-27', 1234567908, '12 Juniper Ln, Boston'),
(20, 'Paul', 'Lewis', 'paul.l@example.com', 'hash20', 'attendee', '2024-10-11', 1234567909, '34 Sycamore St, Nashville'),
(21, 'Jessica', 'Lee', 'jessica.l@example.com', 'hash21', 'attendee', '2024-11-03', 1234567910, '56 Dogwood Ave, Oklahoma City'),
(22, 'Mark', 'Walker', 'mark.w@example.com', 'hash22', 'attendee', '2024-11-18', 1234567911, '78 Redwood Dr, Portland'),
(23, 'Sandra', 'Hall', 'sandra.h@example.com', 'hash23', 'attendee', '2024-12-01', 1234567912, '90 Hemlock Rd, Las Vegas'),
(24, 'Steven', 'Allen', 'steven.a@example.com', 'hash24', 'attendee', '2024-12-12', 1234567913, '23 Fir Ct, Memphis'),
(25, 'Ashley', 'Young', 'ashley.y@example.com', 'hash25', 'attendee', '2024-12-25', 1234567914, '45 Spruce Way, Louisville'),
(26, 'Andrew', 'King', 'andrew.k@example.com', 'hash26', 'attendee', '2025-01-07', 1234567915, '67 Cedar Blvd, Baltimore'),
(27, 'Kimberly', 'Wright', 'kimberly.w@example.com', 'hash27', 'attendee', '2025-01-20', 1234567916, '89 Magnolia Dr, Milwaukee'),
(28, 'Joshua', 'Lopez', 'joshua.l@example.com', 'hash28', 'attendee', '2025-02-02', 1234567917, '12 Pine St, Albuquerque'),
(29, 'Emily', 'Hill', 'emily.h@example.com', 'hash29', 'attendee', '2025-02-14', 1234567918, '34 Oak Ave, Tucson'),
(30, 'Ryan', 'Scott', 'ryan.s@example.com', 'hash30', 'attendee', '2025-02-28', 1234567919, '56 Birch Rd, Fresno'),
-- Organizers (31-45)
(31, 'Eventive', 'Productions', 'events@eventive.com', 'hash31', 'organizer', '2024-01-10', 1234567920, '100 Industry Blvd, Los Angeles'),
(32, 'Concerts', 'Unlimited', 'info@concertsunl.com', 'hash32', 'organizer', '2024-01-20', 1234567921, '200 Music Ln, Nashville'),
(33, 'Tech', 'Conferences', 'contact@techconf.com', 'hash33', 'organizer', '2024-02-05', 1234567922, '300 Silicon Ave, San Jose'),
(34, 'Sports', 'Mania', 'hello@sportsmania.com', 'hash34', 'organizer', '2024-02-18', 1234567923, '400 Stadium Dr, Chicago'),
(35, 'Art', 'Events', 'art@artevents.com', 'hash35', 'organizer', '2024-03-01', 1234567924, '500 Gallery Rd, New York'),
(36, 'Food', 'Fest', 'fest@foodfest.com', 'hash36', 'organizer', '2024-03-15', 1234567925, '600 Culinary St, San Francisco'),
(37, 'Comedy', 'Central', 'book@comedycentral.com', 'hash37', 'organizer', '2024-04-10', 1234567926, '700 Laugh Ln, Chicago'),
(38, 'Wellness', 'Retreats', 'info@wellnessretreats.com', 'hash38', 'organizer', '2024-05-05', 1234567927, '800 Zen Blvd, Sedona'),
(39, 'Gaming', 'Expo', 'expo@gamingexpo.com', 'hash39', 'organizer', '2024-06-01', 1234567928, '900 Arcade Ave, Las Vegas'),
(40, 'Fashion', 'Week', 'press@fashionweek.com', 'hash40', 'organizer', '2024-07-01', 1234567929, '1000 Runway Dr, New York'),
(41, 'Music', 'Fest', 'book@musicfest.com', 'hash41', 'organizer', '2024-08-01', 1234567930, '1100 Harmony Rd, Austin'),
(42, 'Startup', 'Summit', 'hello@startupsummit.com', 'hash42', 'organizer', '2024-09-01', 1234567931, '1200 Innovation Pkwy, San Francisco'),
(43, 'Charity', 'Gala', 'donate@charitygala.org', 'hash43', 'organizer', '2024-10-01', 1234567932, '1300 Generosity Way, Boston'),
(44, 'Film', 'Festival', 'film@filmfest.com', 'hash44', 'organizer', '2024-11-01', 1234567933, '1400 Cinema Blvd, Los Angeles'),
(45, 'Science', 'Fair', 'info@sciencefair.com', 'hash45', 'organizer', '2024-12-01', 1234567934, '1500 Discovery Dr, Seattle'),
-- Admins (46-50)
(46, 'Admin', 'One', 'admin1@system.com', 'hash46', 'admin', '2023-01-01', 1234567935, '1 Admin St, System'),
(47, 'Admin', 'Two', 'admin2@system.com', 'hash47', 'admin', '2023-02-01', 1234567936, '2 Admin St, System'),
(48, 'Admin', 'Three', 'admin3@system.com', 'hash48', 'admin', '2023-03-01', 1234567937, '3 Admin St, System'),
(49, 'Admin', 'Four', 'admin4@system.com', 'hash49', 'admin', '2023-04-01', 1234567938, '4 Admin St, System'),
(50, 'Admin', 'Five', 'admin5@system.com', 'hash50', 'admin', '2023-05-01', 1234567939, '5 Admin St, System');

-- ============================================================
-- 2. ATTENDEE (30 records)
-- ============================================================
INSERT INTO ATTENDEE (attendee_id, user_id)
SELECT user_id, user_id FROM [USER] WHERE role = 'attendee' AND user_id BETWEEN 1 AND 30;

-- ============================================================
-- 3. ORGANIZER (15 records)
-- ============================================================
INSERT INTO ORGANIZER (organizer_id, user_id, company_name, contact_person, contact_email)
SELECT user_id, user_id, 
       CASE user_id
           WHEN 31 THEN 'Eventive Productions'
           WHEN 32 THEN 'Concerts Unlimited'
           WHEN 33 THEN 'Tech Conferences'
           WHEN 34 THEN 'Sports Mania'
           WHEN 35 THEN 'Art Events'
           WHEN 36 THEN 'Food Fest'
           WHEN 37 THEN 'Comedy Central'
           WHEN 38 THEN 'Wellness Retreats'
           WHEN 39 THEN 'Gaming Expo'
           WHEN 40 THEN 'Fashion Week'
           WHEN 41 THEN 'Music Fest'
           WHEN 42 THEN 'Startup Summit'
           WHEN 43 THEN 'Charity Gala'
           WHEN 44 THEN 'Film Festival'
           WHEN 45 THEN 'Science Fair'
       END,
       CONCAT('Contact for ', first_name, ' ', last_name),
       email
FROM [USER] WHERE role = 'organizer' AND user_id BETWEEN 31 AND 45;

-- ============================================================
-- 4. VENUE (20 records)
-- ============================================================
INSERT INTO VENUE (venue_id, name, address, city, capacity, facilities)
VALUES
(1, 'Madison Square Garden', '4 Pennsylvania Plaza', 'New York', 20000, 'Parking, WiFi, Catering'),
(2, 'Staples Center', '1111 S Figueroa St', 'Los Angeles', 19000, 'Parking, WiFi, Disabled Access'),
(3, 'United Center', '1901 W Madison St', 'Chicago', 21000, 'Parking, WiFi'),
(4, 'Toyota Center', '1510 Polk St', 'Houston', 18000, 'Parking, Catering'),
(5, 'Footprint Center', '201 E Jefferson St', 'Phoenix', 17000, 'WiFi, Disabled Access'),
(6, 'Wells Fargo Center', '3601 S Broad St', 'Philadelphia', 19000, 'Parking, WiFi'),
(7, 'AT&T Center', '1 AT&T Center Pkwy', 'San Antonio', 18000, 'Parking'),
(8, 'Pechanga Arena', '3500 Sports Arena Blvd', 'San Diego', 14000, 'WiFi, Catering'),
(9, 'American Airlines Center', '2500 Victory Ave', 'Dallas', 20000, 'Parking, WiFi'),
(10, 'Moody Center', '2001 Robert Dedman Dr', 'Austin', 15000, 'WiFi, Disabled Access'),
(11, 'Nationwide Arena', '200 W Nationwide Blvd', 'Columbus', 19000, 'Parking, Catering'),
(12, 'Spectrum Center', '333 E Trade St', 'Charlotte', 19000, 'WiFi'),
(13, 'Little Caesars Arena', '2645 Woodward Ave', 'Detroit', 20000, 'Parking, WiFi'),
(14, 'Climate Pledge Arena', '334 1st Ave N', 'Seattle', 18000, 'WiFi, Disabled Access'),
(15, 'Ball Arena', '1000 Chopper Cir', 'Denver', 19000, 'Parking, WiFi'),
(16, 'Capital One Arena', '601 F St NW', 'Washington', 20000, 'WiFi, Catering'),
(17, 'TD Garden', '100 Legends Way', 'Boston', 19500, 'Parking, WiFi'),
(18, 'Bridgestone Arena', '501 Broadway', 'Nashville', 20000, 'WiFi, Disabled Access'),
(19, 'Moda Center', '1 N Center Ct St', 'Portland', 19000, 'Parking, WiFi'),
(20, 'T-Mobile Arena', '3780 S Las Vegas Blvd', 'Las Vegas', 20000, 'WiFi, Catering, Disabled Access');

-- ============================================================
-- 5. EVENT (45 records)
-- ============================================================
INSERT INTO EVENT (event_id, title, description, start_date_time, end_date_time, status, created_at, cancellation_policy, category_, image_url, organizer_id, venue_id)
VALUES
(1, 'Rock the Garden', 'Annual rock concert with top bands', '2025-06-15 19:00:00', '2025-06-15 23:00:00', 'active', '2025-01-10', 'Full refund 7 days before', 'Concert', 'rock.jpg', 31, 1),
(2, 'Tech Summit 2025', 'Leading technology conference', '2025-07-10 09:00:00', '2025-07-12 18:00:00', 'active', '2025-02-01', 'No refund after 30 days', 'Conference', 'tech.jpg', 33, 2),
(3, 'NBA All-Star Game', 'Basketball exhibition game', '2025-02-16 20:00:00', '2025-02-16 23:00:00', 'completed', '2024-11-01', 'No refunds', 'Sports', 'nba.jpg', 34, 3),
(4, 'Art Expo', 'Contemporary art exhibition', '2025-08-05 10:00:00', '2025-08-07 20:00:00', 'active', '2025-03-15', 'Full refund 14 days before', 'Art', 'art.jpg', 35, 4),
(5, 'Comedy Night', 'Stand-up comedy with famous comedians', '2025-09-20 20:00:00', '2025-09-20 23:00:00', 'active', '2025-04-01', 'No refunds', 'Comedy', 'comedy.jpg', 37, 5),
(6, 'Food Truck Festival', 'Taste from 50 food trucks', '2025-10-10 11:00:00', '2025-10-12 22:00:00', 'active', '2025-05-01', 'Full refund 7 days before', 'Food', 'food.jpg', 36, 6),
(7, 'Gaming Expo', 'Play new games, meet developers', '2025-11-05 10:00:00', '2025-11-07 18:00:00', 'active', '2025-06-01', 'No refunds', 'Gaming', 'gaming.jpg', 39, 7),
(8, 'Wellness Retreat', 'Yoga and meditation', '2025-12-01 09:00:00', '2025-12-03 17:00:00', 'active', '2025-07-01', 'Full refund 30 days before', 'Wellness', 'wellness.jpg', 38, 8),
(9, 'Fashion Week', 'Spring/Summer collections', '2026-01-15 19:00:00', '2026-01-18 23:00:00', 'active', '2025-08-01', 'No refunds', 'Fashion', 'fashion.jpg', 40, 9),
(10, 'Startup Pitch', 'Pitch your idea to investors', '2026-02-20 09:00:00', '2026-02-20 18:00:00', 'active', '2025-09-01', 'Full refund 14 days before', 'Business', 'startup.jpg', 42, 10),
(11, 'Jazz Festival', 'Smooth jazz performances', '2025-07-01 18:00:00', '2025-07-03 23:00:00', 'active', '2025-02-01', 'Full refund 7 days', 'Concert', 'jazz.jpg', 41, 11),
(12, 'AI Conference', 'Artificial Intelligence trends', '2025-08-20 09:00:00', '2025-08-22 18:00:00', 'active', '2025-03-01', 'No refunds', 'Conference', 'ai.jpg', 33, 12),
(13, 'Marathon', 'City marathon', '2025-10-05 06:00:00', '2025-10-05 14:00:00', 'active', '2025-04-01', 'No refunds', 'Sports', 'marathon.jpg', 34, 13),
(14, 'Charity Gala', 'Dinner and auction', '2025-11-15 19:00:00', '2025-11-15 23:00:00', 'active', '2025-05-01', 'No refunds', 'Charity', 'gala.jpg', 43, 14),
(15, 'Film Festival', 'Independent films', '2026-01-10 10:00:00', '2026-01-14 22:00:00', 'active', '2025-06-01', 'Full refund 14 days', 'Film', 'film.jpg', 44, 15),
(16, 'Science Fair', 'Student projects', '2026-02-25 09:00:00', '2026-02-26 17:00:00', 'active', '2025-07-01', 'No refunds', 'Science', 'science.jpg', 45, 16),
(17, 'Country Music Fest', 'Country stars', '2025-09-10 16:00:00', '2025-09-12 23:00:00', 'active', '2025-03-10', 'Full refund 7 days', 'Concert', 'country.jpg', 32, 17),
(18, 'Blockchain Summit', 'Cryptocurrency and NFTs', '2025-10-20 09:00:00', '2025-10-21 18:00:00', 'active', '2025-04-20', 'No refunds', 'Conference', 'blockchain.jpg', 33, 18),
(19, 'Soccer Match', 'Friendly match', '2025-11-10 20:00:00', '2025-11-10 22:00:00', 'active', '2025-05-10', 'No refunds', 'Sports', 'soccer.jpg', 34, 19),
(20, 'Craft Beer Fest', 'Local breweries', '2025-12-05 12:00:00', '2025-12-07 20:00:00', 'active', '2025-06-10', 'Full refund 7 days', 'Food', 'beer.jpg', 36, 20),
(21, 'EDM Night', 'Electronic dance music', '2026-03-01 21:00:00', '2026-03-01 04:00:00', 'active', '2025-08-01', 'No refunds', 'Concert', 'edm.jpg', 31, 1),
(22, 'Marketing Conference', 'Digital marketing trends', '2026-03-15 09:00:00', '2026-03-16 18:00:00', 'active', '2025-09-01', 'Full refund 30 days', 'Conference', 'marketing.jpg', 33, 2),
(23, 'Wrestling Show', 'Live wrestling', '2026-04-10 19:00:00', '2026-04-10 23:00:00', 'active', '2025-10-01', 'No refunds', 'Sports', 'wrestling.jpg', 34, 3),
(24, 'Painting Workshop', 'Learn to paint', '2026-05-05 10:00:00', '2026-05-05 16:00:00', 'active', '2025-11-01', 'Full refund 14 days', 'Art', 'painting.jpg', 35, 4),
(25, 'Open Mic Night', 'Local talents', '2026-06-01 20:00:00', '2026-06-01 23:00:00', 'active', '2025-12-01', 'No refunds', 'Comedy', 'openmic.jpg', 37, 5),
(26, 'BBQ Championship', 'Best ribs contest', '2026-07-04 11:00:00', '2026-07-04 19:00:00', 'active', '2026-01-01', 'Full refund 7 days', 'Food', 'bbq.jpg', 36, 6),
(27, 'Esports Tournament', 'League of Legends finals', '2026-08-20 10:00:00', '2026-08-22 20:00:00', 'active', '2026-02-01', 'No refunds', 'Gaming', 'esports.jpg', 39, 7),
(28, 'Yoga Marathon', '24-hour yoga', '2026-09-15 08:00:00', '2026-09-16 08:00:00', 'active', '2026-03-01', 'Full refund 30 days', 'Wellness', 'yoga.jpg', 38, 8),
(29, 'Fashion Show', 'Summer collection', '2026-10-10 20:00:00', '2026-10-10 22:00:00', 'active', '2026-04-01', 'No refunds', 'Fashion', 'fashionshow.jpg', 40, 9),
(30, 'Investor Day', 'Meet VCs', '2026-11-05 09:00:00', '2026-11-05 17:00:00', 'active', '2026-05-01', 'Full refund 14 days', 'Business', 'investor.jpg', 42, 10),
(31, 'Classical Concert', 'Symphony orchestra', '2026-12-10 19:30:00', '2026-12-10 22:00:00', 'active', '2026-06-01', 'No refunds', 'Concert', 'classical.jpg', 31, 11),
(32, 'DevOps Conference', 'CI/CD and cloud', '2025-09-25 09:00:00', '2025-09-26 18:00:00', 'active', '2025-03-25', 'Full refund 7 days', 'Conference', 'devops.jpg', 33, 12),
(33, 'Basketball Game', 'Local derby', '2025-10-15 19:00:00', '2025-10-15 22:00:00', 'active', '2025-04-15', 'No refunds', 'Sports', 'basketball.jpg', 34, 13),
(34, 'Sculpture Exhibition', 'Modern sculptures', '2025-11-20 10:00:00', '2025-11-22 18:00:00', 'active', '2025-05-20', 'Full refund 7 days', 'Art', 'sculpture.jpg', 35, 14),
(35, 'Stand-up Special', 'Headliner comedian', '2025-12-12 21:00:00', '2025-12-12 23:30:00', 'active', '2025-06-12', 'No refunds', 'Comedy', 'standup.jpg', 37, 15),
(36, 'Wine Tasting', 'Premium wines', '2026-01-20 18:00:00', '2026-01-20 21:00:00', 'active', '2025-07-20', 'Full refund 14 days', 'Food', 'wine.jpg', 36, 16),
(37, 'VR Experience', 'Virtual reality expo', '2026-02-10 10:00:00', '2026-02-12 18:00:00', 'active', '2025-08-10', 'No refunds', 'Gaming', 'vr.jpg', 39, 17),
(38, 'Meditation Retreat', 'Silent retreat', '2026-03-20 09:00:00', '2026-03-22 17:00:00', 'active', '2025-09-20', 'Full refund 30 days', 'Wellness', 'meditation.jpg', 38, 18),
(39, 'Fashion Expo', 'Designer booths', '2026-04-25 11:00:00', '2026-04-27 19:00:00', 'active', '2025-10-25', 'No refunds', 'Fashion', 'expo.jpg', 40, 19),
(40, 'Pitch Night', 'Startup competition', '2026-05-15 18:00:00', '2026-05-15 22:00:00', 'active', '2025-11-15', 'Full refund 7 days', 'Business', 'pitch.jpg', 42, 20),
(41, 'Rock Festival', 'Multiple bands', '2026-06-20 14:00:00', '2026-06-22 23:00:00', 'active', '2025-12-20', 'No refunds', 'Concert', 'rockfest.jpg', 32, 1),
(42, 'Data Science Summit', 'Big data and AI', '2026-07-25 09:00:00', '2026-07-26 18:00:00', 'active', '2026-01-25', 'Full refund 14 days', 'Conference', 'datascience.jpg', 33, 2),
(43, 'Tennis Open', 'Professional tournament', '2026-08-30 10:00:00', '2026-09-01 18:00:00', 'active', '2026-02-28', 'No refunds', 'Sports', 'tennis.jpg', 34, 3),
(44, 'Graffiti Art', 'Street art show', '2026-09-10 12:00:00', '2026-09-12 20:00:00', 'active', '2026-03-10', 'Full refund 7 days', 'Art', 'graffiti.jpg', 35, 4),
(45, 'Late Night Comedy', 'Midnight show', '2026-10-05 23:00:00', '2026-10-06 01:00:00', 'active', '2026-04-05', 'No refunds', 'Comedy', 'latenight.jpg', 37, 5),
(46, 'Tsoren em Tsane', 'Theatrical performance', '2026-04-30 19:30:00', '2026-04-30 21:30:00', 'upcoming', '2026-03-05', 'No refunds', 'Concert', 'masunq.jpg', 37, 1);

-- ============================================================
-- 6. TICKETTYPE (3 per event = 135 records) using a loop
-- ============================================================
DECLARE @i INT = 1
DECLARE @j INT
WHILE @i <= 45
BEGIN
    SET @j = 1
    WHILE @j <= 3
    BEGIN
        INSERT INTO TICKETTYPE (ticket_type_id, name, price, quantity_total_, description, sales_start_date, sales_end_date, event_id)
        VALUES (
            (@i-1)*3 + @j,
            CASE @j
                WHEN 1 THEN 'General Admission'
                WHEN 2 THEN 'VIP'
                ELSE 'Early Bird'
            END,
            CASE 
                WHEN @j = 1 THEN 50
                WHEN @j = 2 THEN 150
                ELSE 40
            END,
            500 + (@i * 10),
            CASE @j
                WHEN 1 THEN 'Standard entry'
                WHEN 2 THEN 'VIP lounge access'
                ELSE 'Discounted early purchase'
            END,
            DATEADD(day, -30, GETDATE()),
            DATEADD(day, 60, GETDATE()),
            @i
        )
        SET @j = @j + 1
    END
    SET @i = @i + 1
END

-- ============================================================
-- 7. ORDERS (50 records)
-- ============================================================
INSERT INTO ORDERS (order_id, order_date, status_, attendee_id)
VALUES
(1, '2025-06-01', 'paid', 1),
(2, '2025-06-05', 'paid', 2),
(3, '2025-06-10', 'pending', 3),
(4, '2025-07-01', 'paid', 4),
(5, '2025-07-15', 'cancelled', 5),
(6, '2025-08-01', 'paid', 6),
(7, '2025-08-20', 'refunded', 7),
(8, '2025-09-01', 'paid', 8),
(9, '2025-09-10', 'pending', 9),
(10, '2025-10-01', 'paid', 10),
(11, '2025-10-15', 'paid', 11),
(12, '2025-11-01', 'cancelled', 12),
(13, '2025-11-20', 'paid', 13),
(14, '2025-12-01', 'paid', 14),
(15, '2025-12-15', 'refunded', 15),
(16, '2026-01-01', 'paid', 16),
(17, '2026-01-10', 'pending', 17),
(18, '2026-02-01', 'paid', 18),
(19, '2026-02-15', 'paid', 19),
(20, '2026-03-01', 'cancelled', 20),
(21, '2026-03-10', 'paid', 21),
(22, '2026-04-01', 'paid', 22),
(23, '2026-04-15', 'refunded', 23),
(24, '2026-05-01', 'paid', 24),
(25, '2026-05-20', 'pending', 25),
(26, '2026-06-01', 'paid', 26),
(27, '2026-06-10', 'paid', 27),
(28, '2026-07-01', 'cancelled', 28),
(29, '2026-07-15', 'paid', 29),
(30, '2026-08-01', 'paid', 30),
(31, '2026-08-10', 'pending', 1),
(32, '2026-09-01', 'paid', 2),
(33, '2026-09-15', 'paid', 3),
(34, '2026-10-01', 'refunded', 4),
(35, '2026-10-10', 'paid', 5),
(36, '2026-11-01', 'paid', 6),
(37, '2026-11-15', 'cancelled', 7),
(38, '2026-12-01', 'paid', 8),
(39, '2026-12-10', 'pending', 9),
(40, '2026-12-20', 'paid', 10),
(41, '2026-01-20', 'paid', 11),
(42, '2026-02-20', 'paid', 12),
(43, '2026-03-20', 'cancelled', 13),
(44, '2026-04-20', 'paid', 14),
(45, '2026-05-20', 'refunded', 15),
(46, '2026-06-20', 'paid', 16),
(47, '2026-07-20', 'pending', 17),
(48, '2026-08-20', 'paid', 18),
(49, '2026-09-20', 'paid', 19),
(50, '2026-10-20', 'paid', 20);

-- ============================================================
-- 8. ORDERITEM (each order has 1-3 items) using a loop
-- ============================================================
DECLARE @ord INT = 1
DECLARE @item_id INT = 1
WHILE @ord <= 50
BEGIN
    DECLARE @num INT = 1 + CAST(RAND() * 2 AS INT)   -- 1 to 3 items
    DECLARE @k INT = 1
    WHILE @k <= @num
    BEGIN
        DECLARE @tt_id INT = ((@ord + @k) % 135) + 1
        DECLARE @qty INT = 1 + CAST(RAND() * 4 AS INT)
        DECLARE @price INT = CASE WHEN @tt_id % 3 = 1 THEN 50 WHEN @tt_id % 3 = 2 THEN 150 ELSE 40 END
        INSERT INTO ORDERITEM (order_item_id, order_id, ticket_type_id, quantity, price_at_purchase)
        VALUES (@item_id, @ord, @tt_id, @qty, @price)
        SET @item_id = @item_id + 1
        SET @k = @k + 1
    END
    SET @ord = @ord + 1
END

-- ============================================================
-- 9. TICKET (one per quantity in each order item) using loop
-- ============================================================
ALTER TABLE TICKET ALTER COLUMN unique_code_ VARCHAR(50) NOT NULL;
GO

DECLARE @oi_id INT = 1
DECLARE @max_oi INT
SELECT @max_oi = MAX(order_item_id) FROM ORDERITEM
DECLARE @ticket_id INT = 1
WHILE @oi_id <= @max_oi
BEGIN
    DECLARE @qt INT
    SELECT @qt = quantity FROM ORDERITEM WHERE order_item_id = @oi_id
    DECLARE @ct INT = 1
    WHILE @ct <= @qt
    BEGIN
        INSERT INTO TICKET (ticket_id, unique_code_, issued_date, status_, attendee_first_name_, attendee_last_name_, seat_number, order_item_id)
        VALUES (
            @ticket_id,
            CONCAT('T', RIGHT('000000' + CAST(ABS(CHECKSUM(NEWID())) AS VARCHAR), 6)),
            DATEADD(day, -ABS(CHECKSUM(NEWID()) % 30), GETDATE()),
            'valid',
            CONCAT('Attendee', @oi_id),
            CONCAT('Last', @oi_id),
            @oi_id * 100 + @ct,
            @oi_id
        )
        SET @ticket_id = @ticket_id + 1
        SET @ct = @ct + 1
    END
    SET @oi_id = @oi_id + 1
END

-- ============================================================
-- 10. PAYMENT (only for paid orders)
-- ============================================================
INSERT INTO PAYMENT (payment_id, amount, payment_date, transaction_id_, status, payment_method_, order_id)
SELECT 
    order_id,
    (SELECT SUM(price_at_purchase * quantity) FROM ORDERITEM WHERE order_id = o.order_id),
    order_date,
    CONCAT('TXN', order_id, RIGHT(CAST(ABS(CHECKSUM(NEWID())) AS VARCHAR), 6)),
    'success',
    CASE order_id % 3 WHEN 0 THEN 'Credit Card' WHEN 1 THEN 'PayPal' ELSE 'Bank Transfer' END,
    order_id
FROM ORDERS o
WHERE status_ = 'paid'

-- ============================================================
-- Verify row counts (each should be >=40)
-- ============================================================
SELECT 'USER' AS TableName, COUNT(*) AS Rows FROM [USER]
UNION SELECT 'ATTENDEE', COUNT(*) FROM ATTENDEE
UNION SELECT 'ORGANIZER', COUNT(*) FROM ORGANIZER
UNION SELECT 'VENUE', COUNT(*) FROM VENUE
UNION SELECT 'EVENT', COUNT(*) FROM EVENT
UNION SELECT 'TICKETTYPE', COUNT(*) FROM TICKETTYPE
UNION SELECT 'ORDERS', COUNT(*) FROM ORDERS
UNION SELECT 'ORDERITEM', COUNT(*) FROM ORDERITEM
UNION SELECT 'TICKET', COUNT(*) FROM TICKET
UNION SELECT 'PAYMENT', COUNT(*) FROM PAYMENT
GO