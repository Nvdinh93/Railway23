-- extra assignment 1 
DROP DATABASE IF EXISTS data_types;
CREATE DATABASE data_types;
USE data_types;
CREATE TABLE data_types_1(
ID					MEDIUMINT UNSIGNED PRIMARY KEY,
`Name`				VARCHAR(50),
`Code`				CHAR(5),
Modified_Date		DATETIME
);
CREATE TABLE data_types_2(
ID					MEDIUMINT UNSIGNED PRIMARY KEY,
`Name`				VARCHAR(50),
Birth_Date			DATE,
Gender				ENUM('male','female','unknowm'),
Is_Deleted_Flag		ENUM('active','deleted')
);