-- =============================================
-- Dữ liệu mẫu cho Ứng dụng Điểm Danh Nhân Viên
-- Tạo bởi: NHViet
-- Ngày: 2025-01-20
-- =============================================

USE [UngDungDiemDanhNhanVien]
GO

-- =============================================
-- 1. XÓA DỮ LIỆU CŨ (NẾU CÓ)
-- =============================================
DELETE FROM [DiemDanh]
DELETE FROM [NhanVien]
DELETE FROM [QuanTriVien]
DELETE FROM [Luong]
DELETE FROM [NhatKyEmail]
GO

-- =============================================
-- 2. THÊM DỮ LIỆU QUẢN TRỊ VIÊN
-- =============================================
INSERT INTO [QuanTriVien] ([TenDangNhap], [MatKhau], [HoTen], [Email], [SoDienThoai], [VaiTro], [TrangThai], [NgayTao], [NgayCapNhat])
VALUES 
('admin', 'admin123', N'Nguyễn Văn Admin', 'admin@congty.com', '0123456789', 'Admin', 'HoatDong', GETDATE(), GETDATE()),
('manager1', 'manager123', N'Trần Thị Manager', 'manager1@congty.com', '0987654321', 'QuanLy', 'HoatDong', GETDATE(), GETDATE()),
('manager2', 'manager123', N'Lê Văn Quản Lý', 'manager2@congty.com', '0369852147', 'QuanLy', 'HoatDong', GETDATE(), GETDATE())
GO

-- =============================================
-- 3. THÊM DỮ LIỆU NHÂN VIÊN
-- =============================================
INSERT INTO [NhanVien] ([MaNhanVien], [HoTen], [Email], [SoDienThoai], [DiaChi], [PhongBan], [ChucVu], [NgayVaoLam], [LuongCoBan], [TrangThai], [MatKhau], [NgayTao], [NgayCapNhat])
VALUES 
-- Phòng IT
('NV001', N'Nguyễn Văn An', 'an.nguyen@congty.com', '0123456780', N'123 Đường ABC, Quận 1, TP.HCM', N'Công nghệ thông tin', N'Lập trình viên', '2024-01-15', 15000000, 'HoatDong', '123456', GETDATE(), GETDATE()),
('NV002', N'Trần Thị Bình', 'binh.tran@congty.com', '0123456781', N'456 Đường DEF, Quận 2, TP.HCM', N'Công nghệ thông tin', N'Lập trình viên', '2024-02-01', 16000000, 'HoatDong', '123456', GETDATE(), GETDATE()),
('NV003', N'Lê Văn Cường', 'cuong.le@congty.com', '0123456782', N'789 Đường GHI, Quận 3, TP.HCM', N'Công nghệ thông tin', N'Trưởng nhóm', '2023-12-01', 20000000, 'HoatDong', '123456', GETDATE(), GETDATE()),

-- Phòng Nhân sự
('NV004', N'Phạm Thị Dung', 'dung.pham@congty.com', '0123456783', N'321 Đường JKL, Quận 4, TP.HCM', N'Nhân sự', N'Chuyên viên nhân sự', '2024-01-20', 12000000, 'HoatDong', '123456', GETDATE(), GETDATE()),
('NV005', N'Hoàng Văn Em', 'em.hoang@congty.com', '0123456784', N'654 Đường MNO, Quận 5, TP.HCM', N'Nhân sự', N'Trưởng phòng nhân sự', '2023-11-15', 18000000, 'HoatDong', '123456', GETDATE(), GETDATE()),

-- Phòng Kế toán
('NV006', N'Vũ Thị Phương', 'phuong.vu@congty.com', '0123456785', N'987 Đường PQR, Quận 6, TP.HCM', N'Kế toán', N'Kế toán viên', '2024-01-10', 13000000, 'HoatDong', '123456', GETDATE(), GETDATE()),
('NV007', N'Đặng Văn Giang', 'giang.dang@congty.com', '0123456786', N'147 Đường STU, Quận 7, TP.HCM', N'Kế toán', N'Kế toán trưởng', '2023-10-01', 17000000, 'HoatDong', '123456', GETDATE(), GETDATE()),

-- Phòng Marketing
('NV008', N'Bùi Thị Hoa', 'hoa.bui@congty.com', '0123456787', N'258 Đường VWX, Quận 8, TP.HCM', N'Marketing', N'Chuyên viên marketing', '2024-02-15', 14000000, 'HoatDong', '123456', GETDATE(), GETDATE()),
('NV009', N'Ngô Văn Inh', 'inh.ngo@congty.com', '0123456788', N'369 Đường YZA, Quận 9, TP.HCM', N'Marketing', N'Trưởng phòng marketing', '2023-09-01', 19000000, 'HoatDong', '123456', GETDATE(), GETDATE()),

-- Phòng Kinh doanh
('NV010', N'Đinh Thị Khoa', 'khoa.dinh@congty.com', '0123456789', N'741 Đường BCD, Quận 10, TP.HCM', N'Kinh doanh', N'Nhân viên kinh doanh', '2024-01-05', 15000000, 'HoatDong', '123456', GETDATE(), GETDATE()),
('NV011', N'Phan Văn Long', 'long.phan@congty.com', '0123456790', N'852 Đường EFG, Quận 11, TP.HCM', N'Kinh doanh', N'Trưởng phòng kinh doanh', '2023-08-15', 22000000, 'HoatDong', '123456', GETDATE(), GETDATE()),

-- Nhân viên nghỉ việc
('NV012', N'Lý Thị Minh', 'minh.ly@congty.com', '0123456791', N'963 Đường HIJ, Quận 12, TP.HCM', N'Công nghệ thông tin', N'Lập trình viên', '2023-06-01', 14000000, 'NghiViec', '123456', GETDATE(), GETDATE())
GO

-- =============================================
-- 4. THÊM DỮ LIỆU LƯƠNG
-- =============================================
INSERT INTO [Luong] ([NhanVienId], [Thang], [Nam], [LuongCoBan], [PhuCap], [Thuong], [TongLuong], [TrangThai], [NgayTao], [NgayCapNhat])
SELECT 
    n.Id,
    12, -- Tháng 12
    2024, -- Năm 2024
    n.LuongCoBan,
    CASE 
        WHEN n.ChucVu LIKE N'%Trưởng%' THEN 3000000
        WHEN n.ChucVu LIKE N'%Lập trình%' THEN 2000000
        ELSE 1000000
    END,
    CASE 
        WHEN n.ChucVu LIKE N'%Trưởng%' THEN 2000000
        WHEN n.ChucVu LIKE N'%Lập trình%' THEN 1500000
        ELSE 1000000
    END,
    n.LuongCoBan + 
    CASE 
        WHEN n.ChucVu LIKE N'%Trưởng%' THEN 5000000
        WHEN n.ChucVu LIKE N'%Lập trình%' THEN 3500000
        ELSE 2000000
    END,
    'DaTra',
    GETDATE(),
    GETDATE()
FROM [NhanVien] n
WHERE n.TrangThai = 'HoatDong'
GO

-- =============================================
-- 5. THÊM DỮ LIỆU ĐIỂM DANH (7 NGÀY GẦN NHẤT)
-- =============================================
DECLARE @NgayHienTai DATE = CAST(GETDATE() AS DATE)
DECLARE @NgayBatDau DATE = DATEADD(DAY, -6, @NgayHienTai)

-- Tạo dữ liệu điểm danh cho 7 ngày gần nhất
WHILE @NgayBatDau <= @NgayHienTai
BEGIN
    -- Điểm danh cho nhân viên hoạt động (80% nhân viên điểm danh mỗi ngày)
    INSERT INTO [DiemDanh] ([NhanVienId], [Ngay], [GioVao], [GioRa], [PhuongThucVao], [PhuongThucRa], [ViDo], [KinhDo], [GhiChu], [TrangThai], [NgayTao], [NgayCapNhat])
    SELECT 
        n.Id,
        @NgayBatDau,
        -- Giờ vào: 7:30 - 9:00 (ngẫu nhiên)
        DATEADD(MINUTE, 450 + (ABS(CHECKSUM(NEWID())) % 90), CAST(@NgayBatDau AS DATETIME)),
        -- Giờ ra: 17:00 - 18:30 (ngẫu nhiên, 70% nhân viên có giờ ra)
        CASE 
            WHEN ABS(CHECKSUM(NEWID())) % 100 < 70 
            THEN DATEADD(MINUTE, 1020 + (ABS(CHECKSUM(NEWID())) % 90), CAST(@NgayBatDau AS DATETIME))
            ELSE NULL
        END,
        'SinhTracHoc',
        CASE 
            WHEN ABS(CHECKSUM(NEWID())) % 100 < 70 THEN 'SinhTracHoc'
            ELSE NULL
        END,
        -- Vị trí GPS (khu vực TP.HCM)
        10.8231 + (ABS(CHECKSUM(NEWID())) % 100) * 0.001,
        106.6297 + (ABS(CHECKSUM(NEWID())) % 100) * 0.001,
        N'Điểm danh tự động',
        'HoanThanh',
        GETDATE(),
        GETDATE()
    FROM [NhanVien] n
    WHERE n.TrangThai = 'HoatDong'
    AND ABS(CHECKSUM(NEWID())) % 100 < 80 -- 80% nhân viên điểm danh
    
    SET @NgayBatDau = DATEADD(DAY, 1, @NgayBatDau)
END
GO

-- =============================================
-- 6. THÊM DỮ LIỆU NHẬT KÝ EMAIL
-- =============================================
INSERT INTO [NhatKyEmail] ([NguoiGui], [NguoiNhan], [TieuDe], [NoiDung], [TrangThai], [NgayTao])
VALUES 
('admin@congty.com', 'an.nguyen@congty.com', N'Chào mừng nhân viên mới', N'Chào mừng bạn đến với công ty!', 'DaGui', GETDATE()),
('admin@congty.com', 'binh.tran@congty.com', N'Chào mừng nhân viên mới', N'Chào mừng bạn đến với công ty!', 'DaGui', GETDATE()),
('manager1@congty.com', 'cuong.le@congty.com', N'Họp team tuần này', N'Chúng ta sẽ có cuộc họp team vào thứ 6 tuần này.', 'DaGui', GETDATE()),
('manager2@congty.com', 'dung.pham@congty.com', N'Báo cáo tháng', N'Vui lòng chuẩn bị báo cáo tháng cho phòng nhân sự.', 'DaGui', GETDATE())
GO

-- =============================================
-- 7. HIỂN THỊ THỐNG KÊ DỮ LIỆU
-- =============================================
PRINT '=== THỐNG KÊ DỮ LIỆU ĐÃ THÊM ==='
PRINT 'Số lượng quản trị viên: ' + CAST((SELECT COUNT(*) FROM [QuanTriVien]) AS VARCHAR(10))
PRINT 'Số lượng nhân viên: ' + CAST((SELECT COUNT(*) FROM [NhanVien]) AS VARCHAR(10))
PRINT 'Số lượng nhân viên hoạt động: ' + CAST((SELECT COUNT(*) FROM [NhanVien] WHERE TrangThai = 'HoatDong') AS VARCHAR(10))
PRINT 'Số lượng bản ghi lương: ' + CAST((SELECT COUNT(*) FROM [Luong]) AS VARCHAR(10))
PRINT 'Số lượng bản ghi điểm danh: ' + CAST((SELECT COUNT(*) FROM [DiemDanh]) AS VARCHAR(10))
PRINT 'Số lượng email đã gửi: ' + CAST((SELECT COUNT(*) FROM [NhatKyEmail]) AS VARCHAR(10))

-- Hiển thị danh sách nhân viên theo phòng ban
PRINT ''
PRINT '=== DANH SÁCH NHÂN VIÊN THEO PHÒNG BAN ==='
SELECT 
    PhongBan,
    COUNT(*) as SoNhanVien,
    STRING_AGG(HoTen, ', ') as DanhSachNhanVien
FROM [NhanVien] 
WHERE TrangThai = 'HoatDong'
GROUP BY PhongBan
ORDER BY PhongBan

-- Hiển thị thống kê điểm danh 7 ngày gần nhất
PRINT ''
PRINT '=== THỐNG KÊ ĐIỂM DANH 7 NGÀY GẦN NHẤT ==='
SELECT 
    Ngay,
    COUNT(*) as SoNhanVienDiemDanh,
    COUNT(GioRa) as SoNhanVienHoanThanh,
    AVG(DATEDIFF(MINUTE, GioVao, GioRa)) as SoPhutLamViecTrungBinh
FROM [DiemDanh] 
WHERE Ngay >= DATEADD(DAY, -6, CAST(GETDATE() AS DATE))
GROUP BY Ngay
ORDER BY Ngay

PRINT ''
PRINT '=== HOÀN THÀNH THÊM DỮ LIỆU MẪU ==='
PRINT 'Dữ liệu đã được thêm thành công!'
PRINT 'Bạn có thể sử dụng các tài khoản sau để test:'
PRINT 'Admin: admin / admin123'
PRINT 'Manager: manager1 / manager123'
PRINT 'Nhân viên: NV001 / 123456 (Nguyễn Văn An)'
PRINT 'Nhân viên: NV002 / 123456 (Trần Thị Bình)'
GO
