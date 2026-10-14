package com.college.attendance.model;

import com.college.attendance.exception.InvalidAttendanceException;

/**
 * Student Model class that inherits from Person using the 'extends' keyword.
 * Viva Tip: Point out the 'super()' call in the constructor to show how parent attributes are initialized.
 */
public class Student extends Person {
    private String rollNumber;
    private int semester;

    // Default Constructor
    public Student() {
        super();
        this.setRole("STUDENT");
    }

    // Parameterized Constructor
    public Student(int studentId, String rollNumber, String name, String email, String password, int semester) {
        // Calls the parent Person constructor
        super(studentId, name, email, password, "STUDENT");
        this.rollNumber = rollNumber;
        this.semester = semester;
    }

    // Overriding the abstract method from Person (Runtime Polymorphism)
    @Override
    public String getDisplayDetails() {
        return "Student: " + getName() + " | Roll No: " + rollNumber + " | Semester: " + semester;
    }

    // Getters and Setters
    public String getRollNumber() {
        return rollNumber;
    }

    public void setRollNumber(String rollNumber) {
        this.rollNumber = rollNumber;
    }

    public int getSemester() {
        return semester;
    }

    /**
     * Validates that the semester is between 1 and 8 before setting it.
     */
    public void setSemester(int semester) throws InvalidAttendanceException {
        if (semester < 1 || semester > 8) {
            throw new InvalidAttendanceException("Invalid Semester: Must be between 1 and 8.");
        }
        this.semester = semester;
    }
}
