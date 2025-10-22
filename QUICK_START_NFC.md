# ⚡ QUICK START - CHỨC NĂNG NFC

## 🎯 Tóm tắt nhanh

Chức năng NFC đã được tích hợp hoàn chỉnh. Nhân viên có thể quét thẻ NFC để điểm danh thay vì nhập mã.

---

## 🚀 Chạy ngay (3 bước)

### 1️⃣ Cập nhật Database (1 phút)

**Cách 1: Chạy script SQL**
```bash
# Mở SQL Server Management Studio
# Connect tới database: UngDungDiemDanhNhanVien
# Chạy file: UngDungDiemDanhNhanVien/Database/ThemTinhNangNFC.sql
```

**Cách 2: Dùng EF Migration**
```bash
cd UngDungDiemDanhNhanVien
dotnet ef migrations add ThemMaTheNFC
dotnet ef database update
```

### 2️⃣ Chạy Backend (30 giây)

```bash
cd UngDungDiemDanhNhanVien
dotnet run
```

✅ Backend chạy tại: `https://localhost:7000`

### 3️⃣ Chạy Flutter App (1 phút)

```bash
cd ung_dung_diem_danh
flutter pub get
flutter run
```

✅ App sẽ mở trên emulator hoặc điện thoại

---

## 📱 Sử dụng ngay

### Nhân viên điểm danh:

1. **Đăng nhập** vào app
2. Vào **Trang chủ**
3. Nhấn nút **"Điểm danh bằng thẻ NFC"** (màu xanh viền)
4. Nhấn **"Bắt đầu quét"**
5. **Đưa thẻ NFC** gần mặt sau điện thoại
6. Chờ thông báo ✅ **"Điểm danh thành công!"**

---

## 🔍 Kiểm tra nhanh

### ✅ Database đã update chưa?
```sql
SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'NhanVien' AND COLUMN_NAME = 'MaTheNFC';
```

Nếu trả về 1 dòng → OK ✅

### ✅ API hoạt động chưa?
Mở trình duyệt:
```
https://localhost:7000/swagger
```

Tìm endpoint: `GET /api/NhanVien/kiem-tra-the-nfc/{maTheNFC}`

### ✅ App có màn hình NFC chưa?
- Mở app
- Đăng nhập
- Vào Trang chủ
- Xem có nút **"Điểm danh bằng thẻ NFC"** không?

---

## 📋 Checklist triển khai

- [ ] Database đã có cột `MaTheNFC`
- [ ] Backend chạy không lỗi
- [ ] Flutter app build thành công
- [ ] Điện thoại Android bật NFC
- [ ] Có thẻ NFC để test (NTAG213/215/216)
- [ ] Test quét thẻ thành công

---

## ⚠️ Lỗi thường gặp

### "Thiết bị không hỗ trợ NFC"
→ Bật NFC trong Settings → Connections → NFC

### "Không đọc được thẻ"
→ Đưa thẻ sát mặt sau điện thoại, giữ 2-3 giây

### "Backend không kết nối được"
→ Kiểm tra file: `ung_dung_diem_danh/lib/config/constants.dart`
→ Đảm bảo `baseUrl` đúng với IP backend

---

## 📂 Files đã thay đổi

### Backend (.NET)
```
✅ UngDungDiemDanhNhanVien/Models/NhanVien.cs
✅ UngDungDiemDanhNhanVien/DTOs/GanTheNFCRequest.cs (mới)
✅ UngDungDiemDanhNhanVien/DTOs/DangKyRequest.cs
✅ UngDungDiemDanhNhanVien/DTOs/DangKyNhanVienRequest.cs
✅ UngDungDiemDanhNhanVien/Services/INhanVienService.cs
✅ UngDungDiemDanhNhanVien/Services/NhanVienService.cs
✅ UngDungDiemDanhNhanVien/Services/XacThucService.cs
✅ UngDungDiemDanhNhanVien/Controllers/NhanVienController.cs
✅ UngDungDiemDanhNhanVien/Database/ThemTinhNangNFC.sql (mới)
```

### Frontend (Flutter)
```
✅ ung_dung_diem_danh/pubspec.yaml
✅ ung_dung_diem_danh/android/app/src/main/AndroidManifest.xml
✅ ung_dung_diem_danh/lib/models/nhan_vien_model.dart
✅ ung_dung_diem_danh/lib/services/nfc_service.dart (mới)
✅ ung_dung_diem_danh/lib/screens/employee/man_hinh_quet_nfc.dart (mới)
✅ ung_dung_diem_danh/lib/screens/employee/man_hinh_chu_nhan_vien_improved.dart
```

---

## 🎁 Tính năng bonus

Ứng dụng đã tự động:
- ✨ Lưu vị trí GPS khi quét thẻ
- ✨ Kiểm tra thẻ trùng lặp
- ✨ Animation đẹp khi quét
- ✨ Xử lý lỗi thông minh
- ✨ Tương thích nhiều loại thẻ NFC

---

## 📞 Cần giúp?

Xem chi tiết tại: **HUONG_DAN_TRIEN_KHAI_NFC.md**

---

**Ready to scan! 📱✨**

