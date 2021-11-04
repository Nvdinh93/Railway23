
-- 1. Tạo Bảng và thêm tối thiểu 5 bản ghi cho mỗi Bảng

DROP DATABASE IF EXISTS Quan_Ly_Dat_Phong_Karaoke;
CREATE DATABASE Quan_Ly_Dat_Phong_Karaoke;
USE Quan_Ly_Dat_Phong_Karaoke;

ALTER DATABASE Quan_Ly_Dat_Phong_Karaoke CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

DROP TABLE IF EXISTS Phong;
CREATE TABLE Phong(
	MaPhong		SMALLINT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    LoaiPhong	VARCHAR(10) CHAR SET utf8mb4 UNIQUE KEY NOT NULL,
    SoKhachToiDa TINYINT NOT NULL,
    GiaPhong	DECIMAL(8,0) NOT NULL,
    MoTa		VARCHAR(255)
    );
INSERT INTO Phong(LoaiPhong, SoKhachToiDa, GiaPhong)
VALUES		( 'Loai 1', 10, 500000),
			( 'Loai 2', 20, 700000),
            ( 'Loai 3', 30, 900000),
            ( 'Cao Cap', 40, 1200000),
            ('VIP', 50, 1500000);
            
DROP TABLE IF EXISTS Khach_Hang;
CREATE TABLE Khach_Hang(
	MaKh	MEDIUMINT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    TenKh	VARCHAR(50) CHAR SET utf8mb4 NOT NULL,
    DiaChi	VARCHAR(100) CHAR SET utf8mb4,
    SoDT	CHAR(15) NOT NULL UNIQUE
);
INSERT INTO Khach_Hang(TenKH, SoDT)
VALUES		( 'Nguyen Khanh Linh', 080812856),
			( 'tran van b', 09098765432),
            ( 'cao van c', 02100223471),
            ( 'nguyen thi d', 0707157634),
            ( 'nguyen van e', 09091234567);
            
DROP TABLE IF EXISTS Dat_Phong;
CREATE TABLE Dat_Phong(
	MaDatPhong	MEDIUMINT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    MaPhong		SMALLINT NOT NULL,
    MaKH		MEDIUMINT NOT NULL,
    NgayDat		DATE NOT NULL,
    TienDatCoc	DECIMAL(8,0) NOT NULL,
    GhiChu		VARCHAR(255) CHAR SET utf8mb4,
    TrangThaiDat ENUM('đã đặt','đã hủy') NOT NULL,
     FOREIGN KEY (MaPhong) REFERENCES Phong(MaPhong),
     FOREIGN KEY (MaKh) REFERENCES Khach_Hang(MaKh)
    );
INSERT INTO Dat_Phong( MaPhong, MaKH, NgayDat, TienDatCoc, TrangThaiDat)
VALUES		( 1, 1, '2020-10-10', '500000', 'đã đặt'),
			( 1, 2, '2020-10-10', '500000', 'đã đặt'),
			( 2, 3, '2021-10-11', '1000000', 'đã đặt'),
            ( 3, 1, '2020-10-12', '500000', 'đã hủy'),
            ( 4, 5, '2021-10-13', '500000', 'đã hủy');

DROP TABLE IF EXISTS Dich_Vu_Di_Kem;
CREATE TABLE Dich_Vu_Di_Kem(
	MaDV	TINYINT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    TenDV	VARCHAR(50) UNIQUE NOT NULL,
    DonViTinh VARCHAR(10) NOT NULL,
    DonGia	DECIMAL(7,0)
);
INSERT INTO Dich_Vu_Di_Kem( TenDV, DonViTinh, DonGia)
VALUES		( 'Bia', 'Chai', 20000),
			( 'Nước ngọt', 'Chai', 10000),
            ( 'Trái cây', 'Đĩa', 50000),
            ( 'Khăn ướt', 'Cái', 5000),
            ( 'Mực khô', 'Con', 50000);
            
DROP TABLE IF EXISTS Chi_Tiet_Su_Dung_Dich_Vu;
CREATE TABLE Chi_Tiet_Su_Dung_Dich_Vu(
	MaDatPhong	MEDIUMINT NOT NULL,
    MaDV		TINYINT NOT NULL,
    SoLuong		TINYINT NOT NULL,
    PRIMARY KEY(MaDatPhong,MaDV),
    FOREIGN KEY (MaDatPhong) REFERENCES Dat_Phong(MaDatPhong),
    FOREIGN KEY (MaDV) REFERENCES Dich_Vu_Di_Kem(MaDV)
);
INSERT INTO Chi_Tiet_Su_Dung_Dich_Vu(MaDatPhong,MaDV,SoLuong)
VALUES		( 1, 1, 2),
			( 1, 2, 3),
            ( 2, 1, 4),
            ( 3, 3, 2),
            ( 4, 4, 5),
            ( 5, 5, 1);
            
-- 2. Hiển thị loại phòng đã thuê, tên dịch vụ đã sử dụng của khách hàng có tên là “Nguyễn Khánh Linh”

SELECT p.LoaiPhong,dv.TenDV FROM Dat_Phong dp
JOIN Phong p ON dp.MaPhong = p.MaPhong
JOIN Khach_Hang kh ON dp.MaKH = kh.MaKH
JOIN Chi_Tiet_Su_Dung_Dich_Vu ct ON dp.MaDatPhong = ct.MaDatPhong
JOIN Dich_Vu_Di_Kem dv ON ct.MaDV = dv.MaDV
WHERE TenKH = 'Nguyen Khanh Linh';   

-- 3. Viết Function để trả về Số điện thoại của Khách hàng thuê nhiều phòng nhất trong năm 2020

SELECT * FROM Dat_Phong;
SELECT * FROM Khach_Hang;    

DROP FUNCTION IF EXISTS Sdt_Khach_Thue_Nhieu_Nhat;
DELIMITER $$
CREATE FUNCTION Sdt_Khach_Thue_Nhieu_Nhat(Sdt_KH CHAR(15)) RETURNS CHAR(15)
		BEGIN
			DECLARE sdt_kh TINYINT;
				SELECT kh.SoDT
				FROM Dat_Phong dp
				JOIN Khach_Hang kh ON dp.MaKH = kh.MaKH
                GROUP BY dp.MaKH
                HAVING count(MaDatPhong) = ( 
					SELECT MAX(countsolanthue)
					FROM ( SELECT count(MaDatPhong) AS countsolanthue
							FROM Dat_Phong
							WHERE year(NgayDat) = '2020'
							GROUP BY MaKH) AS tabsolanthue
						);
				RETURN sdt_kh;
			END$$
DELIMITER ;

-- 4. Viết thủ tục tăng giá phòng thêm 10,000 VNĐ so với giá phòng hiện tại cho những phòng có số khách
-- tối đa lớn hơn 5.


-- 5. Viết thủ tục thống kê khách hàng và số lần thuê phòng tương ứng của từng khách hàng trong năm
-- nay.
SELECT * FROM Dat_Phong;
SELECT * FROM Khach_Hang;    

DROP PROCEDURE IF EXISTS sp_kh_thue_nam_nay;
DELIMITER $$
CREATE PROCEDURE sp_kh_thue_nam_nay()
	BEGIN 
		SELECT dp.MaKH,TenKh,count(MaDatPhong) AS solanthue
        FROM Dat_Phong dp
        JOIN Khach_Hang kh ON dp.MaKH = kh.MaKH
        WHERE year(NgayDat) = year(curdate())
        GROUP BY dp.MaKH;
	END$$
DELIMITER ;

CALL sp_kh_thue_nam_nay();

-- 6. Viết thủ tục hiển thị 5 đơn đặt phòng gần nhất bao gồm có các thông tin: Mã đặt phòng, tên khách
-- hàng, loại phòng, giá phòng.

-- 7. Viết Trigger kiểm tra khi thêm phòng mới có Số khách tối đa vượt quá 10 người thì không cho thêm
-- mới và hiển thị thông báo “Vượt quá số người cho phép”.
SELECT * FROM Dat_Phong;
SELECT * FROM Phong; 

DROP TRIGGER IF EXISTS trigger_sokhachtoida;
DELIMITER $$
CREATE TRIGGER trigger_sokhachtoida
	BEFORE INSERT ON Dat_Phong
		FOR EACH ROW
			BEGIN
				DECLARE sokhachtoida TINYINT;
                SELECT count(MaDatPhong) 
                FROM Dat_Phong
                GROUP BY MaKH
				
				
				
                                            
			