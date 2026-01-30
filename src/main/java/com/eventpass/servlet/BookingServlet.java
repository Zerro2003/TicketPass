package com.eventpass.servlet;

import com.eventpass.model.User;
import com.eventpass.model.Event;
import com.eventpass.model.Ticket;
import com.eventpass.model.Ticket.TicketType;
import com.eventpass.model.UserDatabase;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

public class BookingServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        List<Event> events = UserDatabase.getEvents();
        request.setAttribute("events", events);
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
        String eventIdStr = request.getParameter("eventId");
        String ticketTypeStr = request.getParameter("ticketType");
        String quantityStr = request.getParameter("quantity");
        
        if (eventIdStr == null || eventIdStr.trim().isEmpty()) {
            request.setAttribute("error", "Please select an event");
            doGet(request, response);
            return;
        }
        
        try {
            int eventId = Integer.parseInt(eventIdStr);
            int quantity = (quantityStr != null) ? Integer.parseInt(quantityStr) : 1;
            TicketType ticketType = (ticketTypeStr != null) ? TicketType.valueOf(ticketTypeStr) : TicketType.REGULAR;
            
            Event event = UserDatabase.getEventById(eventId);
            
            if (event == null) {
                request.setAttribute("error", "Event not found");
                doGet(request, response);
                return;
            }
            
            if (!event.isAvailable() || event.getAvailableTickets() < quantity) {
                request.setAttribute("error", "Not enough tickets available");
                doGet(request, response);
                return;
            }
            
            BigDecimal unitPrice;
            switch (ticketType) {
                case VIP:
                    unitPrice = event.getVipPrice();
                    break;
                case VVIP:
                    unitPrice = event.getVvipPrice();
                    break;
                default:
                    unitPrice = event.getRegularPrice();
            }
            
            Ticket ticket = new Ticket(user.getId(), eventId, ticketType, quantity, unitPrice);
            ticket.setEventName(event.getEventName());
            ticket.setEventDate(event.getEventDate().toString());
            ticket.setEventVenue(event.getVenue());
            ticket.setAttendeeName(user.getFullName());
            ticket.setAttendeeEmail(user.getEmail());
            
            if (UserDatabase.createTicket(ticket) && UserDatabase.decrementEventTickets(eventId, quantity)) {
                response.sendRedirect(request.getContextPath() + "/booking.jsp?success=booked");
            } else {
                request.setAttribute("error", "Failed to book ticket. Please try again.");
                doGet(request, response);
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid data provided");
            doGet(request, response);
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", "Invalid ticket type");
            doGet(request, response);
        }
    }
}
