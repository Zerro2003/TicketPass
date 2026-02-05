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

public class VerifyTicketServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
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
        
        String ticketIdStr = request.getParameter("ticketId");
        String eventIdStr = request.getParameter("eventId");
        
        if (ticketIdStr == null || ticketIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/events");
            return;
        }
        
        try {
            int ticketId = Integer.parseInt(ticketIdStr);
            Ticket ticket = UserDatabase.getTicketById(ticketId);
            
            if (ticket == null) {
                response.sendRedirect(request.getContextPath() + "/event-attendees?eventId=" + eventIdStr + "&error=notfound");
                return;
            }
            
            Event event = UserDatabase.getEventById(ticket.getEventId());
            if (event == null || event.getOrganizerId() != user.getId()) {
                response.sendRedirect(request.getContextPath() + "/events?error=unauthorized");
                return;
            }
            
            if (UserDatabase.verifyTicket(ticketId)) {
                response.sendRedirect(request.getContextPath() + "/event-attendees?eventId=" + eventIdStr + "&success=verified");
            } else {
                response.sendRedirect(request.getContextPath() + "/event-attendees?eventId=" + eventIdStr + "&error=failed");
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/events");
        }
    }
}
