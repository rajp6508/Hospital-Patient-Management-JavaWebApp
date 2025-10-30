<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.List"%>
<%@ page import="jakarta.servlet.http.HttpSession"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Patient Records</title>
<style>
body { font-family: Arial, sans-serif; background: #f4f4f4; margin: 0; }
.header { background: #007bff; color: white; padding: 15px; text-align: center; }
.container { max-width: 900px; margin: 20px auto; background: white; padding: 20px; border-radius: 8px; }
table { width: 100%; border-collapse: collapse; margin-top: 20px; }
th, td { padding: 10px; border-bottom: 1px solid #ddd; text-align: left; }
th { background: #f8f9fa; }
.error { color: red; margin-top: 10px; }
</style>
</head>
<body>

<%

if(session == null || session.getAttribute("role") == null) {
    response.sendRedirect("login.jsp");
    return;
}
String fullName = (String) session.getAttribute("fullName");

Map<String,Object> patientInfo = (Map<String,Object>) request.getAttribute("patientInfo");
List<Map<String,Object>> records = (List<Map<String,Object>>) request.getAttribute("records");
String error = (String) request.getAttribute("error");
%>

<div class="header">
    <h1>Patient Records</h1>
</div>

<div class="container">
    <p>Welcome, <b><%=fullName%></b>.</p>

    <% if(error != null) { %>
        <div class="error"><%=error%></div>
    <% } else if(patientInfo != null) { %>
        <h2>Patient Details</h2>
        <p><b>Name:</b> <%=patientInfo.get("name")%></p>
        <p><b>Age:</b> <%=patientInfo.get("age")%></p>
        <p><b>Gender:</b> <%=patientInfo.get("gender")%></p>
        <p><b>Phone:</b> <%=patientInfo.get("phone")%></p>
        <p><b>Email:</b> <%=patientInfo.get("email")%></p>
        <p><b>Status:</b> <%=patientInfo.get("status")%></p>

        <h2>Medical Records</h2>
        <% if(records != null && !records.isEmpty()) { %>
            <table>
                <tr>
                    <th>Record ID</th>
                    <th>Visit Date</th>
                    <th>Diagnosis</th>
                    <th>Treatment</th>
                    <th>Doctor Notes</th>
                </tr>
                <% for(Map<String,Object> r : records) { %>
                <tr>
                    <td><%=r.get("recordID")%></td>
                    <td><%=r.get("visitDate")%></td>
                    <td><%=r.get("diagnosis")%></td>
                    <td><%=r.get("treatment")%></td>
                    <td><%=r.get("doctorNotes")%></td>
                </tr>
                <% } %>
            </table>
        <% } else { %>
            <p>No medical records found for this patient.</p>
        <% } %>
    <% } %>
</div>

</body>
</html>
