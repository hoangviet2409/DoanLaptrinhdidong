# Ứng Dụng Điểm Danh Nhân Viên - Backend API

## Giới thiệu
Backend API cho ứng dụng điểm danh nhân viên được xây dựng với .NET 8.0, SQL Server và JWT Authentication.

## Công nghệ sử dụng
- **.NET 8.0** - Framework chính
- **Entity Framework Core** - ORM
- **SQL Server** - Database
- **JWT** - Authentication
- **BCrypt** - Mã hóa mật khẩu
- **Swagger** - API Documentation
- **MailKit** - Email service
- **Hangfire** - Background jobs
- **Serilog** - Logging

## Cấu trúc thư mục
```
UngDungDiemDanhNhanVien/
├── Controllers/           # API Controllers
│   ├── XacThucController.cs
│   ├── NhanVienController.cs
│   └── DiemDanhController.cs
├── Models/               # Entity Models
│   ├── NhanVien.cs
│   ├── QuanTriVien.cs
│   ├── DiemDanh.cs
│   ├── Luong.cs
│   └── NhatKyEmail.cs
├── DTOs/                 # Data Transfer Objects
│   ├── DangNhapRequest.cs
│   ├── DangNhapResponse.cs
│   └── DiemDanhRequest.cs
├── Services/             # Business Logic
│   ├── XacThucService.cs
│   ├── NhanVienService.cs
│   ├── DiemDanhService.cs
│   ├── BaoCaoService.cs
│   ├── LuongService.cs
│   └── EmailService.cs
├── Data/                 # Database Context
│   └── UngDungDiemDanhContext.cs
├── Helpers/              # Helper Classes
│   └── EmailTemplates.cs
├── Database/             # SQL Scripts
│   └── TaoDatabase.sql
├── Tests/                # Test Files
│   └── test-apis.http
├── appsettings.json      # Cấu hình
└── Program.cs            # Entry point

```

## Cài đặt và Chạy

### Yêu cầu
- .NET 8.0 SDK
- SQL Server 2019+
- Visual Studio 2022 hoặc VS Code

### Bước 1: Clone và Restore
```bash
cd UngDungDiemDanhNhanVien
dotnet restore
```

### Bước 2: Cấu hình Database
1. Mở `appsettings.json`
2. Cập nhật connection string:
```json
"ConnectionStrings": {
  "DefaultConnection": "Server=YOUR_SERVER;Database=UngDungDiemDanhNhanVien;..."
}
```

### Bước 3: Tạo Database
1. Mở SQL Server Management Studio
2. Chạy file `Database/TaoDatabase.sql`

### Bước 4: Chạy ứng dụng
```bash
dotnet run
```

Hoặc sử dụng Visual Studio:
- Mở solution
- Nhấn F5 để chạy

### Bước 5: Truy cập Swagger
Mở trình duyệt: `https://localhost:7000/swagger`

## API Endpoints

### Xác Thực
- `POST /api/XacThuc/dang-nhap-quan-tri` - Đăng nhập quản trị viên
- `POST /api/XacThuc/dang-nhap-nhan-vien` - Đăng nhập nhân viên
- `POST /api/XacThuc/xac-thuc-sinh-trac-hoc` - Xác thực sinh trắc học

### Quản Lý Nhân Viên (Admin only)
- `GET /api/NhanVien` - Lấy danh sách nhân viên
- `GET /api/NhanVien/{id}` - Lấy thông tin nhân viên
- `POST /api/NhanVien` - Thêm nhân viên mới
- `PUT /api/NhanVien/{id}` - Cập nhật nhân viên
- `DELETE /api/NhanVien/{id}` - Xóa nhân viên
- `PUT /api/NhanVien/{id}/trang-thai` - Cập nhật trạng thái
- `PUT /api/NhanVien/{id}/dang-ky-sinh-trac-hoc` - Đăng ký sinh trắc học

### Điểm Danh
- `POST /api/DiemDanh/diem-danh-vao` - Điểm danh vào
- `POST /api/DiemDanh/diem-danh-ra` - Điểm danh ra
- `GET /api/DiemDanh/lich-su-ca-nhan` - Lịch sử điểm danh cá nhân
- `GET /api/DiemDanh/lich-su/{nhanVienId}` - Lịch sử điểm danh theo nhân viên
- `GET /api/DiemDanh/theo-ngay` - Điểm danh theo ngày (Admin)
- `POST /api/DiemDanh/diem-danh-thu-cong` - Chấm công thủ công (Admin)

## Xác thực và Phân quyền

### JWT Token
- Token có hiệu lực: 24 giờ
- Gửi token trong header: `Authorization: Bearer {token}`

### Vai trò
- **Admin**: Toàn quyền quản lý
- **QuanLy**: Quản lý nhân viên trong phòng ban
- **NhanVien**: Chỉ xem và điểm danh cá nhân

## Database Schema

### Bảng NhanVien
- Id, MaNhanVien, HoTen, Email
- SoDienThoai, MaSinhTracHoc, MaKhuonMat
- PhongBan, ChucVu, LuongGio
- TrangThai, NgayTao, NgayCapNhat

### Bảng QuanTriVien
- Id, TenDangNhap, MatKhauHash, Email
- VaiTro, NgayTao, NgayCapNhat

### Bảng DiemDanh
- Id, NhanVienId, GioVao, GioRa
- PhuongThucVao, PhuongThucRa
- ViDo, KinhDo, GhiChu
- QuanTriVienId, Ngay, TongGioLam, TrangThai

### Bảng Luong
- Id, NhanVienId, LoaiKy
- NgayBatDau, NgayKetThuc
- TongGioLam, LuongGio, TongTien
- Thuong, TruLuong, TongCong, TrangThai

## Testing

### Sử dụng REST Client (VS Code)
1. Cài extension "REST Client"
2. Mở file `Tests/test-apis.http`
3. Click "Send Request" để test

### Sử dụng Swagger
1. Mở `https://localhost:7000/swagger`
2. Click "Try it out" trên mỗi endpoint
3. Nhập Authorization token vào ô "Authorize"

### Tài khoản mẫu
- **Admin**: admin / admin123

## Troubleshooting

### Lỗi kết nối Database
- Kiểm tra SQL Server đang chạy
- Kiểm tra connection string trong `appsettings.json`
- Kiểm tra firewall cho phép kết nối SQL Server

### Lỗi 401 Unauthorized
- Kiểm tra token có hợp lệ
- Kiểm tra token chưa hết hạn
- Kiểm tra định dạng header: `Bearer {token}`

### Lỗi migration
```bash
dotnet ef database drop
dotnet ef migrations remove
dotnet ef migrations add InitialCreate
dotnet ef database update
```

## Phát triển tiếp

### Giai đoạn 1 (Hoàn thành)
- ✅ Xác thực và phân quyền
- ✅ Quản lý nhân viên
- ✅ Điểm danh vào/ra
- ✅ Lịch sử điểm danh

### Giai đoạn 2 (Sắp tới)
- [ ] Quản lý ca làm việc
- [ ] Quản lý nghỉ phép
- [ ] Quản lý tăng ca
- [ ] Báo cáo và thống kê
- [ ] Tính lương tự động
- [ ] Push notifications
- [ ] GPS tracking
- [ ] Camera verification

## Liên hệ và Hỗ trợ
- Email: support@congty.com
- Tài liệu: Xem file `HUONG_DAN_TEST.md`
