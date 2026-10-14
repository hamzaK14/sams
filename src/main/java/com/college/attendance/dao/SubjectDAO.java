package com.college.attendance.dao;

import com.college.attendance.model.Subject;
import com.college.attendance.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SubjectDAO {

    public boolean addSubject(Subject subject) {
        String sql = "INSERT INTO subjects (subject_code, subject_name, professor_id) VALUES (?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, subject.getSubjectCode());
            pstmt.setString(2, subject.getSubjectName());
            pstmt.setInt(3, subject.getProfessorId());
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Subject> getAllSubjects() {
        List<Subject> subjects = new ArrayList<>();
        String sql = "SELECT * FROM subjects ORDER BY subject_code ASC";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                subjects.add(new Subject(
                    rs.getInt("subject_id"),
                    rs.getString("subject_code"),
                    rs.getString("subject_name"),
                    rs.getInt("professor_id")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return subjects;
    }

    public List<Subject> getStudentSubjectAttendance(int studentId) {
        List<Subject> subjects = new ArrayList<>();
        String sql = "SELECT s.subject_id, s.subject_code, s.subject_name, s.professor_id, " +
                     "(SELECT COUNT(*) FROM attendance a WHERE a.subject_id = s.subject_id AND a.student_id = ?) AS total_held, " +
                     "(SELECT COUNT(*) FROM attendance a WHERE a.subject_id = s.subject_id AND a.student_id = ? AND a.status = 'PRESENT') AS total_attended " +
                     "FROM subjects s ORDER BY s.subject_code ASC";
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
            e.printStackTrace();
        }
        return subjects;
    }
}