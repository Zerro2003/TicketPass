package com.eventpass.model;

import java.util.HashMap;
import java.util.Map;

public class UserDatabase {
    
    private static final Map<String, User> users = new HashMap<>();
    private static final Map<String, String[]> events = new HashMap<>();
    
    static {
        users.put("john", new User(
            "john", 
            "password123", 
            "John Smith", 
            "john.smith@email.com", 
            User.UserRole.ATTENDEE
        ));
        
        users.put("sarah", new User(
            "sarah", 
            "password123", 
            "Sarah Johnson", 
            "sarah.j@email.com", 
            User.UserRole.ATTENDEE
        ));
        
        users.put("mike", new User(
            "mike", 
            "password123", 
            "Mike Williams", 
            "mike.w@email.com", 
            User.UserRole.ATTENDEE
        ));
        
        users.put("admin", new User(
            "admin", 
            "admin123", 
            "Event Admin", 
            "admin@eventpass.com", 
            User.UserRole.ORGANIZER
        ));
        
        users.put("organizer", new User(
            "organizer", 
            "org123", 
            "Jane Organizer", 
            "jane.org@eventpass.com", 
            User.UserRole.ORGANIZER
        ));
        
        events.put("evt001", new String[]{
            "Tech Conference 2026", 
            "February 15, 2026", 
            "Convention Center Hall A"
        });
        
        events.put("evt002", new String[]{
            "Music Festival", 
            "March 20, 2026", 
            "City Park Amphitheater"
        });
        
        events.put("evt003", new String[]{
            "Business Summit", 
            "April 10, 2026", 
            "Grand Hotel Ballroom"
        });
        
        events.put("evt004", new String[]{
            "Art Exhibition Opening", 
            "January 25, 2026", 
            "Modern Art Gallery"
        });
    }
    
    public static User authenticate(String username, String password) {
        User user = users.get(username);
        if (user != null && user.getPassword().equals(password)) {
            return user;
        }
        return null;
    }
    
    public static User getUser(String username) {
        return users.get(username);
    }
    
    public static boolean userExists(String username) {
        return users.containsKey(username);
    }
    
    public static Map<String, String[]> getEvents() {
        return new HashMap<>(events);
    }
    
    public static String[] getEvent(String eventId) {
        return events.get(eventId);
    }
    
    public static String getTestCredentials() {
        return "Attendees: john/password123, sarah/password123, mike/password123 | " +
               "Organizers: admin/admin123, organizer/org123";
    }
}
