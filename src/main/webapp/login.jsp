<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.eventpass.model.User" %>
<%
    User loggedInUser = (User) session.getAttribute("user");
    
    if (loggedInUser != null) {
        response.sendRedirect(request.getContextPath() + "/booking.jsp");
        return;
    }
    
    String error = (String) request.getAttribute("error");
    String success = (String) request.getAttribute("success");
    String username = (String) request.getAttribute("username");
    String logoutParam = request.getParameter("logout");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - EventPass</title>
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
                <h1>Welcome Back</h1>
                <p>Sign in to book your event tickets</p>
            </div>
            
            <% if (logoutParam != null && logoutParam.equals("true")) { %>
                <div class="alert alert-success">
                    <i class="fas fa-check-circle alert-icon"></i>
                    <span>You have been successfully logged out.</span>
                </div>
            <% } %>
            
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
            
            <form action="login" method="post" class="auth-form">
                <div class="form-group">
                    <label for="username">Username</label>
                    <div class="input-wrapper">
                        <i class="fas fa-user input-icon"></i>
                        <input type="text" id="username" name="username" 
                               value="<%= username != null ? username : "" %>"
                               placeholder="Enter your username" required>
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="password">Password</label>
                    <div class="input-wrapper">
                        <i class="fas fa-lock input-icon"></i>
                        <input type="password" id="password" name="password" 
                               placeholder="Enter your password" required>
                    </div>
                </div>
                
                <button type="submit" class="btn btn-primary btn-block">
                    <span>Sign In</span>
                    <i class="fas fa-arrow-right"></i>
                </button>
            </form>
            
            <div class="auth-footer">
                <p>Don't have an account? <a href="register.jsp">Create Account</a></p>
            </div>
            

        </div>
    </div>
</body>
</html>
