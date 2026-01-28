package com.eventpass.dao;

import com.eventpass.model.Ticket;
import com.eventpass.model.Ticket.TicketStatus;
import com.eventpass.model.Ticket.TicketType;
import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TicketDAO {
    
    public boolean insertTicket(Ticket ticket) {
        String sql = "INSERT INTO tickets (ticket_code, user_id, event_id, ticket_type, quantity, " +
                     "unit_price, total_price, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            statement.setString(1, ticket.getTicketCode());
            statement.setInt(2, ticket.getUserId());
            statement.setInt(3, ticket.getEventId());
            statement.setString(4, ticket.getTicketType().name());
            statement.setInt(5, ticket.getQuantity());
            statement.setBigDecimal(6, ticket.getUnitPrice());
            statement.setBigDecimal(7, ticket.getTotalPrice());
            statement.setString(8, ticket.getStatus().name());
            
            int rowsAffected = statement.executeUpdate();
            
            if (rowsAffected > 0) {
                ResultSet generatedKeys = statement.getGeneratedKeys();
                if (generatedKeys.next()) {
                    ticket.setId(generatedKeys.getInt(1));
                }
                return true;
            }
            return false;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public Ticket getTicketById(int id) {
        String sql = "SELECT t.*, e.event_name, e.event_date, e.venue, u.full_name, u.email " +
                     "FROM tickets t " +
                     "JOIN events e ON t.event_id = e.id " +
                     "JOIN users u ON t.user_id = u.id " +
                     "WHERE t.id = ?";
        
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setInt(1, id);
            ResultSet resultSet = statement.executeQuery();
            
            if (resultSet.next()) {
                return mapResultSetToTicket(resultSet);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public Ticket getTicketByCode(String ticketCode) {
        String sql = "SELECT t.*, e.event_name, e.event_date, e.venue, u.full_name, u.email " +
                     "FROM tickets t " +
                     "JOIN events e ON t.event_id = e.id " +
                     "JOIN users u ON t.user_id = u.id " +
                     "WHERE t.ticket_code = ?";
        
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setString(1, ticketCode);
            ResultSet resultSet = statement.executeQuery();
            
            if (resultSet.next()) {
                return mapResultSetToTicket(resultSet);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public List<Ticket> getTicketsByUser(int userId) {
        String sql = "SELECT t.*, e.event_name, e.event_date, e.venue, u.full_name, u.email " +
                     "FROM tickets t " +
                     "JOIN events e ON t.event_id = e.id " +
                     "JOIN users u ON t.user_id = u.id " +
                     "WHERE t.user_id = ? " +
                     "ORDER BY t.booking_time DESC";
        List<Ticket> tickets = new ArrayList<>();
        
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setInt(1, userId);
            ResultSet resultSet = statement.executeQuery();
            
            while (resultSet.next()) {
                tickets.add(mapResultSetToTicket(resultSet));
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return tickets;
    }
    
    public List<Ticket> getTicketsByEvent(int eventId) {
        String sql = "SELECT t.*, e.event_name, e.event_date, e.venue, u.full_name, u.email " +
                     "FROM tickets t " +
                     "JOIN events e ON t.event_id = e.id " +
                     "JOIN users u ON t.user_id = u.id " +
                     "WHERE t.event_id = ? AND t.status != 'CANCELLED' " +
                     "ORDER BY t.booking_time DESC";
        List<Ticket> tickets = new ArrayList<>();
        
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setInt(1, eventId);
            ResultSet resultSet = statement.executeQuery();
            
            while (resultSet.next()) {
                tickets.add(mapResultSetToTicket(resultSet));
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return tickets;
    }
    
    public boolean updateTicketStatus(int id, TicketStatus status) {
        String sql = "UPDATE tickets SET status = ? WHERE id = ?";
        
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setString(1, status.name());
            statement.setInt(2, id);
            
            return statement.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean verifyTicket(int id) {
        return updateTicketStatus(id, TicketStatus.VERIFIED);
    }
    
    public boolean cancelTicket(int id) {
        return updateTicketStatus(id, TicketStatus.CANCELLED);
    }
    
    public boolean deleteTicket(int id) {
        String sql = "DELETE FROM tickets WHERE id = ?";
        
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setInt(1, id);
            return statement.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public int countTicketsByEvent(int eventId) {
        String sql = "SELECT SUM(quantity) FROM tickets WHERE event_id = ? AND status != 'CANCELLED'";
        
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
    
    public BigDecimal getTotalRevenueByEvent(int eventId) {
        String sql = "SELECT SUM(total_price) FROM tickets WHERE event_id = ? AND status != 'CANCELLED'";
        
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setInt(1, eventId);
            ResultSet resultSet = statement.executeQuery();
            
            if (resultSet.next()) {
                BigDecimal result = resultSet.getBigDecimal(1);
                return result != null ? result : BigDecimal.ZERO;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return BigDecimal.ZERO;
    }
    
    public BigDecimal getTotalRevenueByOrganizer(int organizerId) {
        String sql = "SELECT SUM(t.total_price) FROM tickets t " +
                     "JOIN events e ON t.event_id = e.id " +
                     "WHERE e.organizer_id = ? AND t.status != 'CANCELLED'";
        
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setInt(1, organizerId);
            ResultSet resultSet = statement.executeQuery();
            
            if (resultSet.next()) {
                BigDecimal result = resultSet.getBigDecimal(1);
                return result != null ? result : BigDecimal.ZERO;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return BigDecimal.ZERO;
    }
    
    private Ticket mapResultSetToTicket(ResultSet resultSet) throws SQLException {
        Ticket ticket = new Ticket();
        ticket.setId(resultSet.getInt("id"));
        ticket.setTicketCode(resultSet.getString("ticket_code"));
        ticket.setUserId(resultSet.getInt("user_id"));
        ticket.setEventId(resultSet.getInt("event_id"));
        ticket.setTicketType(TicketType.valueOf(resultSet.getString("ticket_type")));
        ticket.setQuantity(resultSet.getInt("quantity"));
        ticket.setUnitPrice(resultSet.getBigDecimal("unit_price"));
        ticket.setTotalPrice(resultSet.getBigDecimal("total_price"));
        ticket.setStatus(TicketStatus.valueOf(resultSet.getString("status")));
        
        Timestamp bookingTime = resultSet.getTimestamp("booking_time");
        if (bookingTime != null) {
            ticket.setBookingTime(bookingTime.toLocalDateTime());
        }
        
        ticket.setEventName(resultSet.getString("event_name"));
        Date eventDate = resultSet.getDate("event_date");
        if (eventDate != null) {
            ticket.setEventDate(eventDate.toLocalDate().toString());
        }
        ticket.setEventVenue(resultSet.getString("venue"));
        ticket.setAttendeeName(resultSet.getString("full_name"));
        ticket.setAttendeeEmail(resultSet.getString("email"));
        
        return ticket;
    }
}
