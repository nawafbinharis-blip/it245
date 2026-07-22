-- Create the database
CREATE DATABASE SmartClinicDB
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE SmartClinicDB;


-- Superclass table
CREATE TABLE Person (
    Person_ID INT UNSIGNED AUTO_INCREMENT,
    First_Name VARCHAR(50) NOT NULL,
    Last_Name VARCHAR(50) NOT NULL,
    Phone VARCHAR(20) NOT NULL,
    Email VARCHAR(100) NOT NULL,

    CONSTRAINT PK_Person
        PRIMARY KEY (Person_ID),

    CONSTRAINT UQ_Person_Phone
        UNIQUE (Phone),

    CONSTRAINT UQ_Person_Email
        UNIQUE (Email)
);


-- Patient subclass
CREATE TABLE Patients (
    Patient_ID INT UNSIGNED,
    Date_of_Birth DATE NOT NULL,
    Gender ENUM('Male', 'Female') NOT NULL,
    Address VARCHAR(255),
    Registration_Date DATE NOT NULL DEFAULT (CURRENT_DATE),

    CONSTRAINT PK_Patients
        PRIMARY KEY (Patient_ID),

    CONSTRAINT FK_Patient_Person
        FOREIGN KEY (Patient_ID)
        REFERENCES Person(Person_ID)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);


-- Doctor subclass
CREATE TABLE Doctors (
    Doctor_ID INT UNSIGNED,
    Specialization VARCHAR(100) NOT NULL,
    License_Number VARCHAR(50) NOT NULL,

    CONSTRAINT PK_Doctors
        PRIMARY KEY (Doctor_ID),

    CONSTRAINT UQ_Doctor_License
        UNIQUE (License_Number),

    CONSTRAINT FK_Doctor_Person
        FOREIGN KEY (Doctor_ID)
        REFERENCES Person(Person_ID)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);


-- Appointment table
CREATE TABLE Appointments (
    Appointment_ID INT UNSIGNED AUTO_INCREMENT,
    Patient_ID INT UNSIGNED NOT NULL,
    Doctor_ID INT UNSIGNED NOT NULL,
    Appointment_Date DATE NOT NULL,
    Appointment_Time TIME NOT NULL,
    Reason VARCHAR(255),
    Status ENUM(
        'Scheduled',
        'Completed',
        'Cancelled',
        'No Show'
    ) NOT NULL DEFAULT 'Scheduled',
    Notes TEXT,

    CONSTRAINT PK_Appointments
        PRIMARY KEY (Appointment_ID),

    CONSTRAINT FK_Appointment_Patient
        FOREIGN KEY (Patient_ID)
        REFERENCES Patients(Patient_ID)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT FK_Appointment_Doctor
        FOREIGN KEY (Doctor_ID)
        REFERENCES Doctors(Doctor_ID)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT UQ_Doctor_Appointment_Time
        UNIQUE (
            Doctor_ID,
            Appointment_Date,
            Appointment_Time
        )
);


-- Medicine table
CREATE TABLE Medicines (
    Medicine_ID INT UNSIGNED AUTO_INCREMENT,
    Medicine_Name VARCHAR(100) NOT NULL,
    Description VARCHAR(255),
    Unit_Price DECIMAL(10,2) NOT NULL,
    Stock_Quantity INT UNSIGNED NOT NULL DEFAULT 0,
    Expiry_Date DATE,

    CONSTRAINT PK_Medicines
        PRIMARY KEY (Medicine_ID),

    CONSTRAINT UQ_Medicine_Name
        UNIQUE (Medicine_Name),

    CONSTRAINT CHK_Medicine_Price
        CHECK (Unit_Price >= 0)
);


-- Treatment table
CREATE TABLE Treatments (
    Treatment_ID INT UNSIGNED AUTO_INCREMENT,
    Appointment_ID INT UNSIGNED NOT NULL,
    Medicine_ID INT UNSIGNED,
    Treatment_Name VARCHAR(100) NOT NULL,
    Diagnosis VARCHAR(255) NOT NULL,
    Dosage VARCHAR(100),
    Duration_Days INT UNSIGNED,
    Instructions TEXT,
    Treatment_Cost DECIMAL(10,2) NOT NULL DEFAULT 0.00,

    CONSTRAINT PK_Treatments
        PRIMARY KEY (Treatment_ID),

    CONSTRAINT FK_Treatment_Appointment
        FOREIGN KEY (Appointment_ID)
        REFERENCES Appointments(Appointment_ID)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT FK_Treatment_Medicine
        FOREIGN KEY (Medicine_ID)
        REFERENCES Medicines(Medicine_ID)
        ON UPDATE CASCADE
        ON DELETE SET NULL,

    CONSTRAINT CHK_Treatment_Duration
        CHECK (
            Duration_Days IS NULL
            OR Duration_Days > 0
        ),

    CONSTRAINT CHK_Treatment_Cost
        CHECK (Treatment_Cost >= 0)
);


-- Payment table
CREATE TABLE Payments (
    Payment_ID INT UNSIGNED AUTO_INCREMENT,
    Appointment_ID INT UNSIGNED NOT NULL,
    Payment_Date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    Amount DECIMAL(10,2) NOT NULL,
    Payment_Method ENUM(
        'Cash',
        'Credit Card',
        'Debit Card',
        'Bank Transfer',
        'Insurance'
    ) NOT NULL,
    Payment_Status ENUM(
        'Pending',
        'Paid',
        'Failed',
        'Refunded'
    ) NOT NULL DEFAULT 'Pending',
    Reference_Number VARCHAR(100),

    CONSTRAINT PK_Payments
        PRIMARY KEY (Payment_ID),

    CONSTRAINT UQ_Payment_Reference
        UNIQUE (Reference_Number),

    CONSTRAINT FK_Payment_Appointment
        FOREIGN KEY (Appointment_ID)
        REFERENCES Appointments(Appointment_ID)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT CHK_Payment_Amount
        CHECK (Amount > 0)
);



-- ******************************
-- ******************************

USE SmartClinicDB;

-- 1. PERSON

INSERT INTO Person
    (Person_ID, First_Name, Last_Name, Phone, Email)
VALUES
    (1, 'Ahmed',   'Al-Qahtani',  '0501234501', 'ahmed.qahtani@example.sa'),
    (2, 'Noura',   'Al-Harbi',    '0501234502', 'noura.harbi@example.sa'),
    (3, 'Khalid',  'Al-Otaibi',   '0501234503', 'khalid.otaibi@example.sa'),
    (4, 'Sara',    'Al-Dosari',   '0501234504', 'sara.dosari@example.sa'),
    (5, 'Fahad',   'Al-Shammari', '0501234505', 'fahad.shammari@example.sa'),
    (6, 'Reem',    'Al-Zahrani',  '0501234506', 'reem.zahrani@example.sa'),
    (7, 'Abdullah','Al-Ghamdi',   '0501234507', 'abdullah.ghamdi@example.sa'),

    (8,  'Mohammed', 'Al-Shehri', '0552345601', 'm.shehri@smartclinic.sa'),
    (9,  'Maha',     'Al-Anazi',  '0552345602', 'maha.anazi@smartclinic.sa'),
    (10, 'Saad',     'Al-Mutairi','0552345603', 'saad.mutairi@smartclinic.sa'),
    (11, 'Lama',     'Al-Rashid', '0552345604', 'lama.rashid@smartclinic.sa'),
    (12, 'Yousef',   'Al-Salem',  '0552345605', 'yousef.salem@smartclinic.sa'),
    (13, 'Hanan',    'Al-Yami',   '0552345606', 'hanan.yami@smartclinic.sa'),
    (14, 'Omar',     'Al-Amri',   '0552345607', 'omar.amri@smartclinic.sa');


-- 2. PATIENTS

INSERT INTO Patients
    (Patient_ID, Date_of_Birth, Gender, Address, Registration_Date)
VALUES
    (1, '1992-04-15', 'Male',
     'Al-Narjis District, Riyadh', '2026-01-10'),

    (2, '1988-09-22', 'Female',
     'Al-Safa District, Jeddah', '2026-01-12'),

    (3, '2001-02-08', 'Male',
     'Al-Faisaliyah District, Dammam', '2026-01-15'),

    (4, '1996-11-19', 'Female',
     'Qurban District, Madinah', '2026-01-20'),

    (5, '1983-07-03', 'Male',
     'Al-Shawqiyah District, Makkah', '2026-02-02'),

    (6, '1999-05-27', 'Female',
     'Al-Rawdah District, Abha', '2026-02-05'),

    (7, '1975-12-14', 'Male',
     'Al-Khalidiyah District, Al Khobar', '2026-02-09');


-- 3. DOCTORS

INSERT INTO Doctors
    (Doctor_ID, Specialization, License_Number)
VALUES
    (8,  'General Medicine',  'SCFHS-GM-10081'),
    (9,  'Pediatrics',        'SCFHS-PD-10082'),
    (10, 'Cardiology',        'SCFHS-CD-10083'),
    (11, 'Dermatology',       'SCFHS-DM-10084'),
    (12, 'Orthopedics',       'SCFHS-OR-10085'),
    (13, 'Obstetrics and Gynecology', 'SCFHS-OG-10086'),
    (14, 'Internal Medicine', 'SCFHS-IM-10087');


-- 4. APPOINTMENTS


INSERT INTO Appointments
    (
        Appointment_ID,
        Patient_ID,
        Doctor_ID,
        Appointment_Date,
        Appointment_Time,
        Reason,
        Status,
        Notes
    )
VALUES
    (
        1, 1, 8, '2026-03-01', '09:00:00',
        'Fever and sore throat',
        'Completed',
        'Patient was examined and advised to rest.'
    ),
    (
        2, 2, 10, '2026-03-01', '10:30:00',
        'Chest discomfort',
        'Completed',
        'Blood pressure and heart rate were checked.'
    ),
    (
        3, 3, 11, '2026-03-02', '11:00:00',
        'Skin irritation',
        'Completed',
        'Mild allergic skin reaction was observed.'
    ),
    (
        4, 4, 13, '2026-03-03', '12:30:00',
        'Routine health examination',
        'Completed',
        'Routine examination completed.'
    ),
    (
        5, 5, 12, '2026-03-04', '14:00:00',
        'Knee pain',
        'Completed',
        'Pain increased during movement.'
    ),
    (
        6, 6, 9, '2026-03-05', '16:00:00',
        'Child vaccination consultation',
        'Scheduled',
        'Vaccination record should be brought to the visit.'
    ),
    (
        7, 7, 14, '2026-03-06', '17:30:00',
        'Diabetes follow-up',
        'Scheduled',
        'Patient should bring recent laboratory results.'
    );


-- 5. MEDICINES

INSERT INTO Medicines
    (
        Medicine_ID,
        Medicine_Name,
        Description,
        Unit_Price,
        Stock_Quantity,
        Expiry_Date
    )
VALUES
    (
        1, 'Paracetamol 500 mg',
        'Tablets used to reduce pain and fever',
        12.50, 150, '2028-01-31'
    ),
    (
        2, 'Amoxicillin 500 mg',
        'Antibiotic capsules',
        28.00, 80, '2027-09-30'
    ),
    (
        3, 'Cetirizine 10 mg',
        'Antihistamine tablets for allergy symptoms',
        18.75, 100, '2028-03-31'
    ),
    (
        4, 'Hydrocortisone Cream 1%',
        'Topical cream for mild skin inflammation',
        16.00, 65, '2027-12-31'
    ),
    (
        5, 'Diclofenac Gel',
        'Topical pain-relief gel for muscles and joints',
        24.50, 70, '2028-02-28'
    ),
    (
        6, 'Metformin 500 mg',
        'Oral medicine used in diabetes management',
        21.00, 120, '2028-05-31'
    ),
    (
        7, 'Vitamin D3 1000 IU',
        'Vitamin D supplement tablets',
        30.00, 90, '2028-06-30'
    );


-- 6. TREATMENTS

INSERT INTO Treatments
    (
        Treatment_ID,
        Appointment_ID,
        Medicine_ID,
        Treatment_Name,
        Diagnosis,
        Dosage,
        Duration_Days,
        Instructions,
        Treatment_Cost
    )
VALUES
    (
        1, 1, 1,
        'Fever Management',
        'Upper respiratory infection',
        'One tablet every eight hours when needed',
        5,
        'Drink sufficient fluids and return if symptoms worsen.',
        120.00
    ),
    (
        2, 2, NULL,
        'Cardiac Assessment',
        'Chest discomfort requiring further assessment',
        NULL,
        NULL,
        'Complete the requested ECG and laboratory tests.',
        350.00
    ),
    (
        3, 3, 4,
        'Skin Allergy Treatment',
        'Mild contact dermatitis',
        'Apply a thin layer twice daily',
        7,
        'Avoid contact with the suspected irritant.',
        180.00
    ),
    (
        4, 4, 7,
        'Preventive Care',
        'Vitamin D insufficiency suspected',
        'One tablet daily',
        30,
        'Take the supplement after a meal.',
        200.00
    ),
    (
        5, 5, 5,
        'Knee Pain Management',
        'Mild knee inflammation',
        'Apply to the affected area three times daily',
        10,
        'Reduce strenuous activity and follow exercise advice.',
        250.00
    ),
    (
        6, 6, NULL,
        'Vaccination Consultation',
        'Vaccination status review',
        NULL,
        NULL,
        'Bring the child vaccination record to the next visit.',
        100.00
    ),
    (
        7, 7, 6,
        'Diabetes Follow-up',
        'Type 2 diabetes mellitus',
        'One tablet twice daily with meals',
        30,
        'Monitor blood glucose and follow the dietary plan.',
        300.00
    );


-- 7. PAYMENTS


INSERT INTO Payments
    (
        Payment_ID,
        Appointment_ID,
        Payment_Date,
        Amount,
        Payment_Method,
        Payment_Status,
        Reference_Number
    )
VALUES
    (
        1, 1, '2026-03-01 09:45:00',
        120.00, 'Cash', 'Paid', 'PAY-SA-2026-0001'
    ),
    (
        2, 2, '2026-03-01 11:20:00',
        350.00, 'Credit Card', 'Paid', 'PAY-SA-2026-0002'
    ),
    (
        3, 3, '2026-03-02 11:40:00',
        180.00, 'Debit Card', 'Paid', 'PAY-SA-2026-0003'
    ),
    (
        4, 4, '2026-03-03 13:15:00',
        200.00, 'Insurance', 'Paid', 'PAY-SA-2026-0004'
    ),
    (
        5, 5, '2026-03-04 14:50:00',
        250.00, 'Bank Transfer', 'Paid', 'PAY-SA-2026-0005'
    ),
    (
        6, 6, '2026-03-05 15:30:00',
        100.00, 'Credit Card', 'Pending', 'PAY-SA-2026-0006'
    ),
    (
        7, 7, '2026-03-06 17:00:00',
        300.00, 'Insurance', 'Pending', 'PAY-SA-2026-0007'
    );


-- ******************************
-- ******************************

SELECT
    Appointment_ID,
    Patient_ID,
    Doctor_ID,
    Appointment_Date,
    Appointment_Time,
    Reason
FROM Appointments
WHERE Status = 'Scheduled'
ORDER BY Appointment_Date, Appointment_Time;

SELECT
    Medicine_ID,
    Medicine_Name,
    Stock_Quantity,
    Expiry_Date
FROM Medicines
WHERE Stock_Quantity < 100
ORDER BY Stock_Quantity ASC;

SELECT
    A.Appointment_ID,
    CONCAT(PP.First_Name, ' ', PP.Last_Name) AS Patient_Name,
    CONCAT(DP.First_Name, ' ', DP.Last_Name) AS Doctor_Name,
    D.Specialization,
    A.Appointment_Date,
    A.Appointment_Time,
    A.Status
FROM Appointments AS A
JOIN Patients AS PT
    ON A.Patient_ID = PT.Patient_ID
JOIN Person AS PP
    ON PT.Patient_ID = PP.Person_ID
JOIN Doctors AS D
    ON A.Doctor_ID = D.Doctor_ID
JOIN Person AS DP
    ON D.Doctor_ID = DP.Person_ID
ORDER BY A.Appointment_Date, A.Appointment_Time;

SELECT
    T.Treatment_ID,
    T.Appointment_ID,
    T.Treatment_Name,
    T.Diagnosis,
    M.Medicine_Name,
    T.Dosage,
    T.Duration_Days,
    T.Treatment_Cost
FROM Treatments AS T
LEFT JOIN Medicines AS M
    ON T.Medicine_ID = M.Medicine_ID
ORDER BY T.Treatment_ID;

SELECT
    Treatment_ID,
    Treatment_Name,
    Diagnosis,
    Treatment_Cost
FROM Treatments
WHERE Treatment_Cost > (
    SELECT AVG(Treatment_Cost)
    FROM Treatments
)
ORDER BY Treatment_Cost DESC;


SELECT
    P.Person_ID AS Patient_ID,
    P.First_Name,
    P.Last_Name,
    P.Phone,
    P.Email
FROM Person AS P
WHERE P.Person_ID IN (
    SELECT A.Patient_ID
    FROM Appointments AS A
    WHERE A.Status = 'Completed'
);

SELECT
    D.Doctor_ID,
    CONCAT(P.First_Name, ' ', P.Last_Name) AS Doctor_Name,
    D.Specialization,
    COUNT(A.Appointment_ID) AS Total_Appointments
FROM Doctors AS D
JOIN Person AS P
    ON D.Doctor_ID = P.Person_ID
LEFT JOIN Appointments AS A
    ON D.Doctor_ID = A.Doctor_ID
GROUP BY
    D.Doctor_ID,
    P.First_Name,
    P.Last_Name,
    D.Specialization
ORDER BY Total_Appointments DESC;

SELECT
    Payment_Method,
    COUNT(*) AS Number_of_Payments,
    SUM(Amount) AS Total_Amount,
    AVG(Amount) AS Average_Amount
FROM Payments
WHERE Payment_Status = 'Paid'
GROUP BY Payment_Method
ORDER BY Total_Amount DESC;

UPDATE Appointments
SET
    Status = 'Completed',
    Notes = 'Vaccination consultation completed successfully.'
WHERE Appointment_ID = 6;


DELETE FROM Payments
WHERE Payment_Status = 'Pending';

CREATE OR REPLACE VIEW Appointment_Details AS
SELECT
    A.Appointment_ID,
    A.Patient_ID,
    CONCAT(PP.First_Name, ' ', PP.Last_Name) AS Patient_Name,
    A.Doctor_ID,
    CONCAT(DP.First_Name, ' ', DP.Last_Name) AS Doctor_Name,
    D.Specialization,
    A.Appointment_Date,
    A.Appointment_Time,
    A.Reason,
    A.Status,
    A.Notes
FROM Appointments AS A
JOIN Patients AS PT
    ON A.Patient_ID = PT.Patient_ID
JOIN Person AS PP
    ON PT.Patient_ID = PP.Person_ID
JOIN Doctors AS D
    ON A.Doctor_ID = D.Doctor_ID
JOIN Person AS DP
    ON D.Doctor_ID = DP.Person_ID;


SELECT *
FROM Appointment_Details
ORDER BY Appointment_Date, Appointment_Time;


CREATE TABLE Treatment_Audit (
    Audit_ID INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    Treatment_ID INT UNSIGNED NOT NULL,
    Appointment_ID INT UNSIGNED NOT NULL,
    Action_Type VARCHAR(20) NOT NULL,
    Action_Date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT FK_Audit_Treatment
        FOREIGN KEY (Treatment_ID)
        REFERENCES Treatments(Treatment_ID)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);


INSERT INTO Treatments (
    Appointment_ID,
    Medicine_ID,
    Treatment_Name,
    Diagnosis,
    Dosage,
    Duration_Days,
    Instructions,
    Treatment_Cost
)
VALUES (
    1,
    3,
    'Allergy Symptom Management',
    'Seasonal allergy',
    'One tablet daily',
    7,
    'Take the medicine in the evening.',
    75.00
);


SELECT *
FROM Treatment_Audit
ORDER BY Action_Date DESC;


DELIMITER //

CREATE TRIGGER TRG_After_Treatment_Insert
AFTER INSERT ON Treatments
FOR EACH ROW
BEGIN
    INSERT INTO Treatment_Audit (
        Treatment_ID,
        Appointment_ID,
        Action_Type,
        Action_Date
    )
    VALUES (
        NEW.Treatment_ID,
        NEW.Appointment_ID,
        'INSERT',
        CURRENT_TIMESTAMP
    );
END//

DELIMITER ;












