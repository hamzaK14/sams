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

@WebServlet("/student")
public class StudentServlet extends HttpServlet {

    private SubjectDAO subjectDAO = new SubjectDAO();
    private AttendanceDAO attendanceDAO = new AttendanceDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || !"STUDENT".equals(session.getAttribute("role"))) {
            response.setStatus(HttpServletResponse.SC_FOUND);
            response.setHeader("Location", "login.jsp");
            return;
        }

        String tab = request.getParameter("tab");
        if (tab == null || tab.trim().isEmpty()) {
            tab = "dashboard";
        }

        Student loggedStudent = (Student) session.getAttribute("loggedUser");
        List<Subject> subjectSummary = subjectDAO.getStudentSubjectAttendance(loggedStudent.getId());
        List<Attendance> attendanceHistory = attendanceDAO.getAttendanceHistoryByStudent(loggedStudent.getId());

        request.setAttribute("activeTab", tab);
        request.setAttribute("subjectSummary", subjectSummary);
        request.setAttribute("attendanceHistory", attendanceHistory);

        request.getRequestDispatcher("/student-dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}