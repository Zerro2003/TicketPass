package com.eventpass.model;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class Event {
    
    public enum EventStatus {
        ACTIVE,
        CANCELLED,
        COMPLETED
    }
    
    public enum TicketType {
        REGULAR,
        VIP,
        VVIP
    }
    
    private int id;
    private String eventName;
    private LocalDate eventDate;
    private LocalTime eventTime;
    private String venue;
    private String description;
    private BigDecimal regularPrice;
    private BigDecimal vipPrice;
    private BigDecimal vvipPrice;
    private int capacity;
    private int availableTickets;
    private int organizerId;
    private EventStatus status;
    private LocalDateTime createdAt;
    
    public Event() {
        this.status = EventStatus.ACTIVE;
        this.createdAt = LocalDateTime.now();
    }
    
    public Event(String eventName, LocalDate eventDate, LocalTime eventTime, String venue, 
                 String description, BigDecimal regularPrice, BigDecimal vipPrice, 
                 BigDecimal vvipPrice, int capacity, int organizerId) {
        this();
        this.eventName = eventName;
        this.eventDate = eventDate;
        this.eventTime = eventTime;
        this.venue = venue;
        this.description = description;
        this.regularPrice = regularPrice;
        this.vipPrice = vipPrice;
        this.vvipPrice = vvipPrice;
        this.capacity = capacity;
        this.availableTickets = capacity;
        this.organizerId = organizerId;
    }
    
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public String getEventName() {
        return eventName;
    }
    
    public void setEventName(String eventName) {
        this.eventName = eventName;
    }
    
    public LocalDate getEventDate() {
        return eventDate;
    }
    
    public void setEventDate(LocalDate eventDate) {
        this.eventDate = eventDate;
    }
    
    public LocalTime getEventTime() {
        return eventTime;
    }
    
    public void setEventTime(LocalTime eventTime) {
        this.eventTime = eventTime;
    }
    
    public String getVenue() {
        return venue;
    }
    
    public void setVenue(String venue) {
        this.venue = venue;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public BigDecimal getRegularPrice() {
        return regularPrice;
    }
    
    public void setRegularPrice(BigDecimal regularPrice) {
        this.regularPrice = regularPrice;
    }
    
    public BigDecimal getVipPrice() {
        return vipPrice;
    }
    
    public void setVipPrice(BigDecimal vipPrice) {
        this.vipPrice = vipPrice;
    }
    
    public BigDecimal getVvipPrice() {
        return vvipPrice;
    }
    
    public void setVvipPrice(BigDecimal vvipPrice) {
        this.vvipPrice = vvipPrice;
    }
    
    public BigDecimal getPrice(TicketType type) {
        switch (type) {
            case VIP:
                return vipPrice;
            case VVIP:
                return vvipPrice;
            default:
                return regularPrice;
        }
    }
    
    public int getCapacity() {
        return capacity;
    }
    
    public void setCapacity(int capacity) {
        this.capacity = capacity;
    }
    
    public int getAvailableTickets() {
        return availableTickets;
    }
    
    public void setAvailableTickets(int availableTickets) {
        this.availableTickets = availableTickets;
    }
    
    public int getOrganizerId() {
        return organizerId;
    }
    
    public void setOrganizerId(int organizerId) {
        this.organizerId = organizerId;
    }
    
    public EventStatus getStatus() {
        return status;
    }
    
    public void setStatus(EventStatus status) {
        this.status = status;
    }
    
    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
    
    public boolean isAvailable() {
        return this.status == EventStatus.ACTIVE && this.availableTickets > 0;
    }
    
    public boolean decrementTickets(int quantity) {
        if (this.availableTickets >= quantity) {
            this.availableTickets -= quantity;
            return true;
        }
        return false;
    }
    
    public String getFormattedDate() {
        if (eventDate == null) return "";
        return eventDate.format(DateTimeFormatter.ofPattern("MMMM dd, yyyy"));
    }
    
    public String getFormattedTime() {
        if (eventTime == null) return "";
        return eventTime.format(DateTimeFormatter.ofPattern("hh:mm a"));
    }
    
    @Override
    public String toString() {
        return "Event{" +
                "id=" + id +
                ", eventName='" + eventName + '\'' +
                ", eventDate=" + eventDate +
                ", venue='" + venue + '\'' +
                ", status=" + status +
                '}';
    }
}
