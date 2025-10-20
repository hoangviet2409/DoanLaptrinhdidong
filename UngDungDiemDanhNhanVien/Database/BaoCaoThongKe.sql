-- =============================================
-- Script Báo Cáo và Thống Kê
-- Ứng dụng Điểm Danh Nhân Viên
-- Tạo bởi: NHViet
-- Ngày: 2025-01-20
-- =============================================

USE [UngDungDiemDanhNhanVien]
GO

-- =============================================
-- 1. BÁO CÁO ĐIỂM DANH HÔM NAY
-- =============================================
PRINT '=== BÁO CÁO ĐIỂM DANH HÔM NAY ==='
PRINT 'Ngày: ' + CONVERT(VARCHAR, GETDATE(), 103)

-- Thống kê tổng quan
SELECT 
    'Tổng nhân viên' as Loai,
    COUNT(*) as SoLuong
FROM [NhanVien] 
WHERE TrangThai = 'HoatDong'

UNION ALL

SELECT 
    'Đã điểm danh',
    COUNT(*)
FROM [DiemDanh] 
WHERE Ngay = CAST(GETDATE() AS DATE)

UNION ALL

SELECT 
    'Đang làm việc',
    COUNT(*)
FROM [DiemDanh] 
WHERE Ngay = CAST(GETDATE() AS DATE) AND GioRa IS NULL

UNION ALL

SELECT 
    'Đã hoàn thành',
    COUNT(*)
FROM [DiemDanh] 
WHERE Ngay = CAST(GETDATE() AS DATE) AND GioRa IS NOT NULL

UNION ALL

SELECT 
    'Chưa điểm danh',
    (SELECT COUNT(*) FROM [NhanVien] WHERE TrangThai = 'HoatDong') - 
    (SELECT COUNT(*) FROM [DiemDanh] WHERE Ngay = CAST(GETDATE() AS DATE))

-- Danh sách nhân viên chưa điểm danh hôm nay
PRINT ''
PRINT '=== DANH SÁCH NHÂN VIÊN CHƯA ĐIỂM DANH HÔM NAY ==='
SELECT 
    n.MaNhanVien,
    n.HoTen,
    n.PhongBan,
    n.ChucVu,
    n.SoDienThoai
FROM [NhanVien] n
WHERE n.TrangThai = 'HoatDong'
AND n.Id NOT IN (
    SELECT DISTINCT NhanVienId 
    FROM [DiemDanh] 
    WHERE Ngay = CAST(GETDATE() AS DATE)
)
ORDER BY n.PhongBan, n.HoTen

-- Danh sách nhân viên đang làm việc
PRINT ''
PRINT '=== DANH SÁCH NHÂN VIÊN ĐANG LÀM VIỆC ==='
SELECT 
    n.MaNhanVien,
    n.HoTen,
    n.PhongBan,
    d.GioVao,
    DATEDIFF(MINUTE, d.GioVao, GETDATE()) as SoPhutLamViec
FROM [NhanVien] n
INNER JOIN [DiemDanh] d ON n.Id = d.NhanVienId
WHERE d.Ngay = CAST(GETDATE() AS DATE) 
AND d.GioRa IS NULL
ORDER BY d.GioVao

GO

-- =============================================
-- 2. BÁO CÁO ĐIỂM DANH THEO TUẦN
-- =============================================
PRINT ''
PRINT '=== BÁO CÁO ĐIỂM DANH 7 NGÀY GẦN NHẤT ==='

SELECT 
    d.Ngay,
    DATENAME(WEEKDAY, d.Ngay) as Thu,
    COUNT(*) as SoNhanVienDiemDanh,
    COUNT(d.GioRa) as SoNhanVienHoanThanh,
    AVG(CASE WHEN d.GioRa IS NOT NULL THEN DATEDIFF(MINUTE, d.GioVao, d.GioRa) ELSE NULL END) as SoPhutLamViecTrungBinh,
    MIN(d.GioVao) as GioVaoSomNhat,
    MAX(d.GioVao) as GioVaoMuonNhat
FROM [DiemDanh] d
WHERE d.Ngay >= DATEADD(DAY, -6, CAST(GETDATE() AS DATE))
GROUP BY d.Ngay
ORDER BY d.Ngay

GO

-- =============================================
-- 3. BÁO CÁO ĐIỂM DANH THEO THÁNG
-- =============================================
PRINT ''
PRINT '=== BÁO CÁO ĐIỂM DANH THÁNG ' + CAST(MONTH(GETDATE()) AS VARCHAR(2)) + '/' + CAST(YEAR(GETDATE()) AS VARCHAR(4)) + ' ==='

SELECT 
    n.MaNhanVien,
    n.HoTen,
    n.PhongBan,
    COUNT(d.Id) as SoNgayDiemDanh,
    SUM(CASE WHEN d.GioRa IS NOT NULL THEN 1 ELSE 0 END) as SoNgayHoanThanh,
    AVG(CASE WHEN d.GioRa IS NOT NULL THEN DATEDIFF(MINUTE, d.GioVao, d.GioRa) ELSE NULL END) as SoPhutLamViecTrungBinh,
    MIN(d.GioVao) as GioVaoSomNhat,
    MAX(d.GioVao) as GioVaoMuonNhat
FROM [NhanVien] n
LEFT JOIN [DiemDanh] d ON n.Id = d.NhanVienId 
    AND MONTH(d.Ngay) = MONTH(GETDATE()) 
    AND YEAR(d.Ngay) = YEAR(GETDATE())
WHERE n.TrangThai = 'HoatDong'
GROUP BY n.Id, n.MaNhanVien, n.HoTen, n.PhongBan
ORDER BY n.PhongBan, n.HoTen

GO

-- =============================================
-- 4. BÁO CÁO THEO PHÒNG BAN
-- =============================================
PRINT ''
PRINT '=== BÁO CÁO ĐIỂM DANH THEO PHÒNG BAN ==='

SELECT 
    n.PhongBan,
    COUNT(DISTINCT n.Id) as TongNhanVien,
    COUNT(DISTINCT d.NhanVienId) as SoNhanVienDiemDanhHomNay,
    AVG(CASE WHEN d.GioRa IS NOT NULL THEN DATEDIFF(MINUTE, d.GioVao, d.GioRa) ELSE NULL END) as SoPhutLamViecTrungBinh,
    COUNT(CASE WHEN d.GioRa IS NULL THEN 1 END) as SoNhanVienDangLamViec
FROM [NhanVien] n
LEFT JOIN [DiemDanh] d ON n.Id = d.NhanVienId 
    AND d.Ngay = CAST(GETDATE() AS DATE)
WHERE n.TrangThai = 'HoatDong'
GROUP BY n.PhongBan
ORDER BY n.PhongBan

GO

-- =============================================
-- 5. BÁO CÁO NHÂN VIÊN ĐI MUỘN
-- =============================================
PRINT ''
PRINT '=== BÁO CÁO NHÂN VIÊN ĐI MUỘN (SAU 8:30) ==='

SELECT 
    n.MaNhanVien,
    n.HoTen,
    n.PhongBan,
    d.Ngay,
    d.GioVao,
    DATEDIFF(MINUTE, CAST(CAST(d.Ngay AS VARCHAR) + ' 08:30:00' AS DATETIME), d.GioVao) as SoPhutMuon
FROM [NhanVien] n
INNER JOIN [DiemDanh] d ON n.Id = d.NhanVienId
WHERE d.Ngay >= DATEADD(DAY, -7, CAST(GETDATE() AS DATE))
AND DATEPART(HOUR, d.GioVao) > 8 
OR (DATEPART(HOUR, d.GioVao) = 8 AND DATEPART(MINUTE, d.GioVao) > 30)
ORDER BY d.Ngay DESC, d.GioVao

GO

-- =============================================
-- 6. BÁO CÁO NHÂN VIÊN VỀ SỚM
-- =============================================
PRINT ''
PRINT '=== BÁO CÁO NHÂN VIÊN VỀ SỚM (TRƯỚC 17:00) ==='

SELECT 
    n.MaNhanVien,
    n.HoTen,
    n.PhongBan,
    d.Ngay,
    d.GioRa,
    DATEDIFF(MINUTE, d.GioRa, CAST(CAST(d.Ngay AS VARCHAR) + ' 17:00:00' AS DATETIME)) as SoPhutSom
FROM [NhanVien] n
INNER JOIN [DiemDanh] d ON n.Id = d.NhanVienId
WHERE d.Ngay >= DATEADD(DAY, -7, CAST(GETDATE() AS DATE))
AND d.GioRa IS NOT NULL
AND (DATEPART(HOUR, d.GioRa) < 17)
ORDER BY d.Ngay DESC, d.GioRa

GO

-- =============================================
-- 7. BÁO CÁO TỶ LỆ CHUYÊN CẦN
-- =============================================
PRINT ''
PRINT '=== BÁO CÁO TỶ LỆ CHUYÊN CẦN THÁNG ' + CAST(MONTH(GETDATE()) AS VARCHAR(2)) + '/' + CAST(YEAR(GETDATE()) AS VARCHAR(4)) + ' ==='

WITH ThongKeChuyenCan AS (
    SELECT 
        n.Id,
        n.MaNhanVien,
        n.HoTen,
        n.PhongBan,
        COUNT(d.Id) as SoNgayDiemDanh,
        DATEDIFF(DAY, 
            CASE 
                WHEN DAY(GETDATE()) >= DAY(n.NgayVaoLam) 
                THEN DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), DAY(n.NgayVaoLam))
                ELSE DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()) - 1, DAY(n.NgayVaoLam))
            END,
            GETDATE()
        ) as SoNgayLamViec
    FROM [NhanVien] n
    LEFT JOIN [DiemDanh] d ON n.Id = d.NhanVienId 
        AND MONTH(d.Ngay) = MONTH(GETDATE()) 
        AND YEAR(d.Ngay) = YEAR(GETDATE())
    WHERE n.TrangThai = 'HoatDong'
    GROUP BY n.Id, n.MaNhanVien, n.HoTen, n.PhongBan, n.NgayVaoLam
)
SELECT 
    MaNhanVien,
    HoTen,
    PhongBan,
    SoNgayDiemDanh,
    SoNgayLamViec,
    CASE 
        WHEN SoNgayLamViec > 0 
        THEN CAST((SoNgayDiemDanh * 100.0 / SoNgayLamViec) AS DECIMAL(5,2))
        ELSE 0
    END as TyLeChuyenCan
FROM ThongKeChuyenCan
ORDER BY TyLeChuyenCan DESC, PhongBan, HoTen

GO

-- =============================================
-- 8. BÁO CÁO TOP NHÂN VIÊN CHUYÊN CẦN
-- =============================================
PRINT ''
PRINT '=== TOP 10 NHÂN VIÊN CHUYÊN CẦN NHẤT ==='

WITH ThongKeChuyenCan AS (
    SELECT 
        n.Id,
        n.MaNhanVien,
        n.HoTen,
        n.PhongBan,
        COUNT(d.Id) as SoNgayDiemDanh,
        AVG(CASE WHEN d.GioRa IS NOT NULL THEN DATEDIFF(MINUTE, d.GioVao, d.GioRa) ELSE NULL END) as SoPhutLamViecTrungBinh
    FROM [NhanVien] n
    LEFT JOIN [DiemDanh] d ON n.Id = d.NhanVienId 
        AND d.Ngay >= DATEADD(DAY, -30, CAST(GETDATE() AS DATE))
    WHERE n.TrangThai = 'HoatDong'
    GROUP BY n.Id, n.MaNhanVien, n.HoTen, n.PhongBan
)
SELECT TOP 10
    MaNhanVien,
    HoTen,
    PhongBan,
    SoNgayDiemDanh,
    CAST(SoPhutLamViecTrungBinh / 60.0 AS DECIMAL(5,2)) as SoGioLamViecTrungBinh
FROM ThongKeChuyenCan
ORDER BY SoNgayDiemDanh DESC, SoPhutLamViecTrungBinh DESC

GO

-- =============================================
-- 9. BÁO CÁO THỐNG KÊ LƯƠNG
-- =============================================
PRINT ''
PRINT '=== BÁO CÁO THỐNG KÊ LƯƠNG THÁNG ' + CAST(MONTH(GETDATE()) AS VARCHAR(2)) + '/' + CAST(YEAR(GETDATE()) AS VARCHAR(4)) + ' ==='

SELECT 
    n.PhongBan,
    COUNT(l.Id) as SoNhanVienCoLuong,
    SUM(l.LuongCoBan) as TongLuongCoBan,
    SUM(l.PhuCap) as TongPhuCap,
    SUM(l.Thuong) as TongThuong,
    SUM(l.TongLuong) as TongLuongThucTe,
    AVG(l.TongLuong) as LuongTrungBinh
FROM [NhanVien] n
LEFT JOIN [Luong] l ON n.Id = l.NhanVienId 
    AND l.Thang = MONTH(GETDATE()) 
    AND l.Nam = YEAR(GETDATE())
WHERE n.TrangThai = 'HoatDong'
GROUP BY n.PhongBan
ORDER BY n.PhongBan

GO

-- =============================================
-- 10. TỔNG KẾT BÁO CÁO
-- =============================================
PRINT ''
PRINT '=== TỔNG KẾT BÁO CÁO ==='
PRINT 'Thời gian tạo báo cáo: ' + CONVERT(VARCHAR, GETDATE(), 120)
PRINT 'Database: UngDungDiemDanhNhanVien'
PRINT ''
PRINT 'Các báo cáo đã được tạo:'
PRINT '1. Báo cáo điểm danh hôm nay'
PRINT '2. Báo cáo điểm danh 7 ngày gần nhất'
PRINT '3. Báo cáo điểm danh theo tháng'
PRINT '4. Báo cáo theo phòng ban'
PRINT '5. Báo cáo nhân viên đi muộn'
PRINT '6. Báo cáo nhân viên về sớm'
PRINT '7. Báo cáo tỷ lệ chuyên cần'
PRINT '8. Top nhân viên chuyên cần'
PRINT '9. Báo cáo thống kê lương'
PRINT ''
PRINT 'Bạn có thể sử dụng các stored procedures và views đã tạo để tự động hóa việc tạo báo cáo'
GO
