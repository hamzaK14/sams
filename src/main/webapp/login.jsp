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
    <div class="usr">Student Attendance & Academic Management System</div>
</div>

<div class="main">
    <div class="g2-equal" style="align-items: center; min-height: 70vh;">
        
        <!-- Left Column: Swiss Hero Typography -->
        <div>
            <h1 class="hero-title">Attendance.<br>Tracked.</h1>
            <p class="sub" style="max-width: 42ch; font-size: 18px; margin-top: 20px;">
                Mark lectures, monitor real-time percentages, and stay above the 75% academic requirement.
            </p>
            <div class="stats" style="grid-template-columns: repeat(2, 1fr); max-width: 380px; margin-top: 36px;">
                <div>
                    <b>75%</b>
                    <span>Required threshold</span>
                </div>
                <div>
                    <b style="color: var(--ac);">Live</b>
                    <span>Academic tracking</span>
                </div>
            </div>
        </div>

        <!-- Right Column: Production Sign In Form -->
        <div style="max-width: 460px; width: 100%; margin-left: auto; margin-right: auto;">
            <h2>Sign in</h2>
            <p class="sub">Select your portal role to continue.</p>

            <% if (request.getAttribute("errorMessage") != null) { %>
                <div class="alert">
                    <%= request.getAttribute("errorMessage") %>
                </div>
            <% } %>

            <form action="<%= request.getContextPath() %>/login" method="post">
                <input type="hidden" name="role" id="roleInput" value="STUDENT">

                <div style="margin-bottom: 24px;">
                    <button type="button" class="chip on" id="chipStudent" onclick="selectRole('STUDENT')">Student</button>
                    <button type="button" class="chip" id="chipProf" onclick="selectRole('PROFESSOR')">Faculty</button>
                </div>

                <div style="margin-bottom: 18px;">
                    <label class="lb">Institutional Email</label>
                    <input type="email" name="email" id="emailInput" class="f" placeholder="Enter your college email" required>
                </div>

                <div style="margin-bottom: 24px;">
                    <label class="lb">Password</label>
                    <input type="password" name="password" class="f" placeholder="Enter your password" required>
                </div>

                <button type="submit" class="btn" style="width: 100%; padding: 15px; font-size: 16px;">Sign in</button>
            </form>
        </div>

    </div>
</div>

<script>
function selectRole(role) {
    document.getElementById('roleInput').value = role;
    document.getElementById('chipStudent').className = (role === 'STUDENT') ? 'chip on' : 'chip';
    document.getElementById('chipProf').className = (role === 'PROFESSOR') ? 'chip on' : 'chip';
}
</script>
</body>
</html>