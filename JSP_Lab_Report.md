# JSP Implicit Objects Lab Report

## EventPass - Event Ticket Booking System

**Student:** [Your Name]  
**Date:** [Submission Date]  
**Course:** [Course Name]

---

## 1. Which JSP Implicit Object I Chose

I selected the **`session`** implicit object as my primary JSP implicit object, with **`request`** and **`response`** as supporting objects used consistently across all pages.

### Implicit Objects Used:

| Object | Type | Description |
|--------|------|-------------|
| **session** | `HttpSession` | Stores user login state and data across requests |
| **request** | `HttpServletRequest` | Passes data between servlet and JSP, gets parameters |
| **response** | `HttpServletResponse` | Redirects unauthorized users |
| **application** | `ServletContext` | Tracks application-wide visitor count |

---

## 2. Why I Selected the `session` Implicit Object

I chose `session` as my primary implicit object for the following reasons:

### 2.1 User Authentication
- The application requires users to log in before accessing protected pages
- The session maintains the user's logged-in state across all page requests
- Without session management, users would need to log in on every page

### 2.2 Data Persistence
- User information needs to persist across multiple pages (login → booking → dashboard)
- The booked ticket needs to be accessible on the dashboard after booking
- Session allows data to survive beyond a single request-response cycle

### 2.3 Security
- Session-based authentication is a standard security practice in web applications
- It allows verifying user identity before showing sensitive booking information

---

## 3. How JSP Implicit Objects Are Used in My Project

### 3.1 index.jsp (Landing Page)

```jsp
<%-- SESSION: Check if user is logged in --%>
User loggedInUser = (User) session.getAttribute("user");
boolean isLoggedIn = (loggedInUser != null);

<%-- SESSION: Track user's page visits --%>
Integer userVisits = (Integer) session.getAttribute("userVisits");
session.setAttribute("userVisits", userVisits);

<%-- APPLICATION: Track total visitors --%>
Integer visitorCount = (Integer) application.getAttribute("visitorCount");
application.setAttribute("visitorCount", visitorCount);

<%-- REQUEST: Build proper URLs --%>
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
```

**Purpose:** Shows different content for logged-in vs guest users, tracks visitor statistics.

---

### 3.2 login.jsp (Login Page)

```jsp
<%-- SESSION: Check if already logged in --%>
User loggedInUser = (User) session.getAttribute("user");

<%-- RESPONSE: Redirect logged-in users --%>
if (loggedInUser != null) {
    response.sendRedirect(request.getContextPath() + "/booking.jsp");
    return;
}

<%-- REQUEST: Get error messages and parameters --%>
String error = (String) request.getAttribute("error");
String logoutParam = request.getParameter("logout");
```

**Purpose:** Handles login form display, redirects already authenticated users, shows error messages.

---

### 3.3 booking.jsp (Event Booking Page)

```jsp
<%-- SESSION: Retrieve logged-in user --%>
User user = (User) session.getAttribute("user");

<%-- RESPONSE: Redirect unauthorized users --%>
if (user == null) {
    response.sendRedirect(request.getContextPath() + "/login.jsp");
    return;
}

<%-- REQUEST: Get error messages --%>
String error = (String) request.getAttribute("error");
```

**Purpose:** Shows available events for booking, protects page from unauthorized access.

---

### 3.4 dashboard.jsp (User Dashboard)

```jsp
<%-- SESSION: Get user and their booked ticket --%>
User user = (User) session.getAttribute("user");
Ticket ticket = (Ticket) session.getAttribute("lastBookedTicket");
Integer userVisits = (Integer) session.getAttribute("userVisits");

<%-- RESPONSE: Redirect unauthorized users --%>
if (user == null) {
    response.sendRedirect(request.getContextPath() + "/login.jsp");
    return;
}

<%-- REQUEST: Get success/error messages --%>
String successMessage = (String) request.getAttribute("successMessage");
```

**Purpose:** Displays user account info, shows latest booking, provides quick actions.

---

## 4. Benefits of Using the `session` Implicit Object

### 4.1 State Management
| Benefit | Description |
|---------|-------------|
| **Persistent State** | Data survives across multiple HTTP requests |
| **User Tracking** | Each user has their own isolated session |
| **Automatic Management** | Tomcat handles session creation and cleanup |

### 4.2 Security Benefits
- Protects pages by checking session before displaying content
- Prevents unauthorized access to booking functionality
- Allows secure logout by invalidating the session

### 4.3 User Experience
- Users stay logged in while browsing the site
- Personalized content based on user role (Attendee/Organizer)
- Seamless navigation between pages without re-authentication

### 4.4 Comparison with Other Approaches

| Approach | Pros | Cons |
|----------|------|------|
| **session** ✓ | Secure, persistent, server-side | Uses server memory |
| request | Fast, lightweight | Data lost after response |
| cookies | Works across sessions | Less secure, client-side |

---

## 5. Project Structure

```
ticketPass/
├── src/main/webapp/
│   ├── index.jsp        ← Landing page (session, application, request)
│   ├── login.jsp        ← Login form (session, request, response)
│   ├── booking.jsp      ← Event booking (session, request, response)
│   ├── dashboard.jsp    ← User dashboard (session, request, response)
│   └── css/
│       └── style.css
└── src/main/java/
    └── com/eventpass/
        ├── model/
        │   ├── User.java
        │   ├── Ticket.java
        │   └── UserDatabase.java
        └── servlet/
            ├── LoginServlet.java
            ├── LogoutServlet.java
            ├── BookingServlet.java
            └── VerificationServlet.java
```

---

## 6. Summary Table: Implicit Objects per Page

| Page | session | request | response | application |
|------|---------|---------|----------|-------------|
| index.jsp | ✅ | ✅ | - | ✅ |
| login.jsp | ✅ | ✅ | ✅ | - |
| booking.jsp | ✅ | ✅ | ✅ | - |
| dashboard.jsp | ✅ | ✅ | ✅ | - |

---

## 7. Conclusion

The `session` implicit object is essential for building secure, stateful web applications. In this EventPass project, it enables:

1. **User authentication** - Maintaining login state
2. **Data sharing** - Passing user and ticket data between pages
3. **Personalization** - Displaying user-specific content
4. **Security** - Protecting pages from unauthorized access

Combined with `request` for parameter handling and `response` for navigation, these JSP implicit objects provide a complete solution for building interactive web applications.

---

*End of Report*
