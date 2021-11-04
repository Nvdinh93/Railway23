-- Question 1: Tạo trigger không cho phép người dùng nhập vào Group có ngày tạo trước 1 năm trước
DROP TRIGGER IF EXISTS cannot_input_to_group;
DELIMITER $$
CREATE TRIGGER trigger_cannot_input_to_group
	BEFORE INSERT ON `group`
		FOR EACH ROW
			BEGIN
				DECLARE inputCreatorDate DATE;
                SELECT date_sub(curdate(), interval 1 year) INTO inputCreatorDate;
				if new.creator_date < date_sub(curdate(), interval 1 year) then
                SIGNAL SQLSTATE '12345' SET MESSAGE_TEXT = 'ngay tao khong hop le';
			END IF;
	END$$
DELIMITER ;
			
SELECT * FROM `group`;
			
INSERT INTO `group`(group_name,creator_id,creator_date)
VALUE	('abc',1,'2020-10-25');

-- Question 2: Tạo trigger Không cho phép người dùng thêm bất kỳ user nào vào
-- department "Sale" nữa, khi thêm thì hiện ra thông báo "Department
-- "Sale" cannot add more user"
DROP TRIGGER IF EXISTS trigger_cannot_input_user;
DELIMITER $$
CREATE TRIGGER trigger_cannot_input_user
	BEFORE INSERT ON `account`
		FOR EACH ROW
			BEGIN
				DECLARE IdSales TINYINT;
                	SELECT department_id INTO IdSales
					FROM department 
                    WHERE department_name = 'Sales';
				if new.department_id = IdSales
				THEN SIGNAL SQLSTATE '12345' SET MESSAGE_TEXT = 'Department Sales cannot add more user';
                END IF;
			END$$
DELIMITER ;
                
select * from department;
SELECT * FROM `account`;
INSERT INTO `account`(email,username,fullname,department_id,position_id,create_date)
VALUE	(N'tranphuongthuy@gmail.vn', N'tranthuy', N'tran phuong thuy', 2, 9, '2020-10-31');

-- Question 3: Cấu hình 1 group có nhiều nhất là 5 user
DROP TRIGGER IF EXISTS trigger_group_max_5user;
DELIMITER $$
CREATE TRIGGER trigger_group_max_5user
	BEFORE INSERT ON group_account
		FOR EACH ROW
			BEGIN 
				DECLARE countacc SMALLINT;
					SELECT group_id,count(account_id)  INTO countacc
					FROM group_account
                    WHERE group_id = new.group_id
					GROUP BY group_id;
				if countacc >= 5 THEN SIGNAL SQLSTATE '12345' SET MESSAGE_TEXT = 'khong hop le';
				END IF;
            END$$
DELIMITER ;
SELECT * FROM group_account;
INSERT INTO group_account(group_id,account_id,join_date)
VALUES   ( 1, 8, '2021-10-29');

-- Question 4: Cấu hình 1 bài thi có nhiều nhất là 10 Question
DROP TRIGGER IF EXISTS trigger_exam_max_10_question;
DELIMITER $$
CREATE TRIGGER trigger_exam_max_10_question
	BEFORE INSERT ON exam_question
		FOR EACH ROW
			BEGIN 
				DECLARE countquestion TINYINT;
					SELECT count(question_id) INTO countquestion
					FROM exam_question
					WHERE exam_id = new.exam_id
					GROUP BY exam_id;
                IF countquestion >= 10 THEN SIGNAL SQLSTATE '12345' 
                SET MESSAGE_TEXT = 'max question';
                END IF;
			END$$
DELIMITER ;
   
SELECT * FROM exam_question;
INSERT INTO exam_question(exam_id,question_id)
VALUE (1,2);

-- Question 5: Tạo trigger không cho phép người dùng xóa tài khoản có email là
-- admin@gmail.com (đây là tài khoản admin, không cho phép user xóa),
-- còn lại các tài khoản khác thì sẽ cho phép xóa và sẽ xóa tất cả các thông
-- tin liên quan tới user đó
INSERT INTO `account`(email,username,fullname,department_id,position_id,create_date)
VALUE  ('admin@gmail.com', 'admin' , 'admin1', 2, 1, '2021-10-31');
DROP TRIGGER IF EXISTS trigger_no_deleting_admin_email;
DELIMITER $$
CREATE TRIGGER trigger_no_deleting_admin_email
	BEFORE DELETE ON `account`
		FOR EACH ROW
			BEGIN 
				DECLARE admin_id TINYINT;
					SELECT account_id INTO admin_id
					FROM `account`
					WHERE email LIKE 'admin%';
				IF old.account_id = admin_id THEN SIGNAL SQLSTATE '12345'
                SET MESSAGE_TEXT = 'đây là tài khoản admin, không cho phép user xóa';
                END IF;
			END$$
DELIMITER ;

SELECT * FROM `account`;
DELETE FROM `account` WHERE email = 'admin@gmail.com';

-- Question 6: Không sử dụng cấu hình default cho field DepartmentID của table account
-- hãy tạo trigger cho phép người dùng khi tạo account không điền
-- vào departmentID thì sẽ được phân vào phòng ban "waiting Department"
SELECT * FROM department;
INSERT INTO department(department_name) VALUE ('waiting Department');

DROP TRIGGER IF EXISTS trigger_waiting_Department;
DELIMITER $$
CREATE TRIGGER trigger_waiting_Department
	BEFORE INSERT ON `account` 
		FOR EACH ROW
			BEGIN
				DECLARE waitingD_id TINYINT;
					SELECT department_id  INTO waitingD_id
					FROM department
					WHERE department_name = 'waiting Department';
				IF new.department_id IS NULL THEN SET new.department_id = waitingD_id;
                END IF;
			END$$
DELIMITER ;

SELECT * FROM `account`;
INSERT INTO `account`(email,username,fullname,position_id,create_date)
VALUE ( 'new1@gmail.com', 'new1', 'obama', 4,'2021-10-30');

-- Question 7: Cấu hình 1 bài thi chỉ cho phép user tạo tối đa 4 answers cho mỗi
-- question, trong đó có tối đa 2 đáp án đúng.



-- Question 8: Viết trigger sửa lại dữ liệu cho đúng:
-- Nếu người dùng nhập vào gender của account là nam, nữ, chưa xác định
-- Thì sẽ đổi lại thành M, F, U cho giống với cấu hình ở database
-- Question 9: Viết trigger không cho phép người dùng xóa bài thi mới tạo được 2 ngày
-- Question 10: Viết trigger chỉ cho phép người dùng chỉ được update, delete các
-- question khi question đó chưa nằm trong exam nào
-- Question 12: Lấy ra thông tin exam trong đó:

-- Duration <= 30 thì sẽ đổi thành giá trị "Short time"
-- 30 < Duration <= 60 thì sẽ đổi thành giá trị "Medium time"
-- Duration > 60 thì sẽ đổi thành giá trị "Long time"

-- Question 13: Thống kê số account trong mỗi group và in ra thêm 1 column nữa có tên
-- là the_number_user_amount và mang giá trị được quy định như sau:

-- 2

-- Nếu số lượng user trong group =< 5 thì sẽ có giá trị là few
-- Nếu số lượng user trong group <= 20 và > 5 thì sẽ có giá trị là normal
-- Nếu số lượng user trong group > 20 thì sẽ có giá trị là higher
-- Question 14: Thống kê số mỗi phòng ban có bao nhiêu user, nếu phòng ban nào
-- không có user thì sẽ thay đổi giá trị 0 thành "Không có User"
