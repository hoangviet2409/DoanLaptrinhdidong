-- =============================================
-- Script Backup và Restore Database
-- Ứng dụng Điểm Danh Nhân Viên
-- Tạo bởi: NHViet
-- Ngày: 2025-01-20
-- =============================================

-- =============================================
-- 1. BACKUP DATABASE
-- =============================================

-- Backup toàn bộ database
DECLARE @BackupPath NVARCHAR(500)
DECLARE @DatabaseName NVARCHAR(100) = 'UngDungDiemDanhNhanVien'
DECLARE @BackupFileName NVARCHAR(500)

-- Tạo tên file backup với timestamp
SET @BackupFileName = @DatabaseName + '_Backup_' + 
    FORMAT(GETDATE(), 'yyyyMMdd_HHmmss') + '.bak'

-- Đường dẫn backup (thay đổi theo môi trường của bạn)
SET @BackupPath = 'C:\Backup\' + @BackupFileName

-- Tạo thư mục backup nếu chưa tồn tại
DECLARE @CreateDirCmd NVARCHAR(1000)
SET @CreateDirCmd = 'IF NOT EXIST "C:\Backup" MKDIR "C:\Backup"'
EXEC xp_cmdshell @CreateDirCmd

-- Thực hiện backup
BACKUP DATABASE [UngDungDiemDanhNhanVien] 
TO DISK = @BackupPath
WITH 
    FORMAT,
    INIT,
    NAME = N'UngDungDiemDanhNhanVien-Full Database Backup',
    SKIP,
    NOREWIND,
    NOUNLOAD,
    STATS = 10

PRINT 'Backup hoàn thành: ' + @BackupPath
GO

-- =============================================
-- 2. BACKUP CÁC BẢNG QUAN TRỌNG
-- =============================================

-- Backup bảng NhanVien
SELECT * INTO [NhanVien_Backup] FROM [NhanVien]
PRINT 'Đã backup bảng NhanVien'

-- Backup bảng DiemDanh
SELECT * INTO [DiemDanh_Backup] FROM [DiemDanh]
PRINT 'Đã backup bảng DiemDanh'

-- Backup bảng QuanTriVien
SELECT * INTO [QuanTriVien_Backup] FROM [QuanTriVien]
PRINT 'Đã backup bảng QuanTriVien'

-- Backup bảng Luong
SELECT * INTO [Luong_Backup] FROM [Luong]
PRINT 'Đã backup bảng Luong'

-- Backup bảng NhatKyEmail
SELECT * INTO [NhatKyEmail_Backup] FROM [NhatKyEmail]
PRINT 'Đã backup bảng NhatKyEmail'

GO

-- =============================================
-- 3. EXPORT DỮ LIỆU RA FILE CSV
-- =============================================

-- Export danh sách nhân viên
DECLARE @ExportCmd NVARCHAR(1000)
SET @ExportCmd = 'bcp "SELECT * FROM UngDungDiemDanhNhanVien.dbo.NhanVien" queryout "C:\Backup\NhanVien.csv" -c -t"," -r"\n" -S' + @@SERVERNAME + ' -T'
EXEC xp_cmdshell @ExportCmd

-- Export điểm danh
SET @ExportCmd = 'bcp "SELECT * FROM UngDungDiemDanhNhanVien.dbo.DiemDanh" queryout "C:\Backup\DiemDanh.csv" -c -t"," -r"\n" -S' + @@SERVERNAME + ' -T'
EXEC xp_cmdshell @ExportCmd

PRINT 'Đã export dữ liệu ra file CSV'

GO

-- =============================================
-- 4. RESTORE DATABASE (VÍ DỤ)
-- =============================================

/*
-- Uncomment để sử dụng khi cần restore

-- Restore database từ backup
RESTORE DATABASE [UngDungDiemDanhNhanVien_Restore] 
FROM DISK = 'C:\Backup\UngDungDiemDanhNhanVien_Backup_20250120_143000.bak'
WITH 
    MOVE 'UngDungDiemDanhNhanVien' TO 'C:\Data\UngDungDiemDanhNhanVien_Restore.mdf',
    MOVE 'UngDungDiemDanhNhanVien_Log' TO 'C:\Data\UngDungDiemDanhNhanVien_Restore_Log.ldf',
    REPLACE

PRINT 'Restore hoàn thành'
*/

-- =============================================
-- 5. RESTORE TỪ BACKUP TABLES
-- =============================================

/*
-- Uncomment để sử dụng khi cần restore từ backup tables

-- Restore bảng NhanVien
DELETE FROM [NhanVien]
INSERT INTO [NhanVien] SELECT * FROM [NhanVien_Backup]
PRINT 'Đã restore bảng NhanVien'

-- Restore bảng DiemDanh
DELETE FROM [DiemDanh]
INSERT INTO [DiemDanh] SELECT * FROM [DiemDanh_Backup]
PRINT 'Đã restore bảng DiemDanh'

-- Restore bảng QuanTriVien
DELETE FROM [QuanTriVien]
INSERT INTO [QuanTriVien] SELECT * FROM [QuanTriVien_Backup]
PRINT 'Đã restore bảng QuanTriVien'

-- Restore bảng Luong
DELETE FROM [Luong]
INSERT INTO [Luong] SELECT * FROM [Luong_Backup]
PRINT 'Đã restore bảng Luong'

-- Restore bảng NhatKyEmail
DELETE FROM [NhatKyEmail]
INSERT INTO [NhatKyEmail] SELECT * FROM [NhatKyEmail_Backup]
PRINT 'Đã restore bảng NhatKyEmail'
*/

-- =============================================
-- 6. IMPORT DỮ LIỆU TỪ FILE CSV
-- =============================================

/*
-- Uncomment để sử dụng khi cần import từ CSV

-- Import nhân viên từ CSV
BULK INSERT [NhanVien]
FROM 'C:\Backup\NhanVien.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
)

-- Import điểm danh từ CSV
BULK INSERT [DiemDanh]
FROM 'C:\Backup\DiemDanh.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
)

PRINT 'Đã import dữ liệu từ CSV'
*/

-- =============================================
-- 7. CLEANUP BACKUP TABLES
-- =============================================

/*
-- Uncomment để xóa các bảng backup sau khi đã restore

DROP TABLE [NhanVien_Backup]
DROP TABLE [DiemDanh_Backup]
DROP TABLE [QuanTriVien_Backup]
DROP TABLE [Luong_Backup]
DROP TABLE [NhatKyEmail_Backup]

PRINT 'Đã xóa các bảng backup'
*/

-- =============================================
-- 8. THỐNG KÊ BACKUP
-- =============================================

PRINT '=== THỐNG KÊ BACKUP ==='
PRINT 'Thời gian backup: ' + CONVERT(VARCHAR, GETDATE(), 120)
PRINT 'Database: UngDungDiemDanhNhanVien'
PRINT 'Số lượng nhân viên: ' + CAST((SELECT COUNT(*) FROM [NhanVien]) AS VARCHAR(10))
PRINT 'Số lượng điểm danh: ' + CAST((SELECT COUNT(*) FROM [DiemDanh]) AS VARCHAR(10))
PRINT 'Số lượng quản trị viên: ' + CAST((SELECT COUNT(*) FROM [QuanTriVien]) AS VARCHAR(10))
PRINT 'Số lượng bản ghi lương: ' + CAST((SELECT COUNT(*) FROM [Luong]) AS VARCHAR(10))
PRINT 'Số lượng email: ' + CAST((SELECT COUNT(*) FROM [NhatKyEmail]) AS VARCHAR(10))

-- Hiển thị kích thước database
SELECT 
    DB_NAME() AS DatabaseName,
    CAST(SUM(CAST(FILEPROPERTY(name, 'SpaceUsed') AS bigint) * 8192.) / 1024 / 1024 AS DECIMAL(15,2)) AS 'Database Size (MB)'
FROM sys.database_files
WHERE type IN (0,1)

PRINT ''
PRINT '=== HOÀN THÀNH BACKUP ==='
PRINT 'Các file backup đã được tạo trong thư mục C:\Backup\'
PRINT 'Bạn có thể sử dụng các file này để restore khi cần thiết'
GO
