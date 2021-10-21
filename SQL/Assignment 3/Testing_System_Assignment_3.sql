
USE testing_system;

        
         -- Question 2: lấy ra tất cả các phòng ban
SELECT *
FROM testing_system.department;

-- Question 3: lấy ra id của phòng ban "Sale"
SELECT department_id
FROM testing_system.department
WHERE department_name = 'sales';

-- Question 4: lấy ra thông tin account có full name dài nhất
SELECT *
FROM testing_system.`account`
WHERE length(fullname) = (SELECT MAX(length(fullname)) FROM testing_system.`account`);

-- Question 5: Lấy ra thông tin account có full name dài nhất và thuộc phòng ban có id = 3
SELECT *
FROM testing_system.`account`
WHERE length(fullname) = (SELECT MAX(length(fullname)) FROM testing_system.`account`) AND department_id = 3;

-- Question 6: Lấy ra tên group đã tham gia trước ngày 20/12/2019
SELECT group_name
FROM testing_system.`group`
WHERE creator_date < '2019-12-20';

-- Question 7: Lấy ra ID của question có >= 4 câu trả lời
SELECT question_id
FROM testing_system.answer
GROUP BY question_id
HAVING count(question_id)>= 4;

-- Question 8: Lấy ra các mã đề thi có thời gian thi >= 60 phút và được tạo trước ngày 20/12/2019
SELECT *
FROM testing_system.exam
WHERE duration >= '01:00:00' AND create_date < '2019-12-20';

-- Question 9: Lấy ra 5 group được tạo gần đây nhất
SELECT *
FROM testing_system.`group`
ORDER BY creator_date DESC
LIMIT 5;

-- Question 10: Đếm số nhân viên thuộc department có id = 2 
SELECT count(fullname) AS nhan_vien_thuoc_department2,fullname
FROM testing_system.`account`
WHERE department_id = 2;

-- Question 11: Lấy ra nhân viên có tên bắt đầu bằng chữ "D" và kết thúc bằng chữ "o"
SELECT fullname
FROM testing_system.`account`
WHERE fullname LIKE 'D%o';

-- Question 12: Xóa tất cả các exam được tạo trước ngày 20/12/2019
SET FOREIGN_KEY_CHECKS=0;
SELECT * 
FROM testing_system.exam;                       
DELETE  
FROM exam
WHERE create_date < '2019-12-20';

-- Question 13: Xóa tất cả các question có nội dung bắt đầu bằng từ "câu hỏi"
select *
from testing_system.question;
DELETE 
FROM testing_system.question
WHERE content LIKE 'câu hỏi%';

-- Question 14: Update thông tin của account có id = 5 thành tên "Nguyễn Bá Lộc" và email thành loc.nguyenba@vti.com.vn
SELECT *
FROM testing_system.`account`;
UPDATE `account`
SET  fullname = 'Nguyễn Bá Lộc',
	 email = 'thanhloc.nguyen@vti.com.vn'
WHERE account_id = 5;

-- Question 15: update account có id = 5 sẽ thuộc group có id = 4 ???
SELECT *
FROM group_account;
UPDATE group_account
SET group_id = 4
WHERE account_id = 5;
