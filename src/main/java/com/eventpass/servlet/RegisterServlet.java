package com.eventpass.servlet;

import com.eventpass.model.User;
import com.eventpass.model.User.UserRole;
import com.eventpass.model.UserDatabase;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

public class RegisterServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String roleStr = request.getParameter("role");
        
        if (username == null || username.trim().isEmpty() ||
            password == null || password.trim().isEmpty() ||
            fullName == null || fullName.trim().isEmpty() ||
            email == null || email.trim().isEmpty()) {
            
            request.setAttribute("error", "All fields are required");
            forwardWithData(request, response, username, fullName, email, roleStr);
            return;
        }
        
        username = username.trim();
        password = password.trim();
        fullName = fullName.trim();
        email = email.trim();
        
        if (password.length() < 6) {
            request.setAttribute("error", "Password must be at least 6 characters");
            forwardWithData(request, response, username, fullName, email, roleStr);
            return;
        }
        
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match");
            forwardWithData(request, response, username, fullName, email, roleStr);
            return;
        }
        
        if (UserDatabase.userExists(username)) {
            request.setAttribute("error", "Username already exists");
            forwardWithData(request, response, null, fullName, email, roleStr);
            return;
        }
        
        if (UserDatabase.emailExists(email)) {
            request.setAttribute("error", "Email already registered");
            forwardWithData(request, response, username, fullName, null, roleStr);
            return;
        }
        
        UserRole role = UserRole.ATTENDEE;
        if (roleStr != null && roleStr.equals("ORGANIZER")) {
            role = UserRole.ORGANIZER;
        }
        
        User newUser = new User(username, password, fullName, email, role);
        
        if (UserDatabase.registerUser(newUser)) {
            request.setAttribute("success", "Registration successful! Please login.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Registration failed. Please try again.");
            forwardWithData(request, response, username, fullName, email, roleStr);
        }
    }
    
    private void forwardWithData(HttpServletRequest request, HttpServletResponse response,
                                  String username, String fullName, String email, String role) 
            throws ServletException, IOException {
        request.setAttribute("username", username);
        request.setAttribute("fullName", fullName);
        request.setAttribute("email", email);
        request.setAttribute("role", role);
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }
}
