
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

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;

	@Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(
                    request.getContextPath() + "/login.jsp");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");

        String sql =
                "SELECT u.username, u.total_xp, u.player_level, "
              + "(SELECT COUNT(*) FROM mission_submissions ms "
              + "WHERE ms.user_id = u.id AND ms.is_correct = 1) "
              + "AS completed_missions "
              + "FROM users u WHERE u.id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    request.setAttribute(
                            "username", rs.getString("username"));
                    request.setAttribute(
                            "totalXP", rs.getInt("total_xp"));
                    request.setAttribute(
                            "playerLevel", rs.getInt("player_level"));
                    request.setAttribute(
                            "completedMissions",
                            rs.getInt("completed_missions"));

                    RequestDispatcher dispatcher =
                            request.getRequestDispatcher("/dashboard.jsp");
                    dispatcher.forward(request, response);
                    return;
                }
            }

            session.invalidate();
            response.sendRedirect(
                    request.getContextPath() + "/login.jsp");

        } catch (SQLException e) {
            getServletContext().log(
                    "Dashboard database error", e);
            response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Unable to load dashboard.");
        }
    }
}
