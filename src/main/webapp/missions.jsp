<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List,java.util.Map" %>

<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    List<Map<String, Object>> missions =
        (List<Map<String, Object>>) request.getAttribute("missions");

    String missionMessage =
        (String) session.getAttribute("missionMessage");

    session.removeAttribute("missionMessage");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CodeQuest | Missions</title>

    <style>
        * { box-sizing: border-box; }

        body {
            margin: 0;
            padding: 25px;
            background: #101827;
            color: #f1f5f9;
            font-family: Arial, sans-serif;
        }

        .container {
            max-width: 1000px;
            margin: auto;
        }

        .navbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 15px;
            flex-wrap: wrap;
            margin-bottom: 30px;
        }

        .logo {
            color: #38bdf8;
            font-size: 25px;
            font-weight: bold;
            text-decoration: none;
        }

        .navbar a:not(.logo) {
            color: #7dd3fc;
            text-decoration: none;
            margin-left: 15px;
        }

        h1 { color: #38bdf8; }

        .intro {
            color: #cbd5e1;
            margin-bottom: 25px;
        }

        .mission-card {
            background: #1e293b;
            border: 1px solid #334155;
            border-radius: 12px;
            padding: 24px;
            margin-bottom: 20px;
        }

        .mission-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 12px;
            flex-wrap: wrap;
        }

        .mission-card h2 {
            margin-top: 0;
            margin-bottom: 10px;
        }

        .description {
            color: #cbd5e1;
            line-height: 1.6;
            white-space: pre-wrap;
        }

        .tag {
            display: inline-block;
            background: #263449;
            color: #7dd3fc;
            border-radius: 20px;
            padding: 6px 10px;
            margin: 3px;
            font-size: 13px;
        }

        .options {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 12px;
            margin-top: 20px;
        }

        .option {
            display: flex;
            align-items: flex-start;
            gap: 10px;
            padding: 14px;
            border: 1px solid #475569;
            border-radius: 8px;
            background: #0f172a;
            cursor: pointer;
        }

        .option:hover {
            border-color: #38bdf8;
        }

        .option input {
            margin-top: 4px;
            accent-color: #38bdf8;
        }

        .xp {
            color: #86efac;
            font-weight: bold;
        }

        .submit-btn {
            margin-top: 20px;
            padding: 12px 20px;
            border: none;
            border-radius: 7px;
            background: #38bdf8;
            color: #082f49;
            font-weight: bold;
            cursor: pointer;
        }

        .submit-btn:hover {
            background: #7dd3fc;
        }

        .message {
            padding: 14px;
            margin: 20px 0;
            background: #1e3a2f;
            color: #86efac;
            border-radius: 8px;
        }

        .empty {
            background: #1e293b;
            border-radius: 12px;
            padding: 25px;
            color: #cbd5e1;
        }

        .error { color: #fca5a5; }

        @media (max-width: 600px) {
            body { padding: 15px; }
            .options { grid-template-columns: 1fr; }
        }
    </style>
</head>

<body>
<div class="container">

    <nav class="navbar">
        <a class="logo"
           href="<%= request.getContextPath() %>/dashboard">CodeQuest</a>

        <div>
            <a href="<%= request.getContextPath() %>/dashboard">Dashboard</a>
            <a href="<%= request.getContextPath() %>/leaderboard">Leaderboard</a>
            <a href="<%= request.getContextPath() %>/logout">Logout</a>
        </div>
    </nav>

    <h1>Programming Missions</h1>
    <p class="intro">
        Choose a challenge, test your knowledge and earn experience points!
    </p>

    <% if (missionMessage != null) { %>
        <div class="message"><%= missionMessage %></div>
    <% } %>

    <% if (request.getAttribute("errorMessage") != null) { %>
        <p class="error">
            <%= request.getAttribute("errorMessage") %>
        </p>
    <% } %>

    <% if (missions != null && !missions.isEmpty()) { %>

        <% for (Map<String, Object> mission : missions) { %>

            <div class="mission-card">

                <div class="mission-header">
                    <div>
                        <h2><%= mission.get("title") %></h2>

                        <span class="tag">
                            <%= mission.get("category") %>
                        </span>

                        <span class="tag">
                            <%= mission.get("difficulty") %>
                        </span>
                    </div>

                    <span class="xp">
                        +<%= mission.get("xp_reward") %> XP
                    </span>
                </div>

                <p class="description"><%= mission.get("description") %></p>

                <form action="<%= request.getContextPath() %>/submit-answer"
                      method="post">

                    <input type="hidden" name="missionId"
                           value="<%= mission.get("id") %>">

                    <div class="options">
                        <label class="option">
                            <input type="radio" name="answer" value="A" required>
                            <span>A. <%= mission.get("option_a") %></span>
                        </label>

                        <label class="option">
                            <input type="radio" name="answer" value="B" required>
                            <span>B. <%= mission.get("option_b") %></span>
                        </label>

                        <label class="option">
                            <input type="radio" name="answer" value="C" required>
                            <span>C. <%= mission.get("option_c") %></span>
                        </label>

                        <label class="option">
                            <input type="radio" name="answer" value="D" required>
                            <span>D. <%= mission.get("option_d") %></span>
                        </label>
                    </div>

                    <button class="submit-btn" type="submit">
                        Submit Answer
                    </button>

                </form>
            </div>

        <% } %>

    <% } else if (request.getAttribute("errorMessage") == null) { %>

        <div class="empty">
            <h2>No missions available yet.</h2>
            <p>Please check back when the admin adds new programming challenges.</p>
        </div>

    <% } %>

</div>
</body>
</html>