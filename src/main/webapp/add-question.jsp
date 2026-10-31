
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if (session.getAttribute("adminId") == null) {
        response.sendRedirect(request.getContextPath() + "/admin-login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CodeQuest | Add Question</title>

    <style>
        * { box-sizing: border-box; }

        body {
            margin: 0;
            padding: 30px 16px;
            background: #101827;
            color: #f1f5f9;
            font-family: Arial, sans-serif;
        }

        .container {
            max-width: 700px;
            margin: auto;
            padding: 30px;
            background: #1e293b;
            border-radius: 14px;
        }

        h1 { color: #38bdf8; }

        label {
            display: block;
            margin: 16px 0 7px;
        }

        input, textarea, select {
            width: 100%;
            padding: 12px;
            border: 1px solid #475569;
            border-radius: 7px;
            background: #0f172a;
            color: white;
            font-size: 15px;
        }

        textarea {
            min-height: 100px;
            resize: vertical;
        }

        .options {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 0 15px;
        }

        button {
            margin-top: 24px;
            width: 100%;
            padding: 13px;
            background: #38bdf8;
            color: #082f49;
            border: none;
            border-radius: 7px;
            font-weight: bold;
            font-size: 16px;
            cursor: pointer;
        }

        .back {
            display: inline-block;
            margin-bottom: 16px;
            color: #38bdf8;
            text-decoration: none;
        }

        .message { color: #86efac; }

        @media (max-width: 520px) {
            .options { grid-template-columns: 1fr; }
            .container { padding: 20px; }
        }
    </style>
</head>

<body>
<div class="container">
    <a class="back" href="<%= request.getContextPath() %>/admin-dashboard">
        &larr; Back to Admin Dashboard
    </a>

    <h1>Add Programming Mission</h1>
    <p>Create a multiple-choice question for CodeQuest students.</p>

    <% if (request.getAttribute("errorMessage") != null) { %>
        <p style="color:#fca5a5">
            <%= request.getAttribute("errorMessage") %>
        </p>
    <% } %>

    <% if (request.getAttribute("successMessage") != null) { %>
        <p class="message">
            <%= request.getAttribute("successMessage") %>
        </p>
    <% } %>

    <form action="<%= request.getContextPath() %>/add-question"
          method="post">

        <label for="title">Question Title</label>
        <input type="text" id="title" name="title"
               maxlength="100" required>

        <label for="description">Question Description</label>
        <textarea id="description" name="description"
                  required></textarea>

        <div class="options">
            <div>
                <label for="category">Category</label>
                <select id="category" name="category" required>
                    <option value="">Select Category</option>
                    <option value="Java">Java</option>
                    <option value="Python">Python</option>
                    <option value="C">C</option>
                    <option value="SQL">SQL</option>
                    <option value="General">General</option>
                </select>
            </div>

            <div>
                <label for="difficulty">Difficulty</label>
                <select id="difficulty" name="difficulty" required>
                    <option value="">Select Difficulty</option>
                    <option value="Easy">Easy</option>
                    <option value="Medium">Medium</option>
                    <option value="Hard">Hard</option>
                </select>
            </div>
        </div>

        <label for="optionA">Option A</label>
        <input type="text" id="optionA" name="optionA"
               maxlength="255" required>

        <label for="optionB">Option B</label>
        <input type="text" id="optionB" name="optionB"
               maxlength="255" required>

        <label for="optionC">Option C</label>
        <input type="text" id="optionC" name="optionC"
               maxlength="255" required>

        <label for="optionD">Option D</label>
        <input type="text" id="optionD" name="optionD"
               maxlength="255" required>

        <label for="correctAnswer">Correct Answer</label>
        <select id="correctAnswer" name="correctAnswer" required>
            <option value="">Choose Correct Option</option>
            <option value="A">Option A</option>
            <option value="B">Option B</option>
            <option value="C">Option C</option>
            <option value="D">Option D</option>
        </select>

        <label for="xpReward">XP Reward</label>
        <input type="number" id="xpReward" name="xpReward"
               min="1" max="1000" value="50" required>

        <button type="submit">Save Mission</button>
    </form>
</div>
</body>
</html>