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

@WebServlet("/viewRecords")
public class ViewRecordsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if(session == null || session.getAttribute("role") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String patientIDStr = request.getParameter("patientID");
        if(patientIDStr == null || patientIDStr.trim().isEmpty()) {
            request.setAttribute("error", "Patient ID is required.");
            request.getRequestDispatcher("/viewRecords.jsp").forward(request, response);
            return;
        }

        int patientID;
        try {
            patientID = Integer.parseInt(patientIDStr);
        } catch(NumberFormatException e) {
            request.setAttribute("error", "Invalid Patient ID format.");
            request.getRequestDispatcher("/viewRecords.jsp").forward(request, response);
            return;
        }

        Map<String,Object> patientInfo = new HashMap<>();
        List<Map<String,Object>> records = new ArrayList<>();

        try(Connection conn = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/hpms_db","root","Rajp@123")) {

            // Patient info
            String sqlPatient = "SELECT * FROM Patients WHERE PatientID=?";
            try(PreparedStatement ps = conn.prepareStatement(sqlPatient)) {
                ps.setInt(1, patientID);
                ResultSet rs = ps.executeQuery();
                if(rs.next()) {
                    patientInfo.put("name", rs.getString("Name"));
                    patientInfo.put("age", rs.getInt("Age"));
                    patientInfo.put("gender", rs.getString("Gender"));
                    patientInfo.put("phone", rs.getString("Phone"));
                    patientInfo.put("email", rs.getString("Email"));
                    patientInfo.put("status", rs.getString("Status"));
                } else {
                    request.setAttribute("error", "Patient not found.");
                    request.getRequestDispatcher("/viewRecords.jsp").forward(request, response);
                    return;
                }
            }

            // Medical records
            String sqlRecords = "SELECT RecordID, VisitDate, Diagnosis, Treatment, DoctorNotes FROM MedicalRecords WHERE PatientID=? ORDER BY VisitDate DESC";
            try(PreparedStatement ps = conn.prepareStatement(sqlRecords)) {
                ps.setInt(1, patientID);
                ResultSet rs = ps.executeQuery();
                while(rs.next()) {
                    Map<String,Object> r = new HashMap<>();
                    r.put("recordID", rs.getInt("RecordID"));
                    r.put("visitDate", rs.getDate("VisitDate"));
                    r.put("diagnosis", rs.getString("Diagnosis"));
                    r.put("treatment", rs.getString("Treatment"));
                    r.put("doctorNotes", rs.getString("DoctorNotes"));
                    records.add(r);
                }
            }

        } catch(SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error: " + e.getMessage());
        }

        request.setAttribute("patientInfo", patientInfo);
        request.setAttribute("records", records);
        request.getRequestDispatcher("/viewRecords.jsp").forward(request, response);
    }
}
