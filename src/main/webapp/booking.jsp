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
    
    List<Event> events = (List<Event>) request.getAttribute("events");
    String error = (String) request.getAttribute("error");
    String success = request.getParameter("success");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Book Events - EventPass</title>
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
            <a href="<%= request.getContextPath() %>/booking" class="active">
                <i class="fas fa-calendar"></i> Events
            </a>
            <a href="<%= request.getContextPath() %>/my-tickets">
                <i class="fas fa-ticket-alt"></i> My Tickets
            </a>
            <a href="<%= request.getContextPath() %>/profile">
                <i class="fas fa-user"></i> Profile
            </a>
            <% if (user.isOrganizer()) { %>
                <a href="<%= request.getContextPath() %>/organizer">
                    <i class="fas fa-chart-line"></i> Organizer
                </a>
            <% } %>
        </div>
        <div class="nav-user">
            <div class="user-info">
                <div class="user-avatar"><%= user.getFullName().substring(0, 1).toUpperCase() %></div>
                <span class="user-greeting"><%= user.getFullName() %></span>
            </div>
            <span class="role-badge <%= user.isAttendee() ? "attendee" : "organizer" %>">
                <%= user.getRole() %>
            </span>
            <a href="<%= request.getContextPath() %>/logout" class="btn btn-outline btn-sm">
                <i class="fas fa-sign-out-alt"></i> Logout
            </a>
        </div>
    </nav>

    <div class="booking-container">
        <div class="page-header">
            <div>
                <h1><i class="fas fa-calendar-alt"></i> Browse Events</h1>
                <p>Find and book tickets for amazing events</p>
            </div>
        </div>
        
        <% if (success != null && success.equals("booked")) { %>
            <div class="alert alert-success">
                <i class="fas fa-check-circle alert-icon"></i>
                <span>Ticket booked successfully! View it in <a href="<%= request.getContextPath() %>/my-tickets">My Tickets</a>.</span>
            </div>
        <% } %>
        
        <% if (error != null) { %>
            <div class="alert alert-error">
                <i class="fas fa-exclamation-circle alert-icon"></i>
                <span><%= error %></span>
            </div>
        <% } %>
        
        <% if (events == null || events.isEmpty()) { %>
            <div class="empty-state">
                <div class="empty-icon"><i class="fas fa-calendar-times"></i></div>
                <h3>No events available</h3>
                <p>Check back later for upcoming events!</p>
            </div>
        <% } else { %>
            <div class="events-grid">
                <% for (Event event : events) { %>
                    <div class="event-card">
                        <div class="event-header">
                            <h3><%= event.getEventName() %></h3>
                            <% if (event.isAvailable()) { %>
                                <span class="availability-badge available">Available</span>
                            <% } else { %>
                                <span class="availability-badge sold-out">Sold Out</span>
                            <% } %>
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
                            <div class="event-detail">
                                <i class="fas fa-ticket-alt"></i>
                                <span><%= event.getAvailableTickets() %> tickets left</span>
                            </div>
                        </div>
                        
                        <% if (event.getDescription() != null && !event.getDescription().isEmpty()) { %>
                            <p class="event-description"><%= event.getDescription() %></p>
                        <% } %>
                        
                        <% if (event.isAvailable()) { %>
                            <form action="<%= request.getContextPath() %>/booking" method="post" class="booking-form">
                                <input type="hidden" name="eventId" value="<%= event.getId() %>">
                                
                                <div class="ticket-types">
                                    <label class="ticket-type-option">
                                        <input type="radio" name="ticketType" value="REGULAR" checked>
                                        <span class="ticket-type-card regular">
                                            <span class="type-name">Regular</span>
                                            <span class="type-price">$<%= event.getRegularPrice() %></span>
                                        </span>
                                    </label>
                                    <label class="ticket-type-option">
                                        <input type="radio" name="ticketType" value="VIP">
                                        <span class="ticket-type-card vip">
                                            <span class="type-name">VIP</span>
                                            <span class="type-price">$<%= event.getVipPrice() %></span>
                                        </span>
                                    </label>
                                    <label class="ticket-type-option">
                                        <input type="radio" name="ticketType" value="VVIP">
                                        <span class="ticket-type-card vvip">
                                            <span class="type-name">VVIP</span>
                                            <span class="type-price">$<%= event.getVvipPrice() %></span>
                                        </span>
                                    </label>
                                </div>
                                
                                <div class="quantity-selector">
                                    <label for="quantity-<%= event.getId() %>">Quantity:</label>
                                    <select name="quantity" id="quantity-<%= event.getId() %>">
                                        <% for (int i = 1; i <= Math.min(5, event.getAvailableTickets()); i++) { %>
                                            <option value="<%= i %>"><%= i %></option>
                                        <% } %>
                                    </select>
                                </div>
                                
                                <button type="submit" class="btn btn-primary btn-block">
                                    <i class="fas fa-shopping-cart"></i>
                                    <span>Book Now</span>
                                </button>
                            </form>
                        <% } else { %>
                            <button class="btn btn-disabled btn-block" disabled>
                                <i class="fas fa-times-circle"></i> Sold Out
                            </button>
                        <% } %>
                    </div>
                <% } %>
            </div>
        <% } %>
    </div>
</body>
</html>
