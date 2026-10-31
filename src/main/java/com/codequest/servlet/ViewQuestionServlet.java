package com.codequest.servlet;

import com.codequest.util.DBConnection;
import jakarta.servlet.ServletException;
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
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/view-questions")
public class ViewQuestionServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;

	@Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Allow only logged-in admins.
        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect(
                request.getContextPath() + "/admin-login.jsp"
            );
            return;
        }

        List<Map<String, Object>> missions = new ArrayList<>();

        String sql = "SELECT id, title, description, category, difficulty, "
                   + "option_a, option_b, option_c, option_d, "
                   + "correct_answer, xp_reward "
                   + "FROM missions ORDER BY id DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Map<String, Object> mission = new HashMap<>();

                mission.put("id", rs.getInt("id"));
                mission.put("title", rs.getString("title"));
                mission.put("description", rs.getString("description"));
                mission.put("category", rs.getString("category"));
                mission.put("difficulty", rs.getString("difficulty"));
                mission.put("option_a", rs.getString("option_a"));
                mission.put("option_b", rs.getString("option_b"));
                mission.put("option_c", rs.getString("option_c"));
                mission.put("option_d", rs.getString("option_d"));
                mission.put("correct_answer", rs.getString("correct_answer"));
                mission.put("xp_reward", rs.getInt("xp_reward"));

                missions.add(mission);
            }

            request.setAttribute("missions", missions);

            // Pass the retrieved questions to the JSP.
            request.getRequestDispatcher("/view-questions.jsp")
                   .forward(request, response);

        } catch (SQLException e) {
            getServletContext().log("Failed to retrieve missions.", e);

            request.setAttribute("errorMessage",
                    "Unable to load missions. Please check the database connection.");

            request.getRequestDispatcher("/view-questions.jsp")
                   .forward(request, response);
        }
    }
}
