package com.eventpass.servlet;

import com.eventpass.model.User;
import com.eventpass.model.Event;
import com.eventpass.model.UserDatabase;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

public class OrganizerDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        
        if (!user.isOrganizer()) {
            response.sendRedirect(request.getContextPath() + "/booking.jsp");
            return;
        }
        
        List<Event> events = UserDatabase.getEventsByOrganizer(user.getId());
        BigDecimal totalRevenue = UserDatabase.getTotalRevenueByOrganizer(user.getId());
        
        int totalTicketsSold = 0;
        for (Event event : events) {
            totalTicketsSold += UserDatabase.countTicketsByEvent(event.getId());
        }
        
        request.setAttribute("events", events);
        request.setAttribute("totalEvents", events.size());
        request.setAttribute("totalTicketsSold", totalTicketsSold);
        request.setAttribute("totalRevenue", totalRevenue);
        
        request.getRequestDispatcher("/organizer-dashboard.jsp").forward(request, response);
    }
}
