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

@WebServlet("/submit-answer")
public class SubmitAnswerServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;

	@Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(
                request.getContextPath() + "/login.jsp"
            );
            return;
        }

        int userId = ((Number) session.getAttribute("userId")).intValue();

        int missionId;
        String selectedAnswer = request.getParameter("answer");

        try {
            missionId = Integer.parseInt(request.getParameter("missionId"));
        } catch (NumberFormatException e) {
            response.sendRedirect(
                request.getContextPath() + "/missions"
            );
            return;
        }

        if (missionId <= 0 || selectedAnswer == null
                || !selectedAnswer.matches("[ABCD]")) {
            response.sendRedirect(
                request.getContextPath() + "/missions"
            );
            return;
        }

        String correctAnswer;
        int xpReward;

        try (Connection con = DBConnection.getConnection()) {

            con.setAutoCommit(false);

            try {
                // Lock the mission row while processing the answer.
                String missionSql =
                    "SELECT correct_answer, xp_reward FROM missions "
                    + "WHERE id = ? FOR UPDATE";

                try (PreparedStatement ps = con.prepareStatement(missionSql)) {
                    ps.setInt(1, missionId);

                    try (ResultSet rs = ps.executeQuery()) {
                        if (!rs.next()) {
                            con.rollback();
                            request.getSession().setAttribute(
                                "missionMessage", "Mission not found."
                            );
                            response.sendRedirect(
                                request.getContextPath() + "/missions"
                            );
                            return;
                        }

                        correctAnswer = rs.getString("correct_answer");
                        xpReward = rs.getInt("xp_reward");
                    }
                }

                // The current database stores the correct option TEXT.
                String submittedText;

                String optionColumn;
                switch (selectedAnswer) {
                    case "A": optionColumn = "option_a"; break;
                    case "B": optionColumn = "option_b"; break;
                    case "C": optionColumn = "option_c"; break;
                    default:  optionColumn = "option_d"; break;
                }

                String optionSql =
                    "SELECT " + optionColumn + " FROM missions WHERE id = ?";

                try (PreparedStatement ps = con.prepareStatement(optionSql)) {
                    ps.setInt(1, missionId);

                    try (ResultSet rs = ps.executeQuery()) {
                        rs.next();
                        submittedText = rs.getString(1);
                    }
                }

                boolean isCorrect = submittedText.equals(correctAnswer);

                // Unique (user_id, mission_id) prevents repeat submissions.
                String insertSql =
                    "INSERT INTO mission_submissions "
                    + "(user_id, mission_id, answer, is_correct) "
                    + "VALUES (?, ?, ?, ?)";

                try (PreparedStatement ps = con.prepareStatement(insertSql)) {
                    ps.setInt(1, userId);
                    ps.setInt(2, missionId);
                    ps.setString(3, submittedText);
                    ps.setBoolean(4, isCorrect);
                    ps.executeUpdate();
                }

                if (isCorrect) {
                	String updateSql =
                		    "UPDATE users "
                		    + "SET total_xp = total_xp + ?, "
                		    + "player_level = ((total_xp + ?) DIV 100) + 1 "
                		    + "WHERE id = ?";

                		try (PreparedStatement ps = con.prepareStatement(updateSql)) {
                		    ps.setInt(1, xpReward);
                		    ps.setInt(2, xpReward);
                		    ps.setInt(3, userId);
                		    ps.executeUpdate();
                		}

                    request.getSession().setAttribute(
                        "missionMessage",
                        "Correct answer! You earned " + xpReward + " XP."
                    );
                } else {
                    request.getSession().setAttribute(
                        "missionMessage",
                        "Incorrect answer. You can review the topic and try other missions."
                    );
                }

                con.commit();

            } catch (SQLException e) {
                con.rollback();

                if ("23000".equals(e.getSQLState())) {
                    request.getSession().setAttribute(
                        "missionMessage",
                        "You have already submitted this mission."
                    );
                } else {
                    throw e;
                }

            } finally {
                con.setAutoCommit(true);
            }

        } catch (SQLException e) {
            getServletContext().log("Answer submission failed.", e);

            request.getSession().setAttribute(
                "missionMessage",
                "Unable to submit your answer. Please try again."
            );
        }

        response.sendRedirect(request.getContextPath() + "/missions");
    }
}