# 🚀 Hướng Dẫn Chạy và Test Flutter App

## ✅ Bước 1: Kiểm Tra Yêu Cầu

### Kiểm tra Flutter đã cài đặt
```bash
flutter --version
flutter doctor
```

Kết quả mong đợi:
```
Flutter 3.x.x
Dart 3.x.x
✓ Flutter (Channel stable)
✓ Android toolchain
```

## 📦 Bước 2: Cài Đặt Dependencies

```bash
cd ung_dung_diem_danh
flutter pub get
```

## ⚙️ Bước 3: Cấu Hình Backend URL

### Nếu test trên Android Emulator:
Mở `lib/config/constants.dart`, sửa:
```dart
static const String baseUrl = 'https://10.0.2.2:7000/api';
```

### Nếu test trên Real Device:
1. Tìm IP máy tính:
```bash
# Windows
ipconfig
# Tìm IPv4 Address (vd: 192.168.1.100)
```

2. Sửa `constants.dart`:
```dart
static const String baseUrl = 'https://192.168.1.100:7000/api';
```

3. **Backend phải cho phép IP từ xa:**
   - Mở firewall cho port 7000
   - Hoặc chạy backend với: `dotnet run --urls="https://0.0.0.0:7000"`

## ▶️ Bước 4: Chạy Backend

```bash
cd UngDungDiemDanhNhanVien
dotnet run
```

Đảm bảo backend chạy thành công tại: `https://localhost:7000`

## 📱 Bước 5: Chạy Flutter App

### Option 1: Chạy trên Android Emulator
1. Mở Android Studio > AVD Manager
2. Start một emulator
3. Chạy:
```bash
flutter run
```

### Option 2: Chạy trên Real Device
1. Kết nối điện thoại qua USB
2. Bật USB Debugging
3. Kiểm tra:
```bash
flutter devices
```
4. Chạy:
```bash
flutter run
```

## 🧪 Bước 6: Test Đăng Nhập

### Test 1: Đăng Nhập Admin

1. Mở app
2. Chọn tab **"Quản Trị Viên"**
3. Nhập:
   - Tên đăng nhập: `admin`
   - Mật khẩu: `admin123`
4. Nhấn **"Đăng Nhập"**

**Kết quả mong đợi:**
- ✅ Hiển thị màn hình "Tổng Quan Admin"
- ✅ Có tên "admin" ở trên cùng
- ✅ Hiển thị các thống kê và menu

### Test 2: Đăng Nhập Nhân Viên

**Trước tiên cần tạo nhân viên:**

1. Mở Swagger: `https://localhost:7000/swagger`
2. POST `/api/NhanVien` - Thêm nhân viên:
```json
{
  "maNhanVien": "NV001",
  "hoTen": "Nguyễn Văn A",
  "email": "nguyenvana@test.com",
  "soDienThoai": "0912345678",
  "phongBan": "IT",
  "chucVu": "Dev",
  "luongGio": 50000,
  "trangThai": "HoatDong"
}
```

3. PUT `/api/NhanVien/1/dang-ky-sinh-trac-hoc`:
```json
"BIOMETRIC123"
```

**Bây giờ test trong app:**

1. Đăng xuất khỏi admin
2. Chọn tab **"Nhân Viên"**
3. Nhập:
   - Mã nhân viên: `NV001`
   - Mã sinh trắc học: `BIOMETRIC123`
4. Nhấn **"Đăng Nhập"**

**Kết quả mong đợi:**
- ✅ Hiển thị màn hình "Trang Chủ Nhân Viên"
- ✅ Có tên "Nguyễn Văn A"
- ✅ Hiển thị nút "Điểm Danh Vào" và "Điểm Danh Ra"

## ✅ Checklist Test

### Đăng Nhập
- [ ] Đăng nhập admin thành công
- [ ] Hiển thị màn hình admin đúng
- [ ] Đăng xuất admin thành công
- [ ] Đăng nhập nhân viên thành công
- [ ] Hiển thị màn hình nhân viên đúng
- [ ] Token được lưu (kiểm tra bằng đăng xuất và mở lại app)

### UI/UX
- [ ] Giao diện đẹp, không bị lỗi
- [ ] Form validation hoạt động
- [ ] Loading indicator hiển thị khi đăng nhập
- [ ] Error message hiển thị khi đăng nhập sai
- [ ] Tab chuyển đổi mượt mà

## ❌ Xử Lý Lỗi

### Lỗi: "Không thể kết nối đến server"

**Nguyên nhân:** Backend không chạy hoặc URL sai

**Giải pháp:**
1. Kiểm tra backend đang chạy: `https://localhost:7000`
2. Kiểm tra URL trong `constants.dart`
3. Nếu dùng emulator: dùng `10.0.2.2` thay vì `localhost`
4. Nếu dùng real device: dùng IP máy tính

### Lỗi: "SSL Handshake failed"

**Nguyên nhân:** Certificate không hợp lệ

**Giải pháp:**
- Code đã tắt SSL verification cho development
- Nếu vẫn lỗi, check `api_service.dart` line 40-45

### Lỗi: "Đăng nhập thất bại"

**Nguyên nhân:** Sai username/password hoặc backend lỗi

**Giải pháp:**
1. Kiểm tra console logs
2. Kiểm tra backend logs
3. Test API trong Swagger trước

### Lỗi: Build failed

```bash
flutter clean
flutter pub get
flutter run
```

## 📊 Debug Tips

### Xem Logs
```bash
flutter logs
```

### Hot Reload (khi app đang chạy)
```
r - Hot reload
R - Hot restart  
q - Quit
```

### Debug Mode
App đang chạy ở debug mode, có thể:
- Xem full logs
- Hot reload khi sửa code
- Debug với breakpoints

## 🎯 Bước Tiếp Theo

Sau khi test đăng nhập thành công:

1. ✅ **HOÀN THÀNH:** Test đăng nhập Admin
2. ✅ **HOÀN THÀNH:** Test đăng nhập Nhân viên
3. 🚧 **TIẾP THEO:** Implement điểm danh vào/ra
4. 🚧 **SAU ĐÓ:** Thêm biometric authentication
5. 🚧 **CUỐI CÙNG:** GPS tracking và camera

## 💡 Lưu Ý Quan Trọng

- Backend phải chạy trước khi test app
- Dùng IP máy tính khi test trên real device
- SSL đã tắt cho development - **CHỈ DÙNG ĐỂ TEST**
- Token được lưu trong SharedPreferences
- Đăng xuất sẽ xóa token

## 📞 Cần Hỗ Trợ?

1. Check backend logs
2. Check Flutter console logs
3. Test API trong Swagger trước
4. Đọc lại file README.md

---

**Chúc bạn test thành công! 🎉**

Sau khi test xong, báo kết quả để tiếp tục phát triển chức năng điểm danh!
