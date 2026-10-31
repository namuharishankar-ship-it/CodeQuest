package com.codequest.util;

import java.sql.*;

public class DBConnection {

    private static final String URL =
            "jdbc:mysql://localhost:3306/codequest_db";

    private static final String USER = "root";

    // Replace this with your actual MySQL password.
    private static final String PASSWORD = "hari@sql123";

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new ExceptionInInitializerError(
                    "MySQL JDBC driver not found: " + e.getMessage()
            );
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}
