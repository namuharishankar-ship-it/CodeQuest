
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%
    if (session.getAttribute("adminId") == null) {
        response.sendRedirect(request.getContextPath() + "/admin-login.jsp");
        return;
    }

    String adminUsername =
        (String) session.getAttribute("adminUsername");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard | CodeQuest</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            min-height: 100vh;
            background: #090e1b;
            color: #f4f7ff;
            font-family: "Segoe UI", Arial, sans-serif;
        }

        nav {
            padding: 22px 6%;
            border-bottom: 1px solid #263550;
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 20px;
        }

        .logo {
            font-size: 25px;
            font-weight: 800;
            text-decoration: none;
            color: #f4f7ff;
        }

        .logo span { color: #20e3c2; }

        nav a.logout {
            color: #ffaaaa;
            text-decoration: none;
        }

        main {
            width: 90%;
            max-width: 1100px;
            margin: 50px auto;
        }

        .eyebrow {
            color: #20e3c2;
            letter-spacing: 2px;
            font-size: 11px;
            font-weight: bold;
            margin-bottom: 12px;
        }

        h1 { font-size: 36px; }

        .intro {
            color: #9baac4;
            margin-top: 12px;
            line-height: 1.7;
        }

        .cards {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 22px;
            margin-top: 35px;
        }

        .card {
            padding: 30px;
            border: 1px solid #263550;
            border-radius: 15px;
            background: #111a2d;
        }

        .card .icon {
            font-size: 30px;
            margin-bottom: 18px;
        }

        .card h2 { font-size: 21px; margin-bottom: 12px; }

        .card p {
            color: #9baac4;
            line-height: 1.7;
            margin-bottom: 22px;
        }

        .btn {
            display: inline-block;
            padding: 12px 18px;
            background: #8b70ff;
            border-radius: 8px;
            color: white;
            font-weight: bold;
            font-size: 14px;
            text-decoration: none;
        }

        .secondary {
            background: #17233b;
            border: 1px solid #33415e;
        }

        footer {
            margin-top: 80px;
            padding: 22px;
            border-top: 1px solid #263550;
            color: #9baac4;
            text-align: center;
            font-size: 12px;
        }

        @media (max-width: 650px) {
            .cards { grid-template-columns: 1fr; }
            h1 { font-size: 29px; }
        }
    </style>
</head>
<body>

    <nav>
        <a href="index.html" class="logo">Code<span>Quest</span></a>
        <a href="admin-logout" class="logout">Logout &#8594;</a>
    </nav>

    <main>
        <p class="eyebrow">ADMIN CONTROL CENTER</p>
        <h1>Welcome, <%= adminUsername %>!</h1>
        <p class="intro">
            Manage the programming challenges that students use
            to learn, earn XP, and progress through CodeQuest.
        </p>

        <div class="cards">
            <section class="card">
                <div class="icon">&#10133;</div>
                <h2>Add Programming Questions</h2>
                <p>
                    Create Java, SQL, and DSA missions with four
                    answer choices, difficulty levels, and XP rewards.
                </p>
                <a href="add-question.jsp" class="btn">
                    Add Question &#8594;
                </a>
            </section>

            <section class="card">
                <div class="icon">&#128203;</div>
                <h2>Manage Questions</h2>
                <p>
                    View the questions stored in the database and
                    review their categories, difficulty, and rewards.
                </p>
                <a href="view-questions" class="btn secondary">
                    View Questions &#8594;
                </a>
            </section>
        </div>
    </main>

    <footer>
        &copy; 2026 CodeQuest. Administrator Console.
    </footer>

</body>
</html>
