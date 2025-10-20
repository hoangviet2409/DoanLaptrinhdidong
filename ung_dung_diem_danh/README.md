# Ứng Dụng Điểm Danh Nhân Viên - Flutter

Ứng dụng mobile điểm danh nhân viên được xây dựng với Flutter, kết nối với backend .NET API.

## 🚀 Cài Đặt

### Yêu Cầu
- Flutter SDK >= 3.0.0
- Dart SDK >= 3.0.0
- Android Studio / VS Code
- Android device hoặc emulator

### Bước 1: Cài đặt dependencies
```bash
flutter pub get
```

### Bước 2: Cấu hình Backend URL
Mở file `lib/config/constants.dart` và cập nhật:
```dart
static const String baseUrl = 'https://YOUR_BACKEND_IP:7000/api';
```

**Lưu ý:** Nếu chạy trên emulator:
- Android emulator: Dùng `https://10.0.2.2:7000/api`
- Real device: Dùng IP máy tính (vd: `https://192.168.1.100:7000/api`)

### Bước 3: Chạy ứng dụng
```bash
flutter run
```

## 📱 Chức Năng

### ✅ Đã Hoàn Thành
- [x] Đăng nhập Admin
- [x] Đăng nhập Nhân Viên
- [x] Lưu token JWT
- [x] Màn hình chủ Nhân Viên
- [x] Màn hình tổng quan Admin
- [x] Logout

### 🚧 Đang Phát Triển
- [ ] Điểm danh vào/ra với API
- [ ] Lịch sử điểm danh
- [ ] Xác thực sinh trắc học (Biometric)
- [ ] GPS tracking
- [ ] Camera verification
- [ ] Push notifications

## 🏗️ Cấu Trúc Dự Án

```
lib/
├── main.dart                 # Entry point
├── config/
│   ├── constants.dart        # API URLs, constants
│   ├── theme.dart           # App theme
│   └── routes.dart          # Navigation routes
├── models/                  # Data models
│   ├── dang_nhap_request.dart
│   ├── dang_nhap_response.dart
│   └── user_model.dart
├── services/                # API & Business logic
│   ├── api_service.dart     # Dio HTTP client
│   └── auth_service.dart    # Authentication service
├── blocs/                   # State management (BLoC)
│   └── auth/
│       ├── auth_bloc.dart
│       ├── auth_event.dart
│       └── auth_state.dart
├── screens/                 # UI Screens
│   ├── auth/
│   │   └── man_hinh_dang_nhap.dart
│   ├── employee/
│   │   └── man_hinh_chu_nhan_vien.dart
│   └── admin/
│       └── man_hinh_tong_quan_admin.dart
└── widgets/                 # Reusable widgets
```

## 🧪 Test Đăng Nhập

### Test Admin
- Tên đăng nhập: `admin`
- Mật khẩu: `admin123`

### Test Nhân Viên
1. Trước tiên phải tạo nhân viên trong backend
2. Đăng ký mã sinh trắc học qua API
3. Dùng mã nhân viên + mã sinh trắc học để đăng nhập

## 📖 Hướng Dẫn Sử Dụng

### 1. Đăng Nhập Admin
- Mở app
- Chọn tab "Quản Trị Viên"
- Nhập: admin / admin123
- Nhấn "Đăng Nhập"

### 2. Đăng Nhập Nhân Viên
- Mở app
- Chọn tab "Nhân Viên"
- Nhập mã nhân viên và mã sinh trắc học
- Nhấn "Đăng Nhập"

## 🔧 Troubleshooting

### Lỗi: Cannot connect to backend
- Kiểm tra backend đang chạy tại `https://localhost:7000`
- Kiểm tra IP address trong `constants.dart`
- Nếu dùng Android emulator, dùng `10.0.2.2` thay vì `localhost`

### Lỗi: SSL Certificate
- App đã tắt SSL verification cho development
- Chỉ dùng cho testing, không deploy production!

### Lỗi: Package not found
```bash
flutter clean
flutter pub get
flutter pub upgrade
```

## 📦 Dependencies Chính

- `flutter_bloc`: State management
- `dio`: HTTP client
- `shared_preferences`: Local storage
- `go_router`: Navigation
- `local_auth`: Biometric authentication
- `geolocator`: GPS tracking
- `image_picker`: Camera
- `fl_chart`: Charts
- `firebase_messaging`: Push notifications

## 🚀 Build APK

### Debug APK
```bash
flutter build apk --debug
```

### Release APK
```bash
flutter build apk --release
```

APK file: `build/app/outputs/flutter-apk/app-release.apk`

## 📱 Chạy Trên Real Device

1. Bật Developer Options trên Android
2. Bật USB Debugging
3. Kết nối device với máy tính
4. Chạy: `flutter devices` để xem device
5. Chạy: `flutter run`

## 📝 Lưu Ý

- Backend phải chạy trước khi test app
- Đảm bảo device/emulator có thể kết nối đến backend
- Dùng IP máy tính, không dùng localhost khi test trên real device
- SSL certificate đã tắt cho development

## 🔄 Bước Tiếp Theo

1. Test đăng nhập thành công
2. Implement điểm danh vào/ra
3. Thêm biometric authentication
4. Thêm GPS tracking
5. Implement các màn hình còn lại

---

**Phiên bản:** 1.0.0  
**Ngày:** 19/10/2025  
**Backend API:** https://localhost:7000/api

