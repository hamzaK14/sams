package com.college.attendance.controller;

import com.college.attendance.dao.AttendanceDAO;
import com.college.attendance.dao.StudentDAO;
import com.college.attendance.model.Professor;
import com.college.attendance.model.Student;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * Controller responsible for authenticating Students and Professors.
 * Viva Tip: Explain that HttpSession is used to keep the user logged in across multiple requests.
 */
@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private StudentDAO studentDAO = new StudentDAO();
    private AttendanceDAO attendanceDAO = new AttendanceDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String role = request.getParameter("role"); // "STUDENT" or "PROFESSOR"

        HttpSession session = request.getSession();

        if ("PROFESSOR".equals(role)) {
            Professor prof = attendanceDAO.authenticateProfessor(email, password);
            if (prof != null) {
                session.setAttribute("loggedUser", prof);
                session.setAttribute("role", "PROFESSOR");
                response.sendRedirect(request.getContextPath() + "/professor");
                return;
            }
        } else if ("STUDENT".equals(role)) {
            Student student = studentDAO.authenticateStudent(email, password);
            if (student != null) {
                session.setAttribute("loggedUser", student);
                session.setAttribute("role", "STUDENT");
                response.sendRedirect(request.getContextPath() + "/student");
                return;
            }
        }

        // If authentication fails, send back to login.jsp with an error message
        request.setAttribute("errorMessage", "Invalid email, password, or role selected!");
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Handle Logout if ?logout=true is passed
        if ("true".equals(request.getParameter("logout"))) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.invalidate();
            }
        }
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }
}
