<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.eventpass.model.User" %>
<%@ page import="com.eventpass.model.Event" %>
<%@ page import="com.eventpass.model.Ticket" %>
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
    
    Event event = (Event) request.getAttribute("event");
    List<Ticket> tickets = (List<Ticket>) request.getAttribute("tickets");
    String success = request.getParameter("success");
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Event Attendees - EventPass</title>
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
                <h1><i class="fas fa-users"></i> Event Attendees</h1>
                <% if (event != null) { %>
                    <p><strong><%= event.getEventName() %></strong> &mdash; <%= event.getFormattedDate() %></p>
                <% } %>
            </div>
            <a href="<%= request.getContextPath() %>/events" class="btn btn-outline">
                <i class="fas fa-arrow-left"></i> Back to Events
            </a>
        </div>
        
        <% if (success != null && success.equals("verified")) { %>
            <div class="alert alert-success">
                <i class="fas fa-check-circle alert-icon"></i>
                <span>Ticket verified successfully!</span>
            </div>
        <% } %>
        
        <% if (error != null) { %>
            <div class="alert alert-error">
                <i class="fas fa-exclamation-circle alert-icon"></i>
                <span>
                    <% if (error.equals("notfound")) { %>
                        Ticket not found
                    <% } else if (error.equals("unauthorized")) { %>
                        Unauthorized action
                    <% } else { %>
                        An error occurred
                    <% } %>
                </span>
            </div>
        <% } %>
        
        <% if (tickets == null || tickets.isEmpty()) { %>
            <div class="empty-state">
                <div class="empty-icon"><i class="fas fa-users-slash"></i></div>
                <h3>No attendees yet</h3>
                <p>No one has booked tickets for this event yet.</p>
            </div>
        <% } else { %>
            <div class="attendees-summary">
                <span class="summary-item">
                    <i class="fas fa-users"></i> 
                    Total Attendees: <strong><%= tickets.size() %></strong>
                </span>
            </div>
            
            <div class="attendees-table-wrapper">
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>Ticket Code</th>
                            <th>Attendee</th>
                            <th>Email</th>
                            <th>Type</th>
                            <th>Qty</th>
                            <th>Total</th>
                            <th>Status</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Ticket ticket : tickets) { %>
                        <tr>
                            <td><code><%= ticket.getTicketCode() %></code></td>
                            <td><strong><%= ticket.getAttendeeName() %></strong></td>
                            <td><%= ticket.getAttendeeEmail() %></td>
                            <td>
                                <span class="badge <%= ticket.getTicketTypeBadgeClass() %>">
                                    <%= ticket.getTicketType() %>
                                </span>
                            </td>
                            <td><%= ticket.getQuantity() %></td>
                            <td>$<%= ticket.getTotalPrice() %></td>
                            <td>
                                <span class="status-badge <%= ticket.getStatusBadgeClass() %>">
                                    <% if (ticket.isPending()) { %>
                                        <i class="fas fa-clock"></i> Pending
                                    <% } else if (ticket.isVerified()) { %>
                                        <i class="fas fa-check"></i> Verified
                                    <% } %>
                                </span>
                            </td>
                            <td>
                                <% if (ticket.isPending()) { %>
                                    <form action="<%= request.getContextPath() %>/verify-ticket" method="post" style="display: inline;">
                                        <input type="hidden" name="ticketId" value="<%= ticket.getId() %>">
                                        <input type="hidden" name="eventId" value="<%= event.getId() %>">
                                        <button type="submit" class="btn btn-sm btn-primary">
                                            <i class="fas fa-check"></i> Verify
                                        </button>
                                    </form>
                                <% } else { %>
                                    <span class="text-muted">
                                        <i class="fas fa-check-double"></i> Done
                                    </span>
                                <% } %>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        <% } %>
    </div>
</body>
</html>
