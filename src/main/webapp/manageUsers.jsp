<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.security.MessageDigest" %>

<%!  
    // 🔐 SHA-256 Password Hashing
    public String hashPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hashedBytes = md.digest(password.getBytes("UTF-8"));
            StringBuilder sb = new StringBuilder();
            for (byte b : hashedBytes) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (Exception e) {
            return password;
        }
    }
%>

<%
    // DB Config
    String jdbcURL = "jdbc:mysql://localhost:3306/hpms_db";
    String jdbcUsername = "root";
    String jdbcPassword = "Rajp@123";
    request.setCharacterEncoding("UTF-8");

    // ✅ Delete
    String deleteId = request.getParameter("deleteId");
    if (deleteId != null) {
        try (Connection conn = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
             PreparedStatement stmt = conn.prepareStatement("DELETE FROM users WHERE UserID=?")) {
            Class.forName("com.mysql.cj.jdbc.Driver");
            stmt.setInt(1, Integer.parseInt(deleteId));
            stmt.executeUpdate();
        } catch (Exception e) {
            out.println("<p style='color:red;'>Delete Error: " + e.getMessage() + "</p>");
        }
    }

    // ✅ Update
    String updateId = request.getParameter("updateId");
    if (updateId != null && "POST".equalsIgnoreCase(request.getMethod())) {
        String fullName = request.getParameter("FullName");
        String username = request.getParameter("Username");
        String password = request.getParameter("PasswordHash");
        String role = request.getParameter("Role");

        String hashedPassword = hashPassword(password);

        try (Connection conn = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
             PreparedStatement stmt = conn.prepareStatement(
                "UPDATE users SET FullName=?, Username=?, PasswordHash=?, Role=? WHERE UserID=?")) {
            Class.forName("com.mysql.cj.jdbc.Driver");
            stmt.setString(1, fullName);
            stmt.setString(2, username);
            stmt.setString(3, hashedPassword);
            stmt.setString(4, role);
            stmt.setInt(5, Integer.parseInt(updateId));
            stmt.executeUpdate();
            response.sendRedirect("manageUsers.jsp");
            return;
        } catch (Exception e) {
            out.println("<p style='color:red;'>Update Error: " + e.getMessage() + "</p>");
        }
    }

    // ✅ Add
    if (updateId == null && "POST".equalsIgnoreCase(request.getMethod())) {
        String fullName = request.getParameter("FullName");
        String username = request.getParameter("Username");
        String password = request.getParameter("PasswordHash");
        String role = request.getParameter("Role");

        String hashedPassword = hashPassword(password);

        try (Connection conn = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
             PreparedStatement stmt = conn.prepareStatement(
                "INSERT INTO users (FullName, Username, PasswordHash, Role) VALUES (?, ?, ?, ?)")) {
            Class.forName("com.mysql.cj.jdbc.Driver");
            stmt.setString(1, fullName);
            stmt.setString(2, username);
            stmt.setString(3, hashedPassword);
            stmt.setString(4, role);
            stmt.executeUpdate();
            response.sendRedirect("manageUsers.jsp");
            return;
        } catch (Exception e) {
            out.println("<p style='color:red;'>Insert Error: " + e.getMessage() + "</p>");
        }
    }

    // ✅ Fetch Edit Data
    String editId = request.getParameter("editId");
    String editFullName = "", editUsername = "", editRole = "";
    if (editId != null) {
        try (Connection conn = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
             PreparedStatement stmt = conn.prepareStatement("SELECT * FROM users WHERE UserID=?")) {
            Class.forName("com.mysql.cj.jdbc.Driver");
            stmt.setInt(1, Integer.parseInt(editId));
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                editFullName = rs.getString("FullName");
                editUsername = rs.getString("Username");
                editRole = rs.getString("Role");
            }
            rs.close();
        } catch (Exception e) {
            out.println("<p style='color:red;'>Edit Fetch Error: " + e.getMessage() + "</p>");
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Manage Users - HPMS</title>
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
<style>
body { font-family: Arial, sans-serif; background:#f8f9ff; padding:20px; }
h2 { color:#007bff; margin-bottom:15px; }
form {
    background:white; padding:20px; border-radius:10px;
    box-shadow:0 3px 8px rgba(0,0,0,0.15);
    width:400px; margin-bottom:25px;
}
label { display:block; margin-top:10px; font-weight:bold; color:#333; }
input, select {
    width:100%; padding:10px; margin-top:5px;
    border:1px solid #ccc; border-radius:6px;
}
button {
    margin-top:15px; padding:10px; border:none;
    background:#28a745; color:white;
    border-radius:6px; cursor:pointer; width:100%;
    font-size:16px;
}
button:hover { background:#218838; }
table {
    width:100%; border-collapse:collapse; margin-top:20px;
    background:white; box-shadow:0 2px 6px rgba(0,0,0,0.1);
}
th, td { border:1px solid #ddd; padding:12px; text-align:left; }
th { background:#007bff; color:white; }
tr:nth-child(even) { background:#f9f9f9; }
.edit-btn, .delete-btn {
    padding:6px 12px; border-radius:5px; text-decoration:none;
    color:white; font-size:14px;
}
.edit-btn { background:#007bff; }
.edit-btn:hover { background:#0056b3; }
.delete-btn { background:#dc3545; }
.delete-btn:hover { background:#c82333; }
</style>
</head>
<body>

    <h2><%= (editId != null ? "Edit User" : "Add New User") %></h2>
    <form method="post">
        <% if (editId != null) { %>
            <input type="hidden" name="updateId" value="<%= editId %>">
        <% } %>

        <label>Full Name:</label>
        <input type="text" name="FullName" value="<%= editFullName %>" required>

        <label>Username:</label>
        <input type="text" name="Username" value="<%= editUsername %>" required>

        <label>Password:</label>
        <input type="password" name="PasswordHash" required placeholder="Enter password">

        <label>Role:</label>
        <select name="Role" required>
            <option value="Admin" <%= "Admin".equals(editRole) ? "selected" : "" %>>Admin</option>
            <option value="Doctor" <%= "Doctor".equals(editRole) ? "selected" : "" %>>Doctor</option>
            <option value="Staff" <%= "Staff".equals(editRole) ? "selected" : "" %>>Staff</option>
        </select>

        <button type="submit">
            <i class="fas fa-save"></i> <%= (editId != null ? "Update User" : "Add User") %>
        </button>
    </form>

    <h2>Manage Users</h2>
    <table>
        <tr>
            <th>ID</th>
            <th>Full Name</th>
            <th>Username</th>
            <th>Role</th>
            <th>Actions</th>
        </tr>
        <%
            try (Connection conn = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
                 Statement stmt = conn.createStatement();
                 ResultSet rs = stmt.executeQuery("SELECT UserID, FullName, Username, Role FROM users")) {
                boolean hasUsers = false;
                while (rs.next()) {
                    hasUsers = true;
        %>
        <tr>
            <td><%= rs.getInt("UserID") %></td>
            <td><%= rs.getString("FullName") %></td>
            <td><%= rs.getString("Username") %></td>
            <td><%= rs.getString("Role") %></td>
            <td>
                <a href="manageUsers.jsp?editId=<%= rs.getInt("UserID") %>" class="edit-btn"><i class="fas fa-edit"></i> Edit</a>
                <a href="manageUsers.jsp?deleteId=<%= rs.getInt("UserID") %>" class="delete-btn" onclick="return confirm('Are you sure?');"><i class="fas fa-trash"></i> Delete</a>
            </td>
        </tr>
        <%
                }
                if (!hasUsers) {
        %>
        <tr><td colspan="5" style="text-align:center; color:#555;">No users found</td></tr>
        <%
                }
            } catch (Exception e) {
                out.println("<tr><td colspan='5' style='color:red;'>Error: " + e.getMessage() + "</td></tr>");
            }
        %>
    </table>
</body>
</html>
