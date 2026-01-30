-- EventPass Database Schema
-- Run this script in phpMyAdmin to create the database structure

-- Create database if not exists
CREATE DATABASE IF NOT EXISTS eventpass_db;
USE eventpass_db;

-- Drop existing tables if they exist (in correct order due to foreign keys)
DROP TABLE IF EXISTS tickets;
DROP TABLE IF EXISTS events;
DROP TABLE IF EXISTS users;

-- Users Table
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    role ENUM('ATTENDEE', 'ORGANIZER') NOT NULL DEFAULT 'ATTENDEE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Events Table
CREATE TABLE events (
    id INT AUTO_INCREMENT PRIMARY KEY,
    event_name VARCHAR(200) NOT NULL,
    event_date DATE NOT NULL,
    event_time TIME,
    venue VARCHAR(200) NOT NULL,
    description TEXT,
    regular_price DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    vip_price DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    vvip_price DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    capacity INT NOT NULL DEFAULT 100,
    available_tickets INT NOT NULL DEFAULT 100,
    organizer_id INT NOT NULL,
    status ENUM('ACTIVE', 'CANCELLED', 'COMPLETED') NOT NULL DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (organizer_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Tickets Table
CREATE TABLE tickets (
    id INT AUTO_INCREMENT PRIMARY KEY,
    ticket_code VARCHAR(20) NOT NULL UNIQUE,
    user_id INT NOT NULL,
    event_id INT NOT NULL,
    ticket_type ENUM('REGULAR', 'VIP', 'VVIP') NOT NULL DEFAULT 'REGULAR',
    quantity INT NOT NULL DEFAULT 1,
    unit_price DECIMAL(10, 2) NOT NULL,
    total_price DECIMAL(10, 2) NOT NULL,
    booking_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('PENDING', 'VERIFIED', 'CANCELLED') NOT NULL DEFAULT 'PENDING',
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (event_id) REFERENCES events(id) ON DELETE CASCADE
);

-- Insert default users
INSERT INTO users (username, password, full_name, email, role) VALUES
('john', 'password123', 'John Smith', 'john.smith@email.com', 'ATTENDEE'),
('sarah', 'password123', 'Sarah Johnson', 'sarah.j@email.com', 'ATTENDEE'),
('mike', 'password123', 'Mike Williams', 'mike.w@email.com', 'ATTENDEE'),
('admin', 'admin123', 'Event Admin', 'admin@eventpass.com', 'ORGANIZER'),
('organizer', 'org123', 'Jane Organizer', 'jane.org@eventpass.com', 'ORGANIZER');

-- Insert sample events (created by admin, id=4)
INSERT INTO events (event_name, event_date, event_time, venue, description, regular_price, vip_price, vvip_price, capacity, available_tickets, organizer_id) VALUES
('Tech Conference 2026', '2026-02-15', '09:00:00', 'Convention Center Hall A', 'Annual technology conference featuring the latest innovations', 50.00, 100.00, 200.00, 500, 500, 4),
('Music Festival', '2026-03-20', '14:00:00', 'City Park Amphitheater', 'A day of amazing live music performances', 75.00, 150.00, 300.00, 1000, 1000, 4),
('Business Summit', '2026-04-10', '08:30:00', 'Grand Hotel Ballroom', 'Network with industry leaders and entrepreneurs', 100.00, 200.00, 400.00, 300, 300, 4),
('Art Exhibition Opening', '2026-01-25', '18:00:00', 'Modern Art Gallery', 'Exclusive opening night for contemporary art exhibition', 25.00, 50.00, 100.00, 200, 200, 5);

-- Create indexes for better performance
CREATE INDEX idx_tickets_user ON tickets(user_id);
CREATE INDEX idx_tickets_event ON tickets(event_id);
CREATE INDEX idx_events_organizer ON events(organizer_id);
CREATE INDEX idx_tickets_status ON tickets(status);
