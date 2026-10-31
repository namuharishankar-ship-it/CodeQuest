<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List,java.util.Map" %>
<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    List<Map<String, Object>> students =
        (List<Map<String, Object>>) request.getAttribute("students");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Leaderboard | CodeQuest</title>

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
        }

        nav {
            background: #111827;
            border-bottom: 1px solid #273449;
            padding: 20px 8%;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .logo {
            font-size: 25px;
            font-weight: bold;
            color: #38bdf8;
        }

        nav a {
            color: #cbd5e1;
            text-decoration: none;
            margin-left: 20px;
        }

        nav a:hover {
            color: #38bdf8;
        }

        .container {
            width: 85%;
            max-width: 1000px;
            margin: 45px auto;
        }

        .heading {
            text-align: center;
            margin-bottom: 30px;
        }

        .heading h1 {
            font-size: 34px;
            margin-bottom: 12px;
        }

        .heading p {
            color: #94a3b8;
        }

        .table-card {
            background: #151e30;
            border: 1px solid #273449;
            border-radius: 14px;
            padding: 20px;
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            min-width: 450px;
        }

        th, td {
            padding: 17px 15px;
            text-align: left;
            border-bottom: 1px solid #273449;
        }

        th {
            color: #38bdf8;
            font-size: 13px;
            text-transform: uppercase;
        }

        td {
            color: #e2e8f0;
        }

        tr:last-child td {
            border-bottom: none;
        }

        .rank {
            font-weight: bold;
            color: #facc15;
        }

        .xp {
            color: #38bdf8;
            font-weight: bold;
        }

        .empty {
            text-align: center;
            padding: 30px;
            color: #94a3b8;
        }

        .back {
            display: inline-block;
            margin-top: 25px;
            padding: 13px 20px;
            background: #0284c7;
            color: white;
            text-decoration: none;
            border-radius: 8px;
        }

        .back:hover {
            background: #0369a1;
        }

        @media (max-width: 650px) {
            nav {
                flex-direction: column;
                gap: 15px;
            }

            nav a {
                margin: 0 7px;
            }

            .container {
                width: 92%;
            }
        }
    </style>
</head>

<body>

<nav>
    <div class="logo">CodeQuest</div>
    <div>
        <a href="<%= request.getContextPath() %>/dashboard">Dashboard</a>
        <a href="<%= request.getContextPath() %>/missions">Missions</a>
        <a href="<%= request.getContextPath() %>/logout">Logout</a>
    </div>
</nav>

<div class="container">

    <div class="heading">
        <h1>Leaderboard</h1>
        <p>See how you rank against other CodeQuest students.</p>
    </div>

    <div class="table-card">
        <table>
            <thead>
                <tr>
                    <th>Rank</th>
                    <th>Student</th>
                    <th>Level</th>
                    <th>Total XP</th>
                </tr>
            </thead>

            <tbody>
            <%
                if (students != null && !students.isEmpty()) {
                    for (Map<String, Object> student : students) {
            %>
                <tr>
                    <td class="rank">#<%= student.get("rank") %></td>
                    <td><%= student.get("username") %></td>
                    <td><%= student.get("level") %></td>
                    <td class="xp"><%= student.get("totalXP") %> XP</td>
                </tr>
            <%
                    }
                } else {
            %>
                <tr>
                    <td colspan="4" class="empty">
                        No students found yet.
                    </td>
                </tr>
            <%
                }
            %>
            </tbody>
        </table>
    </div>

    <a class="back" href="<%= request.getContextPath() %>/dashboard">
        Back to Dashboard
    </a>

</div>

</body>
</html>
