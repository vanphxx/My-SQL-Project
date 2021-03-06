--
USE DBIASSIGNMENT
GO

-- View source code: Xem được một phần của user profile để hiểu rõ hơn về những thông tin cơ bản của user, thông qua đó dễ kết bạn làm quen và xác định vào đúng group
-- Ý nghĩa của View: Cho phép người quản trị CSDL cung cấp cho người dùng những thông tin cần thiết và tiện trong những câu truy vấn phức tạp
CREATE VIEW USER_VIEW AS 
SELECT USERID, DOB, GENDER, HOBBIES FROM [dbo].[USER_PROFILE] WHERE USERID IS NOT NULL 
SELECT * FROM USER_VIEW

--Store procedure: Nghiệp vụ: 
				/* 1. chứa câu lệnh SQL để hoàn thành một tác vụ và thủ tục sẽ nhanh hơn câu lệnh
				   2. có thể sử dụng lại nhiều lần.
				   3. Đảm bảo vấn đề bảo mật
				   4. Tiết kiệm băng thông
				   */
-- Source code: Câu lệnh trả về số tuổi và giới tính của user để có thể sắp xếp user vào các nhóm và duyệt vào group phù hợp
CREATE PROCEDURE sp_usersage
AS
BEGIN 
SELECT [USERID], [DOB], [GENDER] from [dbo].[USER_PROFILE] ORDER BY USERID
END;

EXECUTE sp_usersage

-- Function source code: Tìm tất cả thông tin của các post trong group để khi cần có thể kiểm định nội dung người dùng post lên
CREATE FUNCTION UF_SELECTALLPOST ()
RETURNS TABLE
AS RETURN SELECT * FROM GROUP_POST
GO

SELECT * FROM UF_SELECTALLPOST ()

--Trigger: được gọi mỗi khi có thao tác đổi thông tin bảng; để kiểm tra ràng buộc trên nhiều quan hệ hoặc trên nhiều dòng của bảng.
CREATE TRIGGER tr_INSERTUSERPROFILE ON [dbo].[USER_PROFILE] 
FOR INSERT, UPDATE
AS
BEGIN
 ROLLBACK TRAN  
 PRINT 'TRIGGER'
END
GO

-- Test case của trigger:
UPDATE [dbo].[USER_PROFILE] SET GENDER = 0 where [PROFILE_ID] = 'P001'
SELECT * FROM [dbo].[USER_PROFILE]

CREATE TRIGGER tr_PreventAlterTable
ON DATABASE
FOR ALTER_TABLE
AS
	PRINT N'Không được phép sửa bảng'
	ROLLBACK
GO

-- Test case của trigger:
Alter table [dbo].[USER_PROFILE] Add School Nvarchar(100)