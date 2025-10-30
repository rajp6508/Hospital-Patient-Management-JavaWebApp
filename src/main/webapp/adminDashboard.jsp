<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="jakarta.servlet.http.HttpSession"%>
<%
    
    if(session == null || session.getAttribute("role") == null || 
       !"Admin".equalsIgnoreCase((String)session.getAttribute("role"))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    String fullName = (String) session.getAttribute("fullName");
    String role = (String) session.getAttribute("role");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>HPMS Admin Dashboard</title>
<link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<style>
body { font-family: 'Roboto', Arial, sans-serif; margin:0; background:#f8f9ff; }
.header {
    background: linear-gradient(135deg, #007bff 0%, #0056b3 100%);
    color:white; padding:20px; text-align:center; position:relative;
    min-height:150px; display:flex; align-items:center; justify-content:center;
}
.header::before {
    content:''; position:absolute; top:0; left:0; right:0; bottom:0;
    background: rgba(0,0,0,0.4); z-index:1;
}
.header > * { position:relative; z-index:2; }
.logout {
    position:absolute; top:20px; right:20px;
    background:#dc3545; color:white; padding:10px 15px; text-decoration:none; border-radius:6px;
}
.logout:hover { background:#c82333; transform:scale(1.05); }
.container { max-width:1200px; margin:30px auto; background:white; padding:30px; border-radius:12px; box-shadow:0 8px 32px rgba(0,0,0,0.1);}
.welcome { margin-bottom:30px; text-align:center; padding:20px; background: linear-gradient(135deg,#e3f2fd 0%,#f3e5f5 100%); border-radius:12px; }
.welcome i { font-size:3em; color:#007bff; margin-bottom:10px; display:block; animation:pulse 2s infinite; }
.nav-menu { display:grid; grid-template-columns: repeat(auto-fit,minmax(250px,1fr)); gap:20px; }
.nav-card {
    background:linear-gradient(135deg,#fff 0%,#f8f9fa 100%);
    border-radius:12px; padding:20px; text-align:center;
    box-shadow:0 4px 16px rgba(0,0,0,0.1); transition:all 0.3s ease; border:1px solid #e9ecef;
    position:relative; overflow:hidden;
}
.nav-card::before {
    content:''; position:absolute; top:0; left:-100%; width:100%; height:100%; background: linear-gradient(90deg,transparent,rgba(255,255,255,0.4),transparent); transition:left 0.5s;
}
.nav-card:hover::before { left:100%; }
.nav-card:hover { transform: translateY(-8px) scale(1.02); box-shadow:0 12px 32px rgba(0,123,255,0.2); border-color:#007bff; }
.nav-card i { font-size:3em; color:#28a745; margin-bottom:10px; display:block; transition: color 0.3s ease; }
.nav-card:hover i { color:#007bff; animation:bounce 0.6s ease; }
.nav-btn {
    padding:12px 24px; background-color:#28a745; color:white; text-decoration:none; border-radius:6px;
    display:inline-block; margin-top:10px; transition:all 0.3s ease; border:none; cursor:pointer; width:100%;
}
.nav-btn:hover { background-color:#218838; transform:scale(1.05); box-shadow:0 4px 12px rgba(40,167,69,0.3); }

/* Animations */
@keyframes pulse {0%,100%{transform:scale(1);}50%{transform:scale(1.05);}}
@keyframes bounce {0%,20%,50%,80%,100%{transform:translateY(0);}40%{transform:translateY(-10px);}60%{transform:translateY(-5px);}}

@media (max-width:768px) { .nav-menu{grid-template-columns:1fr;} .container{margin:15px;padding:20px;} }
</style>
</head>
<body>
    <div class="header">
        <h1>HPMS Admin Dashboard</h1>
        <a href="<%=request.getContextPath()%>/LogoutServlet.jsp" class="logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
    </div>

    <div class="container">
        <div class="welcome">
            <i class="fas fa-user-shield"></i>
            <h2>Welcome, <%=fullName%>! (Role: <%=role%>)</h2>
            <p>Manage users, view reports, and oversee all hospital operations.</p>
        </div>

        <div class="nav-menu">
            <div class="nav-card">
                <i class="fas fa-users-cog"></i>
                <h4>Manage Users</h4>
                <p>Add, edit, or remove staff and doctors</p>
                <a href="<%=request.getContextPath()%>/manageUsers.jsp" class="nav-btn">Manage</a>
            </div>

            <div class="nav-card">
                <i class="fas fa-chart-line"></i>
                <h4>Generate Reports</h4>
                <p>View hospital stats, patient trends, and analytics</p>
                <a href="<%=request.getContextPath()%>/patientReport.jsp" class="nav-btn">Generate</a>
            </div>

            <div class="nav-card">
                <i class="fas fa-hospital-user"></i>
                <h4>Search All Patients</h4>
                <p>Access all patient records securely</p>
                <a href="<%=request.getContextPath()%>/searchRecord.jsp" class="nav-btn">View</a>
            </div>

           
        </div>
    </div>
</body>
</html>
