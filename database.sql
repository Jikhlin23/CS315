DROP DATABASE HospitalDB;

CREATE DATABASE HospitalDB;

USE HospitalDB;

CREATE TABLE Patient (
    Patient_ID INT NOT NULL,
    Patient_FName VARCHAR(20) NOT NULL,
    Patient_LName VARCHAR(20) NOT NULL,
    Phone VARCHAR(13) NOT NULL,
    Blood_Type  VARCHAR(5) NOT NULL,
    Email VARCHAR(50),
    Gender  VARCHAR(10),
    Condition_ VARCHAR(30),
    PRIMARY KEY (Patient_ID) 
    );

CREATE TABLE Department (
    Dept_ID INT NOT NULL,
    Dept_Head INT NOT NULL,
    Dept_Name VARCHAR(15) NOT NULL,
    PRIMARY  KEY (Dept_ID) 
  );

CREATE TABLE Staff (
    Emp_ID INT  NOT NULL,
    Emp_FName  VARCHAR(20) NOT NULL,
    Emp_LName  VARCHAR(20) NOT NULL,
    Date_Joining  DATE,
    Date_Seperation DATE,
    Email  VARCHAR(50),
    Address  VARCHAR(50),
    Dept_ID  INT NOT NULL,
    Gender  VARCHAR(10),
    PRIMARY KEY (Emp_ID),
    FOREIGN KEY (Dept_ID) REFERENCES Department  (Dept_ID)
);

CREATE TABLE Doctor (
    Doctor_ID INT NOT NULL,
    Qualifications VARCHAR(20) NOT NULL,
    Emp_ID INT NOT NULL,
    Specialization VARCHAR(30) NOT NULL,
    PRIMARY KEY (Doctor_ID),
    FOREIGN KEY (Emp_ID) REFERENCES Staff (Emp_ID)
);

CREATE TABLE Nurse (
    Nurse_ID INT  NOT NULL,
    Patient_ID  INT  NOT NULL,
    Emp_ID  INT NOT NULL,
    PRIMARY KEY(Nurse_ID),
    FOREIGN KEY (Patient_ID) REFERENCES Patient (Patient_ID),
    FOREIGN KEY (Emp_ID) REFERENCES Staff  (Emp_ID)
);

CREATE TABLE Emergency_Contact(
    Contact_ID INT  NOT NULL,
    Contact_Name VARCHAR(20) NOT NULL,
    Phone VARCHAR(13) NOT NULL,
    Relation VARCHAR(20) NOT NULL,
    Patient_ID  INT NOT NULL,
    PRIMARY KEY (Contact_ID),
    FOREIGN KEY (Patient_ID) REFERENCES Patient (Patient_ID)
);

  CREATE TABLE Payroll (
    Account_No VARCHAR(25) NOT NULL,
    Salary DECIMAL(10,2) NOT NULL,
    Bonus DECIMAL(10,2),
    Emp_ID INT NOT NULL,
    PRIMARY KEY (Account_No),
    FOREIGN KEY (Emp_ID) REFERENCES Staff (Emp_ID)
   );

 CREATE TABLE  Lab_Screening (
    Lab_ID INT NOT NULL,
    Patient_ID  INT  NOT NULL,
    Technician_ID  INT  NOT NULL,
    Doctor_ID  INT,
    Test_Cost  DECIMAL(10,2),
    Date  DATE  NOT NULL,
    PRIMARY KEY (Lab_ID),
    FOREIGN KEY (Patient_ID) REFERENCES Patient (Patient_ID),
    FOREIGN KEY (Technician_ID) REFERENCES Staff (Emp_ID),
    FOREIGN KEY (Doctor_ID) REFERENCES Doctor (Doctor_ID)
);

CREATE TABLE Insurance (
    Policy_Number      VARCHAR(30)      NOT NULL,    -- e.g. ten-digit alphanumeric
    Patient_ID         INT               NOT NULL,
    Insurer_IRDAI_Code VARCHAR(15)       NOT NULL,    -- IRDAI registration code
    Start_Date         DATE              NOT NULL,
    End_Date           DATE              NOT NULL,
    Provider_Name      VARCHAR(100)      NOT NULL,    -- e.g. “Star Health”
    Plan_Name          VARCHAR(100),                 -- e.g. “Family Floater”
    Sum_Insured        DECIMAL(12,2)     NOT NULL,    -- total cover amount
    PRIMARY KEY (Policy_Number),
    FOREIGN KEY (Patient_ID) REFERENCES Patient (Patient_ID)
);

CREATE TABLE Medicine (
    Medicine_ID INT  NOT NULL,
    M_Name VARCHAR(20) NOT NULL,
    M_Quantity INT NOT NULL,
    M_Cost  Decimal(10,2),
   PRIMARY KEY (Medicine_ID)
    );

CREATE TABLE Prescription (
    Prescription_ID INT  NOT NULL,
    Patient_ID  INT  NOT NULL,
    Medicine_ID  INT  NOT NULL,
    Date  DATE,
    Dosage  INT,  -- Amount prescribed on daily basis
    Doctor_ID INT NOT NULL,
    PRIMARY KEY (Prescription_ID),
    FOREIGN KEY (Patient_ID) REFERENCES Patient (Patient_ID),
    FOREIGN KEY (Doctor_ID) REFERENCES Doctor (Doctor_ID),
    FOREIGN KEY (Medicine_ID) REFERENCES Medicine (Medicine_ID)
);

CREATE TABLE Medical_History (
    Record_ID  INT NOT NULL,
    Patient_ID  INT NOT NULL,
    Allergies VARCHAR(50),
    Pre_Conditions VARCHAR(50),
    PRIMARY KEY (Record_ID),
    FOREIGN KEY (Patient_ID) REFERENCES Patient (Patient_ID)
);

CREATE TABLE Appointment (
    Appt_ID INT  NOT NULL,
    Date  DATE,
    Day_Of_Week ENUM('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday') NOT NULL,
    Doctor_ID INT NOT NULL,
    Patient_ID  INT NOT NULL,
    PRIMARY KEY (Appt_ID),
    FOREIGN KEY (Doctor_ID) REFERENCES Doctor (Doctor_ID), 
    FOREIGN KEY (Patient_ID) REFERENCES Patient (Patient_ID)
);

 CREATE TABLE  Room (
    Room_ID INT NOT NULL,
    Room_Type VARCHAR(50) NOT NULL,
    Patient_ID  INT,
    Doctor_ID INT,
    Room_Cost  DECIMAL(10,2),
    PRIMARY KEY (Room_ID),
    FOREIGN KEY (Patient_ID) REFERENCES Patient (Patient_ID),
    FOREIGN KEY (Doctor_ID) REFERENCES Doctor (Doctor_ID)
    );

CREATE TABLE Bill (
    Bill_ID INT NOT NULL,
    Date  DATE,
    Room_Cost Decimal(10,2),
    Test_Cost  DECIMAL(10,2),
    Other_Charges  DECIMAL(10,2),
    M_Cost DECIMAL(10,2),
    Total  DECIMAL(10,2),
    Patient_ID INT NOT NULL,
    Remaining_Balance DECIMAL(10,2),
    Policy_Number VARCHAR(20),
    PRIMARY KEY (Bill_ID),
    FOREIGN KEY (Patient_ID) REFERENCES Patient (Patient_ID),
    FOREIGN KEY (Policy_Number) REFERENCES Insurance (Policy_Number)
);

CREATE TABLE Doctor_Schedule (
    Schedule_ID INT NOT NULL AUTO_INCREMENT,
    Doctor_ID INT NOT NULL,
    Day_Of_Week ENUM('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday') NOT NULL,
    Start_Time TIME NOT NULL,
    End_Time TIME NOT NULL,
    Slot_Duration  INT NOT NULL, -- in minutes, e.g., 15 for 15-minute slots
    PRIMARY KEY (Schedule_ID),
    FOREIGN KEY (Doctor_ID) REFERENCES Doctor(Doctor_ID)
);

INSERT INTO Department (Dept_ID, Dept_Head, Dept_Name) 
VALUES 
(1, 101, 'Cardiology'),
(2, 201, 'Neurology'),
(3, 301, 'Orthopedics'),
(4, 401, 'Pharmacy'),
(5, 501, 'Housekeeping'),
(6, 601, 'Pediatrics'),
(7, 701, 'Billing'),
(8, 801, 'HR/Payroll'),
(9, 901, 'Reception'),
(10, 1001, 'Dermatology'),
(11, 1101, 'Nursing');

INSERT INTO Staff (Emp_ID, Emp_FName, Emp_LName, Date_Joining, Date_Seperation, Email, Address, Dept_ID, Gender) 
VALUES 
-- Cardiology (Dept_ID = 1)
(101, 'Rajesh', 'Khanna', '2018-05-10', NULL, 'rajesh.khanna@hospital.com', 'Mumbai, Maharashtra', 1 , 'Male'),
(102, 'Aarav', 'Sharma', '2020-05-01', NULL, 'aarav.sharma@hospital.com', 'Delhi, Delhi', 1,  'Male'),
-- Neurology (DEpt_ID = 2)
(201, 'Priya', 'Reddy', '2019-02-15', NULL, 'priya.reddy@hospital.com', 'Hyderabad, Telangana', 2,'Female'),
(202, 'Kavita', 'Nair', '2020-09-14', NULL, 'kavita.nair@hospital.com', 'Thiruvananthapuram, Kerala', 2,'Female'),
-- Orthopedics (Dept_ID = 3)
(301, 'Vikram', 'Singh', '2021-11-18', NULL, 'vikram.singh@hospital.com', 'Kolkata, West Bengal', 3,  'Male'),
(302, 'Ravi', 'Kumar', '2020-07-30', NULL, 'ravi.kumar@hospital.com', 'Gaya, Bihar', 3,  'Male'),
-- Pharmacy (Dept_ID = 4)
(401, 'Anjali', 'Desai', '2020-01-05', NULL, 'anjali.desai@hospital.com', 'Chennai, Tamil Nadu', 4,'Female'),
(402, 'Meera', 'Patel', '2021-12-10', NULL, 'meera.patel@hospital.com', 'Surat, Gujarat', 4,'Female'),
-- Housekeeping (Dept_ID = 5)
(501, 'Ramesh', 'Patel', '2020-08-25', NULL, 'ramesh.patel@hospital.com', 'Ahmedabad, Gujarat', 5 , 'Male'),
(502, 'Suresh', 'Iyer', '2020-01-20', NULL, 'suresh.iyer@hospital.com', 'Coimbatore, Tamil Nadu', 5, 'Male'),
-- Pediatrics (Dept_ID = 6)
(601, 'Sunita', 'Sharma', '2020-04-10', NULL, 'sunita.sharma@hospital.com', 'Pune, Maharashtra', 6,'Female'),
(602, 'Ananya', 'Das', '2020-08-05', NULL, 'ananya.das@hospital.com', 'Siliguri, West Bengal', 6,'Female'),
-- Billing (Dept_ID = 7)
(701, 'Neha', 'Gupta', '2020-03-20', NULL, 'neha.gupta@hospital.com', 'Delhi, Delhi', 7,'Female'),
(702, 'Rahul', 'Verma', '2021-07-12', '2025-12-22', 'rahul.verma@hospital.com', 'Bangalore, Karnataka', 7, 'Male'),
(703, 'Vijay', 'Malhotra', '2021-11-15', NULL, 'vijay.malhotra@hospital.com', 'Chandigarh, Punjab', 7, 'Male'),
-- HR/Payroll (Dept_ID = 8)
(801, 'Arun', 'Kumar', '2020-01-01', NULL, 'arun.kumar@hospital.com', 'Patna, Bihar', 8, 'Male'),
(802, 'Preeti', 'Choudhury', '2021-04-22', NULL, 'preeti.choudhury@hospital.com', 'Udaipur, Rajasthan', 8,'Female'),
-- Reception (Dept_ID = 9)
(901, 'Amit', 'Yadav', '2021-06-15', NULL, 'amit.yadav@hospital.com', 'Jaipur, Rajasthan', 9, 'Male'),
(902, 'Deepak', 'Mehta', '2021-10-01', NULL, 'deepak.mehta@hospital.com', 'Nagpur, Maharashtra', 9, 'Male'),
-- Dermatology (Dept_ID = 10)
(1001, 'Sneha', 'Joshi', '2021-03-22', NULL, 'sneha.joshi@hospital.com', 'Lucknow, Uttar Pradesh', 10,'Female'),
(1002, 'Nisha', 'Srinivasan', '2021-01-10', NULL, 'nisha.srinivasan@hospital.com', 'Mysuru, Karnataka', 10,'Female'),
-- Nursing (Dept_ID = 11)
(1101, 'Priya', 'Sharma', '2020-01-15', NULL, 'priya.sharma@hospital.com', 'Bhopal, Madhya Pradesh', 11,'Female'),
(1102, 'Anil', 'Verma', '2019-07-10', '2025-11-30', 'anil.verma@hospital.com', 'Chennai, Tamil Nadu', 11, 'Male'),
(1103, 'Meena', 'Iyer', '2021-03-20', NULL, 'meena.iyer@hospital.com', 'Kolkata, West Bengal', 11,'Female'),
(1104, 'Kavita', 'Reddy', '2021-06-01', NULL, 'kavita.reddy@hospital.com', 'Hyderabad, Telangana', 11,'Female');

INSERT INTO Patient (Patient_ID, Patient_FName, Patient_LName, Phone, Blood_Type, Email, Gender, Condition_) 
VALUES 
(1001, 'Aarav', 'Sharma', '+919876543210', 'B+', 'aarav.sharma@gmail.com', 'Male', 'Hypertension'),
(1002, 'Priya', 'Patel', '+919712345678', 'A+', 'priya.patel@gmail.com', 'Female', 'Diabetes'),
(1003, 'Rohan', 'Verma', '+919898765432', 'O+', 'rohan.verma@gmail.com', 'Male', 'Fracture'),
(1004, 'Anaya', 'Singh', '+919877665544', 'AB+', 'anaya.singh@gmail.com', 'Female', 'Pneumonia'),
(1005, 'Arjun', 'Reddy', '+919765432109', 'B-', 'arjun.reddy@gmail.com', 'Male', 'Asthma'),
(1006, 'Isha', 'Gupta', '+919812345670', 'A-', 'isha.gupta@gmail.com', 'Female', 'Migraine'),
(1007, 'Vihaan', 'Joshi', '+919887766554', 'O-', 'vihaan.joshi@gmail.com', 'Male', 'Appendicitis'),
(1008, 'Myra', 'Kumar', '+919776655443', 'AB-', 'myra.kumar@gmail.com', 'Female', 'Bronchitis'),
(1009, 'Reyansh', 'Yadav', '+919654321098', 'A+', 'reyansh.yadav@gmail.com', 'Male', 'Fever'),
(1010, 'Saanvi', 'Desai', '+919543210987', 'B+', 'saanvi.desai@gmail.com', 'Female', 'UTI');

INSERT INTO Doctor (Doctor_ID, Qualifications, Emp_ID, Specialization) 
VALUES 
(601, 'MD, MBBS', 101, 'Interventional Cardiology'),
(602, 'MS, MBBS', 102, 'Electrophysiology'),
(603, 'MBBS, DNB', 201, 'Epilepsy'),
(604, 'B.Pharm, M.Pharm', 202, 'Stroke and Vascular'),
(605, 'MD, DM', 301, 'Sports Medicine'),
(606, 'MBBS, DCH', 302, 'Spine Surgery'),
(607, 'MD, DVD', 601, 'Neonatology'),
(608, 'MBBS, MS', 602, 'Pediatric Cardiology'),
(609, 'BDS, MDS', 1001, 'Cosmetic Dermatology'),
(610, 'MBBS, DGO', 1002, 'Pediatric Dermatology');

INSERT INTO Nurse (Nurse_ID, Patient_ID, Emp_ID) 
VALUES 
(701, 1001, 1101),
(702, 1002, 1104),
(703, 1003, 1103),
(704, 1004, 1104),
(705, 1005, 1101),
(706, 1006, 1103),
(707, 1007, 1104),
(708, 1008, 1103),
(709, 1009, 1101),
(710, 1010, 1103);

INSERT INTO Emergency_Contact (Contact_ID, Contact_Name, Phone, Relation, Patient_ID) 
VALUES 
(801, 'Rajesh Sharma', '+919887766550', 'Father', 1001),
(802, 'Sunita Patel', '+919776655441', 'Mother', 1002),
(803, 'Vikram Verma', '+919665544332', 'Brother', 1003),
(804, 'Anjali Singh', '+919554433221', 'Sister', 1004),
(805, 'Arjun Reddy', '+919443322110', 'Wife', 1005),
(806, 'Priya Gupta', '+919332211009', 'Husband', 1006),
(807, 'Rohan Joshi', '+919221100998', 'Father', 1007),
(808, 'Isha Kumar', '+919110099887', 'Mother', 1008),
(809, 'Vihaan Yadav', '+919009988776', 'Brother', 1009),
(810, 'Myra Desai', '+919898877665', 'Sister', 1010);

INSERT INTO Payroll (Account_No, Salary, Bonus, Emp_ID) 
VALUES 
('IN001', 120000.00, 15000.00, 101),
('IN002', 110000.00, 10000.00, 102),
('IN003', 90000.00, NULL, 201),
('IN004', 85000.00, 5000.00, 202),
('IN005', 80000.00, NULL, 301),
('IN006', 75000.00, 3600.00, 302),
('IN007', 50000.00, 3200.00, 401),
('IN008', 48000.00, NULL, 402),
('IN009', 35000.00, NULL, 501),
('IN010', 42000.00, NULL, 502),
('IN011', 55000.00, 4200.00, 601),
('IN012', 32000.00, 2600.00, 602),
('IN013', 45000.00, 1000.00, 701),
('IN014', 22000.00, NULL, 703),
('IN015', 25000.00, NULL, 801),
('IN016', 52000.00, NULL, 802),
('IN017', 15000.00, 10000.00, 901),
('IN018', 62000.00, NULL, 902),
('IN019', 95000.00, 6000.00, 1001),
('IN020', 142000.00, NULL, 1002),
('IN021', 10000.00, 2000.00, 1101),
('IN022', 18000.00, NULL, 1103),
('IN023', 15000.00, NULL, 1104);


INSERT INTO Lab_Screening (Lab_ID, Patient_ID, Technician_ID, Doctor_ID, Test_Cost, Date) 
VALUES 
(901, 1001, 301, 610, 1500.00, '2025-05-02'),
(902, 1002, 602, 609, 2000.00, '2025-05-06'),
(903, 1003, 1001, 608, 2500.00, '2025-05-21'),
(904, 1004, 301, 607, 1800.00, '2025-05-11'),
(905, 1005, 1001, 606, 3000.00, '2025-05-13'),
(906, 1006, 602, 601, 2200.00, '2025-05-04'),
(907, 1007, 1001, 602, 2700.00, '2025-05-08'),
(908, 1008, 301, 603, 1900.00, '2025-05-10'),
(909, 1009, 602, 604, 2100.00, '2025-05-15'),
(910, 1010, 602, 605, 2300.00, '2025-05-17');

INSERT INTO Insurance (Policy_Number, Patient_ID, Insurer_IRDAI_Code, Start_Date, End_Date, Provider_Name, Plan_Name, Sum_Insured) 
VALUES 
('POL001', 1001, 'IRDAI00123', '2025-01-01', '2026-01-01', 'Star Health', 'Star Comprehensive', 500000),
('POL004', 1004, 'IRDAI00987', '2025-06-15', '2026-06-01', 'ICICI Lombard', 'Health Shield Plus', 1000000),
('POL005', 1005, 'IRDAI00456', '2024-03-20', '2026-03-19', 'HDFC ERGO', 'Optima Restore', 750000),
('POL006', 1006, 'IRDAI00789', '2025-10-01', '2026-09-30', 'New India Assurance', 'Mediclaim 2025',	300000),
('POL008', 1008, 'IRDAI00234', '2024-01-10', '2026-01-09', 'Max Bupa', 'Health Companion Gold', 1500000);

INSERT INTO Medicine (Medicine_ID, M_Name, M_Quantity, M_Cost) 
VALUES 
(501, 'Paracetamol', 500, 105),
(502, 'Amoxicillin', 300, 457.5),
(503, 'Cetirizine', 200, 150.0),
(504, 'Omeprazole', 150, 258.0),
(505, 'Metformin', 400, 12.30),
(506, 'Aspirin', 600, 89.0),
(507, 'Ibuprofen', 350, 184.0),
(508, 'Losartan', 250, 300.0),
(509, 'Atorvastatin', 180, 40.20),
(510, 'Dolo 650', 700, 5.75);

INSERT INTO Prescription (Prescription_ID, Patient_ID, Medicine_ID, Date, Dosage, Doctor_ID) 
VALUES 
(1001, 1001, 501, '2025-05-02', 2, 601),
(1002, 1002, 502, '2025-05-06', 1, 602),
(1003, 1003, 503, '2025-05-21', 3, 603),
(1004, 1004, 504, '2025-05-11', 6, 604),
(1005, 1005, 505, '2024-11-13', 8, 605),
(1006, 1006, 506, '2025-05-04', 13, 606),
(1007, 1007, 507, '2025-04-08', 9, 607),
(1008, 1008, 508, '2025-04-10', 4, 608),
(1009, 1009, 509, '2025-05-15', 2, 609),
(1010, 1010, 510, '2025-05-17', 1, 610);

INSERT INTO Medical_History (Record_ID, Patient_ID, Allergies, Pre_Conditions) 
VALUES 
(2001, 1001, 'None', 'Hypertension'),
(2002, 1002, 'Penicillin', 'Diabetes'),
(2003, 1003, 'Dust', 'Asthma'),
(2004, 1004, 'Shellfish', 'High Cholesterol'),
(2005, 1005, 'Pollen', 'Arthritis'),
(2006, 1006, 'Sulfa Drugs', 'Migraine'),
(2007, 1007, 'Latex', 'Appendicitis'),
(2008, 1008, 'Peanuts', 'Bronchitis'),
(2009, 1009, 'Eggs', 'Fever'),
(2010, 1010, 'None', 'UTI');

INSERT INTO Appointment (Appt_ID, Date, Day_Of_Week, Doctor_ID, Patient_ID) 
VALUES 
(3001, '2024-10-05', 'Thursday', 601, 1001),
(3002, '2024-10-10', 'Tuesday', 602, 1002),
(3003, '2024-09-25', 'Monday', 603, 1003),
(3004, '2024-10-15', 'Sunday', 604, 1004),
(3011, '2025-04-24', 'Thursday', 604, 1005),
(3012, '2025-04-24', 'Thursday', 604, 1008),
(3013, '2025-04-24', 'Thursday', 604, 1009),
(3005, '2025-05-17', 'Tuesday', 605, 1005),
(3006, '2025-05-08', 'Sunday', 606, 1006),
(3007, '2025-05-12', 'Thursday', 607, 1007),
(3008, '2025-04-14', 'Saturday', 608, 1008),
(3009, '2025-04-19', 'Thursday', 609, 1009),
(3014, '2025-04-24', 'Thursday', 609, 1005),
(3015, '2025-04-24', 'Thursday', 609, 1003),
(3010, '2025-10-21', 'Saturday', 610, 1010);

INSERT INTO Room (Room_ID, Room_Type, Patient_ID, Doctor_ID,Room_Cost) 
VALUES 
(101, 'General', 1001, NULL, 2000.00),
(102, 'ICU', 1002, NULL, 5000.00),
(103, 'Private', 1003, NULL, 3000.00),
(104, 'Semi-Private', 1004, NULL, 2500.00),
(105, 'General', 1005, NULL, 2000.00),
(106, 'ICU', 1006, NULL, 5000.00),
(108, 'Semi-Private', 1008, NULL, 2500.00),
(109, 'General', 1009, NULL, 2000.00);


INSERT INTO Bill (Bill_ID, Date, Room_Cost, Test_Cost, Other_Charges, M_Cost, Total, Patient_ID, Remaining_Balance, Policy_Number) 
VALUES 
(4001, '2025-05-15', 2000.00, 1500.00, 1000.00, 21.00, 4521.00, 1001, 0.00, 'POL001'),
(4002, '2025-05-20', 5000.00, 2000.00, 1500.00, 45.75, 8545.75, 1002, 2000.00, NULL),
(4003, '2024-10-25', 3000.00, 2500.00, 1200.00, 15.00, 6715.00, 1003, 0.00, NULL),
(4004, '2025-04-30', 2500.00, 1800.00, 900.00, 25.80, 5225.80, 1004, 2500.00, 'POL004'),
(4005, '2024-11-05', 2000.00, 3000.00, 1500.00, 12.30, 6512.30, 1005, 0.00, 'POL005'),
(4006, '2025-05-10', 5000.00, 2200.00, 1300.00, 8.90, 8508.90, 1006, 3000.00, 'POL006'),
(4007, '2025-05-15', 3000.00, 2700.00, 1400.00, 18.40, 7118.40, 1007, 0.00, NULL),
(4008, '2025-04-20', 2500.00, 1900.00, 1100.00, 30.00, 5530.00, 1008, 2500.00, 'POL008'),
(4009, '2024-03-25', 2000.00, 2100.00, 1000.00, 40.20, 5140.20, 1009, 0.00, NULL),
(4010, '2024-05-30', 5000.00, 2300.00, 1600.00, 5.75, 8905.75, 1010, 4000.00, NULL);

INSERT INTO Doctor_Schedule (Schedule_ID, Doctor_ID, Day_Of_Week, Start_Time, End_Time, Slot_Duration) 
VALUES 
(1501 , 601, 'Thursday', '09:00:00', '17:00:00', 15),
(1502 , 602, 'Tuesday', '10:00:00', '18:00:00', 10),
(1503 , 603, 'Monday', '08:30:00', '16:30:00', 20),
(1504 , 604, 'Thursday', '11:00:00', '19:00:00', 10),
(1505 , 605, 'Tuesday', '07:00:00', '15:00:00', 15),
(1506 , 606, 'Sunday', '09:30:00', '17:30:00', 20),
(1507 , 607, 'Thursday', '10:00:00', '14:00:00', 15),
(1508 , 608, 'Saturday', '13:00:00', '21:00:00', 20),
(1509 , 609, 'Thursday', '08:00:00', '16:00:00', 10),
(1510 , 610, 'Saturday', '12:00:00', '20:00:00', 15),
(1511 , 604, 'Sunday', '11:00:00', '19:00:00', 10);