<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.eventpass.model.User" %>
<%@ page import="com.eventpass.model.UserDatabase" %>
<%@ page import="java.util.Map" %>
<%
    // Check if user is logged in
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    // Get error message if any
    String error = (String) request.getAttribute("error");
    
    // Get available events
    Map<String, String[]> events = UserDatabase.getEvents();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Book Tickets - EventPass</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <!-- Navigation Bar -->
    <nav class="navbar">
        <div class="nav-brand">
            <span class="logo-icon">🎫</span>
            <span class="logo-text">EventPass</span>
        </div>
        <div class="nav-user">
            <span class="user-greeting">Hello, <strong><%= user.getFullName() %></strong></span>
            <span class="role-badge <%= user.isAttendee() ? "attendee" : "organizer" %>">
                <%= user.getRole() %>
            </span>
            <a href="logout" class="btn btn-outline btn-sm">Logout</a>
        </div>
    </nav>

    <div class="booking-container">
        <div class="page-header">
            <h1>🎪 Book Your Event</h1>
            <p>Select an event below to book your ticket</p>
        </div>
        
        <% if (error != null) { %>
            <div class="alert alert-error">
                <span class="alert-icon">⚠</span>
                <%= error %>
            </div>
        <% } %>
        
        <form action="booking" method="post" class="booking-form">
            <div class="events-grid">
                <% for (Map.Entry<String, String[]> event : events.entrySet()) { 
                    String eventId = event.getKey();
                    String[] details = event.getValue();
                %>
                <label class="event-card">
                    <input type="radio" name="eventId" value="<%= eventId %>" required>
                    <div class="event-content">
                        <div class="event-icon">🎭</div>
                        <h3 class="event-name"><%= details[0] %></h3>
                        <div class="event-details">
                            <div class="event-detail">
                                <span class="detail-icon">📅</span>
                                <span><%= details[1] %></span>
                            </div>
                            <div class="event-detail">
                                <span class="detail-icon">📍</span>
                                <span><%= details[2] %></span>
                            </div>
                        </div>
                        <div class="event-select-indicator">
                            <span class="checkmark">✓</span>
                            <span>Selected</span>
                        </div>
                    </div>
                </label>
                <% } %>
            </div>
            
            <div class="booking-summary">
                <div class="summary-info">
                    <h4>Booking Details</h4>
                    <p><strong>Attendee:</strong> <%= user.getFullName() %></p>
                    <p><strong>Email:</strong> <%= user.getEmail() %></p>
                </div>
                <button type="submit" class="btn btn-primary btn-large">
                    <span>Book Ticket</span>
                    <span class="btn-arrow">→</span>
                </button>
            </div>
        </form>
        
        <div class="collaboration-note">
            <h5>📚 Servlet Collaboration Demo</h5>
            <p>When you click "Book Ticket", the <code>BookingServlet</code> will:</p>
            <ol>
                <li>Create a Ticket object with your booking details</li>
                <li>Use <code>request.setAttribute()</code> to store the ticket</li>
                <li>Use <code>RequestDispatcher.forward()</code> to pass to VerificationServlet</li>
            </ol>
            <p><strong>Notice:</strong> The URL will stay as <code>/booking</code> after submission!</p>
        </div>
    </div>
</body>
</html>
