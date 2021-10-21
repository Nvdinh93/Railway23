-- SQL – Assignment 4
-- Exercise 1: Join

USE testing_system;

-- Question 1: Viết lệnh để lấy ra danh sách nhân viên và thông tin phòng ban của họ
SELECT fullname,department_name
FROM testing_system.`account`
JOIN department ON `account`.department_id = department.department_id;

-- Question 2: Viết lệnh để lấy ra thông tin các account được tạo sau ngày 20/12/2010
SELECT *
FROM testing_system.`account`
WHERE create_date > '2010-12-20';

-- Question 3: Viết lệnh để lấy ra tất cả các developer

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
SELECT *
FROM `account`;
SELECT *
FROM `group`
LEFT JOIN group_account ON `group`.group_id = group_account.group_id
;


