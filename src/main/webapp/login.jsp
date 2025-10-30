<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Hospital Patient Management System - Login</title>
    <!-- Google Fonts for modern typography (matching dashboard) -->
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
    <!-- Font Awesome for icons (matching dashboard) -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: 'Roboto', Arial, sans-serif;
            height: 100vh;
            background: linear-gradient(135deg, #e3f2fd 0%, #bbdefb 100%); /* Calming blue gradient matching dashboard */
            display: flex;
            justify-content: center;
            align-items: center;
            overflow: hidden; /* Prevent scroll on animations */
        }
        
        .login-header {
            background: linear-gradient(135deg, #007bff 0%, #0056b3 100%), /* Gradient overlay matching dashboard header */
                        url('https://images.unsplash.com/photo-1576091160399-112ba8d25d1f?ixlib=rb-4.0.3&auto=format&fit=crop&w=1920&q=80') center/cover; /* Subtle hospital background */
            color: white;
            padding: 20px;
            text-align: center;
            position: relative;
            min-height: 120px;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 4px 20px rgba(0, 123, 255, 0.3);
            animation: fadeInDown 1s ease-out;
            width: 100%;
            top: 0;
            margin-bottom: 20px;
        }
        
        .login-header::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(0, 0, 0, 0.4); /* Dark overlay for readability */
            z-index: 1;
        }
        
        .login-header > * {
            position: relative;
            z-index: 2;
        }
        
        .login-container {
            background: #fff;
            padding: 30px 40px;
            border-radius: 12px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1); /* Matching dashboard container shadow */
            width: 350px;
            animation: fadeInUp 1s ease-out 0.5s both; /* Delayed fade-in like dashboard */
            position: relative;
            z-index: 3;
        }
        
        .login-title {
            text-align: center;
            color: #333;
            margin-bottom: 25px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }
        
        .login-title i {
            font-size: 2.5em;
            color: #007bff; /* Blue accent matching dashboard */
            animation: pulse 2s infinite; /* Subtle pulse like dashboard welcome icon */
        }
        
        .login-title h2 {
            margin: 0;
            color: #00796b; /* Teal for title, but blue accents elsewhere */
            font-weight: 500;
        }
        
        .welcome-text {
            text-align: center;
            color: #666;
            margin-bottom: 20px;
            font-size: 14px;
        }
        
        .input-group {
            position: relative;
            margin-bottom: 15px;
        }
        
        .input-group i {
            position: absolute;
            left: 12px;
            top: 50%;
            transform: translateY(-50%);
            color: #007bff;
            z-index: 1;
            font-size: 16px;
        }
        
        label {
            display: block;
            font-weight: 500;
            margin-bottom: 5px;
            color: #333;
        }
        
        input[type="text"], input[type="password"], select {
            width: 100%;
            padding: 12px 12px 12px 40px; /* Space for icon */
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 14px;
            transition: all 0.3s ease; /* Smooth focus like dashboard inputs */
            box-sizing: border-box;
        }
        
        input[type="text"]:focus, input[type="password"]:focus, select:focus {
            border-color: #007bff;
            outline: none;
            box-shadow: 0 0 8px rgba(0, 123, 255, 0.2); /* Glow matching dashboard focus */
            transform: translateY(-1px);
        }
        
        select {
            padding-left: 40px; /* Icon space for select */
            background: white;
            cursor: pointer;
        }
        
        button {
            width: 100%;
            padding: 12px;
            background-color: #28a745; /* Green matching dashboard nav-btn */
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease; /* Hover like dashboard buttons */
            margin-top: 10px;
        }
        
        button:hover {
            background-color: #218838;
            transform: translateY(-2px) scale(1.02); /* Lift and scale like dashboard */
            box-shadow: 0 4px 12px rgba(40, 167, 69, 0.3);
        }
        
        .error {
            color: #dc3545; /* Red matching dashboard error */
            font-weight: bold;
            margin-bottom: 15px;
            text-align: center;
            padding: 10px;
            background: #f8d7da;
            border-radius: 6px;
            border: 1px solid #f5c6cb;
            animation: shake 0.5s ease-in-out; /* Shake like dashboard error */
        }
        
        .register-link {
            text-align: center;
            margin-top: 20px;
            font-size: 14px;
            color: #666;
        }
        
        .register-link a {
            color: #007bff; /* Blue link matching dashboard */
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 5px;
            transition: color 0.3s ease;
        }
        
        .register-link a:hover {
            color: #0056b3;
            text-decoration: underline;
        }
        
        /* Animations (matching dashboard) */
        @keyframes fadeInDown {
            from { opacity: 0; transform: translateY(-30px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(30px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        @keyframes pulse {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.05); }
        }
        
        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            10%, 30%, 50%, 70%, 90% { transform: translateX(-5px); }
            20%, 40%, 60%, 80% { transform: translateX(5px); }
        }
        
        /* Responsive Design (matching dashboard) */
        @media (max-width: 768px) {
            .login-container { width: 90%; margin: 10px; padding: 20px; }
            .login-header { min-height: 100px; padding: 15px; }
            input[type="text"], input[type="password"], select { padding: 10px 10px 10px 35px; font-size: 16px; }
        }
    </style>
</head>
<body>
    <!-- Header Section (matching dashboard header style) -->
    <div class="login-header">
        <h1 style="margin: 0; font-size: 1.8em;"><i class="fas fa-hospital"></i> HPMS Portal</h1>
    </div>

    <div class="login-container">
        <div class="login-title">
            <i class="fas fa-sign-in-alt"></i>
            <h2>Login to HPMS</h2>
        </div>
        
        <p class="welcome-text">Secure access to patient management and digital records.</p>

        <% if (request.getAttribute("error") != null) { %>
            <div class="error"><%= request.getAttribute("error") %></div>
        <% } %>

        <form action="LoginServlet" method="post">
            <div class="input-group">
                <label>Username:</label>
                <i class="fas fa-user"></i>
                <input type="text" name="username" required placeholder="Enter username" />
            </div>

            <div class="input-group">
                <label>Password:</label>
                <i class="fas fa-lock"></i>
                <input type="password" name="password" required placeholder="Enter password" />
            </div>

            <div class="input-group">
                <label>Role:</label>
                <i class="fas fa-user-tag"></i>
                <select name="role" required>
                    <option value="">-- Select Role --</option>
                    <option value="Doctor">Doctor</option>
                    <option value="Admin">Admin</option>
                    <option value="User">User </option>
                </select>
            </div>

            <button type="submit"><i class="fas fa-arrow-right"></i> Login</button>
        </form>

        <div class="register-link">
            <p>Not registered? <a href="register.jsp"><i class="fas fa-user-plus"></i> Register Now</a></p>
        </div>
    </div>
</body>
</html>