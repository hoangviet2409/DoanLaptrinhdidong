# Hướng Dẫn Cài Đặt và Chạy Ứng Dụng

## ⚙️ Yêu Cầu Hệ Thống

### Backend
- .NET 8.0 SDK ([Tải tại đây](https://dotnet.microsoft.com/download/dotnet/8.0))
- SQL Server 2019 hoặc mới hơn
- Visual Studio 2022 hoặc VS Code
- Postman hoặc REST Client extension (để test API)

### Kiểm tra .NET đã cài đặt
```bash
dotnet --version
# Kết quả mong đợi: 8.0.x
```

## 📦 Bước 1: Chuẩn Bị Database

### 1.1. Kiểm tra SQL Server
- Mở SQL Server Management Studio (SSMS)
- Kết nối đến server: `HOANGVIET24\MSSQLSERVER01`
- Đảm bảo có quyền tạo database

### 1.2. Tạo Database
1. Mở file `Database/TaoDatabase.sql` trong SSMS
2. Nhấn F5 hoặc Execute
3. Kiểm tra database `UngDungDiemDanhNhanVien` đã được tạo

### 1.3. Kiểm tra Tables
```sql
USE UngDungDiemDanhNhanVien;
GO

SELECT TABLE_NAME 
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_TYPE = 'BASE TABLE';
```

Bạn phải thấy 5 bảng: QuanTriVien, NhanVien, DiemDanh, Luong, NhatKyEmail

## 🚀 Bước 2: Cài Đặt Backend

### 2.1. Restore NuGet Packages
```bash
cd UngDungDiemDanhNhanVien
dotnet restore
```

### 2.2. Build Project
```bash
dotnet build
```

Nếu thành công, bạn sẽ thấy:
```
Build succeeded.
    0 Warning(s)
    0 Error(s)
```

### 2.3. Chạy Migrations (tùy chọn)
Nếu muốn dùng Entity Framework Migrations:
```bash
dotnet ef migrations add InitialCreate
dotnet ef database update
```

## ▶️ Bước 3: Chạy Ứng Dụng

### Cách 1: Sử dụng Command Line
```bash
dotnet run
```

### Cách 2: Sử dụng Visual Studio
1. Mở file `UngDungDiemDanhNhanVien.csproj`
2. Nhấn F5 hoặc Ctrl+F5

### Cách 3: Sử dụng VS Code
1. Mở thư mục project trong VS Code
2. Nhấn F5 hoặc chọn "Run and Debug"

### Kết quả mong đợi
```
info: Microsoft.Hosting.Lifetime[14]
      Now listening on: https://localhost:7000
info: Microsoft.Hosting.Lifetime[14]
      Now listening on: http://localhost:5000
info: Microsoft.Hosting.Lifetime[0]
      Application started. Press Ctrl+C to shut down.
```

## 🧪 Bước 4: Kiểm Tra API

### 4.1. Mở Swagger UI
- Mở trình duyệt
- Truy cập: `https://localhost:7000/swagger`
- Bạn sẽ thấy danh sách tất cả API endpoints

### 4.2. Test API đầu tiên
1. Trong Swagger, tìm endpoint `POST /api/XacThuc/dang-nhap-quan-tri`
2. Click "Try it out"
3. Nhập:
```json
{
  "tenDangNhap": "admin",
  "matKhau": "admin123"
}
```
4. Click "Execute"
5. Kiểm tra Response:
   - Status Code: 200
   - Body có token JWT

### 4.3. Copy Token
- Copy giá trị `token` từ response
- Click nút "Authorize" ở đầu trang Swagger
- Paste token vào ô "Value" (có format: `Bearer {token}`)
- Click "Authorize"

Bây giờ bạn có thể gọi các API cần authentication!

## 📝 Bước 5: Test Toàn Bộ Workflow

### Sử dụng REST Client (VS Code)
1. Cài đặt extension "REST Client" trong VS Code
2. Mở file `Tests/test-apis.http`
3. Làm theo thứ tự:
   - Test đăng nhập admin
   - Copy token vào biến `@token`
   - Test thêm nhân viên
   - Test đăng ký sinh trắc học
   - Test đăng nhập nhân viên
   - Test điểm danh

### Hoặc sử dụng Postman
1. Import file `Tests/test-apis.http` vào Postman
2. Tạo Environment variable `token`
3. Test từng endpoint theo hướng dẫn trong file

## ✅ Checklist Cài Đặt

- [ ] .NET 8.0 SDK đã cài đặt
- [ ] SQL Server đang chạy
- [ ] Database đã được tạo (5 tables)
- [ ] `dotnet restore` thành công
- [ ] `dotnet build` thành công
- [ ] `dotnet run` chạy không lỗi
- [ ] Swagger UI mở được tại https://localhost:7000/swagger
- [ ] Đăng nhập admin thành công
- [ ] Nhận được JWT token
- [ ] Có thể gọi API với token

## ❌ Xử Lý Lỗi Thường Gặp

### Lỗi 1: "Unable to connect to SQL Server"
**Nguyên nhân:** SQL Server không chạy hoặc connection string sai

**Giải pháp:**
1. Kiểm tra SQL Server service đang chạy
2. Mở `appsettings.json`, kiểm tra connection string
3. Test connection trong SSMS

### Lỗi 2: "The type or namespace name could not be found"
**Nguyên nhân:** Thiếu packages

**Giải pháp:**
```bash
dotnet restore
dotnet clean
dotnet build
```

### Lỗi 3: "Port 5000 is already in use"
**Nguyên nhân:** Port đang được sử dụng

**Giải pháp:**
1. Đóng ứng dụng đang dùng port 5000
2. Hoặc thay đổi port trong `Properties/launchSettings.json`

### Lỗi 4: "Cannot create database"
**Nguyên nhân:** Không có quyền tạo database

**Giải pháp:**
- Chạy SSMS với quyền Administrator
- Hoặc yêu cầu DBA tạo database

### Lỗi 5: Swagger không load
**Nguyên nhân:** Certificate SSL không hợp lệ

**Giải pháp:**
```bash
dotnet dev-certs https --trust
```

### Lỗi 6: "Password hash không đúng"
**Nguyên nhân:** BCrypt hash không khớp

**Giải pháp:**
1. Xóa dữ liệu trong bảng QuanTriVien
2. Chạy lại ứng dụng để seed data tự động
3. Hoặc reset password bằng code

## 📚 Tài Liệu Tham Khảo

- [HUONG_DAN_TEST.md](HUONG_DAN_TEST.md) - Hướng dẫn test chi tiết
- [README_BACKEND.md](README_BACKEND.md) - Tài liệu API
- [Tests/test-apis.http](Tests/test-apis.http) - Sample API requests

## 🎯 Bước Tiếp Theo

Sau khi backend chạy thành công:
1. ✅ Test tất cả API endpoints
2. 🚧 Tạo ứng dụng Android
3. 🚧 Tích hợp biometric authentication
4. 🚧 Kết nối Android app với backend API

## 💡 Tips

- Sử dụng Swagger để test nhanh
- Dùng REST Client trong VS Code để lưu lại các request
- Check logs trong console khi có lỗi
- Backup database trước khi test

## 🆘 Cần Hỗ Trợ?

Nếu gặp vấn đề:
1. Kiểm tra logs trong console
2. Xem file `logs/ungdungdiemdanh-*.txt`
3. Đọc lại hướng dẫn từng bước
4. Kiểm tra checklist ở trên

---

**Chúc bạn cài đặt thành công! 🎉**
