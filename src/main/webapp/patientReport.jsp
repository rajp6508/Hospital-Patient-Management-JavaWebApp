<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    String jdbcURL = "jdbc:mysql://localhost:3306/hpms_db";
    String jdbcUsername = "root";
    String jdbcPassword = "Rajp@123";
    request.setCharacterEncoding("UTF-8");

    // --- PRINT POPUP ---
    String printId = request.getParameter("print");
    if(printId != null){
        response.setContentType("text/html;charset=UTF-8");
        try{
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(jdbcURL,jdbcUsername,jdbcPassword);
            PreparedStatement stmt = conn.prepareStatement("SELECT * FROM patient_reports WHERE ReportID=?");
            stmt.setInt(1,Integer.parseInt(printId));
            ResultSet rs = stmt.executeQuery();
            if(rs.next()){
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Patient Report - HPMS</title>
<style>
body{font-family:'Segoe UI',Arial,sans-serif;margin:0;padding:0;background:#f4f4f4;}
.report-container{width:700px;margin:30px auto;padding:30px;background:white;border-radius:10px;box-shadow:0 0 15px rgba(0,0,0,0.2);}
h1{text-align:center;color:#007bff;margin-bottom:30px;}
.report-section{margin-bottom:20px;}
.report-section label{font-weight:bold;color:#333;}
.report-section p{margin:5px 0;font-size:16px;}
.report-footer{text-align:center;margin-top:30px;font-size:14px;color:#555;}
.print-btn{display:block;margin:20px auto;padding:10px 25px;background:#28a745;color:white;border:none;border-radius:5px;font-size:16px;cursor:pointer;}
.print-btn:hover{background:#218838;}
@media print{
    .print-btn{display:none;}
    body{background:white;}
}
</style>
</head>
<body>
<div class="report-container">
    <h1>Patient Report</h1>
    <div class="report-section">
        <label>Patient Name:</label>
        <p><%= rs.getString("PatientName") %></p>
    </div>
    <div class="report-section">
        <label>Diagnosis:</label>
        <p><%= rs.getString("Diagnosis") %></p>
    </div>
    <div class="report-section">
        <label>Essential Info:</label>
        <p><%= rs.getString("EssentialInfo") %></p>
    </div>
    <div class="report-section">
        <label>Generated On:</label>
        <p><%= rs.getTimestamp("CreatedDate") %></p>
    </div>
    <button class="print-btn" onclick="window.print()">Print Report</button>
    <div class="report-footer">
        HPMS - Hospital Patient Management System
    </div>
</div>
</body>
</html>
<%
            }
            rs.close(); stmt.close(); conn.close();
        }catch(Exception e){
            out.println("<p style='color:red;'>Print Error: "+e.getMessage()+"</p>");
        }
        return; // stop executing main page
    }

    // --- HANDLE DELETE ---
    String deleteId = request.getParameter("deleteId");
    if(deleteId != null){
        try{
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(jdbcURL,jdbcUsername,jdbcPassword);
            PreparedStatement stmt = conn.prepareStatement("DELETE FROM patient_reports WHERE ReportID=?");
            stmt.setInt(1,Integer.parseInt(deleteId));
            stmt.executeUpdate(); stmt.close(); conn.close();
        }catch(Exception e){ out.println("<p style='color:red;'>Delete Error: "+e.getMessage()+"</p>"); }
    }

    // --- HANDLE EDIT FETCH ---
    String editId = request.getParameter("editId");
    String editPatient="", editDiagnosis="", editInfo="";
    if(editId != null){
        try{
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(jdbcURL,jdbcUsername,jdbcPassword);
            PreparedStatement stmt = conn.prepareStatement("SELECT * FROM patient_reports WHERE ReportID=?");
            stmt.setInt(1,Integer.parseInt(editId));
            ResultSet rs = stmt.executeQuery();
            if(rs.next()){
                editPatient = rs.getString("PatientName");
                editDiagnosis = rs.getString("Diagnosis");
                editInfo = rs.getString("EssentialInfo");
            }
            rs.close(); stmt.close(); conn.close();
        }catch(Exception e){ out.println("<p style='color:red;'>Edit Fetch Error: "+e.getMessage()+"</p>"); }
    }

    // --- HANDLE INSERT / UPDATE ---
    String reportPatient = request.getParameter("PatientName");
    String reportDiagnosis = request.getParameter("Diagnosis");
    String reportInfo = request.getParameter("EssentialInfo");
    String updateId = request.getParameter("updateId");

    if(reportPatient != null && reportDiagnosis != null){
        try{
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(jdbcURL,jdbcUsername,jdbcPassword);
            PreparedStatement stmt;
            if(updateId != null){
                stmt = conn.prepareStatement(
                    "UPDATE patient_reports SET PatientName=?, Diagnosis=?, EssentialInfo=? WHERE ReportID=?"
                );
                stmt.setString(1,reportPatient);
                stmt.setString(2,reportDiagnosis);
                stmt.setString(3,reportInfo);
                stmt.setInt(4,Integer.parseInt(updateId));
                stmt.executeUpdate();
            }else{
                stmt = conn.prepareStatement(
                    "INSERT INTO patient_reports (PatientName, Diagnosis, EssentialInfo) VALUES(?,?,?)"
                );
                stmt.setString(1,reportPatient);
                stmt.setString(2,reportDiagnosis);
                stmt.setString(3,reportInfo);
                stmt.executeUpdate();
            }
            stmt.close(); conn.close();
        }catch(Exception e){ out.println("<p style='color:red;'>DB Error: "+e.getMessage()+"</p>"); }
    }
%>

