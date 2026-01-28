package com.eventpass.model;

import com.eventpass.dao.UserDAO;
import com.eventpass.dao.EventDAO;
import com.eventpass.dao.TicketDAO;
import java.util.List;
import java.math.BigDecimal;

public class UserDatabase {
    
    private static final UserDAO userDAO = new UserDAO();
    private static final EventDAO eventDAO = new EventDAO();
    private static final TicketDAO ticketDAO = new TicketDAO();
    
    public static User authenticate(String username, String password) {
        return userDAO.authenticate(username, password);
    }
    
    public static User getUser(String username) {
        return userDAO.getUserByUsername(username);
    }
    
    public static User getUserById(int id) {
        return userDAO.getUserById(id);
    }
    
    public static boolean userExists(String username) {
        return userDAO.userExists(username);
    }
    
    public static boolean emailExists(String email) {
        return userDAO.emailExists(email);
    }
    
    public static boolean registerUser(User user) {
        return userDAO.insertUser(user);
    }
    
    public static boolean updateUser(User user) {
        return userDAO.updateUser(user);
    }
    
    public static List<Event> getEvents() {
        return eventDAO.getAllEvents();
    }
    
    public static Event getEventById(int id) {
        return eventDAO.getEventById(id);
    }
    
    public static List<Event> getEventsByOrganizer(int organizerId) {
        return eventDAO.getEventsByOrganizer(organizerId);
    }
    
    public static boolean createEvent(Event event) {
        return eventDAO.insertEvent(event);
    }
    
    public static boolean updateEvent(Event event) {
        return eventDAO.updateEvent(event);
    }
    
    public static boolean deleteEvent(int eventId) {
        return eventDAO.deleteEvent(eventId);
    }
    
    public static boolean decrementEventTickets(int eventId, int quantity) {
        return eventDAO.decrementAvailableTickets(eventId, quantity);
    }
    
    public static boolean createTicket(Ticket ticket) {
        return ticketDAO.insertTicket(ticket);
    }
    
    public static List<Ticket> getTicketsByUser(int userId) {
        return ticketDAO.getTicketsByUser(userId);
    }
    
    public static List<Ticket> getTicketsByEvent(int eventId) {
        return ticketDAO.getTicketsByEvent(eventId);
    }
    
    public static Ticket getTicketById(int ticketId) {
        return ticketDAO.getTicketById(ticketId);
    }
    
    public static boolean verifyTicket(int ticketId) {
        return ticketDAO.verifyTicket(ticketId);
    }
    
    public static boolean deleteTicket(int ticketId) {
        return ticketDAO.deleteTicket(ticketId);
    }
    
    public static BigDecimal getTotalRevenueByOrganizer(int organizerId) {
        return ticketDAO.getTotalRevenueByOrganizer(organizerId);
    }
    
    public static int countTicketsByEvent(int eventId) {
        return ticketDAO.countTicketsByEvent(eventId);
    }
    
    public static String getTestCredentials() {
        return "Attendees: john/password123, sarah/password123, mike/password123 | " +
               "Organizers: admin/admin123, organizer/org123";
    }
}
