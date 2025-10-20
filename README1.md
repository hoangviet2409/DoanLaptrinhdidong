# Kế hoạch Chia Việc Nhóm 5 Người - Ứng dụng Điểm Danh Nhân Viên

## Phân Công Thành Viên

### Thành viên 1: Backend Lead - Database & Core APIs
**Chuyên môn**: Backend (Node.js, SQL Server)

**Nhiệm vụ chính**:
- Thiết lập cấu trúc dự án backend (Express.js, SQL Server connection)
- Thiết kế và tạo database schema đầy đủ (cả 2 giai đoạn)
- Xây dựng Authentication APIs (JWT, biometric verification)
- Xây dựng Attendance APIs (check-in/out, manual attendance)
- Xây dựng middleware authorization và security layer
- Hỗ trợ integration testing với team mobile

**File paths**: `backend/`, `backend/config/`, `backend/models/`, `backend/routes/auth.js`, `backend/routes/attendance.js`, `backend/middleware/`, `database/schema.sql`

---

### Thành viên 2: Backend - Employee & Reports
**Chuyên môn**: Backend (Node.js, Email Service)

**Nhiệm vụ chính**:
- Xây dựng Employee Management APIs
- Xây dựng Report APIs (weekly, monthly, quarterly, yearly)
- Xây dựng Salary APIs
- Tích hợp Email Service (nodemailer, templates HTML)
- Thiết lập Cron Jobs (scheduled reports, auto salary calculation)
- Validation và error handling

**File paths**: `backend/routes/employees.js`, `backend/routes/reports.js`, `backend/routes/salary.js`, `backend/services/emailService.js`, `backend/templates/`, `backend/jobs/`

---

### Thành viên 3: Backend - Advanced Features (Giai đoạn 2)
**Chuyên môn**: Backend (Node.js, Firebase, APIs nâng cao)

**Nhiệm vụ chính**:
- Xây dựng Shift Management APIs
- Xây dựng Leave Management APIs
- Xây dựng Overtime Management APIs
- Xây dựng Role & Permission System
- Xây dựng Department Management APIs
- Tích hợp Firebase Cloud Messaging (Push Notifications)
- Xây dựng Analytics & Advanced Reports APIs
- Export Reports (Excel, PDF)

**File paths**: `backend/routes/shifts.js`, `backend/routes/leave.js`, `backend/routes/overtime.js`, `backend/routes/roles.js`, `backend/routes/departments.js`, `backend/routes/analytics.js`, `backend/services/notificationService.js`, `backend/services/exportService.js`

---

### Thành viên 4: Mobile Lead - Core Features
**Chuyên môn**: Flutter, Mobile UI/UX

**Nhiệm vụ chính**:
- Thiết lập Flutter project và dependencies
- Xây dựng Navigation structure (go_router/Navigator)
- Xây dựng Authentication Screens (Login, Biometric Setup)
- Tích hợp Biometric Authentication với local_auth (fingerprint/Face ID)
- Xây dựng Employee Screens:
  - ManHinhChuNhanVien (check-in/out)
  - ManHinhLichSuDiemDanh
  - ManHinhXemLuong
  - ManHinhCaNhan
- Tích hợp API với backend (Dio)
- UI/UX design với Material Design

**File paths**: `ung_dung_diem_danh/lib/`, `lib/screens/auth/`, `lib/screens/employee/`, `lib/routes/`, `lib/services/api_service.dart`, `lib/widgets/`

---

### Thành viên 5: Mobile - Admin & Advanced Features  
**Chuyên môn**: Flutter, Charts, Camera/GPS

**Nhiệm vụ chính**:
- Xây dựng Admin Screens:
  - ManHinhTongQuanAdmin (overview, charts với fl_chart)
  - ManHinhQuanLyNhanVien
  - ManHinhChamCongThuCong
  - ManHinhBaoCao
  - ManHinhQuanLyLuong
- Tích hợp Charts và Analytics (fl_chart)
- Xây dựng Advanced Features (Giai đoạn 2):
  - ManHinhLichCaLam, ManHinhXinNghiPhep
  - GPS Tracking (geolocator)
  - Camera Verification (image_picker)
  - Push Notifications (firebase_messaging)
  - ManHinhQuanLyGeofence, ManHinhCanhBao
  - ManHinhPhanTichDuLieu với advanced charts

**File paths**: `lib/screens/admin/`, `lib/screens/advanced/`, `lib/widgets/charts/`, `lib/services/gps_service.dart`, `lib/services/camera_service.dart`, `lib/services/notification_service.dart`

---

## Timeline & Dependencies

### Phase 1: Setup & Core Features (Tuần 1-4)

**Tuần 1: Setup & Infrastructure**
- Thành viên 1: Setup backend project, database schema giai đoạn 1
- Thành viên 2: Setup email service, templates
- Thành viên 3: Chuẩn bị database schema giai đoạn 2
- Thành viên 4: Setup Flutter project, navigation, authentication UI
- Thành viên 5: Setup fl_chart, admin UI components

**Tuần 2-3: Core APIs & Screens**
- Thành viên 1 & 2: Hoàn thành các APIs giai đoạn 1
- Thành viên 4: Employee screens + biometric integration
- Thành viên 5: Admin screens + basic charts

**Tuần 4: Integration & Testing Phase 1**
- Tất cả: Testing, bug fixes, integration

### Phase 2: Advanced Features (Tuần 5-8)

**Tuần 5-6: Advanced Backend & Features**
- Thành viên 1: Support advanced features, optimize queries
- Thành viên 2: Advanced reports, cron jobs optimization
- Thành viên 3: Shifts, Leave, Overtime, Role APIs
- Thành viên 4: Employee advanced screens (leave, overtime)
- Thành viên 5: GPS, Camera, Geofencing integration

**Tuần 7: Notifications & Analytics**
- Thành viên 3: FCM integration, analytics APIs
- Thành viên 5: Push notifications mobile, analytics dashboard

**Tuần 8: Final Testing & Deployment**
- Thành viên 1: Database optimization, deployment setup
- Thành viên 2: Documentation, API docs
- Thành viên 3: Export reports, final testing
- Thành viên 4: Mobile testing on real devices
- Thành viên 5: Performance testing, APK build

---

## Collaboration & Communication

### Daily Standup Topics:
- Tiến độ công việc hôm qua
- Kế hoạch hôm nay
- Blockers và cần hỗ trợ gì

### Integration Points:
- **Backend Team (1, 2, 3)**: Daily sync về API contracts, database changes
- **Mobile Team (4, 5)**: Pair programming cho complex features
- **Cross-team**: API integration meetings 2x/week

### Code Review:
- Backend reviews backend PRs
- Mobile reviews mobile PRs
- Cross-review cho integration points

---

## Key Deliverables by Member

**Thành viên 1**: Database schema, Auth & Attendance APIs, Security layer
**Thành viên 2**: Employee/Report/Salary APIs, Email service, Cron jobs  
**Thành viên 3**: Advanced APIs (Shift/Leave/Overtime/Role/Dept), FCM, Analytics, Export
**Thành viên 4**: Employee Flutter app, Biometric với local_auth, Core UI/UX
**Thành viên 5**: Admin Flutter app, Charts với fl_chart, GPS/Camera, Push notifications

---

## Success Criteria

- [ ] Tất cả APIs hoạt động và được document
- [ ] Mobile app chạy mượt trên Android
- [ ] Biometric authentication hoạt động
- [ ] Email service gửi được reports tự động
- [ ] GPS & Camera verification hoạt động
- [ ] Push notifications hoạt động
- [ ] Analytics dashboard hiển thị đúng data
- [ ] Export Excel/PDF thành công
- [ ] Code có documentation và comments
- [ ] Deployment thành công

---

## Chi tiết Công việc theo Tuần

### Tuần 1: Setup & Infrastructure
**Thành viên 1**:
- [ ] Khởi tạo Node.js project với Express.js
- [ ] Cấu hình kết nối SQL Server
- [ ] Thiết lập JWT authentication middleware
- [ ] Tạo database schema cho giai đoạn 1 (Users, Admins, Attendance, Salary, EmailLogs)

**Thành viên 2**:
- [ ] Setup nodemailer cho email service
- [ ] Tạo email templates HTML (weekly, monthly reports)
- [ ] Thiết lập node-cron cho scheduled jobs
- [ ] Setup validation với Joi/express-validator

**Thành viên 3**:
- [ ] Nghiên cứu Firebase Cloud Messaging
- [ ] Thiết kế database schema cho giai đoạn 2
- [ ] Setup các dependencies cần thiết (exceljs, pdfkit)
- [ ] Chuẩn bị cấu trúc cho advanced APIs

**Thành viên 4**:
- [ ] Khởi tạo Flutter project
- [ ] Cài đặt dependencies: local_auth, dio, shared_preferences, flutter_bloc
- [ ] Setup navigation structure (go_router)
- [ ] Tạo UI components cơ bản

**Thành viên 5**:
- [ ] Cài đặt fl_chart, flutter UI packages
- [ ] Setup admin UI components
- [ ] Chuẩn bị cấu trúc cho advanced mobile features
- [ ] Nghiên cứu geolocator và image_picker

### Tuần 2-3: Core APIs & Screens
**Thành viên 1**:
- [ ] Xây dựng Authentication APIs (admin/login, employee/login, biometric/verify)
- [ ] Xây dựng Attendance APIs (check-in, check-out, manual attendance)
- [ ] Implement security layer (bcrypt, rate limiting, SQL injection prevention)
- [ ] Testing APIs với Postman

**Thành viên 2**:
- [ ] Xây dựng Employee Management APIs (CRUD operations)
- [ ] Xây dựng Report APIs (weekly, monthly, quarterly, yearly)
- [ ] Xây dựng Salary APIs (calculate, generate, history)
- [ ] Implement email service và cron jobs

**Thành viên 4**:
- [ ] Xây dựng LoginScreen và BiometricSetupScreen
- [ ] Tích hợp biometric authentication
- [ ] Xây dựng EmployeeHomeScreen (check-in/out functionality)
- [ ] Xây dựng AttendanceHistoryScreen và SalaryScreen
- [ ] Tích hợp API calls với backend

**Thành viên 5**:
- [ ] Xây dựng AdminDashboardScreen với basic charts
- [ ] Xây dựng EmployeeManagementScreen
- [ ] Xây dựng ManualAttendanceScreen
- [ ] Xây dựng ReportsScreen và SalaryManagementScreen

### Tuần 4: Integration & Testing Phase 1
**Tất cả thành viên**:
- [ ] Integration testing giữa backend và mobile
- [ ] Bug fixes và optimization
- [ ] Testing biometric authentication trên thiết bị thật
- [ ] Testing email service
- [ ] Code review và documentation

### Tuần 5-6: Advanced Backend & Features
**Thành viên 1**:
- [ ] Support advanced features, optimize database queries
- [ ] Implement advanced security features
- [ ] Performance optimization

**Thành viên 2**:
- [ ] Advanced reports với filters và pagination
- [ ] Optimize cron jobs performance
- [ ] Enhanced email templates

**Thành viên 3**:
- [ ] Xây dựng Shift Management APIs
- [ ] Xây dựng Leave Management APIs (request, approve, reject)
- [ ] Xây dựng Overtime Management APIs
- [ ] Xây dựng Role & Permission System
- [ ] Xây dựng Department Management APIs

**Thành viên 4**:
- [ ] Xây dựng ShiftScheduleScreen
- [ ] Xây dựng LeaveRequestScreen và LeaveHistoryScreen
- [ ] Xây dựng OvertimeScreen
- [ ] Tích hợp advanced APIs

**Thành viên 5**:
- [ ] Tích hợp GPS tracking (react-native-geolocation-service)
- [ ] Tích hợp Camera verification (react-native-image-picker)
- [ ] Xây dựng GeofenceManagementScreen
- [ ] Xây dựng AlertsScreen

### Tuần 7: Notifications & Analytics
**Thành viên 3**:
- [ ] Tích hợp Firebase Cloud Messaging backend
- [ ] Xây dựng Analytics APIs (overview, attendance-rate, late-checkin, etc.)
- [ ] Implement Export Reports (Excel, PDF)
- [ ] Setup notification triggers

**Thành viên 5**:
- [ ] Tích hợp Push Notifications mobile (@react-native-firebase/messaging)
- [ ] Xây dựng AnalyticsDashboardScreen với advanced charts
- [ ] Xây dựng PerformanceComparisonScreen
- [ ] Xây dựng ExportReportsScreen

### Tuần 8: Final Testing & Deployment
**Thành viên 1**:
- [ ] Database optimization và indexing
- [ ] Setup production database
- [ ] Deployment configuration

**Thành viên 2**:
- [ ] API documentation hoàn chỉnh
- [ ] User guides cho admin và employee
- [ ] Final testing email service

**Thành viên 3**:
- [ ] Final testing export reports
- [ ] Performance testing advanced features
- [ ] Documentation cho advanced APIs

**Thành viên 4**:
- [ ] Testing trên nhiều thiết bị Android
- [ ] Performance optimization mobile app
- [ ] Final UI/UX polish

**Thành viên 5**:
- [ ] Performance testing GPS và Camera
- [ ] Testing push notifications
- [ ] Build APK cho production
- [ ] Final testing advanced features

---

## Công cụ và Dependencies

### Backend Dependencies
```json
{
  "express": "^4.18.2",
  "mssql": "^9.1.1",
  "jsonwebtoken": "^9.0.2",
  "bcryptjs": "^2.4.3",
  "nodemailer": "^6.9.4",
  "node-cron": "^3.0.2",
  "joi": "^17.9.2",
  "express-rate-limit": "^6.8.1",
  "firebase-admin": "^11.10.1",
  "exceljs": "^4.3.0",
  "pdfkit": "^0.13.0"
}
```

### Flutter Dependencies (pubspec.yaml)
```yaml
dependencies:
  flutter:
    sdk: flutter
  # State Management
  flutter_bloc: ^8.1.3
  provider: ^6.1.1
  
  # API & Networking
  dio: ^5.4.0
  http: ^1.1.2
  
  # Local Storage
  shared_preferences: ^2.2.2
  
  # Biometric
  local_auth: ^2.1.8
  
  # Navigation
  go_router: ^13.0.0
  
  # UI & Charts
  fl_chart: ^0.66.0
  table_calendar: ^3.0.9
  
  # Location & Camera
  geolocator: ^11.0.0
  image_picker: ^1.0.7
  permission_handler: ^11.2.0
  
  # Firebase
  firebase_core: ^2.24.2
  firebase_messaging: ^14.7.10
  
  # Utilities
  intl: ^0.18.1
  equatable: ^2.0.5
```

---

## Lưu ý Quan trọng

1. **Communication**: Mỗi ngày họp 15 phút để sync tiến độ
2. **Code Review**: Bắt buộc review code trước khi merge
3. **Testing**: Test trên thiết bị thật, đặc biệt cho biometric và GPS
4. **Documentation**: Comment code và viết README cho mỗi module
5. **Backup**: Commit code thường xuyên, backup database
6. **Security**: Không commit sensitive data (passwords, API keys)
7. **Performance**: Monitor performance, optimize queries
8. **User Experience**: Test UX với người dùng thật

---

## Contact & Support

- **Backend Team Lead**: Thành viên 1
- **Mobile Team Lead**: Thành viên 4
- **Project Manager**: [Tên người quản lý dự án]
- **Daily Standup**: 9:00 AM mỗi ngày
- **Weekly Review**: Thứ 6 hàng tuần
