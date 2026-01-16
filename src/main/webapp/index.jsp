<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.eventpass.model.User" %>
<%
    User loggedInUser = (User) session.getAttribute("user");
    boolean isLoggedIn = (loggedInUser != null);
    
    Integer visitorCount = (Integer) application.getAttribute("visitorCount");
    if (visitorCount == null) {
        visitorCount = 0;
    }
    visitorCount++;
    application.setAttribute("visitorCount", visitorCount);
    
    Integer userVisits = (Integer) session.getAttribute("userVisits");
    if (userVisits == null) {
        userVisits = 0;
    }
    userVisits++;
    session.setAttribute("userVisits", userVisits);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EventPass - Book Your Event Tickets</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
    <nav class="navbar">
        <div class="nav-brand">
            <span class="logo-icon">🎫</span>
            <span class="logo-text">EventPass</span>
        </div>
        <div class="nav-user">
            <% if (isLoggedIn) { %>
                <span class="user-greeting">Hello, <strong><%= loggedInUser.getFullName() %></strong></span>
                <span class="role-badge <%= loggedInUser.isAttendee() ? "attendee" : "organizer" %>">
                    <%= loggedInUser.getRole() %>
                </span>
                <a href="<%= request.getContextPath() %>/logout" class="btn btn-outline btn-sm">Logout</a>
            <% } else { %>
                <a href="<%= request.getContextPath() %>/login.jsp" class="btn btn-primary btn-sm">Login</a>
            <% } %>
        </div>
    </nav>

    <div class="hero-container">
        <div class="hero-content">
            <div class="hero-badge">🎭 Premier Event Platform</div>
            <h1 class="hero-title">
                Discover & Book
                <span class="gradient-text">Amazing Events</span>
            </h1>
            <p class="hero-subtitle">
                Your gateway to unforgettable experiences. Book tickets for concerts, 
                conferences, and exclusive events with just a few clicks.
            </p>
            
            <% if (isLoggedIn) { %>
                <a href="<%= request.getContextPath() %>/booking.jsp" class="btn btn-primary btn-large">
                    <span>Browse Events</span>
                    <span class="btn-arrow">→</span>
                </a>
            <% } else { %>
                <a href="<%= request.getContextPath() %>/login.jsp" class="btn btn-primary btn-large">
                    <span>Get Started</span>
                    <span class="btn-arrow">→</span>
                </a>
            <% } %>
        </div>
        
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon">👥</div>
                <div class="stat-content">
                    <div class="stat-number"><%= visitorCount %></div>
                    <div class="stat-label">Total Visitors</div>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">🎪</div>
                <div class="stat-content">
                    <div class="stat-number">3</div>
                    <div class="stat-label">Active Events</div>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">🔄</div>
                <div class="stat-content">
                    <div class="stat-number"><%= userVisits %></div>
                    <div class="stat-label">Your Visits</div>
                </div>
            </div>
        </div>
    </div>
    
    <div class="booking-container">
        <div class="session-info-card">
            <h3>📊 JSP Implicit Objects Demo</h3>
            <div class="session-details">
                <div class="session-item">
                    <span class="session-label">Session Status:</span>
                    <span class="session-value <%= isLoggedIn ? "status-active" : "status-inactive" %>">
                        <%= isLoggedIn ? "✅ Logged In" : "❌ Not Logged In" %>
                    </span>
                </div>
                <div class="session-item">
                    <span class="session-label">Session ID:</span>
                    <code class="session-value"><%= session.getId().substring(0, 16) %>...</code>
                </div>
                <% if (isLoggedIn) { %>
                <div class="session-item">
                    <span class="session-label">Logged in as:</span>
                    <span class="session-value"><%= loggedInUser.getUsername() %> (<%= loggedInUser.getEmail() %>)</span>
                </div>
                <% } %>
            </div>
        </div>
        
        <div class="collaboration-note">
            <h5>📚 JSP Implicit Objects Used on This Page</h5>
            <ul class="implicit-objects-list">
                <li><code>session</code> - Stores user login state and visit count per user</li>
                <li><code>request</code> - Gets context path for building URLs</li>
                <li><code>application</code> - Tracks total visitor count across all users</li>
            </ul>
        </div>
    </div>
</body>
</html>
