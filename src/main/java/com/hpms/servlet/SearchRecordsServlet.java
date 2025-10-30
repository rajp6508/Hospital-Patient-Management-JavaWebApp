package com.hpms.servlet;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/searchRecords")
public class SearchRecordsServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("role") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String name = request.getParameter("name");
        if (name == null || name.trim().isEmpty()) {
            request.setAttribute("error", "Please enter a name to search.");
            request.getRequestDispatcher("/searchRecord.jsp").forward(request, response);
            return;
        }

        List<Map<String,Object>> patients = new ArrayList<>();
        try (Connection conn = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/hpms_db","root","Rajp@123")) {

            String sql = "SELECT PatientID, Name, Age, Gender, Phone, Status FROM Patients WHERE Name LIKE ?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, "%" + name.trim() + "%");
                ResultSet rs = ps.executeQuery();
                while(rs.next()) {
                    Map<String,Object> p = new HashMap<>();
                    p.put("PatientID", rs.getInt("PatientID"));
                    p.put("Name", rs.getString("Name"));
                    p.put("Age", rs.getInt("Age"));
                    p.put("Gender", rs.getString("Gender"));
                    p.put("Phone", rs.getString("Phone"));
                    p.put("Status", rs.getString("Status"));
                    patients.add(p);
                }
            }

            request.setAttribute("patients", patients);

        } catch(SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error: " + e.getMessage());
        }

        request.getRequestDispatcher("/searchRecord.jsp").forward(request, response);
    }
}
