-- Script thêm Quản Trị Viên mặc định
-- Lưu ý: Password hash sẽ được tạo bằng code C# khi chạy ứng dụng lần đầu

USE UngDungDiemDanhNhanVien;
GO

-- Xóa admin cũ nếu có
DELETE FROM QuanTriVien WHERE TenDangNhap = 'admin';
GO

-- Thêm admin mới
-- Password: admin123
-- Hash được tạo bằng BCrypt trong C# code
INSERT INTO QuanTriVien (TenDangNhap, MatKhauHash, Email, VaiTro, NgayTao)
VALUES (
    'admin',
    '$2a$11$placeholder', -- Sẽ được cập nhật khi chạy app
    'admin@congty.com',
    'Admin',
    GETDATE()
);
GO

PRINT N'✅ Tài khoản admin đã được tạo';
PRINT N'📧 Email: admin@congty.com';
PRINT N'🔑 Password: admin123';
PRINT N'⚠️ Lưu ý: Vui lòng chạy ứng dụng để cập nhật password hash';
GO
