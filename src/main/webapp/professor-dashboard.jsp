<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.college.attendance.model.Student" %>
<%@ page import="com.college.attendance.model.Subject" %>
<%@ page import="com.college.attendance.model.Professor" %>
<%@ page import="com.college.attendance.model.Attendance" %>
<%
    Professor prof = (Professor) session.getAttribute("loggedUser");
    List<Student> studentList = (List<Student>) request.getAttribute("studentList");
    List<Subject> subjectList = (List<Subject>) request.getAttribute("subjectList");
    List<Attendance> allHistory = (List<Attendance>) request.getAttribute("allHistory");
    String activeTab = (String) request.getAttribute("activeTab");
    if (activeTab == null) activeTab = "dashboard";

    int totalStudents = (studentList != null) ? studentList.size() : 0;
    int totalSubjects = (subjectList != null) ? subjectList.size() : 0;
    int totalRecords = (allHistory != null) ? allHistory.size() : 0;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
    <title>SAMS — Faculty Portal</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>

<div class="hd">
    <a href="<%= request.getContextPath() %>/professor?tab=dashboard" class="brand">SAMS<i>.</i></a>
    <nav>
        <a href="<%= request.getContextPath() %>/professor?tab=dashboard" class="<%= "dashboard".equals(activeTab) ? "on" : "" %>">Dashboard</a>
        <a href="<%= request.getContextPath() %>/professor?tab=mark" class="<%= "mark".equals(activeTab) ? "on" : "" %>">Mark attendance</a>
        <a href="<%= request.getContextPath() %>/professor?tab=students" class="<%= "students".equals(activeTab) ? "on" : "" %>">Students</a>
        <a href="<%= request.getContextPath() %>/professor?tab=subjects" class="<%= "subjects".equals(activeTab) ? "on" : "" %>">Subjects</a>
        <a href="<%= request.getContextPath() %>/professor?tab=history" class="<%= "history".equals(activeTab) ? "on" : "" %>">History</a>
    </nav>
    <div class="usr">
        Signed in as <b><%= prof != null ? prof.getName() : "Faculty" %></b> · Faculty
        <a href="<%= request.getContextPath() %>/login?logout=true">Logout</a>
    </div>
</div>

<div class="main">

    <% if (request.getAttribute("successMessage") != null) { %>
        <div class="alert g"><%= request.getAttribute("successMessage") %></div>
    <% } %>
    <% if (request.getAttribute("errorMessage") != null) { %>
        <div class="alert"><%= request.getAttribute("errorMessage") %></div>
    <% } %>

    <% if ("dashboard".equals(activeTab)) { %>
        <!-- ================= PAGE 1: FACULTY DASHBOARD (DEFAULT LANDING) ================= -->
        <div style="display: flex; justify-content: space-between; align-items: flex-end; flex-wrap: wrap; gap: 20px;">
            <div>
                <h1>Dashboard</h1>
                <p class="sub"><%= java.time.LocalDate.now() %> · Academic Overview & Recent Attendance</p>
            </div>
            <div>
                <a href="<%= request.getContextPath() %>/professor?tab=mark" class="btn">Mark attendance</a>
                <a href="<%= request.getContextPath() %>/professor?tab=students" class="btn g">Manage students</a>
            </div>
        </div>

        <div class="stats">
            <div>
                <b><%= totalStudents %></b>
                <span>Students enrolled</span>
            </div>
            <div>
                <b><%= totalSubjects %></b>
                <span>Active subjects</span>
            </div>
            <div>
                <b><%= totalRecords %></b>
                <span>Recorded student logs</span>
            </div>
            <div>
                <b style="color: var(--ac);">75%</b>
                <span>Required threshold</span>
            </div>
        </div>

        <div class="g2">
            <!-- Left: Recent Attendance History -->
            <div>
                <h2>Recent attendance history</h2>
                <div class="table-wrap">
                    <table class="t">
                        <thead>
                            <tr>
                                <th>Date</th>
                                <th>Subject</th>
                                <th>Roll</th>
                                <th>Student</th>
                                <th class="r">Status</th>
                            </tr>
                        </thead>
                        <tbody>
                        <% if (allHistory != null && !allHistory.isEmpty()) {
                            int count = 0;
                            for (Attendance att : allHistory) {
                                if (count++ >= 10) break;
                                boolean isP = "PRESENT".equalsIgnoreCase(att.getStatus());
                        %>
                            <tr>
                                <td><%= att.getAttendanceDate() %></td>
                                <td class="n"><%= att.getSubjectName() %></td>
                                <td><%= att.getRollNumber() %></td>
                                <td class="n"><%= att.getStudentName() %></td>
                                <td class="r <%= isP ? "ok" : "bad" %>"><%= att.getStatus() %></td>
                            </tr>
                        <%  }
                        } else { %>
                            <tr><td colspan="5" class="mu">No attendance records logged yet.</td></tr>
                        <% } %>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Right: Active Courses & Quick Links -->
            <div>
                <h2>Active courses</h2>
                <div class="table-wrap">
                    <table class="t">
                        <thead>
                            <tr>
                                <th>Code</th>
                                <th>Subject</th>
                                <th class="r">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                        <% if (subjectList != null) {
                            for (Subject sub : subjectList) { %>
                            <tr>
                                <td class="n"><%= sub.getSubjectCode() %></td>
                                <td><%= sub.getSubjectName() %></td>
                                <td class="r">
                                    <a href="<%= request.getContextPath() %>/professor?tab=mark" style="color: var(--ac); font-weight: 700; text-decoration: none;">Mark →</a>
                                </td>
                            </tr>
                        <%  }
                        } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

    <% } else if ("mark".equals(activeTab)) { %>
        <!-- ================= PAGE 2: MARK ATTENDANCE ================= -->
        <div style="display: flex; justify-content: space-between; align-items: flex-end; flex-wrap: wrap; gap: 20px; margin-bottom: 12px;">
            <div>
                <h1>Mark attendance</h1>
                <p class="sub">Choose a subject and date, then mark each student.</p>
            </div>
            <div>
                <b id="presentCounter" style="font: 900 44px/1 var(--hf);"><%= totalStudents %> / <%= totalStudents %></b>
                <div class="mu" style="font-size: 13px; text-align: right;">Present in sheet</div>
            </div>
        </div>

        <form action="<%= request.getContextPath() %>/professor" method="post">
            <input type="hidden" name="action" value="markAttendance">

            <div class="g3" style="align-items: end;">
                <div>
                    <label class="lb">Subject</label>
                    <select name="subjectId" class="f" required>
                        <% if (subjectList != null) {
                            for (Subject sub : subjectList) { %>
                                <option value="<%= sub.getSubjectId() %>">
                                    <%= sub.getSubjectCode() %> · <%= sub.getSubjectName() %>
                                </option>
                        <%  }
                        } %>
                    </select>
                </div>
                <div>
                    <label class="lb">Date</label>
                    <input type="date" name="attendanceDate" class="f" value="<%= java.time.LocalDate.now() %>" required>
                </div>
                <div>
                    <button type="button" class="btn g" style="width: 100%;" onclick="markAllStatus('PRESENT')">Mark all present</button>
                </div>
            </div>

            <h2>Student Roll Sheet</h2>
            <div class="table-wrap">
                <table class="t">
                    <thead>
                        <tr>
                            <th>Roll</th>
                            <th>Student</th>
                            <th>Email</th>
                            <th>Semester</th>
                            <th class="r">Status</th>
                        </tr>
                    </thead>
                    <tbody>
                    <% if (studentList != null && !studentList.isEmpty()) {
                        for (Student s : studentList) { %>
                            <tr>
                                <td class="n"><%= s.getRollNumber() %></td>
                                <td class="n"><%= s.getName() %></td>
                                <td class="mu"><%= s.getEmail() %></td>
                                <td>Sem <%= s.getSemester() %></td>
                                <td class="r">
                                    <div class="seg">
                                        <label>
                                            <input type="radio" class="att-radio" name="status_<%= s.getId() %>" value="PRESENT" checked onchange="updatePresentCount()">
                                            <span>Present</span>
                                        </label>
                                        <label>
                                            <input type="radio" class="att-radio" name="status_<%= s.getId() %>" value="ABSENT" onchange="updatePresentCount()">
                                            <span>Absent</span>
                                        </label>
                                    </div>
                                </td>
                            </tr>
                    <%  }
                    } %>
                    </tbody>
                </table>
            </div>

            <div style="margin-top: 28px;">
                <button type="submit" class="btn">Save attendance</button>
                <button type="button" class="btn g" onclick="markAllStatus('PRESENT')">Reset all present</button>
            </div>
        </form>

    <% } else if ("students".equals(activeTab)) { %>
        <!-- ================= PAGE 3: STUDENT DIRECTORY & ADD STUDENT ================= -->
        <h1>Students</h1>
        <p class="sub"><%= totalStudents %> enrolled students · Manage directory or enroll a new student.</p>

        <div class="g2">
            <div>
                <h2>Enrolled students</h2>
                <div class="table-wrap">
                    <table class="t">
                        <thead>
                            <tr>
                                <th>Roll</th>
                                <th>Name</th>
                                <th>Email</th>
                                <th class="r">Sem</th>
                            </tr>
                        </thead>
                        <tbody>
                        <% if (studentList != null) {
                            for (Student s : studentList) { %>
                            <tr>
                                <td class="n"><%= s.getRollNumber() %></td>
                                <td class="n"><%= s.getName() %></td>
                                <td class="mu"><%= s.getEmail() %></td>
                                <td class="r"><%= s.getSemester() %></td>
                            </tr>
                        <%  }
                        } %>
                        </tbody>
                    </table>
                </div>
            </div>

            <div>
                <h2>Add student</h2>
                <form action="<%= request.getContextPath() %>/professor" method="post">
                    <input type="hidden" name="action" value="addStudent">
                    <div style="margin-bottom: 14px;">
                        <label class="lb">Roll Number</label>
                        <input type="text" name="rollNumber" class="f" placeholder="e.g. CS202504" required>
                    </div>
                    <div style="margin-bottom: 14px;">
                        <label class="lb">Full Name</label>
                        <input type="text" name="name" class="f" placeholder="e.g. Rohan Kulkarni" required>
                    </div>
                    <div style="margin-bottom: 14px;">
                        <label class="lb">Institutional Email</label>
                        <input type="email" name="email" class="f" placeholder="rohan@college.edu" required>
                    </div>
                    <div class="g2-equal" style="gap: 16px; margin-bottom: 20px;">
                        <div>
                            <label class="lb">Semester</label>
                            <input type="number" name="semester" class="f" value="4" min="1" max="8" required>
                        </div>
                        <div>
                            <label class="lb">Initial Password</label>
                            <input type="password" name="password" class="f" value="pass123" required>
                        </div>
                    </div>
                    <button type="submit" class="btn">Save student</button>
                </form>
            </div>
        </div>

    <% } else if ("subjects".equals(activeTab)) { %>
        <!-- ================= PAGE 4: SUBJECT MANAGEMENT ================= -->
        <h1>Subjects</h1>
        <p class="sub"><%= totalSubjects %> academic subjects configured.</p>

        <div class="g2">
            <div>
                <h2>Course catalog</h2>
                <div class="table-wrap">
                    <table class="t">
                        <thead>
                            <tr>
                                <th>Code</th>
                                <th>Subject Name</th>
                                <th class="r">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                        <% if (subjectList != null) {
                            for (Subject sub : subjectList) { %>
                            <tr>
                                <td class="n"><%= sub.getSubjectCode() %></td>
                                <td class="n"><%= sub.getSubjectName() %></td>
                                <td class="r">
                                    <a href="<%= request.getContextPath() %>/professor?tab=mark" style="color: var(--ac); font-weight: 700; text-decoration: none;">Mark attendance</a>
                                </td>
                            </tr>
                        <%  }
                        } %>
                        </tbody>
                    </table>
                </div>
            </div>

            <div>
                <h2>Add subject</h2>
                <form action="<%= request.getContextPath() %>/professor" method="post">
                    <input type="hidden" name="action" value="addSubject">
                    <div style="margin-bottom: 16px;">
                        <label class="lb">Subject Code</label>
                        <input type="text" name="subjectCode" class="f" placeholder="e.g. CS404" required>
                    </div>
                    <div style="margin-bottom: 20px;">
                        <label class="lb">Subject Title</label>
                        <input type="text" name="subjectName" class="f" placeholder="e.g. Computer Networks" required>
                    </div>
                    <button type="submit" class="btn">Create subject</button>
                </form>
            </div>
        </div>

    <% } else if ("history".equals(activeTab)) { %>
        <!-- ================= PAGE 5: COMPLETE ATTENDANCE HISTORY ================= -->
        <div style="display: flex; justify-content: space-between; align-items: flex-end; flex-wrap: wrap; gap: 20px; margin-bottom: 20px;">
            <div>
                <h1>History</h1>
                <p class="sub">Complete log of recorded lectures across all subjects. Re-mark any date to update records.</p>
            </div>
            <a href="<%= request.getContextPath() %>/professor?tab=mark" class="btn">Edit / Re-mark lecture</a>
        </div>

        <div class="table-wrap">
            <table class="t">
                <thead>
                    <tr>
                        <th>Date</th>
                        <th>Subject</th>
                        <th>Roll Number</th>
                        <th>Student Name</th>
                        <th class="r">Status</th>
                    </tr>
                </thead>
                <tbody>
                <% if (allHistory != null && !allHistory.isEmpty()) {
                    for (Attendance att : allHistory) {
                        boolean isP = "PRESENT".equalsIgnoreCase(att.getStatus());
                %>
                    <tr>
                        <td><%= att.getAttendanceDate() %></td>
                        <td class="n"><%= att.getSubjectName() %></td>
                        <td><%= att.getRollNumber() %></td>
                        <td class="n"><%= att.getStudentName() %></td>
                        <td class="r <%= isP ? "ok" : "bad" %>"><%= att.getStatus() %></td>
                    </tr>
                <%  }
                } else { %>
                    <tr><td colspan="5" class="mu">No attendance history found.</td></tr>
                <% } %>
                </tbody>
            </table>
        </div>
    <% } %>

</div>

<script>
function markAllStatus(statusVal) {
    const radios = document.querySelectorAll('.att-radio[value="' + statusVal + '"]');
    radios.forEach(r => r.checked = true);
    updatePresentCount();
}

function updatePresentCount() {
    const presentRadios = document.querySelectorAll('.att-radio[value="PRESENT"]:checked');
    const totalStudents = <%= totalStudents %>;
    const counter = document.getElementById('presentCounter');
    if (counter) {
        counter.textContent = presentRadios.length + ' / ' + totalStudents;
    }
}
</script>
</body>
</html>