package com.college.attendance.model;

/**
 * Professor Model class inheriting from Person.
 * Demonstrates OOP Inheritance and polymorphism.
 */
public class Professor extends Person {
    private String employeeId;
    private String department;

    public Professor() {
        super();
        this.setRole("PROFESSOR");
    }

    public Professor(int professorId, String employeeId, String name, String email, String password, String department) {
        super(professorId, name, email, password, "PROFESSOR");
        this.employeeId = employeeId;
        this.department = department;
    }

    @Override
    public String getDisplayDetails() {
        return "Prof. " + getName() + " | Dept: " + department + " | Emp ID: " + employeeId;
    }

    public String getEmployeeId() {
        return employeeId;
    }

    public void setEmployeeId(String employeeId) {
        this.employeeId = employeeId;
    }

    public String getDepartment() {
        return department;
    }

    public void setDepartment(String department) {
        this.department = department;
    }
}
