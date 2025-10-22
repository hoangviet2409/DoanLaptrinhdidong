# 🚀 Hướng Dẫn Chạy App Trên Máy Thật

## 📋 Bước 1: Tìm IP của máy tính

### Windows:
```cmd
ipconfig
```
Tìm dòng có dạng: `IPv4 Address. . . . . . . . . . . : 192.168.1.xxx`

### Hoặc PowerShell:
```powershell
Get-NetIPAddress -AddressFamily IPv4 | Where-Object {$_.IPAddress -like "192.168.*"}
```

## 📋 Bước 2: Cập nhật IP trong code

### Cách 1: Tự động (Khuyến nghị)
```bash
# Chạy script tự động cập nhật IP
scripts/update_ip.bat
```

### Cách 2: Thủ công
Mở file `lib/config/constants.dart` và thay đổi:

```dart
static const String baseUrl = 'http://192.168.1.100:5095/api'; // Thay IP này
```

**Ví dụ:** Nếu IP máy tính là `192.168.1.50`, thì sửa thành:
```dart
static const String baseUrl = 'http://192.168.1.50:5095/api';
```

## 📋 Bước 3: Kiểm tra Backend

### Kiểm tra backend có chạy không:
```cmd
netstat -an | findstr :5095
```

### Nếu chưa chạy, khởi động backend:
```cmd
cd UngDungDiemDanhNhanVien
dotnet run
```

## 📋 Bước 4: Cấu hình Firewall (nếu cần)

### Mở port 5095:
```cmd
netsh advfirewall firewall add rule name="Flutter API" dir=in action=allow protocol=TCP localport=5095
```

## 📋 Bước 5: Chạy app trên máy thật

### Kết nối điện thoại qua USB:
```bash
flutter devices
```

### Chạy app:
```bash
flutter run
```

## 🔧 Troubleshooting

### Lỗi timeout:
1. ✅ Kiểm tra IP có đúng không
2. ✅ Kiểm tra backend có chạy không  
3. ✅ Kiểm tra firewall có chặn không
4. ✅ Kiểm tra máy tính và điện thoại cùng mạng WiFi

### Lỗi CORS:
Backend đã cấu hình CORS cho phép tất cả origin.

### Lỗi SSL:
Dùng HTTP thay vì HTTPS cho môi trường development.

## 📱 Test trên máy thật

1. **Đăng nhập Admin**: `admin` / `admin123`
2. **Tạo nhân viên**: Thêm thông tin + quét thẻ NFC
3. **Đăng nhập nhân viên**: Dùng mã nhân viên vừa tạo
4. **Điểm danh**: Bấm nút "Điểm danh bằng thẻ NFC"

## 🎯 Lưu ý quan trọng

- **IP thay đổi**: Mỗi lần kết nối WiFi khác, IP có thể thay đổi
- **NFC chỉ hoạt động trên máy thật**: Emulator không hỗ trợ NFC
- **Backend phải chạy**: Đảm bảo backend đang chạy trên port 5095
- **Cùng mạng**: Máy tính và điện thoại phải cùng mạng WiFi

## 🔄 Chuyển đổi giữa Emulator và Máy thật

### Chạy trên Emulator:
```dart
return _emulatorUrl; // Trong _getBaseUrl()
```

### Chạy trên Máy thật:
```dart
return _deviceUrl; // Trong _getBaseUrl()
```
