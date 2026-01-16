package com.eventpass.model;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.UUID;

public class Ticket {
    
    private String ticketId;
    private String eventName;
    private String eventDate;
    private String eventVenue;
    private String attendeeName;
    private String attendeeEmail;
    private LocalDateTime bookingTime;
    private TicketStatus status;
    
    public enum TicketStatus {
        PENDING,
        VERIFIED,
        USED,
        CANCELLED
    }
    
    public Ticket() {
        this.ticketId = generateTicketId();
        this.bookingTime = LocalDateTime.now();
        this.status = TicketStatus.PENDING;
    }
    
    public Ticket(String eventName, String eventDate, String eventVenue, 
                  String attendeeName, String attendeeEmail) {
        this();
        this.eventName = eventName;
        this.eventDate = eventDate;
        this.eventVenue = eventVenue;
        this.attendeeName = attendeeName;
        this.attendeeEmail = attendeeEmail;
    }
    
    private String generateTicketId() {
        String uuid = UUID.randomUUID().toString().replace("-", "").substring(0, 8).toUpperCase();
        return "EP-" + uuid;
    }
    
    public String getTicketId() {
        return ticketId;
    }
    
    public void setTicketId(String ticketId) {
        this.ticketId = ticketId;
    }
    
    public String getEventName() {
        return eventName;
    }
    
    public void setEventName(String eventName) {
        this.eventName = eventName;
    }
    
    public String getEventDate() {
        return eventDate;
    }
    
    public void setEventDate(String eventDate) {
        this.eventDate = eventDate;
    }
    
    public String getEventVenue() {
        return eventVenue;
    }
    
    public void setEventVenue(String eventVenue) {
        this.eventVenue = eventVenue;
    }
    
    public String getAttendeeName() {
        return attendeeName;
    }
    
    public void setAttendeeName(String attendeeName) {
        this.attendeeName = attendeeName;
    }
    
    public String getAttendeeEmail() {
        return attendeeEmail;
    }
    
    public void setAttendeeEmail(String attendeeEmail) {
        this.attendeeEmail = attendeeEmail;
    }
    
    public LocalDateTime getBookingTime() {
        return bookingTime;
    }
    
    public void setBookingTime(LocalDateTime bookingTime) {
        this.bookingTime = bookingTime;
    }
    
    public String getFormattedBookingTime() {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MMMM dd, yyyy HH:mm:ss");
        return bookingTime.format(formatter);
    }
    
    public TicketStatus getStatus() {
        return status;
    }
    
    public void setStatus(TicketStatus status) {
        this.status = status;
    }
    
    public void verify() {
        this.status = TicketStatus.VERIFIED;
    }
    
    public boolean isValid() {
        return this.status == TicketStatus.VERIFIED;
    }
    
    @Override
    public String toString() {
        return "Ticket{" +
                "ticketId='" + ticketId + '\'' +
                ", eventName='" + eventName + '\'' +
                ", attendeeName='" + attendeeName + '\'' +
                ", status=" + status +
                '}';
    }
}
