<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.eventpass.model.User" %>
<%@ page import="com.eventpass.model.Event" %>
<%@ page import="java.util.List" %>
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
    String success = request.getParameter("success");
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Events - EventPass</title>
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
            <a href="<%= request.getContextPath() %>/organizer">
                <i class="fas fa-chart-line"></i> Dashboard
            </a>
            <a href="<%= request.getContextPath() %>/events" class="active">
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
                <h1><i class="fas fa-calendar-alt"></i> My Events</h1>
                <p>Create and manage your events</p>
            </div>
            <a href="<%= request.getContextPath() %>/events?action=new" class="btn btn-primary">
                <i class="fas fa-plus"></i>
                <span>Create Event</span>
            </a>
        </div>
        
        <% if (success != null) { %>
            <div class="alert alert-success">
                <i class="fas fa-check-circle alert-icon"></i>
                <span>
                    <% if (success.equals("created")) { %>
                        Event created successfully!
                    <% } else if (success.equals("updated")) { %>
                        Event updated successfully!
                    <% } else if (success.equals("deleted")) { %>
                        Event deleted successfully!
                    <% } %>
                </span>
            </div>
        <% } %>
        
        <% if (error != null) { %>
            <div class="alert alert-error">
                <i class="fas fa-exclamation-circle alert-icon"></i>
                <span>An error occurred. Please try again.</span>
            </div>
        <% } %>
        
        <% if (events == null || events.isEmpty()) { %>
            <div class="empty-state">
                <div class="empty-icon"><i class="fas fa-calendar-plus"></i></div>
                <h3>No events yet</h3>
                <p>Create your first event to get started!</p>
                <a href="<%= request.getContextPath() %>/events?action=new" class="btn btn-primary">
                    <i class="fas fa-plus"></i>
                    <span>Create Event</span>
                </a>
            </div>
        <% } else { %>
            <div class="organizer-events">
                <% for (Event event : events) { %>
                    <div class="event-card-large">
                        <div class="event-header">
                            <h3><%= event.getEventName() %></h3>
                            <span class="status-badge <%= event.getStatus().name().toLowerCase() %>">
                                <%= event.getStatus() %>
                            </span>
                        </div>
                        <div class="event-details">
                            <div class="event-detail">
                                <i class="far fa-calendar"></i>
                                <span><%= event.getFormattedDate() %></span>
                            </div>
                            <div class="event-detail">
                                <i class="far fa-clock"></i>
                                <span><%= event.getFormattedTime() %></span>
                            </div>
                            <div class="event-detail">
                                <i class="fas fa-map-marker-alt"></i>
                                <span><%= event.getVenue() %></span>
                            </div>
                        </div>
                        <div class="event-prices">
                            <span class="price-tag regular">Regular: $<%= event.getRegularPrice() %></span>
                            <span class="price-tag vip">VIP: $<%= event.getVipPrice() %></span>
                            <span class="price-tag vvip">VVIP: $<%= event.getVvipPrice() %></span>
                        </div>
                        <div class="event-stats">
                            <i class="fas fa-ticket-alt"></i>
                            <span><%= event.getCapacity() - event.getAvailableTickets() %>/<%= event.getCapacity() %> sold</span>
                        </div>
                        <div class="event-actions">
                            <a href="<%= request.getContextPath() %>/event-attendees?eventId=<%= event.getId() %>" 
                               class="btn btn-outline btn-sm">
                               <i class="fas fa-users"></i> Attendees
                            </a>
                            <a href="<%= request.getContextPath() %>/events?action=edit&id=<%= event.getId() %>" 
                               class="btn btn-outline btn-sm">
                               <i class="fas fa-edit"></i> Edit
                            </a>
                            <a href="<%= request.getContextPath() %>/events?action=delete&id=<%= event.getId() %>" 
                               class="btn btn-outline btn-sm btn-danger"
                               onclick="return confirm('Are you sure you want to delete this event?');">
                               <i class="fas fa-trash"></i> Delete
                            </a>
                        </div>
                    </div>
                <% } %>
            </div>
        <% } %>
    </div>
</body>
</html>
