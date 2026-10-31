
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Login | CodeQuest</title>

    <style>
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            min-height: 100vh;
            background: #090e1b;
            color: #f4f7ff;
            font-family: "Segoe UI", Arial, sans-serif;
            display: flex;
            flex-direction: column;
        }

        nav {
            padding: 22px 6%;
            border-bottom: 1px solid #263550;
        }

        .logo {
            color: #f4f7ff;
            font-size: 24px;
            font-weight: 800;
            text-decoration: none;
        }

        .logo span {
            color: #20e3c2;
        }

        .login-box {
            width: 90%;
            max-width: 430px;
            margin: 65px auto;
            padding: 34px;
            background: #111a2d;
            border: 1px solid #263550;
            border-radius: 16px;
        }

        .eyebrow {
            color: #20e3c2;
            font-size: 11px;
            font-weight: 800;
            letter-spacing: 2px;
            margin-bottom: 14px;
        }

        h1 {
            font-size: 29px;
            margin-bottom: 10px;
        }

        .subtitle {
            color: #9baac4;
            font-size: 14px;
            line-height: 1.6;
            margin-bottom: 25px;
        }

        label {
            display: block;
            margin: 17px 0 8px;
            font-size: 14px;
        }

        input {
            display: block;
            width: 100%;
            padding: 13px;
            background: #090e1b;
            color: #f4f7ff;
            border: 1px solid #33415e;
            border-radius: 8px;
            outline: none;
        }

        input:focus {
            border-color: #20e3c2;
        }

        button {
            width: 100%;
            margin-top: 25px;
            padding: 14px;
            background: #8b70ff;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 15px;
            font-weight: 700;
            cursor: pointer;
        }

        button:hover {
            background: #7658f0;
        }

        .error {
            padding: 12px;
            margin-bottom: 18px;
            background: #321c29;
            color: #ffaaaa;
            border-radius: 8px;
            font-size: 14px;
        }

        .back-link {
            margin-top: 22px;
            text-align: center;
            font-size: 14px;
        }

        .back-link a {
            color: #20e3c2;
        }

        footer {
            margin-top: auto;
            padding: 22px;
            text-align: center;
            color: #9baac4;
            font-size: 12px;
        }
    </style>
</head>
<body>

    <nav>
        <a href="index.html" class="logo">Code<span>Quest</span></a>
    </nav>

    <main class="login-box">
        <p class="eyebrow">ADMINISTRATOR ACCESS</p>
        <h1>Admin Login</h1>
        <p class="subtitle">
            Sign in to manage programming missions and questions.
        </p>

        <%
            String errorMessage =
                (String) request.getAttribute("errorMessage");

            if (errorMessage != null) {
        %>
            <div class="error">
                <%= errorMessage %>
            </div>
        <%
            }
        %>

        <form action="${pageContext.request.contextPath}/admin-login"
              method="post">

            <label for="username">Admin Username</label>
            <input type="text"
                   id="username"
                   name="username"
                   autocomplete="username"
                   required>

            <label for="password">Password</label>
            <input type="password"
                   id="password"
                   name="password"
                   autocomplete="current-password"
                   required>

            <button type="submit">Sign In to Admin</button>
        </form>

        <p class="back-link">
            <a href="index.html">Return to CodeQuest Home</a>
        </p>
    </main>

    <footer>
        &copy; 2026 CodeQuest. Admin Console.
    </footer>

</body>
</html>
