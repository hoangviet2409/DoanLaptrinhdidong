class AppConstants {
  // API Configuration
  static const String baseUrl = 'https://10.0.2.2:7000/api';
  
  // Endpoints
  static const String loginAdminEndpoint = '/XacThuc/dang-nhap-quan-tri';
  static const String loginEmployeeEndpoint = '/XacThuc/dang-nhap-nhan-vien';
  static const String verifyBiometricEndpoint = '/XacThuc/xac-thuc-sinh-trac-hoc';
  
  // Registration Endpoints
  static const String registerAdminEndpoint = '/XacThuc/dang-ky-admin'; // Admin only
  static const String registerEndpoint = '/XacThuc/dang-ky'; // Public registration
  
  static const String employeesEndpoint = '/NhanVien';
  static const String attendanceCheckInEndpoint = '/DiemDanh/diem-danh-vao';
  static const String attendanceCheckOutEndpoint = '/DiemDanh/diem-danh-ra';
  static const String attendanceHistoryEndpoint = '/DiemDanh/lich-su-ca-nhan';
  
  // Report Endpoints
  static const String reportWeekEndpoint = '/BaoCao/tuan';
  static const String reportMonthEndpoint = '/BaoCao/thang';
  static const String reportQuarterEndpoint = '/BaoCao/quy';
  static const String reportYearEndpoint = '/BaoCao/nam';
  static const String reportPersonalWeekEndpoint = '/BaoCao/ca-nhan/tuan';
  static const String reportSendEmailEndpoint = '/BaoCao/gui-email';
  
  // Salary Endpoints
  static const String salaryCalculateEndpoint = '/Luong/tinh-luong';
  static const String salaryHistoryEndpoint = '/Luong/lich-su';
  static const String salaryPersonalHistoryEndpoint = '/Luong/lich-su-ca-nhan';
  static const String salaryUpdateEndpoint = '/Luong';
  static const String salaryCreateMonthlyEndpoint = '/Luong/tao-bang-luong-thang';
  
  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userRoleKey = 'user_role';
  static const String userIdKey = 'user_id';
  static const String userNameKey = 'user_name';
  static const String biometricIdKey = 'biometric_id';
  static const String maNhanVienKey = 'ma_nhan_vien';
  
  // App Settings
  static const int requestTimeout = 60000; // 60 seconds
  
  // User Roles
  static const String roleAdmin = 'Admin';
  static const String roleEmployee = 'NhanVien';
  static const String roleManager = 'QuanLy';
}

