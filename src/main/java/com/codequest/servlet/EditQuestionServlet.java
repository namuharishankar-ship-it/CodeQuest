package com.codequest.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.codequest.util.DBConnection;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/edit-question")
public class EditQuestionServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private boolean isAdmin(HttpServletRequest request,
                            HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect(
                request.getContextPath() + "/admin-login.jsp");
            return false;
        }

        return true;
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdmin(request, response)) {
            return;
        }

        int id;

        try {
            id = Integer.parseInt(request.getParameter("id"));
            if (id <= 0) {
                throw new NumberFormatException();
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(
                request.getContextPath() + "/view-questions");
            return;
        }

        String sql = "SELECT * FROM missions WHERE id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    request.getSession().setAttribute(
                        "adminMessage", "Mission not found.");

                    response.sendRedirect(
                        request.getContextPath() + "/view-questions");
                    return;
                }

                request.setAttribute("missionId", rs.getInt("id"));
                request.setAttribute("title", rs.getString("title"));
                request.setAttribute("description", rs.getString("description"));
                request.setAttribute("category", rs.getString("category"));
                request.setAttribute("difficulty", rs.getString("difficulty"));
                request.setAttribute("optionA", rs.getString("option_a"));
                request.setAttribute("optionB", rs.getString("option_b"));
                request.setAttribute("optionC", rs.getString("option_c"));
                request.setAttribute("optionD", rs.getString("option_d"));
                request.setAttribute("correctAnswer", rs.getString("correct_answer"));
                request.setAttribute("xpReward", rs.getInt("xp_reward"));
            }

            RequestDispatcher dispatcher =
                request.getRequestDispatcher("/edit-question.jsp");

            dispatcher.forward(request, response);

        } catch (Exception e) {
            throw new ServletException("Unable to load mission.", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdmin(request, response)) {
            return;
        }

        request.setCharacterEncoding("UTF-8");

        int id;
        int xpReward;

        try {
            id = Integer.parseInt(request.getParameter("id"));
            xpReward = Integer.parseInt(request.getParameter("xpReward"));

            if (id <= 0 || xpReward < 1 || xpReward > 1000) {
                throw new NumberFormatException();
            }
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage",
                "Invalid mission ID or XP reward.");
            response.sendError(HttpServletResponse.SC_BAD_REQUEST,
                "Invalid mission ID or XP reward.");
            return;
        }

        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String category = request.getParameter("category");
        String difficulty = request.getParameter("difficulty");
        String optionA = request.getParameter("optionA");
        String optionB = request.getParameter("optionB");
        String optionC = request.getParameter("optionC");
        String optionD = request.getParameter("optionD");
        String correctChoice = request.getParameter("correctAnswer");

        if (title == null || title.trim().isEmpty()
                || description == null || description.trim().isEmpty()
                || optionA == null || optionA.trim().isEmpty()
                || optionB == null || optionB.trim().isEmpty()
                || optionC == null || optionC.trim().isEmpty()
                || optionD == null || optionD.trim().isEmpty()
                || category == null
                || !category.matches("Java|Python|C|SQL|General")
                || difficulty == null
                || !difficulty.matches("Easy|Medium|Hard")
                || correctChoice == null
                || !correctChoice.matches("A|B|C|D")) {

            response.sendError(HttpServletResponse.SC_BAD_REQUEST,
                "Please provide valid mission details.");
            return;
        }

        String correctAnswer;

        switch (correctChoice) {
            case "A": correctAnswer = optionA.trim(); break;
            case "B": correctAnswer = optionB.trim(); break;
            case "C": correctAnswer = optionC.trim(); break;
            default:  correctAnswer = optionD.trim(); break;
        }

        String sql = "UPDATE missions SET title=?, description=?, "
            + "category=?, difficulty=?, option_a=?, option_b=?, "
            + "option_c=?, option_d=?, correct_answer=?, xp_reward=? "
            + "WHERE id=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, title.trim());
            ps.setString(2, description.trim());
            ps.setString(3, category);
            ps.setString(4, difficulty);
            ps.setString(5, optionA.trim());
            ps.setString(6, optionB.trim());
            ps.setString(7, optionC.trim());
            ps.setString(8, optionD.trim());
            ps.setString(9, correctAnswer);
            ps.setInt(10, xpReward);
            ps.setInt(11, id);

            if (ps.executeUpdate() > 0) {
                request.getSession().setAttribute(
                    "adminMessage", "Mission updated successfully.");
            } else {
                request.getSession().setAttribute(
                    "adminMessage", "Mission not found.");
            }

            response.sendRedirect(
                request.getContextPath() + "/view-questions");

        } catch (Exception e) {
            throw new ServletException("Unable to update mission.", e);
        }
    }
}
