-- create database fresher_training_management
DROP DATABASE IF EXISTS fresher_training_management;
CREATE DATABASE fresher_training_management;
USE fresher_training_management;

ALTER DATABASE fresher_training_management CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- create table trainee
CREATE TABLE trainee(
	trainee_id			MEDIUMINT AUTO_INCREMENT PRIMARY KEY,
	full_name			VARCHAR(50) CHAR SET utf8mb4 NOT NULL,
	birth_date			DATE NOT NULL,
	gender				ENUM('male','female','unknown') NOT NULL,
	et_iq				MEDIUMINT CHECK(et_iq >= 0 AND et_iq <= 20) NOT NULL,
	et_gmath			MEDIUMINT CHECK(et_gmath >= 0 AND et_gmath <= 20) NOT NULL,
	et_english			MEDIUMINT CHECK(et_english >= 0 AND et_english <= 50) NOT NULL,
	training_class		VARCHAR(20),
	evaluation_notes	VARCHAR(255) CHAR SET utf8mb4,
	vti_account			VARCHAR(50) UNIQUE KEY NOT NULL

);
INSERT INTO trainee(full_name,birth_date,gender,et_iq,et_gmath,et_english,training_class,evaluation_notes,vti_account)
VALUES  (N'nguyễn văn a','1993-01-01',N'male','10','11','12','a1','danh gia 1','nva'),
		(N'nguyễn văn b','1993-02-02',N'female','15','16','17','a2','danh gia 2','nvb'),
        (N'nguyễn văn c','1993-01-03',N'female','12','13','22','a3','danh gia 3','nvc'),
        (N'nguyễn văn d','1993-02-04',N'male','12','11','30','a4','danh gia 1','nvd'),
        (N'nguyễn văn e','1993-02-05',N'male','11','12','31','a5','danh gia 2','nve'),
        (N'trần văn a','1994-03-01',N'female','15','16','32','a2','danh gia 3','tva'),
        (N'trần văn b','1994-03-02',N'male','14','14','33','a3','danh gia 4','tvb'),
        (N'trần văn c','1994-03-03',N'male','15','15','12','a4','danh gia 5','tvc'),
        (N'trần văn d','1994-03-04',N'female','16','16','40','a5','danh gia 6','tvd'),
        (N'trần văn e','1994-04-05',N'male','19','19','49','a5','danh gia 7','tve');
        
-- extra assignment 1_2 exercise 2 3

DROP DATABASE IF EXISTS data_types;
CREATE DATABASE data_types;
USE data_types;
-- create table data types 1
DROP TABLE IF EXISTS data_types_1;
CREATE TABLE data_types_1(
ID					MEDIUMINT UNSIGNED PRIMARY KEY,
`Name`				VARCHAR(50),
`Code`				CHAR(5),
Modified_Date		DATETIME
);
-- create table data types 2
DROP TABLE IF EXISTS data_types_2;
CREATE TABLE data_types_2(
ID					MEDIUMINT UNSIGNED PRIMARY KEY,
`Name`				VARCHAR(50),
Birth_Date			DATE,
Gender				ENUM('0','1','unknowm'),
Is_Deleted_Flag		ENUM('0','1')
);
