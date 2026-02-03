package com.eventpass.servlet;

import com.eventpass.model.User;
import com.eventpass.model.Ticket;
import com.eventpass.model.UserDatabase;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

public class DeleteTicketServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        String ticketIdStr = request.getParameter("ticketId");
        
        if (ticketIdStr == null || ticketIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/my-tickets?error=invalid");
            return;
        }
        
        try {
            int ticketId = Integer.parseInt(ticketIdStr);
            Ticket ticket = UserDatabase.getTicketById(ticketId);
            
            if (ticket == null) {
                response.sendRedirect(request.getContextPath() + "/my-tickets?error=notfound");
                return;
            }
            
            if (ticket.getUserId() != user.getId()) {
                response.sendRedirect(request.getContextPath() + "/my-tickets?error=unauthorized");
                return;
            }
            
            if (!ticket.isVerified()) {
                response.sendRedirect(request.getContextPath() + "/my-tickets?error=notverified");
                return;
            }
            
            if (UserDatabase.deleteTicket(ticketId)) {
                response.sendRedirect(request.getContextPath() + "/my-tickets?success=deleted");
            } else {
                response.sendRedirect(request.getContextPath() + "/my-tickets?error=failed");
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/my-tickets?error=invalid");
        }
    }
}
