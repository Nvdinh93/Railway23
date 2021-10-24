DROP DATABASE IF EXISTS testing_system;
CREATE DATABASE IF NOT EXISTS testing_system;
USE testing_system;

ALTER DATABASE testing_system CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- create table 1: department
DROP TABLE IF EXISTS department;
CREATE TABLE department(
	department_id		TINYINT AUTO_INCREMENT PRIMARY KEY NOT NULL ,
	department_name		VARCHAR(30) CHAR SET utf8mb4 NOT NULL UNIQUE KEY
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
	position_id		TINYINT AUTO_INCREMENT PRIMARY KEY NOT NULL,
	position_name	ENUM('Dev','Test','Scrum Master','Pm')
);

INSERT INTO `position`(position_name)
VALUES  (N'Dev'),
		(N'Test'),
        (N'Scrum Master'),
        (N'Pm');
        
-- create table 3: account
DROP TABLE IF EXISTS `account`;
CREATE TABLE `account`(
	account_id		MEDIUMINT AUTO_INCREMENT PRIMARY KEY,
	email			VARCHAR(50) UNIQUE KEY,
	username		VARCHAR(20) UNIQUE KEY NOT NULL,
	fullname		VARCHAR(50) CHAR SET utf8mb4 NOT NULL,
	department_id	TINYINT NOT NULL,
	position_id		TINYINT NOT NULL,
	create_date		DATE,
    FOREIGN KEY (department_id) REFERENCES department(department_id),
    FOREIGN KEY (position_id) REFERENCES `position`(position_id)
);

INSERT INTO `account`(email,username,fullname,department_id,position_id,create_date)
VALUES  (N'nvdinh@gmail.com', N'nvdinh', N'nguyen van dinh', 1, 1, '2010-10-18'),
		(N'dqh@yahoo.com', N'dqhuy', N'dương quang huy', 1, 2, '2011-10-18'),
        (N'nva@gmail.com', N'nva', N'nguyen van a', 1, 3, '2011-10-19'),
        (N'vnanh@edumesa.com', N'vnanh', N'vu ngoc anh', 1, 3, '2011-10-10'),
        (N'ntnga@gmail.com', N'ntnga', N'nguyen thi nga', 5, 4, '2012-10-14'),
        (N'ltkhang@gmail.com', N'ltkhang', N'lam thi khang', 2, 3, '2012-10-14'),
        (N'nvb@yahoo.com', N'nvb', N'nguyen van b', 6, 4, '2012-10-14'),
        (N'tvanh@gmail.com', N'tvanh', N'tran van anh', 7, 4, '2013-10-13'),
        (N'tvbinh@gmail.com', N'tvbinh', N'tran van binh', 10, 2, '2013-10-13'),
        (N'tvduc@gmail.com', N'tvduc', N'tran van duc', 9, 3, '2013-10-10');
        
-- create table 4: group
DROP TABLE IF EXISTS `group`;
CREATE TABLE `group`(
	group_id		SMALLINT AUTO_INCREMENT PRIMARY KEY,
	group_name		VARCHAR(50) UNIQUE KEY NOT NULL,
	creator_id		MEDIUMINT,
	creator_date	DATE,
    FOREIGN KEY (creator_id) REFERENCES `account`(account_id)
);

INSERT INTO `group`(group_name,creator_id,creator_date)
VALUES  (N'pttt', 2, '2010-10-17'),
		(N'qlns', 4, '2010-10-19'),
        (N'y tuong', 3, '2011-10-19'),
        (N'thuc thi', 1, '2011-10-18'),
        (N'quang ba', 1, '2012-10-18'),
        (N'ky ket', 2, '2012-10-19'),
        (N'cskh', 5, '2013-10-17'),
        (N'xnk', 1, '2013-10-20'),
        (N'tnykkh', 5, '2014-10-20'),
        (N'dtnl', 4, '2014-10-17');

-- create table 5: group_account
DROP TABLE IF EXISTS group_account;
CREATE TABLE group_account(
	group_id		SMALLINT NOT NULL,
	account_id		MEDIUMINT NOT NULL,
	join_date		DATE,
    PRIMARY KEY (group_id,account_id),
    FOREIGN KEY (group_id) REFERENCES `group`(group_id),
    FOREIGN KEY (account_id) REFERENCES `account`(account_id)
);

INSERT INTO group_account(group_id,account_id,join_date)
VALUES   ( 1, 5, '2010-10-17'),
		 ( 1, 1, '2011-10-17'),
         ( 1, 2, '2011-10-17'),
         ( 1, 3, '2011-10-17'),
         ( 1, 4, '2011-10-17'),
         ( 1, 7, '2011-10-17'),
         ( 2, 1, '2012-10-18'),
         ( 2, 2, '2013-10-18'),
         ( 2, 3, '2013-10-18'),
         ( 2, 4, '2013-10-18'),
         ( 2, 5, '2013-10-18'),
         ( 2, 8, '2013-10-18'),
         ( 2, 9, '2013-10-18'),
         ( 3, 10, '2014-10-19'),
         ( 3, 6, '2015-10-19'),
         ( 4, 7, '2016-10-20'),
         ( 4, 8, '2017-10-21'),
		 ( 5, 9, '2018-10-21'),
         ( 5, 10, '2019-10-22');

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
	category_id		TINYINT AUTO_INCREMENT PRIMARY KEY NOT NULL,
	category_name	VARCHAR(50) UNIQUE KEY NOT NULL
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

INSERT INTO question(content,category_id,type_id,creator_id,create_date)
VALUES  (N'câu hỏi java la gi',1,1,2,'2011-10-18'),								
		(N'cau hoi java 2',1,2,3,'2012-10-18'),
        (N'sql la gi',3,2,4,'2013-10-19'),
        (N'postman la gi',4,2,5,'2014-10-20'),
        (N'ruby la gi',5,1,6,'2015-10-17'),
        (N'cach tao mot trang web',6,1,2,'2015-10-17'),
        (N'googleplay la gi',7,2,7,'2016-10-17'),
        (N'ios la gi',8,1,7,'2017-10-18'),
        (N'cloud la gi',9,2,2,'2017-10-18'),
        (N'cach tao mot game',10,2,6,'2017-10-19');

-- create table 9: answer
DROP TABLE IF EXISTS answer;
CREATE TABLE answer(
	answer_id		MEDIUMINT AUTO_INCREMENT PRIMARY KEY,
	content			VARCHAR(255) CHAR SET utf8mb4 NOT NULL,
	question_id		MEDIUMINT NOT NULL,
	is_correct		BOOLEAN,
	FOREIGN KEY (question_id) REFERENCES question(question_id) ON DELETE CASCADE
);

INSERT INTO answer(content,question_id,is_correct)
VALUES  (N'cau tra loi 1',1,1),
		(N'cau tra loi 2',1,1),
        (N'cau tra loi 3',1,0),
        (N'cau tra loi 4',1,0),
        (N'cau tra loi 5',5,0),
        (N'cau tra loi 6',6,1),
        (N'cau tra loi 7',7,1),
        (N'cau tra loi 8',8,1),
        (N'cau tra loi 9',9,1),
        (N'cau tra loi 10',10,0);

-- create table 10: exam
DROP TABLE IF EXISTS exam;
CREATE TABLE exam(
	exam_id			TINYINT AUTO_INCREMENT PRIMARY KEY NOT NULL,
	`code`			VARCHAR(10) NOT NULL UNIQUE KEY,
	title			VARCHAR(50) NOT NULL,
	category_id		TINYINT NOT NULL,
	duration		TIME NOT NULL,
	creator_id		MEDIUMINT NOT NULL,
	create_date		DATE,
    FOREIGN KEY (category_id) REFERENCES category_question(category_id),
    FOREIGN KEY (creator_id) REFERENCES `account`(account_id)
);

INSERT INTO exam(`code`,title,category_id,duration,creator_id,create_date)
VALUES  (N'a1','title 1',1,'00:30:00',1,'2011-10-19'),
		(N'a2','title 2',2,'00:45:00',1,'2011-10-19'),
        (N'b1','title 3',3,'00:45:00',3,'2012-10-18'),
        (N'b2','title 4',4,'00:45:00',4,'2012-10-18'),
        (N'c1','title 5',5,'01:30:00',5,'2013-10-18'),
        (N'c2','title 6',6,'01:30:00',2,'2013-10-19'),
        (N'd1','title 7',7,'01:00:00',3,'2014-10-19'),
        (N'd2','title 8',1,'01:00:00',2,'2014-10-20'),
        (N'e1','title 9',2,'01:00:00',6,'2015-10-20'),
        (N'e2','title 10',3,'01:30:00',4,'2015-10-20');

-- create table 11: exam question
DROP TABLE IF EXISTS exam_question;
CREATE TABLE exam_question(
	exam_id			TINYINT,
	question_id		MEDIUMINT,
    PRIMARY KEY (exam_id,question_id),
    FOREIGN KEY (exam_id) REFERENCES exam(exam_id) ON DELETE CASCADE,
    FOREIGN KEY (question_id) REFERENCES question(question_id) ON DELETE CASCADE
);

INSERT INTO exam_question(exam_id,question_id)
VALUES  (1,1),
		(2,1),
        (3,1),
        (4,1),
        (5,3),
        (6,3),
        (7,4),
        (8,4),
        (9,5),
        (10,5);