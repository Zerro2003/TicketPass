package com.eventpass.servlet;

import com.eventpass.model.Ticket;
import com.eventpass.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;

public class VerificationServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        processRequest(request, response);
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        if (request.getAttribute("ticket") == null) {
            response.sendRedirect(request.getContextPath() + "/booking.jsp");
            return;
        }
        processRequest(request, response);
    }
    
    private void processRequest(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        Ticket ticket = (Ticket) request.getAttribute("ticket");
        User user = (User) request.getAttribute("user");
        
        if (ticket == null) {
            response.sendRedirect(request.getContextPath() + "/booking.jsp");
            return;
        }
        
        if (user == null) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                user = (User) session.getAttribute("user");
            }
        }
        
        ticket.verify();
        
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.setAttribute("lastBookedTicket", ticket);
        }
        
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        out.println("<!DOCTYPE html>");
        out.println("<html lang=\"en\">");
        out.println("<head>");
        out.println("    <meta charset=\"UTF-8\">");
        out.println("    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">");
        out.println("    <title>Ticket Confirmed - EventPass</title>");
        out.println("    <link rel=\"stylesheet\" href=\"css/style.css\">");
        out.println("    <style>");
        out.println("        .confirmation-container { max-width: 600px; margin: 50px auto; padding: 40px; }");
        out.println("        .ticket-card { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); ");
        out.println("                        border-radius: 20px; padding: 40px; color: white; ");
        out.println("                        box-shadow: 0 20px 60px rgba(102, 126, 234, 0.4); }");
        out.println("        .ticket-header { text-align: center; margin-bottom: 30px; }");
        out.println("        .ticket-header h1 { font-size: 2rem; margin-bottom: 10px; }");
        out.println("        .ticket-header .checkmark { font-size: 4rem; margin-bottom: 20px; }");
        out.println("        .ticket-id { background: rgba(255,255,255,0.2); padding: 15px 30px; ");
        out.println("                     border-radius: 50px; font-size: 1.5rem; font-weight: bold; ");
        out.println("                     display: inline-block; letter-spacing: 3px; }");
        out.println("        .ticket-details { background: rgba(255,255,255,0.1); border-radius: 15px; ");
        out.println("                          padding: 25px; margin: 25px 0; }");
        out.println("        .detail-row { display: flex; justify-content: space-between; ");
        out.println("                      padding: 12px 0; border-bottom: 1px solid rgba(255,255,255,0.2); }");
        out.println("        .detail-row:last-child { border-bottom: none; }");
        out.println("        .detail-label { opacity: 0.8; font-size: 0.9rem; }");
        out.println("        .detail-value { font-weight: bold; text-align: right; }");
        out.println("        .status-badge { background: #4CAF50; padding: 8px 20px; border-radius: 20px; ");
        out.println("                        font-weight: bold; text-transform: uppercase; font-size: 0.85rem; }");
        out.println("        .collaboration-info { background: #f8f9fa; border-radius: 15px; padding: 25px; ");
        out.println("                               margin-top: 30px; color: #333; }");
        out.println("        .collaboration-info h3 { color: #667eea; margin-bottom: 15px; }");
        out.println("        .collaboration-info code { background: #e9ecef; padding: 3px 8px; ");
        out.println("                                    border-radius: 4px; font-size: 0.9rem; }");
        out.println("        .btn-home { display: inline-block; margin-top: 25px; padding: 15px 40px; ");
        out.println("                    background: white; color: #667eea; text-decoration: none; ");
        out.println("                    border-radius: 50px; font-weight: bold; transition: all 0.3s; }");
        out.println("        .btn-home:hover { transform: translateY(-3px); box-shadow: 0 10px 30px rgba(0,0,0,0.2); }");
        out.println("        .btn-logout { background: transparent; border: 2px solid white; color: white; ");
        out.println("                      margin-left: 15px; }");
        out.println("        .btn-logout:hover { background: white; color: #667eea; }");
        out.println("    </style>");
        out.println("</head>");
        out.println("<body>");
        out.println("    <div class=\"confirmation-container\">");
        out.println("        <div class=\"ticket-card\">");
        out.println("            <div class=\"ticket-header\">");
        out.println("                <div class=\"checkmark\">✓</div>");
        out.println("                <h1>Booking Confirmed!</h1>");
        out.println("                <div class=\"ticket-id\">" + ticket.getTicketId() + "</div>");
        out.println("            </div>");
        out.println("            <div class=\"ticket-details\">");
        out.println("                <div class=\"detail-row\">");
        out.println("                    <span class=\"detail-label\">Event</span>");
        out.println("                    <span class=\"detail-value\">" + ticket.getEventName() + "</span>");
        out.println("                </div>");
        out.println("                <div class=\"detail-row\">");
        out.println("                    <span class=\"detail-label\">Date</span>");
        out.println("                    <span class=\"detail-value\">" + ticket.getEventDate() + "</span>");
        out.println("                </div>");
        out.println("                <div class=\"detail-row\">");
        out.println("                    <span class=\"detail-label\">Venue</span>");
        out.println("                    <span class=\"detail-value\">" + ticket.getEventVenue() + "</span>");
        out.println("                </div>");
        out.println("                <div class=\"detail-row\">");
        out.println("                    <span class=\"detail-label\">Attendee</span>");
        out.println("                    <span class=\"detail-value\">" + ticket.getAttendeeName() + "</span>");
        out.println("                </div>");
        out.println("                <div class=\"detail-row\">");
        out.println("                    <span class=\"detail-label\">Booked At</span>");
        out.println("                    <span class=\"detail-value\">" + ticket.getFormattedBookingTime() + "</span>");
        out.println("                </div>");
        out.println("                <div class=\"detail-row\">");
        out.println("                    <span class=\"detail-label\">Status</span>");
        out.println("                    <span class=\"detail-value\"><span class=\"status-badge\">" + ticket.getStatus() + "</span></span>");
        out.println("                </div>");
        out.println("            </div>");
        out.println("            <div style=\"text-align: center;\">");
        out.println("                <a href=\"dashboard.jsp\" class=\"btn-home\">View Dashboard</a>");
        out.println("                <a href=\"booking.jsp\" class=\"btn-home\" style=\"margin-left: 15px;\">Book Another</a>");
        out.println("                <a href=\"logout\" class=\"btn-home btn-logout\">Logout</a>");
        out.println("            </div>");
        out.println("        </div>");
        out.println();
        out.println("        <div class=\"collaboration-info\">");
        out.println("            <h3>🔄 Servlet Collaboration Demonstrated</h3>");
        out.println("            <p><strong>Data Flow:</strong></p>");
        out.println("            <ol>");
        out.println("                <li><code>BookingServlet</code> created the ticket and used <code>request.setAttribute(\"ticket\", ticket)</code></li>");
        out.println("                <li><code>BookingServlet</code> called <code>RequestDispatcher.forward()</code> to pass control</li>");
        out.println("                <li><code>VerificationServlet</code> retrieved data using <code>request.getAttribute(\"ticket\")</code></li>");
        out.println("            </ol>");
        out.println("            <p><strong>Note:</strong> The browser URL is still <code>/booking</code> because forward() is server-side!</p>");
        out.println("        </div>");
        out.println("    </div>");
        out.println("</body>");
        out.println("</html>");
    }
}
