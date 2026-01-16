<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.eventpass.model.User" %>
<%@ page import="com.eventpass.model.Ticket" %>
<%
    User user = (User) session.getAttribute("user");
    
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    Ticket ticket = (Ticket) session.getAttribute("lastBookedTicket");
    String successMessage = (String) request.getAttribute("successMessage");
    String errorMessage = (String) request.getAttribute("error");
    
    Integer userVisits = (Integer) session.getAttribute("userVisits");
    if (userVisits == null) userVisits = 0;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - EventPass</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
    <nav class="navbar">
        <div class="nav-brand">
            <a href="<%= request.getContextPath() %>/index.jsp" style="text-decoration: none; display: flex; align-items: center; gap: 0.5rem;">
                <span class="logo-icon">🎫</span>
                <span class="logo-text">EventPass</span>
            </a>
        </div>
        <div class="nav-user">
            <span class="user-greeting">Hello, <strong><%= user.getFullName() %></strong></span>
            <span class="role-badge <%= user.isAttendee() ? "attendee" : "organizer" %>">
                <%= user.getRole() %>
            </span>
            <a href="<%= request.getContextPath() %>/logout" class="btn btn-outline btn-sm">Logout</a>
        </div>
    </nav>

    <div class="booking-container">
        <div class="page-header">
            <h1>🎯 Your Dashboard</h1>
            <p>View your bookings and account information</p>
        </div>
        
        <% if (successMessage != null) { %>
            <div class="alert alert-success">
                <span class="alert-icon">✓</span>
                <%= successMessage %>
            </div>
        <% } %>
        
        <% if (errorMessage != null) { %>
            <div class="alert alert-error">
                <span class="alert-icon">⚠</span>
                <%= errorMessage %>
            </div>
        <% } %>
        
        <div class="dashboard-grid">
            <div class="dashboard-card user-info-card">
                <div class="card-header">
                    <h3>👤 Account Information</h3>
                </div>
                <div class="card-body">
                    <div class="info-row">
                        <span class="info-label">Full Name:</span>
                        <span class="info-value"><%= user.getFullName() %></span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Username:</span>
                        <span class="info-value"><%= user.getUsername() %></span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Email:</span>
                        <span class="info-value"><%= user.getEmail() %></span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Role:</span>
                        <span class="role-badge <%= user.isAttendee() ? "attendee" : "organizer" %>">
                            <%= user.getRole() %>
                        </span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Page Visits:</span>
                        <span class="info-value"><%= userVisits %> visits this session</span>
                    </div>
                </div>
            </div>
            
            <div class="dashboard-card booking-card">
                <div class="card-header">
                    <h3>🎫 Latest Booking</h3>
                </div>
                <div class="card-body">
                    <% if (ticket != null) { %>
                        <div class="ticket-display">
                            <div class="ticket-header">
                                <span class="ticket-icon">🎭</span>
                                <h4><%= ticket.getEventName() %></h4>
                            </div>
                            <div class="ticket-details">
                                <div class="ticket-row">
                                    <span class="ticket-label">📅 Date:</span>
                                    <span class="ticket-value"><%= ticket.getEventDate() %></span>
                                </div>
                                <div class="ticket-row">
                                    <span class="ticket-label">📍 Venue:</span>
                                    <span class="ticket-value"><%= ticket.getEventVenue() %></span>
                                </div>
                                <div class="ticket-row">
                                    <span class="ticket-label">🎟️ Ticket ID:</span>
                                    <code class="ticket-value"><%= ticket.getTicketId() %></code>
                                </div>
                                <div class="ticket-row">
                                    <span class="ticket-label">👤 Attendee:</span>
                                    <span class="ticket-value"><%= ticket.getAttendeeName() %></span>
                                </div>
                            </div>
                            <div class="ticket-status">
                                <span class="status-badge confirmed">✓ Confirmed</span>
                            </div>
                        </div>
                    <% } else { %>
                        <div class="no-bookings">
                            <div class="no-bookings-icon">🎪</div>
                            <p>You haven't booked any events yet.</p>
                            <a href="<%= request.getContextPath() %>/booking.jsp" class="btn btn-primary">
                                <span>Browse Events</span>
                                <span class="btn-arrow">→</span>
                            </a>
                        </div>
                    <% } %>
                </div>
            </div>
        </div>
        
        <div class="quick-actions">
            <h3>⚡ Quick Actions</h3>
            <div class="actions-grid">
                <a href="<%= request.getContextPath() %>/booking.jsp" class="action-card">
                    <span class="action-icon">🎪</span>
                    <span class="action-label">Book New Event</span>
                </a>
                <a href="<%= request.getContextPath() %>/index.jsp" class="action-card">
                    <span class="action-icon">🏠</span>
                    <span class="action-label">Home Page</span>
                </a>
                <a href="<%= request.getContextPath() %>/logout" class="action-card">
                    <span class="action-icon">🚪</span>
                    <span class="action-label">Logout</span>
                </a>
            </div>
        </div>
        
        <div class="collaboration-note">
            <h5>📚 JSP Implicit Objects Used on This Page</h5>
            <ul class="implicit-objects-list">
                <li><code>session</code> - Retrieves logged-in user and booked ticket data</li>
                <li><code>request</code> - Gets success/error messages and context path</li>
                <li><code>response</code> - Redirects unauthorized users to login page</li>
            </ul>
            <p style="margin-top: 1rem;"><strong>Session ID:</strong> <code><%= session.getId().substring(0, 16) %>...</code></p>
        </div>
    </div>
</body>
</html>
