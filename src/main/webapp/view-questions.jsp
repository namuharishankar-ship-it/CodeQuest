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
    <title>CodeQuest | View Questions</title>

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
            max-width: 1200px;
            margin: auto;
        }

        h1 { color: #38bdf8; }

        a {
            color: #38bdf8;
            text-decoration: none;
        }

        .table-wrapper {
            margin-top: 25px;
            overflow-x: auto;
            background: #1e293b;
            border-radius: 10px;
        }

       
		table {
		    width: 100%;
		    border-collapse: collapse;
		    table-layout: fixed;
		    min-width: 1100px;
		}
		
		th, td {
		    padding: 16px 12px;
		    border-bottom: 1px solid #334155;
		    text-align: left;
		    vertical-align: top;
		    overflow-wrap: anywhere;
		    line-height: 1.5;
		}
		
		th {
		    background: #263449;
		    color: #7dd3fc;
		    font-size: 14px;
		}
		
		td strong {
		    display: inline-block;
		    margin-bottom: 6px;
		}
		
		td:nth-child(5) {
		    line-height: 1.7;
		}
		
		td:nth-child(6) {
		    min-width: 130px;
		}
		
		td:nth-child(8) a,
		td:nth-child(8) button {
		    margin-bottom: 8px;
		}


        tr:hover { background: #273449; }

        .message {
            padding: 12px;
            background: #1e3a2f;
            color: #86efac;
            border-radius: 7px;
        }

        .empty {
            padding: 25px;
            text-align: center;
            color: #cbd5e1;
        }

        .back {
            display: inline-block;
            margin: 10px 0;
        }
        
		.actions-cell {
		    min-width: 150px;
		    white-space: nowrap;
		}
		
		.action-link {
		    display: inline-block;
		    margin: 0 0 12px 0;
		    color: #38bdf8;
		    font-weight: bold;
		}
		
		.delete-form {
		    display: block !important;
		    margin-top: 8px;
		}
		
		.delete-button {
		    background: #dc2626;
		    color: white;
		    border: none;
		    padding: 8px 14px;
		    border-radius: 6px;
		    cursor: pointer;
		    font-size: 14px;
		}
		
		.delete-button:hover {
		    background: #b91c1c;
		}
        
    </style>
</head>

<body>
<div class="container">
    <a href="<%= request.getContextPath() %>/admin-dashboard">
        &larr; Admin Dashboard
    </a>

    <h1>Programming Missions</h1>
    <p>View all questions created in CodeQuest.</p>

    <% if (request.getAttribute("errorMessage") != null) { %>
        <p style="color:#fca5a5">
            <%= request.getAttribute("errorMessage") %>
        </p>
    <% } %>

    <div class="table-wrapper">
        
		<table>
		    <colgroup>
		        <col style="width:5%">
		        <col style="width:27%">
		        <col style="width:9%">
		        <col style="width:9%">
		        <col style="width:24%">
		        <col style="width:13%">
		        <col style="width:5%">
		        <col style="width:8%">
		    </colgroup>

            <thead>
            <tr>
                <th>ID</th>
                <th>Title and Description</th>
                <th>Category</th>
                <th>Difficulty</th>
                <th>Options</th>
                <th>Correct Answer</th>
				<th>XP</th>
				<th>Actions</th>
            </tr>
            </thead>

            <tbody>
            <%
                java.util.List<java.util.Map<String, Object>> missions =
                    (java.util.List<java.util.Map<String, Object>>)
                    request.getAttribute("missions");

                if (missions != null && !missions.isEmpty()) {
                    for (java.util.Map<String, Object> mission : missions) {
            %>
                <tr>
                    <td><%= mission.get("id") %></td>
                    <td>
                        <strong><%= mission.get("title") %></strong><br><br>
                        <%= mission.get("description") %>
                    </td>
                    <td><%= mission.get("category") %></td>
                    <td><%= mission.get("difficulty") %></td>
                    <td>
                        A. <%= mission.get("option_a") %><br>
                        B. <%= mission.get("option_b") %><br>
                        C. <%= mission.get("option_c") %><br>
                        D. <%= mission.get("option_d") %>
                    </td>
					                    
					<td><%= mission.get("correct_answer") %></td>
					<td><%= mission.get("xp_reward") %></td>
					
					<td class="actions-cell">
					    <a class="action-link"
					       href="<%= request.getContextPath() %>/edit-question?id=<%= mission.get("id") %>">
					        Edit
					    </a>
					
					    <form class="delete-form"
					          action="<%= request.getContextPath() %>/delete-question"
					          method="post"
					          onsubmit="return confirm('Are you sure you want to delete this mission?');">
					
					        <input type="hidden" name="id"
					               value="<%= mission.get("id") %>">
					
					        <button type="submit" class="delete-button">
					            Delete
					        </button>
					    </form>
					</td>


                </tr>
            <%
                    }
                } else {
            %>
                <tr>
                    <td colspan="8" class="empty">
                        No missions found. Add your first mission!
                    </td>
                </tr>
            <%
                }
            %>
            </tbody>
        </table>
    </div>
</div>
</body>
</html>
