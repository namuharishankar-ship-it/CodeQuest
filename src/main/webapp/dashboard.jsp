
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    String username = (String) request.getAttribute("username");
    Integer totalXP = (Integer) request.getAttribute("totalXP");
    Integer playerLevel = (Integer) request.getAttribute("playerLevel");
    Integer completedMissions =
        (Integer) request.getAttribute("completedMissions");

    if (username == null) username = (String) session.getAttribute("username");
    if (totalXP == null) totalXP = 0;
    if (playerLevel == null) playerLevel = 1;
    if (completedMissions == null) completedMissions = 0;

    // Each level requires 100 XP in this initial UI design.
    int xpInLevel = totalXP % 100;
    int xpToNextLevel = 100 - xpInLevel;
    int progress = xpInLevel;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard | CodeQuest</title>

    <style>
        :root {
            --bg: #090e1b;
            --panel: #111a2d;
            --panel-hover: #17233b;
            --border: #263550;
            --text: #f4f7ff;
            --muted: #9baac4;
            --purple: #8b70ff;
            --cyan: #20e3c2;
            --orange: #ffb86b;
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            min-height: 100vh;
            background:
                radial-gradient(ellipse at 10% 0%, #172344 0, transparent 38%),
                var(--bg);
            color: var(--text);
            font-family: "Segoe UI", Arial, sans-serif;
        }

        a {
            color: inherit;
            text-decoration: none;
        }

        .navbar {
            min-height: 76px;
            padding: 16px 6%;
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 20px;
            border-bottom: 1px solid var(--border);
            background: rgba(9, 14, 27, 0.92);
        }

        .logo {
            font-size: 25px;
            font-weight: 800;
            letter-spacing: -1px;
        }

        .logo span {
            color: var(--cyan);
        }

        .nav-links {
            display: flex;
            align-items: center;
            flex-wrap: wrap;
            gap: 24px;
        }

        .nav-links a {
            color: var(--muted);
            font-size: 14px;
            transition: color 0.2s;
        }

        .nav-links a:hover,
        .nav-links a.active {
            color: var(--cyan);
        }

        .nav-links .logout {
            padding: 10px 15px;
            border: 1px solid var(--border);
            border-radius: 8px;
            color: var(--text);
        }

        .container {
            width: min(1120px, 90%);
            margin: 42px auto 70px;
        }

        .welcome {
            display: flex;
            justify-content: space-between;
            align-items: flex-end;
            flex-wrap: wrap;
            gap: 20px;
            margin-bottom: 30px;
        }

        .eyebrow {
            color: var(--cyan);
            font-size: 11px;
            font-weight: 800;
            letter-spacing: 2px;
            margin-bottom: 12px;
        }

        .welcome h1 {
            font-size: clamp(28px, 4vw, 42px);
            letter-spacing: -1px;
            line-height: 1.2;
        }

        .welcome h1 span {
            color: var(--cyan);
        }

        .welcome p {
            margin-top: 12px;
            color: var(--muted);
            line-height: 1.7;
        }

        .level-pill {
            display: inline-block;
            padding: 11px 16px;
            border: 1px solid #4a4386;
            background: #1a2040;
            border-radius: 30px;
            font-size: 13px;
            font-weight: 700;
            color: #d4caff;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 20px;
            margin-bottom: 25px;
        }

        .stat-card {
            min-height: 170px;
            padding: 25px;
            border: 1px solid var(--border);
            border-radius: 16px;
            background: linear-gradient(145deg, #15213a, #10182a);
            transition: transform 0.2s, border-color 0.2s;
        }

        .stat-card:hover {
            transform: translateY(-3px);
            border-color: #596b96;
        }

        .stat-top {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 10px;
            color: var(--muted);
            font-size: 13px;
        }

        .stat-icon {
            width: 38px;
            height: 38px;
            display: grid;
            place-items: center;
            background: #202c49;
            border-radius: 10px;
            font-size: 19px;
        }

        .stat-card h2 {
            margin-top: 22px;
            font-size: 34px;
            letter-spacing: -1px;
        }

        .xp-value { color: var(--cyan); }
        .level-value { color: var(--purple); }
        .mission-value { color: var(--orange); }

        .panel {
            padding: 28px;
            background: var(--panel);
            border: 1px solid var(--border);
            border-radius: 16px;
            margin-bottom: 25px;
        }

        .panel-heading {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 15px;
            flex-wrap: wrap;
            margin-bottom: 23px;
        }

        .panel-heading h2 {
            font-size: 19px;
        }

        .panel-heading p {
            margin-top: 7px;
            color: var(--muted);
            font-size: 13px;
        }

        .xp-numbers {
            display: flex;
            justify-content: space-between;
            gap: 12px;
            margin-bottom: 12px;
            color: var(--muted);
            font-size: 13px;
        }

        .xp-numbers strong {
            color: var(--cyan);
        }

        .progress-track {
            width: 100%;
            height: 10px;
            overflow: hidden;
            background: #27334c;
            border-radius: 20px;
        }

        .progress-fill {
            height: 100%;
            width: <%= progress %>%;
            background: linear-gradient(90deg, var(--purple), var(--cyan));
            border-radius: 20px;
        }

        .progress-note {
            color: var(--muted);
            font-size: 12px;
            margin-top: 13px;
        }

        .actions-grid {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 18px;
        }

        .action-card {
            display: block;
            padding: 23px;
            background: #141f35;
            border: 1px solid var(--border);
            border-radius: 14px;
            transition: background 0.2s, transform 0.2s;
        }

        .action-card:hover {
            background: var(--panel-hover);
            transform: translateY(-3px);
        }

        .action-icon {
            font-size: 25px;
            margin-bottom: 16px;
        }

        .action-card h3 {
            font-size: 16px;
            margin-bottom: 9px;
        }

        .action-card p {
            color: var(--muted);
            font-size: 13px;
            line-height: 1.6;
        }

        .action-arrow {
            display: inline-block;
            color: var(--cyan);
            margin-top: 18px;
            font-size: 13px;
            font-weight: 700;
        }

        footer {
            padding: 25px;
            border-top: 1px solid var(--border);
            text-align: center;
            color: var(--muted);
            font-size: 12px;
        }

        @media (max-width: 760px) {
            .navbar {
                flex-direction: column;
                align-items: flex-start;
            }

            .nav-links {
                gap: 16px;
            }

            .stats-grid,
            .actions-grid {
                grid-template-columns: 1fr;
            }

            .stat-card {
                min-height: 140px;
            }

            .panel {
                padding: 22px;
            }
        }
    </style>
</head>

<body>

    <nav class="navbar">
        <a href="<%= request.getContextPath() %>/index.html" class="logo">
            Code<span>Quest</span>
        </a>

        <div class="nav-links">
            <a href="<%= request.getContextPath() %>/dashboard"
               class="active">Dashboard</a>
            <a href="<%= request.getContextPath() %>/missions">Missions</a>
            <a href="<%= request.getContextPath() %>/leaderboard">Leaderboard</a>
            <a href="<%= request.getContextPath() %>/logout" class="logout">
                Logout &#8594;
            </a>
        </div>
    </nav>

    <main class="container">

        <section class="welcome">
            <div>
                <p class="eyebrow">PLAYER CONTROL CENTER</p>
                <h1>Welcome back, <span><%= username %></span>!</h1>
                <p>Your next coding achievement is waiting. Ready for another quest?</p>
            </div>

            <div class="level-pill">
                &#9733; LEVEL <%= playerLevel %> PLAYER
            </div>
        </section>

        <section class="stats-grid">

            <div class="stat-card">
                <div class="stat-top">
                    <span>Total Experience</span>
                    <span class="stat-icon">&#9889;</span>
                </div>
                <h2 class="xp-value"><%= totalXP %> <small>XP</small></h2>
            </div>

            <div class="stat-card">
                <div class="stat-top">
                    <span>Current Level</span>
                    <span class="stat-icon">&#127942;</span>
                </div>
                <h2 class="level-value"><%= playerLevel %></h2>
            </div>

            <div class="stat-card">
                <div class="stat-top">
                    <span>Completed Missions</span>
                    <span class="stat-icon">&#10003;</span>
                </div>
                <h2 class="mission-value"><%= completedMissions %></h2>
            </div>

        </section>

        <section class="panel">
            <div class="panel-heading">
                <div>
                    <h2>Level Progress</h2>
                    <p>Keep solving missions to earn more experience.</p>
                </div>
                <strong>Level <%= playerLevel %></strong>
            </div>

            <div class="xp-numbers">
                <span><strong><%= xpInLevel %> XP</strong> toward next level</span>
                <span><%= xpToNextLevel %> XP remaining</span>
            </div>

            <div class="progress-track">
                <div class="progress-fill"></div>
            </div>

            <p class="progress-note">
                Progress bar currently uses a provisional 100-XP-per-level display.
                Actual level thresholds will be aligned with the XP rules we implement.
            </p>
        </section>

        <section class="panel">
            <div class="panel-heading">
                <div>
                    <h2>Choose Your Next Quest</h2>
                    <p>Practice your skills and climb the leaderboard.</p>
                </div>
            </div>

            <div class="actions-grid">

                <a href="<%= request.getContextPath() %>/missions"
                   class="action-card">
                    <div class="action-icon">&#128187;</div>
                    <h3>Programming Missions</h3>
                    <p>Solve Java, SQL and DSA questions to gain experience.</p>
                    <span class="action-arrow">Explore missions &#8594;</span>
                </a>

                <a href="<%= request.getContextPath() %>/leaderboard"
                   class="action-card">
                    <div class="action-icon">&#127942;</div>
                    <h3>Global Leaderboard</h3>
                    <p>Compare your XP and ranking with other players.</p>
                    <span class="action-arrow">View rankings &#8594;</span>
                </a>

                <a href="<%= request.getContextPath() %>/dashboard"
                   class="action-card">
                    <div class="action-icon">&#128202;</div>
                    <h3>Your Progress</h3>
                    <p>Review your current level and completed missions.</p>
                    <span class="action-arrow">Refresh progress &#8594;</span>
                </a>

            </div>
        </section>

    </main>

    <footer>
        &copy; 2026 CodeQuest. Learn. Play. Level Up.
    </footer>

</body>
</html>
