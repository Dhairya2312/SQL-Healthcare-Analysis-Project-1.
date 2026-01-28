-- =============================================
-- HEALTHCARE MANAGEMENT SYSTEM DATABASE SCHEMA
-- SQL Server Implementation
-- =============================================

--CREATE DATABASE HealthcareDB;
--GO

--USE HealthcareDB;
--GO

-- Table 1: Patients
CREATE TABLE Patients (
    PatientID INT PRIMARY KEY IDENTITY(1,1),
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    DateOfBirth DATE NOT NULL,
    Gender CHAR(1) CHECK (Gender IN ('M', 'F', 'O')),
    BloodGroup VARCHAR(5),
    PhoneNumber VARCHAR(15),
    Email VARCHAR(100),
    Address VARCHAR(255),
    City VARCHAR(50),
    State VARCHAR(50),
    ZipCode VARCHAR(10),
    EmergencyContactName VARCHAR(100),
    EmergencyContactPhone VARCHAR(15),
    RegistrationDate DATE DEFAULT GETDATE(),
    IsActive BIT DEFAULT 1
);

-- Table 2: Doctors
CREATE TABLE Doctors (
    DoctorID INT PRIMARY KEY IDENTITY(1,1),
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Specialization VARCHAR(100) NOT NULL,
    LicenseNumber VARCHAR(50) UNIQUE NOT NULL,
    PhoneNumber VARCHAR(15),
    Email VARCHAR(100),
    YearsOfExperience INT,
    ConsultationFee DECIMAL(10,2),
    DepartmentID INT,
    HireDate DATE,
    IsActive BIT DEFAULT 1
);

-- Table 3: Departments
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY IDENTITY(1,1),
    DepartmentName VARCHAR(100) NOT NULL UNIQUE,
    Location VARCHAR(100),
    HeadDoctorID INT,
    PhoneNumber VARCHAR(15),
    Budget DECIMAL(12,2),
    EstablishedDate DATE
);

-- Table 4: Appointments
CREATE TABLE Appointments (
    AppointmentID INT PRIMARY KEY IDENTITY(1,1),
    PatientID INT NOT NULL,
    DoctorID INT NOT NULL,
    AppointmentDate DATE NOT NULL,
    AppointmentTime TIME NOT NULL,
    Status VARCHAR(20) CHECK (Status IN ('Scheduled', 'Completed', 'Cancelled', 'No-Show')),
    ReasonForVisit VARCHAR(255),
    Notes TEXT,
    CreatedDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID)
);

-- Table 5: MedicalRecords
CREATE TABLE MedicalRecords (
    RecordID INT PRIMARY KEY IDENTITY(1,1),
    PatientID INT NOT NULL,
    DoctorID INT NOT NULL,
    AppointmentID INT,
    VisitDate DATE NOT NULL,
    Diagnosis VARCHAR(255),
    Symptoms TEXT,
    Treatment TEXT,
    PrescriptionDetails TEXT,
    FollowUpDate DATE,
    RecordDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID),
    FOREIGN KEY (AppointmentID) REFERENCES Appointments(AppointmentID)
);

-- Table 6: Prescriptions
CREATE TABLE Prescriptions (
    PrescriptionID INT PRIMARY KEY IDENTITY(1,1),
    RecordID INT NOT NULL,
    PatientID INT NOT NULL,
    DoctorID INT NOT NULL,
    MedicationName VARCHAR(200) NOT NULL,
    Dosage VARCHAR(100),
    Frequency VARCHAR(100),
    Duration VARCHAR(50),
    Instructions TEXT,
    PrescriptionDate DATE NOT NULL,
    FOREIGN KEY (RecordID) REFERENCES MedicalRecords(RecordID),
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID)
);

-- Table 7: Billing
CREATE TABLE Billing (
    BillID INT PRIMARY KEY IDENTITY(1,1),
    PatientID INT NOT NULL,
    AppointmentID INT,
    BillDate DATE NOT NULL,
    ConsultationCharges DECIMAL(10,2),
    MedicationCharges DECIMAL(10,2),
    LabCharges DECIMAL(10,2),
    RoomCharges DECIMAL(10,2),
    OtherCharges DECIMAL(10,2),
    TotalAmount DECIMAL(10,2),
    DiscountAmount DECIMAL(10,2) DEFAULT 0,
    TaxAmount DECIMAL(10,2) DEFAULT 0,
    NetAmount DECIMAL(10,2),
    PaymentStatus VARCHAR(20) CHECK (PaymentStatus IN ('Paid', 'Pending', 'Partial', 'Cancelled')),
    PaymentDate DATE,
    PaymentMethod VARCHAR(50),
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (AppointmentID) REFERENCES Appointments(AppointmentID)
);

-- Table 8: LabTests
CREATE TABLE LabTests (
    TestID INT PRIMARY KEY IDENTITY(1,1),
    PatientID INT NOT NULL,
    DoctorID INT NOT NULL,
    AppointmentID INT,
    TestName VARCHAR(200) NOT NULL,
    TestDate DATE NOT NULL,
    ResultDate DATE,
    TestResult VARCHAR(100),
    ReferenceRange VARCHAR(100),
    Status VARCHAR(20) CHECK (Status IN ('Pending', 'Completed', 'Cancelled')),
    TestCost DECIMAL(10,2),
    LabTechnicianName VARCHAR(100),
    Notes TEXT,
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID),
    FOREIGN KEY (AppointmentID) REFERENCES Appointments(AppointmentID)
);

-- Table 9: HospitalAdmissions
CREATE TABLE HospitalAdmissions (
    AdmissionID INT PRIMARY KEY IDENTITY(1,1),
    PatientID INT NOT NULL,
    DoctorID INT NOT NULL,
    AdmissionDate DATETIME NOT NULL,
    DischargeDate DATETIME,
    RoomNumber VARCHAR(20),
    RoomType VARCHAR(50),
    ReasonForAdmission TEXT,
    DischargeSummary TEXT,
    TotalCost DECIMAL(12,2),
    Status VARCHAR(20) CHECK (Status IN ('Admitted', 'Discharged', 'Transferred')),
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID)
);

-- Table 10: Staff
CREATE TABLE Staff (
    StaffID INT PRIMARY KEY IDENTITY(1,1),
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Role VARCHAR(100) NOT NULL,
    DepartmentID INT,
    PhoneNumber VARCHAR(15),
    Email VARCHAR(100),
    Salary DECIMAL(10,2),
    HireDate DATE,
    IsActive BIT DEFAULT 1,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

-- Add Foreign Key Constraint for Departments
ALTER TABLE Departments
ADD FOREIGN KEY (HeadDoctorID) REFERENCES Doctors(DoctorID);

ALTER TABLE Doctors
ADD FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID);

GO

-- =============================================
-- SAMPLE DATA INSERTION
-- Healthcare Management System
-- =============================================

-- Insert Patients
INSERT INTO Patients (FirstName, LastName, DateOfBirth, Gender, BloodGroup, PhoneNumber, Email, Address, City, State, ZipCode, EmergencyContactName, EmergencyContactPhone, RegistrationDate) VALUES
('John', 'Smith', '1985-03-15', 'M', 'O+', '555-0101', 'john.smith@email.com', '123 Main St', 'Boston', 'MA', '02101', 'Jane Smith', '555-0102', '2023-01-15'),
('Emily', 'Johnson', '1990-07-22', 'F', 'A+', '555-0103', 'emily.j@email.com', '456 Oak Ave', 'Boston', 'MA', '02102', 'Michael Johnson', '555-0104', '2023-02-20'),
('Michael', 'Williams', '1978-11-30', 'M', 'B+', '555-0105', 'mwilliams@email.com', '789 Pine Rd', 'Cambridge', 'MA', '02138', 'Sarah Williams', '555-0106', '2023-03-10'),
('Sarah', 'Brown', '1995-05-18', 'F', 'AB+', '555-0107', 'sbrown@email.com', '321 Elm St', 'Somerville', 'MA', '02143', 'Robert Brown', '555-0108', '2023-04-05'),
('David', 'Jones', '1982-09-25', 'M', 'O-', '555-0109', 'djones@email.com', '654 Maple Dr', 'Boston', 'MA', '02115', 'Lisa Jones', '555-0110', '2023-05-12'),
('Jennifer', 'Garcia', '1988-12-08', 'F', 'A-', '555-0111', 'jgarcia@email.com', '987 Birch Ln', 'Brookline', 'MA', '02445', 'Carlos Garcia', '555-0112', '2023-06-18'),
('Robert', 'Martinez', '1975-04-14', 'M', 'B-', '555-0113', 'rmartinez@email.com', '147 Cedar Ave', 'Boston', 'MA', '02116', 'Maria Martinez', '555-0114', '2023-07-22'),
('Jessica', 'Rodriguez', '1992-08-03', 'F', 'AB-', '555-0115', 'jrodriguez@email.com', '258 Spruce St', 'Cambridge', 'MA', '02139', 'Juan Rodriguez', '555-0116', '2023-08-30'),
('William', 'Wilson', '1980-01-27', 'M', 'O+', '555-0117', 'wwilson@email.com', '369 Ash Rd', 'Somerville', 'MA', '02144', 'Mary Wilson', '555-0118', '2023-09-15'),
('Linda', 'Anderson', '1987-06-19', 'F', 'A+', '555-0119', 'landerson@email.com', '741 Willow Dr', 'Boston', 'MA', '02118', 'Thomas Anderson', '555-0120', '2023-10-08'),
('James', 'Taylor', '1991-10-11', 'M', 'B+', '555-0121', 'jtaylor@email.com', '852 Oak St', 'Brookline', 'MA', '02446', 'Patricia Taylor', '555-0122', '2023-11-12'),
('Patricia', 'Thomas', '1984-02-28', 'F', 'O-', '555-0123', 'pthomas@email.com', '963 Pine Ave', 'Cambridge', 'MA', '02140', 'Mark Thomas', '555-0124', '2023-12-05'),
('Richard', 'Jackson', '1979-07-16', 'M', 'A-', '555-0125', 'rjackson@email.com', '159 Elm Rd', 'Boston', 'MA', '02119', 'Susan Jackson', '555-0126', '2024-01-20'),
('Barbara', 'White', '1993-11-05', 'F', 'B-', '555-0127', 'bwhite@email.com', '357 Maple Ln', 'Somerville', 'MA', '02145', 'George White', '555-0128', '2024-02-14'),
('Charles', 'Harris', '1986-03-22', 'M', 'AB+', '555-0129', 'charris@email.com', '753 Birch Dr', 'Boston', 'MA', '02120', 'Nancy Harris', '555-0130', '2024-03-18'),
('Maria', 'Martin', '1989-09-09', 'F', 'O+', '555-0131', 'mmartin@email.com', '951 Cedar St', 'Brookline', 'MA', '02447', 'David Martin', '555-0132', '2024-04-22'),
('Joseph', 'Thompson', '1977-12-31', 'M', 'A+', '555-0133', 'jthompson@email.com', '246 Spruce Ave', 'Cambridge', 'MA', '02141', 'Elizabeth Thompson', '555-0134', '2024-05-10'),
('Lisa', 'Moore', '1994-04-17', 'F', 'B+', '555-0135', 'lmoore@email.com', '468 Ash Rd', 'Boston', 'MA', '02121', 'Kevin Moore', '555-0136', '2024-06-15'),
('Daniel', 'Lee', '1981-08-24', 'M', 'O-', '555-0137', 'dlee@email.com', '579 Willow St', 'Somerville', 'MA', '02146', 'Michelle Lee', '555-0138', '2024-07-08'),
('Margaret', 'Walker', '1996-01-13', 'F', 'A-', '555-0139', 'mwalker@email.com', '681 Oak Dr', 'Boston', 'MA', '02122', 'Christopher Walker', '555-0140', '2024-08-20');

-- Insert Departments
INSERT INTO Departments (DepartmentName, Location, PhoneNumber, Budget, EstablishedDate) VALUES
('Cardiology', 'Building A, Floor 3', '555-1001', 2500000.00, '2010-01-15'),
('Neurology', 'Building A, Floor 4', '555-1002', 2200000.00, '2010-03-20'),
('Orthopedics', 'Building B, Floor 2', '555-1003', 1800000.00, '2011-05-10'),
('Pediatrics', 'Building C, Floor 1', '555-1004', 1500000.00, '2010-06-01'),
('Oncology', 'Building A, Floor 5', '555-1005', 3000000.00, '2012-09-15'),
('Emergency Medicine', 'Building D, Ground Floor', '555-1006', 2800000.00, '2010-01-01'),
('Radiology', 'Building B, Ground Floor', '555-1007', 2000000.00, '2010-02-01'),
('General Surgery', 'Building B, Floor 3', '555-1008', 2400000.00, '2010-04-01'),
('Internal Medicine', 'Building C, Floor 2', '555-1009', 1900000.00, '2010-07-01'),
('Dermatology', 'Building C, Floor 3', '555-1010', 1200000.00, '2013-11-01');

-- Insert Doctors
INSERT INTO Doctors (FirstName, LastName, Specialization, LicenseNumber, PhoneNumber, Email, YearsOfExperience, ConsultationFee, DepartmentID, HireDate) VALUES
('Robert', 'Chen', 'Cardiologist', 'MD-12345', '555-2001', 'rchen@hospital.com', 15, 250.00, 1, '2010-02-01'),
('Sarah', 'Patel', 'Neurologist', 'MD-12346', '555-2002', 'spatel@hospital.com', 12, 275.00, 2, '2011-03-15'),
('Michael', 'Kim', 'Orthopedic Surgeon', 'MD-12347', '555-2003', 'mkim@hospital.com', 10, 300.00, 3, '2012-06-01'),
('Emily', 'Davis', 'Pediatrician', 'MD-12348', '555-2004', 'edavis@hospital.com', 8, 180.00, 4, '2014-01-10'),
('David', 'Wilson', 'Oncologist', 'MD-12349', '555-2005', 'dwilson@hospital.com', 18, 350.00, 5, '2010-05-01'),
('Lisa', 'Thompson', 'Emergency Medicine', 'MD-12350', '555-2006', 'lthompson@hospital.com', 13, 220.00, 6, '2011-08-15'),
('James', 'Brown', 'Radiologist', 'MD-12351', '555-2007', 'jbrown@hospital.com', 11, 280.00, 7, '2012-09-01'),
('Jennifer', 'Miller', 'General Surgeon', 'MD-12352', '555-2008', 'jmiller@hospital.com', 14, 320.00, 8, '2011-11-20'),
('William', 'Taylor', 'Internal Medicine', 'MD-12353', '555-2009', 'wtaylor@hospital.com', 9, 200.00, 9, '2014-04-01'),
('Maria', 'Garcia', 'Dermatologist', 'MD-12354', '555-2010', 'mgarcia@hospital.com', 7, 190.00, 10, '2015-07-15'),
('Thomas', 'Anderson', 'Cardiologist', 'MD-12355', '555-2011', 'tanderson@hospital.com', 16, 260.00, 1, '2010-09-01'),
('Nancy', 'Martinez', 'Pediatrician', 'MD-12356', '555-2012', 'nmartinez@hospital.com', 6, 175.00, 4, '2016-02-01'),
('Christopher', 'Lee', 'Orthopedic Surgeon', 'MD-12357', '555-2013', 'clee@hospital.com', 12, 310.00, 3, '2013-05-15'),
('Linda', 'White', 'Oncologist', 'MD-12358', '555-2014', 'lwhite@hospital.com', 10, 340.00, 5, '2013-08-01'),
('Steven', 'Harris', 'Neurologist', 'MD-12359', '555-2015', 'sharris@hospital.com', 8, 270.00, 2, '2015-10-01');

-- Insert Appointments
INSERT INTO Appointments (PatientID, DoctorID, AppointmentDate, AppointmentTime, Status, ReasonForVisit, CreatedDate) VALUES
(1, 1, '2024-01-15', '09:00', 'Completed', 'Chest pain and shortness of breath', '2024-01-10'),
(2, 4, '2024-01-15', '10:30', 'Completed', 'Child vaccination', '2024-01-12'),
(3, 3, '2024-01-16', '14:00', 'Completed', 'Knee pain after injury', '2024-01-13'),
(4, 10, '2024-01-17', '11:00', 'Completed', 'Skin rash and itching', '2024-01-14'),
(5, 9, '2024-01-18', '09:30', 'Completed', 'Annual checkup', '2024-01-15'),
(6, 2, '2024-01-19', '15:00', 'Completed', 'Severe headaches', '2024-01-16'),
(7, 5, '2024-01-20', '10:00', 'Completed', 'Follow-up for cancer treatment', '2024-01-17'),
(8, 12, '2024-01-22', '08:30', 'Completed', 'Child fever and cough', '2024-01-19'),
(9, 8, '2024-01-23', '13:00', 'Completed', 'Abdominal pain', '2024-01-20'),
(10, 1, '2024-01-24', '10:00', 'Completed', 'High blood pressure consultation', '2024-01-21'),
(11, 3, '2024-01-25', '11:30', 'Completed', 'Back pain', '2024-01-22'),
(12, 9, '2024-01-26', '09:00', 'Completed', 'Diabetes management', '2024-01-23'),
(13, 6, '2024-01-27', '16:00', 'Completed', 'Emergency chest pain', '2024-01-27'),
(14, 10, '2024-01-29', '14:00', 'Completed', 'Acne treatment', '2024-01-26'),
(15, 11, '2024-01-30', '09:30', 'Completed', 'Heart palpitations', '2024-01-27'),
(16, 4, '2024-02-01', '10:00', 'Completed', 'Child allergies', '2024-01-29'),
(17, 5, '2024-02-02', '11:00', 'Completed', 'Cancer screening', '2024-01-30'),
(18, 2, '2024-02-03', '15:30', 'Completed', 'Migraine', '2024-02-01'),
(19, 13, '2024-02-05', '08:00', 'Completed', 'Hip replacement consultation', '2024-02-02'),
(20, 9, '2024-02-06', '10:30', 'Completed', 'Hypertension follow-up', '2024-02-03'),
(1, 11, '2024-03-10', '09:00', 'Completed', 'Follow-up for heart condition', '2024-03-05'),
(3, 13, '2024-03-12', '14:00', 'Completed', 'Physical therapy consultation', '2024-03-08'),
(5, 9, '2024-04-15', '10:00', 'Completed', 'Quarterly checkup', '2024-04-10'),
(7, 14, '2024-05-20', '11:00', 'Completed', 'Chemotherapy follow-up', '2024-05-15'),
(2, 12, '2024-06-10', '09:30', 'Completed', 'Child wellness exam', '2024-06-05'),
(10, 1, '2024-07-15', '10:30', 'Completed', 'Cardiac stress test', '2024-07-10'),
(15, 11, '2024-08-20', '14:00', 'Completed', 'EKG follow-up', '2024-08-15'),
(6, 15, '2024-09-10', '11:30', 'Cancelled', 'Neurological consultation', '2024-09-05'),
(18, 2, '2024-10-05', '15:00', 'No-Show', 'Headache follow-up', '2024-10-01'),
(1, 1, '2025-01-15', '09:00', 'Scheduled', 'Annual cardiac checkup', '2025-01-10'),
(5, 9, '2025-01-20', '10:00', 'Scheduled', 'Routine physical', '2025-01-15'),
(10, 11, '2025-01-25', '11:00', 'Scheduled', 'Heart health consultation', '2025-01-20');

-- Insert Medical Records
INSERT INTO MedicalRecords (PatientID, DoctorID, AppointmentID, VisitDate, Diagnosis, Symptoms, Treatment, PrescriptionDetails, FollowUpDate) VALUES
(1, 1, 1, '2024-01-15', 'Coronary Artery Disease', 'Chest pain, shortness of breath, fatigue', 'Prescribed medication and lifestyle changes', 'Aspirin 81mg daily, Atorvastatin 40mg', '2024-02-15'),
(2, 4, 2, '2024-01-15', 'Routine Vaccination', 'None', 'Administered MMR vaccine', 'N/A', '2025-01-15'),
(3, 3, 3, '2024-01-16', 'Meniscus Tear', 'Knee pain, swelling, limited mobility', 'Physical therapy recommended, pain management', 'Ibuprofen 600mg as needed', '2024-02-16'),
(4, 10, 4, '2024-01-17', 'Contact Dermatitis', 'Red itchy rash on arms', 'Topical steroid cream', 'Hydrocortisone 1% cream twice daily', '2024-02-17'),
(5, 9, 5, '2024-01-18', 'Healthy - Annual Checkup', 'None', 'Continue healthy lifestyle', 'Multivitamin daily', '2025-01-18'),
(6, 2, 6, '2024-01-19', 'Chronic Migraine', 'Severe recurring headaches, light sensitivity', 'Prescribed preventive medication', 'Propranolol 80mg daily', '2024-03-19'),
(7, 5, 7, '2024-01-20', 'Stage 2 Breast Cancer', 'Post-surgery follow-up', 'Continue chemotherapy protocol', 'Chemotherapy medications', '2024-02-20'),
(8, 12, 8, '2024-01-22', 'Viral Upper Respiratory Infection', 'Fever, cough, runny nose', 'Rest, fluids, symptomatic treatment', 'Acetaminophen for fever', '2024-02-05'),
(9, 8, 9, '2024-01-23', 'Acute Appendicitis', 'Severe abdominal pain, nausea', 'Emergency appendectomy performed', 'Antibiotics post-surgery', '2024-02-23'),
(10, 1, 10, '2024-01-24', 'Hypertension', 'Elevated blood pressure readings', 'Blood pressure medication initiated', 'Lisinopril 10mg daily', '2024-03-24'),
(11, 3, 11, '2024-01-25', 'Lumbar Strain', 'Lower back pain after lifting', 'Physical therapy and pain management', 'Muscle relaxants', '2024-02-25'),
(12, 9, 12, '2024-01-26', 'Type 2 Diabetes', 'Elevated blood glucose levels', 'Diabetes management plan', 'Metformin 500mg twice daily', '2024-03-26'),
(13, 6, 13, '2024-01-27', 'Acute Myocardial Infarction', 'Severe chest pain, sweating', 'Emergency cardiac catheterization', 'Multiple cardiac medications', '2024-02-10'),
(14, 10, 14, '2024-01-29', 'Acne Vulgaris', 'Facial acne breakouts', 'Topical retinoid and antibiotic', 'Tretinoin cream, Clindamycin gel', '2024-04-29'),
(15, 11, 15, '2024-01-30', 'Atrial Fibrillation', 'Irregular heartbeat, palpitations', 'Rate control medication', 'Diltiazem 120mg daily', '2024-02-27');

-- Insert Prescriptions
INSERT INTO Prescriptions (RecordID, PatientID, DoctorID, MedicationName, Dosage, Frequency, Duration, Instructions, PrescriptionDate) VALUES
(1, 1, 1, 'Aspirin', '81mg', 'Once daily', '90 days', 'Take with food in the morning', '2024-01-15'),
(1, 1, 1, 'Atorvastatin', '40mg', 'Once daily', '90 days', 'Take at bedtime', '2024-01-15'),
(3, 3, 3, 'Ibuprofen', '600mg', 'Three times daily', '14 days', 'Take with food', '2024-01-16'),
(4, 4, 10, 'Hydrocortisone Cream', '1%', 'Twice daily', '14 days', 'Apply to affected area', '2024-01-17'),
(6, 6, 2, 'Propranolol', '80mg', 'Once daily', '90 days', 'Take in the morning', '2024-01-19'),
(8, 8, 12, 'Acetaminophen', '500mg', 'Every 6 hours', '7 days', 'Take as needed for fever', '2024-01-22'),
(9, 9, 8, 'Amoxicillin', '500mg', 'Three times daily', '7 days', 'Complete full course', '2024-01-23'),
(10, 10, 1, 'Lisinopril', '10mg', 'Once daily', '90 days', 'Take in the morning', '2024-01-24'),
(11, 11, 3, 'Cyclobenzaprine', '10mg', 'Three times daily', '10 days', 'May cause drowsiness', '2024-01-25'),
(12, 12, 9, 'Metformin', '500mg', 'Twice daily', '90 days', 'Take with meals', '2024-01-26'),
(13, 13, 6, 'Clopidogrel', '75mg', 'Once daily', '365 days', 'Take at same time each day', '2024-01-27'),
(13, 13, 6, 'Metoprolol', '50mg', 'Twice daily', '365 days', 'Do not stop abruptly', '2024-01-27'),
(14, 14, 10, 'Tretinoin Cream', '0.025%', 'Once daily', '90 days', 'Apply at bedtime', '2024-01-29'),
(15, 15, 11, 'Diltiazem', '120mg', 'Once daily', '90 days', 'Extended release formula', '2024-01-30');

-- Insert Lab Tests
INSERT INTO LabTests (PatientID, DoctorID, AppointmentID, TestName, TestDate, ResultDate, TestResult, ReferenceRange, Status, TestCost, LabTechnicianName) VALUES
(1, 1, 1, 'Lipid Panel', '2024-01-15', '2024-01-16', 'High Cholesterol: 240 mg/dL', '<200 mg/dL', 'Completed', 85.00, 'Tech-001'),
(1, 1, 1, 'ECG', '2024-01-15', '2024-01-15', 'Abnormal - ST segment changes', 'Normal', 'Completed', 150.00, 'Tech-002'),
(3, 3, 3, 'X-Ray Knee', '2024-01-16', '2024-01-16', 'Meniscus tear confirmed', 'Normal', 'Completed', 200.00, 'Tech-003'),
(5, 9, 5, 'Complete Blood Count', '2024-01-18', '2024-01-19', 'Normal', 'Normal ranges', 'Completed', 75.00, 'Tech-001'),
(5, 9, 5, 'Comprehensive Metabolic Panel', '2024-01-18', '2024-01-19', 'Normal', 'Normal ranges', 'Completed', 95.00, 'Tech-001'),
(6, 2, 6, 'MRI Brain', '2024-01-19', '2024-01-20', 'No abnormalities detected', 'Normal', 'Completed', 1200.00, 'Tech-004'),
(9, 8, 9, 'CT Scan Abdomen', '2024-01-23', '2024-01-23', 'Acute appendicitis confirmed', 'Normal', 'Completed', 800.00, 'Tech-005'),
(10, 1, 10, 'Blood Pressure Monitoring', '2024-01-24', '2024-01-24', '160/95 mmHg', '120/80 mmHg', 'Completed', 50.00, 'Tech-002'),
(12, 9, 12, 'HbA1c Test', '2024-01-26', '2024-01-27', '8.5%', '<5.7%', 'Completed', 90.00, 'Tech-001'),
(12, 9, 12, 'Fasting Glucose', '2024-01-26', '2024-01-27', '185 mg/dL', '70-100 mg/dL', 'Completed', 65.00, 'Tech-001'),
(13, 6, 13, 'Troponin Test', '2024-01-27', '2024-01-27', 'Elevated', '<0.04 ng/mL', 'Completed', 120.00, 'Tech-006'),
(13, 6, 13, 'Cardiac Catheterization', '2024-01-27', '2024-01-27', '70% blockage LAD', 'Normal', 'Completed', 3500.00, 'Tech-007'),
(15, 11, 15, 'ECG', '2024-01-30', '2024-01-30', 'Atrial Fibrillation confirmed', 'Normal', 'Completed', 150.00, 'Tech-002'),
(15, 11, 15, 'Echocardiogram', '2024-01-30', '2024-01-31', 'Mild left atrial enlargement', 'Normal', 'Completed', 450.00, 'Tech-008');

-- Insert Billing
INSERT INTO Billing (PatientID, AppointmentID, BillDate, ConsultationCharges, MedicationCharges, LabCharges, RoomCharges, OtherCharges, TotalAmount, DiscountAmount, TaxAmount, NetAmount, PaymentStatus, PaymentDate, PaymentMethod) VALUES
(1, 1, '2024-01-15', 250.00, 45.00, 235.00, 0.00, 0.00, 530.00, 0.00, 0.00, 530.00, 'Paid', '2024-01-15', 'Insurance'),
(2, 2, '2024-01-15', 180.00, 0.00, 0.00, 0.00, 50.00, 230.00, 0.00, 0.00, 230.00, 'Paid', '2024-01-15', 'Cash'),
(3, 3, '2024-01-16', 300.00, 25.00, 200.00, 0.00, 0.00, 525.00, 52.50, 0.00, 472.50, 'Paid', '2024-01-20', 'Credit Card'),
(4, 4, '2024-01-17', 190.00, 35.00, 0.00, 0.00, 0.00, 225.00, 0.00, 0.00, 225.00, 'Paid', '2024-01-17', 'Insurance'),
(5, 5, '2024-01-18', 200.00, 15.00, 170.00, 0.00, 0.00, 385.00, 0.00, 0.00, 385.00, 'Paid', '2024-01-25', 'Insurance'),
(6, 6, '2024-01-19', 275.00, 60.00, 1200.00, 0.00, 0.00, 1535.00, 0.00, 0.00, 1535.00, 'Paid', '2024-01-30', 'Insurance'),
(7, 7, '2024-01-20', 350.00, 0.00, 0.00, 0.00, 2500.00, 2850.00, 0.00, 0.00, 2850.00, 'Paid', '2024-02-10', 'Insurance'),
(8, 8, '2024-01-22', 175.00, 20.00, 0.00, 0.00, 0.00, 195.00, 0.00, 0.00, 195.00, 'Paid', '2024-01-22', 'Cash'),
(9, 9, '2024-01-23', 320.00, 85.00, 800.00, 1500.00, 3000.00, 5705.00, 0.00, 0.00, 5705.00, 'Paid', '2024-02-15', 'Insurance'),
(10, 10, '2024-01-24', 250.00, 40.00, 50.00, 0.00, 0.00, 340.00, 0.00, 0.00, 340.00, 'Paid', '2024-01-24', 'Insurance'),
(11, 11, '2024-01-25', 300.00, 30.00, 0.00, 0.00, 0.00, 330.00, 0.00, 0.00, 330.00, 'Paid', '2024-02-01', 'Credit Card'),
(12, 12, '2024-01-26', 200.00, 50.00, 155.00, 0.00, 0.00, 405.00, 0.00, 0.00, 405.00, 'Paid', '2024-01-30', 'Insurance'),
(13, 13, '2024-01-27', 220.00, 200.00, 3620.00, 2500.00, 5000.00, 11540.00, 0.00, 0.00, 11540.00, 'Partial', '2024-02-15', 'Insurance'),
(14, 14, '2024-01-29', 190.00, 75.00, 0.00, 0.00, 0.00, 265.00, 0.00, 0.00, 265.00, 'Paid', '2024-01-29', 'Cash'),
(15, 15, '2024-01-30', 260.00, 65.00, 600.00, 0.00, 0.00, 925.00, 0.00, 0.00, 925.00, 'Paid', '2024-02-05', 'Insurance');

-- Insert Hospital Admissions
INSERT INTO HospitalAdmissions (PatientID, DoctorID, AdmissionDate, DischargeDate, RoomNumber, RoomType, ReasonForAdmission, DischargeSummary, TotalCost, Status) VALUES
(9, 8, '2024-01-23 14:30', '2024-01-26 10:00', '302', 'Semi-Private', 'Acute Appendicitis - Emergency Surgery', 'Patient underwent successful appendectomy. Recovery was uneventful. Discharged with antibiotics.', 5705.00, 'Discharged'),
(13, 6, '2024-01-27 16:30', '2024-01-30 11:00', '401-ICU', 'ICU', 'Acute Myocardial Infarction', 'Patient underwent cardiac catheterization with stent placement. Stable condition. Cardiac rehabilitation recommended.', 11540.00, 'Discharged'),
(7, 5, '2024-02-15 09:00', '2024-02-17 14:00', '205', 'Private', 'Chemotherapy Treatment', 'Patient completed chemotherapy cycle. Tolerated treatment well. Follow-up in 3 weeks.', 4200.00, 'Discharged');

-- Insert Staff
INSERT INTO Staff (FirstName, LastName, Role, DepartmentID, PhoneNumber, Email, Salary, HireDate) VALUES
('Amanda', 'Rogers', 'Head Nurse', 1, '555-3001', 'arogers@hospital.com', 75000.00, '2011-03-15'),
('Brian', 'Cooper', 'Nurse', 2, '555-3002', 'bcooper@hospital.com', 65000.00, '2013-06-01'),
('Catherine', 'Hughes', 'Lab Technician', 7, '555-3003', 'chughes@hospital.com', 55000.00, '2014-09-10'),
('Daniel', 'Foster', 'Pharmacist', 1, '555-3004', 'dfoster@hospital.com', 90000.00, '2012-01-20'),
('Elena', 'Price', 'Nurse', 4, '555-3005', 'eprice@hospital.com', 67000.00, '2015-04-15'),
('Frank', 'Bennett', 'Administrative Assistant', 9, '555-3006', 'fbennett@hospital.com', 48000.00, '2016-07-01'),
('Grace', 'Wood', 'Physical Therapist', 3, '555-3007', 'gwood@hospital.com', 72000.00, '2014-11-01'),
('Henry', 'Barnes', 'Radiologic Technologist', 7, '555-3008', 'hbarnes@hospital.com', 68000.00, '2013-02-15'),
('Isabel', 'Ross', 'Nurse Practitioner', 6, '555-3009', 'iross@hospital.com', 95000.00, '2012-05-20'),
('Jason', 'Henderson', 'Medical Records Clerk', 9, '555-3010', 'jhenderson@hospital.com', 42000.00, '2017-03-10');

GO

