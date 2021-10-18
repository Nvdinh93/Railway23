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
	gender				ENUM('male','female','unknown'),
	et_eq				MEDIUMINT CHECK(et_eq >= 0 AND et_eq <= 20),
	et_gmath			MEDIUMINT CHECK(et_gmath >= 0 AND et_gmath <= 20),
	et_english			MEDIUMINT CHECK(et_english >= 0 AND et_english <= 50),
	training_class		VARCHAR(50),
	evaluation_notes	VARCHAR(255) CHAR SET utf8mb4,
	vti_account			VARCHAR(50) UNIQUE KEY NOT NULL

);
