<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.eventpass.model.User" %>
<%@ page import="com.eventpass.model.Event" %>
<%@ page import="java.util.List" %>
<%@ page import="java.math.BigDecimal" %>
<%
    User user = (User) session.getAttribute("user");
    
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    if (!user.isOrganizer()) {
        response.sendRedirect(request.getContextPath() + "/booking.jsp");
        return;
    }
    
    List<Event> events = (List<Event>) request.getAttribute("events");
    Integer totalEvents = (Integer) request.getAttribute("totalEvents");
    Integer totalTicketsSold = (Integer) request.getAttribute("totalTicketsSold");
    BigDecimal totalRevenue = (BigDecimal) request.getAttribute("totalRevenue");
    
    if (totalEvents == null) totalEvents = 0;
    if (totalTicketsSold == null) totalTicketsSold = 0;
    if (totalRevenue == null) totalRevenue = BigDecimal.ZERO;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Organizer Dashboard - EventPass</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
    <nav class="navbar">
        <div class="nav-brand">
            <a href="<%= request.getContextPath() %>/index.jsp">
                <div class="logo-icon"><i class="fas fa-ticket-alt"></i></div>
                <span class="logo-text">EventPass</span>
            </a>
        </div>
        <div class="nav-links">
            <a href="<%= request.getContextPath() %>/organizer" class="active">
                <i class="fas fa-chart-line"></i> Dashboard
            </a>
            <a href="<%= request.getContextPath() %>/events">
                <i class="fas fa-calendar-alt"></i> My Events
            </a>
            <a href="<%= request.getContextPath() %>/events?action=new">
                <i class="fas fa-plus"></i> Create Event
            </a>
        </div>
        <div class="nav-user">
            <div class="user-info">
                <div class="user-avatar"><%= user.getFullName().substring(0, 1).toUpperCase() %></div>
                <span class="user-greeting"><%= user.getFullName() %></span>
            </div>
            <span class="role-badge organizer">ORGANIZER</span>
            <a href="<%= request.getContextPath() %>/logout" class="btn btn-outline btn-sm">
                <i class="fas fa-sign-out-alt"></i> Logout
            </a>
        </div>
    </nav>

    <div class="booking-container">
        <div class="page-header">
            <div>
                <h1><i class="fas fa-chart-line"></i> Organizer Dashboard</h1>
                <p>Manage your events and track performance</p>
            </div>
        </div>
        
        <div class="stats-grid dashboard-stats">
            <div class="stat-card">
                <div class="stat-icon"><i class="fas fa-calendar-alt"></i></div>
                <div class="stat-content">
                    <div class="stat-number"><%= totalEvents %></div>
                    <div class="stat-label">Total Events</div>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon"><i class="fas fa-ticket-alt"></i></div>
                <div class="stat-content">
                    <div class="stat-number"><%= totalTicketsSold %></div>
                    <div class="stat-label">Tickets Sold</div>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon"><i class="fas fa-dollar-sign"></i></div>
                <div class="stat-content">
                    <div class="stat-number">$<%= totalRevenue %></div>
                    <div class="stat-label">Total Revenue</div>
                </div>
            </div>
        </div>
        
        <div class="quick-actions">
            <h3><i class="fas fa-bolt"></i> Quick Actions</h3>
            <div class="actions-grid">
                <a href="<%= request.getContextPath() %>/events?action=new" class="action-card">
                    <span class="action-icon"><i class="fas fa-plus"></i></span>
                    <span class="action-label">Create Event</span>
                </a>
                <a href="<%= request.getContextPath() %>/events" class="action-card">
                    <span class="action-icon"><i class="fas fa-list"></i></span>
                    <span class="action-label">Manage Events</span>
                </a>
                <a href="<%= request.getContextPath() %>/profile" class="action-card">
                    <span class="action-icon"><i class="fas fa-user-cog"></i></span>
                    <span class="action-label">My Profile</span>
                </a>
            </div>
        </div>
        
        <% if (events != null && !events.isEmpty()) { %>
        <div class="recent-events">
            <h3><i class="fas fa-calendar"></i> Your Events</h3>
            <div class="events-table-wrapper">
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>Event Name</th>
                            <th>Date</th>
                            <th>Venue</th>
                            <th>Tickets</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Event event : events) { %>
                        <tr>
                            <td><strong><%= event.getEventName() %></strong></td>
                            <td><%= event.getFormattedDate() %></td>
                            <td><%= event.getVenue() %></td>
                            <td><%= event.getCapacity() - event.getAvailableTickets() %>/<%= event.getCapacity() %></td>
                            <td>
                                <a href="<%= request.getContextPath() %>/event-attendees?eventId=<%= event.getId() %>" 
                                   class="btn btn-sm btn-outline">
                                   <i class="fas fa-users"></i> Attendees
                                </a>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
        <% } %>
    </div>
</body>
</html>
