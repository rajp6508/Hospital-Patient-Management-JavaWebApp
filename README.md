# 🏥 Hospital Patient Management System (JSP | Servlet | JDBC | MySQL)

A fully functional **Hospital Patient Management System** built using **Java (JSP + Servlet)**, **JDBC**, and **MySQL**.  
It helps hospital staff efficiently manage patient records, admissions, and treatment details through an interactive web interface.

---

## 🚀 Features

### 👨‍⚕️ Admin / Staff Side
- 🔐 Secure login authentication for staff
- 🧾 Add, update, and delete patient records
- 🧍 Admit new patients and assign treatment details
- 🔍 Search, view, and filter patient records dynamically
- 💊 Update patient treatment information
- 📋 Manage hospital users and staff accounts
- 🏥 Dashboard to view all hospital data at a glance

### 👨‍🦱 Patient Side
- 📝 Patient self-registration module
- 📄 View and download treatment history
- 🕒 Real-time updates of admitted or discharged status

---

## 🧱 Tech Stack

| Layer | Technology Used |
|-------|------------------|
| **Frontend** | HTML, CSS, JSP |
| **Backend** | Java Servlet, JSP |
| **Database** | MySQL (via JDBC) |
| **Server** | Apache Tomcat |
| **IDE** | Eclipse IDE for Enterprise Java Developers |

---


## ⚙️ Setup Instructions

### 1️⃣ Clone the Repository

git clone https://github.com/rajp6508/Hospital-Patient-Management-JavaWebApp.git

2️⃣ Import the Project in Eclipse
Open Eclipse IDE

Go to File → Import → Existing Projects into Workspace

Browse to the cloned folder and click Finish

3️⃣ Configure the Database
Open MySQL and create a new database:


CREATE DATABASE hospital_db;
Import the SQL file:


SOURCE path_to_project/database/hospital_db.sql;
Update your JDBC connection file (inside src/main/java/)
with your MySQL username and password.

4️⃣ Run the Project
Right-click on the project → Run on Server

Choose Apache Tomcat Server

Access in browser: 
👉 http://localhost:8080/HospitalPatientManagement/



🧑‍💻 Author ->

👋 Raj Puri

📧 Email: rajp66228@gmail.com

⭐ Contribute / Support 

If you found this project useful, please give it a ⭐ on GitHub to support my work!

🏁 License
This project is open-source and available under the MIT License.

