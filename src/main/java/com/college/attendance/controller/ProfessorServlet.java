package com.college.attendance.controller;

import com.college.attendance.dao.AttendanceDAO;
import com.college.attendance.dao.StudentDAO;
import com.college.attendance.dao.SubjectDAO;
import com.college.attendance.model.Attendance;
import com.college.attendance.model.Student;
import com.college.attendance.model.Subject;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Date;
import java.util.List;

/**
 * Controller for the Professor Dashboard.
 * Handles displaying student lists and saving daily attendance records.
 */
@WebServlet("/professor")
public class ProfessorServlet extends HttpServlet {
    private StudentDAO studentDAO = new StudentDAO();
    private SubjectDAO subjectDAO = new SubjectDAO();
    private AttendanceDAO attendanceDAO = new AttendanceDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Security Check: Ensure only logged-in professors can access
        HttpSession session = request.getSession(false);
        if (session == null || !"PROFESSOR".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        List<Student> students = studentDAO.getAllStudents();
        List<Subject> subjects = subjectDAO.getAllSubjects();

        request.setAttribute("studentList", students);
        request.setAttribute("subjectList", subjects);
        request.getRequestDispatcher("/professor-dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int subjectId = Integer.parseInt(request.getParameter("subjectId"));
            Date attendanceDate = Date.valueOf(request.getParameter("attendanceDate")); // Format: YYYY-MM-DD
            List<Student> students = studentDAO.getAllStudents();
            int markedCount = 0;

            // Loop through every student and read their radio button status (status_1, status_2, etc.)
            for (Student s : students) {
                String status = request.getParameter("status_" + s.getId());
                if (status != null) {
                    Attendance att = new Attendance(0, s.getId(), subjectId, attendanceDate, status);
                    if (attendanceDAO.markAttendance(att)) {
                        markedCount++;
                    }
                }
            }
            request.setAttribute("successMessage", "Attendance saved successfully for " + markedCount + " students!");
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Error marking attendance: " + e.getMessage());
            e.printStackTrace();
        }
        // Reload dashboard data after form submission
        doGet(request, response);
    }
}
