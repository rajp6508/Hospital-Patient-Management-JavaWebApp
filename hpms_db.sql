-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Oct 30, 2025 at 08:14 AM
-- Server version: 9.3.0
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `hpms_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `admissions`
--

CREATE TABLE `admissions` (
  `AdmissionID` int NOT NULL,
  `PatientID` int NOT NULL,
  `AdmissionDate` date NOT NULL,
  `DischargeDate` date DEFAULT NULL,
  `Reason` text NOT NULL,
  `AssignedDoctorID` int DEFAULT NULL,
  `Ward` varchar(50) DEFAULT NULL,
  `BedNumber` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `admissions`
--

INSERT INTO `admissions` (`AdmissionID`, `PatientID`, `AdmissionDate`, `DischargeDate`, `Reason`, `AssignedDoctorID`, `Ward`, `BedNumber`) VALUES
(1, 1, '2025-09-27', NULL, 'Routine checkup', 2, 'General', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `medicalrecords`
--

CREATE TABLE `medicalrecords` (
  `RecordID` int NOT NULL,
  `PatientID` int NOT NULL,
  `VisitDate` date NOT NULL,
  `Diagnosis` text,
  `Treatment` text,
  `DoctorNotes` text,
  `UpdatedBy` int NOT NULL,
  `UpdatedDate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `medicalrecords`
--

INSERT INTO `medicalrecords` (`RecordID`, `PatientID`, `VisitDate`, `Diagnosis`, `Treatment`, `DoctorNotes`, `UpdatedBy`, `UpdatedDate`) VALUES
(1, 1, '2025-09-27', 'Mild Hypertension', 'Daily medication and diet', 'Monitor BP weekly', 2, '2025-09-27 04:58:38'),
(2, 1, '2025-09-28', 'brain enjury', 'fdx', 'ef\r\n', 4, '2025-09-28 05:55:56');

-- --------------------------------------------------------

--
-- Table structure for table `patients`
--

CREATE TABLE `patients` (
  `PatientID` int NOT NULL,
  `Name` varchar(100) NOT NULL,
  `Age` int DEFAULT NULL,
  `Gender` varchar(10) DEFAULT NULL,
  `Phone` varchar(15) NOT NULL,
  `Email` varchar(100) DEFAULT NULL,
  `Address` text,
  `MedicalHistory` text,
  `EmergencyContact` varchar(100) DEFAULT NULL,
  `Status` varchar(20) DEFAULT 'Pending',
  `CreatedDate` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ;

--
-- Dumping data for table `patients`
--

INSERT INTO `patients` (`PatientID`, `Name`, `Age`, `Gender`, `Phone`, `Email`, `Address`, `MedicalHistory`, `EmergencyContact`, `Status`, `CreatedDate`) VALUES
(1, 'John Doe', 30, 'M', '123-456-7890', 'john@example.com', '123 Main St', 'Allergic to penicillin; History of hypertension', NULL, 'Active', '2025-09-27 04:58:15'),
(2, 'Raju Vishnu Puri', 25, 'Male', '09579762044', 'rajp66228@gamil.com', 'shevgaon', 'stomch diango\r\n', NULL, 'Active', '2025-09-27 05:37:54'),
(3, 'Raju Vishnu Puri', 25, 'M', '09579762026', 'raj126@gamil.com', 'shevgaon', 'accidental case', '12345', 'Pending', '2025-09-28 03:47:36');

-- --------------------------------------------------------

--
-- Table structure for table `patient_reports`
--

CREATE TABLE `patient_reports` (
  `ReportID` int NOT NULL,
  `PatientName` varchar(100) NOT NULL,
  `Diagnosis` varchar(255) NOT NULL,
  `EssentialInfo` varchar(500) DEFAULT NULL,
  `CreatedDate` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `patient_reports`
--

INSERT INTO `patient_reports` (`ReportID`, `PatientName`, `Diagnosis`, `EssentialInfo`, `CreatedDate`) VALUES
(1, 'raju puri', 'accidenatl opration', 'brain damage ', '2025-09-28 08:39:03'),
(2, 'raju puri gadewadi', 'accidenatl opration', 'brain damage ', '2025-09-28 08:51:44'),
(3, 'raju puri gadewadi', 'accidenatl opration', 'brain damage ', '2025-09-28 08:53:44'),
(4, 'raju puri gadewadi', 'accidenatl opration', 'brain damage ', '2025-09-28 08:56:57'),
(5, 'raju puri shevgaon', 'accidenatl opration', 'brain damage ', '2025-09-28 08:57:03');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `UserID` int NOT NULL,
  `Username` varchar(50) NOT NULL,
  `PasswordHash` varchar(255) NOT NULL,
  `Role` varchar(20) NOT NULL,
  `FullName` varchar(100) NOT NULL,
  `CreatedDate` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`UserID`, `Username`, `PasswordHash`, `Role`, `FullName`, `CreatedDate`) VALUES
(2, 'doctor1', 'ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f', 'Doctor', 'Dr. John Smith', '2025-09-27 04:56:47'),
(3, 'rahul12', '5994471abb01112afcc18159f6cc74b4f511b99806da59b3caf5a9c173cacfc5', 'Admin', 'DR.Rahul', '2025-09-27 05:41:36'),
(4, 'raju@gmail', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'Doctor', 'DR.raju', '2025-09-27 05:42:10'),
(5, 'uday@122', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'User', 'uday kale ', '2025-09-28 03:56:07'),
(6, 'user12', '6b51d431df5d7f141cbececcf79edf3dd861c3b4069f0b11661a3eefacbba918', 'User ', 'ram kale ', '2025-09-28 06:38:58'),
(7, 'ajay123@', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'User ', 'ajay', '2025-09-28 06:53:20'),
(8, 'admin@123', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'Admin', 'admin12', '2025-09-28 07:36:53'),
(9, 'ramak@123', '1234', 'Doctor', 'rama', '2025-09-28 08:19:18'),
(11, 'raju123', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'Admin', 'sima raju giri', '2025-10-06 05:15:57'),
(12, 'raju', '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4', 'User ', 'raju puri', '2025-10-28 05:38:21'),
(13, 'raj', '9af15b336e6a9619928537df30b2e6a2376569fcf9d7e773eccede65606529a0', 'User ', '123', '2025-10-28 05:39:24'),
(14, 'admin2', '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4', 'User ', '1234', '2025-10-28 05:41:27'),
(15, 'raju1234', '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4', 'User ', 'raju', '2025-10-28 05:46:04'),
(16, 'ram', '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4', 'User ', '124', '2025-10-28 06:11:54'),
(17, 'admin22', '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4', 'Doctor', 'ram', '2025-10-28 06:12:57'),
(18, 'admin25', '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4', 'User ', 'ram', '2025-10-28 06:15:24');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admissions`
--
ALTER TABLE `admissions`
  ADD PRIMARY KEY (`AdmissionID`),
  ADD KEY `PatientID` (`PatientID`),
  ADD KEY `AssignedDoctorID` (`AssignedDoctorID`);

--
-- Indexes for table `medicalrecords`
--
ALTER TABLE `medicalrecords`
  ADD PRIMARY KEY (`RecordID`),
  ADD KEY `PatientID` (`PatientID`),
  ADD KEY `UpdatedBy` (`UpdatedBy`);

--
-- Indexes for table `patients`
--
ALTER TABLE `patients`
  ADD PRIMARY KEY (`PatientID`),
  ADD UNIQUE KEY `Phone` (`Phone`),
  ADD UNIQUE KEY `Email` (`Email`);

--
-- Indexes for table `patient_reports`
--
ALTER TABLE `patient_reports`
  ADD PRIMARY KEY (`ReportID`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`UserID`),
  ADD UNIQUE KEY `Username` (`Username`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admissions`
--
ALTER TABLE `admissions`
  MODIFY `AdmissionID` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `medicalrecords`
--
ALTER TABLE `medicalrecords`
  MODIFY `RecordID` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `patients`
--
ALTER TABLE `patients`
  MODIFY `PatientID` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `patient_reports`
--
ALTER TABLE `patient_reports`
  MODIFY `ReportID` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `UserID` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `admissions`
--
ALTER TABLE `admissions`
  ADD CONSTRAINT `admissions_ibfk_1` FOREIGN KEY (`PatientID`) REFERENCES `patients` (`PatientID`) ON DELETE CASCADE,
  ADD CONSTRAINT `admissions_ibfk_2` FOREIGN KEY (`AssignedDoctorID`) REFERENCES `users` (`UserID`);

--
-- Constraints for table `medicalrecords`
--
ALTER TABLE `medicalrecords`
  ADD CONSTRAINT `medicalrecords_ibfk_1` FOREIGN KEY (`PatientID`) REFERENCES `patients` (`PatientID`) ON DELETE CASCADE,
  ADD CONSTRAINT `medicalrecords_ibfk_2` FOREIGN KEY (`UpdatedBy`) REFERENCES `users` (`UserID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
