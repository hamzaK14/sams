<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>SAMS - Login</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
    <div class="container" style="max-width: 420px; margin-top: 80px;">
        <div class="card">
            <h2 style="text-align: center;">SAMS Portal Login</h2>
            <p style="text-align: center; color: #64748b;">Student Attendance & Academic Management</p>

            <% if (request.getAttribute("errorMessage") != null) { %>
                <p style="color: #dc2626; font-weight: bold; text-align: center;">
                    <%= request.getAttribute("errorMessage") %>
                </p>
            <% } %>

            <form action="<%= request.getContextPath() %>/login" method="post">
                <div class="input-group">
                    <label>Login As:</label>
                    <select name="role" required>
                        <option value="STUDENT">Student</option>
                        <option value="PROFESSOR">Professor</option>
                    </select>
                </div>
                <div class="input-group">
                    <label>Email Address:</label>
                    <input type="email" name="email" placeholder="Enter college email" required>
                </div>
                <div class="input-group">
                    <label>Password:</label>
                    <input type="password" name="password" placeholder="Enter password" required>
                </div>
                <button type="submit" class="btn" style="width: 100%;">Sign In</button>
            </form>
        </div>
    </div>
</body>
</html>
