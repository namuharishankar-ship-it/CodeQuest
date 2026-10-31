<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    if (session.getAttribute("adminId") == null) {
        response.sendRedirect(request.getContextPath() + "/admin-login.jsp");
        return;
    }

    Object missionId = request.getAttribute("missionId");

    if (missionId == null) {
        response.sendRedirect(request.getContextPath() + "/view-questions");
        return;
    }

    String title = (String) request.getAttribute("title");
    String description = (String) request.getAttribute("description");
    String category = (String) request.getAttribute("category");
    String difficulty = (String) request.getAttribute("difficulty");
    String optionA = (String) request.getAttribute("optionA");
    String optionB = (String) request.getAttribute("optionB");
    String optionC = (String) request.getAttribute("optionC");
    String optionD = (String) request.getAttribute("optionD");
    String correctAnswer = (String) request.getAttribute("correctAnswer");
    Object xpReward = request.getAttribute("xpReward");

    String correctChoice = "A";
    if (correctAnswer != null && correctAnswer.equals(optionB)) correctChoice = "B";
    else if (correctAnswer != null && correctAnswer.equals(optionC)) correctChoice = "C";
    else if (correctAnswer != null && correctAnswer.equals(optionD)) correctChoice = "D";
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Mission | CodeQuest</title>

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
            max-width: 750px;
            margin: 20px auto;
            padding: 30px;
            background: #1e293b;
            border: 1px solid #334155;
            border-radius: 12px;
        }

        h1 { color: #38bdf8; }

        label {
            display: block;
            margin: 17px 0 8px;
            font-weight: bold;
        }

        input, textarea, select {
            width: 100%;
            padding: 12px;
            border: 1px solid #475569;
            border-radius: 7px;
            background: #0f172a;
            color: #f1f5f9;
            font-size: 15px;
        }

        textarea {
            min-height: 100px;
            resize: vertical;
        }

        .row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 18px;
        }

        button, .back {
            display: inline-block;
            margin-top: 24px;
            padding: 13px 20px;
            border: none;
            border-radius: 7px;
            background: #0284c7;
            color: white;
            text-decoration: none;
            font-size: 15px;
            font-weight: bold;
            cursor: pointer;
        }

        button:hover { background: #0369a1; }

        .back {
            margin-left: 10px;
            background: #334155;
        }

        .back:hover { background: #475569; }

        @media (max-width: 600px) {
            .row { grid-template-columns: 1fr; }
            .container { padding: 20px; }
        }
    </style>
</head>

<body>

<div class="container">

    <a href="<%= request.getContextPath() %>/view-questions"
       style="color:#38bdf8;text-decoration:none;">
        &larr; Back to Questions
    </a>

    <h1>Edit Mission</h1>
    <p>Update the mission details below.</p>

    <form action="<%= request.getContextPath() %>/edit-question" method="post">

        <input type="hidden" name="id" value="<%= missionId %>">

        <label for="title">Mission Title</label>
        <input type="text" id="title" name="title"
               value="<%= title %>" maxlength="100" required>

        <label for="description">Description</label>
        <textarea id="description" name="description"
                  required><%= description %></textarea>

        <div class="row">
            <div>
                <label for="category">Category</label>
                <select id="category" name="category" required>
                    <option value="Java" <%= "Java".equals(category) ? "selected" : "" %>>Java</option>
                    <option value="Python" <%= "Python".equals(category) ? "selected" : "" %>>Python</option>
                    <option value="C" <%= "C".equals(category) ? "selected" : "" %>>C</option>
                    <option value="SQL" <%= "SQL".equals(category) ? "selected" : "" %>>SQL</option>
                    <option value="General" <%= "General".equals(category) ? "selected" : "" %>>General</option>
                </select>
            </div>

            <div>
                <label for="difficulty">Difficulty</label>
                <select id="difficulty" name="difficulty" required>
                    <option value="Easy" <%= "Easy".equals(difficulty) ? "selected" : "" %>>Easy</option>
                    <option value="Medium" <%= "Medium".equals(difficulty) ? "selected" : "" %>>Medium</option>
                    <option value="Hard" <%= "Hard".equals(difficulty) ? "selected" : "" %>>Hard</option>
                </select>
            </div>
        </div>

        <label for="optionA">Option A</label>
        <input type="text" id="optionA" name="optionA"
               value="<%= optionA %>" required>

        <label for="optionB">Option B</label>
        <input type="text" id="optionB" name="optionB"
               value="<%= optionB %>" required>

        <label for="optionC">Option C</label>
        <input type="text" id="optionC" name="optionC"
               value="<%= optionC %>" required>

        <label for="optionD">Option D</label>
        <input type="text" id="optionD" name="optionD"
               value="<%= optionD %>" required>

        <label for="correctAnswer">Correct Answer</label>
        <select id="correctAnswer" name="correctAnswer" required>
            <option value="A" <%= "A".equals(correctChoice) ? "selected" : "" %>>A</option>
            <option value="B" <%= "B".equals(correctChoice) ? "selected" : "" %>>B</option>
            <option value="C" <%= "C".equals(correctChoice) ? "selected" : "" %>>C</option>
            <option value="D" <%= "D".equals(correctChoice) ? "selected" : "" %>>D</option>
        </select>

        <label for="xpReward">XP Reward (1–1000)</label>
        <input type="number" id="xpReward" name="xpReward"
               min="1" max="1000" value="<%= xpReward %>" required>

        <button type="submit">Save Changes</button>

        <a class="back"
           href="<%= request.getContextPath() %>/view-questions">
            Cancel
        </a>

    </form>

</div>

</body>
</html>
