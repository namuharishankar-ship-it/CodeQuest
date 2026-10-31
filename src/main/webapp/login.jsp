<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Login | CodeQuest</title>
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/style.css">

    <style>
        html, body {
            min-height: 100%;
            background: #0b1020;
            color: #f4f6ff;
        }
        
		* {
		    box-sizing: border-box;
		}
		
		.navbar {
		    width: 100%;
		    min-height: 72px;
		    padding: 18px 8%;
		    display: flex;
		    justify-content: space-between;
		    align-items: center;
		    gap: 20px;
		    background: #111827;
		    border-bottom: 1px solid #273449;
		}
		
		.brand {
		    color: #38bdf8;
		    font-family: Arial, sans-serif;
		    font-size: 26px;
		    font-weight: bold;
		    text-decoration: none;
		    white-space: nowrap;
		}
		
		.nav-links {
		    display: flex;
		    align-items: center;
		    justify-content: flex-end;
		    gap: 28px;
		    flex-shrink: 0;
		}
		
		.nav-links a {
		    color: #cbd5e1;
		    font-family: Arial, sans-serif;
		    font-size: 15px;
		    font-weight: 600;
		    text-decoration: none;
		    white-space: nowrap;
		}
		
		.nav-links a:hover {
		    color: #38bdf8;
		}
		
		@media (max-width: 480px) {
		    .navbar {
		        padding: 16px 5%;
		    }
		
		    .nav-links {
		        gap: 14px;
		    }
		}


        .login-box {
            display: block;
            width: 90%;
            max-width: 440px;
            margin: 55px auto;
            padding: 32px;
            background: #141c30;
            border: 1px solid #29334b;
            border-radius: 16px;
            margin: 35px auto;
        }

        .login-box h1 {
            margin-bottom: 10px;
        }

        .login-box .subtitle {
            color: #a2acc5;
            margin-bottom: 20px;
            line-height: 1.6;
        }

        .login-box label {
            display: block;
            margin: 16px 0 7px;
        }

        .login-box input {
            display: block;
            width: 100%;
            padding: 12px;
            color: #f4f6ff;
            background: #0b1020;
            border: 1px solid #29334b;
            border-radius: 7px;
        }

        .login-box button {
            display: block;
            width: 100%;
            padding: 14px;
            margin-top: 24px;
            color: white;
            background: #7c5cff;
            border: none;
            border-radius: 8px;
            font-weight: bold;
            cursor: pointer;
        }

        .message {
            margin-bottom: 16px;
            padding: 12px;
            border-radius: 7px;
            line-height: 1.5;
        }

        .error {
            color: #ff9999;
            background: #321c29;
        }

        .login-box .register-link {
            margin-top: 20px;
            color: #a2acc5;
        }

        .register-link a {
            color: #00e0b8;
        }
		       	
		html, body {
		    min-height: 100%;
		    margin: 0;
		}
		
		body {
		    min-height: 100vh;
		    display: flex;
		    flex-direction: column;
		}
		
		.navbar {
		    flex-shrink: 0;
		}
		
		.login-container {
		    margin: 36px auto;
		}
		
		footer {
		    margin-top: auto;
		    width: 100%;
		    padding: 18px 20px;
		    text-align: center;
		    color: #94a3b8;
		    font-family: Arial, sans-serif;
		    font-size: 14px;
		    border-top: 1px solid #273449;
		    background: #0b1020;
		}

		        
    </style>
</head>
<body>

   	
	<nav class="navbar">
	    <a class="brand" href="index.html">CodeQuest</a>
	
	    <div class="nav-links">
	        <a href="index.html">Home</a>
	        <a href="register.jsp">Register</a>
	    </div>
	</nav>


    <main class="login-box">
        <h1>Welcome Back</h1>
        <p class="subtitle">Log in to continue your coding quest.</p>

        <%
            String errorMessage =
                (String) request.getAttribute("errorMessage");

            if (errorMessage != null) {
        %>
            <div class="message error">
                <%= errorMessage %>
            </div>
        <%
            }
        %>

        <form action="${pageContext.request.contextPath}/login"
              method="post">

            <label for="identity">Username or Email</label>
            <input type="text"
                   id="identity"
                   name="identity"
                   autocomplete="username"
                   required>

            <label for="password">Password</label>
            <input type="password"
                   id="password"
                   name="password"
                   autocomplete="current-password"
                   required>

            <button type="submit">Log In</button>
        </form>

        <p class="register-link">
            New player?
            <a href="register.jsp">Create an account</a>
        </p>
    </main>

    <footer>
        <p>&copy; 2026 CodeQuest. Learn. Play. Level Up.</p>
    </footer>

</body>
</html>
