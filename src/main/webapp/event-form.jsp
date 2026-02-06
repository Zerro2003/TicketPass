<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.eventpass.model.User" %>
<%@ page import="com.eventpass.model.Event" %>
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
    
    Event event = (Event) request.getAttribute("event");
    boolean isEdit = (event != null);
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= isEdit ? "Edit" : "Create" %> Event - EventPass</title>
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
            <a href="<%= request.getContextPath() %>/events">
                <i class="fas fa-calendar-alt"></i> My Events
            </a>
            <a href="<%= request.getContextPath() %>/events?action=new" class="<%= isEdit ? "" : "active" %>">
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
                <h1>
                    <i class="fas fa-<%= isEdit ? "edit" : "plus-circle" %>"></i> 
                    <%= isEdit ? "Edit Event" : "Create Event" %>
                </h1>
                <p><%= isEdit ? "Update your event details" : "Set up a new event" %></p>
            </div>
        </div>
        
        <% if (error != null) { %>
            <div class="alert alert-error">
                <i class="fas fa-exclamation-circle alert-icon"></i>
                <span><%= error %></span>
            </div>
        <% } %>
        
        <div class="form-card">
            <form action="<%= request.getContextPath() %>/events" method="post" class="event-form">
                <% if (isEdit) { %>
                    <input type="hidden" name="eventId" value="<%= event.getId() %>">
                <% } %>
                
                <div class="form-section">
                    <h3>Event Details</h3>
                    
                    <div class="form-group">
                        <label for="eventName">Event Name *</label>
                        <div class="input-wrapper">
                            <i class="fas fa-heading input-icon"></i>
                            <input type="text" id="eventName" name="eventName" 
                                   value="<%= isEdit ? event.getEventName() : "" %>" 
                                   placeholder="Enter event name" required>
                        </div>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="eventDate">Event Date *</label>
                            <div class="input-wrapper">
                                <i class="far fa-calendar input-icon"></i>
                                <input type="date" id="eventDate" name="eventDate" 
                                       value="<%= isEdit ? event.getEventDate() : "" %>" required>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label for="eventTime">Event Time</label>
                            <div class="input-wrapper">
                                <i class="far fa-clock input-icon"></i>
                                <input type="time" id="eventTime" name="eventTime" 
                                       value="<%= isEdit && event.getEventTime() != null ? event.getEventTime() : "" %>">
                            </div>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="venue">Venue *</label>
                        <div class="input-wrapper">
                            <i class="fas fa-map-marker-alt input-icon"></i>
                            <input type="text" id="venue" name="venue" 
                                   value="<%= isEdit ? event.getVenue() : "" %>" 
                                   placeholder="Enter venue location" required>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="description">Description</label>
                        <textarea id="description" name="description" rows="4" 
                                  placeholder="Describe your event"><%= isEdit && event.getDescription() != null ? event.getDescription() : "" %></textarea>
                    </div>
                    
                    <div class="form-group">
                        <label for="capacity">Total Capacity *</label>
                        <div class="input-wrapper">
                            <i class="fas fa-users input-icon"></i>
                            <input type="number" id="capacity" name="capacity" min="1" 
                                   value="<%= isEdit ? event.getCapacity() : "100" %>" required>
                        </div>
                    </div>
                </div>
                
                <div class="form-section">
                    <h3>Ticket Pricing</h3>
                    <p>Set prices for each ticket category</p>
                    
                    <div class="form-row pricing-row">
                        <div class="form-group">
                            <label for="regularPrice">Regular ($)</label>
                            <div class="input-wrapper">
                                <i class="fas fa-dollar-sign input-icon"></i>
                                <input type="number" id="regularPrice" name="regularPrice" 
                                       step="0.01" min="0" 
                                       value="<%= isEdit ? event.getRegularPrice() : "0" %>">
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label for="vipPrice">VIP ($)</label>
                            <div class="input-wrapper">
                                <i class="fas fa-star input-icon"></i>
                                <input type="number" id="vipPrice" name="vipPrice" 
                                       step="0.01" min="0" 
                                       value="<%= isEdit ? event.getVipPrice() : "0" %>">
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label for="vvipPrice">VVIP ($)</label>
                            <div class="input-wrapper">
                                <i class="fas fa-crown input-icon"></i>
                                <input type="number" id="vvipPrice" name="vvipPrice" 
                                       step="0.01" min="0" 
                                       value="<%= isEdit ? event.getVvipPrice() : "0" %>">
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="form-actions">
                    <a href="<%= request.getContextPath() %>/events" class="btn btn-outline">
                        <i class="fas fa-times"></i> Cancel
                    </a>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save"></i>
                        <span><%= isEdit ? "Update Event" : "Create Event" %></span>
                    </button>
                </div>
            </form>
        </div>
    </div>
</body>
</html>
