# 🏗️ Architecture Overview - Ứng dụng Điểm Danh

## 📊 System Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                        CLIENT LAYER                              │
├─────────────────────────────────────────────────────────────────┤
│                                                                   │
│  ┌────────────────────┐        ┌────────────────────┐          │
│  │   Flutter Mobile   │        │   Web Admin Panel  │          │
│  │    (Android/iOS)   │        │   (Future Phase)   │          │
│  │                    │        │                    │          │
│  │  • BLoC Pattern    │        │  • React/Angular   │          │
│  │  • Material Design │        │  • Dashboard       │          │
│  │  • Biometric Auth  │        │  • Analytics       │          │
│  └─────────┬──────────┘        └─────────┬──────────┘          │
│            │                              │                      │
└────────────┼──────────────────────────────┼──────────────────────┘
             │                              │
             │ HTTPS/REST API               │
             ▼                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                      API GATEWAY LAYER                           │
├─────────────────────────────────────────────────────────────────┤
│                                                                   │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │              ASP.NET Core 8 Web API                       │  │
│  │                                                            │  │
│  │  • JWT Authentication Middleware                          │  │
│  │  • CORS Policy                                            │  │
│  │  • Exception Handling                                     │  │
│  │  • Request/Response Logging (Serilog)                     │  │
│  │  • Swagger/OpenAPI Documentation                          │  │
│  └───────────────────────────────────────────────────────────┘  │
│                                                                   │
└────────────────────────────┬─────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│                    CONTROLLERS LAYER                             │
├─────────────────────────────────────────────────────────────────┤
│                                                                   │
│  ┌────────────┐  ┌─────────────┐  ┌──────────────┐            │
│  │  XacThuc   │  │  NhanVien   │  │  DiemDanh    │            │
│  │ Controller │  │ Controller  │  │  Controller  │            │
│  │  (5 APIs)  │  │  (8 APIs)   │  │  (13 APIs)   │            │
│  └─────┬──────┘  └──────┬──────┘  └──────┬───────┘            │
│        │                │                 │                      │
│  ┌─────┴───────┐  ┌────┴─────────┐      │                      │
│  │   BaoCao    │  │    Luong     │      │                      │
│  │ Controller  │  │  Controller  │      │                      │
│  │  (6 APIs)   │  │   (7 APIs)   │      │                      │
│  └─────┬───────┘  └──────┬───────┘      │                      │
│        │                  │              │                      │
└────────┼──────────────────┼──────────────┼──────────────────────┘
         │                  │              │
         │   Dependency Injection (DI)     │
         ▼                  ▼              ▼
┌─────────────────────────────────────────────────────────────────┐
│                     SERVICES LAYER                               │
├─────────────────────────────────────────────────────────────────┤
│                                                                   │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐          │
│  │   XacThuc    │  │  NhanVien    │  │  DiemDanh    │          │
│  │   Service    │  │   Service    │  │   Service    │          │
│  │              │  │              │  │              │          │
│  │ • Login      │  │ • CRUD       │  │ • Check-in   │          │
│  │ • Register   │  │ • Search     │  │ • Check-out  │          │
│  │ • JWT Token  │  │ • Filter     │  │ • History    │          │
│  │ • Biometric  │  │ • Validate   │  │ • Stats      │          │
│  └──────────────┘  └──────────────┘  └──────────────┘          │
│                                                                   │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐          │
│  │   BaoCao     │  │    Luong     │  │    Email     │          │
│  │   Service    │  │   Service    │  │   Service    │          │
│  │              │  │              │  │              │          │
│  │ • Reports    │  │ • Calculate  │  │ • SMTP       │          │
│  │ • Stats      │  │ • History    │  │ • Templates  │          │
│  │ • Export     │  │ • Bonus      │  │ • Queue      │          │
│  └──────────────┘  └──────────────┘  └──────────────┘          │
│                                                                   │
└────────────────────────────┬─────────────────────────────────────┘
                             │
                             │ Entity Framework Core (ORM)
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│                    DATA ACCESS LAYER                             │
├─────────────────────────────────────────────────────────────────┤
│                                                                   │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │           UngDungDiemDanhContext (DbContext)              │  │
│  │                                                            │  │
│  │  DbSet<QuanTriVien>                                       │  │
│  │  DbSet<NhanVien>                                          │  │
│  │  DbSet<DiemDanh>                                          │  │
│  │  DbSet<Luong>                                             │  │
│  │  DbSet<NhatKyEmail>                                       │  │
│  └───────────────────────────────────────────────────────────┘  │
│                                                                   │
└────────────────────────────┬─────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│                     DATABASE LAYER                               │
├─────────────────────────────────────────────────────────────────┤
│                                                                   │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │                    SQL Server Database                     │  │
│  │                                                            │  │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐   │  │
│  │  │ QuanTriVien  │  │  NhanVien    │  │  DiemDanh    │   │  │
│  │  │  (Admins)    │  │ (Employees)  │  │(Attendance)  │   │  │
│  │  └──────────────┘  └──────────────┘  └──────────────┘   │  │
│  │                                                            │  │
│  │  ┌──────────────┐  ┌──────────────┐                      │  │
│  │  │    Luong     │  │ NhatKyEmail  │                      │  │
│  │  │  (Salary)    │  │(Email Logs)  │                      │  │
│  │  └──────────────┘  └──────────────┘                      │  │
│  └───────────────────────────────────────────────────────────┘  │
│                                                                   │
└─────────────────────────────────────────────────────────────────┘


┌─────────────────────────────────────────────────────────────────┐
│                   EXTERNAL SERVICES                              │
├─────────────────────────────────────────────────────────────────┤
│                                                                   │
│  ┌────────────┐  ┌─────────────┐  ┌──────────────┐            │
│  │   SMTP     │  │  Firebase   │  │   Hangfire   │            │
│  │  Server    │  │    (FCM)    │  │(Background)  │            │
│  │            │  │             │  │              │            │
│  │ • Gmail    │  │ • Push      │  │ • Scheduled  │            │
│  │ • SendGrid │  │   Notify    │  │   Jobs       │            │
│  │ • Custom   │  │             │  │ • Email Auto │            │
│  └────────────┘  └─────────────┘  └──────────────┘            │
│                                                                   │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🔐 Authentication Flow

```
┌──────────────┐
│    User      │
│ (Mobile App) │
└──────┬───────┘
       │
       │ 1. POST /api/XacThuc/dang-nhap-nhan-vien
       │    { maNhanVien, matKhau }
       ▼
┌─────────────────────────┐
│  XacThucController      │
└──────┬──────────────────┘
       │
       │ 2. Validate credentials
       ▼
┌─────────────────────────┐
│   XacThucService        │
│  • Verify password      │
│  • Generate JWT token   │
└──────┬──────────────────┘
       │
       │ 3. Query database
       ▼
┌─────────────────────────┐
│   Database (NhanVien)   │
└──────┬──────────────────┘
       │
       │ 4. Return JWT token
       ▼
┌──────────────┐
│  Mobile App  │
│ • Save token │
│ • Navigate   │
└──────────────┘

Subsequent Requests:
┌──────────────┐
│  Mobile App  │───► GET /api/DiemDanh/lich-su-ca-nhan
└──────────────┘     Header: Authorization: Bearer {token}
       │
       ▼
┌─────────────────────────┐
│  JWT Middleware         │
│  • Validate token       │
│  • Extract claims       │
│  • Set User context     │
└──────┬──────────────────┘
       │
       │ ✅ Authorized
       ▼
┌─────────────────────────┐
│  DiemDanhController     │
│  • Access UserId        │
│  • Process request      │
└─────────────────────────┘
```

---

## 📱 Flutter App Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                       PRESENTATION LAYER                         │
├─────────────────────────────────────────────────────────────────┤
│                                                                   │
│  ┌─────────────┐  ┌──────────────┐  ┌──────────────┐          │
│  │   Screens   │  │   Widgets    │  │  Navigation  │          │
│  │             │  │              │  │              │          │
│  │ • Login     │  │ • Custom     │  │ • go_router  │          │
│  │ • Home      │  │   Buttons    │  │ • Routes     │          │
│  │ • Attendance│  │ • Cards      │  │ • Guards     │          │
│  │ • Reports   │  │ • Forms      │  │              │          │
│  └─────────────┘  └──────────────┘  └──────────────┘          │
│                                                                   │
└────────────────────────────┬─────────────────────────────────────┘
                             │
                             │ Events / State
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│                    STATE MANAGEMENT (BLoC)                       │
├─────────────────────────────────────────────────────────────────┤
│                                                                   │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │                     AuthBloc                              │  │
│  │                                                            │  │
│  │  Events:                    States:                       │  │
│  │  • LoginRequested           • AuthInitial                 │  │
│  │  • LogoutRequested          • AuthLoading                 │  │
│  │  • TokenRefreshed           • Authenticated               │  │
│  │                             • Unauthenticated             │  │
│  └───────────────────────────────────────────────────────────┘  │
│                                                                   │
└────────────────────────────┬─────────────────────────────────────┘
                             │
                             │ API Calls
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│                      BUSINESS LOGIC LAYER                        │
├─────────────────────────────────────────────────────────────────┤
│                                                                   │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐          │
│  │   AuthSvc    │  │  DiemDanhSvc │  │  BaoCaoSvc   │          │
│  └──────────────┘  └──────────────┘  └──────────────┘          │
│                                                                   │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐          │
│  │ NhanVienSvc  │  │   AdminSvc   │  │   AuthMgr    │          │
│  └──────────────┘  └──────────────┘  └──────────────┘          │
│                                                                   │
└────────────────────────────┬─────────────────────────────────────┘
                             │
                             │ HTTP (Dio)
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│                      DATA ACCESS LAYER                           │
├─────────────────────────────────────────────────────────────────┤
│                                                                   │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │                      ApiService                            │  │
│  │                       (Dio Client)                         │  │
│  │                                                            │  │
│  │  • Base URL configuration                                 │  │
│  │  • Interceptors (Token, Logging, Error)                   │  │
│  │  • Request/Response serialization                         │  │
│  │  • Timeout handling                                        │  │
│  └───────────────────────────────────────────────────────────┘  │
│                                                                   │
└────────────────────────────┬─────────────────────────────────────┘
                             │
                             │ REST API
                             ▼
                     Backend APIs (ASP.NET Core)


┌─────────────────────────────────────────────────────────────────┐
│                      LOCAL STORAGE                               │
├─────────────────────────────────────────────────────────────────┤
│                                                                   │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │              SharedPreferences                             │  │
│  │                                                            │  │
│  │  • JWT Token                                              │  │
│  │  • User Info (cached)                                     │  │
│  │  • App Settings                                            │  │
│  │  • Remember Me flag                                        │  │
│  └───────────────────────────────────────────────────────────┘  │
│                                                                   │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🔄 Attendance Flow (Check-in/out)

```
┌───────────────────────────────────────────────────────────────┐
│                 1. USER TAPS CHECK-IN BUTTON                  │
└────────────────────────────┬──────────────────────────────────┘
                             │
                             ▼
┌───────────────────────────────────────────────────────────────┐
│              2. REQUEST BIOMETRIC AUTHENTICATION              │
│                  (Fingerprint / Face ID)                      │
└────────────────────────────┬──────────────────────────────────┘
                             │
                    ┌────────┴────────┐
                    │                 │
              ✅ Success         ❌ Failed
                    │                 │
                    ▼                 ▼
          ┌──────────────┐    ┌──────────────┐
          │   Continue   │    │  Show Error  │
          └──────┬───────┘    │   & Stop     │
                 │            └──────────────┘
                 ▼
┌───────────────────────────────────────────────────────────────┐
│           3. CAPTURE LOCATION (GPS) - Optional                │
│              Get latitude & longitude                         │
└────────────────────────────┬──────────────────────────────────┘
                             │
                             ▼
┌───────────────────────────────────────────────────────────────┐
│           4. PREPARE API REQUEST                              │
│           {                                                    │
│             nhanVienId: 123,                                  │
│             gioVao: "2025-10-22T08:30:00",                   │
│             viDo: "10.762622",                                │
│             kinhDo: "106.660172",                             │
│             phuongThucVao: "SinhTracHoc"                      │
│           }                                                    │
└────────────────────────────┬──────────────────────────────────┘
                             │
                             │ POST /api/DiemDanh/diem-danh-vao
                             ▼
┌───────────────────────────────────────────────────────────────┐
│              5. BACKEND PROCESSES REQUEST                     │
│                                                                │
│  • Validate user exists                                       │
│  • Check if already checked in today                          │
│  • Save to database (DiemDanh table)                          │
│  • Log the action                                             │
└────────────────────────────┬──────────────────────────────────┘
                             │
                    ┌────────┴────────┐
                    │                 │
              ✅ Success         ❌ Error
                    │                 │
                    ▼                 ▼
          ┌──────────────┐    ┌──────────────┐
          │ Return 200   │    │ Return 400   │
          │   + Data     │    │  + Message   │
          └──────┬───────┘    └──────┬───────┘
                 │                   │
                 ▼                   ▼
┌───────────────────────────────────────────────────────────────┐
│              6. FLUTTER HANDLES RESPONSE                      │
│                                                                │
│  Success:                         Error:                      │
│  • Show success message           • Show error dialog         │
│  • Update UI state               • Allow retry                │
│  • Refresh attendance list        • Log error                 │
│  • Show check-out button                                      │
└───────────────────────────────────────────────────────────────┘
```

---

## 📊 Report Generation Flow

```
┌───────────────────────────────────────────────────────────────┐
│        1. ADMIN SELECTS REPORT TYPE (Week/Month/etc)         │
└────────────────────────────┬──────────────────────────────────┘
                             │
                             ▼
┌───────────────────────────────────────────────────────────────┐
│        2. FLUTTER APP CALLS API                               │
│        GET /api/BaoCao/tuan?nhanVienId=123&ngayBatDau=...    │
└────────────────────────────┬──────────────────────────────────┘
                             │
                             ▼
┌───────────────────────────────────────────────────────────────┐
│        3. BACKEND QUERIES DATABASE                            │
│                                                                │
│  SELECT * FROM DiemDanh                                       │
│  WHERE NhanVienId = @id                                       │
│    AND Ngay BETWEEN @start AND @end                           │
│  ORDER BY Ngay                                                │
└────────────────────────────┬──────────────────────────────────┘
                             │
                             ▼
┌───────────────────────────────────────────────────────────────┐
│        4. CALCULATE STATISTICS                                │
│                                                                │
│  • Total working days = COUNT(DISTINCT Ngay)                 │
│  • Total hours = SUM(GioRa - GioVao)                         │
│  • Average hours/day = Total hours / Working days            │
│  • Late arrivals = COUNT(GioVao > 08:00)                     │
│  • Early leaves = COUNT(GioRa < 17:00)                       │
│  • Attendance rate = (Working days / Total days) * 100       │
└────────────────────────────┬──────────────────────────────────┘
                             │
                             ▼
┌───────────────────────────────────────────────────────────────┐
│        5. BUILD RESPONSE DTO                                  │
│        {                                                       │
│          thanhCong: true,                                     │
│          danhSachDiemDanh: [...],                             │
│          thongKe: {                                           │
│            tongNgayLam: 20,                                   │
│            tongGioLam: 160,                                   │
│            soLanDiMuon: 2,                                    │
│            tyLeDiemDanh: 95.2                                 │
│          }                                                     │
│        }                                                       │
└────────────────────────────┬──────────────────────────────────┘
                             │
                             ▼
┌───────────────────────────────────────────────────────────────┐
│        6. FLUTTER DISPLAYS REPORT                             │
│                                                                │
│  • Show charts (fl_chart)                                     │
│  • Display statistics cards                                   │
│  • List attendance records                                    │
│  • Provide export/email options                               │
└───────────────────────────────────────────────────────────────┘
```

---

## 💰 Salary Calculation Flow

```
┌───────────────────────────────────────────────────────────────┐
│        1. ADMIN CLICKS "CALCULATE SALARY"                     │
│        • Select period (Week/Month)                           │
│        • Select employee (or all)                             │
└────────────────────────────┬──────────────────────────────────┘
                             │
                             ▼
┌───────────────────────────────────────────────────────────────┐
│        2. API CALL                                            │
│        POST /api/Luong/tinh-luong                             │
│        {                                                       │
│          nhanVienId: 123,                                     │
│          kyLuong: "Thang",                                    │
│          tuNgay: "2025-10-01",                                │
│          denNgay: "2025-10-31"                                │
│        }                                                       │
└────────────────────────────┬──────────────────────────────────┘
                             │
                             ▼
┌───────────────────────────────────────────────────────────────┐
│        3. GET EMPLOYEE INFO                                   │
│        SELECT LuongTheoGio FROM NhanVien WHERE Id = @id       │
└────────────────────────────┬──────────────────────────────────┘
                             │
                             ▼
┌───────────────────────────────────────────────────────────────┐
│        4. CALCULATE TOTAL HOURS                               │
│                                                                │
│  SELECT SUM(DATEDIFF(hour, GioVao, GioRa)) as TotalHours     │
│  FROM DiemDanh                                                │
│  WHERE NhanVienId = @id                                       │
│    AND Ngay BETWEEN @start AND @end                           │
│    AND GioVao IS NOT NULL                                     │
│    AND GioRa IS NOT NULL                                      │
└────────────────────────────┬──────────────────────────────────┘
                             │
                             ▼
┌───────────────────────────────────────────────────────────────┐
│        5. CALCULATE SALARY                                    │
│                                                                │
│  BaseSalary = TotalHours × HourlyRate                        │
│  FinalSalary = BaseSalary + Bonus - Deduction                │
│                                                                │
│  Example:                                                      │
│  • Total hours: 160 hours                                     │
│  • Hourly rate: 50,000 VND                                    │
│  • Base = 160 × 50,000 = 8,000,000 VND                       │
│  • Bonus = 500,000 VND                                        │
│  • Deduction = 0 VND                                          │
│  • Final = 8,500,000 VND                                      │
└────────────────────────────┬──────────────────────────────────┘
                             │
                             ▼
┌───────────────────────────────────────────────────────────────┐
│        6. SAVE TO DATABASE                                    │
│        INSERT INTO Luong (...)                                │
│        VALUES (nhanVienId, period, hours, amount, ...)        │
└────────────────────────────┬──────────────────────────────────┘
                             │
                             ▼
┌───────────────────────────────────────────────────────────────┐
│        7. RETURN RESULT & DISPLAY                             │
│        • Show salary breakdown                                │
│        • Allow adjustments (bonus/deduction)                  │
│        • Print/Export option                                  │
│        • Send email notification (optional)                   │
└───────────────────────────────────────────────────────────────┘
```

---

## 🔒 Security Layers

```
┌─────────────────────────────────────────────────────────────────┐
│                     SECURITY LAYERS                             │
├─────────────────────────────────────────────────────────────────┤
│                                                                   │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │  1. NETWORK LAYER                                         │  │
│  │     • HTTPS/TLS encryption                                │  │
│  │     • Certificate validation                              │  │
│  │     • Firewall rules                                      │  │
│  └───────────────────────────────────────────────────────────┘  │
│                            ▼                                     │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │  2. API GATEWAY                                           │  │
│  │     • CORS policy                                         │  │
│  │     • Rate limiting                                       │  │
│  │     • IP whitelisting (optional)                          │  │
│  └───────────────────────────────────────────────────────────┘  │
│                            ▼                                     │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │  3. AUTHENTICATION                                        │  │
│  │     • JWT token validation                                │  │
│  │     • Token expiry check (24 hours)                       │  │
│  │     • Biometric authentication                            │  │
│  └───────────────────────────────────────────────────────────┘  │
│                            ▼                                     │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │  4. AUTHORIZATION                                         │  │
│  │     • Role-based access control (Admin/Employee)          │  │
│  │     • Resource ownership validation                       │  │
│  │     • Permission checks                                   │  │
│  └───────────────────────────────────────────────────────────┘  │
│                            ▼                                     │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │  5. DATA VALIDATION                                       │  │
│  │     • Input sanitization                                  │  │
│  │     • Data type validation                                │  │
│  │     • Business rule validation                            │  │
│  └───────────────────────────────────────────────────────────┘  │
│                            ▼                                     │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │  6. DATABASE SECURITY                                     │  │
│  │     • Parameterized queries (SQL injection prevention)    │  │
│  │     • Password hashing (BCrypt)                           │  │
│  │     • Encrypted connections                               │  │
│  └───────────────────────────────────────────────────────────┘  │
│                            ▼                                     │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │  7. LOGGING & MONITORING                                  │  │
│  │     • Request/Response logging (Serilog)                  │  │
│  │     • Audit trail                                         │  │
│  │     • Error tracking                                      │  │
│  │     • Suspicious activity detection                       │  │
│  └───────────────────────────────────────────────────────────┘  │
│                                                                   │
└─────────────────────────────────────────────────────────────────┘
```

---

## 📦 Deployment Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                        PRODUCTION                                │
├─────────────────────────────────────────────────────────────────┤
│                                                                   │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │                    LOAD BALANCER                         │    │
│  │                   (Optional/Future)                      │    │
│  └───────────────────────┬─────────────────────────────────┘    │
│                          │                                       │
│         ┌────────────────┼────────────────┐                     │
│         │                │                │                     │
│  ┌──────▼─────┐   ┌──────▼─────┐   ┌─────▼──────┐             │
│  │  Web       │   │   Web      │   │    Web     │             │
│  │  Server 1  │   │ Server 2   │   │  Server 3  │             │
│  │            │   │            │   │            │             │
│  │ • IIS/     │   │ • IIS/     │   │ • IIS/     │             │
│  │   Nginx    │   │   Nginx    │   │   Nginx    │             │
│  │ • .NET App │   │ • .NET App │   │ • .NET App │             │
│  │ • HTTPS    │   │ • HTTPS    │   │ • HTTPS    │             │
│  └────────────┘   └────────────┘   └────────────┘             │
│         │                │                │                     │
│         └────────────────┼────────────────┘                     │
│                          │                                       │
│                   ┌──────▼─────────┐                            │
│                   │   DATABASE     │                            │
│                   │   SQL Server   │                            │
│                   │                │                            │
│                   │ • Primary      │                            │
│                   │ • Replica      │                            │
│                   │   (Read-only)  │                            │
│                   └────────────────┘                            │
│                                                                   │
│  ┌──────────────┐   ┌──────────────┐   ┌──────────────┐        │
│  │    SMTP      │   │   Firebase   │   │   Hangfire   │        │
│  │   Server     │   │     FCM      │   │   Dashboard  │        │
│  └──────────────┘   └──────────────┘   └──────────────┘        │
│                                                                   │
│  ┌────────────────────────────────────────────────────────┐     │
│  │              MONITORING & LOGGING                       │     │
│  │  • Application Insights / ELK Stack                     │     │
│  │  • Health checks                                        │     │
│  │  • Performance metrics                                  │     │
│  └────────────────────────────────────────────────────────┘     │
│                                                                   │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│                          CLIENTS                                 │
├─────────────────────────────────────────────────────────────────┤
│                                                                   │
│  ┌─────────────┐   ┌─────────────┐   ┌─────────────┐           │
│  │  Android    │   │     iOS     │   │  Web Admin  │           │
│  │   Devices   │   │   Devices   │   │   (Future)  │           │
│  └─────────────┘   └─────────────┘   └─────────────┘           │
│                                                                   │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🎯 Data Flow Summary

1. **User Action** → Flutter UI
2. **BLoC Event** → State Management
3. **Service Call** → Business Logic
4. **HTTP Request** → API Gateway
5. **Controller** → Request Handling
6. **Service Layer** → Business Rules
7. **Entity Framework** → Data Access
8. **SQL Server** → Data Storage
9. **Response** → Back through layers
10. **UI Update** → Display to User

---

## 📊 Key Design Patterns

- **Backend**: Repository Pattern, Dependency Injection, Clean Architecture
- **Flutter**: BLoC Pattern, Service Layer, Repository Pattern
- **Security**: JWT Bearer Token, BCrypt Hashing
- **API**: RESTful, Stateless, JSON
- **Database**: Entity Framework Code-First, Migrations

---

**📅 Last Updated**: 22/10/2025  
**👨‍💻 Architect**: NHViet Development Team

