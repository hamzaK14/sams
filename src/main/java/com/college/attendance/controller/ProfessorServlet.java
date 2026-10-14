package com.college.attendance.controller;

import com.college.attendance.dao.AttendanceDAO;
import com.college.attendance.dao.StudentDAO;
import com.college.attendance.dao.SubjectDAO;
import com.college.attendance.model.Attendance;
import com.college.attendance.model.Professor;
import com.college.attendance.model.Student;
import com.college.attendance.model.Subject;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Date;
import java.util.List;

@WebServlet("/professor")
public class ProfessorServlet extends HttpServlet {

    private StudentDAO studentDAO = new StudentDAO();
    private SubjectDAO subjectDAO = new SubjectDAO();
    private AttendanceDAO attendanceDAO = new AttendanceDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || !"PROFESSOR".equals(session.getAttribute("role"))) {
            response.setStatus(HttpServletResponse.SC_FOUND);
            response.setHeader("Location", "login.jsp");
            return;
        }

        String tab = request.getParameter("tab");
        if (tab == null || tab.trim().isEmpty()) {
            tab = "dashboard";
        }

        List<Student> students = studentDAO.getAllStudents();
        List<Subject> subjects = subjectDAO.getAllSubjects();
        List<Attendance> allHistory = attendanceDAO.getAllAttendanceHistory();

        request.setAttribute("activeTab", tab);
        request.setAttribute("studentList", students);
        request.setAttribute("subjectList", subjects);
        request.setAttribute("allHistory", allHistory);
        request.getRequestDispatcher("/professor-dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        String redirectTab = "dashboard";

        try {
            if ("addStudent".equals(action)) {
                redirectTab = "students";
                String roll = request.getParameter("rollNumber");
                String name = request.getParameter("name");
                String email = request.getParameter("email");
                String password = request.getParameter("password");
                int sem = Integer.parseInt(request.getParameter("semester"));

                Student newStudent = new Student(0, roll, name, email, password, sem);
                if (studentDAO.addStudent(newStudent)) {
                    request.setAttribute("successMessage", "Student " + name + " (" + roll + ") added successfully.");
                } else {
                    request.setAttribute("errorMessage", "Could not add student. Roll number or email may already exist.");
                }
            } else if ("addSubject".equals(action)) {
                redirectTab = "subjects";
                String code = request.getParameter("subjectCode");
                String name = request.getParameter("subjectName");
                HttpSession session = request.getSession(false);
                Professor prof = (Professor) session.getAttribute("loggedUser");
                int profId = (prof != null) ? prof.getId() : 1;

                Subject newSub = new Subject(0, code, name, profId);
                if (subjectDAO.addSubject(newSub)) {
                    request.setAttribute("successMessage", "Subject " + code + " - " + name + " created.");
                } else {
                    request.setAttribute("errorMessage", "Could not add subject. Code may already exist.");
                }
            } else {
                // Default action: Mark Attendance
                redirectTab = "mark";
                int subjectId = Integer.parseInt(request.getParameter("subjectId"));
                Date attendanceDate = Date.valueOf(request.getParameter("attendanceDate"));
                List<Student> students = studentDAO.getAllStudents();
                int markedCount = 0;

                for (Student s : students) {
                    String status = request.getParameter("status_" + s.getId());
                    if (status != null) {
                        Attendance att = new Attendance(0, s.getId(), subjectId, attendanceDate, status);
                        if (attendanceDAO.markAttendance(att)) {
                            markedCount++;
                        }
                    }
                }
                request.setAttribute("successMessage", "Attendance recorded for " + markedCount + " students on " + attendanceDate + ".");
            }
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Operation failed: " + e.getMessage());
        }

        request.setAttribute("activeTab", redirectTab);
        List<Student> students = studentDAO.getAllStudents();
        List<Subject> subjects = subjectDAO.getAllSubjects();
        List<Attendance> allHistory = attendanceDAO.getAllAttendanceHistory();

        request.setAttribute("studentList", students);
        request.setAttribute("subjectList", subjects);
        request.setAttribute("allHistory", allHistory);
        request.getRequestDispatcher("/professor-dashboard.jsp").forward(request, response);
    }
}