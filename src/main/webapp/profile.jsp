<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.eventpass.model.User" %>
<%
    User user = (User) session.getAttribute("user");
    
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    String error = (String) request.getAttribute("error");
    String success = (String) request.getAttribute("success");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profile - EventPass</title>
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
            <a href="<%= request.getContextPath() %>/my-tickets">
                <i class="fas fa-ticket-alt"></i> My Tickets
            </a>
            <a href="<%= request.getContextPath() %>/profile" class="active">
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
                <h1><i class="fas fa-user-cog"></i> My Profile</h1>
                <p>Manage your account settings</p>
            </div>
        </div>
        
        <% if (success != null) { %>
            <div class="alert alert-success">
                <i class="fas fa-check-circle alert-icon"></i>
                <span><%= success %></span>
            </div>
        <% } %>
        
        <% if (error != null) { %>
            <div class="alert alert-error">
                <i class="fas fa-exclamation-circle alert-icon"></i>
                <span><%= error %></span>
            </div>
        <% } %>
        
        <div class="profile-card">
            <form action="<%= request.getContextPath() %>/profile" method="post" class="profile-form">
                <div class="form-section">
                    <h3>Account Information</h3>
                    
                    <div class="form-group">
                        <label for="username">Username</label>
                        <div class="input-wrapper">
                            <i class="fas fa-at input-icon"></i>
                            <input type="text" id="username" value="<%= user.getUsername() %>" disabled>
                        </div>
                        <small>Username cannot be changed</small>
                    </div>
                    
                    <div class="form-group">
                        <label for="fullName">Full Name</label>
                        <div class="input-wrapper">
                            <i class="fas fa-user input-icon"></i>
                            <input type="text" id="fullName" name="fullName" 
                                   value="<%= user.getFullName() %>" required>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="email">Email</label>
                        <div class="input-wrapper">
                            <i class="fas fa-envelope input-icon"></i>
                            <input type="email" id="email" name="email" 
                                   value="<%= user.getEmail() %>" required>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label>Account Type</label>
                        <div class="role-display">
                            <span class="role-badge <%= user.isAttendee() ? "attendee" : "organizer" %>">
                                <%= user.getRole() %>
                            </span>
                        </div>
                    </div>
                </div>
                
                <div class="form-section">
                    <h3>Change Password</h3>
                    <p>Leave blank to keep current password</p>
                    
                    <div class="form-group">
                        <label for="currentPassword">Current Password</label>
                        <div class="input-wrapper">
                            <i class="fas fa-lock input-icon"></i>
                            <input type="password" id="currentPassword" name="currentPassword" 
                                   placeholder="Enter current password">
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="newPassword">New Password</label>
                        <div class="input-wrapper">
                            <i class="fas fa-key input-icon"></i>
                            <input type="password" id="newPassword" name="newPassword" 
                                   placeholder="Enter new password (min 6 chars)">
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="confirmPassword">Confirm New Password</label>
                        <div class="input-wrapper">
                            <i class="fas fa-key input-icon"></i>
                            <input type="password" id="confirmPassword" name="confirmPassword" 
                                   placeholder="Confirm new password">
                        </div>
                    </div>
                </div>
                
                <div class="form-actions">
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save"></i>
                        <span>Save Changes</span>
                    </button>
                </div>
            </form>
        </div>
    </div>
</body>
</html>
