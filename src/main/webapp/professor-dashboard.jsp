<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.college.attendance.model.Student" %>
<%@ page import="com.college.attendance.model.Subject" %>
<%@ page import="com.college.attendance.model.Professor" %>
<%
    Professor prof = (Professor) session.getAttribute("loggedUser");
    List<Student> studentList = (List<Student>) request.getAttribute("studentList");
    List<Subject> subjectList = (List<Subject>) request.getAttribute("subjectList");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Professor Dashboard - SAMS</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
    <div class="navbar">
        <div><strong>SAMS</strong> | <%= prof != null ? prof.getDisplayDetails() : "Professor" %></div>
        <a href="<%= request.getContextPath() %>/login?logout=true">Logout</a>
    </div>

    <div class="container">
        <% if (request.getAttribute("successMessage") != null) { %>
            <div class="card" style="background-color: #dcfce7; color: #166534; font-weight: bold;">
                <%= request.getAttribute("successMessage") %>
            </div>
        <% } %>

        <div class="card">
            <h2>Mark Daily Attendance</h2>
            <form action="<%= request.getContextPath() %>/professor" method="post">
                <div style="display: flex; gap: 20px; margin-bottom: 15px;">
                    <div class="input-group" style="flex: 1;">
                        <label>Select Subject:</label>
                        <select name="subjectId" required>
                            <% if (subjectList != null) {
                                for (Subject sub : subjectList) { %>
                                    <option value="<%= sub.getSubjectId() %>">
                                        <%= sub.getSubjectCode() %> - <%= sub.getSubjectName() %>
                                    </option>
                            <%  } 
                               } %>
                        </select>
                    </div>
                    <div class="input-group" style="flex: 1;">
                        <label>Select Date:</label>
                        <input type="date" name="attendanceDate" value="<%= java.time.LocalDate.now() %>" required>
                    </div>
                </div>

                <table>
                    <thead>
                        <tr>
                            <th>Roll No</th>
                            <th>Student Name</th>
                            <th>Semester</th>
                            <th>Mark Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (studentList != null && !studentList.isEmpty()) {
                            for (Student s : studentList) { %>
                                <tr>
                                    <td><%= s.getRollNumber() %></td>
                                    <td><%= s.getName() %></td>
                                    <td>Sem <%= s.getSemester() %></td>
                                    <td>
                                        <label style="margin-right: 15px; color: #16a34a; font-weight: bold;">
                                            <input type="radio" name="status_<%= s.getId() %>" value="PRESENT" checked> Present
                                        </label>
                                        <label style="color: #dc2626; font-weight: bold;">
                                            <input type="radio" name="status_<%= s.getId() %>" value="ABSENT"> Absent
                                        </label>
                                    </td>
                                </tr>
                        <%  } 
                           } else { %>
                            <tr><td colspan="4">No students found in the database.</td></tr>
                        <% } %>
                    </tbody>
                </table>

                <button type="submit" class="btn" style="margin-top: 15px;">Submit Attendance</button>
            </form>
        </div>
    </div>
</body>
</html>
