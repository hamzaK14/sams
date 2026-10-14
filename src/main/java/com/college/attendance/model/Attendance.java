package com.college.attendance.model;

import com.college.attendance.exception.InvalidAttendanceException;
import java.sql.Date;

/**
 * Represents a single attendance record for a specific student, subject, and date.
 */
public class Attendance {
    private int attendanceId;
    private int studentId;
    private int subjectId;
    private Date attendanceDate; // java.sql.Date maps directly to MySQL DATE column
    private String status;       // Strictly "PRESENT" or "ABSENT"

    // Optional helper fields for displaying joined data in JSP tables
    private String studentName;
    private String rollNumber;
    private String subjectName;

    public Attendance() {
    }

    public Attendance(int attendanceId, int studentId, int subjectId, Date attendanceDate, String status)
            throws InvalidAttendanceException {
        this.attendanceId = attendanceId;
        this.studentId = studentId;
        this.subjectId = subjectId;
        this.attendanceDate = attendanceDate;
        setStatus(status); // Uses setter to enforce validation
    }

    // Getters and Setters
    public int getAttendanceId() {
        return attendanceId;
    }

    public void setAttendanceId(int attendanceId) {
        this.attendanceId = attendanceId;
    }

    public int getStudentId() {
        return studentId;
    }

    public void setStudentId(int studentId) {
        this.studentId = studentId;
    }

    public int getSubjectId() {
        return subjectId;
    }

    public void setSubjectId(int subjectId) {
        this.subjectId = subjectId;
    }

    public Date getAttendanceDate() {
        return attendanceDate;
    }

    public void setAttendanceDate(Date attendanceDate) {
        this.attendanceDate = attendanceDate;
    }

    public String getStatus() {
        return status;
    }

    /**
     * Validates that status is strictly "PRESENT" or "ABSENT".
     * Throws our custom InvalidAttendanceException if invalid input is given.
     */
    public void setStatus(String status) throws InvalidAttendanceException {
        if (status == null || (!status.equalsIgnoreCase("PRESENT") && !status.equalsIgnoreCase("ABSENT"))) {
            throw new InvalidAttendanceException("Invalid Attendance Status: Must be 'PRESENT' or 'ABSENT'.");
        }
        this.status = status.toUpperCase();
    }

    public String getStudentName() {
        return studentName;
    }

    public void setStudentName(String studentName) {
        this.studentName = studentName;
    }

    public String getRollNumber() {
        return rollNumber;
    }

    public void setRollNumber(String rollNumber) {
        this.rollNumber = rollNumber;
    }

    public String getSubjectName() {
        return subjectName;
    }

    public void setSubjectName(String subjectName) {
        this.subjectName = subjectName;
    }
}
