CREATE DATABASE IF NOT EXISTS attendance_db;
USE attendance_db;

-- 1. Students Table
CREATE TABLE students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    roll_number VARCHAR(20) UNIQUE NOT NULL,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(100) NOT NULL,
    semester INT NOT NULL
);

-- 2. Professors Table
CREATE TABLE professors (
    professor_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id VARCHAR(20) UNIQUE NOT NULL,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(100) NOT NULL,
    department VARCHAR(50) NOT NULL
);

-- 3. Subjects Table
CREATE TABLE subjects (
    subject_id INT AUTO_INCREMENT PRIMARY KEY,
    subject_code VARCHAR(20) UNIQUE NOT NULL,
    subject_name VARCHAR(100) NOT NULL,
    professor_id INT,
    FOREIGN KEY (professor_id) REFERENCES professors(professor_id) ON DELETE SET NULL
);

-- 4. Attendance Records Table
CREATE TABLE attendance (
    attendance_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    subject_id INT NOT NULL,
    attendance_date DATE NOT NULL,
    status VARCHAR(10) NOT NULL CHECK (status IN ('PRESENT', 'ABSENT')),
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,
    FOREIGN KEY (subject_id) REFERENCES subjects(subject_id) ON DELETE CASCADE,
    -- Prevents marking attendance twice for the same student, subject, and date
    UNIQUE KEY unique_daily_attendance (student_id, subject_id, attendance_date)
);
CREATE DATABASE IF NOT EXISTS attendance_db;
USE attendance_db;

-- Drop existing tables if re-running the script
DROP TABLE IF EXISTS attendance;
DROP TABLE IF EXISTS subjects;
DROP TABLE IF EXISTS professors;
DROP TABLE IF EXISTS students;

-- 1. Students Table
CREATE TABLE students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    roll_number VARCHAR(20) UNIQUE NOT NULL,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(100) NOT NULL,
    semester INT NOT NULL
);

-- 2. Professors Table
CREATE TABLE professors (
    professor_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id VARCHAR(20) UNIQUE NOT NULL,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(100) NOT NULL,
    department VARCHAR(50) NOT NULL
);

-- 3. Subjects Table
CREATE TABLE subjects (
    subject_id INT AUTO_INCREMENT PRIMARY KEY,
    subject_code VARCHAR(20) UNIQUE NOT NULL,
    subject_name VARCHAR(100) NOT NULL,
    professor_id INT,
    FOREIGN KEY (professor_id) REFERENCES professors(professor_id) ON DELETE SET NULL
);

-- 4. Attendance Table
CREATE TABLE attendance (
    attendance_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    subject_id INT NOT NULL,
    attendance_date DATE NOT NULL,
    status VARCHAR(10) NOT NULL CHECK (status IN ('PRESENT', 'ABSENT')),
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,
    FOREIGN KEY (subject_id) REFERENCES subjects(subject_id) ON DELETE CASCADE,
    UNIQUE KEY unique_daily_attendance (student_id, subject_id, attendance_date)
);

-- ==========================================
-- INSERT SAMPLE SEED DATA FOR TESTING & VIVA
-- ==========================================

-- Demo Professor Login: sharma@college.edu / pass123
INSERT INTO professors (employee_id, name, email, password, department) VALUES
('EMP001', 'Dr. Rajesh Sharma', 'sharma@college.edu', 'pass123', 'Computer Engineering');

-- Demo Student Login: hamza@college.edu / pass123
INSERT INTO students (roll_number, name, email, password, semester) VALUES
('CS202501', 'Hamza Khan', 'hamza@college.edu', 'pass123', 4),
('CS202502', 'Aarav Mehta', 'aarav@college.edu', 'pass123', 4),
('CS202503', 'Priya Nair', 'priya@college.edu', 'pass123', 4);

-- Demo Subjects
INSERT INTO subjects (subject_code, subject_name, professor_id) VALUES
('CS401', 'Object Oriented Programming with Java', 1),
('CS402', 'Database Management Systems', 1),
('CS403', 'Operating Systems', 1);

-- Demo Attendance for Student 1 (Hamza Khan):
-- Subject 1 (CS401): 4/4 Present = 100% (GREEN BADGE)
INSERT INTO attendance (student_id, subject_id, attendance_date, status) VALUES
(1, 1, '2026-10-01', 'PRESENT'),
(1, 1, '2026-10-02', 'PRESENT'),
(1, 1, '2026-10-03', 'PRESENT'),
(1, 1, '2026-10-04', 'PRESENT');

-- Subject 2 (CS402): 2/3 Present = 66.67% (YELLOW BADGE)
INSERT INTO attendance (student_id, subject_id, attendance_date, status) VALUES
(1, 2, '2026-10-01', 'PRESENT'),
(1, 2, '2026-10-02', 'PRESENT'),
(1, 2, '2026-10-03', 'ABSENT');

-- Subject 3 (CS403): 1/3 Present = 33.33% (RED BADGE)
INSERT INTO attendance (student_id, subject_id, attendance_date, status) VALUES
(1, 3, '2026-10-01', 'PRESENT'),
(1, 3, '2026-10-02', 'ABSENT'),
(1, 3, '2026-10-03', 'ABSENT');