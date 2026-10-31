
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    String message = (String) session.getAttribute("missionMessage");

    if (message == null) {
        message = "Your mission result will appear here after you submit an answer.";
    } else {
        session.removeAttribute("missionMessage");
    }

    boolean correct = message.startsWith("Correct answer!");
    boolean incorrect = message.startsWith("Incorrect answer.");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mission Result | CodeQuest</title>

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: Arial, sans-serif;
            background: #0b1020;
            color: #f1f5f9;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .result-card {
            width: 100%;
            max-width: 600px;
            background: #151e30;
            border: 1px solid #273449;
            border-radius: 16px;
            padding: 40px 30px;
            text-align: center;
        }

        .icon {
            font-size: 55px;
            margin-bottom: 20px;
        }

        h1 {
            font-size: 30px;
            margin-bottom: 18px;
        }

        .message {
            color: #cbd5e1;
            font-size: 17px;
            line-height: 1.7;
            overflow-wrap: anywhere;
            margin-bottom: 28px;
        }

        .success {
            color: #4ade80;
        }

        .failure {
            color: #fb7185;
        }

        .info {
            color: #38bdf8;
        }

        .buttons {
            display: flex;
            justify-content: center;
            flex-wrap: wrap;
            gap: 12px;
        }

        .btn {
            display: inline-block;
            padding: 13px 20px;
            border-radius: 8px;
            background: #0284c7;
            color: white;
            text-decoration: none;
            font-weight: bold;
        }

        .btn:hover {
            background: #0369a1;
        }

        .secondary {
            background: #273449;
        }

        .secondary:hover {
            background: #334155;
        }
    </style>
</head>

<body>

<div class="result-card">

    <%
        if (correct) {
    %>
        <div class="icon">&#10004;</div>
        <h1 class="success">Correct Answer!</h1>
    <%
        } else if (incorrect) {
    %>
        <div class="icon">&#10006;</div>
        <h1 class="failure">Not Quite!</h1>
    <%
        } else {
    %>
        <div class="icon">&#9733;</div>
        <h1 class="info">Mission Result</h1>
    <%
        }
    %>

    <p class="message"><%= message %></p>

    <div class="buttons">
        <a class="btn"
           href="<%= request.getContextPath() %>/missions">
            Back to Missions
        </a>

        <a class="btn secondary"
           href="<%= request.getContextPath() %>/dashboard">
            Dashboard
        </a>

        <a class="btn secondary"
           href="<%= request.getContextPath() %>/leaderboard">
            Leaderboard
        </a>
    </div>

</div>

</body>
</html>
