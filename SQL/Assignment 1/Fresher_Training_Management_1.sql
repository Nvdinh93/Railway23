DROP DATABASE IF EXISTS fresher_training_management;
CREATE DATABASE fresher_training_management;
USE fresher_training_management;
CREATE TABLE trainee (
trainee_id				INT,
full_name				VARCHAR(100),
birth_date				DATE,
gender					ENUM('male','female','unknown'),
et_eq					INT,
et_gmath				INT,
et_english				INT,
training_class			VARCHAR(50),
evaluation_notes		VARCHAR(200),
vti_account				VARCHAR(50) UNIQUE KEY NOT NULL

);