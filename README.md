# Ứng dụng Điểm Danh Nhân Viên

Hệ thống quản lý điểm danh và tính lương cho doanh nghiệp nhỏ với khả năng xác thực sinh trắc học (vân tay, khuôn mặt) và thẻ NFC.

## 📋 Tính năng chính

### ✅ Đã hoàn thành

1. **Điểm danh thông minh**
   - ✨ Điểm danh vào/ra với vân tay hoặc khuôn mặt (sinh trắc học)
   - 🎫 Hỗ trợ thẻ nhân viên NFC (dự kiến)
   - ⏰ Ghi nhận thời gian vào làm và về
   - 📍 Ghi nhận vị trí GPS (optional)
   - 📸 Chụp ảnh xác nhận khi điểm danh

2. **Quản lý nhân viên (Admin)**
   - 👥 Thêm/cập nhật/đóng tài khoản nhân viên
   - 🔍 Tìm kiếm và lọc nhân viên
   - 📝 Chấm công thủ công cho nhân viên
   - 👁️ Xem chi tiết lịch sử điểm danh từng nhân viên

3. **Báo cáo thống kê**
   - 📊 Báo cáo tuần/tháng/quý/năm
   - 📈 Thống kê tổng giờ làm, số ngày làm việc, đi muộn, về sớm
   - 💼 Báo cáo cho từng nhân viên hoặc toàn công ty
   - 📧 Gửi báo cáo qua email tự động

4. **Quản lý lương**
   - 💰 Tính lương theo tuần/tháng dựa trên số giờ làm
   - 🎁 Thêm thưởng/khấu trừ
   - 📜 Lịch sử lương của nhân viên
   - 🔢 Tự động tính toán dựa trên giờ công chuẩn

5. **Xác thực & Bảo mật**
   - 🔐 Đăng nhập với JWT authentication
   - 👆 Xác thực sinh trắc học (vân tay/Face ID)
   - 🔑 Phân quyền Admin và Nhân viên
   - 🛡️ Mã hóa mật khẩu với BCrypt

## 🏗️ Kiến trúc hệ thống

### Backend: ASP.NET Core 8
```
UngDungDiemDanhNhanVien/
├── Controllers/          # API endpoints
│   ├── XacThucController.cs       # Authentication APIs
│   ├── NhanVienController.cs      # Employee management
│   ├── DiemDanhController.cs      # Attendance APIs
│   ├── BaoCaoController.cs        # Report APIs
│   └── LuongController.cs         # Salary APIs
├── Models/               # Database models
│   ├── NhanVien.cs       # Employee model
│   ├── QuanTriVien.cs    # Admin model
│   ├── DiemDanh.cs       # Attendance model
│   ├── Luong.cs          # Salary model
│   └── NhatKyEmail.cs    # Email log model
├── Services/             # Business logic
│   ├── XacThucService.cs
│   ├── NhanVienService.cs
│   ├── DiemDanhService.cs
│   ├── BaoCaoService.cs
│   ├── LuongService.cs
│   └── EmailService.cs
├── DTOs/                 # Data transfer objects
├── Data/                 # Database context
└── Migrations/           # EF Core migrations
```

### Mobile App: Flutter
```
ung_dung_diem_danh/
├── lib/
│   ├── screens/
│   │   ├── auth/                  # Đăng nhập, đăng ký
│   │   ├── employee/              # Màn hình nhân viên
│   │   │   ├── man_hinh_chu_nhan_vien.dart
│   │   │   ├── man_hinh_diem_danh.dart
│   │   │   ├── man_hinh_lich_su_diem_danh.dart
│   │   │   └── man_hinh_ho_so.dart
│   │   └── admin/                 # Màn hình admin
│   │       ├── man_hinh_tong_quan_admin.dart
│   │       ├── man_hinh_quan_ly_user.dart
│   │       ├── man_hinh_bao_cao_tuan.dart
│   │       ├── man_hinh_bao_cao_thang.dart
│   │       ├── man_hinh_bao_cao_quy.dart
│   │       └── man_hinh_bao_cao_nam.dart
│   ├── models/           # Data models
│   ├── services/         # API services
│   ├── blocs/            # State management (BLoC)
│   └── config/           # Configuration & constants
```

## 🛠️ Tech Stack

### Backend
- **Framework**: ASP.NET Core 8 (C#)
- **Database**: SQL Server
- **ORM**: Entity Framework Core
- **Authentication**: JWT Bearer Token
- **Email**: MailKit/MimeKit
- **Background Jobs**: Hangfire
- **Logging**: Serilog
- **Security**: BCrypt.Net

### Mobile App
- **Framework**: Flutter (Dart)
- **State Management**: BLoC Pattern
- **HTTP Client**: Dio
- **Local Storage**: Shared Preferences
- **Biometric**: local_auth
- **GPS**: geolocator
- **Camera**: image_picker
- **Charts**: fl_chart

### Database Schema

**Bảng chính:**
- `NhanVien` - Thông tin nhân viên
- `QuanTriVien` - Thông tin admin
- `DiemDanh` - Bản ghi điểm danh
- `Luong` - Bảng lương
- `NhatKyEmail` - Lịch sử gửi email

## 🚀 Cài đặt và Chạy

### Backend (.NET)

```bash
# Di chuyển vào thư mục backend
cd UngDungDiemDanhNhanVien

# Restore packages
dotnet restore

# Update database (chạy migrations)
dotnet ef database update

# Chạy ứng dụng
dotnet run
```

Backend sẽ chạy tại: `https://localhost:7095` hoặc `http://localhost:5095`

### Mobile App (Flutter)

```bash
# Di chuyển vào thư mục Flutter
cd ung_dung_diem_danh

# Cài đặt dependencies
flutter pub get

# Cấu hình URL backend (nếu cần)
# Chỉnh sửa file: lib/config/constants.dart

# Chạy ứng dụng (Android)
flutter run

# Hoặc build APK
flutter build apk --release
```

## ⚙️ Cấu hình

### Backend Configuration

Chỉnh sửa file `appsettings.json`:

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=YOUR_SERVER;Database=UngDungDiemDanh;..."
  },
  "JwtSettings": {
    "SecretKey": "YOUR_SECRET_KEY",
    "Issuer": "UngDungDiemDanh",
    "Audience": "UngDungDiemDanhUsers",
    "ExpiryMinutes": 1440
  },
  "EmailSettings": {
    "SmtpServer": "smtp.gmail.com",
    "SmtpPort": 587,
    "SenderEmail": "your-email@gmail.com",
    "SenderPassword": "your-app-password"
  }
}
```

### Flutter Configuration

Chỉnh sửa file `lib/config/constants.dart`:

```dart
class ApiConstants {
  // Đổi URL này thành địa chỉ backend của bạn
  static const String baseUrl = 'http://YOUR_IP:5095/api';
}
```

## 📱 Hướng dẫn sử dụng

### Cho Nhân viên

1. **Đăng nhập** bằng mã nhân viên và mật khẩu
2. **Đăng ký sinh trắc học** (vân tay/Face ID) lần đầu
3. **Điểm danh vào** mỗi sáng bằng vân tay
4. **Điểm danh ra** khi tan làm
5. **Xem lịch sử** điểm danh và thống kê cá nhân
6. **Xem lương** hàng tuần/tháng
7. **Nhận email** báo cáo tự động

### Cho Admin

1. **Đăng nhập** với tài khoản admin
2. **Quản lý nhân viên**: Thêm/sửa/đóng tài khoản
3. **Chấm công thủ công** cho nhân viên (nếu cần)
4. **Xem báo cáo** tuần/tháng/quý/năm
5. **Tính lương** cho nhân viên
6. **Gửi báo cáo email** tự động hoặc thủ công
7. **Xem dashboard** tổng quan

## 📊 API Endpoints

### Authentication
- `POST /api/XacThuc/dang-nhap-admin` - Đăng nhập admin
- `POST /api/XacThuc/dang-nhap-nhan-vien` - Đăng nhập nhân viên
- `POST /api/XacThuc/dang-ky-admin` - Đăng ký admin mới

### Employee Management (Admin)
- `GET /api/NhanVien` - Danh sách nhân viên
- `GET /api/NhanVien/{id}` - Chi tiết nhân viên
- `POST /api/NhanVien` - Thêm nhân viên
- `PUT /api/NhanVien/{id}` - Cập nhật nhân viên
- `DELETE /api/NhanVien/{id}` - Xóa nhân viên

### Attendance
- `POST /api/DiemDanh/diem-danh-vao` - Điểm danh vào
- `POST /api/DiemDanh/diem-danh-ra` - Điểm danh ra
- `GET /api/DiemDanh/lich-su/{nhanVienId}` - Lịch sử điểm danh
- `POST /api/DiemDanh/cham-cong-thu-cong` - Chấm công thủ công (admin)

### Reports
- `GET /api/BaoCao/tuan` - Báo cáo tuần
- `GET /api/BaoCao/thang` - Báo cáo tháng
- `GET /api/BaoCao/quy` - Báo cáo quý
- `GET /api/BaoCao/nam` - Báo cáo năm
- `POST /api/BaoCao/gui-email` - Gửi báo cáo email

### Salary
- `GET /api/Luong` - Danh sách lương
- `POST /api/Luong/tinh-luong` - Tính lương
- `GET /api/Luong/nhan-vien/{nhanVienId}` - Lương của nhân viên

## 🔒 Bảo mật

- ✅ Mật khẩu được mã hóa với BCrypt
- ✅ JWT token cho authentication
- ✅ HTTPS cho production (khuyến nghị)
- ✅ Input validation trên mọi API
- ✅ Role-based authorization (Admin/Employee)
- ✅ Rate limiting (dự kiến)

## 📧 Tự động hóa

### Email tự động (Hangfire)
- 📅 Gửi báo cáo tuần mỗi Chủ nhật
- 📅 Gửi báo cáo tháng vào ngày 1 hàng tháng
- 📅 Gửi bảng lương vào cuối tháng
- ⏰ Nhắc nhở điểm danh (dự kiến)

### Background Jobs
- Tự động tính lương
- Xóa dữ liệu cũ (log, email history)
- Backup database định kỳ (dự kiến)

## 📈 Tính năng dự kiến (Phase 2)

### Đang phát triển
- 🏢 Quản lý phòng ban
- 📅 Quản lý ca làm việc (sáng/chiều/đêm)
- 🏖️ Yêu cầu nghỉ phép
- ⏰ Đăng ký tăng ca
- 🔔 Push notifications (Firebase)
- 📍 Geofencing (giới hạn vùng điểm danh)
- 📊 Dashboard analytics nâng cao
- 📄 Export Excel/PDF

### Tính năng nâng cao
- 👥 Role Manager (phân quyền chi tiết)
- 📸 Chụp ảnh xác nhận điểm danh
- 🌐 Multi-language support
- 📱 Web admin panel
- 🎫 NFC card reader integration
- 🤖 AI phát hiện gian lận

## 🧪 Testing

### Backend
```bash
# Chạy tests
dotnet test

# Test API với Swagger
# Truy cập: https://localhost:7095/swagger
```

### Mobile
```bash
# Chạy tests
flutter test

# Integration tests
flutter drive --target=test_driver/app.dart
```

## 📝 Tài liệu tham khảo

- [Backend README](./UngDungDiemDanhNhanVien/README_BACKEND.md)
- [Flutter Setup](./ung_dung_diem_danh/README.md)
- [API Documentation](./UngDungDiemDanhNhanVien/HUONG_DAN_TEST.md)
- [Troubleshooting](./ung_dung_diem_danh/SUA_LOI_BUILD.md)

## 🐛 Troubleshooting

### Lỗi thường gặp

**Backend không kết nối được database:**
```bash
# Kiểm tra connection string trong appsettings.json
# Chạy lại migrations
dotnet ef database update
```

**Flutter không kết nối được API:**
- Kiểm tra `baseUrl` trong `lib/config/constants.dart`
- Trên Android emulator, dùng `http://10.0.2.2:5095` thay vì `localhost`
- Trên iOS simulator, dùng `http://localhost:5095`
- Trên thiết bị thật, dùng IP máy tính: `http://192.168.x.x:5095`

**Sinh trắc học không hoạt động:**
- Đảm bảo đã cấp quyền trong app settings
- Test trên thiết bị thật (emulator không hỗ trợ đầy đủ)
- iOS: Cấu hình Face ID trong simulator

## 👥 Contributors

- **Developer**: Team NHViet
- **Project**: Đồ án Lập trình Di động

## 📄 License

Copyright © 2025. All rights reserved.

---

## 🎯 Roadmap

### ✅ Phase 1 (Hoàn thành)
- [x] Backend API (.NET Core)
- [x] Database schema (SQL Server)
- [x] Authentication & Authorization
- [x] Employee Management
- [x] Attendance tracking
- [x] Report generation
- [x] Salary calculation
- [x] Email service
- [x] Flutter mobile app
- [x] Biometric authentication
- [x] Admin & Employee screens

### 🚧 Phase 2 (Đang phát triển)
- [ ] NFC card support
- [ ] Geofencing
- [ ] Photo verification
- [ ] Push notifications
- [ ] Leave management
- [ ] Overtime tracking
- [ ] Advanced analytics

### 🔮 Phase 3 (Tương lai)
- [ ] Web admin panel
- [ ] Multi-language
- [ ] Export reports (Excel/PDF)
- [ ] AI anomaly detection
- [ ] IoT device integration

---

**🌟 Nếu bạn thấy project hữu ích, đừng quên cho một ⭐ trên GitHub!**
