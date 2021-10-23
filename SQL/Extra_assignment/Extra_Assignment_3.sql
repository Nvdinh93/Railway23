USE fresher_training_management;

-- Exercise 1: Continuing with Fresher Training Management Database
-- Question 1: Add at least 10 records into created table
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
        
-- Question 2: Query all the trainees who is passed the entry test, group them into different birth months
SELECT group_concat(full_name) AS 'group_theo_thang_sinh',month(birth_date)
FROM trainee
GROUP BY month(birth_date);

-- Question 3: Query the trainee who has the longest name, showing his/her age along 
            -- with his/her basic information (as defined in the table)
	SELECT full_name,birth_date
    FROM trainee
    WHERE length(full_name) = (SELECT max(length(full_name))FROM trainee);
    
-- Question 4: Query all the ET-passed trainees. One trainee is considered as ET-passed
            -- when he/she has the entry test points satisfied below criteria:
			--  ET_IQ + ET_Gmath>=20
			--  ET_IQ>=8
			--  ET_Gmath>=8
			--  ET_English>=18
SELECT *
FROM trainee
WHERE et_iq + et_gmath >= 20 AND et_iq >= 8 AND et_gmath >= 8 AND et_english >= 18;

            
-- Question 5: delete information of trainee who has TraineeID = 3
DELETE
FROM trainee
WHERE trainee_id = 3;

-- Question 6: trainee who has TraineeID = 5 move "2" class. Let update information into database
UPDATE trainee
SET training_class = 2
WHERE trainee_id = 5;

