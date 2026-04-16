-- Drop database if it already exists
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'EventTicketing')
    DROP DATABASE EventTicketing;
GO

-- Create new database
CREATE DATABASE EventTicketing;
GO

-- Use the new database
USE EventTicketing;
GO

-- USER table
CREATE TABLE [USER] (
    user_id INT NOT NULL,
    first_name VARCHAR(30) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(30) NOT NULL,
    password_hash VARCHAR(30) NOT NULL,
    role VARCHAR(20) NOT NULL,
    registration_date DATE NOT NULL,
    phone_ INT,
    address_ VARCHAR(50),
    CONSTRAINT PK_USER PRIMARY KEY (user_id),
    CONSTRAINT UQ_USER_EMAIL UNIQUE (email)
);

-- ORGANIZER (fixed duplicate user_id column)
CREATE TABLE ORGANIZER (
    organizer_id INT NOT NULL,
    user_id INT NOT NULL,
    company_name VARCHAR(30),
    contact_person VARCHAR(50),
    contact_email VARCHAR(30),
    CONSTRAINT PK_ORGANIZER PRIMARY KEY (organizer_id),
    CONSTRAINT FK_ORGANIZER_USER FOREIGN KEY (user_id) REFERENCES [USER](user_id)
);

-- VENUE
CREATE TABLE VENUE (
    venue_id INT NOT NULL,
    name VARCHAR(50) NOT NULL,
    address VARCHAR(100) NOT NULL,
    city VARCHAR(30) NOT NULL,
    capacity INT NOT NULL,
    facilities VARCHAR(100),
    CONSTRAINT PK_VENUE PRIMARY KEY (venue_id),
    CONSTRAINT UQ_VENUE_ADDRESS_CITY UNIQUE (address, city)
);

-- EVENT
CREATE TABLE EVENT (
    event_id INT NOT NULL,
    title VARCHAR(50) NOT NULL,
    description VARCHAR(500),
    start_date_time DATE NOT NULL,
    end_date_time DATE NOT NULL,
    status VARCHAR(20) NOT NULL,
    created_at DATE NOT NULL,
    cancellation_policy VARCHAR(100),
    category_ VARCHAR(50),
    image_url VARCHAR(100),
    organizer_id INT NOT NULL,
    venue_id INT NOT NULL,
    CONSTRAINT PK_EVENT PRIMARY KEY (event_id),
    CONSTRAINT FK_EVENT_ORGANIZER FOREIGN KEY (organizer_id) REFERENCES ORGANIZER(organizer_id),
    CONSTRAINT FK_EVENT_VENUE FOREIGN KEY (venue_id) REFERENCES VENUE(venue_id)
);

-- ATTENDEE
CREATE TABLE ATTENDEE (
    attendee_id INT NOT NULL,
    user_id INT NOT NULL,
    CONSTRAINT PK_ATTENDEE PRIMARY KEY (attendee_id),
    CONSTRAINT FK_ATTENDEE_USER FOREIGN KEY (user_id) REFERENCES [USER](user_id)
);

-- TICKETTYPE
CREATE TABLE TICKETTYPE (
    ticket_type_id INT NOT NULL,
    name VARCHAR(50) NOT NULL,
    price INT NOT NULL,
    quantity_total_ INT NOT NULL,
    description VARCHAR(200),
    sales_start_date DATE,
    sales_end_date DATE,
    event_id INT NOT NULL,
    CONSTRAINT PK_TICKETTYPE PRIMARY KEY (ticket_type_id),
    CONSTRAINT FK_TICKETTYPE_EVENT FOREIGN KEY (event_id) REFERENCES EVENT(event_id),
    CONSTRAINT UQ_TICKETTYPE_NAME_EVENT UNIQUE (name, event_id)
);

-- ORDER (renamed to ORDERS because ORDER is a reserved keyword)
CREATE TABLE ORDERS (
    order_id INT NOT NULL,
    order_date DATE NOT NULL,
    status_ VARCHAR(20) NOT NULL,
    attendee_id INT NOT NULL,
    CONSTRAINT PK_ORDERS PRIMARY KEY (order_id),
    CONSTRAINT FK_ORDERS_ATTENDEE FOREIGN KEY (attendee_id) REFERENCES ATTENDEE(attendee_id)
);

-- ORDERITEM (fixed duplicate columns)
CREATE TABLE ORDERITEM (
    order_item_id INT NOT NULL,
    order_id INT NOT NULL,
    ticket_type_id INT NOT NULL,
    quantity INT NOT NULL,
    price_at_purchase INT NOT NULL,
    CONSTRAINT PK_ORDERITEM PRIMARY KEY (order_item_id),
    CONSTRAINT FK_ORDERITEM_ORDER FOREIGN KEY (order_id) REFERENCES ORDERS(order_id),
    CONSTRAINT FK_ORDERITEM_TICKETTYPE FOREIGN KEY (ticket_type_id) REFERENCES TICKETTYPE(ticket_type_id),
    CONSTRAINT UQ_ORDERITEM_ORDER_TICKET UNIQUE (order_id, ticket_type_id)
);

-- TICKET
CREATE TABLE TICKET (
    ticket_id INT NOT NULL,
    unique_code_ VARCHAR(50) NOT NULL,
    issued_date DATE NOT NULL,
    status_ VARCHAR(20) NOT NULL,
    attendee_first_name_ VARCHAR(30),
    attendee_last_name_ VARCHAR(30),
    seat_number INT,
    order_item_id INT NOT NULL,
    CONSTRAINT PK_TICKET PRIMARY KEY (ticket_id),
    CONSTRAINT FK_TICKET_ORDERITEM FOREIGN KEY (order_item_id) REFERENCES ORDERITEM(order_item_id),
    CONSTRAINT UQ_TICKET_UNIQUE_CODE UNIQUE (unique_code_),
    CONSTRAINT UQ_TICKET_SEAT UNIQUE (seat_number)
);

-- PAYMENT
CREATE TABLE PAYMENT (
    payment_id INT NOT NULL,
    amount INT NOT NULL,
    payment_date DATE NOT NULL,
    transaction_id_ VARCHAR(100) NOT NULL,
    status VARCHAR(20) NOT NULL,
    payment_method_ VARCHAR(30) NOT NULL,
    order_id INT NOT NULL,
    CONSTRAINT PK_PAYMENT PRIMARY KEY (payment_id),
    CONSTRAINT FK_PAYMENT_ORDER FOREIGN KEY (order_id) REFERENCES ORDERS(order_id),
    CONSTRAINT UQ_PAYMENT_TRANSACTION UNIQUE (transaction_id_),
    CONSTRAINT UQ_PAYMENT_ORDER UNIQUE (order_id)
);

PRINT 'Database created successfully!';
GO