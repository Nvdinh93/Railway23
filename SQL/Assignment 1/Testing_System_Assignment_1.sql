DROP DATABASE IF EXISTS testing_system;
CREATE DATABASE IF NOT EXISTS testing_system;
USE testing_system;
-- khoảng cách giữa tên trường và kiểu dữ liệu 
-- khoảng cách lùi đầu dòng của các trường trong bảng 
DROP TABLE IF EXISTS department;
CREATE TABLE department(
	department_id		TINYINT AUTO_INCREMENT PRIMARY KEY,
	department_name		VARCHAR(50)
);
DROP TABLE IF EXISTS `position`;
CREATE TABLE `position`(
	position_id		TINYINT AUTO_INCREMENT PRIMARY KEY,
	position_name	ENUM('Dev','Test','Scrum Master','PM')
);
DROP TABLE IF EXISTS `account`;
CREATE TABLE `account`(
	account_id		MEDIUMINT AUTO_INCREMENT PRIMARY KEY,
	email			VARCHAR(50) UNIQUE KEY,
	username		VARCHAR(50) UNIQUE KEY,
	fullname		VARCHAR(50),
	department_id	TINYINT,
	position_id		TINYINT,
	create_date		DATE
);
DROP TABLE IF EXISTS `group`;
CREATE TABLE `group`(
	group_id		SMALLINT AUTO_INCREMENT PRIMARY KEY,
	group_name		VARCHAR(50) UNIQUE KEY,
	creator_id		MEDIUMINT,
	creator_date	DATE
);
DROP TABLE IF EXISTS group_account;
CREATE TABLE group_account(
	group_id		SMALLINT,
	account_id		MEDIUMINT,
	join_date		DATE
);
DROP TABLE IF EXISTS type_question;
CREATE TABLE type_question(
	type_id			INT,
	type_name		VARCHAR(50)
);
DROP TABLE IF EXISTS category_question;
CREATE TABLE category_question(
	category_id		INT,
	category_name	VARCHAR(50)
);
DROP TABLE IF EXISTS question;
CREATE TABLE question(
	question		VARCHAR(50),
	content			VARCHAR(100),
	category_id		INT,
	type_id			INT,
	creator_id		INT,
	create_date		DATE
);
DROP TABLE IF EXISTS answer;
CREATE TABLE answer(
	answer_id		INT,
	content			VARCHAR(100),
	question_id		INT,
	is_correct		BOOLEAN -- yes or no
);
DROP TABLE IF EXISTS exam;
CREATE TABLE exam(
	exam_id			INT,
	code_			VARCHAR(50),
	title			VARCHAR(100),
	category_id		INT,
	duration		TIME,
	creator_id		INT,
	create_date		DATE
);
DROP TABLE IF EXISTS exam_question;
CREATE TABLE exam_question(
	exam_id			INT,
	question_id		INT
);