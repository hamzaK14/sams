package com.college.attendance.model;

import com.college.attendance.exception.InvalidAttendanceException;

/**
 * Represents an academic Subject and encapsulates the business logic for
 * calculating attendance percentage, risk badges, and required classes.
 */
public class Subject {
    private int subjectId;
    private String subjectCode;
    private String subjectName;
    private int professorId;

    // Fields used when displaying a student's attendance summary for this subject
    private int totalClassesHeld;
    private int classesAttended;

    public Subject() {
    }

    public Subject(int subjectId, String subjectCode, String subjectName, int professorId) {
        this.subjectId = subjectId;
        this.subjectCode = subjectCode;
        this.subjectName = subjectName;
        this.professorId = professorId;
    }

    // --- CORE BUSINESS LOGIC METHODS FOR DASHBOARD ---

    /**
     * Calculates current attendance percentage rounded to 2 decimal places.
     */
    public double getAttendancePercentage() {
        if (totalClassesHeld == 0) {
            return 100.0; // Default to 100% if no classes have been conducted yet
        }
        double percentage = ((double) classesAttended / totalClassesHeld) * 100.0;
        return Math.round(percentage * 100.0) / 100.0;
    }

    /**
     * Requirement 3: Attendance Risk Indicator
     * Returns color status based on attendance percentage:
     * - GREEN: Greater than or equal to 75%
     * - YELLOW: 65% to 74.99%
     * - RED: Less than 65%
     */
    public String getRiskStatusColor() {
        double percentage = getAttendancePercentage();
        if (percentage >= 75.0) {
            return "GREEN";
        } else if (percentage >= 65.0) {
            return "YELLOW";
        } else {
            return "RED";
        }
    }

    /**
     * Requirement 4: Required Attendance Calculator
     * Calculates how many consecutive future classes a student MUST attend to reach targetPercentage (e.g., 75%).
     * Math formula: ((attended + x) / (total + x)) * 100 >= target
     */
    public int getClassesNeededForTarget(double targetPercentage) {
        if (getAttendancePercentage() >= targetPercentage || targetPercentage >= 100.0) {
            return 0; // Already at or above target
        }
        double targetRatio = targetPercentage / 100.0;
        double numerator = (targetRatio * totalClassesHeld) - classesAttended;
        double denominator = 1.0 - targetRatio;
        // Math.ceil rounds up to the next whole class
        return (int) Math.ceil(numerator / denominator);
    }

    // --- GETTERS AND SETTERS WITH EXCEPTION HANDLING ---

    public int getSubjectId() {
        return subjectId;
    }

    public void setSubjectId(int subjectId) {
        this.subjectId = subjectId;
    }

    public String getSubjectCode() {
        return subjectCode;
    }

    public void setSubjectCode(String subjectCode) {
        this.subjectCode = subjectCode;
    }

    public String getSubjectName() {
        return subjectName;
    }

    public void setSubjectName(String subjectName) {
        this.subjectName = subjectName;
    }

    public int getProfessorId() {
        return professorId;
    }

    public void setProfessorId(int professorId) {
        this.professorId = professorId;
    }

    public int getTotalClassesHeld() {
        return totalClassesHeld;
    }

    public void setTotalClassesHeld(int totalClassesHeld) throws InvalidAttendanceException {
        if (totalClassesHeld < 0) {
            throw new InvalidAttendanceException("Total classes held cannot be negative.");
        }
        this.totalClassesHeld = totalClassesHeld;
    }

    public int getClassesAttended() {
        return classesAttended;
    }

    public void setClassesAttended(int classesAttended) throws InvalidAttendanceException {
        if (classesAttended < 0 || classesAttended > this.totalClassesHeld) {
            throw new InvalidAttendanceException("Classes attended must be between 0 and total classes held.");
        }
        this.classesAttended = classesAttended;
    }
}
