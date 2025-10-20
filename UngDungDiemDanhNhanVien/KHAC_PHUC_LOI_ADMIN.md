# Khắc Phục Lỗi Đăng Nhập Admin

## Nguyên nhân
Lỗi `ArgumentOutOfRangeException` xảy ra vì:
1. Database chưa có tài khoản admin
2. Hoặc password hash không đúng định dạng BCrypt

## Giải pháp

### Cách 1: Chạy SQL Script (Nhanh nhất)

Mở SQL Server Management Studio và chạy:

```sql
USE UngDungDiemDanhNhanVien;
GO

-- Xóa admin cũ nếu có
DELETE FROM QuanTriVien WHERE TenDangNhap = 'admin';
GO

-- Thêm admin mới với password: admin123
-- Hash này được tạo bằng BCrypt
INSERT INTO QuanTriVien (TenDangNhap, MatKhauHash, Email, VaiTro, NgayTao)
VALUES (
    'admin',
    '$2a$11$KvVK5Z5Z5Z5Z5Z5Z5Z5Z5uXYZ5Z5Z5Z5Z5Z5Z5Z5Z5Z5Z5Z5Z5Z5Z5',
    'admin@congty.com',
    'Admin',
    GETDATE()
);
GO

SELECT * FROM QuanTriVien;
GO
```

**LƯU Ý:** Hash trên chỉ là placeholder. Cần chạy ứng dụng để tự động tạo hash đúng.

### Cách 2: Để ứng dụng tự tạo (Khuyên dùng)

Database context sẽ tự động tạo admin khi chạy lần đầu.

1. **Xóa database cũ:**
```sql
USE master;
GO
DROP DATABASE IF EXISTS UngDungDiemDanhNhanVien;
GO
```

2. **Chạy lại script tạo database:**
   - Mở file: `Database/TaoDatabase.sql`
   - Execute trong SSMS

3. **Chạy ứng dụng:**
```bash
dotnet run
```

Ứng dụng sẽ tự động:
- Tạo các bảng (nếu chưa có)
- Seed admin account với password hash đúng

### Cách 3: Thêm admin qua API (Sau khi sửa)

Tạo một endpoint đặc biệt để setup admin lần đầu.

## Kiểm tra

Sau khi thực hiện, kiểm tra:

```sql
USE UngDungDiemDanhNhanVien;
SELECT * FROM QuanTriVien;
```

Bạn sẽ thấy:
- Id: 1
- TenDangNhap: admin
- Email: admin@congty.com
- MatKhauHash: $2a$11$... (60 ký tự)

## Test lại

1. Mở Swagger: https://localhost:7000/swagger
2. Test: POST /api/XacThuc/dang-nhap-quan-tri
3. Body:
```json
{
  "tenDangNhap": "admin",
  "matKhau": "admin123"
}
```

Kết quả mong đợi: 200 OK với JWT token

