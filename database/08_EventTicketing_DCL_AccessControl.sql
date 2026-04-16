USE EventTicketing;
GO

-- ============================================================
-- DCL: CREATE LOGINS AND DATABASE USERS (with existence checks)
-- ============================================================

-- Create server logins (if not exist)
IF NOT EXISTS (SELECT name FROM sys.server_principals WHERE name = 'attendee_app')
    CREATE LOGIN attendee_app WITH PASSWORD = 'AttendeePass123!';
IF NOT EXISTS (SELECT name FROM sys.server_principals WHERE name = 'organizer_app')
    CREATE LOGIN organizer_app WITH PASSWORD = 'OrganizerPass123!';
IF NOT EXISTS (SELECT name FROM sys.server_principals WHERE name = 'admin_user')
    CREATE LOGIN admin_user WITH PASSWORD = 'AdminPass123!';
GO

-- Create database users (if not exist)
IF NOT EXISTS (SELECT name FROM sys.database_principals WHERE name = 'attendee_app')
    CREATE USER attendee_app FOR LOGIN attendee_app;
IF NOT EXISTS (SELECT name FROM sys.database_principals WHERE name = 'organizer_app')
    CREATE USER organizer_app FOR LOGIN organizer_app;
IF NOT EXISTS (SELECT name FROM sys.database_principals WHERE name = 'admin_user')
    CREATE USER admin_user FOR LOGIN admin_user;
GO

-- ============================================================
-- GRANT PERMISSIONS (use GRANT, which is idempotent)
-- ============================================================
GRANT SELECT ON [User] TO attendee_app;
GRANT SELECT ON Event TO attendee_app;
GRANT SELECT ON Venue TO attendee_app;
GRANT SELECT ON TicketType TO attendee_app;
GRANT SELECT ON Attendee TO attendee_app;
GRANT SELECT ON Orders TO attendee_app;
GRANT SELECT ON OrderItem TO attendee_app;
GRANT SELECT ON Ticket TO attendee_app;

GRANT INSERT ON Orders TO attendee_app;
GRANT INSERT ON OrderItem TO attendee_app;
GRANT INSERT ON Ticket TO attendee_app;
GRANT INSERT ON Payment TO attendee_app;

GRANT EXECUTE ON usp_RegisterUser TO attendee_app;
GRANT EXECUTE ON usp_PurchaseTickets TO attendee_app;
GRANT EXECUTE ON usp_GetAvailableTickets TO attendee_app;
GRANT EXECUTE ON usp_CancelOrder TO attendee_app;

DENY UPDATE, DELETE ON Payment TO attendee_app;
DENY UPDATE, DELETE ON [User] TO attendee_app;

-- Organizer permissions
GRANT SELECT, INSERT, UPDATE ON Event TO organizer_app;
GRANT SELECT, INSERT, UPDATE ON TicketType TO organizer_app;
GRANT SELECT ON Venue TO organizer_app;
GRANT SELECT ON Orders TO organizer_app;
GRANT SELECT ON OrderItem TO organizer_app;
GRANT SELECT ON Ticket TO organizer_app;
GRANT SELECT ON Payment TO organizer_app;

GRANT EXECUTE ON usp_GenerateOrganizerReport TO organizer_app;
GRANT EXECUTE ON usp_CreateEvent TO organizer_app;
GRANT EXECUTE ON usp_UpdateEventStatus TO organizer_app;

DENY SELECT ON [User] TO organizer_app;
DENY SELECT ON Attendee TO organizer_app;

-- Admin permissions (full control)
GRANT CONTROL ON DATABASE::EventTicketing TO admin_user;

-- Revoke delete on sensitive tables from non-admin
REVOKE DELETE ON Payment FROM attendee_app;
REVOKE DELETE ON Payment FROM organizer_app;

PRINT 'Access control (DCL) applied successfully.';
GO