-- Script thêm tính năng NFC cho hệ thống điểm danh
-- Ngày tạo: 2025-10-22
-- Mô tả: Thêm cột MaTheNFC vào bảng NhanVien để lưu UID thẻ NFC

USE UngDungDiemDanhNhanVien;
GO

-- Kiểm tra nếu cột chưa tồn tại thì mới thêm
IF NOT EXISTS (SELECT * FROM sys.columns 
               WHERE object_id = OBJECT_ID(N'[dbo].[NhanVien]') 
               AND name = 'MaTheNFC')
BEGIN
    -- Thêm cột MaTheNFC
    ALTER TABLE NhanVien
    ADD MaTheNFC NVARCHAR(50) NULL;
    PRINT 'Đã thêm cột MaTheNFC vào bảng NhanVien';
END
ELSE
BEGIN
    PRINT 'Cột MaTheNFC đã tồn tại';
END
GO

-- Tạo index để tìm kiếm nhanh theo MaTheNFC
IF NOT EXISTS (SELECT * FROM sys.indexes 
               WHERE name = 'IX_NhanVien_MaTheNFC' 
               AND object_id = OBJECT_ID('NhanVien'))
BEGIN
    CREATE INDEX IX_NhanVien_MaTheNFC ON NhanVien(MaTheNFC);
    PRINT 'Đã tạo index IX_NhanVien_MaTheNFC';
END
ELSE
BEGIN
    PRINT 'Index IX_NhanVien_MaTheNFC đã tồn tại';
END
GO

-- Thêm constraint unique (mỗi thẻ chỉ gán cho 1 nhân viên)
IF NOT EXISTS (SELECT * FROM sys.key_constraints 
               WHERE name = 'UQ_NhanVien_MaTheNFC')
BEGIN
    ALTER TABLE NhanVien
    ADD CONSTRAINT UQ_NhanVien_MaTheNFC UNIQUE(MaTheNFC);
    PRINT 'Đã thêm constraint UNIQUE cho MaTheNFC';
END
ELSE
BEGIN
    PRINT 'Constraint UQ_NhanVien_MaTheNFC đã tồn tại';
END
GO

-- Thống kê số nhân viên đã/chưa đăng ký thẻ NFC
SELECT 
    COUNT(*) AS TongNhanVien,
    COUNT(MaTheNFC) AS DaDangKyNFC,
    COUNT(*) - COUNT(MaTheNFC) AS ChuaDangKyNFC
FROM NhanVien
WHERE TrangThai = 'HoatDong';
GO

PRINT 'Hoàn thành cập nhật database cho tính năng NFC!';

