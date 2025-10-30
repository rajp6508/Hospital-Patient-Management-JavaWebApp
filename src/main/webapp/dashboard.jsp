<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="jakarta.servlet.http.HttpSession"%>
<%@ page import="java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>HPMS Dashboard</title>
<!-- Google Fonts for modern typography -->
<link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
<!-- Font Awesome for icons -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<style>
body {
	font-family: 'Roboto', Arial, sans-serif;
	margin: 0;
	background-color: #f8f9ff; /* Light blue tint for calming effect */
	overflow-x: hidden; /* Prevent horizontal scroll on animations */
}

.header {
	background: linear-gradient(135deg, #007bff 0%, #0056b3 100%), /* Gradient overlay */
	            url('https://images.unsplash.com/photo-1576091160399-112ba8d25d1f?ixlib=rb-4.0.3&auto=format&fit=crop&w=1920&q=80') center/cover; /* Subtle hospital-themed background image */
	color: white;
	padding: 20px;
	text-align: center;
	position: relative;
	min-height: 150px;
	display: flex;
	align-items: center;
	justify-content: center;
	box-shadow: 0 4px 20px rgba(0, 123, 255, 0.3);
	animation: fadeInDown 1s ease-out;
}

.header::before {
	content: '';
	position: absolute;
	top: 0;
	left: 0;
	right: 0;
	bottom: 0;
	background: rgba(0, 0, 0, 0.4); /* Dark overlay for readability */
	z-index: 1;
}

.header > * {
	position: relative;
	z-index: 2;
}

.container {
	max-width: 1200px;
	margin: 30px auto;
	background: white;
	padding: 30px;
	border-radius: 12px;
	box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
	animation: fadeInUp 1s ease-out 0.5s both; /* Delayed fade-in */
}

.welcome {
	margin-bottom: 30px;
	color: #333;
	text-align: center;
	padding: 20px;
	background: linear-gradient(135deg, #e3f2fd 0%, #f3e5f5 100%);
	border-radius: 12px;
	animation: fadeIn 1s ease-out;
}

.welcome i {
	font-size: 3em;
	color: #007bff;
	margin-bottom: 10px;
	display: block;
	animation: pulse 2s infinite; /* Subtle breathing animation for icon */
}

.nav-menu {
	display: grid;
	grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); /* Responsive grid for cards */
	gap: 20px;
	margin-bottom: 30px;
}

.nav-card {
	background: linear-gradient(135deg, #ffffff 0%, #f8f9fa 100%);
	border-radius: 12px;
	padding: 20px;
	text-align: center;
	box-shadow: 0 4px 16px rgba(0, 0, 0, 0.1);
	transition: all 0.3s ease; /* Smooth hover transition */
	border: 1px solid #e9ecef;
	position: relative;
	overflow: hidden;
}

.nav-card::before {
	content: '';
	position: absolute;
	top: 0;
	left: -100%;
	width: 100%;
	height: 100%;
	background: linear-gradient(90deg, transparent, rgba(255,255,255,0.4), transparent);
	transition: left 0.5s;
}

.nav-card:hover::before {
	left: 100%; /* Shine effect on hover */
}

.nav-card:hover {
	transform: translateY(-8px) scale(1.02); /* Lift and slight scale on hover */
	box-shadow: 0 12px 32px rgba(0, 123, 255, 0.2);
	border-color: #007bff;
	animation: glow 0.5s ease-in-out;
}

.nav-card i {
	font-size: 3em;
	color: #28a745;
	margin-bottom: 10px;
	display: block;
	transition: color 0.3s ease;
}

.nav-card:hover i {
	color: #007bff; /* Icon color change on hover */
	animation: bounce 0.6s ease;
}

.nav-btn {
	padding: 12px 24px;
	background-color: #28a745;
	color: white;
	text-decoration: none;
	border-radius: 6px;
	font-weight: 500;
	display: inline-block;
	margin-top: 10px;
	transition: all 0.3s ease;
	border: none;
	cursor: pointer;
	width: 100%;
}

.nav-btn:hover {
	background-color: #218838;
	transform: scale(1.05);
	box-shadow: 0 4px 12px rgba(40, 167, 69, 0.3);
}

.doctor-only, .admin-only {
	display: none;
	animation: fadeIn 0.8s ease-out; /* Animate in when shown */
}

.search-section {
	margin-bottom: 20px;
	text-align: center;
	padding: 20px;
	background: #f8f9fa;
	border-radius: 8px;
	animation: slideInRight 1s ease-out;
}

input[type="number"] {
	padding: 10px 15px;
	border: 1px solid #ddd;
	border-radius: 6px;
	font-size: 16px;
	width: 200px;
	margin-right: 10px;
	transition: border-color 0.3s ease;
}

input[type="number"]:focus {
	border-color: #007bff;
	outline: none;
	box-shadow: 0 0 8px rgba(0, 123, 255, 0.2);
}

button {
	padding: 10px 20px;
	background-color: #007bff;
	color: white;
	border: none;
	border-radius: 6px;
	cursor: pointer;
	font-size: 16px;
	transition: all 0.3s ease;
	margin-left: 10px;
}

button:hover {
	background-color: #0056b3;
	transform: translateY(-2px);
	box-shadow: 0 4px 12px rgba(0, 123, 255, 0.3);
}

table {
	width: 100%;
	border-collapse: collapse;
	margin-top: 20px;
	border-radius: 8px;
	overflow: hidden;
	box-shadow: 0 4px 16px rgba(0, 0, 0, 0.1);
	animation: fadeIn 1s ease-out;
}

th, td {
	padding: 12px;
	text-align: left;
	border-bottom: 1px solid #e9ecef;
}

th {
	background-color: #007bff;
	color: white;
	font-weight: 500;
}

.error {
	color: #dc3545;
	text-align: center;
	margin: 10px 0;
	padding: 12px;
	background: #f8d7da;
	border-radius: 6px;
	border: 1px solid #f5c6cb;
	animation: shake 0.5s ease-in-out;
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
	z-index: 3;
}

.logout:hover {
	background: #c82333;
	transform: scale(1.05);
	box-shadow: 0 4px 12px rgba(220, 53, 69, 0.3);
}

/* Animations */
@keyframes fadeInDown {
	from { opacity: 0; transform: translateY(-30px); }
	to { opacity: 1; transform: translateY(0); }
}

@keyframes fadeInUp {
	from { opacity: 0; transform: translateY(30px); }
	to { opacity: 1; transform: translateY(0); }
}

@keyframes fadeIn {
	from { opacity: 0; }
	to { opacity: 1; }
}

@keyframes slideInRight {
	from { opacity: 0; transform: translateX(50px); }
	to { opacity: 1; transform: translateX(0); }
}

@keyframes pulse {
	0%, 100% { transform: scale(1); }
	50% { transform: scale(1.05); }
}

@keyframes glow {
	0%, 100% { box-shadow: 0 4px 16px rgba(0, 0, 0, 0.1); }
	50% { box-shadow: 0 12px 32px rgba(0, 123, 255, 0.4); }
}

@keyframes bounce {
	0%, 20%, 50%, 80%, 100% { transform: translateY(0); }
	40% { transform: translateY(-10px); }
	60% { transform: translateY(-5px); }
}

@keyframes shake {
	0%, 100% { transform: translateX(0); }
	10%, 30%, 50%, 70%, 90% { transform: translateX(-5px); }
	20%, 40%, 60%, 80% { transform: translateX(5px); }
}

/* Responsive Design */
@media (max-width: 768px) {
	.nav-menu { grid-template-columns: 1fr; }
	.header { min-height: 120px; padding: 15px; }
	.container { margin: 15px; padding: 20px; }
	input[type="number"] { width: 100%; margin-bottom: 10px; }
	button { width: 100%; margin: 5px 0; }
}
</style>
</head>
<body>
	<%
	if (session == null || session.getAttribute("role") == null) {
		response.sendRedirect(request.getContextPath() + "/login.jsp");
		return;
	}
	String role = (String) session.getAttribute("role");
	String fullName = (String) session.getAttribute("fullName");
	Integer userID = (Integer) session.getAttribute("userID");
	%>


	<div class="header">
		<h1>Hospital Patient Management System (HPMS)</h1>
		<a href="<%=request.getContextPath()%>/LogoutServlet.jsp" class="logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
	</div>

	<div class="container">
		<div class="welcome">
			<i class="fas fa-user-md"></i> <!-- Icon for welcome (doctor/patient) -->
			<h2>
				Welcome,
				<%=fullName%>! (Role:
				<%=role%>)
			</h2>
			<p>This dashboard automates patient care: Register, Admit, View
				Records, and Maintain Secure Digital History.</p>
		</div>

		<!-- Navigation Menu (Now as Animated Cards with Icons) -->
		<div class="nav-menu">
			<div class="nav-card">
				<i class="fas fa-user-plus"></i> <!-- Icon for patient registration -->
				<h4>Register New Patient</h4>
				<p>Automate digital registration to reduce paperwork</p>
				<a href="<%=request.getContextPath()%>/registerNewPatient.jsp"
					class="nav-btn"><i class="fas fa-arrow-right"></i> Start</a>
			</div>
			
			<div class="nav-card">
				<i class="fas fa-hospital-user"></i> <!-- Icon for admission -->
				<h4>Admit Patient</h4>
				<p>Handle admissions efficiently with linked records</p>
				<a href="<%=request.getContextPath()%>/admit.jsp" class="nav-btn"><i class="fas fa-arrow-right"></i> Admit</a>
			</div>

			<%
			if ("Doctor".equalsIgnoreCase(role)) {
			%>
			<div class="nav-card doctor-only">
				<i class="fas fa-stethoscope"></i> <!-- Icon for viewing records -->
				<h4>View Patient Records</h4>
				<p>Access history, diagnosis, and treatment securely</p>
				<a href="searchRecord.jsp" class="nav-btn"><i class="fas fa-arrow-right"></i> View</a>
			</div> 
			<div class="nav-card doctor-only">
				<i class="fas fa-edit"></i> <!-- Icon for updating treatment -->
				<h4>Update Treatment</h4>
				<p>Edit diagnosis and notes for accurate care</p>
				<a href="<%=request.getContextPath()%>/updateRecord.jsp"
					class="nav-btn"><i class="fas fa-arrow-right"></i> Update</a>
			</div>
			<%
			}
			%>

			<%
			if ("Admin".equalsIgnoreCase(role)) {
			%>
			<div class="nav-card admin-only">
				<i class="fas fa-chart-bar"></i> <!-- Icon for reports -->
				<h4>Generate Reports</h4>
				<p>View hospital stats and analytics</p>
				<a href="#" class="nav-btn"><i class="fas fa-arrow-right"></i> Generate</a>
			</div>
			<div class="nav-card admin-only">
				<i class="fas fa-users-cog"></i> <!-- Icon for user management -->
				<h4>Manage Users</h4>
				<p>Control staff access and roles</p>
				<a href="#" class="nav-btn"><i class="fas fa-arrow-right"></i> Manage</a>
			</div>
			<%
			}
			%>
		</div>

		<!-- JavaScript to show role-specific buttons -->
		<script>
        const isDoctor = "<%=role%>" === "Doctor";
        const isAdmin = "<%=role%>" === "Admin";
        if (isDoctor) document.querySelectorAll('.doctor-only').forEach(el => el.style.display = 'block');
        if (isAdmin) document.querySelectorAll('.admin-only').forEach(el => el.style.display = 'block');
        function viewRecords() {
            const patientID = prompt("Enter Patient ID to view records:");
            if (patientID) window.location.href = "<%=request.getContextPath()%>/viewRecords?patientID=" + patientID;
        }
    </script>
	</div>
</body>
</html>