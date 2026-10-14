package com.college.attendance.controller;

import com.college.attendance.dao.AttendanceDAO;
import com.college.attendance.dao.SubjectDAO;
import com.college.attendance.model.Attendance;
import com.college.attendance.model.Student;
import com.college.attendance.model.Subject;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 * Controller for the Student Dashboard.
 * Fetches subject attendance percentages, risk indicators, and daily attendance log.
 */
@WebServlet("/student")
public class StudentServlet extends HttpServlet {
    private SubjectDAO subjectDAO = new SubjectDAO();
    private AttendanceDAO attendanceDAO = new AttendanceDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"STUDENT".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        Student loggedStudent = (Student) session.getAttribute("loggedUser");

        // Fetch subject-wise attendance summary & daily log
        List<Subject> subjectSummary = subjectDAO.getStudentSubjectAttendance(loggedStudent.getId());
        List<Attendance> attendanceHistory = attendanceDAO.getAttendanceHistoryByStudent(loggedStudent.getId());

        request.setAttribute("subjectSummary", subjectSummary);
        request.setAttribute("attendanceHistory", attendanceHistory);
        request.getRequestDispatcher("/student-dashboard.jsp").forward(request, response);
    }
}
