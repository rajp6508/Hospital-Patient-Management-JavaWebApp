package com.hpms.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.time.LocalDate;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admit")
public class admitServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        // Session and Role Check (Admin only for admission)
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("role") == null || 
            !"Admin".equalsIgnoreCase((String) session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
            return;
        }

        // Get patient type and parameters
        String patientType = request.getParameter("patientType");
        boolean isNewPatient = "new".equals(patientType);

        // New patient params
        String newName = request.getParameter("newName");
        String newAgeStr = request.getParameter("newAge");
        String newGender = request.getParameter("newGender");
        String newPhone = request.getParameter("newPhone");
        String newEmail = request.getParameter("newEmail");
        String newAddress = request.getParameter("newAddress");
        String newMedicalHistory = request.getParameter("newMedicalHistory");

        // Existing patient param
        String patientIDStr = request.getParameter("patientID");

        // Common admission params
        String reason = request.getParameter("reason");
        String ward = request.getParameter("ward");
        String assignedDoctorStr = request.getParameter("assignedDoctor");
        String bedNumber = request.getParameter("bedNumber");
        String admissionDateStr = request.getParameter("admissionDate");

        // Validate common fields
        if (reason == null || reason.trim().isEmpty() || ward == null || ward.trim().isEmpty() || 
            assignedDoctorStr == null || assignedDoctorStr.trim().isEmpty()) {
            request.setAttribute("error", "Required fields: Admission Reason, Ward, Assigned Doctor");
            request.getRequestDispatcher("/jsp/admit.jsp").forward(request, response);
            return;
        }

        // Parse common values
        int assignedDoctorID;
        try {
            assignedDoctorID = Integer.parseInt(assignedDoctorStr);
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Assigned Doctor must be a valid selection");
            request.getRequestDispatcher("/jsp/admit.jsp").forward(request, response);
            return;
        }

        LocalDate admissionDate = LocalDate.now(); // Default to today
        if (admissionDateStr != null && !admissionDateStr.trim().isEmpty()) {
            try {
                admissionDate = LocalDate.parse(admissionDateStr);
            } catch (Exception e) {
                request.setAttribute("error", "Invalid admission date format");
                request.getRequestDispatcher("/jsp/admit.jsp").forward(request, response);
                return;
            }
        }

        // Sanitize common inputs
        reason = reason.trim();
        ward = ward.trim();
        bedNumber = (bedNumber != null) ? bedNumber.trim() : null;

        int patientID = -1;
        String patientName = null;
        String currentStatus = null;

        // Database connection
        try (Connection conn = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/hpms_db",
                "root",
                "password")) {  // Update to your MySQL credentials

            if (isNewPatient) {
                // Handle New Patient: Validate and register first
                if (newName == null || newName.trim().isEmpty() || newAgeStr == null || newAgeStr.trim().isEmpty() || 
                    newPhone == null || newPhone.trim().isEmpty()) {
                    request.setAttribute("error", "For new patients: Full Name, Age, and Phone are required");
                    request.getRequestDispatcher("/jsp/admit.jsp").forward(request, response);
                    return;
                }

                int newAge;
                try {
                    newAge = Integer.parseInt(newAgeStr);
                    if (newAge < 1 || newAge > 120) {
                        request.setAttribute("error", "Age must be between 1 and 120");
                        request.getRequestDispatcher("/jsp/admit.jsp").forward(request, response);
                        return;
                    }
                } catch (NumberFormatException e) {
                    request.setAttribute("error", "Age must be a valid number");
                    request.getRequestDispatcher("/jsp/admit.jsp").forward(request, response);
                    return;
                }

                // Sanitize new patient inputs
                newName = newName.trim();
                newPhone = newPhone.trim().replaceAll("[^\\d+\\-\\s()]", "");  // Basic phone cleaning
                String newEmailTrimmed = (newEmail != null) ? newEmail.trim().toLowerCase() : null;
                String newAddressTrimmed = (newAddress != null) ? newAddress.trim() : null;
                String newMedicalHistoryTrimmed = (newMedicalHistory != null) ? newMedicalHistory.trim() : null;
                String newGenderTrimmed = (newGender != null && !newGender.isEmpty()) ? newGender.trim() : null;

                // Check for duplicates (Phone or Email)
                String checkSql = "SELECT PatientID FROM Patients WHERE Phone = ? OR Email = ?";
                try (PreparedStatement checkPstmt = conn.prepareStatement(checkSql)) {
                    checkPstmt.setString(1, newPhone);
                    checkPstmt.setString(2, newEmailTrimmed);
                    ResultSet rs = checkPstmt.executeQuery();
                    if (rs.next()) {
                        request.setAttribute("error", "A patient with this phone or email already exists. Use existing patient flow.");
                        request.getRequestDispatcher("/jsp/admit.jsp").forward(request, response);
                        return;
                    }
                }

                // Insert new patient (Status='Active' since admitting immediately)
                String insertPatientSql = "INSERT INTO Patients (Name, Age, Gender, Phone, Email, Address, MedicalHistory, Status) " +
                                          "VALUES (?, ?, ?, ?, ?, ?, ?, 'Active')";
                try (PreparedStatement insertPatientPstmt = conn.prepareStatement(insertPatientSql, Statement.RETURN_GENERATED_KEYS)) {
                    insertPatientPstmt.setString(1, newName);
                    insertPatientPstmt.setInt(2, newAge);
                    insertPatientPstmt.setString(3, newGenderTrimmed);
                    insertPatientPstmt.setString(4, newPhone);
                    if (newEmailTrimmed != null) {
                        insertPatientPstmt.setString(5, newEmailTrimmed);
                    } else {
                        insertPatientPstmt.setNull(5, Types.VARCHAR);
                    }
                    if (newAddressTrimmed != null) {
                        insertPatientPstmt.setString(6, newAddressTrimmed);
                    } else {
                        insertPatientPstmt.setNull(6, Types.VARCHAR);
                    }
                    if (newMedicalHistoryTrimmed != null) {
                        insertPatientPstmt.setString(7, newMedicalHistoryTrimmed);
                    } else {
                        insertPatientPstmt.setNull(7, Types.VARCHAR);
                    }

                    int patientRowsAffected = insertPatientPstmt.executeUpdate();
                    if (patientRowsAffected > 0) {
                        ResultSet patientKeys = insertPatientPstmt.getGeneratedKeys();
                        if (patientKeys.next()) {
                            patientID = patientKeys.getInt(1);
                        }
                        patientName = newName;  // Use provided name
                        currentStatus = "Active";  // Newly set
                    } else {
                        request.setAttribute("error", "Failed to register new patient");
                        request.getRequestDispatcher("/jsp/admit.jsp").forward(request, response);
                        return;
                    }
                }

            } else {
                // Handle Existing Patient: Validate PatientID
                if (patientIDStr == null || patientIDStr.trim().isEmpty()) {
                    request.setAttribute("error", "Patient ID is required for existing patients");
                    request.getRequestDispatcher("/jsp/admit.jsp").forward(request, response);
                    return;
                }

                int existingPatientID;
                try {
                    existingPatientID = Integer.parseInt(patientIDStr);
                } catch (NumberFormatException e) {
                    request.setAttribute("error", "Patient ID must be a valid number");
                    request.getRequestDispatcher("/jsp/admit.jsp").forward(request, response);
                    return;
                }

                // Check if patient exists
                String patientSql = "SELECT PatientID, Name, Status FROM Patients WHERE PatientID = ?";
                try (PreparedStatement patientPstmt = conn.prepareStatement(patientSql)) {
                    patientPstmt.setInt(1, existingPatientID);
                    ResultSet patientRs = patientPstmt.executeQuery();
                    if (!patientRs.next()) {
                        request.setAttribute("error", "Patient with ID " + existingPatientID + " not found. Register or use new patient flow.");
                        request.getRequestDispatcher("/jsp/admit.jsp").forward(request, response);
                        return;
                    }
                    patientID = patientRs.getInt("PatientID");
                    patientName = patientRs.getString("Name");
                    currentStatus = patientRs.getString("Status");
                }
            }

            // Validate assigned doctor exists and is a Doctor
            String doctorSql = "SELECT UserID, FullName FROM Users WHERE UserID = ? AND Role = 'Doctor'";
            try (PreparedStatement doctorPstmt = conn.prepareStatement(doctorSql)) {
                doctorPstmt.setInt(1, assignedDoctorID);
                ResultSet doctorRs = doctorPstmt.executeQuery();
                if (!doctorRs.next()) {
                    request.setAttribute("error", "Selected doctor not found or not a valid doctor");
                    request.getRequestDispatcher("/jsp/admit.jsp").forward(request, response);
                    return;
                }
                String doctorName = doctorRs.getString("FullName");  // For success message
            }

            // Insert admission record
            String insertAdmissionSql = "INSERT INTO Admissions (PatientID, AdmissionDate, DischargeDate, Reason, AssignedDoctorID, Ward, BedNumber) " +
                                        "VALUES (?, ?, NULL, ?, ?, ?, ?)";
            try (PreparedStatement insertAdmissionPstmt = conn.prepareStatement(insertAdmissionSql, Statement.RETURN_GENERATED_KEYS)) {
                insertAdmissionPstmt.setInt(1, patientID);
                insertAdmissionPstmt.setDate(2, java.sql.Date.valueOf(admissionDate));
                insertAdmissionPstmt.setString(3, reason);
                insertAdmissionPstmt.setInt(4, assignedDoctorID);
                insertAdmissionPstmt.setString(5, ward);
                if (bedNumber != null) {
                    insertAdmissionPstmt.setString(6, bedNumber);
                } else {
                    insertAdmissionPstmt.setNull(6, Types.VARCHAR);
                }

                int admissionRowsAffected = insertAdmissionPstmt.executeUpdate();
                if (admissionRowsAffected > 0) {
                    ResultSet admissionKeys = insertAdmissionPstmt.getGeneratedKeys();
                    int admissionID = -1;
                    if (admissionKeys.next()) {
                        admissionID = admissionKeys.getInt(1);
                    }

                    // Update patient status to 'Active' if not already (e.g., for pending patients)
                    if (!"Active".equals(currentStatus)) {
                        String updateStatusSql = "UPDATE Patients SET Status = 'Active' WHERE PatientID = ?";
                        try (PreparedStatement updatePstmt = conn.prepareStatement(updateStatusSql)) {
                            updatePstmt.setInt(1, patientID);
                            updatePstmt.executeUpdate();
                        }
                    }

                    // Success message (tailored for new vs existing)
                    String successMsg = "Admission successful for " + patientName + " (Patient ID: " + patientID + ")!<br>" +
                                        "Admission ID: " + admissionID + "<br>" +
                                        "Details: Ward - " + ward + ", Doctor - Assigned, Date - " + admissionDate + "<br>" +
                                        "Reason: " + reason + (bedNumber != null ? "<br>Bed: " + bedNumber : "") + ".<br>" +
                                        "Digital records updated securely.";
                    if (isNewPatient) {
                        successMsg = "New patient " + patientName + " registered and admitted successfully!<br>" + successMsg;
                    }
                    request.setAttribute("success", successMsg);
                } else {
                    request.setAttribute("error", "Admission failed: No rows inserted");
                }
            }

            // Forward to JSP to display message
            request.getRequestDispatcher("/jsp/admit.jsp").forward(request, response);

        } catch (SQLException e) {
            request.setAttribute("error", "Database error during admission: " + e.getMessage());
            request.getRequestDispatcher("/jsp/admit.jsp").forward(request, response);
            e.printStackTrace();  // Log for debugging
        }
    }

    // GET method: Display the form (with session/role check)
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("role") == null || 
            !"Admin".equalsIgnoreCase((String) session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
            return;
        }
        request.getRequestDispatcher("/jsp/admit.jsp").forward(request, response);
    }
}
