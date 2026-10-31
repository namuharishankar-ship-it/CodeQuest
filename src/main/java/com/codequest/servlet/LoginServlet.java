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

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;

	@Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        RequestDispatcher dispatcher =
                request.getRequestDispatcher("/login.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String identity = request.getParameter("identity");
        String password = request.getParameter("password");

        if (identity == null || password == null
                || identity.isBlank() || password.isEmpty()) {

            showError(request, response,
                    "Enter your username or email and password.");
            return;
        }

        String sql = "SELECT id, username, email, password "
                   + "FROM users WHERE username = ? OR email = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, identity.trim());
            ps.setString(2, identity.trim());

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    String storedPassword = rs.getString("password");

                    if (storedPassword.equals(password)) {

                        // Prevent session fixation after authentication.
                        HttpSession oldSession = request.getSession(false);

                        if (oldSession != null) {
                            oldSession.invalidate();
                        }

                        HttpSession session = request.getSession(true);
                        session.setAttribute("userId", rs.getInt("id"));
                        session.setAttribute("username",
                                rs.getString("username"));
                        session.setAttribute("userEmail",
                                rs.getString("email"));

                        response.sendRedirect(
                                request.getContextPath() + "/dashboard");
                        return;
                    }
                }
            }

            showError(request, response,
                    "Invalid username/email or password.");

        } catch (SQLException e) {
            getServletContext().log("Student login failed", e);
            showError(request, response,
                    "Database error. Please try again.");
        }
    }

    private void showError(HttpServletRequest request,
                           HttpServletResponse response,
                           String message)
            throws ServletException, IOException {

        request.setAttribute("errorMessage", message);

        RequestDispatcher dispatcher =
                request.getRequestDispatcher("/login.jsp");
        dispatcher.forward(request, response);
    }
}
