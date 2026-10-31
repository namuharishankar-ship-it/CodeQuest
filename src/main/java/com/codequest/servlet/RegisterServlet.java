package com.codequest.servlet;

import com.codequest.util.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;

	@Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("/register.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String role = request.getParameter("role");
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if (role == null || username == null || password == null
                || username.trim().isEmpty()
                || password.isEmpty()) {

            request.setAttribute("errorMessage",
                    "Please fill in all required fields.");
            request.getRequestDispatcher("/register.jsp")
                   .forward(request, response);
            return;
        }

        role = role.trim().toLowerCase();
        username = username.trim();

        if (!role.equals("student") && !role.equals("admin")) {
            request.setAttribute("errorMessage", "Invalid account type.");
            request.getRequestDispatcher("/register.jsp")
                   .forward(request, response);
            return;
        }

        if (!username.matches("[A-Za-z0-9_]{3,50}")) {
            request.setAttribute("errorMessage",
                    "Username must contain 3-50 letters, numbers or underscores.");
            request.getRequestDispatcher("/register.jsp")
                   .forward(request, response);
            return;
        }

        if (password.length() < 8 || password.length() > 100) {
            request.setAttribute("errorMessage",
                    "Password must be between 8 and 100 characters.");
            request.getRequestDispatcher("/register.jsp")
                   .forward(request, response);
            return;
        }

        String email = request.getParameter("email");
        String confirmPassword = request.getParameter("confirmPassword");

        if (role.equals("student")) {
            if (email == null || email.trim().isEmpty()
                    || confirmPassword == null
                    || !password.equals(confirmPassword)) {

                request.setAttribute("errorMessage",
                        "Enter your email and make sure both passwords match.");
                request.getRequestDispatcher("/register.jsp")
                       .forward(request, response);
                return;
            }

            email = email.trim();

            if (!email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$")) {
                request.setAttribute("errorMessage",
                        "Please enter a valid email address.");
                request.getRequestDispatcher("/register.jsp")
                       .forward(request, response);
                return;
            }
        }

        try (Connection con = DBConnection.getConnection()) {

            if (role.equals("student")) {

                String checkSql =
                        "SELECT id FROM users WHERE username = ? OR email = ?";

                try (PreparedStatement check = con.prepareStatement(checkSql)) {
                    check.setString(1, username);
                    check.setString(2, email);

                    try (ResultSet rs = check.executeQuery()) {
                        if (rs.next()) {
                            request.setAttribute("errorMessage",
                                    "Username or email already exists.");
                            request.getRequestDispatcher("/register.jsp")
                                   .forward(request, response);
                            return;
                        }
                    }
                }

                String sql = "INSERT INTO users "
                        + "(username, email, password, total_xp, player_level) "
                        + "VALUES (?, ?, ?, 0, 1)";

                try (PreparedStatement ps = con.prepareStatement(sql)) {
                    ps.setString(1, username);
                    ps.setString(2, email);
                    ps.setString(3, password);
                    ps.executeUpdate();
                }

                request.setAttribute("successMessage",
                        "Student account created successfully. Please log in.");
                request.getRequestDispatcher("/register.jsp")
                       .forward(request, response);

            } else {

                String checkSql =
                        "SELECT id FROM admins WHERE username = ?";

                try (PreparedStatement check = con.prepareStatement(checkSql)) {
                    check.setString(1, username);

                    try (ResultSet rs = check.executeQuery()) {
                        if (rs.next()) {
                            request.setAttribute("errorMessage",
                                    "Admin username already exists.");
                            request.getRequestDispatcher("/register.jsp")
                                   .forward(request, response);
                            return;
                        }
                    }
                }

                String sql =
                        "INSERT INTO admins (username, password) VALUES (?, ?)";

                try (PreparedStatement ps = con.prepareStatement(sql)) {
                    ps.setString(1, username);
                    ps.setString(2, password);
                    ps.executeUpdate();
                }

                request.setAttribute("successMessage",
                        "Admin account created successfully. Please use Admin Login.");
                request.getRequestDispatcher("/register.jsp")
                       .forward(request, response);
            }

        } catch (SQLException e) {
            getServletContext().log("Registration failed.", e);

            request.setAttribute("errorMessage",
                    "Registration failed. Please check the details and try again.");
            request.getRequestDispatcher("/register.jsp")
                   .forward(request, response);
        }
    }
}