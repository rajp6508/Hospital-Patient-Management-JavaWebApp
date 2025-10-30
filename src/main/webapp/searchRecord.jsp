<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="jakarta.servlet.http.HttpSession"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Search Patient Records - HPMS</title>
<link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<style>
body { margin:0; padding:0; font-family:'Roboto',Arial,sans-serif; background:linear-gradient(135deg,#e3f2fd 0%,#bbdefb 100%); min-height:100vh; display:flex; flex-direction:column; align-items:center; padding:20px; box-sizing:border-box; }
.header { background: linear-gradient(135deg,#007bff 0%,#0056b3 100%), url('https://images.unsplash.com/photo-1576091160399-112ba8d25d1f?ixlib=rb-4.0.3&auto=format&fit=crop&w=1920&q=80') center/cover; color:white; padding:20px; text-align:center; position:relative; width:100%; max-width:900px; border-radius:12px; box-shadow:0 4px 20px rgba(0,123,255,0.3); }
.header::before { content:''; position:absolute; top:0; left:0; right:0; bottom:0; background:rgba(0,0,0,0.4); border-radius:12px; z-index:1; }
.header h1 { position:relative; z-index:2; margin:0; font-size:1.8em; display:flex; align-items:center; justify-content:center; gap:10px; }
.container { background:#fff; padding:30px 40px; border-radius:12px; box-shadow:0 8px 32px rgba(0,0,0,0.1); max-width:900px; width:100%; margin-top:20px; box-sizing:border-box; }
input[type="text"] { width:100%; padding:12px 12px 12px 40px; border:1px solid #ddd; border-radius:6px; font-size:14px; margin-right:10px; box-sizing:border-box; }
input[type="text"]::placeholder { color:#999; }
button { padding:12px 20px; background-color:#007bff; color:white; border:none; border-radius:8px; cursor:pointer; font-size:14px; font-weight:500; transition:all 0.3s ease; }
button:hover { background-color:#0056b3; transform:translateY(-2px) scale(1.02); box-shadow:0 4px 12px rgba(0,123,255,0.3); }
form { display:flex; gap:10px; margin-bottom:20px; flex-wrap:wrap; }
table { width:100%; border-collapse:collapse; margin-top:10px; }
th, td { padding:12px; border-bottom:1px solid #ddd; text-align:left; font-size:14px; }
th { background:#f8f9fa; }
.error { color:#dc3545; background:#f8d7da; padding:10px; border-radius:6px; margin-top:10px; border:1px solid #f5c6cb; }
a { color:#007bff; text-decoration:none; }
a:hover { text-decoration:underline; }
.back-link { margin-top:20px; text-align:center; }
@media(max-width:768px){ form{flex-direction:column;} input, button{width:100%;} }
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
    <h1><i class="fas fa-hospital-user"></i> Search Patient Records</h1>
</div>

<div class="container">
    <p>Welcome, <b><%=fullName%></b>. Search patient records by name below:</p>

    <form action="<%=request.getContextPath()%>/searchRecords" method="get">
        <i class="fas fa-search" style="position:absolute;margin-left:10px;margin-top:12px;color:#007bff;"></i>
        <input type="text" name="name" placeholder="Enter patient name" required />
        <button type="submit"><i class="fas fa-search"></i> Search</button>
    </form>

    <%
        String error = (String) request.getAttribute("error");
        if(error != null) {
    %>
        <div class="error"><%=error%></div>
    <%
        }

        java.util.List<java.util.Map<String,Object>> patients = 
            (java.util.List<java.util.Map<String,Object>>) request.getAttribute("patients");
        if(patients != null && !patients.isEmpty()) {
    %>
        <table>
            <tr>
                <th>Patient ID</th>
                <th>Name</th>
                <th>Age</th>
                <th>Gender</th>
                <th>Phone</th>
                <th>Status</th>
                <th>Action</th>
            </tr>
            <%
                for(java.util.Map<String,Object> p : patients) {
            %>
            <tr>
                <td><%=p.get("PatientID")%></td>
                <td><%=p.get("Name")%></td>
                <td><%=p.get("Age")%></td>
                <td><%=p.get("Gender")%></td>
                <td><%=p.get("Phone")%></td>
                <td><%=p.get("Status")%></td>
                <td><a href="<%=request.getContextPath()%>/viewRecords?patientID=<%=p.get("PatientID")%>">View Records</a></td>
            </tr>
            <%
                }
            %>
        </table>
    <%
        } else if(patients != null) {
    %>
        <p>No records found for this name.</p>
    <%
        }
    %>

    <div class="back-link">
        <a href="dashboard.jsp"><i class="fas fa-arrow-left"></i> Back to Dashboard</a>
    </div>
</div>

</body>
</html>
