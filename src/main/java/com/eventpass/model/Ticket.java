package com.eventpass.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.UUID;

public class Ticket {
    
    public enum TicketStatus {
        PENDING,
        VERIFIED,
        CANCELLED
    }
    
    public enum TicketType {
        REGULAR,
        VIP,
        VVIP
    }
    
    private int id;
    private String ticketCode;
    private int userId;
    private int eventId;
    private TicketType ticketType;
    private int quantity;
    private BigDecimal unitPrice;
    private BigDecimal totalPrice;
    private LocalDateTime bookingTime;
    private TicketStatus status;
    
    private String eventName;
    private String eventDate;
    private String eventVenue;
    private String attendeeName;
    private String attendeeEmail;
    
    public Ticket() {
        this.ticketCode = generateTicketCode();
        this.bookingTime = LocalDateTime.now();
        this.status = TicketStatus.PENDING;
        this.ticketType = TicketType.REGULAR;
        this.quantity = 1;
    }
    
    public Ticket(int userId, int eventId, TicketType ticketType, int quantity, BigDecimal unitPrice) {
        this();
        this.userId = userId;
        this.eventId = eventId;
        this.ticketType = ticketType;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
        this.totalPrice = unitPrice.multiply(BigDecimal.valueOf(quantity));
    }
    
    private String generateTicketCode() {
        String uuid = UUID.randomUUID().toString().replace("-", "").substring(0, 8).toUpperCase();
        return "EP-" + uuid;
    }
    
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public String getTicketCode() {
        return ticketCode;
    }
    
    public void setTicketCode(String ticketCode) {
        this.ticketCode = ticketCode;
    }
    
    public String getTicketId() {
        return ticketCode;
    }
    
    public void setTicketId(String ticketId) {
        this.ticketCode = ticketId;
    }
    
    public int getUserId() {
        return userId;
    }
    
    public void setUserId(int userId) {
        this.userId = userId;
    }
    
    public int getEventId() {
        return eventId;
    }
    
    public void setEventId(int eventId) {
        this.eventId = eventId;
    }
    
    public TicketType getTicketType() {
        return ticketType;
    }
    
    public void setTicketType(TicketType ticketType) {
        this.ticketType = ticketType;
    }
    
    public int getQuantity() {
        return quantity;
    }
    
    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }
    
    public BigDecimal getUnitPrice() {
        return unitPrice;
    }
    
    public void setUnitPrice(BigDecimal unitPrice) {
        this.unitPrice = unitPrice;
    }
    
    public BigDecimal getTotalPrice() {
        return totalPrice;
    }
    
    public void setTotalPrice(BigDecimal totalPrice) {
        this.totalPrice = totalPrice;
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
    
    public void cancel() {
        this.status = TicketStatus.CANCELLED;
    }
    
    public boolean isPending() {
        return this.status == TicketStatus.PENDING;
    }
    
    public boolean isVerified() {
        return this.status == TicketStatus.VERIFIED;
    }
    
    public boolean isCancelled() {
        return this.status == TicketStatus.CANCELLED;
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
    
    public String getTicketTypeBadgeClass() {
        switch (ticketType) {
            case VIP:
                return "badge-vip";
            case VVIP:
                return "badge-vvip";
            default:
                return "badge-regular";
        }
    }
    
    public String getStatusBadgeClass() {
        switch (status) {
            case VERIFIED:
                return "badge-verified";
            case CANCELLED:
                return "badge-cancelled";
            default:
                return "badge-pending";
        }
    }
    
    @Override
    public String toString() {
        return "Ticket{" +
                "id=" + id +
                ", ticketCode='" + ticketCode + '\'' +
                ", ticketType=" + ticketType +
                ", status=" + status +
                '}';
    }
}
