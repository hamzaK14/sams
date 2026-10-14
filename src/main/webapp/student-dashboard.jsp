<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.college.attendance.model.Student" %>
<%@ page import="com.college.attendance.model.Subject" %>
<%@ page import="com.college.attendance.model.Attendance" %>
<%
    Student student = (Student) session.getAttribute("loggedUser");
    List<Subject> subjectSummary = (List<Subject>) request.getAttribute("subjectSummary");
    List<Attendance> attendanceHistory = (List<Attendance>) request.getAttribute("attendanceHistory");

    int totalHeld = 0;
    int totalAttended = 0;
    int below75Count = 0;
    Subject worstSubject = null;

    if (subjectSummary != null) {
        for (Subject sub : subjectSummary) {
            totalHeld += sub.getTotalClassesHeld();
            totalAttended += sub.getClassesAttended();
            if (sub.getAttendancePercentage() < 75.0) {
                below75Count++;
                if (worstSubject == null || sub.getAttendancePercentage() < worstSubject.getAttendancePercentage()) {
                    worstSubject = sub;
                }
            }
        }
    }
    int overallPct = totalHeld > 0 ? (int) Math.round(((double) totalAttended / totalHeld) * 100.0) : 100;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
    <title>SAMS — Student Portal</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>

<div class="hd">
    <a href="#" class="brand">SAMS<i>.</i></a>
    <nav>
        <a href="#top" class="on">My dashboard</a>
        <a href="#subjects">My subjects</a>
        <a href="#calendar">History</a>
        <a href="#calculator">Calculator</a>
    </nav>
    <div class="usr">
        Signed in as <b><%= student != null ? student.getName() : "Student" %></b> · Student
        <a href="<%= request.getContextPath() %>/login?logout=true">Logout</a>
    </div>
</div>

<div class="main" id="top">

    <!-- Header & Overall Attendance -->
    <div style="display: flex; justify-content: space-between; align-items: flex-end; flex-wrap: wrap; gap: 16px; margin-bottom: 18px;">
        <div>
            <h1>Hi, <%= student != null ? student.getName().split(" ")[0] : "Student" %></h1>
            <p class="sub" style="margin-bottom: 0;">
                <%= student != null ? student.getRollNumber() : "" %> · Semester <%= student != null ? student.getSemester() : "" %> · <%= student != null ? student.getEmail() : "" %>
            </p>
        </div>
        <div style="text-align: right;">
            <b style="font: 900 48px/1 var(--hf); letter-spacing: -.04em; color: <%= overallPct < 75 ? "var(--bad)" : "#111" %>;"><%= overallPct %>%</b>
            <div class="mu" style="font-size: 12px;">Overall attendance</div>
        </div>
    </div>

    <!-- Dynamic Risk Warning Banner -->
    <% if (worstSubject != null) { %>
        <div class="alert">
            <%= worstSubject.getSubjectName() %> is at <%= worstSubject.getAttendancePercentage() %>%. 
            Attend the next <b><%= worstSubject.getClassesNeededForTarget(75.0) %></b> lectures in a row to get back to 75%.
        </div>
    <% } else { %>
        <div class="alert g">
            All subjects are at or above the 75% attendance threshold. Keep it up!
        </div>
    <% } %>

    <!-- 4-Column Swiss Stats -->
    <div class="stats">
        <div>
            <b><%= subjectSummary != null ? subjectSummary.size() : 0 %></b>
            <span>Enrolled subjects</span>
        </div>
        <div>
            <b><%= totalAttended %>/<%= totalHeld %></b>
            <span>Lectures attended</span>
        </div>
        <div>
            <b><%= overallPct %>%</b>
            <span>Overall rate</span>
        </div>
        <div>
            <b class="<%= below75Count > 0 ? "bad" : "ok" %>"><%= below75Count %></b>
            <span>Below 75%</span>
        </div>
    </div>

    <!-- 2-Column Split: My Subjects & Monthly Calendar Grid -->
    <div class="g2" id="subjects">
        
        <!-- Left: My Subjects Table -->
        <div>
            <h2>My subjects</h2>
            <div class="table-wrap">
                <table class="t">
                    <thead>
                        <tr>
                            <th>Subject</th>
                            <th>Present</th>
                            <th>Attendance</th>
                            <th class="r">Status</th>
                        </tr>
                    </thead>
                    <tbody>
                    <% if (subjectSummary != null) {
                        for (Subject sub : subjectSummary) {
                            double pct = sub.getAttendancePercentage();
                            String color = sub.getRiskStatusColor(); // GREEN, YELLOW, RED
                            int needed = sub.getClassesNeededForTarget(75.0);
                            String barClass = color.equals("RED") ? "m l" : (color.equals("YELLOW") ? "m w" : "m");
                            String textClass = color.equals("RED") ? "bad" : (color.equals("YELLOW") ? "warn" : "ok");
                    %>
                        <tr>
                            <td class="n">
                                <%= sub.getSubjectName() %>
                                <% if (needed > 0) { %>
                                    <div class="mu" style="font-size: 11px; font-weight: 400;">Need +<%= needed %> in a row for 75%</div>
                                <% } %>
                            </td>
                            <td><%= sub.getClassesAttended() %>/<%= sub.getTotalClassesHeld() %></td>
                            <td>
                                <span class="<%= barClass %>"><i style="width: <%= Math.min(pct, 100.0) %>%;"></i></span>
                                <b><%= Math.round(pct) %>%</b>
                            </td>
                            <td class="r <%= textClass %>">
                                <%= color.equals("GREEN") ? "GOOD" : (color.equals("YELLOW") ? "WARN" : "LOW") %>
                            </td>
                        </tr>
                    <%  }
                    } %>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Right: 7-Column Attendance Calendar Grid & History -->
        <div id="calendar">
            <h2>Attendance calendar</h2>
            <div class="cal">
                <span>M</span><span>T</span><span>W</span><span>T</span><span>F</span><span>S</span><span>S</span>
                <% 
                // Render recent attendance sessions inside the 7-column Swiss calendar grid
                if (attendanceHistory != null && !attendanceHistory.isEmpty()) {
                    int idx = 1;
                    for (Attendance att : attendanceHistory) {
                        boolean isPresent = "PRESENT".equalsIgnoreCase(att.getStatus());
                %>
                        <i class="<%= isPresent ? "p" : "a" %>" title="<%= att.getAttendanceDate() %> - <%= att.getSubjectName() %> (<%= att.getStatus() %>)">
                            <%= idx++ %>
                        </i>
                <%  }
                    // Pad remaining cells up to 14 for clean grid visuals
                    while (idx <= 14) { %>
                        <i class="z"><%= idx++ %></i>
                <%  }
                } else {
                    for (int i = 1; i <= 14; i++) { %>
                        <i><%= i %></i>
                <%  }
                } %>
            </div>
            <p class="mu" style="font-size: 12px; margin-bottom: 18px;">
                <span class="ok">■ Present</span> &nbsp; <span class="bad">■ Absent</span> &nbsp; <span>■ No lecture</span>
            </p>

            <h2>Recent history</h2>
            <div class="table-wrap">
                <table class="t">
                    <thead>
                        <tr>
                            <th>Date</th>
                            <th>Subject</th>
                            <th class="r">Status</th>
                        </tr>
                    </thead>
                    <tbody>
                    <% if (attendanceHistory != null && !attendanceHistory.isEmpty()) {
                        for (Attendance att : attendanceHistory) {
                            boolean isP = "PRESENT".equalsIgnoreCase(att.getStatus());
                    %>
                        <tr>
                            <td><%= att.getAttendanceDate() %></td>
                            <td class="n"><%= att.getSubjectName() %></td>
                            <td class="r <%= isP ? "ok" : "bad" %>"><%= att.getStatus() %></td>
                        </tr>
                    <%  }
                    } else { %>
                        <tr><td colspan="3" class="mu">No attendance records logged yet.</td></tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
        </div>

    </div>

    <!-- Calculator Section (Screen 13 from SAMS-UI-Showcase.pdf) -->
    <div id="calculator" style="margin-top: 10px;">
        <h1>Calculator</h1>
        <p class="sub">Know exactly what you need to attend.</p>

        <div class="g2">
            <!-- Left: Subject Selector & What-If Inputs -->
            <div>
                <h2>What if I attend or miss lectures?</h2>
                <div style="margin-bottom: 12px;">
                    <label class="lb">Select subject</label>
                    <select id="calcSubjectSelect" class="f" onchange="simulateAttendance()">
                        <% if (subjectSummary != null) {
                            for (Subject sub : subjectSummary) { %>
                                <option value="<%= sub.getSubjectId() %>"
                                        data-attended="<%= sub.getClassesAttended() %>"
                                        data-total="<%= sub.getTotalClassesHeld() %>">
                                    <%= sub.getSubjectCode() %> · <%= sub.getSubjectName() %> (<%= sub.getClassesAttended() %>/<%= sub.getTotalClassesHeld() %> — <%= Math.round(sub.getAttendancePercentage()) %>%)
                                </option>
                        <%  }
                        } %>
                    </select>
                </div>

                <div class="g2" style="gap: 14px; margin-bottom: 14px;">
                    <div>
                        <label class="lb">Lectures I will attend</label>
                        <input type="number" id="futureAttendInput" class="f" value="3" min="0" oninput="simulateAttendance()">
                    </div>
                    <div>
                        <label class="lb">Lectures I will miss</label>
                        <input type="number" id="futureSkipInput" class="f" value="0" min="0" oninput="simulateAttendance()">
                    </div>
                </div>

                <button type="button" class="btn" onclick="simulateAttendance()">Calculate</button>
            </div>

            <!-- Right: Giant Swiss Typography Output -->
            <div>
                <h2>Projection result</h2>
                <div id="simulationResult" style="padding-top: 8px;"></div>
            </div>
        </div>
    </div>

</div>

<script src="<%= request.getContextPath() %>/js/calculator.js"></script>
<script>
    window.onload = simulateAttendance;
</script>
</body>
</html>