package com.eventpass.servlet;

import com.eventpass.model.User;
import com.eventpass.model.UserDatabase;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

public class ProfileServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        request.getRequestDispatcher("/profile.jsp").forward(request, response);
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
        
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        
        if (fullName == null || fullName.trim().isEmpty() ||
            email == null || email.trim().isEmpty()) {
            request.setAttribute("error", "Full name and email are required");
            request.getRequestDispatcher("/profile.jsp").forward(request, response);
            return;
        }
        
        fullName = fullName.trim();
        email = email.trim();
        
        if (!email.equals(user.getEmail()) && UserDatabase.emailExists(email)) {
            request.setAttribute("error", "Email already in use by another account");
            request.getRequestDispatcher("/profile.jsp").forward(request, response);
            return;
        }
        
        user.setFullName(fullName);
        user.setEmail(email);
        
        if (newPassword != null && !newPassword.trim().isEmpty()) {
            if (currentPassword == null || !currentPassword.equals(user.getPassword())) {
                request.setAttribute("error", "Current password is incorrect");
                request.getRequestDispatcher("/profile.jsp").forward(request, response);
                return;
            }
            
            if (newPassword.length() < 6) {
                request.setAttribute("error", "New password must be at least 6 characters");
                request.getRequestDispatcher("/profile.jsp").forward(request, response);
                return;
            }
            
            if (!newPassword.equals(confirmPassword)) {
                request.setAttribute("error", "New passwords do not match");
                request.getRequestDispatcher("/profile.jsp").forward(request, response);
                return;
            }
            
            user.setPassword(newPassword);
        }
        
        if (UserDatabase.updateUser(user)) {
            session.setAttribute("user", user);
            request.setAttribute("success", "Profile updated successfully");
        } else {
            request.setAttribute("error", "Failed to update profile");
        }
        
        request.getRequestDispatcher("/profile.jsp").forward(request, response);
    }
}
