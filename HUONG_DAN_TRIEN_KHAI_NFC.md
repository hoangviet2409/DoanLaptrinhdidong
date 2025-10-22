# 📱 HƯỚNG DẪN TRIỂN KHAI CHỨC NĂNG NFC

## 📋 TỔNG QUAN

Chức năng NFC cho phép nhân viên điểm danh bằng cách quét thẻ NFC, thay vì nhập mã nhân viên hoặc sử dụng sinh trắc học.

## ✅ CÁC BƯỚC ĐÃ THỰC HIỆN

### 1. Backend (.NET)
- ✅ Thêm cột `MaTheNFC` vào bảng `NhanVien` trong database
- ✅ Cập nhật Model `NhanVien.cs`
- ✅ Tạo DTOs: `GanTheNFCRequest`, `KiemTraTheNFCResponse`
- ✅ Cập nhật Service: `NhanVienService` với 2 methods mới:
  - `CapNhatMaTheNFC()` - Gán thẻ NFC cho nhân viên
  - `LayNhanVienTheoMaTheNFC()` - Tìm nhân viên theo mã thẻ
- ✅ Thêm API endpoints:
  - `POST /api/NhanVien/gan-the-nfc` - Gán thẻ NFC
  - `GET /api/NhanVien/kiem-tra-the-nfc/{maTheNFC}` - Kiểm tra thẻ

### 2. Frontend (Flutter)
- ✅ Thêm package `nfc_manager: ^3.5.0`
- ✅ Cấu hình quyền NFC trong `AndroidManifest.xml`
- ✅ Cập nhật Model `NhanVienModel` với field `maTheNFC`
- ✅ Tạo `NFCService` để xử lý quét thẻ NFC
- ✅ Tạo màn hình `ManHinhQuetNFC` với UI đẹp và animation
- ✅ Tích hợp nút quét NFC vào màn hình chủ nhân viên

---

## 🚀 HƯỚNG DẪN TRIỂN KHAI

### BƯỚC 1: Cập nhật Database

1. Mở **SQL Server Management Studio**
2. Kết nối tới database `UngDungDiemDanhNhanVien`
3. Chạy script SQL:

```sql
-- File: UngDungDiemDanhNhanVien/Database/ThemTinhNangNFC.sql
```

Hoặc chạy trực tiếp:

```sql
USE UngDungDiemDanhNhanVien;
GO

-- Thêm cột MaTheNFC
ALTER TABLE NhanVien
ADD MaTheNFC NVARCHAR(50) NULL;

-- Tạo index
CREATE INDEX IX_NhanVien_MaTheNFC ON NhanVien(MaTheNFC);

-- Thêm constraint unique
ALTER TABLE NhanVien
ADD CONSTRAINT UQ_NhanVien_MaTheNFC UNIQUE(MaTheNFC);
GO
```

**Hoặc** sử dụng Entity Framework Migration:

```bash
cd UngDungDiemDanhNhanVien
dotnet ef migrations add ThemTinhNangNFC
dotnet ef database update
```

### BƯỚC 2: Build Backend

```bash
cd UngDungDiemDanhNhanVien
dotnet build
dotnet run
```

Kiểm tra API đã hoạt động:
- Swagger UI: `https://localhost:7000/swagger`
- Test endpoint: `GET /api/NhanVien/kiem-tra-the-nfc/test`

### BƯỚC 3: Build Frontend (Flutter)

1. **Cài đặt dependencies:**

```bash
cd ung_dung_diem_danh
flutter pub get
```

2. **Build ứng dụng Android:**

```bash
flutter build apk --release
# hoặc
flutter run
```

### BƯỚC 4: Kiểm tra NFC trên thiết bị

1. Mở **Settings** trên điện thoại Android
2. Tìm **NFC** hoặc **Kết nối**
3. Bật **NFC** và **Android Beam**

---

## 📲 HƯỚNG DẪN SỬ DỤNG

### A. Gán thẻ NFC cho nhân viên

#### Cách 1: Qua Admin Dashboard (Chưa có UI)

Gọi API để gán thẻ:

```http
POST /api/NhanVien/gan-the-nfc
Content-Type: application/json
Authorization: Bearer {token}

{
  "maNhanVien": "NV001",
  "maTheNFC": "04:5E:C3:2A:B1:54:80"
}
```

#### Cách 2: Nhân viên tự đăng ký (Khuyến nghị)

1. Nhân viên đăng nhập vào app
2. Vào **Trang chủ** → Nhấn nút **"Điểm danh bằng thẻ NFC"**
3. Nhấn **"Bắt đầu quét"**
4. Đưa thẻ NFC gần điện thoại
5. Lần đầu tiên quét, hệ thống sẽ tự động gán thẻ cho nhân viên

### B. Điểm danh bằng NFC

1. Nhân viên mở app và đăng nhập
2. Vào **Trang chủ** → Nhấn **"Điểm danh bằng thẻ NFC"**
3. Nhấn nút **"Bắt đầu quét"**
4. Đưa thẻ NFC gần mặt sau điện thoại (khoảng 2-3 giây)
5. Chờ thông báo xác nhận:
   - ✅ "Điểm danh VÀO thành công" (nếu chưa điểm danh vào)
   - ✅ "Điểm danh RA thành công" (nếu đã điểm danh vào)

---

## 🔧 TROUBLESHOOTING

### 1. "Thiết bị không hỗ trợ NFC"
**Nguyên nhân:**
- Điện thoại không có chip NFC
- NFC chưa được bật

**Giải pháp:**
- Kiểm tra Settings → NFC → Bật NFC
- Thử với điện thoại khác có hỗ trợ NFC

### 2. "Không đọc được thẻ NFC"
**Nguyên nhân:**
- Thẻ NFC không tương thích
- Vị trí quét không đúng
- Thẻ bị hỏng

**Giải pháp:**
- Sử dụng thẻ NTAG213/215/216 hoặc MIFARE Classic
- Đưa thẻ sát mặt sau điện thoại (gần camera)
- Giữ thẻ yên trong 2-3 giây
- Thử với thẻ khác

### 3. "Thẻ NFC đã được gán cho nhân viên khác"
**Nguyên nhân:**
- Thẻ đã được đăng ký trước đó

**Giải pháp:**
- Liên hệ admin để gỡ gán thẻ cũ
- Sử dụng thẻ NFC khác

### 4. Backend không nhận được request
**Nguyên nhân:**
- URL backend chưa đúng
- CORS chưa được cấu hình

**Giải pháp:**
- Kiểm tra file `ung_dung_diem_danh/lib/config/constants.dart`
- Đảm bảo `baseUrl` đúng với IP của backend

---

## 📊 LUỒNG HOẠT ĐỘNG

```
┌─────────────┐         ┌──────────────┐         ┌──────────────┐
│  Nhân viên  │         │  Ứng dụng    │         │   Backend    │
│   quét thẻ  │         │   Flutter    │         │    .NET      │
└──────┬──────┘         └──────┬───────┘         └──────┬───────┘
       │                       │                        │
       │  1. Đưa thẻ NFC       │                        │
       │──────────────────────>│                        │
       │                       │                        │
       │                       │  2. Đọc UID thẻ       │
       │                       │  (04:5E:C3:2A:...)    │
       │                       │                        │
       │                       │  3. Kiểm tra thẻ       │
       │                       │───────────────────────>│
       │                       │                        │
       │                       │  4. Thông tin NV       │
       │                       │<───────────────────────│
       │                       │                        │
       │                       │  5. Điểm danh (NFC)    │
       │                       │───────────────────────>│
       │                       │                        │
       │                       │  6. Lưu vào DB         │
       │                       │  PhuongThuc = "NFC"    │
       │                       │                        │
       │                       │  7. Kết quả            │
       │                       │<───────────────────────│
       │                       │                        │
       │  8. Thông báo         │                        │
       │<──────────────────────│                        │
       │  "Điểm danh thành     │                        │
       │   công!"              │                        │
       │                       │                        │
```

---

## 🎯 CÁC TÍNH NĂNG ĐANG CÓ

### Đã triển khai ✅
- [x] Quét thẻ NFC để lấy UID
- [x] Gán thẻ NFC cho nhân viên
- [x] Điểm danh vào/ra bằng NFC
- [x] Lưu thông tin vị trí GPS khi quét thẻ
- [x] Kiểm tra thẻ hợp lệ trước khi điểm danh
- [x] Animation và UI đẹp cho màn hình quét
- [x] Xử lý lỗi và hiển thị thông báo

### Có thể mở rộng thêm 🔮
- [ ] Admin quản lý thẻ NFC qua dashboard
- [ ] Lịch sử quét thẻ NFC
- [ ] Thống kê điểm danh theo phương thức (NFC, Sinh trắc, Thủ công)
- [ ] Ghi dữ liệu vào thẻ NFC (không chỉ đọc UID)
- [ ] Mã hóa dữ liệu trên thẻ NFC để tăng bảo mật
- [ ] Cảnh báo nếu thẻ NFC bị clone (phát hiện duplicate)
- [ ] Giới hạn bán kính điểm danh (geofencing)

---

## 🛡️ BẢO MẬT

### Hiện tại:
- UID thẻ NFC được lưu dạng plain text
- Kết hợp GPS để kiểm tra vị trí
- Mỗi thẻ chỉ gán cho 1 nhân viên (UNIQUE constraint)

### Khuyến nghị nâng cao:
- Sử dụng thẻ NFC có mã hóa (NTAG424, DESFire)
- Thêm challenge-response authentication
- Giới hạn thời gian điểm danh (chỉ trong giờ làm việc)
- Giới hạn vùng địa lý (geofencing)
- Log tất cả hoạt động quét thẻ

---

## 📞 HỖ TRỢ

Nếu gặp vấn đề, vui lòng:
1. Kiểm tra log trong `UngDungDiemDanhNhanVien/logs/`
2. Xem console của Flutter khi chạy debug
3. Liên hệ team phát triển

---

## 📝 CHANGELOG

### Version 1.0.0 (2025-10-22)
- ✨ Thêm tính năng quét thẻ NFC
- ✨ Gán thẻ NFC cho nhân viên
- ✨ Điểm danh bằng NFC
- ✨ UI/UX màn hình quét NFC
- 🐛 Sửa lỗi xử lý multiple NFC tag types

---

**Chúc bạn triển khai thành công!** 🎉

