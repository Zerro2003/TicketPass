<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.eventpass.model.User" %>
<%
    // Check if user is already logged in
    User loggedInUser = (User) session.getAttribute("user");
    if (loggedInUser != null) {
        response.sendRedirect(request.getContextPath() + "/booking.jsp");
        return;
    }
    
    // Get any error message from request
    String error = (String) request.getAttribute("error");
    String username = (String) request.getAttribute("username");
    String logoutParam = request.getParameter("logout");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - EventPass</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="auth-container">
        <div class="auth-card">
            <div class="auth-header">
                <div class="logo">
                    <span class="logo-icon">🎫</span>
                    <span class="logo-text">EventPass</span>
                </div>
                <h1>Welcome Back</h1>
                <p>Sign in to book your event tickets</p>
            </div>
            
            <% if (logoutParam != null && logoutParam.equals("true")) { %>
                <div class="alert alert-success">
                    <span class="alert-icon">✓</span>
                    You have been successfully logged out.
                </div>
            <% } %>
            
            <% if (error != null) { %>
                <div class="alert alert-error">
                    <span class="alert-icon">⚠</span>
                    <%= error %>
                </div>
            <% } %>
            
            <form action="login" method="post" class="auth-form">
                <div class="form-group">
                    <label for="username">Username</label>
                    <div class="input-wrapper">
                        <span class="input-icon">👤</span>
                        <input type="text" id="username" name="username" 
                               value="<%= username != null ? username : "" %>"
                               placeholder="Enter your username" required>
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="password">Password</label>
                    <div class="input-wrapper">
                        <span class="input-icon">🔒</span>
                        <input type="password" id="password" name="password" 
                               placeholder="Enter your password" required>
                    </div>
                </div>
                
                <button type="submit" class="btn btn-primary btn-block">
                    <span>Sign In</span>
                    <span class="btn-arrow">→</span>
                </button>
            </form>
            
            <div class="test-credentials">
                <h4>🧪 Test Credentials</h4>
                <div class="credentials-grid">
                    <div class="credential-item">
                        <span class="role-badge attendee">Attendee</span>
                        <code>john / password123</code>
                    </div>
                    <div class="credential-item">
                        <span class="role-badge organizer">Organizer</span>
                        <code>admin / admin123</code>
                    </div>
                </div>
            </div>
            
            <div class="collaboration-note">
                <h5>📚 Servlet Collaboration Demo</h5>
                <p>This login uses <code>sendRedirect()</code> to navigate to the booking page after successful authentication.</p>
            </div>
        </div>
    </div>
</body>
</html>
