DROP DATABASE IF EXISTS testing_system;
CREATE DATABASE IF NOT EXISTS testing_system;
USE testing_system;

ALTER DATABASE testing_system CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- create table 1: department
DROP TABLE IF EXISTS department;
CREATE TABLE department(
	department_id		TINYINT AUTO_INCREMENT PRIMARY KEY,
	department_name		VARCHAR(50) CHAR SET utf8mb4 NOT NULL
);
INSERT INTO department(department_id,department_name)
VALUES	(1,	N'marketing'),
		(2,	N'sales'),
		(3,	N'Bảo vệ'),
		(4,	N'nhân sự'),
		(5,	N'kỹ thuật'),
		(6,	N'tài chính'),
		(7,	N'phó giám đốc'),
		(8,	N'giám đốc'),
		(9,	N'thư ký'),
		(10,N'bán hàng');
        
  -- create table 2: position                  
DROP TABLE IF EXISTS `position`;
CREATE TABLE `position`(
	position_id		TINYINT AUTO_INCREMENT PRIMARY KEY,
	position_name	ENUM('dev','test','scrum master','pm')
);

INSERT INTO `position`(position_name)
VALUES  (N'dev'),
		(N'test'),
        (N'scrum master'),
        (N'pm');
        
-- create table 3: account
DROP TABLE IF EXISTS `account`;
CREATE TABLE `account`(
	account_id		MEDIUMINT AUTO_INCREMENT PRIMARY KEY,
	email			VARCHAR(50) UNIQUE KEY,
	username		VARCHAR(50) UNIQUE KEY NOT NULL,
	fullname		VARCHAR(50) CHAR SET utf8mb4 NOT NULL,
	department_id	TINYINT NOT NULL,
	position_id		TINYINT NOT NULL,
	create_date		DATE,
    FOREIGN KEY (department_id) REFERENCES department(department_id),
    FOREIGN KEY (position_id) REFERENCES `position`(position_id)
);

INSERT INTO `account`(email,username,fullname,department_id,position_id,create_date)
VALUES  (N'nvdinh@gmail.com', N'nvdinh', N'nguyen van dinh', 1, 1, '2021-10-18'),
		(N'dqh@yahoo.com', N'dqhuy', N'dương quang huy', 1, 2, '2021-10-18'),
        (N'nva@gmail.com', N'nva', N'nguyen van a', 2, 3, '2021-10-19'),
        (N'vnanh@edumesa.com', N'vnanh', N'vu ngoc anh', 1, 3, '2021-10-10'),
        (N'ntnga@gmail.com', N'ntnga', N'nguyen thi nga', 5, 4, '2021-10-14'),
        (N'ltkhang@gmail.com', N'ltkhang', N'lam thi khang', 2, 3, '2021-10-14'),
        (N'nvb@yahoo.com', N'nvb', N'nguyen van b', 6, 4, '2021-10-14'),
        (N'tvanh@gmail.com', N'tvanh', N'tran van anh', 7, 1, '2021-10-13'),
        (N'tvbinh@gmail.com', N'tvbinh', N'tran van binh', 10, 2, '2021-10-13'),
        (N'tvduc@gmail.com', N'tvduc', N'tran van duc', 9, 3, '2021-10-10');
        
-- create table 4: group
DROP TABLE IF EXISTS `group`;
CREATE TABLE `group`(
	group_id		SMALLINT AUTO_INCREMENT PRIMARY KEY,
	group_name		VARCHAR(50) UNIQUE KEY,
	creator_id		MEDIUMINT,
	creator_date	DATE,
    FOREIGN KEY (creator_id) REFERENCES `account`(account_id)
);

INSERT INTO `group`(group_name,creator_id,creator_date)
VALUES  (N'pttt', 2, '2021-10-17'),
		(N'qlns', 4, '2021-10-19'),
        (N'y tuong', 3, '2021-10-19'),
        (N'thuc thi', 1, '2021-10-18'),
        (N'quang ba', 1, '2021-10-18'),
        (N'ky ket', 2, '2021-10-19'),
        (N'cskh', 5, '2021-10-17'),
        (N'xnk', 1, '2021-10-20'),
        (N'tnykkh', 5, '2021-10-20'),
        (N'dtnl', 4, '2021-10-17');

-- create table 5: group_account
DROP TABLE IF EXISTS group_account;
CREATE TABLE group_account(
	group_id		SMALLINT,
	account_id		MEDIUMINT,
	join_date		DATE,
    FOREIGN KEY (group_id) REFERENCES `group`(group_id),
    FOREIGN KEY (account_id) REFERENCES `account`(account_id)
);

INSERT INTO group_account(group_id,account_id,join_date)
VALUES   ( 1, 6, '2021-10-17'),
		 ( 1, 7, '021-10-17'),
         ( 2, 8, '2021-10-18'),
         ( 2, 9, '2021-10-18'),
         ( 3, 10, '2021-10-19'),
         ( 3, 6, '2021-10-19'),
         ( 4, 7, '2021-10-20'),
         ( 4, 8, '2021-10-21'),
		 ( 5, 9, '2021-10-21'),
         ( 5, 10, '2021-10-22');

-- create table 6: type question
DROP TABLE IF EXISTS type_question;
CREATE TABLE type_question(
	type_id			TINYINT AUTO_INCREMENT PRIMARY KEY,
	type_name		ENUM('essay','multiple_choice') NOT NULL
);

INSERT INTO type_question(type_name)
VALUES  (N'essay'),
		(N'multiple_choice');
        
-- create table 7: category question
DROP TABLE IF EXISTS category_question;
CREATE TABLE category_question(
	category_id		TINYINT AUTO_INCREMENT PRIMARY KEY,
	category_name	VARCHAR(50) 
);

INSERT INTO category_question(category_name)
VALUES   (N'java'),
		 (N'net'),
         (N'sql'),
         (N'postman'),
         (N'ruby'),
         (N'web'),
         (N'googleplay'),
         (N'ios'),
         (N'cloud'),
         (N'game');

-- create table 8: question
DROP TABLE IF EXISTS question;
CREATE TABLE question(
	question_id		MEDIUMINT AUTO_INCREMENT PRIMARY KEY,
	content			VARCHAR(255) CHAR SET utf8mb4,
	category_id		TINYINT,
	type_id			TINYINT,
	creator_id		MEDIUMINT,
	create_date		DATE,
    FOREIGN KEY (category_id) REFERENCES category_question(category_id),
    FOREIGN KEY (type_id) REFERENCES type_question(type_id),
    FOREIGN KEY (creator_id) REFERENCES `account`(account_id)
);

INSERT INTO question(category_id,type_id,creator_id,create_date)
VALUES  (1,1,2,'2021-10-18'),
		(2,1,3,'2021-10-18'),
        (3,2,4,'2021-10-19'),
        (4,2,5,'2021-10-20'),
        (5,1,6,'2021-10-17'),
        (6,1,2,'2021-10-17'),
        (7,2,7,'2021-10-17'),
        (7,1,7,'021-10-18'),
        (6,2,2,'2021-10-18'),
        (5,2,6,'2021-10-19');

-- create table 9: answer
DROP TABLE IF EXISTS answer;
CREATE TABLE answer(
	answer_id		MEDIUMINT AUTO_INCREMENT PRIMARY KEY,
	content			VARCHAR(255) CHAR SET utf8mb4,
	question_id		MEDIUMINT,
	is_correct		BOOLEAN,
	FOREIGN KEY (question_id) REFERENCES question(question_id)
);

INSERT INTO answer(question_id)
VALUES  (1),
		(2),
        (3),
        (4),
        (5),
        (6),
        (7),
        (8),
        (9),
        (10);

-- create table 10: exam
DROP TABLE IF EXISTS exam;
CREATE TABLE exam(
	exam_id			TINYINT AUTO_INCREMENT PRIMARY KEY,
	`code`			VARCHAR(10) NOT NULL,
	title			VARCHAR(50) ,
	category_id		TINYINT,
	duration		TIME NOT NULL,
	creator_id		MEDIUMINT,
	create_date		DATE,
    FOREIGN KEY (category_id) REFERENCES category_question(category_id),
    FOREIGN KEY (creator_id) REFERENCES `account`(account_id)
);

INSERT INTO exam(`code`,category_id,duration,creator_id,create_date)
VALUES  (N'a1',1,'00:45:00',1,'2021-10-19'),
		(N'a2',2,'00:45:00',1,'2021-10-19'),
        (N'b1',3,'00:45:00',3,'2021-10-18'),
        (N'b2',4,'00:45:00',4,'2021-10-18'),
        (N'c1',5,'00:45:00',5,'2021-10-18'),
        (N'c2',6,'00:45:00',2,'2021-10-19'),
        (N'd1',7,'01:00:00',3,'2021-10-19'),
        (N'd2',1,'01:00:00',2,'2021-10-20'),
        (N'e1',2,'01:00:00',6,'2021-10-20'),
        (N'e2',3,'01:00:00',4,'2021-10-20');

-- create table 11: exam question
DROP TABLE IF EXISTS exam_question;
CREATE TABLE exam_question(
	exam_id			TINYINT,
	question_id		MEDIUMINT,
    FOREIGN KEY (exam_id) REFERENCES exam(exam_id),
    FOREIGN KEY (question_id) REFERENCES question(question_id)
);

INSERT INTO exam_question(exam_id,question_id)
VALUES  (1,1),
		(2,1),
        (3,2),
        (4,2),
        (5,3),
        (6,3),
        (7,4),
        (8,4),
        (9,5),
        (10,5);
        
        -- Question 2: lấy ra tất cả các phòng ban
SELECT *
FROM testing_system.department;

-- Question 3: lấy ra id của phòng ban "Sale"
SELECT department_id,department_name
FROM testing_system.department
WHERE department_name = 'sales';

-- Question 4: lấy ra thông tin account có full name dài nhất
SELECT *
FROM testing_system.`account`
WHERE length(fullname) = (SELECT MAX(length(fullname)) FROM testing_system.`account`);

-- Question 5: Lấy ra thông tin account có full name dài nhất và thuộc phòng ban có id = 3
SELECT *
FROM testing_system.`account`
WHERE length(fullname) = (SELECT MAX(length(fullname)) FROM testing_system.`account`) AND department_id = 3;

-- Question 6: Lấy ra tên group đã tham gia trước ngày 20/12/2019
SELECT group_name
FROM testing_system.`group`
WHERE creator_date < '2019-12-20';

-- Question 7: Lấy ra ID của question có >= 4 câu trả lời

-- Question 8: Lấy ra các mã đề thi có thời gian thi >= 60 phút và được tạo trước ngày 20/12/2019
SELECT *
FROM testing_system.exam
WHERE duration >= '01:00:00' AND create_date < '2019-12-20';

-- Question 9: Lấy ra 5 group được tạo gần đây nhất
SELECT *
FROM testing_system.`group`
ORDER BY creator_date DESC
LIMIT 5;

-- Question 10: Đếm số nhân viên thuộc department có id = 2 ??? (thuoc department nao)
SELECT *
FROM testing_system.`account`;

-- Question 11: Lấy ra nhân viên có tên bắt đầu bằng chữ "D" và kết thúc bằng chữ "o"
SELECT fullname
FROM testing_system.`account`
WHERE fullname LIKE 'd%o';

-- Question 12: Xóa tất cả các exam được tạo trước ngày 20/12/2019
DELETE exam_id
FROM testing_system.exam
WHERE create_date < '2021-10-20';

-- Question 13: Xóa tất cả các question có nội dung bắt đầu bằng từ "câu hỏi"

-- Question 14: Update thông tin của account có id = 5 thành tên "Nguyễn Bá Lộc" và email thành loc.nguyenba@vti.com.vn
SELECT *
FROM testing_system.`account`;
UPDATE `account`
SET  fullname = 'nguyen ba loc',
	 email = 'thanhloc.nguyen@vti.com.vn'
WHERE `account` = 5;

-- Question 15: update account có id = 5 sẽ thuộc group có id = 4 ???
