<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.college.attendance.model.Student" %>
<%@ page import="com.college.attendance.model.Subject" %>
<%@ page import="com.college.attendance.model.Attendance" %>
<%
    Student student = (Student) session.getAttribute("loggedUser");
    List<Subject> subjectSummary = (List<Subject>) request.getAttribute("subjectSummary");
    List<Attendance> attendanceHistory = (List<Attendance>) request.getAttribute("attendanceHistory");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Student Dashboard - SAMS</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
    <div class="navbar">
        <div><strong>SAMS</strong> | <%= student != null ? student.getDisplayDetails() : "Student" %></div>
        <a href="<%= request.getContextPath() %>/login?logout=true">Logout</a>
    </div>

    <div class="container">
        <!-- 1. Subject Attendance & Risk Indicator Table -->
        <div class="card">
            <h2>My Subject Attendance & Risk Status</h2>
            <table>
                <thead>
                    <tr>
                        <th>Subject Code</th>
                        <th>Subject Name</th>
                        <th>Attended / Total</th>
                        <th>Percentage</th>
                        <th>Risk Indicator</th>
                        <th>75% Target Calculator</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (subjectSummary != null) {
                        for (Subject sub : subjectSummary) { 
                            double pct = sub.getAttendancePercentage();
                            String color = sub.getRiskStatusColor();
                            int needed = sub.getClassesNeededForTarget(75.0);
                    %>
                            <tr>
                                <td><strong><%= sub.getSubjectCode() %></strong></td>
                                <td><%= sub.getSubjectName() %></td>
                                <td><%= sub.getClassesAttended() %> / <%= sub.getTotalClassesHeld() %></td>
                                <td><strong><%= pct %>%</strong></td>
                                <td>
                                    <span class="badge badge-<%= color %>">
                                        <%= color.equals("GREEN") ? "SAFE" : (color.equals("YELLOW") ? "MODERATE RISK" : "HIGH RISK") %>
                                    </span>
                                </td>
                                <td>
                                    <% if (needed == 0) { %>
                                        <span style="color: #16a34a; font-weight: 600;">On Track (>= 75%)</span>
                                    <% } else { %>
                                        Attend next <strong><%= needed %></strong> classes consecutively
                                    <% } %>
                                </td>
                            </tr>
                    <%  } 
                       } %>
                </tbody>
            </table>
        </div>

        <!-- 2. Interactive What-If Attendance Calculator (DOM Manipulation) -->
        <div class="card">
            <h2>Interactive "What-If" Attendance Simulator</h2>
            <p style="color: #64748b;">Test how attending or skipping upcoming lectures will impact your attendance percentage.</p>
            
            <div style="display: flex; gap: 15px; align-items: flex-end; flex-wrap: wrap;">
                <div class="input-group" style="flex: 2; min-width: 220px;">
                    <label>Select Subject:</label>
                    <select id="calcSubjectSelect" onchange="simulateAttendance()">
                        <% if (subjectSummary != null) {
                            for (Subject sub : subjectSummary) { %>
                                <option value="<%= sub.getSubjectId() %>" 
                                        data-attended="<%= sub.getClassesAttended() %>" 
                                        data-total="<%= sub.getTotalClassesHeld() %>">
                                    <%= sub.getSubjectCode() %> - <%= sub.getSubjectName() %> (<%= sub.getAttendancePercentage() %>%)
                                </option>
                        <%  } 
                           } %>
                    </select>
                </div>
                <div class="input-group" style="flex: 1; min-width: 150px;">
                    <label>If I Attend Next (X) Classes:</label>
                    <input type="number" id="futureAttendInput" value="3" min="0" oninput="simulateAttendance()">
                </div>
                <div class="input-group" style="flex: 1; min-width: 150px;">
                    <label>If I Skip Next (Y) Classes:</label>
                    <input type="number" id="futureSkipInput" value="0" min="0" oninput="simulateAttendance()">
                </div>
                <div class="input-group">
                    <button type="button" class="btn" onclick="simulateAttendance()">Calculate Impact</button>
                </div>
            </div>

            <div id="simulationResult"></div>
        </div>

        <!-- 3. Visual Attendance Calendar & Recent Log -->
        <div class="card">
            <h2>Attendance Calendar & Daily Log</h2>
            <div class="calendar-grid">
                <% if (attendanceHistory != null && !attendanceHistory.isEmpty()) {
                    for (Attendance att : attendanceHistory) { %>
                        <div class="cal-day cal-<%= att.getStatus() %>">
                            <strong><%= att.getAttendanceDate() %></strong><br>
                            <span><%= att.getSubjectName() %></span><br>
                            <small>[<%= att.getStatus() %>]</small>
                        </div>
                <%  } 
                   } else { %>
                    <p>No attendance records logged yet.</p>
                <% } %>
            </div>
        </div>
    </div>

    <script src="<%= request.getContextPath() %>/js/calculator.js"></script>
    <script>
        // Run once on load so the student immediately sees a simulation
        window.onload = simulateAttendance;
    </script>
</body>
</html>
