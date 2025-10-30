package com.hpms.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/PatientSelfRegister")
public class PatientSelfRegisterServlet extends HttpServlet {

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		// Get form parameters
		String name = request.getParameter("name");
		String ageStr = request.getParameter("age");
		String gender = request.getParameter("gender");
		String phone = request.getParameter("phone");
		String email = request.getParameter("email");
		String address = request.getParameter("address");
		String emergencyContact = request.getParameter("emergencyContact");
		String medicalHistory = request.getParameter("medicalHistory");
		String confirmation = request.getParameter("confirmation");

		// Server-side validation (ensures accuracy)
		if (name == null || name.trim().isEmpty() || ageStr == null || ageStr.trim().isEmpty() || phone == null
				|| phone.trim().isEmpty() || email == null || email.trim().isEmpty() || confirmation == null
				|| !confirmation.trim().equalsIgnoreCase("HPMS")) {
			request.setAttribute("error", "All required fields must be filled. Confirmation must be 'HPMS'.");
			request.getRequestDispatcher("registerNewPatient.jsp").forward(request, response);
			return;
		}

		int age;
		try {
			age = Integer.parseInt(ageStr);
			if (age < 1 || age > 120) {
				request.setAttribute("error", "Age must be between 1 and 120");
				request.getRequestDispatcher("registerNewPatient.jsp").forward(request, response);
				return;
			}
		} catch (NumberFormatException e) {
			request.setAttribute("error", "Age must be a valid number");
			request.getRequestDispatcher("registerNewPatient.jsp").forward(request, response);
			return;
		}

		// Trim and sanitize (basic security)
		name = name.trim();
		phone = phone.trim().replaceAll("[^\\d+\\-\\s()]", ""); // Clean phone
		email = email.trim().toLowerCase();
		address = (address != null) ? address.trim() : null;
		emergencyContact = (emergencyContact != null) ? emergencyContact.trim() : null;
		medicalHistory = (medicalHistory != null) ? medicalHistory.trim() : null;
		gender = (gender != null && !gender.isEmpty()) ? gender : null;

		// Database connection (integrated with HPMS DB)
		try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/hpms_db", "root", "Rajp@123")) { // Update
																															// to
																															// your
																															// MySQL
																															// credentials

			// Check for duplicates (Phone or Email) to avoid errors
			String checkSql = "SELECT PatientID FROM Patients WHERE Phone = ? OR Email = ?";
			try (PreparedStatement checkPstmt = conn.prepareStatement(checkSql)) {
				checkPstmt.setString(1, phone);
				checkPstmt.setString(2, email);
				ResultSet rs = checkPstmt.executeQuery();
				if (rs.next()) {
					request.setAttribute("error",
							"A registration with this phone or email already exists. Please contact reception.");
					request.getRequestDispatcher("registerNewPatient.jsp").forward(request, response);
					return;
				}
			}

			// Insert as pending (automates self-registration for digital records)
			String insertSql = "INSERT INTO Patients (Name, Age, Gender, Phone, Email, Address, MedicalHistory, EmergencyContact, Status) "
					+ "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

			try (PreparedStatement insertPstmt = conn.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS)) {
				insertPstmt.setString(1, name);
				insertPstmt.setInt(2, age);
				insertPstmt.setString(3, gender);
				insertPstmt.setString(4, phone);
				insertPstmt.setString(5, email);
				insertPstmt.setString(6, address);
				insertPstmt.setString(7, medicalHistory);
				insertPstmt.setString(8, emergencyContact);
				insertPstmt.setString(9, "Active "); // set Status here
				insertPstmt.executeUpdate();

				if (address != null)
					insertPstmt.setString(6, address);
				else
					insertPstmt.setNull(6, java.sql.Types.VARCHAR);
				if (medicalHistory != null)
					insertPstmt.setString(7, medicalHistory);
				else
					insertPstmt.setNull(7, java.sql.Types.VARCHAR);
				if (emergencyContact != null)
					insertPstmt.setString(8, emergencyContact);
				else
					insertPstmt.setNull(8, java.sql.Types.VARCHAR);

				int rowsAffected = insertPstmt.executeUpdate();
				if (rowsAffected > 0) {
					// Get generated PatientID (temporary ID for patient)
					ResultSet generatedKeys = insertPstmt.getGeneratedKeys();
					int patientID = -1;
					if (generatedKeys.next()) {
						patientID = generatedKeys.getInt(1);
					}
					request.setAttribute("success",
							"Thank you for registering with HPMS! Your temporary Patient ID is: <strong>" + patientID
									+ "</strong>. "
									+ "Your digital record has been created (Status: Pending). A staff member will activate it upon verification. "
									+ "Print or save this ID for your visit.");
				} else {
					request.setAttribute("error", "Registration failed. Please try again or contact support.");
				}
			}

			// Forward to JSP to show message
			request.getRequestDispatcher("registerNewPatient.jsp").forward(request, response);

		} catch (SQLException e) {
			request.setAttribute("error",
					"System error during registration: " + e.getMessage() + ". Please try again.");
			request.getRequestDispatcher("registerNewPatient.jsp").forward(request, response);
			e.printStackTrace(); // Log for debugging
		}
	}

	// GET: Directly show the form (public access)
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.getRequestDispatcher("registerNewPatient.jsp").forward(request, response);
	}
}