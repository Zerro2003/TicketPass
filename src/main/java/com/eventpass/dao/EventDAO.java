package com.eventpass.dao;

import com.eventpass.model.Event;
import com.eventpass.model.Event.EventStatus;
import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EventDAO {
    
    public boolean insertEvent(Event event) {
        String sql = "INSERT INTO events (event_name, event_date, event_time, venue, description, " +
                     "regular_price, vip_price, vvip_price, capacity, available_tickets, organizer_id, status) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            statement.setString(1, event.getEventName());
            statement.setDate(2, Date.valueOf(event.getEventDate()));
            statement.setTime(3, event.getEventTime() != null ? Time.valueOf(event.getEventTime()) : null);
            statement.setString(4, event.getVenue());
            statement.setString(5, event.getDescription());
            statement.setBigDecimal(6, event.getRegularPrice());
            statement.setBigDecimal(7, event.getVipPrice());
            statement.setBigDecimal(8, event.getVvipPrice());
            statement.setInt(9, event.getCapacity());
            statement.setInt(10, event.getAvailableTickets());
            statement.setInt(11, event.getOrganizerId());
            statement.setString(12, event.getStatus().name());
            
            int rowsAffected = statement.executeUpdate();
            
            if (rowsAffected > 0) {
                ResultSet generatedKeys = statement.getGeneratedKeys();
                if (generatedKeys.next()) {
                    event.setId(generatedKeys.getInt(1));
                }
                return true;
            }
            return false;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public Event getEventById(int id) {
        String sql = "SELECT * FROM events WHERE id = ?";
        
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setInt(1, id);
            ResultSet resultSet = statement.executeQuery();
            
            if (resultSet.next()) {
                return mapResultSetToEvent(resultSet);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public List<Event> getAllEvents() {
        String sql = "SELECT * FROM events WHERE status = 'ACTIVE' ORDER BY event_date ASC";
        List<Event> events = new ArrayList<>();
        
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {
            
            while (resultSet.next()) {
                events.add(mapResultSetToEvent(resultSet));
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return events;
    }
    
    public List<Event> getEventsByOrganizer(int organizerId) {
        String sql = "SELECT * FROM events WHERE organizer_id = ? ORDER BY event_date DESC";
        List<Event> events = new ArrayList<>();
        
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setInt(1, organizerId);
            ResultSet resultSet = statement.executeQuery();
            
            while (resultSet.next()) {
                events.add(mapResultSetToEvent(resultSet));
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return events;
    }
    
    public boolean updateEvent(Event event) {
        String sql = "UPDATE events SET event_name = ?, event_date = ?, event_time = ?, venue = ?, " +
                     "description = ?, regular_price = ?, vip_price = ?, vvip_price = ?, " +
                     "capacity = ?, available_tickets = ?, status = ? WHERE id = ?";
        
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setString(1, event.getEventName());
            statement.setDate(2, Date.valueOf(event.getEventDate()));
            statement.setTime(3, event.getEventTime() != null ? Time.valueOf(event.getEventTime()) : null);
            statement.setString(4, event.getVenue());
            statement.setString(5, event.getDescription());
            statement.setBigDecimal(6, event.getRegularPrice());
            statement.setBigDecimal(7, event.getVipPrice());
            statement.setBigDecimal(8, event.getVvipPrice());
            statement.setInt(9, event.getCapacity());
            statement.setInt(10, event.getAvailableTickets());
            statement.setString(11, event.getStatus().name());
            statement.setInt(12, event.getId());
            
            return statement.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean deleteEvent(int id) {
        String sql = "DELETE FROM events WHERE id = ?";
        
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setInt(1, id);
            return statement.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean decrementAvailableTickets(int eventId, int quantity) {
        String sql = "UPDATE events SET available_tickets = available_tickets - ? " +
                     "WHERE id = ? AND available_tickets >= ?";
        
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setInt(1, quantity);
            statement.setInt(2, eventId);
            statement.setInt(3, quantity);
            
            return statement.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean incrementAvailableTickets(int eventId, int quantity) {
        String sql = "UPDATE events SET available_tickets = available_tickets + ? WHERE id = ?";
        
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setInt(1, quantity);
            statement.setInt(2, eventId);
            
            return statement.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public int getTicketsSoldCount(int eventId) {
        String sql = "SELECT COUNT(*) FROM tickets WHERE event_id = ? AND status != 'CANCELLED'";
        
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setInt(1, eventId);
            ResultSet resultSet = statement.executeQuery();
            
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    private Event mapResultSetToEvent(ResultSet resultSet) throws SQLException {
        Event event = new Event();
        event.setId(resultSet.getInt("id"));
        event.setEventName(resultSet.getString("event_name"));
        
        Date eventDate = resultSet.getDate("event_date");
        if (eventDate != null) {
            event.setEventDate(eventDate.toLocalDate());
        }
        
        Time eventTime = resultSet.getTime("event_time");
        if (eventTime != null) {
            event.setEventTime(eventTime.toLocalTime());
        }
        
        event.setVenue(resultSet.getString("venue"));
        event.setDescription(resultSet.getString("description"));
        event.setRegularPrice(resultSet.getBigDecimal("regular_price"));
        event.setVipPrice(resultSet.getBigDecimal("vip_price"));
        event.setVvipPrice(resultSet.getBigDecimal("vvip_price"));
        event.setCapacity(resultSet.getInt("capacity"));
        event.setAvailableTickets(resultSet.getInt("available_tickets"));
        event.setOrganizerId(resultSet.getInt("organizer_id"));
        event.setStatus(EventStatus.valueOf(resultSet.getString("status")));
        
        Timestamp createdAt = resultSet.getTimestamp("created_at");
        if (createdAt != null) {
            event.setCreatedAt(createdAt.toLocalDateTime());
        }
        
        return event;
    }
}
