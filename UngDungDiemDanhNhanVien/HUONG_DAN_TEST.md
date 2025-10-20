# Hướng Dẫn Test Ứng Dụng Điểm Danh Nhân Viên

## Bước 1: Khởi tạo Database

### 1.1. Mở SQL Server Management Studio (SSMS)
- Kết nối đến server: `HOANGVIET24\MSSQLSERVER01`

### 1.2. Chạy script tạo database
- Mở file `Database/TaoDatabase.sql`
- Execute script
- Kiểm tra database `UngDungDiemDanhNhanVien` đã được tạo

## Bước 2: Chạy Backend API

### 2.1. Restore packages và build
```bash
cd UngDungDiemDanhNhanVien
dotnet restore
dotnet build
```

### 2.2. Chạy migration (nếu cần)
```bash
dotnet ef migrations add InitialCreate
dotnet ef database update
```

### 2.3. Chạy ứng dụng
```bash
dotnet run
```

API sẽ chạy tại: `https://localhost:7000` hoặc `http://localhost:5000`

Swagger UI: `https://localhost:7000/swagger`

## Bước 3: Test Chức Năng Xác Thực

### 3.1. Test Đăng Nhập Quản Trị Viên

**Endpoint:** `POST /api/XacThuc/dang-nhap-quan-tri`

**Request Body:**
```json
{
  "tenDangNhap": "admin",
  "matKhau": "admin123"
}
```

**Response mong đợi:**
```json
{
  "thanhCong": true,
  "thongBao": "Đăng nhập thành công",
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "vaiTro": "Admin",
  "hoTen": "admin@congty.com"
}
```

**Lưu lại Token** để sử dụng cho các request tiếp theo!

### 3.2. Test Đăng Nhập Sai Thông Tin

**Request Body:**
```json
{
  "tenDangNhap": "admin",
  "matKhau": "sai_mat_khau"
}
```

**Response mong đợi:**
```json
{
  "thanhCong": false,
  "thongBao": "Tên đăng nhập hoặc mật khẩu không đúng",
  "token": null,
  "vaiTro": null
}
```

## Bước 4: Test Quản Lý Nhân Viên

### 4.1. Thêm Nhân Viên Mới

**Endpoint:** `POST /api/NhanVien`

**Headers:**
```
Authorization: Bearer {TOKEN_TỪ_BƯỚC_3.1}
```

**Request Body:**
```json
{
  "maNhanVien": "NV001",
  "hoTen": "Nguyễn Văn A",
  "email": "nguyenvana@congty.com",
  "soDienThoai": "0912345678",
  "phongBan": "Phòng Kỹ Thuật",
  "chucVu": "Nhân viên",
  "luongGio": 50000,
  "trangThai": "HoatDong"
}
```

**Response mong đợi:** HTTP 201 Created + thông tin nhân viên

### 4.2. Lấy Danh Sách Nhân Viên

**Endpoint:** `GET /api/NhanVien`

**Headers:**
```
Authorization: Bearer {TOKEN}
```

**Response mong đợi:** Danh sách nhân viên

### 4.3. Đăng Ký Sinh Trắc Học

**Endpoint:** `PUT /api/NhanVien/1/dang-ky-sinh-trac-hoc`

**Headers:**
```
Authorization: Bearer {TOKEN}
Content-Type: application/json
```

**Request Body:**
```json
"BIOMETRIC_HASH_12345"
```

**Response mong đợi:** "Đăng ký sinh trắc học thành công"

## Bước 5: Test Đăng Nhập Nhân Viên

### 5.1. Đăng Nhập Bằng Mã Nhân Viên

**Endpoint:** `POST /api/XacThuc/dang-nhap-nhan-vien`

**Request Body:**
```json
{
  "maNhanVien": "NV001",
  "maSinhTracHoc": "BIOMETRIC_HASH_12345"
}
```

**Response mong đợi:**
```json
{
  "thanhCong": true,
  "thongBao": "Đăng nhập thành công",
  "token": "eyJhbGciOi...",
  "vaiTro": "NhanVien",
  "nhanVienId": 1,
  "hoTen": "Nguyễn Văn A"
}
```

## Bước 6: Test Điểm Danh

### 6.1. Điểm Danh Vào

**Endpoint:** `POST /api/DiemDanh/diem-danh-vao`

**Headers:**
```
Authorization: Bearer {TOKEN_NHAN_VIEN}
```

**Request Body:**
```json
{
  "maNhanVien": "NV001",
  "maSinhTracHoc": "BIOMETRIC_HASH_12345",
  "viDo": 10.762622,
  "kinhDo": 106.660172,
  "ghiChu": "Điểm danh buổi sáng"
}
```

**Response mong đợi:** HTTP 200 + thông tin điểm danh

### 6.2. Điểm Danh Ra

**Endpoint:** `POST /api/DiemDanh/diem-danh-ra`

**Headers:**
```
Authorization: Bearer {TOKEN_NHAN_VIEN}
```

**Request Body:**
```json
{
  "maNhanVien": "NV001",
  "maSinhTracHoc": "BIOMETRIC_HASH_12345",
  "viDo": 10.762622,
  "kinhDo": 106.660172,
  "ghiChu": "Điểm danh buổi chiều"
}
```

**Response mong đợi:** HTTP 200 + thông tin điểm danh (có tổng giờ làm)

### 6.3. Xem Lịch Sử Điểm Danh Cá Nhân

**Endpoint:** `GET /api/DiemDanh/lich-su-ca-nhan`

**Headers:**
```
Authorization: Bearer {TOKEN_NHAN_VIEN}
```

**Response mong đợi:** Danh sách lịch sử điểm danh

### 6.4. Admin Xem Điểm Danh Theo Ngày

**Endpoint:** `GET /api/DiemDanh/theo-ngay?ngay=2025-10-19`

**Headers:**
```
Authorization: Bearer {TOKEN_ADMIN}
```

**Response mong đợi:** Danh sách điểm danh của tất cả nhân viên trong ngày

## Checklist Test

### ✅ Xác Thực
- [ ] Đăng nhập Admin thành công
- [ ] Đăng nhập Admin sai mật khẩu
- [ ] Đăng nhập Nhân Viên thành công
- [ ] Đăng nhập Nhân Viên sai thông tin
- [ ] Token JWT được tạo và hợp lệ

### ✅ Quản Lý Nhân Viên
- [ ] Thêm nhân viên mới thành công
- [ ] Xem danh sách nhân viên
- [ ] Cập nhật thông tin nhân viên
- [ ] Đăng ký sinh trắc học
- [ ] Cập nhật trạng thái nhân viên
- [ ] Authorization: chỉ Admin mới thêm/sửa/xóa được

### ✅ Điểm Danh
- [ ] Điểm danh vào thành công
- [ ] Điểm danh ra thành công
- [ ] Tính toán tổng giờ làm chính xác
- [ ] Không thể điểm danh vào 2 lần trong 1 ngày
- [ ] Không thể điểm danh ra nếu chưa điểm danh vào
- [ ] Xem lịch sử điểm danh cá nhân
- [ ] Admin xem điểm danh theo ngày

## Công Cụ Test Khuyến Nghị

1. **Postman** - Import collection và test APIs
2. **Swagger UI** - Test trực tiếp trong browser
3. **VS Code REST Client** - Tạo file `.http` để test

## Lưu Ý
- Luôn kiểm tra kết nối database trước khi test
- Lưu lại token sau khi đăng nhập
- Kiểm tra logs trong console nếu có lỗi
- Test cả trường hợp thành công và thất bại

## Bước Tiếp Theo
Sau khi test xong các chức năng trên, chúng ta sẽ:
1. Tạo ứng dụng Android
2. Tích hợp biometric authentication
3. Xây dựng UI/UX cho mobile app
