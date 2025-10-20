# 📊 Database Scripts - Ứng Dụng Điểm Danh Nhân Viên

Thư mục này chứa các script SQL để thiết lập và quản lý database cho ứng dụng điểm danh nhân viên.

## 📁 Cấu trúc Files

### 1. **TaoDatabaseVaBang.sql**
- Tạo database `UngDungDiemDanhNhanVien`
- Tạo các bảng: QuanTriVien, NhanVien, DiemDanh, Luong, NhatKyEmail
- Tạo indexes để tối ưu hiệu suất
- Tạo stored procedures và views
- **Chạy đầu tiên** khi setup database mới

### 2. **DuLieuMau.sql**
- Thêm dữ liệu mẫu cho testing
- 3 quản trị viên (admin, manager1, manager2)
- 12 nhân viên thuộc các phòng ban khác nhau
- Dữ liệu điểm danh 7 ngày gần nhất
- Dữ liệu lương và email mẫu
- **Chạy sau** khi tạo database và bảng

### 3. **BackupRestore.sql**
- Script backup toàn bộ database
- Backup từng bảng riêng lẻ
- Export dữ liệu ra file CSV
- Script restore database và bảng
- Import dữ liệu từ CSV
- **Sử dụng** để backup/restore dữ liệu

### 4. **BaoCaoThongKe.sql**
- Các báo cáo điểm danh hôm nay
- Báo cáo theo tuần, tháng
- Thống kê theo phòng ban
- Báo cáo nhân viên đi muộn/về sớm
- Tỷ lệ chuyên cần
- Top nhân viên chuyên cần
- Thống kê lương
- **Sử dụng** để tạo báo cáo định kỳ

### 5. **TaoDatabase.sql** (File gốc)
- Script tạo database cơ bản
- **Có thể bỏ qua** nếu đã chạy TaoDatabaseVaBang.sql

### 6. **ThemQuanTriVien.sql** (File gốc)
- Thêm quản trị viên mặc định
- **Có thể bỏ qua** nếu đã chạy DuLieuMau.sql

## 🚀 Hướng dẫn sử dụng

### **Setup Database mới:**
```sql
-- Bước 1: Tạo database và bảng
sqlcmd -S localhost -i TaoDatabaseVaBang.sql

-- Bước 2: Thêm dữ liệu mẫu
sqlcmd -S localhost -i DuLieuMau.sql
```

### **Backup Database:**
```sql
-- Backup toàn bộ
sqlcmd -S localhost -i BackupRestore.sql
```

### **Tạo báo cáo:**
```sql
-- Chạy các báo cáo
sqlcmd -S localhost -i BaoCaoThongKe.sql
```

## 📊 Cấu trúc Database

### **Bảng QuanTriVien**
- Quản lý tài khoản admin và manager
- Vai trò: Admin, QuanLy

### **Bảng NhanVien**
- Thông tin nhân viên
- Phòng ban: IT, Nhân sự, Kế toán, Marketing, Kinh doanh
- Trạng thái: HoatDong, NghiViec

### **Bảng DiemDanh**
- Lịch sử điểm danh hàng ngày
- GPS tracking (ViDo, KinhDo)
- Phương thức: SinhTracHoc, ThuCong

### **Bảng Luong**
- Thông tin lương theo tháng
- Bao gồm: Lương cơ bản, phụ cấp, thưởng

### **Bảng NhatKyEmail**
- Lịch sử gửi email thông báo

## 🔐 Tài khoản mặc định

### **Admin:**
- Username: `admin`
- Password: `admin123`
- Vai trò: Admin

### **Manager:**
- Username: `manager1`
- Password: `manager123`
- Vai trò: QuanLy

### **Nhân viên:**
- Username: `NV001` (Nguyễn Văn An)
- Password: `123456`
- Phòng ban: Công nghệ thông tin

## 📈 Stored Procedures

### **sp_ThongKeDiemDanhTheoThang**
```sql
EXEC sp_ThongKeDiemDanhTheoThang @Thang = 1, @Nam = 2025
```

### **sp_NhanVienChuaDiemDanhHomNay**
```sql
EXEC sp_NhanVienChuaDiemDanhHomNay
```

## 👁️ Views

### **vw_ThongKeDiemDanhTongQuan**
- Thống kê tổng quan điểm danh hôm nay

### **vw_NhanVienDiemDanhHomNay**
- Danh sách nhân viên với thông tin điểm danh hôm nay

## 📋 Dữ liệu mẫu

### **Nhân viên theo phòng ban:**
- **IT**: 3 nhân viên (NV001, NV002, NV003)
- **Nhân sự**: 2 nhân viên (NV004, NV005)
- **Kế toán**: 2 nhân viên (NV006, NV007)
- **Marketing**: 2 nhân viên (NV008, NV009)
- **Kinh doanh**: 2 nhân viên (NV010, NV011)
- **Nghỉ việc**: 1 nhân viên (NV012)

### **Dữ liệu điểm danh:**
- 7 ngày gần nhất
- 80% nhân viên điểm danh mỗi ngày
- Giờ vào: 7:30 - 9:00
- Giờ ra: 17:00 - 18:30
- GPS: Khu vực TP.HCM

## ⚠️ Lưu ý

1. **Thay đổi đường dẫn backup** trong `BackupRestore.sql` phù hợp với môi trường
2. **Kiểm tra quyền** SQL Server trước khi chạy scripts
3. **Backup dữ liệu** trước khi chạy scripts restore
4. **Cập nhật connection string** trong ứng dụng sau khi setup database

## 🔧 Troubleshooting

### **Lỗi permission:**
```sql
-- Cấp quyền cho user
GRANT CREATE DATABASE TO [YourUser]
GRANT ALTER ANY SCHEMA TO [YourUser]
```

### **Lỗi file path:**
- Kiểm tra thư mục backup tồn tại
- Thay đổi đường dẫn trong script

### **Lỗi foreign key:**
- Chạy scripts theo đúng thứ tự
- Kiểm tra dữ liệu parent table

---

**Tạo bởi:** NHViet  
**Ngày:** 2025-01-20  
**Version:** 1.0
