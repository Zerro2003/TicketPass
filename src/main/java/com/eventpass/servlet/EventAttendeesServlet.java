package com.eventpass.servlet;

import com.eventpass.model.User;
import com.eventpass.model.Event;
import com.eventpass.model.Ticket;
import com.eventpass.model.UserDatabase;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

public class EventAttendeesServlet extends HttpServlet {

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
        
        String eventIdStr = request.getParameter("eventId");
        
        if (eventIdStr == null || eventIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/events");
            return;
        }
        
        try {
            int eventId = Integer.parseInt(eventIdStr);
            Event event = UserDatabase.getEventById(eventId);
            
            if (event == null || event.getOrganizerId() != user.getId()) {
                response.sendRedirect(request.getContextPath() + "/events");
                return;
            }
            
            List<Ticket> tickets = UserDatabase.getTicketsByEvent(eventId);
            
            request.setAttribute("event", event);
            request.setAttribute("tickets", tickets);
            request.getRequestDispatcher("/event-attendees.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/events");
        }
    }
}
