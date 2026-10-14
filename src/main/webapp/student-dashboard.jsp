<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.college.attendance.model.Student" %>
<%@ page import="com.college.attendance.model.Subject" %>
<%@ page import="com.college.attendance.model.Attendance" %>
<%
    Student student = (Student) session.getAttribute("loggedUser");
    List<Subject> subjectSummary = (List<Subject>) request.getAttribute("subjectSummary");
    List<Attendance> attendanceHistory = (List<Attendance>) request.getAttribute("attendanceHistory");
    String activeTab = (String) request.getAttribute("activeTab");
    if (activeTab == null) activeTab = "dashboard";

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
    <a href="<%= request.getContextPath() %>/student?tab=dashboard" class="brand">SAMS<i>.</i></a>
    <nav>
        <a href="<%= request.getContextPath() %>/student?tab=dashboard" class="<%= "dashboard".equals(activeTab) ? "on" : "" %>">My dashboard</a>
        <a href="<%= request.getContextPath() %>/student?tab=subjects" class="<%= "subjects".equals(activeTab) ? "on" : "" %>">My subjects</a>
        <a href="<%= request.getContextPath() %>/student?tab=calculator" class="<%= "calculator".equals(activeTab) ? "on" : "" %>">Calculator</a>
    </nav>
    <div class="usr">
        Signed in as <b><%= student != null ? student.getName() : "Student" %></b> · Student
        <a href="<%= request.getContextPath() %>/login?logout=true">Logout</a>
    </div>
</div>

<div class="main">

    <% if ("dashboard".equals(activeTab)) { %>
        <!-- ================= PAGE 1: STUDENT DASHBOARD & HISTORY ================= -->
        <div style="display: flex; justify-content: space-between; align-items: flex-end; flex-wrap: wrap; gap: 20px; margin-bottom: 24px;">
            <div>
                <h1>Hi, <%= student != null ? student.getName().split(" ")[0] : "Student" %></h1>
                <p class="sub" style="margin-bottom: 0;">
                    <%= student != null ? student.getRollNumber() : "" %> · Semester <%= student != null ? student.getSemester() : "" %> · <%= student != null ? student.getEmail() : "" %>
                </p>
            </div>
            <div style="text-align: right;">
                <b style="font: 900 64px/1 var(--hf); letter-spacing: -.04em; color: <%= overallPct < 75 ? "var(--bad)" : "#111" %>;"><%= overallPct %>%</b>
                <div class="mu" style="font-size: 14px; font-weight: 600;">Overall attendance</div>
            </div>
        </div>

        <% if (worstSubject != null) { %>
            <div class="alert">
                <%= worstSubject.getSubjectName() %> is at <%= worstSubject.getAttendancePercentage() %>%. 
                Attend the next <b><%= worstSubject.getClassesNeededForTarget(75.0) %></b> lectures in a row to get back to 75%.
            </div>
        <% } else { %>
            <div class="alert g">
                All enrolled subjects are at or above the 75% attendance requirement.
            </div>
        <% } %>

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
                <span>Subjects below 75%</span>
            </div>
        </div>

        <div class="g2">
            <!-- Left: Subject Overview & Attendance History Log -->
            <div>
                <h2>Subject overview</h2>
                <div class="table-wrap" style="margin-bottom: 40px;">
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
                                String color = sub.getRiskStatusColor();
                                String barClass = color.equals("RED") ? "m l" : (color.equals("YELLOW") ? "m w" : "m");
                                String textClass = color.equals("RED") ? "bad" : (color.equals("YELLOW") ? "warn" : "ok");
                        %>
                            <tr>
                                <td class="n"><%= sub.getSubjectName() %></td>
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

                <h2>Attendance history</h2>
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

            <!-- Right: Calendar Grid & Quick Links -->
            <div>
                <h2>Attendance calendar</h2>
                <div class="cal">
                    <span>M</span><span>T</span><span>W</span><span>T</span><span>F</span><span>S</span><span>S</span>
                    <% 
                    if (attendanceHistory != null && !attendanceHistory.isEmpty()) {
                        int idx = 1;
                        for (Attendance att : attendanceHistory) {
                            boolean isPresent = "PRESENT".equalsIgnoreCase(att.getStatus());
                    %>
                            <i class="<%= isPresent ? "p" : "a" %>" title="<%= att.getAttendanceDate() %> - <%= att.getSubjectName() %>">
                                <%= idx++ %>
                            </i>
                    <%  }
                        while (idx <= 21) { %>
                            <i class="z"><%= idx++ %></i>
                    <%  }
                    } else {
                        for (int i = 1; i <= 21; i++) { %>
                            <i><%= i %></i>
                    <%  }
                    } %>
                </div>
                <p class="mu" style="font-size: 13px; margin-bottom: 36px;">
                    <span class="ok">■ Present</span> &nbsp;&nbsp; <span class="bad">■ Absent</span> &nbsp;&nbsp; <span>■ No lecture</span>
                </p>

                <h2>Quick actions</h2>
                <div style="display: flex; flex-direction: column; gap: 12px;">
                    <a href="<%= request.getContextPath() %>/student?tab=calculator" class="btn" style="text-align: center;">Open Attendance Calculator</a>
                    <a href="<%= request.getContextPath() %>/student?tab=subjects" class="btn g" style="text-align: center;">View Detailed Subject Breakdown</a>
                </div>
            </div>
        </div>

    <% } else if ("subjects".equals(activeTab)) { %>
        <!-- ================= PAGE 2: DETAILED MY SUBJECTS PAGE ================= -->
        <h1>My subjects</h1>
        <p class="sub">Detailed course breakdown and required consecutive lectures to reach 75%.</p>

        <div class="table-wrap" style="margin-top: 24px;">
            <table class="t">
                <thead>
                    <tr>
                        <th>Code</th>
                        <th>Subject Name</th>
                        <th>Attended / Conducted</th>
                        <th>Attendance Rate</th>
                        <th>Status</th>
                        <th class="r">Action Required for 75%</th>
                    </tr>
                </thead>
                <tbody>
                <% if (subjectSummary != null) {
                    for (Subject sub : subjectSummary) {
                        double pct = sub.getAttendancePercentage();
                        String color = sub.getRiskStatusColor();
                        int needed = sub.getClassesNeededForTarget(75.0);
                        String barClass = color.equals("RED") ? "m l" : (color.equals("YELLOW") ? "m w" : "m");
                        String textClass = color.equals("RED") ? "bad" : (color.equals("YELLOW") ? "warn" : "ok");
                %>
                    <tr>
                        <td class="n"><%= sub.getSubjectCode() %></td>
                        <td class="n"><%= sub.getSubjectName() %></td>
                        <td><%= sub.getClassesAttended() %> / <%= sub.getTotalClassesHeld() %> lectures</td>
                        <td>
                            <span class="<%= barClass %>"><i style="width: <%= Math.min(pct, 100.0) %>%;"></i></span>
                            <b><%= pct %>%</b>
                        </td>
                        <td class="<%= textClass %>">
                            <%= color.equals("GREEN") ? "GOOD (>=75%)" : (color.equals("YELLOW") ? "WARNING (65-74%)" : "LOW (<65%)") %>
                        </td>
                        <td class="r">
                            <% if (needed == 0) { %>
                                <span class="ok">On track</span>
                            <% } else { %>
                                <span class="bad">Attend next <%= needed %> in a row</span>
                            <% } %>
                        </td>
                    </tr>
                <%  }
                } %>
                </tbody>
            </table>
        </div>

    <% } else if ("calculator".equals(activeTab)) { %>
        <!-- ================= PAGE 3: DEDICATED CALCULATOR PAGE ================= -->
        <h1>Calculator</h1>
        <p class="sub">Know exactly what you need to attend or see what happens if you miss upcoming lectures.</p>

        <div class="g2-equal" style="margin-top: 32px;">
            <div>
                <h2>Simulate future lectures</h2>
                <div style="margin-bottom: 18px;">
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

                <div class="g2-equal" style="gap: 20px; margin-bottom: 24px;">
                    <div>
                        <label class="lb">Lectures I will attend</label>
                        <input type="number" id="futureAttendInput" class="f" value="3" min="0" oninput="simulateAttendance()">
                    </div>
                    <div>
                        <label class="lb">Lectures I will miss</label>
                        <input type="number" id="futureSkipInput" class="f" value="0" min="0" oninput="simulateAttendance()">
                    </div>
                </div>

                <button type="button" class="btn" onclick="simulateAttendance()">Calculate projection</button>
            </div>

            <div>
                <h2>Projection result</h2>
                <div id="simulationResult" style="padding-top: 12px;"></div>
            </div>
        </div>

        <script src="<%= request.getContextPath() %>/js/calculator.js"></script>
        <script>
            window.onload = simulateAttendance;
        </script>
    <% } %>

</div>

</body>
</html>