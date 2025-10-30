package com.hpms.servlet;

import java.io.IOException;
import java.security.MessageDigest;
import java.sql.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    private String hashPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hashed = md.digest(password.getBytes());
            StringBuilder sb = new StringBuilder();
            for (byte b : hashed) sb.append(String.format("%02x", b));
            return sb.toString();
        } catch (Exception e) {
            throw new RuntimeException("Hash error", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String roleInput = request.getParameter("role"); // role chosen from dropdown

        try (Connection conn = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/hpms_db",
                "root", "Rajp@123")) {

            String sql = "SELECT UserID, PasswordHash, Role, FullName FROM Users WHERE Username=? AND Role=?";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, username);
            pstmt.setString(2, roleInput);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next() && hashPassword(password).equals(rs.getString("PasswordHash"))) {
                HttpSession session = request.getSession();
                session.setAttribute("userID", rs.getInt("UserID"));
                session.setAttribute("role", rs.getString("Role"));
                session.setAttribute("fullName", rs.getString("FullName"));

                // Redirect based on role
                switch (rs.getString("Role")) {
                    case "Doctor":
                        response.sendRedirect(request.getContextPath() + "/dashboard.jsp");
                        break;
                    case "Admin":
                        response.sendRedirect(request.getContextPath() + "/adminDashboard.jsp");
                        break;
                    case "User":
                        response.sendRedirect(request.getContextPath() + "/userDashboard.jsp");
                        break;
                }
            } else {
                request.setAttribute("error", "Invalid username, password, or role");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            throw new ServletException("Database error: " + e.getMessage(), e);
        }
    }
}
