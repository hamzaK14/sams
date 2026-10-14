package com.college.attendance.dao;

import com.college.attendance.model.Attendance;
import com.college.attendance.model.Professor;
import com.college.attendance.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AttendanceDAO {

    public boolean markAttendance(Attendance attendance) {
        String sql = "INSERT INTO attendance (student_id, subject_id, attendance_date, status) " +
                     "VALUES (?, ?, ?, ?) ON DUPLICATE KEY UPDATE status = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, attendance.getStudentId());
            pstmt.setInt(2, attendance.getSubjectId());
            pstmt.setDate(3, attendance.getAttendanceDate());
            pstmt.setString(4, attendance.getStatus());
            pstmt.setString(5, attendance.getStatus());
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public Professor authenticateProfessor(String email, String password) {
        String sql = "SELECT * FROM professors WHERE email = ? AND password = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, email);
            pstmt.setString(2, password);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return new Professor(
                        rs.getInt("professor_id"),
                        rs.getString("employee_id"),
                        rs.getString("name"),
                        rs.getString("email"),
                        rs.getString("password"),
                        rs.getString("department")
                    );
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Attendance> getAttendanceHistoryByStudent(int studentId) {
        List<Attendance> history = new ArrayList<>();
        String sql = "SELECT a.*, sub.subject_name FROM attendance a " +
                     "JOIN subjects sub ON a.subject_id = sub.subject_id " +
                     "WHERE a.student_id = ? ORDER BY a.attendance_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, studentId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Attendance att = new Attendance(
                        rs.getInt("attendance_id"),
                        rs.getInt("student_id"),
                        rs.getInt("subject_id"),
                        rs.getDate("attendance_date"),
                        rs.getString("status")
                    );
                    att.setSubjectName(rs.getString("subject_name"));
                    history.add(att);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return history;
    }

    public List<Attendance> getAllAttendanceHistory() {
        List<Attendance> history = new ArrayList<>();
        String sql = "SELECT a.*, s.name AS student_name, s.roll_number, sub.subject_name " +
                     "FROM attendance a " +
                     "JOIN students s ON a.student_id = s.student_id " +
                     "JOIN subjects sub ON a.subject_id = sub.subject_id " +
                     "ORDER BY a.attendance_date DESC, s.roll_number ASC LIMIT 60";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                Attendance att = new Attendance(
                    rs.getInt("attendance_id"),
                    rs.getInt("student_id"),
                    rs.getInt("subject_id"),
                    rs.getDate("attendance_date"),
                    rs.getString("status")
                );
                att.setStudentName(rs.getString("student_name"));
                att.setRollNumber(rs.getString("roll_number"));
                att.setSubjectName(rs.getString("subject_name"));
                history.add(att);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return history;
    }
}