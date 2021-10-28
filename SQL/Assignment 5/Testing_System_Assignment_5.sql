
USE testing_system;

-- Question 1: Tạo view có chứa danh sách nhân viên thuộc phòng ban sale
DROP VIEW IF EXISTS nhan_vien_phong_sale;
CREATE VIEW nhan_vien_phong_sale AS
SELECT account_id,username,fullname
FROM `account` ac
JOIN department de ON ac.department_id = de.department_id
WHERE de.department_name = 'sale'
;
SELECT *
FROM nhan_vien_phong_sale;

-- Question 2: Tạo view có chứa thông tin các account tham gia vào nhiều group nhất
SELECT *
FROM `account`;
SELECT *
FROM group_account;

DROP VIEW IF EXISTS account_nhieu_group_nhat;
CREATE VIEW account_nhieu_group_nhat AS
	SELECT COUNT(grac.group_id),ac.*
	FROM `account` ac
	JOIN group_account grac ON ac.account_id = grac.account_id
	GROUP BY grac.group_id
	HAVING COUNT(grac.group_id) = (
		SELECT MAX(so_ac_trong_moi_group)
		FROM (
			SELECT COUNT(grac1.group_id) AS so_ac_trong_moi_group
			FROM group_account grac1
			GROUP BY grac1.group_id
			) AS tab_grac1
	);

-- Question 3: Tạo view có chứa câu hỏi có những content quá dài (content quá 300 từ được coi là quá dài) và xóa nó đi
SELECT *
FROM question;

DROP VIEW IF EXISTS content_qua_dai;
CREATE VIEW content_qua_dai AS
	SELECT *
	FROM question
	WHERE length(content) > 300;
    
DELETE 
FROM content_qua_dai;

-- Question 4: Tạo view có chứa danh sách các phòng ban có nhiều nhân viên nhất
SELECT *
FROM department;
SELECT *
FROM `account`;

DROP VIEW IF EXISTS phong_ban_nhieu_nhan_vien_nhat;
CREATE VIEW phong_ban_nhieu_nhan_vien_nhat AS
	SELECT de.department_id,department_name
	FROM department de
	JOIN `account` ac ON de.department_id = ac.department_id
	GROUP BY ac.department_id
	HAVING COUNT(ac.account_id) = (
		SELECT MAX(so_ac_trong_moi_department)
		FROM (
			SELECT COUNT(account_id) AS so_ac_trong_moi_department
			FROM `account` acc
			GROUP BY acc.department_id
			) AS tab_numb_ac
);

-- Question 5: Tạo view có chứa tất các các câu hỏi do user họ Nguyễn tạo
SELECT *
FROM `account`;
SELECT *
FROM question;

DROP VIEW IF EXISTS cau_hoi_do_ho_nguyen_tao;
CREATE VIEW cau_hoi_do_ho_nguyen_tao AS
	SELECT question_id,content,fullname AS nguoi_tao_cau_hoi
	FROM question q
	JOIN `account` ac ON q.creator_id = ac.account_id
	WHERE fullname LIKE 'Nguyễn%';

