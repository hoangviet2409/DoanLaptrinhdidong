# Kế hoạch Xây dựng Ứng dụng Điểm Danh Nhân Viên

## 1. Thiết lập cấu trúc dự án

### Backend (Node.js + SQL Server)

- Khởi tạo Node.js project với Express.js
- Cấu hình kết nối SQL Server (sử dụng `mssql` package)
- Thiết lập JWT authentication và middleware authorization
- Cấu hình nodemailer cho gửi email tự động
- Thiết lập node-cron cho các tác vụ tự động (gửi báo cáo định kỳ)

### Mobile App (Flutter)

- Khởi tạo Flutter project
- Cài đặt các dependencies cần thiết:
- `local_auth` cho vân tay/Face ID (sinh trắc học)
- `flutter_bloc` hoặc `provider` cho state management
- `dio` cho API calls
- `shared_preferences` cho lưu token
- `fl_chart` cho biểu đồ thống kê
- `geolocator` cho GPS tracking

## 2. Thiết kế Database (SQL Server)

Tạo các bảng chính:

**Users** (Nhân viên)

- id, employee_code, full_name, email, phone
- biometric_id (lưu hash hoặc reference), face_id
- department, position, hourly_rate
- status (active/inactive), created_at, updated_at

**Admins**

- id, username, password_hash, email, role
- created_at, updated_at

**Attendance**

- id, user_id, check_in_time, check_out_time
- check_in_method (biometric/face/manual)
- location_lat, location_lng (optional)
- notes, created_by_admin_id (null nếu tự điểm danh)
- date, total_hours, status

**Salary**

- id, user_id, period_type (weekly/monthly)
- period_start, period_end
- total_hours, hourly_rate, total_amount
- bonus, deduction, final_amount
- status (pending/paid), created_at

**EmailLogs**

- id, user_id, email_type, sent_at
- status (success/failed), error_message

## 3. Xây dựng Backend APIs

### Authentication APIs

- POST `/api/auth/admin/login` - Đăng nhập admin
- POST `/api/auth/employee/login` - Đăng nhập nhân viên (qua employee_code)
- POST `/api/auth/biometric/verify` - Xác thực sinh trắc học
- POST `/api/auth/refresh` - Refresh JWT token

### Employee Management APIs (Admin only)

- GET `/api/employees` - Danh sách nhân viên (có filter, pagination)
- POST `/api/employees` - Thêm nhân viên mới
- PUT `/api/employees/:id` - Cập nhật thông tin nhân viên
- PUT `/api/employees/:id/status` - Đóng/Mở tài khoản
- POST `/api/employees/:id/biometric` - Đăng ký sinh trắc học

### Attendance APIs

- POST `/api/attendance/check-in` - Điểm danh vào
- POST `/api/attendance/check-out` - Điểm danh ra
- GET `/api/attendance/my-records` - Lịch sử điểm danh của nhân viên
- POST `/api/attendance/manual` - Admin chấm công thủ công (admin only)
- PUT `/api/attendance/:id` - Chỉnh sửa bản ghi (admin only)
- GET `/api/attendance/daily` - Báo cáo ngày (admin only)

### Report APIs

- GET `/api/reports/weekly/:user_id?` - Báo cáo tuần
- GET `/api/reports/monthly/:user_id?` - Báo cáo tháng
- GET `/api/reports/quarterly/:user_id?` - Báo cáo quý
- GET `/api/reports/yearly/:user_id?` - Báo cáo năm
- POST `/api/reports/send-email` - Gửi báo cáo qua email (thủ công)

### Salary APIs

- GET `/api/salary/calculate` - Tính lương (theo tuần/tháng)
- POST `/api/salary/generate` - Tạo bảng lương (admin only)
- GET `/api/salary/history/:user_id` - Lịch sử lương
- PUT `/api/salary/:id` - Cập nhật bảng lương (admin only)

### Scheduled Jobs

- Cron job gửi báo cáo email hàng tuần (Chủ nhật 6PM)
- Cron job gửi báo cáo email hàng tháng (ngày 1 mỗi tháng)
- Cron job tự động tính lương cuối tháng

## 4. Xây dựng Mobile App (Flutter)

### Màn hình Authentication

- **ManHinhDangNhap** (LoginScreen): Đăng nhập cho Admin và Nhân viên
- **ManHinhDangKySinhTracHoc** (BiometricSetupScreen): Đăng ký vân tay/Face ID lần đầu

### Màn hình Nhân Viên

- **ManHinhChuNhanVien** (EmployeeHomeScreen): 
  - Hiển thị thông tin cá nhân
  - Nút "Điểm danh vào" / "Điểm danh ra" (lớn, rõ ràng)
  - Thời gian làm việc hôm nay
  - Trạng thái điểm danh
- **ManHinhLichSuDiemDanh** (AttendanceHistoryScreen): Lịch sử điểm danh (calendar view)
- **ManHinhXemLuong** (SalaryScreen): Xem lương và lịch sử lương
- **ManHinhCaNhan** (ProfileScreen): Thông tin cá nhân, cài đặt

### Màn hình Admin

- **ManHinhTongQuanAdmin** (AdminDashboardScreen):
  - Tổng quan: Số nhân viên đang làm, đã về, nghỉ
  - Biểu đồ thống kê (fl_chart)
- **ManHinhQuanLyNhanVien** (EmployeeManagementScreen):
  - Danh sách nhân viên (search, filter)
  - Thêm/Sửa/Đóng tài khoản
- **ManHinhChamCongThuCong** (ManualAttendanceScreen): Chấm công thủ công cho nhân viên
- **ManHinhBaoCao** (ReportsScreen): 
  - Chọn loại báo cáo (tuần/tháng/quý/năm)
  - Xem và gửi báo cáo qua email
- **ManHinhQuanLyLuong** (SalaryManagementScreen): 
  - Tính và quản lý lương nhân viên
  - Thêm thưởng/trừ lương

### Tích hợp Biometric

- Sử dụng `local_auth` package để:
  - Kiểm tra thiết bị hỗ trợ sinh trắc học
  - Đăng ký fingerprint/Face ID
  - Xác thực khi điểm danh

## 5. Email Service

- Tạo email templates HTML đẹp cho:
- Báo cáo tuần (tổng giờ làm, số ngày làm, số ngày nghỉ)
- Báo cáo tháng (tổng giờ, lương dự kiến, chi tiết từng ngày)
- Sử dụng nodemailer với SMTP (Gmail hoặc dịch vụ email khác)
- Tích hợp queue system (optional) để gửi email hàng loạt

## 6. Security & Validation

- Hash password với bcrypt
- JWT token với expiry time
- Validate input với Joi/express-validator
- Rate limiting cho APIs
- SQL injection prevention (sử dụng parameterized queries)
- HTTPS cho production

## 7. Testing & Deployment

- Test các API endpoints với Postman
- Test Flutter app trên thiết bị thật (để test biometric)
- Build APK/AAB cho Android (flutter build apk/appbundle)
- Build IPA cho iOS (nếu cần)
- Deploy backend lên VPS hoặc cloud (AWS, Azure, DigitalOcean)
- Cấu hình SQL Server production database

## 8. Documentation

- Tạo file README.md với hướng dẫn cài đặt
- Document API endpoints
- Hướng dẫn sử dụng app cho admin và nhân viên

---

# GIAI ĐOẠN 2: TÍNH NĂNG NÂNG CAO

## 9. Quản lý Ca làm việc & Nghỉ phép

### Database mở rộng

**Shifts** (Ca làm việc)

- id, shift_name (Sáng/Chiều/Đêm/Tự do)
- start_time, end_time
- break_duration (phút nghỉ giải lao)
- is_active

**EmployeeShifts** (Phân ca cho nhân viên)

- id, user_id, shift_id
- effective_date, end_date
- days_of_week (JSON: [1,2,3,4,5] = T2-T6)

**LeaveTypes** (Loại nghỉ phép)

- id, name (Nghỉ phép năm, Nghỉ ốm, Nghỉ không lương)
- days_per_year, requires_approval
- paid (có lương/không)

**LeaveBalances** (Số ngày phép còn lại)

- id, user_id, leave_type_id
- total_days, used_days, remaining_days
- year

**LeaveRequests** (Yêu cầu nghỉ phép)

- id, user_id, leave_type_id
- start_date, end_date, total_days
- reason, status (pending/approved/rejected)
- approved_by_id, approved_at, rejection_reason
- created_at

**Overtime** (Tăng ca)

- id, user_id, date, hours
- overtime_rate (1.5x, 2x), total_amount
- status, approved_by_id, notes

### APIs mới

**Shift Management**

- GET `/api/shifts` - Danh sách ca làm việc
- POST `/api/shifts` - Tạo ca mới (admin)
- PUT `/api/shifts/:id` - Cập nhật ca (admin)
- POST `/api/employee-shifts` - Phân ca cho nhân viên (admin)
- GET `/api/employee-shifts/:user_id` - Xem lịch ca của nhân viên
- GET `/api/shifts/schedule` - Lịch làm việc toàn công ty (admin)

**Leave Management**

- GET `/api/leave/types` - Danh sách loại nghỉ phép
- GET `/api/leave/balance/:user_id` - Số ngày phép còn lại
- POST `/api/leave/request` - Tạo yêu cầu nghỉ phép (employee)
- GET `/api/leave/my-requests` - Lịch sử nghỉ phép cá nhân
- GET `/api/leave/pending` - Danh sách chờ duyệt (admin/manager)
- PUT `/api/leave/:id/approve` - Duyệt nghỉ phép (admin/manager)
- PUT `/api/leave/:id/reject` - Từ chối nghỉ phép (admin/manager)
- GET `/api/leave/calendar` - Calendar view nghỉ phép (admin)

**Overtime Management**

- POST `/api/overtime/request` - Đăng ký tăng ca
- GET `/api/overtime/my-records` - Lịch sử tăng ca cá nhân
- GET `/api/overtime/pending` - Danh sách tăng ca chờ duyệt (admin)
- PUT `/api/overtime/:id/approve` - Duyệt tăng ca (admin/manager)

### Mobile Screens mới

**Employee**

- **ShiftScheduleScreen**: Xem lịch ca làm việc cá nhân (calendar view)
- **LeaveRequestScreen**: Tạo yêu cầu nghỉ phép, xem số ngày phép còn lại
- **LeaveHistoryScreen**: Lịch sử nghỉ phép, trạng thái duyệt
- **OvertimeScreen**: Đăng ký tăng ca, xem lịch sử

**Admin/Manager**

- **ShiftManagementScreen**: Tạo ca, phân ca cho nhân viên
- **LeaveApprovalScreen**: Duyệt/từ chối nghỉ phép, xem calendar nghỉ phép
- **OvertimeApprovalScreen**: Duyệt tăng ca

## 10. Hệ thống Phân quyền & Role Manager

### Database mở rộng

**Roles**

- id, name (Admin, Manager, Employee)
- description, is_system_role

**Permissions**

- id, name, resource, action
- description
- VD: "view_employees", "approve_leave", "edit_attendance"

**RolePermissions**

- role_id, permission_id

**Departments** (Phòng ban)

- id, name, description
- manager_id (user_id của manager)
- created_at

Cập nhật **Users**:

- Thêm: role_id, department_id, manager_id

**ManagerDepartments** (Manager quản lý phòng ban nào)

- id, manager_id, department_id

### APIs mới

**Role & Permission**

- GET `/api/roles` - Danh sách roles
- GET `/api/permissions` - Danh sách permissions
- POST `/api/roles/:id/permissions` - Gán quyền cho role (admin only)
- GET `/api/users/:id/permissions` - Xem quyền của user

**Department**

- GET `/api/departments` - Danh sách phòng ban
- POST `/api/departments` - Tạo phòng ban (admin)
- PUT `/api/departments/:id` - Cập nhật phòng ban
- GET `/api/departments/:id/employees` - Nhân viên trong phòng ban
- POST `/api/departments/:id/manager` - Gán manager cho phòng ban

### Middleware

- `checkPermission(permission)` - Kiểm tra quyền trước khi truy cập API
- `isManager` - Kiểm tra có phải manager không
- `canAccessEmployee(userId)` - Manager chỉ truy cập nhân viên trong phòng ban của mình

### Mobile Screens mới

**Admin**

- **RoleManagementScreen**: Quản lý roles và permissions
- **DepartmentManagementScreen**: Quản lý phòng ban, gán manager

**Manager** (new user type)

- **MyTeamScreen**: Danh sách nhân viên trong team
- **TeamAttendanceScreen**: Xem điểm danh của team
- **TeamReportsScreen**: Báo cáo của phòng ban

## 11. GPS Tracking & Camera Verification

### Database mở rộng

Cập nhật **Attendance**:

- Thêm: photo_url, device_info, ip_address
- accuracy (GPS accuracy in meters)
- is_within_geofence (boolean)

**GeofenceLocations** (Địa điểm cho phép điểm danh)

- id, name (Văn phòng chính, Chi nhánh HCM)
- latitude, longitude, radius (meters)
- is_active

**AttendanceAlerts** (Cảnh báo bất thường)

- id, user_id, attendance_id
- alert_type (outside_geofence, late_checkin, missing_photo, suspicious_location)
- description, resolved, resolved_by_id
- created_at

### APIs mới

**Geofence**

- GET `/api/geofence/locations` - Danh sách địa điểm
- POST `/api/geofence/locations` - Thêm địa điểm (admin)
- POST `/api/geofence/verify` - Kiểm tra vị trí có trong geofence không

**Attendance với GPS & Photo**

- Cập nhật POST `/api/attendance/check-in` - Nhận GPS + photo
- Cập nhật POST `/api/attendance/check-out` - Nhận GPS + photo
- GET `/api/attendance/:id/photo` - Xem ảnh điểm danh
- GET `/api/attendance/alerts` - Danh sách cảnh báo (admin)

### Mobile Updates (Flutter)

Cập nhật **ManHinhChuNhanVien**:

- Request GPS permission (geolocator)
- Capture photo khi điểm danh (image_picker)
- Hiển thị cảnh báo nếu ngoài vùng cho phép

Thêm dependencies:

- `geolocator` cho GPS tracking
- `image_picker` cho camera/selfie
- `permission_handler` cho quản lý permissions

**Admin**

- **ManHinhQuanLyGeofence**: Quản lý địa điểm cho phép
- **ManHinhCanhBao**: Xem và xử lý các cảnh báo bất thường
- **ManHinhChiTietDiemDanh**: Xem chi tiết (ảnh, GPS, thời gian)

## 12. Push Notifications

### Backend

- Tích hợp Firebase Cloud Messaging (FCM)
- Cài đặt `firebase-admin` package

**Notifications** table

- id, user_id, title, body
- type (leave_approved, overtime_approved, salary_ready, alert, reminder)
- data (JSON), read_status
- sent_at, read_at

**DeviceTokens** table

- id, user_id, token, platform (android/ios)
- is_active, last_used_at

### APIs mới

- POST `/api/notifications/register-token` - Đăng ký FCM token
- GET `/api/notifications/my-notifications` - Danh sách thông báo
- PUT `/api/notifications/:id/read` - Đánh dấu đã đọc
- POST `/api/notifications/send` - Gửi notification (admin)

### Notification Triggers

- Khi admin duyệt/từ chối nghỉ phép → gửi cho employee
- Khi admin duyệt tăng ca → gửi cho employee
- Nhắc nhở điểm danh (8:00 AM mỗi ngày làm việc)
- Cảnh báo quên check-out (sau 6:00 PM)
- Khi có bảng lương mới
- Khi có cảnh báo bất thường

### Mobile (Flutter)

- Cài đặt `firebase_messaging` package
- **ManHinhThongBao** (NotificationsScreen): Danh sách thông báo
- Badge count cho unread notifications
- Handle notification clicks (navigation)

## 13. Dashboard Analytics & Reports nâng cao

### Backend Analytics APIs

- GET `/api/analytics/overview` - Tổng quan (admin/manager)
  - Tổng nhân viên, tỷ lệ đi làm, trung bình giờ làm
  - Trend theo tháng
- GET `/api/analytics/attendance-rate` - Tỷ lệ điểm danh theo phòng ban/thời gian
- GET `/api/analytics/late-checkin` - Top nhân viên đi muộn
- GET `/api/analytics/overtime-stats` - Thống kê tăng ca
- GET `/api/analytics/leave-stats` - Thống kê nghỉ phép
- GET `/api/analytics/salary-summary` - Tổng chi phí lương theo phòng ban
- GET `/api/analytics/compare-employees` - So sánh hiệu suất
- GET `/api/analytics/compare-departments` - So sánh phòng ban

### Export Reports

- Cài đặt `exceljs` cho Excel export
- Cài đặt `pdfkit` hoặc `puppeteer` cho PDF export

**APIs**

- GET `/api/reports/export/excel?type=attendance&period=monthly` - Export Excel
- GET `/api/reports/export/pdf?type=salary&user_id=123` - Export PDF

### Automated Alerts

**Cron jobs mới**:

- Hàng ngày 9:00 AM: Cảnh báo nhân viên đi muộn cho manager
- Hàng tuần: Báo cáo nhân viên thiếu giờ
- Hàng tháng: Top performers và underperformers

**AlertRules** table

- id, name, condition (JSON), action
- is_active, notify_roles

VD Alert Rules:

- "Đi muộn 3 lần/tuần → thông báo manager"
- "Thiếu > 5 giờ/tháng → thông báo admin"
- "Không check-out 2 lần/tuần → cảnh báo"

### Mobile Screens mới (Flutter)

**Admin Dashboard (nâng cao)**

- **ManHinhPhanTichDuLieu** (AnalyticsDashboardScreen): 
  - Biểu đồ line/bar/pie với fl_chart (tỷ lệ điểm danh, tăng ca, nghỉ phép)
  - KPI cards (tỷ lệ đúng giờ, trung bình giờ làm)
  - Filter theo phòng ban, thời gian
- **ManHinhSoSanhHieuSuat** (PerformanceComparisonScreen): So sánh nhân viên/phòng ban
- **ManHinhCanhBaoTuDong** (AutomatedAlertsScreen): Cấu hình rules cảnh báo tự động
- **ManHinhXuatBaoCao** (ExportReportsScreen): Export Excel/PDF với custom filters

## 14. Update Database Schema Summary

Các bảng mới (giai đoạn 2):

1. Shifts, EmployeeShifts
2. LeaveTypes, LeaveBalances, LeaveRequests
3. Overtime
4. Roles, Permissions, RolePermissions
5. Departments, ManagerDepartments
6. GeofenceLocations, AttendanceAlerts
7. Notifications, DeviceTokens
8. AlertRules

Các bảng cập nhật:

- Users: thêm role_id, department_id, manager_id
- Attendance: thêm photo_url, device_info, ip_address, accuracy, is_within_geofence

## 15. Technology Stack Updates

### Backend thêm

- `firebase-admin` - Push notifications
- `exceljs` - Excel export
- `pdfkit` hoặc `puppeteer` - PDF export
- `node-schedule` - Advanced cron jobs

### Mobile thêm (Flutter)

- `firebase_core` và `firebase_messaging` - FCM  
- `geolocator` - GPS tracking
- `image_picker` - Camera/Selfie
- `permission_handler` - Quản lý permissions
- `fl_chart` - Biểu đồ nâng cao
- `table_calendar` - Calendar views
- `flutter_bloc` hoặc `provider` - State management
- `dio` - HTTP client
- `shared_preferences` - Local storage
- `local_auth` - Biometric authentication

## 16. Testing & Performance

- Load testing với nhiều nhân viên điểm danh đồng thời
- Test GPS accuracy và geofencing
- Test push notifications trên Android
- Optimize database queries với indexes
- Implement caching (Redis) cho analytics data
- Image optimization và CDN cho attendance photos

### To-dos

- [x] Khởi tạo .NET backend với SQL Server connection, và cấu trúc thư mục
- [ ] Khởi tạo Flutter project và cài đặt dependencies cần thiết
- [x] Tạo database schema và SQL scripts cho các bảng chính
- [x] Xây dựng authentication APIs (login, biometric verification, JWT)
- [x] Xây dựng Employee Management APIs cho admin
- [x] Xây dựng Attendance APIs (check-in/out, manual attendance)
- [ ] Xây dựng Report và Salary APIs
- [ ] Tích hợp email service và tạo templates, thiết lập cron jobs
- [ ] Xây dựng màn hình authentication và tích hợp biometric cho Flutter
- [ ] Xây dựng các màn hình cho Employee (home, attendance, salary, profile)
- [ ] Xây dựng các màn hình cho Admin (dashboard, employee management, reports)
- [ ] Testing toàn bộ hệ thống và tạo documentation
