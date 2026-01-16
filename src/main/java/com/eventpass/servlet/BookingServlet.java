package com.eventpass.servlet;

import com.eventpass.model.Ticket;
import com.eventpass.model.User;
import com.eventpass.model.UserDatabase;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

public class BookingServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        request.getRequestDispatcher("/booking.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        String eventId = request.getParameter("eventId");
        
        if (eventId == null || eventId.trim().isEmpty()) {
            request.setAttribute("error", "Please select an event to book");
            request.getRequestDispatcher("/booking.jsp").forward(request, response);
            return;
        }
        
        String[] eventDetails = UserDatabase.getEvent(eventId);
        if (eventDetails == null) {
            request.setAttribute("error", "Selected event not found");
            request.getRequestDispatcher("/booking.jsp").forward(request, response);
            return;
        }
        
        Ticket ticket = new Ticket(
            eventDetails[0],
            eventDetails[1],
            eventDetails[2],
            user.getFullName(),
            user.getEmail()
        );
        
        request.setAttribute("ticket", ticket);
        request.setAttribute("user", user);
        request.setAttribute("bookingSuccess", true);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/verify");
        dispatcher.forward(request, response);
    }
}
