<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="jakarta.servlet.http.HttpSession"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>HPMS User Dashboard</title>
<!-- Google Fonts -->
<link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
<!-- Font Awesome -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<style>
body {
    font-family: 'Roboto', Arial, sans-serif;
    margin: 0;
    background-color: #f8f9ff;
}

.header {
    background: linear-gradient(135deg, #007bff 0%, #0056b3 100%);
    color: white;
    padding: 20px;
    text-align: center;
    position: relative;
    box-shadow: 0 4px 20px rgba(0, 123, 255, 0.3);
}

.header h1 {
    margin: 0;
}

.logout {
    position: absolute;
    top: 20px;
    right: 20px;
    background: #dc3545;
    color: white;
    padding: 10px 15px;
    text-decoration: none;
    border-radius: 6px;
    font-weight: 500;
    transition: all 0.3s ease;
}

.logout:hover {
    background: #c82333;
    transform: scale(1.05);
    box-shadow: 0 4px 12px rgba(220,53,69,0.3);
}

.container {
    max-width: 1200px;
    margin: 30px auto;
    background: white;
    padding: 30px;
    border-radius: 12px;
    box-shadow: 0 8px 32px rgba(0,0,0,0.1);
}

.welcome {
    text-align: center;
    margin-bottom: 30px;
    padding: 20px;
    background: linear-gradient(135deg, #e3f2fd 0%, #f3e5f5 100%);
    border-radius: 12px;
}

.nav-menu {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
    gap: 20px;
}

.nav-card {
    background: linear-gradient(135deg, #ffffff 0%, #f8f9fa 100%);
    border-radius: 12px;
    padding: 20px;
    text-align: center;
    box-shadow: 0 4px 16px rgba(0,0,0,0.1);
    transition: all 0.3s ease;
    border: 1px solid #e9ecef;
    position: relative;
    overflow: hidden;
}

.nav-card::before {
    content: '';
    position: absolute;
    top: 0; left: -100%;
    width: 100%; height: 100%;
    background: linear-gradient(90deg, transparent, rgba(255,255,255,0.4), transparent);
    transition: left 0.5s;
}

.nav-card:hover::before { left: 100%; }
.nav-card:hover { transform: translateY(-8px) scale(1.02); box-shadow: 0 12px 32px rgba(0,123,255,0.2); border-color:#007bff; }

.nav-card i {
    font-size: 3em;
    color: #28a745;
    margin-bottom: 10px;
    display: block;
    transition: color 0.3s ease;
}

.nav-card:hover i { color: #007bff; }

.nav-btn {
    display: inline-block;
    margin-top: 10px;
    padding: 12px 24px;
    background-color: #28a745;
    color: white;
    text-decoration: none;
    border-radius: 6px;
    font-weight: 500;
    width: 100%;
    transition: all 0.3s ease;
}

.nav-btn:hover { background-color: #218838; transform: scale(1.05); box-shadow: 0 4px 12px rgba(40,167,69,0.3); }

@media (max-width: 768px) {
    .nav-menu { grid-template-columns: 1fr; }
    .container { margin: 15px; padding: 20px; }
}
</style>
</head>
<body>
<%
    if (session == null || session.getAttribute("role") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    String fullName = (String) session.getAttribute("fullName");
    String role = (String) session.getAttribute("role");
%>

<div class="header">
    <h1>Hospital Patient Management System (HPMS)</h1>
    <a href="<%=request.getContextPath()%>/LogoutServlet.jsp" class="logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
</div>

<div class="container">
    <div class="welcome">
        <h2>Welcome, <%=fullName%>! (Role: <%=role%>)</h2>
        <p>Use the buttons below to manage patients.</p>
    </div>

    <div class="nav-menu">
        <div class="nav-card">
            <i class="fas fa-user-plus"></i>
            <h4>Register New Patient</h4>
            <p>Create a new patient record quickly</p>
            <a href="<%=request.getContextPath()%>/registerNewPatient.jsp" class="nav-btn"><i class="fas fa-arrow-right"></i> Register</a>
        </div>

        <div class="nav-card">
            <i class="fas fa-hospital-user"></i>
            <h4>Admit Patient</h4>
            <p>Handle patient admissions efficiently</p>
            <a href="<%=request.getContextPath()%>/admit.jsp" class="nav-btn"><i class="fas fa-arrow-right"></i> Admit</a>
        </div>

       
    </div>
</div>
</body>
</html>
