-- SQL – Assignment 4
-- Exercise 1: Join

USE testing_system;

-- Question 1: Viết lệnh để lấy ra danh sách nhân viên và thông tin phòng ban của họ
SELECT fullname AS danh_sach_nhan_vien,department_name AS phong_ban
FROM testing_system.`account`
JOIN department ON `account`.department_id = department.department_id;

-- Question 2: Viết lệnh để lấy ra thông tin các account được tạo sau ngày 20/12/2010
SELECT *
FROM testing_system.`account`
WHERE create_date > '2010-12-20';

-- Question 3: Viết lệnh để lấy ra tất cả các developer
SELECT *
FROM `account`
JOIN position ON `account`.position_id = position.position_id
WHERE position_name = 'Dev'
;

-- Question 4: Viết lệnh để lấy ra danh sách các phòng ban có >3 nhân viên
SELECT department_name
FROM testing_system.department
JOIN testing_system.`account` ON department.department_id = `account`.department_id
GROUP BY department.department_name
HAVING COUNT(department_name) > 3;

-- Question 5: Viết lệnh để lấy ra danh sách câu hỏi được sử dụng trong đề thi nhiều nhat
SELECT *
FROM testing_system.question
JOIN exam_question ON question.question_id = exam_question.question_id;

SELECT content,count(content) AS 'cau_hoi_nhieu_nhat'
FROM testing_system.question
JOIN exam_question ON question.question_id = exam_question.question_id
GROUP BY content
HAVING count(content) = (SELECT MAX(count(content)) FROM exam_question)
ORDER BY count(content) DESC
LIMIT 1;

-- Question 6: Thông kê mỗi category Question được sử dụng trong bao nhiêu Question
SELECT category_name,count(category_name) AS so_lan_su_dung
FROM testing_system.category_question
JOIN question ON category_question.category_id = question.category_id
GROUP BY category_name
HAVING count(category_name);

-- Question 7: Thông kê mỗi Question được sử dụng trong bao nhiêu Exam
SELECT content,count(content) AS so_lan_su_dung
FROM testing_system.question
JOIN exam_question ON question.question_id = exam_question.question_id
GROUP BY content
HAVING count(content);

-- Question 8: Lấy ra Question có nhiều câu trả lời nhất
SELECT *
FROM testing_system.question
JOIN answer ON question.question_id = answer.question_id
GROUP BY answer.question_id
HAVING count(question_id) = (SELECT max(count(question_id)));

-- Question 9: Thống kê số lượng account trong mỗi group
SELECT group_account.group_id,group_name,count(group_account.group_id) AS so_luong_account
FROM `group`
LEFT JOIN group_account ON `group`.group_id = group_account.group_id
GROUP BY group_account.group_id
HAVING count(group_account.group_id)
ORDER BY group_id ASC
;

-- Question 10: Tìm chức vụ có ít người nhất
SELECT position_name
FROM `account`
JOIN position ON `account`.position_id = position.position_id
GROUP BY `account`.position_id
HAVING count(`account`.position_id)
ORDER BY `account`.position_id ASC
LIMIT 1;

-- Question 11: Thống kê mỗi phòng ban có bao nhiêu dev, test, scrum master, PM
SELECT department.department_id,department_name,count(position_name) AS so_position,position_name
FROM `account`
JOIN position ON `account`.position_id = position.position_id
JOIN department ON `account`.department_id = department.department_id
GROUP BY position_name
HAVING count(position_name);

-- Question 12: Lấy thông tin chi tiết của câu hỏi bao gồm: thông tin cơ bản của
-- question, loại câu hỏi, ai là người tạo ra câu hỏi, câu trả lời là gì, ...
SELECT q.*,category_name,answer.content
FROM question q
LEFT JOIN exam ON q.category_id = exam.category_id
LEFT JOIN answer ON q.question_id = answer.question_id
LEFT JOIN category_question cq ON q.category_id = cq.category_id
ORDER BY q.question_id ASC;

-- Question 13: Lấy ra số lượng câu hỏi của mỗi loại tự luận hay trắc nghiệm
SELECT *
FROM type_question;
SELECT *
FROM question;
SELECT type_name,count(type_name) AS so_luong_cau_hoi
FROM type_question typeq
LEFT JOIN question q ON typeq.type_id = q.type_id
GROUP BY type_name
HAVING count(type_name);

-- Question 14:Lấy ra group không có account nào
-- Question 15: Lấy ra group không có account nào
SELECT *
FROM group_account;
SELECT *
FROM `group` gr
LEFT JOIN group_account grac ON gr.group_id = grac.group_id
WHERE account_id IS NULL;

-- Question 16: Lấy ra question không có answer nào
SELECT *
FROM answer;
SELECT *
FROM question q
LEFT JOIN answer ans ON q.question_id = ans.question_id
WHERE answer_id IS NULL;

-- Question 17:
	-- a) Lấy các account thuộc nhóm thứ 1
	-- b) Lấy các account thuộc nhóm thứ 2
	-- c) Ghép 2 kết quả từ câu a) và câu b) sao cho không có record nào trùng nhau
    SELECT *
    FROM `account` ac
    JOIN group_account grac ON ac.account_id = grac.account_id
    WHERE group_id = 1
    UNION
    SELECT *
    FROM `account` ac
    JOIN group_account grac ON ac.account_id = grac.account_id
    WHERE group_id = 2;
-- Question 18:
	-- a) Lấy các group có lớn hơn 5 thành viên
	-- b) Lấy các group có nhỏ hơn 7 thành viên
	-- c) Ghép 2 kết quả từ câu a) và câu b)
SELECT *
FROM group_account;
SELECT *
FROM `group` gr
JOIN group_account grac ON gr.group_id = grac.group_id
GROUP BY gr.group_id
HAVING count(gr.group_id) > 5
UNION
SELECT *
FROM `group` gr
LEFT JOIN group_account grac ON gr.group_id = grac.group_id
GROUP BY gr.group_id
HAVING count(gr.group_id) < 7;
