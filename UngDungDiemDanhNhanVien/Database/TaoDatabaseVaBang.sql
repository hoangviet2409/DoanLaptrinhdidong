-- =============================================
-- Script tạo Database và Bảng cho Ứng dụng Điểm Danh Nhân Viên
-- Tạo bởi: NHViet
-- Ngày: 2025-01-20
-- =============================================

-- =============================================
-- 1. TẠO DATABASE
-- =============================================
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'UngDungDiemDanhNhanVien')
BEGIN
    CREATE DATABASE [UngDungDiemDanhNhanVien]
    COLLATE SQL_Latin1_General_CP1_CI_AS
END
GO

USE [UngDungDiemDanhNhanVien]
GO

-- =============================================
-- 2. TẠO BẢNG QUẢN TRỊ VIÊN
-- =============================================
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='QuanTriVien' AND xtype='U')
BEGIN
    CREATE TABLE [QuanTriVien] (
        [Id] int IDENTITY(1,1) NOT NULL,
        [TenDangNhap] nvarchar(50) NOT NULL,
        [MatKhau] nvarchar(255) NOT NULL,
        [HoTen] nvarchar(100) NOT NULL,
        [Email] nvarchar(100) NOT NULL,
        [SoDienThoai] nvarchar(20) NULL,
        [VaiTro] nvarchar(20) NOT NULL DEFAULT 'Admin',
        [TrangThai] nvarchar(20) NOT NULL DEFAULT 'HoatDong',
        [NgayTao] datetime2 NOT NULL DEFAULT GETDATE(),
        [NgayCapNhat] datetime2 NOT NULL DEFAULT GETDATE(),
        CONSTRAINT [PK_QuanTriVien] PRIMARY KEY ([Id]),
        CONSTRAINT [UQ_QuanTriVien_TenDangNhap] UNIQUE ([TenDangNhap]),
        CONSTRAINT [UQ_QuanTriVien_Email] UNIQUE ([Email])
    )
END
GO

-- =============================================
-- 3. TẠO BẢNG NHÂN VIÊN
-- =============================================
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='NhanVien' AND xtype='U')
BEGIN
    CREATE TABLE [NhanVien] (
        [Id] int IDENTITY(1,1) NOT NULL,
        [MaNhanVien] nvarchar(20) NOT NULL,
        [HoTen] nvarchar(100) NOT NULL,
        [Email] nvarchar(100) NOT NULL,
        [SoDienThoai] nvarchar(20) NULL,
        [DiaChi] nvarchar(255) NULL,
        [PhongBan] nvarchar(50) NULL,
        [ChucVu] nvarchar(50) NULL,
        [NgayVaoLam] date NULL,
        [LuongCoBan] decimal(18,2) NULL DEFAULT 0,
        [TrangThai] nvarchar(20) NOT NULL DEFAULT 'HoatDong',
        [MatKhau] nvarchar(255) NOT NULL,
        [NgayTao] datetime2 NOT NULL DEFAULT GETDATE(),
        [NgayCapNhat] datetime2 NOT NULL DEFAULT GETDATE(),
        CONSTRAINT [PK_NhanVien] PRIMARY KEY ([Id]),
        CONSTRAINT [UQ_NhanVien_MaNhanVien] UNIQUE ([MaNhanVien]),
        CONSTRAINT [UQ_NhanVien_Email] UNIQUE ([Email])
    )
END
GO

-- =============================================
-- 4. TẠO BẢNG ĐIỂM DANH
-- =============================================
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='DiemDanh' AND xtype='U')
BEGIN
    CREATE TABLE [DiemDanh] (
        [Id] int IDENTITY(1,1) NOT NULL,
        [NhanVienId] int NOT NULL,
        [Ngay] date NOT NULL,
        [GioVao] datetime2 NULL,
        [GioRa] datetime2 NULL,
        [PhuongThucVao] nvarchar(20) NULL,
        [PhuongThucRa] nvarchar(20) NULL,
        [ViDo] decimal(10,7) NULL,
        [KinhDo] decimal(10,7) NULL,
        [GhiChu] nvarchar(500) NULL,
        [TrangThai] nvarchar(20) NOT NULL DEFAULT 'DangLamViec',
        [NgayTao] datetime2 NOT NULL DEFAULT GETDATE(),
        [NgayCapNhat] datetime2 NOT NULL DEFAULT GETDATE(),
        CONSTRAINT [PK_DiemDanh] PRIMARY KEY ([Id]),
        CONSTRAINT [FK_DiemDanh_NhanVien] FOREIGN KEY ([NhanVienId]) REFERENCES [NhanVien]([Id]) ON DELETE CASCADE,
        CONSTRAINT [UQ_DiemDanh_NhanVien_Ngay] UNIQUE ([NhanVienId], [Ngay])
    )
END
GO

-- =============================================
-- 5. TẠO BẢNG LƯƠNG
-- =============================================
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Luong' AND xtype='U')
BEGIN
    CREATE TABLE [Luong] (
        [Id] int IDENTITY(1,1) NOT NULL,
        [NhanVienId] int NOT NULL,
        [Thang] int NOT NULL,
        [Nam] int NOT NULL,
        [LuongCoBan] decimal(18,2) NOT NULL,
        [PhuCap] decimal(18,2) NULL DEFAULT 0,
        [Thuong] decimal(18,2) NULL DEFAULT 0,
        [TongLuong] decimal(18,2) NOT NULL,
        [TrangThai] nvarchar(20) NOT NULL DEFAULT 'ChuaTra',
        [NgayTao] datetime2 NOT NULL DEFAULT GETDATE(),
        [NgayCapNhat] datetime2 NOT NULL DEFAULT GETDATE(),
        CONSTRAINT [PK_Luong] PRIMARY KEY ([Id]),
        CONSTRAINT [FK_Luong_NhanVien] FOREIGN KEY ([NhanVienId]) REFERENCES [NhanVien]([Id]) ON DELETE CASCADE,
        CONSTRAINT [UQ_Luong_NhanVien_Thang_Nam] UNIQUE ([NhanVienId], [Thang], [Nam])
    )
END
GO

-- =============================================
-- 6. TẠO BẢNG NHẬT KÝ EMAIL
-- =============================================
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='NhatKyEmail' AND xtype='U')
BEGIN
    CREATE TABLE [NhatKyEmail] (
        [Id] int IDENTITY(1,1) NOT NULL,
        [NguoiGui] nvarchar(100) NOT NULL,
        [NguoiNhan] nvarchar(100) NOT NULL,
        [TieuDe] nvarchar(200) NOT NULL,
        [NoiDung] ntext NULL,
        [TrangThai] nvarchar(20) NOT NULL DEFAULT 'ChuaGui',
        [NgayTao] datetime2 NOT NULL DEFAULT GETDATE(),
        CONSTRAINT [PK_NhatKyEmail] PRIMARY KEY ([Id])
    )
END
GO

-- =============================================
-- 7. TẠO INDEXES ĐỂ TỐI ƯU HIỆU SUẤT
-- =============================================

-- Index cho bảng NhanVien
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_NhanVien_MaNhanVien')
    CREATE INDEX [IX_NhanVien_MaNhanVien] ON [NhanVien] ([MaNhanVien])

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_NhanVien_Email')
    CREATE INDEX [IX_NhanVien_Email] ON [NhanVien] ([Email])

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_NhanVien_PhongBan')
    CREATE INDEX [IX_NhanVien_PhongBan] ON [NhanVien] ([PhongBan])

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_NhanVien_TrangThai')
    CREATE INDEX [IX_NhanVien_TrangThai] ON [NhanVien] ([TrangThai])

-- Index cho bảng DiemDanh
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_DiemDanh_NhanVienId')
    CREATE INDEX [IX_DiemDanh_NhanVienId] ON [DiemDanh] ([NhanVienId])

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_DiemDanh_Ngay')
    CREATE INDEX [IX_DiemDanh_Ngay] ON [DiemDanh] ([Ngay])

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_DiemDanh_TrangThai')
    CREATE INDEX [IX_DiemDanh_TrangThai] ON [DiemDanh] ([TrangThai])

-- Index cho bảng Luong
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Luong_NhanVienId')
    CREATE INDEX [IX_Luong_NhanVienId] ON [Luong] ([NhanVienId])

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Luong_Thang_Nam')
    CREATE INDEX [IX_Luong_Thang_Nam] ON [Luong] ([Thang], [Nam])

-- Index cho bảng QuanTriVien
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_QuanTriVien_TenDangNhap')
    CREATE INDEX [IX_QuanTriVien_TenDangNhap] ON [QuanTriVien] ([TenDangNhap])

-- =============================================
-- 8. TẠO STORED PROCEDURES
-- =============================================

-- Stored Procedure: Lấy thống kê điểm danh theo tháng
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'sp_ThongKeDiemDanhTheoThang')
    DROP PROCEDURE [sp_ThongKeDiemDanhTheoThang]
GO

CREATE PROCEDURE [sp_ThongKeDiemDanhTheoThang]
    @Thang INT,
    @Nam INT
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        n.MaNhanVien,
        n.HoTen,
        n.PhongBan,
        COUNT(d.Id) as SoNgayDiemDanh,
        SUM(CASE WHEN d.GioRa IS NOT NULL THEN 1 ELSE 0 END) as SoNgayHoanThanh,
        AVG(CASE WHEN d.GioRa IS NOT NULL THEN DATEDIFF(MINUTE, d.GioVao, d.GioRa) ELSE NULL END) as SoPhutLamViecTrungBinh
    FROM [NhanVien] n
    LEFT JOIN [DiemDanh] d ON n.Id = d.NhanVienId 
        AND MONTH(d.Ngay) = @Thang 
        AND YEAR(d.Ngay) = @Nam
    WHERE n.TrangThai = 'HoatDong'
    GROUP BY n.Id, n.MaNhanVien, n.HoTen, n.PhongBan
    ORDER BY n.PhongBan, n.HoTen
END
GO

-- Stored Procedure: Lấy danh sách nhân viên chưa điểm danh hôm nay
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'sp_NhanVienChuaDiemDanhHomNay')
    DROP PROCEDURE [sp_NhanVienChuaDiemDanhHomNay]
GO

CREATE PROCEDURE [sp_NhanVienChuaDiemDanhHomNay]
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        n.Id,
        n.MaNhanVien,
        n.HoTen,
        n.PhongBan,
        n.ChucVu,
        n.Email,
        n.SoDienThoai
    FROM [NhanVien] n
    WHERE n.TrangThai = 'HoatDong'
    AND n.Id NOT IN (
        SELECT DISTINCT NhanVienId 
        FROM [DiemDanh] 
        WHERE Ngay = CAST(GETDATE() AS DATE)
    )
    ORDER BY n.PhongBan, n.HoTen
END
GO

-- =============================================
-- 9. TẠO VIEWS
-- =============================================

-- View: Thống kê điểm danh tổng quan
IF EXISTS (SELECT * FROM sys.views WHERE name = 'vw_ThongKeDiemDanhTongQuan')
    DROP VIEW [vw_ThongKeDiemDanhTongQuan]
GO

CREATE VIEW [vw_ThongKeDiemDanhTongQuan]
AS
SELECT 
    CAST(GETDATE() AS DATE) as Ngay,
    (SELECT COUNT(*) FROM [NhanVien] WHERE TrangThai = 'HoatDong') as TongNhanVien,
    (SELECT COUNT(*) FROM [DiemDanh] WHERE Ngay = CAST(GETDATE() AS DATE)) as SoNhanVienDiemDanh,
    (SELECT COUNT(*) FROM [DiemDanh] WHERE Ngay = CAST(GETDATE() AS DATE) AND GioRa IS NULL) as SoNhanVienDangLamViec,
    (SELECT COUNT(*) FROM [DiemDanh] WHERE Ngay = CAST(GETDATE() AS DATE) AND GioRa IS NOT NULL) as SoNhanVienHoanThanh,
    (SELECT COUNT(*) FROM [NhanVien] WHERE TrangThai = 'HoatDong') - 
    (SELECT COUNT(*) FROM [DiemDanh] WHERE Ngay = CAST(GETDATE() AS DATE)) as SoNhanVienChuaDiemDanh
GO

-- View: Danh sách nhân viên với thông tin điểm danh hôm nay
IF EXISTS (SELECT * FROM sys.views WHERE name = 'vw_NhanVienDiemDanhHomNay')
    DROP VIEW [vw_NhanVienDiemDanhHomNay]
GO

CREATE VIEW [vw_NhanVienDiemDanhHomNay]
AS
SELECT 
    n.Id,
    n.MaNhanVien,
    n.HoTen,
    n.PhongBan,
    n.ChucVu,
    d.GioVao,
    d.GioRa,
    d.TrangThai as TrangThaiDiemDanh,
    CASE 
        WHEN d.GioRa IS NOT NULL THEN DATEDIFF(MINUTE, d.GioVao, d.GioRa)
        ELSE DATEDIFF(MINUTE, d.GioVao, GETDATE())
    END as SoPhutLamViec
FROM [NhanVien] n
LEFT JOIN [DiemDanh] d ON n.Id = d.NhanVienId AND d.Ngay = CAST(GETDATE() AS DATE)
WHERE n.TrangThai = 'HoatDong'
GO

-- =============================================
-- 10. HIỂN THỊ THÔNG TIN HOÀN THÀNH
-- =============================================
PRINT '=== HOÀN THÀNH TẠO DATABASE VÀ BẢNG ==='
PRINT 'Database: UngDungDiemDanhNhanVien'
PRINT 'Các bảng đã tạo:'
PRINT '- QuanTriVien'
PRINT '- NhanVien'
PRINT '- DiemDanh'
PRINT '- Luong'
PRINT '- NhatKyEmail'
PRINT ''
PRINT 'Các Index đã tạo để tối ưu hiệu suất'
PRINT 'Các Stored Procedures đã tạo:'
PRINT '- sp_ThongKeDiemDanhTheoThang'
PRINT '- sp_NhanVienChuaDiemDanhHomNay'
PRINT ''
PRINT 'Các Views đã tạo:'
PRINT '- vw_ThongKeDiemDanhTongQuan'
PRINT '- vw_NhanVienDiemDanhHomNay'
PRINT ''
PRINT 'Bước tiếp theo: Chạy file DuLieuMau.sql để thêm dữ liệu mẫu'
GO
