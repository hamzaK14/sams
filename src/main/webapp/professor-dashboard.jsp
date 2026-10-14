<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.college.attendance.model.Student" %>
<%@ page import="com.college.attendance.model.Subject" %>
<%@ page import="com.college.attendance.model.Professor" %>
<%
    Professor prof = (Professor) session.getAttribute("loggedUser");
    List<Student> studentList = (List<Student>) request.getAttribute("studentList");
    List<Subject> subjectList = (List<Subject>) request.getAttribute("subjectList");
    int totalStudents = (studentList != null) ? studentList.size() : 0;
    int totalSubjects = (subjectList != null) ? subjectList.size() : 0;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
    <title>SAMS — Mark Attendance</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>

<div class="hd">
    <a href="#" class="brand">SAMS<i>.</i></a>
    <nav>
        <a href="#overview">Dashboard</a>
        <a href="#mark" class="on">Mark attendance</a>
        <a href="#directory">Students</a>
    </nav>
    <div class="usr">
        Signed in as <b><%= prof != null ? prof.getName() : "Faculty" %></b> · Faculty
        <a href="<%= request.getContextPath() %>/login?logout=true">Logout</a>
    </div>
</div>

<div class="main">

    <% if (request.getAttribute("successMessage") != null) { %>
        <div class="alert g">
            <%= request.getAttribute("successMessage") %>
        </div>
    <% } %>
    <% if (request.getAttribute("errorMessage") != null) { %>
        <div class="alert">
            <%= request.getAttribute("errorMessage") %>
        </div>
    <% } %>

    <h1 id="overview">Mark attendance</h1>
    <p class="sub">Choose a lecture, then mark each student.</p>

    <!-- Top Swiss Metric Row -->
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
            <b id="presentCounter"><%= totalStudents %> / <%= totalStudents %></b>
            <span>Present in current sheet</span>
        </div>
        <div>
            <b style="color: var(--ac);">75%</b>
            <span>Target threshold</span>
        </div>
    </div>

    <!-- Attendance Marking Form -->
    <form action="<%= request.getContextPath() %>/professor" method="post" id="mark">
        <div class="g3" style="margin-bottom: 18px;">
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
                <label class="lb">Quick Action</label>
                <div style="display: flex; gap: 8px;">
                    <button type="button" class="btn g" style="width: 100%;" onclick="markAllStatus('PRESENT')">Mark all present</button>
                </div>
            </div>
        </div>

        <h2>Student Roll Sheet</h2>
        <div class="table-wrap" id="directory">
            <table class="t">
                <thead>
                    <tr>
                        <th>Roll</th>
                        <th>Student</th>
                        <th>Email</th>
                        <th>Sem</th>
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
                } else { %>
                    <tr><td colspan="5">No students found in database.</td></tr>
                <% } %>
                </tbody>
            </table>
        </div>

        <div style="margin-top: 20px;">
            <button type="submit" class="btn">Save attendance</button>
            <button type="button" class="btn g" onclick="markAllStatus('PRESENT')">Reset all present</button>
        </div>
    </form>

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