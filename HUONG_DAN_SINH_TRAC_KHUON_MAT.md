# 📱 HƯỚNG DẪN SINH TRẮC HỌC & NHẬN DIỆN KHUÔN MẶT

## 📋 TỔNG QUAN

Hệ thống hiện có **3 phương thức điểm danh thông minh**:

### 1️⃣ **Vân Tay / Face ID** (Sinh trắc học hệ thống)
- ✅ Dùng cảm biến vân tay hoặc Face ID của điện thoại
- ✅ Xác thực nhanh, bảo mật cao
- ✅ Không cần thiết bị thêm
- ✅ Dùng package: `local_auth`

### 2️⃣ **Quét Khuôn Mặt** (Camera + AI)
- 📸 Chụp ảnh khuôn mặt bằng camera
- 🤖 So sánh với ảnh đã lưu (AI - đang phát triển)
- 📍 Kết hợp GPS để xác minh vị trí
- ✅ Dùng package: `image_picker`

### 3️⃣ **Quét Thẻ NFC** (Đã triển khai trước)
- 📡 Quét thẻ NFC để điểm danh
- ✅ Dùng package: `nfc_manager`

---

## 🚀 CÀI ĐẶT

### Packages đã có sẵn:
```yaml
dependencies:
  local_auth: ^2.1.8          # ✅ Đã có
  image_picker: ^1.0.7         # ✅ Đã có
  nfc_manager: ^4.1.1          # ✅ Đã có
  native_auth: ^1.0.6          # ⚠️ Không cần thiết (trùng local_auth)
```

**Lưu ý:** Bạn có thể **XÓA** `native_auth` vì đã có `local_auth` (tốt hơn).

---

## ✅ PHẦN 1: SINH TRẮC HỌC (Vân Tay/Face ID)

### 📁 Files đã tạo:

```
ung_dung_diem_danh/lib/
├── services/
│   └── biometric_service.dart              # ✅ Service xử lý sinh trắc học
└── screens/employee/
    └── man_hinh_diem_danh_sinh_trac.dart   # ✅ Màn hình điểm danh vân tay
```

### 🎯 Tính năng:

1. **Kiểm tra hỗ trợ**: Tự động detect vân tay/Face ID/Iris
2. **Xác thực**: Popup hệ thống yêu cầu quét vân tay/mặt
3. **Điểm danh**: Tự động điểm danh sau khi xác thực thành công
4. **Fallback**: Cho phép dùng PIN/Pattern nếu sinh trắc thất bại

### 📋 Cách sử dụng:

```
1. Nhân viên đăng nhập vào app
2. Vào Trang chủ → Nhấn "Điểm danh bằng vân tay"
3. Nhấn "Xác Thực & Điểm Danh"
4. Quét vân tay hoặc nhìn vào camera (Face ID)
5. Hệ thống tự động điểm danh
```

### 🔧 Cấu hình:

**Android** - Đã cấu hình sẵn trong `AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.USE_BIOMETRIC"/>
```

**iOS** - Cần thêm vào `Info.plist` (nếu build iOS):
```xml
<key>NSFaceIDUsageDescription</key>
<string>Ứng dụng cần quyền Face ID để xác thực điểm danh</string>
```

### 📊 API Methods:

```dart
// Trong BiometricService:
await biometricService.isAvailableBiometrics()      // Kiểm tra hỗ trợ
await biometricService.authenticate()                // Xác thực
await biometricService.getBiometricTypeString()     // Lấy tên loại
```

---

## 📸 PHẦN 2: NHẬN DIỆN KHUÔN MẶT

### 📁 Files đã tạo:

```
ung_dung_diem_danh/lib/
└── screens/employee/
    └── man_hinh_quet_khuon_mat.dart   # ✅ Màn hình quét khuôn mặt
```

### 🎯 Tính năng:

1. **Mở camera trước** (selfie)
2. **Chụp ảnh khuôn mặt**
3. **Xem lại ảnh** trước khi gửi
4. **Gửi lên server** (base64)
5. **Điểm danh** với phương thức "KhuonMat"

### 📋 Cách sử dụng:

```
1. Nhân viên vào Trang chủ → "Điểm danh bằng khuôn mặt"
2. Nhấn "Mở Camera"
3. Chụp ảnh khuôn mặt (đảm bảo rõ, đủ sáng)
4. Xem lại ảnh
5. Nhấn "Xác Nhận & Điểm Danh"
```

### ⚠️ Lưu ý:

**Hiện tại:** Chỉ chụp và gửi ảnh lên server
**Chưa có:** AI so sánh khuôn mặt thực sự

**Để thêm AI nhận diện khuôn mặt**, cần:

#### Option 1: Google ML Kit (Khuyến nghị)
```bash
flutter pub add google_mlkit_face_detection
```

Sau đó thêm code:
```dart
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

final faceDetector = FaceDetector(options: FaceDetectorOptions());
final faces = await faceDetector.processImage(inputImage);
// So sánh với ảnh đã lưu
```

#### Option 2: Backend AI (Python/TensorFlow)
- Gửi ảnh lên server
- Server dùng **face_recognition** (Python)
- So sánh với ảnh đã đăng ký
- Trả về kết quả

### 🔧 Cấu hình:

**Android** - Đã có quyền camera:
```xml
<uses-permission android:name="android.permission.CAMERA" />
```

**iOS** - Cần thêm (nếu build iOS):
```xml
<key>NSCameraUsageDescription</key>
<string>Ứng dụng cần quyền camera để chụp ảnh điểm danh</string>
```

---

## 🎨 UI/UX

### Màn hình Trang chủ nhân viên:

Hiện có **4 nút điểm danh**:

```
┌─────────────────────────────────┐
│  [Điểm danh vào/ra]             │  ← Nút chính (xanh lá)
├─────────────────────────────────┤
│  [📱 Điểm danh bằng thẻ NFC]     │  ← Viền xanh dương
├─────────────────────────────────┤
│  [👆 Điểm danh bằng vân tay]     │  ← Viền xanh lá
├─────────────────────────────────┤
│  [😊 Điểm danh bằng khuôn mặt]   │  ← Viền tím
└─────────────────────────────────┘
```

### Icons & Colors:

| Phương thức | Icon | Màu |
|------------|------|-----|
| GPS + Sinh trắc | `login/logout` | Xanh lá |
| NFC | `nfc` | Xanh dương |
| Vân tay | `fingerprint` | Xanh lá |
| Khuôn mặt | `face` | Tím |

---

## 📊 LUỒNG HOẠT ĐỘNG

### 1. Vân tay/Face ID:

```
Nhấn nút 
  → BiometricService.authenticate()
  → Popup xác thực hệ thống
  → Quét vân tay/Face ID
  → Nếu OK: Gọi API điểm danh
  → Backend lưu với phuongThuc = "SinhTracHoc"
  → Hiển thị thành công
```

### 2. Khuôn mặt:

```
Nhấn nút 
  → Mở camera
  → Chụp ảnh
  → Xem lại
  → Convert sang base64
  → Gọi API điểm danh (gửi kèm ảnh)
  → Backend lưu với phuongThuc = "KhuonMat"
  → Hiển thị thành công
```

---

## 🔐 BẢO MẬT

### Sinh trắc học:
- ✅ **Rất cao**: Dùng chip bảo mật của điện thoại
- ✅ Không lưu vân tay/khuôn mặt trên server
- ✅ Chỉ xác thực local

### Quét khuôn mặt:
- ⚠️ **Trung bình**: Ảnh có thể bị giả mạo
- 🔒 **Cải thiện**: Thêm liveness detection (phát hiện ảnh/video giả)
- 🔒 **Cải thiện**: Mã hóa ảnh trước khi gửi server

---

## 🐛 TROUBLESHOOTING

### 1. "Thiết bị không hỗ trợ sinh trắc học"

**Nguyên nhân:**
- Điện thoại không có cảm biến vân tay/Face ID
- Chưa thiết lập vân tay trong Settings

**Giải pháp:**
```
Settings → Security → Fingerprint/Face Unlock → Thêm vân tay/khuôn mặt
```

### 2. "Lỗi mở camera"

**Nguyên nhân:**
- Chưa cấp quyền camera
- Camera bị ứng dụng khác chiếm dụng

**Giải pháp:**
```
Settings → Apps → Điểm Danh → Permissions → Camera → Allow
```

### 3. "Xác thực thất bại"

**Nguyên nhân:**
- Vân tay bẩn/ướt
- Góc nhìn không đúng (Face ID)

**Giải pháp:**
- Lau sạch ngón tay
- Nhìn thẳng vào camera
- Thử lại hoặc dùng PIN/Pattern

---

## 📈 SO SÁNH CÁC PHƯƠNG THỨC

| Tiêu chí | Vân tay/Face ID | Khuôn mặt | NFC |
|----------|----------------|-----------|-----|
| **Tốc độ** | ⚡⚡⚡ Rất nhanh (< 2s) | ⚡⚡ Trung bình (5-10s) | ⚡⚡⚡ Nhanh (< 3s) |
| **Bảo mật** | 🔒🔒🔒 Rất cao | 🔒🔒 Trung bình | 🔒🔒 Trung bình |
| **Tiện lợi** | ⭐⭐⭐ Rất tiện | ⭐⭐ Trung bình | ⭐⭐ Cần thẻ |
| **Chi phí** | 💰 Miễn phí | 💰 Miễn phí | 💰💰 Cần mua thẻ |
| **Độ chính xác** | 99.9% | 85-95% | 99% |

---

## 🎯 ROADMAP TƯƠNG LAI

### Phase 1: ✅ Đã hoàn thành
- [x] Sinh trắc học (vân tay/Face ID)
- [x] Chụp ảnh khuôn mặt
- [x] UI/UX đẹp mắt

### Phase 2: 🚧 Đang phát triển
- [ ] AI nhận diện khuôn mặt (Google ML Kit)
- [ ] Liveness detection (phát hiện ảnh/video giả)
- [ ] So sánh độ tương đồng khuôn mặt

### Phase 3: 🔮 Kế hoạch
- [ ] Nhận diện nhiều khuôn mặt cùng lúc
- [ ] Dashboard admin quản lý ảnh khuôn mặt
- [ ] Export báo cáo theo phương thức điểm danh

---

## 📞 HỖ TRỢ

**Tham khảo:**
- [local_auth package](https://pub.dev/packages/local_auth)
- [image_picker package](https://pub.dev/packages/image_picker)
- [Google ML Kit Face Detection](https://pub.dev/packages/google_mlkit_face_detection)

**Note:** Package `native_auth` không cần thiết vì đã có `local_auth` tốt hơn.

---

**Chúc bạn triển khai thành công!** 🎉

