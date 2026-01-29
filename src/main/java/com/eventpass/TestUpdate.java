package com.eventpass;

import com.eventpass.model.User;
import com.eventpass.model.UserDatabase;

public class TestUpdate {

    public static void main(String[] args) {
        System.out.println("=== Testing UPDATE Operation ===");
        
        // 1. Fetch a user to update (Assuming user with ID 1 exists, e.g., 'john')
        // You might need to adjust the ID if ID 1 doesn't exist.
        int userIdToUpdate = 1; 
        User user = UserDatabase.getUserById(userIdToUpdate);
        
        if (user == null) {
            System.out.println("User with ID " + userIdToUpdate + " not found!");
            // Try fetching by username 'john' as fallback
            user = UserDatabase.getUser("john");
        }

        if (user != null) {
            System.out.println("\n[Before Update]");
            System.out.println(user);
            
            // 2. Modify the user object
            String originalName = user.getFullName();
            String newName = originalName + " (Updated)";
            
            user.setFullName(newName);
            System.out.println("\n... Updating Full Name to: " + newName);
            
            // 3. Perform Update
            boolean success = UserDatabase.updateUser(user);
            
            if (success) {
                System.out.println("Update Status: SUCCESS");
                
                // 4. Verify by re-fetching from database
                User updatedUser = UserDatabase.getUserById(user.getId());
                System.out.println("\n[After Update]");
                System.out.println(updatedUser);
            } else {
                System.out.println("Update Status: FAILED");
            }
            
        } else {
            System.out.println("No user found to test update.");
        }
        
        System.out.println("\n=== Test Complete ===");
    }
}
