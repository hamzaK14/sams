package com.college.attendance.exception;

/**
 * Custom Checked Exception thrown when invalid data is passed into Attendance or Student models
 * (e.g., negative attendance counts, invalid status strings, or invalid semesters).
 * Viva Tip: Extending the 'Exception' class makes this a Checked Exception, forcing the
 * developer to handle it using try-catch or throws.
 */
public class InvalidAttendanceException extends Exception {
    public InvalidAttendanceException(String errorMessage) {
        // Calls the constructor of the parent java.lang.Exception class
        super(errorMessage);
    }
}
