<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
    <title>SAMS — Sign in</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>

<div class="hd">
    <a href="#" class="brand">SAMS<i>.</i></a>
    <div class="usr">Student Attendance Management System</div>
</div>

<div class="main">
    <div class="g2" style="align-items: start; margin-top: 24px;">
        
        <!-- Left Column: Swiss Hero Typography -->
        <div>
            <h1 class="hero-title">Attendance.<br>Tracked.</h1>
            <p class="sub" style="max-width: 38ch; font-size: 15px; margin-top: 16px;">
                Mark lectures, watch percentages and stay above 75%.
            </p>
            <div class="stats" style="grid-template-columns: repeat(2, 1fr); max-width: 320px; margin-top: 28px;">
                <div>
                    <b>75%</b>
                    <span>Minimum threshold</span>
                </div>
                <div>
                    <b style="color: var(--ac);">MVC</b>
                    <span>Servlet · JSP · JDBC</span>
                </div>
            </div>
        </div>

        <!-- Right Column: Sign In Form -->
        <div style="max-width: 400px; width: 100%;">
            <h2>Sign in</h2>
            <p class="sub">Choose your role to continue.</p>

            <% if (request.getAttribute("errorMessage") != null) { %>
                <div class="alert">
                    <%= request.getAttribute("errorMessage") %>
                </div>
            <% } %>

            <form action="<%= request.getContextPath() %>/login" method="post">
                <input type="hidden" name="role" id="roleInput" value="STUDENT">

                <div style="margin-bottom: 18px;">
                    <button type="button" class="chip on" id="chipStudent" onclick="selectRole('STUDENT')">Student</button>
                    <button type="button" class="chip" id="chipProf" onclick="selectRole('PROFESSOR')">Faculty / Admin</button>
                </div>

                <div style="margin-bottom: 14px;">
                    <label class="lb">Email / Username</label>
                    <input type="email" name="email" id="emailInput" class="f" placeholder="hamza@college.edu" required>
                </div>

                <div style="margin-bottom: 18px;">
                    <label class="lb">Password</label>
                    <input type="password" name="password" class="f" placeholder="••••••••" required>
                </div>

                <button type="submit" class="btn" style="width: 100%; padding: 12px;">Sign in</button>

                <p class="mu" style="font-size: 12px; margin-top: 14px;">
                    Demo accounts: <b>hamza@college.edu</b> (Student) / <b>sharma@college.edu</b> (Faculty) · Pass: <b>pass123</b>
                </p>
            </form>
        </div>

    </div>
</div>

<script>
function selectRole(role) {
    document.getElementById('roleInput').value = role;
    document.getElementById('chipStudent').className = (role === 'STUDENT') ? 'chip on' : 'chip';
    document.getElementById('chipProf').className = (role === 'PROFESSOR') ? 'chip on' : 'chip';
    document.getElementById('emailInput').placeholder = (role === 'STUDENT') ? 'hamza@college.edu' : 'sharma@college.edu';
}
</script>
</body>
</html>