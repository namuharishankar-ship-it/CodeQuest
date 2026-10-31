package com.codequest.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import com.codequest.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/delete-question")
public class DeleteQuestionServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect(
                request.getContextPath() + "/admin-login.jsp");
            return;
        }

        int missionId;

        try {
            missionId = Integer.parseInt(request.getParameter("id"));

            if (missionId <= 0) {
                throw new NumberFormatException();
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(
                request.getContextPath() + "/view-questions");
            return;
        }

        String sql = "DELETE FROM missions WHERE id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, missionId);

            int deleted = ps.executeUpdate();

            if (deleted > 0) {
                session.setAttribute(
                    "adminMessage", "Mission deleted successfully.");
            } else {
                session.setAttribute(
                    "adminMessage", "Mission not found.");
            }

        } catch (java.sql.SQLException e) {
            getServletContext().log("Unable to delete mission.", e);

            session.setAttribute(
                "adminMessage",
                "Unable to delete this mission. It may have student submissions."
            );
        }

        response.sendRedirect(
            request.getContextPath() + "/view-questions");
    }
}
