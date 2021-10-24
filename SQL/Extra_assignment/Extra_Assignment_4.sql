-- Exercise 1:
-- Cho table sau:
-- Department (Department_Number, Department_Name)
-- Employee_Table (Employee_Number, Employee_Name,Department_Number)
-- Employee_Skill_Table (Employee_Number, Skill_Code, Date Registered)

-- Question 1: Tạo table với các ràng buộc và kiểu dữ liệu
-- Question 2: Thêm ít nhất 10 bản ghi vào table
DROP DATABASE IF EXISTS employee;
CREATE DATABASE employee;
USE employee;

ALTER DATABASE employee CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

DROP TABLE IF EXISTS department_employee;
CREATE TABLE department(
	Department_Number	TINYINT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    Department_Name		VARCHAR(50) UNIQUE KEY NOT NULL
);
INSERT INTO department(Department_Name)
VALUES		(N'Nhân sự'),
			(N'Hành chính'),
            (N'Marketing'),
            (N'Sale'),
            (N'Lễ tân'),
            (N'Chăm sóc kh'),
            (N'Bảo vệ'),
            (N'Pttt'),
            (N'Giám đốc'),
            (N'HDQT');
            		
DROP TABLE IF EXISTS Employee_Table;
CREATE TABLE Employee_Table(
	Employee_Number		MEDIUMINT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    Employee_Name		VARCHAR(50) CHAR SET utf8mb4 NOT NULL,
    Department_Number	TINYINT,
    FOREIGN KEY (Department_Number) REFERENCES department(Department_Number)
);
INSERT INTO Employee_Table(Employee_Name,Department_Number)
VALUES		(N'nguyen van a',1),
			(N'nguyen van b',1),
            (N'nguyen van c',1),
            (N'nguyen van d',4),
            (N'nguyen van e',5),
            (N'tran van a',1),
            (N'tran van b',6),
            (N'tran van c',7),
            (N'tran van d',8),
            (N'tran van e',9);
            
DROP TABLE IF EXISTS Employee_Skill_Table;
CREATE TABLE Employee_Skill_Table(
	Employee_Number		MEDIUMINT NOT NULL,
    Skill_Code			VARCHAR(10) NOT NULL,
    Date_Registered		DATE NOT NULL,
    FOREIGN KEY (Employee_Number) REFERENCES Employee_Table(Employee_Number)
);
INSERT INTO Employee_Skill_Table(Employee_Number,Skill_Code,Date_Registered)
VALUES		(1,N'Java','2015-01-01'),
			(1,N'Sql','2016-01-01'),
            (2,N'Web','2015-02-01'),
            (3,N'Java','2017-01-01'),
            (4,N'Java','2018-01-01'),
            (5,N'Sql','2015-01-01'),
            (5,N'Web','2016-01-01'),
            (5,N'Java','2017-01-01'),
            (7,N'Sql','2019-01-01'),
            (8,N'Web','2019-01-01');

-- Question 3: Viết lệnh để lấy ra danh sách nhân viên (name) có skill Java Hướng dẫn: sử dụng UNION
SELECT Employee_Name
FROM employee_table et
JOIN employee_skill_table est ON et.Employee_Number = est.Employee_Number
WHERE Skill_Code = 'Java';

-- Question 4: Viết lệnh để lấy ra danh sách các phòng ban có >3 nhân viên
SELECT d.Department_Number,Department_Name,count(Employee_Number)
FROM department d
JOIN employee_table et ON d.Department_Number = et.Department_Number
GROUP BY d.Department_Number
HAVING count(Employee_Number) > 3;

-- Question 5: Viết lệnh để lấy ra danh sách nhân viên của mỗi văn phòng ban. Hướng dẫn: sử dụng GROUP BY
SELECT Department_Name,GROUP_CONCAT(Employee_Name)
FROM employee_table et
JOIN department d ON et.Department_Number = d.Department_Number
GROUP BY et.Department_Number;

-- Question 6: Viết lệnh để lấy ra danh sách nhân viên có > 1 skills. Hướng dẫn: sử dụng DISTINCT
SELECT Employee_Name,COUNT(Skill_Code),GROUP_CONCAT(Skill_Code)
FROM employee_table et
JOIN employee_skill_table est ON et.Employee_Number = est.Employee_Number
GROUP BY et.Employee_Number
HAVING COUNT(Skill_Code) > 1;
