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
import java.sql.SQLException;

@WebServlet("/add-question")
public class AddQuestionServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;

	@Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect(
                request.getContextPath() + "/admin-login.jsp"
            );
            return;
        }

        request.getRequestDispatcher("/add-question.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect(
                request.getContextPath() + "/admin-login.jsp"
            );
            return;
        }

        request.setCharacterEncoding("UTF-8");

        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String category = request.getParameter("category");
        String difficulty = request.getParameter("difficulty");
        String optionA = request.getParameter("optionA");
        String optionB = request.getParameter("optionB");
        String optionC = request.getParameter("optionC");
        String optionD = request.getParameter("optionD");
        String correctAnswer = request.getParameter("correctAnswer");

        int xpReward;
        int adminId;

        try {
            xpReward = Integer.parseInt(request.getParameter("xpReward"));
            adminId = ((Number) session.getAttribute("adminId")).intValue();
        } catch (NumberFormatException | NullPointerException e) {
            request.setAttribute("errorMessage",
                    "Invalid admin session or XP reward.");
            request.getRequestDispatcher("/add-question.jsp")
                   .forward(request, response);
            return;
        }

        if (isBlank(title) || isBlank(description)
                || isBlank(category) || isBlank(difficulty)
                || isBlank(optionA) || isBlank(optionB)
                || isBlank(optionC) || isBlank(optionD)
                || isBlank(correctAnswer)) {

            request.setAttribute("errorMessage",
                    "Please fill in all fields.");
            request.getRequestDispatcher("/add-question.jsp")
                   .forward(request, response);
            return;
        }

        title = title.trim();
        description = description.trim();
        category = category.trim();
        difficulty = difficulty.trim();
        optionA = optionA.trim();
        optionB = optionB.trim();
        optionC = optionC.trim();
        optionD = optionD.trim();
        correctAnswer = correctAnswer.trim().toUpperCase();

        if (title.length() > 100
                || optionA.length() > 255
                || optionB.length() > 255
                || optionC.length() > 255
                || optionD.length() > 255
                || xpReward < 1 || xpReward > 1000) {

            request.setAttribute("errorMessage",
                    "Please check the title, option lengths and XP reward.");
            request.getRequestDispatcher("/add-question.jsp")
                   .forward(request, response);
            return;
        }

        if (!category.matches("Java|Python|C|SQL|General")
                || !difficulty.matches("Easy|Medium|Hard")
                || !correctAnswer.matches("A|B|C|D")) {

            request.setAttribute("errorMessage",
                    "Invalid category, difficulty or correct answer.");
            request.getRequestDispatcher("/add-question.jsp")
                   .forward(request, response);
            return;
        }

        String correctAnswerText;

        switch (correctAnswer) {
            case "A":
                correctAnswerText = optionA;
                break;
            case "B":
                correctAnswerText = optionB;
                break;
            case "C":
                correctAnswerText = optionC;
                break;
            default:
                correctAnswerText = optionD;
                break;
        }

        String sql = "INSERT INTO missions "
                + "(title, description, category, difficulty, "
                + "option_a, option_b, option_c, option_d, "
                + "correct_answer, xp_reward, created_by) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, title);
            ps.setString(2, description);
            ps.setString(3, category);
            ps.setString(4, difficulty);
            ps.setString(5, optionA);
            ps.setString(6, optionB);
            ps.setString(7, optionC);
            ps.setString(8, optionD);
            ps.setString(9, correctAnswerText);
            ps.setInt(10, xpReward);
            ps.setInt(11, adminId);

            ps.executeUpdate();

            request.setAttribute("successMessage",
                    "Mission added successfully!");

            request.getRequestDispatcher("/add-question.jsp")
                   .forward(request, response);

        } catch (SQLException e) {
            getServletContext().log("Failed to save mission.", e);

            request.setAttribute("errorMessage",
                    "Could not save the mission. Please check the database configuration.");
            request.getRequestDispatcher("/add-question.jsp")
                   .forward(request, response);
        }
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}
