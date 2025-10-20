# ⚙️ Cấu Hình Backend URL

## 🎯 Quan Trọng: Cấu Hình URL Backend

Flutter app cần biết địa chỉ backend để kết nối. Tùy theo bạn test trên **Emulator** hay **Real Device**, cấu hình sẽ khác nhau.

---

## 📱 Option 1: Test Trên Android Emulator

### Bước 1: Mở file cấu hình
Mở file: `lib/config/constants.dart`

### Bước 2: Sửa baseUrl
```dart
static const String baseUrl = 'https://10.0.2.2:7000/api';
```

**Giải thích:** 
- `10.0.2.2` là địa chỉ đặc biệt trong Android emulator
- Nó trỏ về `localhost` của máy host (máy tính của bạn)

---

## 📲 Option 2: Test Trên Real Device

### Bước 1: Tìm IP máy tính

**Windows:**
```cmd
ipconfig
```
Tìm dòng `IPv4 Address`, ví dụ: `192.168.1.100`

**Mac/Linux:**
```bash
ifconfig
```

### Bước 2: Sửa baseUrl
Mở file: `lib/config/constants.dart`

```dart
static const String baseUrl = 'https://192.168.1.100:7000/api';
```

**Thay `192.168.1.100` bằng IP máy tính của bạn!**

### Bước 3: Cấu hình Backend cho phép kết nối từ xa

**Option A: Mở Firewall (Khuyến nghị)**
1. Windows Defender Firewall
2. Allow port 7000
3. Chạy backend như bình thường

**Option B: Chạy backend với HTTPS cho tất cả interfaces**

Sửa `UngDungDiemDanhNhanVien/Properties/launchSettings.json`:
```json
{
  "profiles": {
    "https": {
      "commandName": "Project",
      "dotnetRunMessages": true,
      "launchBrowser": true,
      "launchUrl": "swagger",
      "applicationUrl": "https://0.0.0.0:7000;http://0.0.0.0:5000",
      "environmentVariables": {
        "ASPNETCORE_ENVIRONMENT": "Development"
      }
    }
  }
}
```

Hoặc chạy trực tiếp:
```bash
dotnet run --urls="https://0.0.0.0:7000"
```

### Bước 4: Đảm bảo cùng WiFi
- Máy tính và điện thoại phải cùng mạng WiFi!
- Tắt VPN nếu có

---

## ✅ File Cần Sửa

Chỉ cần sửa **MỘT** file này:

**`lib/config/constants.dart`**
```dart
class AppConstants {
  // API Configuration
  // ⬇️ THAY ĐỔI Ở ĐÂY ⬇️
  static const String baseUrl = 'https://YOUR_IP_HERE:7000/api';
  
  // ... phần còn lại giữ nguyên
}
```

---

## 🔍 Test Kết Nối

### Cách 1: Dùng trình duyệt trên điện thoại
Trên real device, mở Chrome và truy cập:
```
https://192.168.1.100:7000/swagger
```
(Thay IP của bạn)

Nếu thấy Swagger UI → OK!

### Cách 2: Xem logs khi chạy app
```bash
flutter logs
```

Nếu thấy:
```
✅ REQUEST[POST] => PATH: /api/XacThuc/dang-nhap-quan-tri
✅ RESPONSE[200]
```
→ Kết nối thành công!

Nếu thấy:
```
❌ ERROR: Không thể kết nối đến server
```
→ Kiểm tra lại URL và backend

---

## 🚨 Lỗi Thường Gặp

### 1. "Không thể kết nối đến server"
- ✅ Backend có đang chạy không?
- ✅ URL trong `constants.dart` đúng chưa?
- ✅ Emulator: Dùng `10.0.2.2`
- ✅ Real device: Dùng IP máy tính
- ✅ Cùng WiFi chưa?

### 2. "SSL Handshake failed"
- Code đã tắt SSL verification cho development
- Nếu vẫn lỗi, kiểm tra `lib/services/api_service.dart`

### 3. "Connection refused"
- Firewall có đang chặn không?
- Backend có listen trên `0.0.0.0` không?

---

## 📝 Tóm Tắt Nhanh

| Môi Trường | Base URL | Yêu Cầu Thêm |
|------------|----------|--------------|
| **Android Emulator** | `https://10.0.2.2:7000/api` | Không |
| **Real Device** | `https://YOUR_IP:7000/api` | Cùng WiFi + Mở Firewall |
| **iOS Simulator** | `https://localhost:7000/api` | Không |

---

## 🎯 Sau Khi Cấu Hình

1. **Save** file `constants.dart`
2. **Hot Restart** app (nhấn `R` trong terminal)
3. **Test đăng nhập** với `admin` / `admin123`

---

**Lưu ý:** Khi deploy production, nhớ đổi lại URL thành domain thật và BẬT LẠI SSL verification!

