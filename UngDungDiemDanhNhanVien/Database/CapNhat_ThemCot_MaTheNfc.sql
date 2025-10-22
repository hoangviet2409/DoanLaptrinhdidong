-- Thêm cột mã thẻ NFC vào bảng Nhân Viên
ALTER TABLE [dbo].[NhanVien]
ADD [MaTheNfc] NVARCHAR(50) NULL;

-- Tạo chỉ mục để tra cứu nhanh theo mã thẻ NFC
CREATE INDEX IX_NhanVien_MaTheNfc ON [dbo].[NhanVien]([MaTheNfc]);

-- Cập nhật một số nhân viên mẫu với mã thẻ NFC (tùy chọn)
-- UPDATE [dbo].[NhanVien] 
-- SET [MaTheNfc] = '04A224CD98B1' 
-- WHERE [MaNhanVien] = 'NV001';

-- UPDATE [dbo].[NhanVien] 
-- SET [MaTheNfc] = '04B335DE89C2' 
-- WHERE [MaNhanVien] = 'NV002';

-- Kiểm tra kết quả
SELECT [Id], [MaNhanVien], [HoTen], [MaTheNfc] 
FROM [dbo].[NhanVien] 
WHERE [MaTheNfc] IS NOT NULL;




