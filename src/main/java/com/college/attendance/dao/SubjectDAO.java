package com.college.attendance.dao;

import com.college.attendance.model.Subject;
import com.college.attendance.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SubjectDAO {

    public List<Subject> getAllSubjects() {
        List<Subject> subjects = new ArrayList<>();
        String sql = "SELECT * FROM subjects";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                Subject sub = new Subject(
                    rs.getInt("subject_id"),
                    rs.getString("subject_code"),
                    rs.getString("subject_name"),
                    rs.getInt("professor_id")
                );
                subjects.add(sub);
            }
        } catch (SQLException e) {
            System.err.println("Error in getAllSubjects: " + e.getMessage());
            e.printStackTrace();
        }
        return subjects;
    }

    /**
     * Fetches subject details along with computed attendance statistics for a specific student.
     */
    public List<Subject> getStudentSubjectAttendance(int studentId) {
        List<Subject> subjects = new ArrayList<>();
        String sql = "SELECT s.subject_id, s.subject_code, s.subject_name, s.professor_id, " +
                     "(SELECT COUNT(*) FROM attendance a WHERE a.subject_id = s.subject_id AND a.student_id = ?) AS total_held, " +
                     "(SELECT COUNT(*) FROM attendance a WHERE a.subject_id = s.subject_id AND a.student_id = ? AND a.status = 'PRESENT') AS total_attended " +
                     "FROM subjects s";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, studentId);
            pstmt.setInt(2, studentId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Subject sub = new Subject(
                        rs.getInt("subject_id"),
                        rs.getString("subject_code"),
                        rs.getString("subject_name"),
                        rs.getInt("professor_id")
                    );
                    sub.setTotalClassesHeld(rs.getInt("total_held"));
                    sub.setClassesAttended(rs.getInt("total_attended"));
                    subjects.add(sub);
                }
            }
        } catch (Exception e) {
            System.err.println("Error in getStudentSubjectAttendance: " + e.getMessage());
            e.printStackTrace();
        }
        return subjects;
    }
}
