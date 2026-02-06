<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.eventpass.model.User" %>
<%@ page import="com.eventpass.model.Ticket" %>
<%@ page import="java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    List<Ticket> tickets = (List<Ticket>) request.getAttribute("tickets");
    String success = request.getParameter("success");
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Tickets - EventPass</title>
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
            <a href="<%= request.getContextPath() %>/booking">
                <i class="fas fa-calendar"></i> Events
            </a>
            <a href="<%= request.getContextPath() %>/my-tickets" class="active">
                <i class="fas fa-ticket-alt"></i> My Tickets
            </a>
            <a href="<%= request.getContextPath() %>/profile">
                <i class="fas fa-user"></i> Profile
            </a>
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
                <h1><i class="fas fa-ticket-alt"></i> My Tickets</h1>
                <p>View and manage your booked tickets</p>
            </div>
        </div>
        
        <% if (success != null && success.equals("deleted")) { %>
            <div class="alert alert-success">
                <i class="fas fa-check-circle alert-icon"></i>
                <span>Ticket deleted successfully</span>
            </div>
        <% } %>
        
        <% if (error != null) { %>
            <div class="alert alert-error">
                <i class="fas fa-exclamation-circle alert-icon"></i>
                <span>
                    <% if (error.equals("notverified")) { %>
                        Only verified tickets can be deleted
                    <% } else if (error.equals("unauthorized")) { %>
                        You can only delete your own tickets
                    <% } else { %>
                        An error occurred. Please try again.
                    <% } %>
                </span>
            </div>
        <% } %>
        
        <% if (tickets == null || tickets.isEmpty()) { %>
            <div class="empty-state">
                <div class="empty-icon"><i class="fas fa-ticket-alt"></i></div>
                <h3>No tickets yet</h3>
                <p>You haven't booked any events yet.</p>
                <a href="<%= request.getContextPath() %>/booking" class="btn btn-primary">
                    <i class="fas fa-search"></i>
                    <span>Browse Events</span>
                </a>
            </div>
        <% } else { %>
            <div class="tickets-list">
                <% for (Ticket ticket : tickets) { %>
                    <div class="ticket-item">
                        <div class="ticket-main">
                            <div class="ticket-event">
                                <h3><%= ticket.getEventName() %></h3>
                                <div class="ticket-meta">
                                    <span><i class="far fa-calendar"></i> <%= ticket.getEventDate() %></span>
                                    <span><i class="fas fa-map-marker-alt"></i> <%= ticket.getEventVenue() %></span>
                                </div>
                            </div>
                            <div class="ticket-info">
                                <div class="ticket-code">
                                    <span class="label">Ticket Code</span>
                                    <code><%= ticket.getTicketCode() %></code>
                                </div>
                                <div class="ticket-type">
                                    <span class="badge <%= ticket.getTicketTypeBadgeClass() %>">
                                        <%= ticket.getTicketType() %>
                                    </span>
                                </div>
                                <div class="ticket-qty">
                                    <span class="label">Qty</span>
                                    <span><%= ticket.getQuantity() %></span>
                                </div>
                                <div class="ticket-price">
                                    <span class="label">Total</span>
                                    <span>$<%= ticket.getTotalPrice() %></span>
                                </div>
                            </div>
                        </div>
                        <div class="ticket-actions">
                            <span class="status-badge <%= ticket.getStatusBadgeClass() %>">
                                <% if (ticket.isPending()) { %>
                                    <i class="fas fa-clock"></i> Pending
                                <% } else if (ticket.isVerified()) { %>
                                    <i class="fas fa-check"></i> Verified
                                <% } else { %>
                                    <i class="fas fa-times"></i> Cancelled
                                <% } %>
                            </span>
                            <% if (ticket.isVerified()) { %>
                                <form action="<%= request.getContextPath() %>/delete-ticket" method="post" 
                                      onsubmit="return confirm('Are you sure you want to delete this ticket?');">
                                    <input type="hidden" name="ticketId" value="<%= ticket.getId() %>">
                                    <button type="submit" class="btn btn-outline btn-sm btn-danger">
                                        <i class="fas fa-trash"></i> Delete
                                    </button>
                                </form>
                            <% } %>
                        </div>
                    </div>
                <% } %>
            </div>
        <% } %>
    </div>
</body>
</html>
