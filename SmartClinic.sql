DROP DATABASE IF EXISTS SmartClinic;
CREATE DATABASE SmartClinic;
USE SmartClinic;

-- =========================================
-- TASK 2: DATABASE IMPLEMENTATION
-- =========================================

CREATE TABLE Person (
    person_id INT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    phone VARCHAR(15) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE Patient (
    person_id INT PRIMARY KEY,
    date_of_birth DATE NOT NULL,
    gender VARCHAR(10) NOT NULL,
    blood_type VARCHAR(5) NOT NULL,
    FOREIGN KEY (person_id) REFERENCES Person(person_id)
);

CREATE TABLE Doctor (
    person_id INT PRIMARY KEY,
    specialization VARCHAR(100) NOT NULL,
    license_number VARCHAR(30) NOT NULL UNIQUE,
    FOREIGN KEY (person_id) REFERENCES Person(person_id)
);

CREATE TABLE Appointment (
    appointment_id INT PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    appointment_date DATE NOT NULL,
    appointment_time TIME NOT NULL,
    status VARCHAR(20) NOT NULL,
    reason VARCHAR(200) NOT NULL,
    FOREIGN KEY (patient_id) REFERENCES Patient(person_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctor(person_id)
);

CREATE TABLE Treatment (
    treatment_id INT PRIMARY KEY,
    appointment_id INT NOT NULL,
    diagnosis VARCHAR(200) NOT NULL,
    treatment_description VARCHAR(200) NOT NULL,
    treatment_date DATE NOT NULL,
    FOREIGN KEY (appointment_id) REFERENCES Appointment(appointment_id)
);

CREATE TABLE Payment (
    payment_id INT PRIMARY KEY,
    appointment_id INT NOT NULL UNIQUE,
    amount DECIMAL(10,2) NOT NULL,
    payment_date DATE NOT NULL,
    payment_method VARCHAR(30) NOT NULL,
    payment_status VARCHAR(20) NOT NULL,
    FOREIGN KEY (appointment_id) REFERENCES Appointment(appointment_id)
);

INSERT INTO Person VALUES
(1, 'Ahmed Ali', '0500000001', 'ahmed@email.com'),
(2, 'Sara Mohammed', '0500000002', 'sara@email.com'),
(3, 'Khalid Omar', '0500000003', 'khalid@email.com'),
(4, 'Noura Saleh', '0500000004', 'noura@email.com'),
(5, 'Faisal Hassan', '0500000005', 'faisal@email.com'),
(6, 'Abdullah Saad', '0500000006', 'abdullah@email.com'),
(7, 'Reem Fahad', '0500000007', 'reem@email.com'),
(8, 'Mohammed Nasser', '0500000008', 'mohammed@email.com'),
(9, 'Huda Ibrahim', '0500000009', 'huda@email.com'),
(10, 'Yasser Majed', '0500000010', 'yasser@email.com');

INSERT INTO Patient VALUES
(1, '2000-05-15', 'Male', 'A+'),
(2, '1998-09-20', 'Female', 'B+'),
(3, '2002-01-10', 'Male', 'O+'),
(4, '1995-07-25', 'Female', 'AB+'),
(5, '2001-12-05', 'Male', 'A-');

INSERT INTO Doctor VALUES
(6, 'General Medicine', 'DOC1001'),
(7, 'Cardiology', 'DOC1002'),
(8, 'Dermatology', 'DOC1003'),
(9, 'Pediatrics', 'DOC1004'),
(10, 'Orthopedics', 'DOC1005');

INSERT INTO Appointment VALUES
(1, 1, 6, '2026-08-15', '09:00:00', 'Completed', 'General checkup'),
(2, 2, 7, '2026-08-16', '10:00:00', 'Completed', 'Chest pain'),
(3, 3, 8, '2026-08-17', '11:00:00', 'Completed', 'Skin allergy'),
(4, 4, 9, '2026-08-18', '12:00:00', 'Scheduled', 'Regular checkup'),
(5, 5, 10, '2026-08-19', '13:00:00', 'Scheduled', 'Knee pain');

INSERT INTO Treatment VALUES
(1, 1, 'Common cold', 'Rest and medication', '2026-08-15'),
(2, 2, 'Muscle pain', 'Pain relief medication', '2026-08-16'),
(3, 3, 'Skin allergy', 'Allergy cream', '2026-08-17'),
(4, 4, 'Normal condition', 'Regular follow-up', '2026-08-18'),
(5, 5, 'Knee inflammation', 'Rest and physical therapy', '2026-08-19');

INSERT INTO Payment VALUES
(1, 1, 150.00, '2026-08-15', 'Cash', 'Paid'),
(2, 2, 300.00, '2026-08-16', 'Card', 'Paid'),
(3, 3, 200.00, '2026-08-17', 'Card', 'Paid'),
(4, 4, 100.00, '2026-08-18', 'Cash', 'Paid'),
(5, 5, 250.00, '2026-08-19', 'Card', 'Paid');

SHOW TABLES;

SELECT * FROM Person;
SELECT * FROM Patient;
SELECT * FROM Doctor;
SELECT * FROM Appointment;
SELECT * FROM Treatment;
SELECT * FROM Payment;

-- =========================================
-- TASK 3: SQL OPERATIONS
-- =========================================

-- 1. SELECT STATEMENTS

SELECT appointment_id, appointment_date, appointment_time, status
FROM Appointment
WHERE status = 'Scheduled';

SELECT payment_id, amount, payment_method, payment_status
FROM Payment
WHERE amount >= 200;

-- 2. JOIN QUERY

SELECT
    a.appointment_id,
    patient.full_name AS patient_name,
    doctor.full_name AS doctor_name,
    a.appointment_date,
    a.appointment_time,
    a.status
FROM Appointment AS a
JOIN Person AS patient
    ON a.patient_id = patient.person_id
JOIN Person AS doctor
    ON a.doctor_id = doctor.person_id;

-- 3. NESTED QUERY

SELECT person_id, full_name
FROM Person
WHERE person_id IN (
    SELECT patient_id
    FROM Appointment
    WHERE status = 'Scheduled'
);

-- 4. AGGREGATE FUNCTIONS WITH GROUP BY

SELECT
    payment_method,
    COUNT(*) AS total_payments,
    SUM(amount) AS total_amount
FROM Payment
GROUP BY payment_method;

-- 5. UPDATE AND DELETE STATEMENTS

UPDATE Appointment
SET status = 'Completed'
WHERE appointment_id = 4;

SELECT * FROM Appointment
WHERE appointment_id = 4;

DELETE FROM Payment
WHERE payment_id = 5;

SELECT * FROM Payment;

-- Restore the deleted record
INSERT INTO Payment VALUES
(5, 5, 250.00, '2026-08-19', 'Card', 'Paid');

-- 6. CREATE ONE VIEW

CREATE VIEW AppointmentDetails AS
SELECT
    a.appointment_id,
    patient.full_name AS patient_name,
    doctor.full_name AS doctor_name,
    a.appointment_date,
    a.appointment_time,
    a.status
FROM Appointment AS a
JOIN Person AS patient
    ON a.patient_id = patient.person_id
JOIN Person AS doctor
    ON a.doctor_id = doctor.person_id;

SELECT * FROM AppointmentDetails;

-- 7. CREATE ONE TRIGGER

CREATE TRIGGER SetAppointmentStatus
BEFORE INSERT ON Appointment
FOR EACH ROW
SET NEW.status = 'Scheduled';

INSERT INTO Appointment VALUES
(6, 1, 6, '2026-08-20', '14:00:00', 'Pending', 'Follow-up');

SELECT * FROM Appointment
WHERE appointment_id = 6;