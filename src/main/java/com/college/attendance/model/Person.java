package com.college.attendance.model;

/**
 * Abstract base class representing a generic person in the college system.
 * Demonstrates OOP Inheritance (reusing common attributes) and Encapsulation (private fields).
 */
public abstract class Person {
    // Protected or Private fields encapsulated with public Getters and Setters
    private int id;
    private String name;
    private String email;
    private String password;
    private String role; // Either "STUDENT" or "PROFESSOR"

    // Default Constructor
    public Person() {
    }

    // Parameterized Constructor
    public Person(int id, String name, String email, String password, String role) {
        this.id = id;
        this.name = name;
        this.email = email;
        this.password = password;
        this.role = role;
    }

    // Abstract method that child classes MUST implement (Demonstrates Polymorphism)
    public abstract String getDisplayDetails();

    // Standard Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }
}
