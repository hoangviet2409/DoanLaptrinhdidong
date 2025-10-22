# 🚀 Hướng dẫn Nhanh - Ứng dụng Điểm Danh

## ⚡ Chạy ứng dụng trong 5 phút

### Yêu cầu hệ thống

- ✅ Windows 10/11 hoặc macOS
- ✅ SQL Server 2019+ hoặc SQL Server Express
- ✅ .NET 8 SDK ([Download](https://dotnet.microsoft.com/download))
- ✅ Flutter 3.x ([Download](https://flutter.dev/docs/get-started/install))
- ✅ Visual Studio Code hoặc Visual Studio 2022
- ✅ Android Studio (cho Flutter)

---

## 📋 Bước 1: Setup Database

### Tạo database SQL Server

```sql
-- Mở SQL Server Management Studio (SSMS)
-- Chạy lệnh:
CREATE DATABASE UngDungDiemDanh;
GO
```

### Hoặc dùng SQL Server Express (LocalDB)

```bash
# Database sẽ tự động tạo khi chạy migrations
```

---

## 🔧 Bước 2: Setup Backend

### 2.1 Cấu hình Connection String

Mở file: `UngDungDiemDanhNhanVien/appsettings.json`

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=(localdb)\\mssqllocaldb;Database=UngDungDiemDanh;Trusted_Connection=True;TrustServerCertificate=True;"
  }
}
```

**Hoặc dùng SQL Server thật:**
```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=YOUR_SERVER_NAME;Database=UngDungDiemDanh;User Id=sa;Password=YOUR_PASSWORD;TrustServerCertificate=True;"
  }
}
```

### 2.2 Chạy Migrations

```bash
cd UngDungDiemDanhNhanVien

# Restore packages
dotnet restore

# Apply migrations (tạo tables)
dotnet ef database update

# Chạy backend
dotnet run
```

✅ Backend sẽ chạy tại: `http://localhost:5095`

### 2.3 Kiểm tra Backend

Mở trình duyệt: `http://localhost:5095/swagger`

Bạn sẽ thấy Swagger UI với tất cả API endpoints.

---

## 📱 Bước 3: Setup Flutter App

### 3.1 Cài đặt dependencies

```bash
cd ung_dung_diem_danh

# Cài packages
flutter pub get

# Kiểm tra Flutter
flutter doctor
```

### 3.2 Cấu hình URL Backend

Mở file: `lib/config/constants.dart`

```dart
class ApiConstants {
  // Chọn một trong các URL sau:
  
  // 1. Nếu test trên Android Emulator:
  static const String baseUrl = 'http://10.0.2.2:5095/api';
  
  // 2. Nếu test trên iOS Simulator:
  // static const String baseUrl = 'http://localhost:5095/api';
  
  // 3. Nếu test trên thiết bị thật (thay YOUR_IP):
  // static const String baseUrl = 'http://192.168.1.100:5095/api';
}
```

**💡 Tip**: Để tìm IP máy tính:
- Windows: `ipconfig` (tìm IPv4 Address)
- Mac/Linux: `ifconfig` hoặc `ip addr`

### 3.3 Chạy Flutter App

```bash
# Liệt kê devices
flutter devices

# Chạy app trên device/emulator đã kết nối
flutter run

# Hoặc chạy trên device cụ thể
flutter run -d chrome  # Web
flutter run -d YOUR_DEVICE_ID  # Android/iOS
```

---

## 👤 Bước 4: Đăng nhập lần đầu

### Tạo tài khoản Admin

**Option 1: Qua API (Swagger)**
1. Mở `http://localhost:5095/swagger`
2. Tìm endpoint `POST /api/XacThuc/dang-ky-admin`
3. Click "Try it out"
4. Nhập thông tin:
```json
{
  "tenDangNhap": "admin",
  "matKhau": "Admin@123",
  "email": "admin@company.com",
  "hoTen": "Quản trị viên"
}
```
5. Click "Execute"

**Option 2: Qua Flutter App**
1. Mở app → Màn hình đăng nhập
2. Click "Đăng ký" (nếu có)
3. Chọn vai trò "Quản trị viên"
4. Điền thông tin và đăng ký

### Đăng nhập Admin

```
Username: admin
Password: Admin@123
```

### Tạo nhân viên

1. Đăng nhập với tài khoản admin
2. Vào "Quản lý nhân viên"
3. Click "Thêm nhân viên mới"
4. Điền thông tin:
   - Mã nhân viên: NV001
   - Họ tên: Nguyễn Văn A
   - Email: nva@company.com
   - Số điện thoại: 0912345678
   - Mật khẩu: 123456
   - Lương theo giờ: 50000

### Đăng nhập Nhân viên

```
Mã nhân viên: NV001
Mật khẩu: 123456
```

---

## 🎯 Bước 5: Test các tính năng

### 1. Điểm danh (Nhân viên)
1. Đăng nhập với tài khoản nhân viên
2. Vào màn hình chính
3. Click "Điểm danh vào" hoặc "Điểm danh ra"
4. Xác thực bằng vân tay (nếu đã cấu hình)
5. Xem lịch sử điểm danh

### 2. Chấm công thủ công (Admin)
1. Đăng nhập admin
2. Vào "Quản lý nhân viên"
3. Chọn nhân viên
4. Click "Chấm công thủ công"
5. Chọn ngày, giờ vào, giờ ra
6. Lưu

### 3. Xem báo cáo
1. Đăng nhập admin
2. Vào "Báo cáo"
3. Chọn loại báo cáo: Tuần/Tháng/Quý/Năm
4. Chọn nhân viên (hoặc để trống = tất cả)
5. Xem thống kê

### 4. Tính lương
1. Đăng nhập admin
2. Vào "Quản lý lương"
3. Chọn kỳ lương: Tuần/Tháng
4. Click "Tính lương"
5. Xem kết quả

---

## 🐛 Xử lý lỗi thường gặp

### ❌ Backend không chạy được

**Lỗi: Cannot connect to SQL Server**
```bash
# Kiểm tra SQL Server đang chạy
# Windows: Mở Services → tìm "SQL Server"

# Hoặc thử connection string LocalDB:
"Server=(localdb)\\mssqllocaldb;Database=UngDungDiemDanh;..."
```

**Lỗi: Migration failed**
```bash
# Xóa database và tạo lại
dotnet ef database drop -f
dotnet ef database update
```

### ❌ Flutter không kết nối được API

**Lỗi: Connection refused**
1. Kiểm tra backend đã chạy: `http://localhost:5095/swagger`
2. Kiểm tra URL trong `constants.dart`
3. Nếu dùng Android Emulator: Dùng `http://10.0.2.2:5095`
4. Nếu dùng thiết bị thật: Dùng IP máy tính

**Lỗi: Certificate/SSL error**
```dart
// Thêm vào file constants.dart (CHỈ cho development):
static const String baseUrl = 'http://localhost:5095/api'; // Dùng HTTP thay vì HTTPS
```

### ❌ Sinh trắc học không hoạt động

1. Test trên **thiết bị thật** (emulator không đầy đủ tính năng)
2. Cấp quyền trong Settings → App → Permissions
3. Đảm bảo đã đăng ký vân tay trong Settings điện thoại

---

## 📞 Cần trợ giúp?

### Tài liệu chi tiết
- [README.md](./README.md) - Tổng quan dự án
- [CHANGELOG.md](./CHANGELOG.md) - Lịch sử thay đổi
- [Backend Guide](./UngDungDiemDanhNhanVien/HUONG_DAN_TEST.md)
- [Flutter Setup](./ung_dung_diem_danh/README.md)

### Báo lỗi
- Tạo Issue trên GitHub
- Hoặc liên hệ team developer

---

## ✨ Tips & Tricks

### Backend Development
```bash
# Hot reload (file watcher)
dotnet watch run

# Tạo migration mới
dotnet ef migrations add TenMigration

# Xem SQL sẽ chạy
dotnet ef migrations script

# Rollback migration
dotnet ef database update TenMigrationTruoc
```

### Flutter Development
```bash
# Hot reload: Nhấn 'r' trong terminal
# Hot restart: Nhấn 'R'

# Clear cache nếu lỗi
flutter clean
flutter pub get

# Build release APK
flutter build apk --release

# Xem logs
flutter logs
```

---

## 🎉 Hoàn thành!

Bây giờ bạn đã có:
- ✅ Backend API chạy tại `http://localhost:5095`
- ✅ Flutter app kết nối thành công
- ✅ Tài khoản admin để quản lý
- ✅ Tài khoản nhân viên để test điểm danh

**Chúc bạn sử dụng vui vẻ! 🚀**

