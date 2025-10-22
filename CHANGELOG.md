# Changelog - Ứng dụng Điểm Danh Nhân Viên

## [2.0.0] - 2025-10-22

### 🎉 Major Updates từ GitHub

#### Backend (.NET Core)
- ✨ **Thêm mới**: `BaoCaoController.cs` - API báo cáo tuần/tháng/quý/năm
- ✨ **Thêm mới**: `LuongController.cs` - API quản lý và tính lương
- 📦 **Thêm mới**: Các DTO models (`BaoCaoResponse`, `LuongResponse`, `ThongKeBaoCaoDto`)
- 🗄️ **Database**: 3 migrations mới (`doan`, `doanapp`, `app`)
- 🔧 **Cập nhật**: `XacThucController`, `NhanVienController` với nhiều cải tiến
- 📁 **Thêm mới**: File `UngDungDiemDanhNhanVien.sln`

#### Flutter App
- 📊 **Màn hình báo cáo mới**:
  - `man_hinh_bao_cao_tuan.dart` - Báo cáo tuần
  - `man_hinh_bao_cao_thang.dart` - Báo cáo tháng
  - `man_hinh_bao_cao_quy.dart` - Báo cáo quý
  - `man_hinh_bao_cao_nam.dart` - Báo cáo năm
- 🎯 **Services mới**: 
  - `BaoCaoService` - Xử lý API báo cáo
  - Models `BaoCaoResponse`
- 🔐 **Cải tiến Auth**: Cập nhật `auth_bloc`, `auth_event`, `auth_service`
- 🔧 **Refactoring**: Tách `dang_ky_request.dart` thay thế file cũ

#### Documentation
- 📖 **Thêm mới**: `PHASE_2_FEATURES.md` - Kế hoạch tính năng phase 2
- 📝 **Cập nhật**: README.md toàn diện

### 📊 Thống kê
- **+5,176 dòng code** mới
- **-295 dòng code** đã xóa
- **70 files** thay đổi
- **2 branches**: `main`, `feature/phase-2-advanced-features`

### 🐛 Bug Fixes
- ✅ Fix lỗi `BaoCaoResponse` không tìm thấy
- ✅ Xóa duplicate class `DiemDanhDto`
- ✅ Khắc phục conflict khi pull từ GitHub
- ✅ Build thành công với 0 errors

---

## [1.0.0] - 2025-10-20

### 🎯 Initial Release

#### Tính năng Core
- ✅ Authentication với JWT
- ✅ Quản lý nhân viên (CRUD)
- ✅ Điểm danh vào/ra
- ✅ Chấm công thủ công (Admin)
- ✅ Xác thực sinh trắc học (vân tay/Face ID)
- ✅ Lịch sử điểm danh

#### Tech Stack
- Backend: ASP.NET Core 8
- Database: SQL Server + Entity Framework
- Mobile: Flutter 3.x
- State Management: BLoC Pattern
- Authentication: JWT Bearer Token

#### Database Schema
- ✅ Bảng `NhanVien`
- ✅ Bảng `QuanTriVien`
- ✅ Bảng `DiemDanh`
- ✅ Bảng `Luong`
- ✅ Bảng `NhatKyEmail`

#### API Endpoints
- Authentication APIs
- Employee Management APIs
- Attendance APIs
- Basic Report APIs
- Salary APIs

---

## 🚀 Upcoming Features

### Phase 2 (In Progress)
- [ ] NFC card reader integration
- [ ] GPS tracking & Geofencing
- [ ] Photo verification khi điểm danh
- [ ] Push notifications (Firebase)
- [ ] Email báo cáo tự động
- [ ] Quản lý nghỉ phép
- [ ] Đăng ký tăng ca

### Phase 3 (Planned)
- [ ] Web admin panel
- [ ] Export Excel/PDF reports
- [ ] Multi-language support
- [ ] Advanced analytics dashboard
- [ ] Role-based permissions (chi tiết)
- [ ] Phòng ban & Manager
- [ ] AI anomaly detection

---

## 📝 Notes

### Breaking Changes
- Không có breaking changes trong version này

### Migration Guide
Nếu bạn đang dùng version cũ:
```bash
# Pull code mới
git pull origin main

# Update dependencies
cd UngDungDiemDanhNhanVien
dotnet restore

# Run migrations
dotnet ef database update

# Rebuild
dotnet build
```

### Known Issues
- ⚠️ Migration names (`doan`, `doanapp`, `app`) - Warning CS8981 (không ảnh hưởng)
- ⚠️ Một số nullable warnings (không ảnh hưởng chức năng)

### Contributors
- Team NHViet
- GitHub: @hoangviet2409

---

**📅 Last Updated**: October 22, 2025

