DESCRIBE `account`;
DESCRIBE department;

-- Question 1: Tạo store để người dùng nhập vào tên phòng ban và in ra tất cả các account thuộc phòng ban đó

DROP PROCEDURE IF EXISTS sp_ten_phong_ban;
DELIMITER $$
CREATE PROCEDURE sp_ten_phong_ban(IN in_department_name VARCHAR(30) CHAR SET utf8mb4)
	BEGIN
		SELECT ac.account_id,ac.fullname 
        FROM `account` ac
        JOIN department de ON ac.department_id = de.department_id
        WHERE de.department_name = in_department_name;
	END$$
DELIMITER ;
CALL sp_ten_phong_ban('sale');

-- Question 2: Tạo store để in ra số lượng account trong mỗi group
DROP PROCEDURE IF EXISTS sp_so_account_moi_group;
DELIMITER $$
CREATE PROCEDURE sp_so_account_moi_group()
	BEGIN
		SELECT count(account_id) AS so_account_moi_group ,group_name
        FROM group_account grac
        JOIN `group` gr ON grac.group_id = gr.group_id
        GROUP BY grac.group_id;
	END$$
DELIMITER ;

CALL sp_so_account_moi_group();

-- Question 3: Tạo store để thống kê mỗi type question có bao nhiêu question được tạo trong tháng hiện tại
DROP PROCEDURE IF EXISTS so_question_tao_trong_thang_hien_tai;
DELIMITER $$
CREATE PROCEDURE so_question_tao_trong_thang_hien_tai()
	BEGIN
		SELECT type_name,count(q.type_id) AS count_question_this_month
		FROM type_question tq
		JOIN question q ON tq.type_id = q.type_id
		WHERE month(q.create_date) = month(current_time()) AND year(q.create_date) = year(current_time())
		GROUP BY q.type_id;
	END$$
DELIMITER ;
CALL so_question_tao_trong_thang_hien_tai();

-- Question 4: Tạo store để trả ra id của type question có nhiều câu hỏi nhất
DROP PROCEDURE IF EXISTS type_question_nhieu_cau_hoi_nhat;
DELIMITER $$
CREATE PROCEDURE type_question_nhieu_cau_hoi_nhat(OUT out_typeid TINYINT)
		SELECT tq.type_id INTO out_typeid
		FROM type_question tq
		JOIN question q ON tq.type_id = q.type_id
		GROUP BY q.type_id
		HAVING count(q.question_id) = (
			SELECT max(so_question)
			FROM (
					SELECT count(q.question_id) AS so_question
					FROM testing_system.question q
					GROUP BY q.type_id) AS tab_so_question
		);
	END$$
DELIMITER ;
SET @out_typeid = 0;	
CALL type_question_nhieu_cau_hoi_nhat(@out_typeid);
SELECT @out_typeid;

-- Question 5: Sử dụng store ở question 4 để tìm ra tên của type question
DROP PROCEDURE IF EXISTS p_typequestion_namebyid;
DELIMITER $$
CREATE PROCEDURE sp_typequestion_namebyid()
	BEGIN
		DECLARE out_typeid TINYINT;
        SET out_typeid = 0;
        CALL type_question_nhieu_cau_hoi_nhat(out_typeid);
        SELECT type_name FROM type_question WHERE type_id = out_typeid;
	END$$
DELIMITER ;

CALL sp_typequestion_namebyid();

-- Question 6: Viết 1 store cho phép người dùng nhập vào 1 chuỗi và trả về group có tên
-- chứa chuỗi của người dùng nhập vào hoặc trả về user có username chứa chuỗi của người dùng nhập vào
DROP PROCEDURE IF EXISTS sp_input_group;
DELIMITER $$
CREATE PROCEDURE sp_input_group(IN input VARCHAR(50))
	BEGIN 
		SELECT g.group_name AS 'ket qua'
		FROM `group` g
        WHERE g.group_name LIKE 
			concat("%",input,"%")
		UNION ALL
		SELECT a.username
        FROM `account` a
		WHERE a.username LIKE
			concat("%",input,"%");
	END$$
DELIMITER ;

CALL sp_input_group('');

-- Question 7: Viết 1 store cho phép người dùng nhập vào thông tin fullName, email và trong store sẽ tự động gán:
-- username sẽ giống email nhưng bỏ phần @..mail đi
-- positionID: sẽ có default là developer
-- departmentID: sẽ được cho vào 1 phòng chờ
-- Sau đó in ra kết quả tạo thành công
DROP PROCEDURE IF EXISTS sp_nhap_user;
DELIMITER $$
CREATE PROCEDURE sp_nhap_user(IN fullname VARCHAR(50) CHAR SET utf8mb4, IN email VARCHAR(50))
	BEGIN
		DECLARE userName VARCHAR(50) DEFAULT substring_index(email,'@',1);
        DECLARE departmentId TINYINT UNSIGNED DEFAULT 8;
        DECLARE positionId TINYINT UNSIGNED DEFAULT 1;
        DECLARE createDate DATETIME DEFAULT curdate();
        INSERT INTO `account`(email,username,fullname,department_id,position_id,create_date)
			VALUES(email,userName,fullname,departmentId,positionId,createDate);
		SELECT * FROM `account` ORDER BY account_id DESC LIMIT 1;
	END$$
DELIMITER ;

CALL sp_nhap_user('','');
		
-- Question 8: Viết 1 store cho phép người dùng nhập vào Essay hoặc Multiple-Choice 
-- để thống kê câu hỏi essay hoặc multiple-choice nào có content dài nhất
DROP PROCEDURE IF EXISTS sp_typequestion_have_the_longest_content;
DELIMITER $$
CREATE PROCEDURE sp_typequestion_have_the_longest_content(IN input_typequestion ENUM('essay','multiple-choice'))
	BEGIN
		SELECT tq.type_name,q.question_id,q.content
		FROM question q JOIN type_question tq ON q.type_id = tq.type_id
        WHERE length(q.content) = (
			SELECT max(length_content) AS max_length_content
			FROM (
				SELECT q.content,q.question_id,tq.type_name,length(content) AS length_content
				FROM question q JOIN type_question tq ON q.type_id = tq.type_id
                WHERE tq.type_name = input_typequestion) AS tab_length_content	)
			AND tq.type_name = input_typequestion;
	END$$
DELIMITER ;
CALL sp_typequestion_have_the_longest_content('multiple-choice');
CALL sp_typequestion_have_the_longest_content('essay');

-- Question 9: Viết 1 store cho phép người dùng xóa exam dựa vào ID
DROP PROCEDURE IF EXISTS sp_delete_exam_by_id;
DELIMITER $$
CREATE PROCEDURE sp_delete_exam_by_id(IN examId TINYINT)
	BEGIN
		DELETE
		FROM exam
		WHERE exam_id = examID;
	END$$
DELIMITER ;

CALL sp_delete_exam_by_id();

-- Question 10: Tìm ra các exam được tạo từ 3 năm trước và xóa các exam đó đi (sử dụng store ở câu 9 để xóa)
-- Sau đó in số lượng record đã remove từ các table liên quan trong khi removing
-- SELECT ROW_COUNT();
INSERT INTO exam(`code`, title, category_id, duration, creator_id, create_date) 
VALUES 
	('RB1'	, 'title ruby1'		, 5		, 50	, 1		, '2018-05-05'),
	('VB1'	, 'title vb 11'		, 6		, 120	, 3		, '2017-06-15'),
	('VB61'	, 'title vb6 11'	, 6		, 120	, 3		, '2016-06-15');

drop procedure if exists sp_delete_exam_and_select_count_record;
DELIMITER $$
create procedure sp_delete_exam_and_select_count_record()
begin
	declare examId tinyint;
    declare delRowCntExam tinyint;
    declare delRowCntExamQuestion tinyint;

    -- biến để xem cursor đã đến dòng cuối chưa
	declare done boolean default false;
    -- tạo cursor các exam được tạo từ 3 năm trước
	declare myCursor cursor for
    select exam_id from exam where year(create_date) <= year(date_add(curdate(), interval -3 year));
    
    -- điều khiển hoạt động của cursor khi đến dòng cuối(set là true)
	declare continue handler for not found set done = true;  
    
    -- đếm số dòng sẽ xóa của bảng exam, exam_question
    select count(e.exam_id) cnt_ex into delRowCntExam
	from exam e
	where year(create_date) <= year(date_add(curdate(), interval -3 year));
    
    select count(eq.exam_id) cnt_ex_ques into delRowCntExamQuestion
	from exam e
	left join exam_question eq on e.exam_id = eq.exam_id
	where year(create_date) <= year(date_add(curdate(), interval -3 year));
    
    -- sử dụng store ở câu 9 để xóa
	-- mở cursor
	open myCursor;
		-- lặp từng dòng
		read_loop: loop
			-- đọc từng dòng của cursor
			fetch myCursor into examId;
			
			-- xóa dlieu
			call sp_delete_exam_by_id(examId);

			-- đến dòng cuối thì thoát đọc loop
			if done then
			  leave read_loop;
			end if;
		end loop;
	  
	-- đóng cursor
	close myCursor;	
    select concat('exam table ', delRowCntExam, ' record', ', exam_question table ', delRowCntExamQuestion, ' record') as 'số lượng record đã remove';
end$$
DELIMITER ;
-- gọi thủ tục
call sp_delete_exam_and_select_count_record();

-- Question 11: Viết store cho phép người dùng xóa phòng ban bằng cách người dùng
-- nhập vào tên phòng ban và các account thuộc phòng ban đó sẽ được chuyển về phòng ban default là phòng ban chờ việc
DROP PROCEDURE IF EXISTS sp_delete_department_by_departmentname;
DELIMITER $$
CREATE PROCEDURE sp_delete_department_by_departmentname(IN input_departmentname VARCHAR(50) CHAR SET utf8mb4 )
	BEGIN
		UPDATE `account`
        SET department_id = (SELECT department_id
				FROM department
                WHERE department_name = 'phong cho')
		WHERE department_id = (SELECT department_id
				FROM department
                WHERE department_name = input_departmentname);
		DELETE
        FROM department
        WHERE department_name = input_departmentname;
    END$$
DELIMITER ;

CALL sp_delete_department_by_departmentname();

-- Question 12: Viết store để in ra mỗi tháng có bao nhiêu câu hỏi được tạo trong năm nay


-- Question 13: Viết store để in ra mỗi tháng có bao nhiêu câu hỏi được tạo trong 6 tháng gần đây nhất
-- (Nếu tháng nào không có thì sẽ in ra là "không có câu hỏi nào trong tháng")

