<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Patient Self-Registration - HPMS</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body { margin:0; padding:0; font-family:'Roboto',Arial,sans-serif; min-height:100vh; display:flex; flex-direction:column; justify-content:center; align-items:center; padding:20px; background:linear-gradient(135deg,#e3f2fd 0%,#bbdefb 100%); box-sizing:border-box; }
        .register-header { background: linear-gradient(135deg,#007bff 0%,#0056b3 100%), url('https://images.unsplash.com/photo-1576091160399-112ba8d25d1f?ixlib=rb-4.0.3&auto=format&fit=crop&w=1920&q=80') center/cover; color:white; padding:15px 20px; text-align:center; position:relative; min-height:100px; display:flex; align-items:center; justify-content:center; box-shadow:0 4px 20px rgba(0,123,255,0.3); animation:fadeInDown 1s ease-out; width:100%; max-width:500px; border-radius:12px 12px 0 0; margin-bottom:0; }
        .register-header::before { content:''; position:absolute; top:0; left:0; right:0; bottom:0; background:rgba(0,0,0,0.4); z-index:1; border-radius:12px 12px 0 0; }
        .register-header > * { position:relative; z-index:2; }
        .container { background:#fff; padding:30px 40px; border-radius:0 0 12px 12px; box-shadow:0 8px 32px rgba(0,0,0,0.1); max-width:500px; width:100%; animation:fadeInUp 1s ease-out 0.5s both; position:relative; z-index:3; box-sizing:border-box; max-height:90vh; overflow-y:auto; }
        .register-title { text-align:center; color:#333; margin-bottom:15px; display:flex; align-items:center; justify-content:center; gap:10px; }
        .register-title i { font-size:2em; color:#007bff; animation:pulse 2s infinite; }
        .register-title h2 { margin:0; color:#00796b; font-weight:500; font-size:1.5em; }
        .welcome-text { text-align:center; color:#666; margin-bottom:20px; font-size:14px; background:#d1ecf1; padding:15px; border-radius:6px; line-height:1.4; }
        .welcome-text strong { color:#007bff; }
        form { display:grid; gap:18px; }
        .input-group { position:relative; display:flex; flex-direction:column; }
        .input-group i { position:absolute; left:12px; top:50%; transform:translateY(-50%); color:#007bff; z-index:2; font-size:16px; pointer-events:none; }
        label { display:block; font-weight:500; margin-bottom:8px; color:#333; transition:color 0.3s ease; }
        .input-group:focus-within label { color:#007bff; }
        input[type="text"], input[type="email"], input[type="number"], input[type="tel"], select, textarea { width:100%; padding:12px 12px 12px 40px; border:1px solid #ddd; border-radius:6px; font-size:14px; transition:all 0.3s ease; box-sizing:border-box; margin-top:0; }
        select { padding-left:40px; background:white; cursor:pointer; appearance:none; background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 20 20'%3e%3cpath stroke='%236b7280' stroke-linecap='round' stroke-linejoin='round' stroke-width='1.5' d='m6 8 4 4 4-4'/%3e%3c/svg%3e"); background-position:right 12px center; background-repeat:no-repeat; background-size:16px; }
        textarea { resize:vertical; height:80px; }
        .textarea-group label { display:flex; align-items:center; gap:8px; margin-bottom:5px; }
        .textarea-group i { position:static; font-size:16px; color:#007bff; transform:none; flex-shrink:0; }
        button { padding:12px; background-color:#28a745; color:white; border:none; border-radius:8px; cursor:pointer; font-size:16px; font-weight:500; transition:all 0.3s ease; margin-top:0; }
        button:hover { background-color:#218838; transform:translateY(-2px) scale(1.02); box-shadow:0 4px 12px rgba(40,167,69,0.3); }
        button:disabled { background-color:#6c757d; cursor:not-allowed; transform:none; box-shadow:none; }
        .error { color:#dc3545; margin:10px 0; text-align:center; background:#f8d7da; padding:10px; border-radius:6px; border:1px solid #f5c6cb; animation:shake 0.5s ease-in-out; }
        .success { color:#155724; margin:10px 0; text-align:center; background:#d4edda; padding:10px; border-radius:6px; border:1px solid #c3e6cb; animation:fadeIn 0.5s ease-out; }
        .back-link { text-align:center; margin-top:20px; font-size:14px; color:#666; padding-top:15px; border-top:1px solid #eee; }
        .back-link a { color:#007bff; text-decoration:none; display:inline-flex; align-items:center; gap:5px; transition:color 0.3s ease; margin:0 15px; }
        .back-link a:hover { color:#0056b3; text-decoration:underline; }
        @keyframes fadeInDown { from{opacity:0; transform:translateY(-30px);} to{opacity:1; transform:translateY(0);} }
        @keyframes fadeInUp { from{opacity:0; transform:translateY(30px);} to{opacity:1; transform:translateY(0);} }
        @keyframes fadeIn { from{opacity:0;} to{opacity:1;} }
        @keyframes pulse { 0%,100%{transform:scale(1);} 50%{transform:scale(1.05);} }
        @keyframes shake { 0%,100%{transform:translateX(0);} 10%,30%,50%,70%,90%{transform:translateX(-5px);} 20%,40%,60%,80%{transform:translateX(5px);} }
        @media (max-width:768px) { body{padding:10px; justify-content:flex-start;} .container{width:95%; padding:20px 25px; max-height:100vh;} .register-header{min-height:80px; padding:10px 15px; max-width:95%; border-radius:8px 8px 0 0;} .register-title h2{font-size:1.3em;} .register-title i{font-size:1.8em;} input, select{padding:14px 14px 14px 45px; font-size:16px;} .input-group i{left:14px;} form{gap:16px;} .back-link a{display:block; margin:10px 0;} .welcome-text{font-size:13px; padding:12px; margin-bottom:15px;} }
        @media (max-width:480px) { .container{padding:15px 20px;} .welcome-text{padding:10px;} }
    </style>
</head>
<body>
    <div class="register-header">
        <h1 style="margin:0; font-size:1.6em;"><i class="fas fa-hospital"></i> HPMS Portal</h1>
    </div>
    <div class="container">
        <div class="register-title">
            <i class="fas fa-user-plus"></i>
            <h2>Patient Self-Registration Portal</h2>
        </div>
        <div class="welcome-text">
            <p>Welcome to HPMS! Register online to save time at the hospital. After submission, you'll receive a temporary Patient ID. Bring it to reception for verification and activation.</p>
            <p><strong>Note:</strong> This creates a pending digital record. Medical staff will review and activate it.</p>
        </div>

        <% if (request.getAttribute("error") != null) { %>
            <div class="error"><%= request.getAttribute("error") %></div>
        <% } %>
        <% if (request.getAttribute("success") != null) { %>
            <div class="success">
                <%= request.getAttribute("success") %><br>
                <strong>Next Steps:</strong> Save your Patient ID and visit the hospital with ID proof. Call us at 123-456-7890 for questions.
            </div>
            <script>document.querySelector('form')?.style.display = 'none';</script>
        <% } else { %>
            <form action="PatientSelfRegister" method="post" id="regForm" onsubmit="return validateForm()">
                <div class="input-group">
                    <label for="name">Full Name *:</label>
                    <i class="fas fa-user"></i>
                    <input type="text" id="name" name="name" required placeholder="e.g., John Doe">
                </div>
                <div class="input-group">
                    <label for="age">Age *:</label>
                    <i class="fas fa-calendar-alt"></i>
                    <input type="number" id="age" name="age" min="1" max="120" required placeholder="e.g., 30">
                </div>
                <div class="input-group">
                    <label for="gender">Gender:</label>
                    <i class="fas fa-venus-mars"></i>
                    <select id="gender" name="gender">
                        <option value="">Select Gender</option>
                        <option value="M">Male</option>
                        <option value="F">Female</option>
                        <option value="Other">Other</option>
                    </select>
                </div>
                <div class="input-group">
                    <label for="phone">Phone Number *:</label>
                    <i class="fas fa-phone"></i>
                    <input type="tel" id="phone" name="phone" required placeholder="e.g., +1-123-456-7890">
                </div>
                <div class="input-group">
                    <label for="email">Email *:</label>
                    <i class="fas fa-envelope"></i>
                    <input type="email" id="email" name="email" required placeholder="e.g., john@example.com">
                </div>
                <div class="input-group">
                    <label for="address">Address:</label>
                    <i class="fas fa-map-marker-alt"></i>
                    <input type="text" id="address" name="address" placeholder="e.g., 123 Main St, City, State">
                </div>
                <div class="input-group">
                    <label for="emergencyContact">Emergency Contact (Optional):</label>
                    <i class="fas fa-exclamation-triangle"></i>
                    <input type="tel" id="emergencyContact" name="emergencyContact" placeholder="e.g., +1-987-654-3210">
                </div>
                <div class="input-group textarea-group">
                    <label for="medicalHistory"><i class="fas fa-notes-medical"></i> Medical History (Optional):</label>
                    <textarea id="medicalHistory" name="medicalHistory" placeholder="Past illnesses, allergies, medications, etc."></textarea>
                </div>
                <button type="submit">Register</button>
            </form>
        <% } %>

        <div class="back-link">
            <a href="dashboard.jsp"><i class="fas fa-arrow-left"></i> Back to Home</a>
        </div>
    </div>

    <script>
        function validateForm() {
            const phone = document.getElementById('phone').value;
            const email = document.getElementById('email').value;
            const phonePattern = /^\+?\d{7,15}$/;
            if (!phonePattern.test(phone)) {
                alert('Enter a valid phone number.');
                return false;
            }
            if (!email.includes('@')) {
                alert('Enter a valid email.');
                return false;
            }
            return true;
        }
    </script>
</body>
</html>
