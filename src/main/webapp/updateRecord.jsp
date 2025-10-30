<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="jakarta.servlet.http.HttpSession"%>
<%@ page import="java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Update Treatment - HPMS</title>
<link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<style>
body { margin:0; padding:0; font-family:'Roboto',Arial,sans-serif; background:linear-gradient(135deg,#e3f2fd 0%,#bbdefb 100%); min-height:100vh; display:flex; flex-direction:column; align-items:center; padding:20px; box-sizing:border-box; }
.header { background: linear-gradient(135deg,#007bff 0%,#0056b3 100%), url('https://images.unsplash.com/photo-1576091160399-112ba8d25d1f?ixlib=rb-4.0.3&auto=format&fit=crop&w=1920&q=80') center/cover; color:white; padding:20px; text-align:center; position:relative; width:100%; max-width:700px; border-radius:12px; box-shadow:0 4px 20px rgba(0,123,255,0.3); }
.header::before { content:''; position:absolute; top:0; left:0; right:0; bottom:0; background:rgba(0,0,0,0.4); border-radius:12px; z-index:1; }
.header h1 { position:relative; z-index:2; margin:0; font-size:1.8em; display:flex; align-items:center; justify-content:center; gap:10px; }
.container { background:#fff; padding:30px 40px; border-radius:12px; box-shadow:0 8px 32px rgba(0,0,0,0.1); max-width:700px; width:100%; margin-top:20px; box-sizing:border-box; }
form { display:grid; gap:18px; }
label { font-weight:500; margin-bottom:5px; color:#333; }
input[type="text"], select, textarea { width:100%; padding:12px 12px 12px 40px; border:1px solid #ddd; border-radius:6px; font-size:14px; box-sizing:border-box; }
textarea { resize:vertical; min-height:80px; }
input[type="text"]::placeholder, textarea::placeholder { color:#999; }
button { padding:12px; background-color:#28a745; color:white; border:none; border-radius:8px; cursor:pointer; font-size:16px; font-weight:500; transition:all 0.3s ease; }
button:hover { background-color:#218838; transform:translateY(-2px) scale(1.02); box-shadow:0 4px 12px rgba(40,167,69,0.3); }
.error { color:#dc3545; margin:10px 0; text-align:center; background:#f8d7da; padding:10px; border-radius:6px; border:1px solid #f5c6cb; }
.success { color:#155724; margin:10px 0; text-align:center; background:#d4edda; padding:10px; border-radius:6px; border:1px solid #c3e6cb; }
.back-link { text-align:center; margin-top:20px; font-size:14px; }
.back-link a { color:#007bff; text-decoration:none; display:inline-flex; align-items:center; gap:5px; transition:color 0.3s ease; }
.back-link a:hover { color:#0056b3; text-decoration:underline; }
.input-icon { position:relative; }
.input-icon i { position:absolute; left:12px; top:50%; transform:translateY(-50%); color:#007bff; pointer-events:none; }
@media(max-width:768px){ .container{padding:20px;} input, select, textarea, button{font-size:14px;} }
</style>
</head>
<body>

<%
if(session == null || session.getAttribute("role") == null) {
    response.sendRedirect("login.jsp");
    return;
}
String fullName = (String) session.getAttribute("fullName");
%>

<div class="header">
    <h1><i class="fas fa-notes-medical"></i> Update Treatment</h1>
</div>

<div class="container">
    <p>Welcome, <b><%=fullName%></b>. Select a patient and update their treatment below:</p>

    <form action="UpdateTreatmentServlet" method="post">
        <div class="input-icon">
            <label for="patientID">Select Patient:</label>
            <i class="fas fa-user-injured"></i>
            <select name="patientID" id="patientID" required>
                <option value="">--Select Patient--</option>
                <%
                try(Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/hpms_db","root","Rajp@123")) {
                    String sql = "SELECT PatientID, Name FROM Patients ORDER BY Name";
                    PreparedStatement ps = conn.prepareStatement(sql);
                    ResultSet rs = ps.executeQuery();
                    while(rs.next()) {
                %>
                <option value="<%=rs.getInt("PatientID")%>"><%=rs.getString("Name")%></option>
                <%
                    }
                } catch(Exception e) { 
                    out.println("<option disabled>Error loading patients</option>");
                }
                %>
            </select>
        </div>

        <div class="input-icon">
            <label for="diagnosis">Diagnosis:</label>
            <i class="fas fa-stethoscope"></i>
            <input type="text" name="diagnosis" id="diagnosis" placeholder="Enter diagnosis" required />
        </div>

        <div class="input-icon">
            <label for="treatment">Treatment:</label>
            <i class="fas fa-pills"></i>
            <textarea name="treatment" id="treatment" placeholder="Enter treatment details" required></textarea>
        </div>

        <div class="input-icon">
            <label for="doctorNotes">Doctor Notes:</label>
            <i class="fas fa-file-medical-alt"></i>
            <textarea name="doctorNotes" id="doctorNotes" placeholder="Enter notes"></textarea>
        </div>

        <button type="submit"><i class="fas fa-save"></i> Update Treatment</button>
    </form>

    <%
        String error = (String) request.getAttribute("error");
        String success = (String) request.getAttribute("success");
        if(error != null) { %>
            <div class="error"><%=error%></div>
        <% } else if(success != null) { %>
            <div class="success"><%=success%></div>
    <% } %>

    <div class="back-link">
        <a href="dashboard.jsp"><i class="fas fa-arrow-left"></i> Back to Dashboard</a>
    </div>
</div>

</body>
</html>
