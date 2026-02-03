package com.eventpass.servlet;

import com.eventpass.model.User;
import com.eventpass.model.Event;
import com.eventpass.model.Event.EventStatus;
import com.eventpass.model.UserDatabase;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

public class EventManagementServlet extends HttpServlet {

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
        
        String action = request.getParameter("action");
        String eventIdStr = request.getParameter("id");
        
        if ("new".equals(action)) {
            request.getRequestDispatcher("/event-form.jsp").forward(request, response);
            return;
        }
        
        if ("edit".equals(action) && eventIdStr != null) {
            try {
                int eventId = Integer.parseInt(eventIdStr);
                Event event = UserDatabase.getEventById(eventId);
                
                if (event != null && event.getOrganizerId() == user.getId()) {
                    request.setAttribute("event", event);
                    request.getRequestDispatcher("/event-form.jsp").forward(request, response);
                    return;
                }
            } catch (NumberFormatException e) {
            }
            response.sendRedirect(request.getContextPath() + "/events");
            return;
        }
        
        if ("delete".equals(action) && eventIdStr != null) {
            try {
                int eventId = Integer.parseInt(eventIdStr);
                Event event = UserDatabase.getEventById(eventId);
                
                if (event != null && event.getOrganizerId() == user.getId()) {
                    if (UserDatabase.deleteEvent(eventId)) {
                        response.sendRedirect(request.getContextPath() + "/events?success=deleted");
                        return;
                    }
                }
            } catch (NumberFormatException e) {
            }
            response.sendRedirect(request.getContextPath() + "/events?error=deletefailed");
            return;
        }
        
        List<Event> events = UserDatabase.getEventsByOrganizer(user.getId());
        request.setAttribute("events", events);
        request.getRequestDispatcher("/events.jsp").forward(request, response);
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
        if (!user.isOrganizer()) {
            response.sendRedirect(request.getContextPath() + "/booking.jsp");
            return;
        }
        
        String eventIdStr = request.getParameter("eventId");
        String eventName = request.getParameter("eventName");
        String eventDateStr = request.getParameter("eventDate");
        String eventTimeStr = request.getParameter("eventTime");
        String venue = request.getParameter("venue");
        String description = request.getParameter("description");
        String regularPriceStr = request.getParameter("regularPrice");
        String vipPriceStr = request.getParameter("vipPrice");
        String vvipPriceStr = request.getParameter("vvipPrice");
        String capacityStr = request.getParameter("capacity");
        
        if (eventName == null || eventName.trim().isEmpty() ||
            eventDateStr == null || eventDateStr.trim().isEmpty() ||
            venue == null || venue.trim().isEmpty()) {
            
            request.setAttribute("error", "Event name, date, and venue are required");
            request.getRequestDispatcher("/event-form.jsp").forward(request, response);
            return;
        }
        
        try {
            LocalDate eventDate = LocalDate.parse(eventDateStr);
            LocalTime eventTime = (eventTimeStr != null && !eventTimeStr.trim().isEmpty()) 
                                  ? LocalTime.parse(eventTimeStr) : null;
            BigDecimal regularPrice = new BigDecimal(regularPriceStr != null ? regularPriceStr : "0");
            BigDecimal vipPrice = new BigDecimal(vipPriceStr != null ? vipPriceStr : "0");
            BigDecimal vvipPrice = new BigDecimal(vvipPriceStr != null ? vvipPriceStr : "0");
            int capacity = Integer.parseInt(capacityStr != null ? capacityStr : "100");
            
            if (eventIdStr != null && !eventIdStr.trim().isEmpty()) {
                int eventId = Integer.parseInt(eventIdStr);
                Event existingEvent = UserDatabase.getEventById(eventId);
                
                if (existingEvent != null && existingEvent.getOrganizerId() == user.getId()) {
                    existingEvent.setEventName(eventName.trim());
                    existingEvent.setEventDate(eventDate);
                    existingEvent.setEventTime(eventTime);
                    existingEvent.setVenue(venue.trim());
                    existingEvent.setDescription(description != null ? description.trim() : "");
                    existingEvent.setRegularPrice(regularPrice);
                    existingEvent.setVipPrice(vipPrice);
                    existingEvent.setVvipPrice(vvipPrice);
                    existingEvent.setCapacity(capacity);
                    
                    if (UserDatabase.updateEvent(existingEvent)) {
                        response.sendRedirect(request.getContextPath() + "/events?success=updated");
                        return;
                    }
                }
                request.setAttribute("error", "Failed to update event");
                request.getRequestDispatcher("/event-form.jsp").forward(request, response);
                return;
            }
            
            Event newEvent = new Event(
                eventName.trim(),
                eventDate,
                eventTime,
                venue.trim(),
                description != null ? description.trim() : "",
                regularPrice,
                vipPrice,
                vvipPrice,
                capacity,
                user.getId()
            );
            
            if (UserDatabase.createEvent(newEvent)) {
                response.sendRedirect(request.getContextPath() + "/events?success=created");
            } else {
                request.setAttribute("error", "Failed to create event");
                request.getRequestDispatcher("/event-form.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Invalid data provided: " + e.getMessage());
            request.getRequestDispatcher("/event-form.jsp").forward(request, response);
        }
    }
}
