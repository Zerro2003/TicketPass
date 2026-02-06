<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.eventpass.model.User" %>
<%
    User user = (User) session.getAttribute("user");
    
    Integer visitorCount = (Integer) application.getAttribute("visitorCount");
    if (visitorCount == null) {
        visitorCount = 0;
    }
    application.setAttribute("visitorCount", visitorCount + 1);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EventPass - Book Amazing Events</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="css/style.css">
    <style>
        .hero {
            min-height: calc(100vh - 64px);
            display: flex;
            align-items: center;
            justify-content: center;
            text-align: center;
            padding: 4rem 2rem;
            background: linear-gradient(135deg, var(--primary-50) 0%, #faf5ff 50%, var(--gray-50) 100%);
        }
        
        .hero-content {
            max-width: 700px;
        }
        
        .hero-icon {
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, var(--primary-500), var(--primary-700));
            border-radius: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2.5rem;
            color: white;
            margin: 0 auto 2rem;
            box-shadow: 0 20px 40px rgba(99, 102, 241, 0.3);
        }
        
        .hero h1 {
            font-size: 3rem;
            font-weight: 700;
            color: var(--gray-900);
            margin-bottom: 1rem;
            line-height: 1.2;
        }
        
        .hero h1 span {
            background: linear-gradient(135deg, var(--primary-500), #8b5cf6);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        
        .hero p {
            font-size: 1.25rem;
            color: var(--gray-600);
            margin-bottom: 2.5rem;
            line-height: 1.6;
        }
        
        .hero-actions {
            display: flex;
            gap: 1rem;
            justify-content: center;
            flex-wrap: wrap;
        }
        
        .hero-actions .btn {
            padding: 0.875rem 2rem;
            font-size: 1rem;
        }
        
        .hero-stats {
            display: flex;
            gap: 3rem;
            justify-content: center;
            margin-top: 4rem;
            padding-top: 3rem;
            border-top: 1px solid var(--gray-200);
        }
        
        .hero-stat {
            text-align: center;
        }
        
        .hero-stat-number {
            font-size: 2rem;
            font-weight: 700;
            color: var(--gray-900);
        }
        
        .hero-stat-label {
            font-size: 0.875rem;
            color: var(--gray-500);
        }
        
        .features {
            padding: 5rem 2rem;
            background: white;
        }
        
        .features-container {
            max-width: 1200px;
            margin: 0 auto;
        }
        
        .features-header {
            text-align: center;
            margin-bottom: 3rem;
        }
        
        .features-header h2 {
            font-size: 2rem;
            font-weight: 700;
            color: var(--gray-900);
            margin-bottom: 0.5rem;
        }
        
        .features-header p {
            color: var(--gray-600);
        }
        
        .features-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 2rem;
        }
        
        .feature-card {
            padding: 2rem;
            background: var(--gray-50);
            border-radius: var(--radius-lg);
            text-align: center;
            transition: var(--transition);
        }
        
        .feature-card:hover {
            transform: translateY(-4px);
            box-shadow: var(--shadow-lg);
        }
        
        .feature-icon {
            width: 60px;
            height: 60px;
            background: var(--primary-100);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            color: var(--primary-600);
            margin: 0 auto 1rem;
        }
        
        .feature-card h3 {
            font-size: 1.125rem;
            font-weight: 600;
            color: var(--gray-900);
            margin-bottom: 0.5rem;
        }
        
        .feature-card p {
            color: var(--gray-600);
            font-size: 0.9375rem;
        }
        
        .welcome-banner {
            background: linear-gradient(135deg, var(--primary-600), var(--primary-800));
            color: white;
            padding: 1.5rem 2rem;
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 1rem;
        }
        
        .welcome-content {
            display: flex;
            align-items: center;
            gap: 1rem;
        }
        
        .welcome-avatar {
            width: 48px;
            height: 48px;
            background: rgba(255, 255, 255, 0.2);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.25rem;
            font-weight: 600;
        }
        
        .welcome-text h2 {
            font-size: 1.125rem;
            font-weight: 600;
            margin-bottom: 0.25rem;
        }
        
        .welcome-text p {
            font-size: 0.875rem;
            opacity: 0.8;
        }
        
        .welcome-actions {
            display: flex;
            gap: 0.75rem;
        }
        
        .welcome-actions .btn {
            background: rgba(255, 255, 255, 0.15);
            border-color: rgba(255, 255, 255, 0.3);
            color: white;
        }
        
        .welcome-actions .btn:hover {
            background: rgba(255, 255, 255, 0.25);
        }
        
        @media (max-width: 768px) {
            .hero h1 {
                font-size: 2rem;
            }
            
            .hero-stats {
                gap: 1.5rem;
            }
        }
    </style>
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
            <% if (user != null) { %>
                <a href="<%= request.getContextPath() %>/booking">
                    <i class="fas fa-calendar"></i> Events
                </a>
                <a href="<%= request.getContextPath() %>/my-tickets">
                    <i class="fas fa-ticket-alt"></i> My Tickets
                </a>
                <% if (user.isOrganizer()) { %>
                    <a href="<%= request.getContextPath() %>/organizer">
                        <i class="fas fa-chart-line"></i> Organizer
                    </a>
                <% } %>
            <% } %>
        </div>
        <div class="nav-user">
            <% if (user != null) { %>
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
            <% } else { %>
                <a href="login.jsp" class="btn btn-outline btn-sm">
                    <i class="fas fa-sign-in-alt"></i> Login
                </a>
                <a href="register.jsp" class="btn btn-primary btn-sm">
                    <i class="fas fa-user-plus"></i> Register
                </a>
            <% } %>
        </div>
    </nav>
    
    <% if (user != null) { %>
        <div class="welcome-banner">
            <div class="welcome-content">
                <div class="welcome-avatar"><%= user.getFullName().substring(0, 1).toUpperCase() %></div>
                <div class="welcome-text">
                    <h2>Welcome back, <%= user.getFullName() %>!</h2>
                    <p>Ready to explore amazing events?</p>
                </div>
            </div>
            <div class="welcome-actions">
                <a href="<%= request.getContextPath() %>/booking" class="btn btn-sm">
                    <i class="fas fa-search"></i> Browse Events
                </a>
                <a href="<%= request.getContextPath() %>/my-tickets" class="btn btn-sm">
                    <i class="fas fa-ticket-alt"></i> My Tickets
                </a>
            </div>
        </div>
    <% } %>

    <section class="hero">
        <div class="hero-content">
            <div class="hero-icon">
                <i class="fas fa-ticket-alt"></i>
            </div>
            <h1>Book <span>Amazing Events</span> in Seconds</h1>
            <p>EventPass makes it easy to discover, book, and manage event tickets. Join thousands of users enjoying seamless event experiences.</p>
            
            <% if (user == null) { %>
                <div class="hero-actions">
                    <a href="register.jsp" class="btn btn-primary">
                        <i class="fas fa-user-plus"></i> Get Started
                    </a>
                    <a href="login.jsp" class="btn btn-outline">
                        <i class="fas fa-sign-in-alt"></i> Sign In
                    </a>
                </div>
            <% } else { %>
                <div class="hero-actions">
                    <a href="<%= request.getContextPath() %>/booking" class="btn btn-primary">
                        <i class="fas fa-search"></i> Browse Events
                    </a>
                </div>
            <% } %>
            
            <div class="hero-stats">
                <div class="hero-stat">
                    <div class="hero-stat-number"><%= visitorCount + 1 %></div>
                    <div class="hero-stat-label">Site Visitors</div>
                </div>
                <div class="hero-stat">
                    <div class="hero-stat-number">50+</div>
                    <div class="hero-stat-label">Events</div>
                </div>
                <div class="hero-stat">
                    <div class="hero-stat-number">1000+</div>
                    <div class="hero-stat-label">Tickets Sold</div>
                </div>
            </div>
        </div>
    </section>
    
    <section class="features">
        <div class="features-container">
            <div class="features-header">
                <h2>Why Choose EventPass?</h2>
                <p>Everything you need for a great event experience</p>
            </div>
            
            <div class="features-grid">
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-bolt"></i>
                    </div>
                    <h3>Fast Booking</h3>
                    <p>Book tickets in seconds with our streamlined checkout process.</p>
                </div>
                
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-shield-alt"></i>
                    </div>
                    <h3>Secure Tickets</h3>
                    <p>Unique ticket codes ensure authenticity at every event.</p>
                </div>
                
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-star"></i>
                    </div>
                    <h3>VIP Access</h3>
                    <p>Choose from Regular, VIP, or VVIP tickets for premium experiences.</p>
                </div>
                
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-check-circle"></i>
                    </div>
                    <h3>Easy Verification</h3>
                    <p>Organizers can verify tickets instantly at the entrance.</p>
                </div>
            </div>
        </div>
    </section>
</body>
</html>
