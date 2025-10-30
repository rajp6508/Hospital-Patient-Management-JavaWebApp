package com.hpms.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.Timestamp;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/UpdateTreatmentServlet")
public class UpdateTreatmentServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if(session == null || session.getAttribute("role") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String role = (String) session.getAttribute("role");
        if(!"Doctor".equalsIgnoreCase(role)) {
            request.setAttribute("error", "Only doctors can update treatments.");
            request.getRequestDispatcher("/updateRecord.jsp").forward(request, response);
            return;
        }

        String patientIDStr = request.getParameter("patientID");
        String diagnosis = request.getParameter("diagnosis");
        String treatment = request.getParameter("treatment");
        String doctorNotes = request.getParameter("doctorNotes");
        Integer doctorID = (Integer) session.getAttribute("userID");

        if(patientIDStr == null || patientIDStr.isEmpty() || diagnosis == null || treatment == null) {
            request.setAttribute("error", "All required fields must be filled.");
            request.getRequestDispatcher("/updateRecord.jsp").forward(request, response);
            return;
        }

        int patientID = Integer.parseInt(patientIDStr);

        try(Connection conn = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/hpms_db","root","Rajp@123")) {

            String sql = "INSERT INTO MedicalRecords (PatientID, VisitDate, Diagnosis, Treatment, DoctorNotes, UpdatedBy, UpdatedDate) " +
                         "VALUES (?, NOW(), ?, ?, ?, ?, ?)";
            try(PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, patientID);
                ps.setString(2, diagnosis);
                ps.setString(3, treatment);
                ps.setString(4, doctorNotes);
                ps.setInt(5, doctorID);
                ps.setTimestamp(6, new Timestamp(System.currentTimeMillis()));

                int rows = ps.executeUpdate();
                if(rows > 0) {
                    request.setAttribute("success", "Treatment updated successfully!");
                } else {
                    request.setAttribute("error", "Failed to update treatment.");
                }
            }

        } catch(Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error: " + e.getMessage());
        }

        request.getRequestDispatcher("/updateRecord.jsp").forward(request, response);
    }
}
