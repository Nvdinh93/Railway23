-- SQL – Assignment 4
-- Exercise 1: Join

USE testing_system;

-- Question 1: Viết lệnh để lấy ra danh sách nhân viên và thông tin phòng ban của họ
SELECT fullname AS danh_sach_nhan_vien,department.*
FROM testing_system.`account`
JOIN department ON `account`.department_id = department.department_id;

-- Question 2: Viết lệnh để lấy ra thông tin các account được tạo sau ngày 20/12/2010
SELECT *
FROM testing_system.`account`
WHERE create_date > '2010-12-20';

-- Question 3: Viết lệnh để lấy ra tất cả các developer
SELECT full_name
FROM `account` a
JOIN `position` p ON a.position_id = p.position_id
WHERE p.position_name = 'Dev'
;

-- Question 4: Viết lệnh để lấy ra danh sách các phòng ban có >3 nhân viên
SELECT department_name
FROM `account` a
JOIN department d ON a.department_id = d.department_id
GROUP BY a.department_id
HAVING COUNT(a.account_id) > 3;

-- Question 5: Viết lệnh để lấy ra danh sách câu hỏi được sử dụng trong đề thi nhiều nhat
SELECT *
FROM question q
JOIN exam_question eq ON q.question_id = eq.question_id;

SELECT content,count(eq.exam_id) AS 'cau_hoi_nhieu_nhat'
FROM question q
JOIN exam_question eq ON q.question_id = eq.question_id
GROUP BY q.question_id
HAVING count(eq.exam_id) = (
	SELECT max(exam_count)
    FROM (
		SELECT count(eq.question_id) AS exam_count
        FROM exam_question eq
        GROUP BY eq.question_id) AS ec
    );

-- Question 6: Thông kê mỗi category Question được sử dụng trong bao nhiêu Question
SELECT category_name,count(cq.category_id) AS so_lan_su_dung
FROM category_question cq
LEFT JOIN question q ON cq.category_id = q.category_id
GROUP BY  cq.category_id;

-- Question 7: Thông kê mỗi Question được sử dụng trong bao nhiêu Exam
SELECT q.content,count(q.question_id) AS so_lan_su_dung
FROM testing_system.question q
JOIN exam_question exq ON q.question_id = exq.question_id
GROUP BY q.question_id
;

-- Question 8: Lấy ra Question có nhiều câu trả lời nhất
SELECT q.content,count(ans.question_id) AS so_answer_nhieu_nhat
FROM question q
JOIN answer ans ON q.question_id = ans.question_id
GROUP BY ans.question_id
HAVING count(ans.question_id) = (
	SELECT max(anscount)
    FROM (
		SELECT count(ans.question_id) AS anscount,content
        FROM answer ans
        GROUP BY ans.question_id) AS table_anscount
); 

-- Question 9: Thống kê số lượng account trong mỗi group
SELECT grac.group_id,group_name,count(grac.group_id) AS so_luong_account
FROM `group` gr
LEFT JOIN group_account grac ON gr.group_id = grac.group_id
GROUP BY grac.group_id
;

-- Question 10: Tìm chức vụ có ít người nhất
SELECT p.position_name,count(acc.account_id) AS chuc_vu_co_it_nguoi_nhat
FROM `account` acc
RIGHT JOIN `position` p ON acc.position_id = p.position_id
GROUP BY acc.position_id
HAVING count(acc.account_id) = (
	SELECT min(min_count)
    FROM (
		SELECT p.position_id,count(acc.account_id) AS min_count
        FROM `account` acc
        RIGHT JOIN `position` p ON acc.position_id = p.position_id 
        GROUP BY acc.position_id) AS tab_min_count
    )
;

-- Question 11: Thống kê mỗi phòng ban có bao nhiêu dev, test, scrum master, PM
SELECT d.department_id,department_name,count(acc.position_id) AS so_position,position_name
FROM department d
	LEFT JOIN `account` acc ON d.department_id = acc.department_id
	LEFT JOIN `position` p ON acc.position_id = p.position_id
	GROUP BY d.department_id
;

-- Question 12: Lấy thông tin chi tiết của câu hỏi bao gồm: thông tin cơ bản của
-- question, loại câu hỏi, ai là người tạo ra câu hỏi, câu trả lời là gì, ...
SELECT q.*,fullname,category_name,answer.content
FROM question q
LEFT JOIN exam ON q.category_id = exam.category_id
LEFT JOIN answer ON q.question_id = answer.question_id
LEFT JOIN category_question cq ON q.category_id = cq.category_id
LEFT JOIN `account` a ON q.creator_id = a.account_id;

-- Question 13: Lấy ra số lượng câu hỏi của mỗi loại tự luận hay trắc nghiệm
SELECT *
FROM type_question;
SELECT *
FROM question;
SELECT type_name,count(typeq.type_id) AS so_luong_cau_hoi
FROM type_question typeq
LEFT JOIN question q ON typeq.type_id = q.type_id
GROUP BY typeq.type_id
;

-- Question 14:Lấy ra group không có account nào
-- Question 15: Lấy ra group không có account nào
SELECT *
FROM `group`;
SELECT *
FROM group_account;
SELECT gr.group_id,gr.group_name
FROM `group` gr
LEFT JOIN group_account grac ON gr.group_id = grac.group_id
WHERE grac.group_id IS NULL
;

-- Question 16: Lấy ra question không có answer nào
SELECT *
FROM answer;
SELECT q.question_id,q.content
FROM question q
LEFT JOIN answer ans ON q.question_id = ans.question_id
WHERE answer_id IS NULL;

-- Question 17:
	-- a) Lấy các account thuộc nhóm thứ 1
	-- b) Lấy các account thuộc nhóm thứ 2
	-- c) Ghép 2 kết quả từ câu a) và câu b) sao cho không có record nào trùng nhau
    SELECT ac.account_id,ac.username
    FROM `account` ac
    JOIN group_account grac ON ac.account_id = grac.account_id
    WHERE group_id = 1
    UNION
    SELECT ac.account_id,ac.username
    FROM `account` ac
    JOIN group_account grac ON ac.account_id = grac.account_id
    WHERE group_id = 2;
-- Question 18:
	-- a) Lấy các group có lớn hơn 5 thành viên
	-- b) Lấy các group có nhỏ hơn 7 thành viên
	-- c) Ghép 2 kết quả từ câu a) và câu b)
SELECT gr.group_id,gr.group_name
FROM group_account;
SELECT gr.group_id,gr.group_name,count(grac.account_id)
FROM `group` gr
JOIN group_account grac ON gr.group_id = grac.group_id
GROUP BY gr.group_id
HAVING count(grac.account_id) > 5
	UNION ALL
SELECT gr.group_id,gr.group_name,count(grac.account_id)
FROM `group` gr
LEFT JOIN group_account grac ON gr.group_id = grac.group_id
GROUP BY gr.group_id
HAVING count(grac.account_id) < 7;
