
package com.codequest.servlet;

import com.codequest.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet("/admin-login")
public class AdminLoginServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;

	@Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        RequestDispatcher dispatcher =
                request.getRequestDispatcher("/admin-login.jsp");

        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if (username == null || password == null
                || username.isBlank() || password.isEmpty()) {

            showError(request, response,
                    "Enter your admin username and password.");
            return;
        }

        String sql =
                "SELECT id, username, password "
              + "FROM admins WHERE username = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, username.trim());

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()
                        && rs.getString("password").equals(password)) {

                    int adminId = rs.getInt("id");
                    String adminUsername = rs.getString("username");

                    // Start a fresh session after authentication.
                    HttpSession oldSession = request.getSession(false);

                    if (oldSession != null) {
                        oldSession.invalidate();
                    }

                    HttpSession session = request.getSession(true);
                    session.setAttribute("adminId", adminId);
                    session.setAttribute("adminUsername", adminUsername);

                    response.sendRedirect(
                            request.getContextPath() + "/admin-dashboard");
                    return;
                }
            }

            showError(request, response,
                    "Invalid admin username or password.");

        } catch (SQLException e) {
            getServletContext().log("Admin login failed", e);

            showError(request, response,
                    "A database error occurred. Check the server log.");
        }
    }

    private void showError(HttpServletRequest request,
                           HttpServletResponse response,
                           String message)
            throws ServletException, IOException {

        request.setAttribute("errorMessage", message);

        RequestDispatcher dispatcher =
                request.getRequestDispatcher("/admin-login.jsp");

        dispatcher.forward(request, response);
    }
}
