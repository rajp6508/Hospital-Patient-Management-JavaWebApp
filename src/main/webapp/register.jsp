<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>HPMS - New User Registration</title>
    <!-- Google Fonts for modern typography (matching login) -->
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
    <!-- Font Awesome for icons (matching login) -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: 'Roboto', Arial, sans-serif;
            height: 100vh;
            background: linear-gradient(135deg, #e3f2fd 0%, #bbdefb 100%); /* Calming blue gradient matching login */
            display: flex;
            justify-content: center;
            align-items: center;
            overflow: hidden; /* Prevent scroll on animations */
        }
        
        .register-header {
            background: linear-gradient(135deg, #007bff 0%, #0056b3 100%), /* Gradient overlay matching login header */
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
        
        .register-header::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(0, 0, 0, 0.4); /* Dark overlay for readability */
            z-index: 1;
        }
        
        .register-header > * {
            position: relative;
            z-index: 2;
        }
        
        .form-container {
            background: #fff;
            padding: 30px 40px;
            border-radius: 12px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1); /* Matching login container shadow */
            width: 400px;
            animation: fadeInUp 1s ease-out 0.5s both; /* Delayed fade-in like login */
            position: relative;
            z-index: 3;
        }
        
        .register-title {
            text-align: center;
            color: #333;
            margin-bottom: 25px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }
        
        .register-title i {
            font-size: 2.5em;
            color: #007bff; /* Blue accent matching login */
            animation: pulse 2s infinite; /* Subtle pulse like login title icon */
        }
        
        .register-title h2 {
            margin: 0;
            color: #00796b; /* Teal for title */
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
        
        input, select {
            width: 100%;
            padding: 12px 12px 12px 40px; /* Space for icon */
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 14px;
            transition: all 0.3s ease; /* Smooth focus like login inputs */
            box-sizing: border-box;
        }
        
        input:focus, select:focus {
            border-color: #007bff;
            outline: none;
            box-shadow: 0 0 8px rgba(0, 123, 255, 0.2); /* Glow matching login focus */
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
            background-color: #28a745; /* Green matching login button */
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease; /* Hover like login button */
            margin-top: 10px;
        }
        
        button:hover {
            background-color: #218838;
            transform: translateY(-2px) scale(1.02); /* Lift and scale like login */
            box-shadow: 0 4px 12px rgba(40, 167, 69, 0.3);
        }
        
        .error {
            color: #dc3545; /* Red matching login error */
            font-weight: bold;
            margin-bottom: 15px;
            text-align: center;
            padding: 10px;
            background: #f8d7da;
            border-radius: 6px;
            border: 1px solid #f5c6cb;
            animation: shake 0.5s ease-in-out; /* Shake like login error */
        }
        
        .success {
            color: #155724; /* Green for success */
            font-weight: bold;
            margin-bottom: 15px;
            text-align: center;
            padding: 10px;
            background: #d4edda;
            border-radius: 6px;
            border: 1px solid #c3e6cb;
            animation: fadeIn 0.5s ease-out; /* Gentle fade for success */
        }
        
        /* Animations (matching login) */
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
        
        @keyframes pulse {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.05); }
        }
        
        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            10%, 30%, 50%, 70%, 90% { transform: translateX(-5px); }
            20%, 40%, 60%, 80% { transform: translateX(5px); }
        }
        
        /* Responsive Design (matching login) */
        @media (max-width: 768px) {
            .form-container { width: 90%; margin: 10px; padding: 20px; }
            .register-header { min-height: 100px; padding: 15px; }
            input, select { padding: 10px 10px 10px 35px; font-size: 16px; }
        }
    </style>
</head>
<body>
    <!-- Header Section (matching login header style) -->
    <div class="register-header">
        <h1 style="margin: 0; font-size: 1.8em;"><i class="fas fa-hospital"></i> HPMS Portal</h1>
    </div>

    <div class="form-container">
        <div class="register-title">
            <i class="fas fa-user-plus"></i>
            <h2>New User Registration</h2>
        </div>
        
        <p class="welcome-text">Create your account for secure access to HPMS features.</p>

        <form action="<%= request.getContextPath() %>/registerUser " method="post">
            <div class="input-group">
                <label for="username">Username:</label>
                <i class="fas fa-user"></i>
                <input type="text" id="username" name="username" required placeholder="Enter username" />
            </div>

            <div class="input-group">
                <label for="password">Password:</label>
                <i class="fas fa-lock"></i>
                <input type="password" id="password" name="password" required placeholder="Enter password" />
            </div>

            <div class="input-group">
                <label for="role">Role:</label>
                <i class="fas fa-user-tag"></i>
                <select id="role" name="role" required>
                    <option value="">Select</option>
                    <option value="User ">User </option>
                    <option value="Admin">Admin</option>
                    <option value="Doctor">Doctor</option>
                </select>
            </div>

            <div class="input-group">
                <label for="fullName">Full Name:</label>
                <i class="fas fa-user-friends"></i>
                <input type="text" id="fullName" name="fullName" required placeholder="Enter full name" />
            </div>

            <button type="submit"><i class="fas fa-user-plus"></i> Register</button>
        </form>

        <% if (request.getAttribute("error") != null) { %>
            <div class="error"><%= request.getAttribute("error") %></div>
        <% } %>

        <% if (request.getAttribute("success") != null) { %>
            <div class="success"><%= request.getAttribute("success") %></div>
        <% } %>
        <a href="login.jsp"> go to login</a>
    </div>
</body>
</html>