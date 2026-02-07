<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.eventpass.model.User" %>
<%
    User loggedInUser = (User) session.getAttribute("user");
    
    if (loggedInUser != null) {
        response.sendRedirect(request.getContextPath() + "/booking.jsp");
        return;
    }
    
    String error = (String) request.getAttribute("error");
    String username = (String) request.getAttribute("username");
    String fullName = (String) request.getAttribute("fullName");
    String email = (String) request.getAttribute("email");
    String role = (String) request.getAttribute("role");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - EventPass</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="auth-container">
        <div class="auth-card">
            <div class="auth-header">
                <div class="logo">
                    <div class="logo-icon">
                        <i class="fas fa-ticket-alt"></i>
                    </div>
                    <span class="logo-text">EventPass</span>
                </div>
                <h1>Create Account</h1>
                <p>Join EventPass to book amazing events</p>
            </div>
            
            <% if (error != null) { %>
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-circle alert-icon"></i>
                    <span><%= error %></span>
                </div>
            <% } %>
            
            <form action="register" method="post" class="auth-form">
                <div class="form-group">
                    <label for="fullName">Full Name</label>
                    <div class="input-wrapper">
                        <i class="fas fa-user input-icon"></i>
                        <input type="text" id="fullName" name="fullName" 
                               value="<%= fullName != null ? fullName : "" %>"
                               placeholder="Enter your full name" required>
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="username">Username</label>
                    <div class="input-wrapper">
                        <i class="fas fa-at input-icon"></i>
                        <input type="text" id="username" name="username" 
                               value="<%= username != null ? username : "" %>"
                               placeholder="Choose a username" required>
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="email">Email</label>
                    <div class="input-wrapper">
                        <i class="fas fa-envelope input-icon"></i>
                        <input type="email" id="email" name="email" 
                               value="<%= email != null ? email : "" %>"
                               placeholder="Enter your email" required>
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="password">Password</label>
                    <div class="input-wrapper">
                        <i class="fas fa-lock input-icon"></i>
                        <input type="password" id="password" name="password" 
                               placeholder="Create a password (min 6 chars)" required>
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="confirmPassword">Confirm Password</label>
                    <div class="input-wrapper">
                        <i class="fas fa-lock input-icon"></i>
                        <input type="password" id="confirmPassword" name="confirmPassword" 
                               placeholder="Confirm your password" required>
                    </div>
                </div>
                
                <div class="form-group">
                    <label>Account Type</label>
                    <div class="role-selector">
                        <label class="role-option">
                            <input type="radio" name="role" value="ATTENDEE" 
                                   <%= (role == null || role.equals("ATTENDEE")) ? "checked" : "" %>>
                            <span class="role-card">
                                <span class="role-icon"><i class="fas fa-user"></i></span>
                                <span class="role-name">Attendee</span>
                                <span class="role-desc">Book event tickets</span>
                            </span>
                        </label>
                        <label class="role-option">
                            <input type="radio" name="role" value="ORGANIZER"
                                   <%= (role != null && role.equals("ORGANIZER")) ? "checked" : "" %>>
                            <span class="role-card">
                                <span class="role-icon"><i class="fas fa-calendar-alt"></i></span>
                                <span class="role-name">Organizer</span>
                                <span class="role-desc">Create & manage events</span>
                            </span>
                        </label>
                    </div>
                </div>
                
                <button type="submit" class="btn btn-primary btn-block">
                    <span>Create Account</span>
                    <i class="fas fa-arrow-right"></i>
                </button>
            </form>
            
            <div class="auth-footer">
                <p>Already have an account? <a href="login.jsp">Sign In</a></p>
            </div>
        </div>
    </div>
</body>
</html>
