<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CodeQuest | Register</title>

    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            background: #101827;
            color: #f1f5f9;
            font-family: Arial, sans-serif;
            padding: 20px;
        }

        .register-card {
            width: 100%;
            max-width: 430px;
            padding: 32px;
            background: #1e293b;
            border-radius: 16px;
            box-shadow: 0 12px 35px rgba(0, 0, 0, 0.3);
        }

        .logo {
            text-align: center;
            font-size: 28px;
            font-weight: bold;
            color: #38bdf8;
            margin-bottom: 8px;
        }

        h2 {
            text-align: center;
            margin-bottom: 24px;
        }

        label {
            display: block;
            margin: 14px 0 7px;
            font-size: 14px;
        }

        input, select {
            width: 100%;
            padding: 12px;
            border: 1px solid #475569;
            border-radius: 7px;
            background: #0f172a;
            color: white;
            font-size: 15px;
        }

        button {
            width: 100%;
            margin-top: 22px;
            padding: 13px;
            border: none;
            border-radius: 7px;
            background: #38bdf8;
            color: #082f49;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
        }

        button:hover {
            background: #7dd3fc;
        }

        .message {
            text-align: center;
            margin: 12px 0;
            font-size: 14px;
        }

        .error {
            color: #fca5a5;
        }

        .success {
            color: #86efac;
        }

        .note {
            color: #cbd5e1;
            font-size: 13px;
            line-height: 1.5;
            margin-top: 10px;
        }

        .footer {
            text-align: center;
            margin-top: 20px;
            font-size: 14px;
        }

        a {
            color: #38bdf8;
            text-decoration: none;
        }

        .hidden {
            display: none;
        }
    </style>
</head>

<body>
    <div class="register-card">
        <div class="logo">CodeQuest</div>
        <h2>Create Your Account</h2>

        <% if (request.getAttribute("errorMessage") != null) { %>
            <p class="message error">
                <%= request.getAttribute("errorMessage") %>
            </p>
        <% } %>

        <% if (request.getAttribute("successMessage") != null) { %>
            <p class="message success">
                <%= request.getAttribute("successMessage") %>
            </p>
        <% } %>

        <form action="<%= request.getContextPath() %>/register"
              method="post">

            <label for="role">Register as</label>
            <select id="role" name="role" onchange="changeRole()" required>
                <option value="student">Student</option>
                <option value="admin">Admin</option>
            </select>

            <div id="emailField">
                <label for="email">Email Address</label>
                <input type="email" id="email" name="email"
                       maxlength="100">
            </div>

            <label for="username">Username</label>
            <input type="text" id="username" name="username"
                   minlength="3" maxlength="50"
                   pattern="[A-Za-z0-9_]{3,50}"
                   title="Use 3-50 letters, numbers or underscores"
                   required>

            <label for="password">Password</label>
            <input type="password" id="password" name="password"
                   minlength="8" maxlength="100" required>

            <div id="confirmField">
                <label for="confirmPassword">Confirm Password</label>
                <input type="password" id="confirmPassword"
                       name="confirmPassword" minlength="8" required>
            </div>


            <button type="submit">Create Account</button>
        </form>

        <div class="footer">
            Already have an account?
            <a href="login.jsp" id="loginLink">Student Login</a>
        </div>

        <div class="footer">
            <a href="index.html">Back to Home</a>
        </div>
    </div>

    <script>
    function changeRole() {
        const role = document.getElementById("role").value;
        const isAdmin = role === "admin";

        document.getElementById("emailField").classList.toggle(
            "hidden", isAdmin
        );

        document.getElementById("confirmField").classList.toggle(
            "hidden", isAdmin
        );

        document.getElementById("email").required = !isAdmin;
        document.getElementById("confirmPassword").required = !isAdmin;

        document.getElementById("loginLink").href =
            isAdmin ? "admin-login.jsp" : "login.jsp";

        document.getElementById("loginLink").textContent =
            isAdmin ? "Admin Login" : "Student Login";
    }
    </script>
</body>
</html>
