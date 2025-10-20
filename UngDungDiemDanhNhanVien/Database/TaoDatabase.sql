-- Tạo database
USE master;
GO

IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'UngDungDiemDanhNhanVien')
BEGIN
    CREATE DATABASE UngDungDiemDanhNhanVien;
END
GO

USE UngDungDiemDanhNhanVien;
GO

-- Bảng QuanTriVien
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'QuanTriVien')
BEGIN
    CREATE TABLE QuanTriVien (
        Id INT PRIMARY KEY IDENTITY(1,1),
        TenDangNhap NVARCHAR(50) NOT NULL UNIQUE,
        MatKhauHash NVARCHAR(255) NOT NULL,
        Email NVARCHAR(100) NOT NULL UNIQUE,
        VaiTro NVARCHAR(50) NOT NULL DEFAULT 'Admin',
        NgayTao DATETIME2 NOT NULL DEFAULT GETDATE(),
        NgayCapNhat DATETIME2 NULL
    );
END
GO

-- Bảng NhanVien
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'NhanVien')
BEGIN
    CREATE TABLE NhanVien (
        Id INT PRIMARY KEY IDENTITY(1,1),
        MaNhanVien NVARCHAR(20) NOT NULL UNIQUE,
        HoTen NVARCHAR(100) NOT NULL,
        Email NVARCHAR(100) NOT NULL UNIQUE,
        SoDienThoai NVARCHAR(15) NULL,
        MaSinhTracHoc NVARCHAR(50) NULL,
        MaKhuonMat NVARCHAR(50) NULL,
        PhongBan NVARCHAR(100) NULL,
        ChucVu NVARCHAR(100) NULL,
        LuongGio DECIMAL(10,2) NOT NULL,
        TrangThai NVARCHAR(20) NOT NULL DEFAULT N'HoatDong',
        NgayTao DATETIME2 NOT NULL DEFAULT GETDATE(),
        NgayCapNhat DATETIME2 NULL
    );
END
GO

-- Bảng DiemDanh
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'DiemDanh')
BEGIN
    CREATE TABLE DiemDanh (
        Id INT PRIMARY KEY IDENTITY(1,1),
        NhanVienId INT NOT NULL,
        GioVao DATETIME2 NULL,
        GioRa DATETIME2 NULL,
        PhuongThucVao NVARCHAR(50) NOT NULL DEFAULT N'SinhTracHoc',
        PhuongThucRa NVARCHAR(50) NULL,
        ViDo DECIMAL(10,6) NULL,
        KinhDo DECIMAL(10,6) NULL,
        GhiChu NVARCHAR(500) NULL,
        QuanTriVienId INT NULL,
        Ngay DATE NOT NULL,
        TongGioLam DECIMAL(5,2) NULL,
        TrangThai NVARCHAR(20) NOT NULL DEFAULT N'DangLam',
        CONSTRAINT FK_DiemDanh_NhanVien FOREIGN KEY (NhanVienId) REFERENCES NhanVien(Id) ON DELETE CASCADE,
        CONSTRAINT FK_DiemDanh_QuanTriVien FOREIGN KEY (QuanTriVienId) REFERENCES QuanTriVien(Id) ON DELETE SET NULL,
        CONSTRAINT UQ_DiemDanh_NhanVien_Ngay UNIQUE (NhanVienId, Ngay)
    );
END
GO

-- Bảng Luong
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Luong')
BEGIN
    CREATE TABLE Luong (
        Id INT PRIMARY KEY IDENTITY(1,1),
        NhanVienId INT NOT NULL,
        LoaiKy NVARCHAR(20) NOT NULL DEFAULT N'Tuan',
        NgayBatDau DATE NOT NULL,
        NgayKetThuc DATE NOT NULL,
        TongGioLam DECIMAL(5,2) NOT NULL,
        LuongGio DECIMAL(10,2) NOT NULL,
        TongTien DECIMAL(12,2) NOT NULL,
        Thuong DECIMAL(12,2) NOT NULL DEFAULT 0,
        TruLuong DECIMAL(12,2) NOT NULL DEFAULT 0,
        TongCong DECIMAL(12,2) NOT NULL,
        TrangThai NVARCHAR(20) NOT NULL DEFAULT N'ChuaTra',
        NgayTao DATETIME2 NOT NULL DEFAULT GETDATE(),
        CONSTRAINT FK_Luong_NhanVien FOREIGN KEY (NhanVienId) REFERENCES NhanVien(Id) ON DELETE CASCADE
    );
END
GO

-- Bảng NhatKyEmail
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'NhatKyEmail')
BEGIN
    CREATE TABLE NhatKyEmail (
        Id INT PRIMARY KEY IDENTITY(1,1),
        NhanVienId INT NULL,
        LoaiEmail NVARCHAR(50) NOT NULL,
        NgayGui DATETIME2 NOT NULL DEFAULT GETDATE(),
        TrangThai NVARCHAR(20) NOT NULL DEFAULT N'ThanhCong',
        ThongBaoLoi NVARCHAR(500) NULL,
        CONSTRAINT FK_NhatKyEmail_NhanVien FOREIGN KEY (NhanVienId) REFERENCES NhanVien(Id) ON DELETE SET NULL
    );
END
GO

-- Tạo indexes để tối ưu hiệu suất
CREATE NONCLUSTERED INDEX IX_DiemDanh_NhanVienId ON DiemDanh(NhanVienId);
CREATE NONCLUSTERED INDEX IX_DiemDanh_Ngay ON DiemDanh(Ngay);
CREATE NONCLUSTERED INDEX IX_Luong_NhanVienId ON Luong(NhanVienId);
CREATE NONCLUSTERED INDEX IX_NhanVien_TrangThai ON NhanVien(TrangThai);
GO

PRINT N'✅ Database đã được tạo thành công!';
PRINT N'📌 Lưu ý: Tài khoản admin sẽ được tạo tự động khi chạy ứng dụng lần đầu';
PRINT N'📧 Tài khoản mặc định: admin / admin123';
GO
