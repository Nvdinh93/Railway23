CREATE DATABASE testing_system;
USE testing_system;
CREATE TABLE department (
department_id			INT,
department_name			VARCHAR(50)
);
CREATE TABLE `position` (
position_id				INT,
position_name			VARCHAR(50)
);
CREATE TABLE `account` (
account_id				INT,
email					VARCHAR(100),
username				VARCHAR(100),
fullname				VARCHAR(100),
department_id			INT,
position_id				INT,
create_date				DATE
);
CREATE TABLE `group` (
group_id				INT,
group_name				VARCHAR(100),
creator_id				INT,
creator_date			DATE
);
CREATE TABLE group_account (
group_id				INT,
account_id				INT,
join_date				DATE
);
CREATE TABLE type_question (
type_id					INT,
type_name				VARCHAR(50)
);
CREATE TABLE category_question (
category_id				INT,
category_name			VARCHAR(50)
);
CREATE TABLE question (
question				VARCHAR(50),
content					VARCHAR(100),
category_id				INT,
type_id					INT,
creator_id				INT,
create_date				DATE
);
CREATE TABLE answer (
answer_id				INT,
content					VARCHAR(100),
question_id				INT,
is_correct				VARCHAR(50)
);
CREATE TABLE exam (
exam_id					INT,
code_					VARCHAR(50),
title					VARCHAR(100),
category_id				INT,
duration				TIME,
creator_id				INT,
create_date				DATE
);
CREATE TABLE exam_question (
exam_id					INT,
question_id				INT
);