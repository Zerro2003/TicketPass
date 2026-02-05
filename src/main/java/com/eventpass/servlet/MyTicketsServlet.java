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
import java.util.List;

public class MyTicketsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        List<Ticket> tickets = UserDatabase.getTicketsByUser(user.getId());
        
        request.setAttribute("tickets", tickets);
        request.getRequestDispatcher("/my-tickets.jsp").forward(request, response);
    }
}
