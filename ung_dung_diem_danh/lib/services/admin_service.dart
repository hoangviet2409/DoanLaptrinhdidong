import '../config/constants.dart';
import '../models/dang_ky_request.dart';
import '../models/dang_ky_response.dart';
import 'api_service.dart';
import 'auth_service.dart';

class AdminService {
  final ApiService _apiService;
  final AuthService _authService;

  AdminService(this._apiService, this._authService);

  // Tạo tài khoản Admin/Quản lý (không cần đăng nhập lại)
  Future<DangKyResponse> taoTaiKhoanAdmin(DangKyRequest request) async {
    try {
      // Lấy token từ AuthService
      final token = await _authService.getCurrentToken();
      if (token == null) {
        throw Exception('Chưa đăng nhập');
      }
      
      // Set token cho API service
      _apiService.setToken(token);
      
      final response = await _apiService.post(
        AppConstants.registerAdminEndpoint,
        data: request.toJson(),
      );

      return DangKyResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Tạo tài khoản thất bại: ${e.toString()}');
    }
  }

  // Tạo tài khoản Nhân viên
  Future<DangKyResponse> taoTaiKhoanNhanVien(DangKyNhanVienRequest request) async {
    try {
      // Lấy token từ AuthService
      final token = await _authService.getCurrentToken();
      if (token == null) {
        throw Exception('Chưa đăng nhập');
      }
      
      // Set token cho API service
      _apiService.setToken(token);
      
      // Tạo NhanVien object từ request
      final nhanVienData = {
        'maNhanVien': request.maNhanVien,
        'hoTen': request.hoTen,
        'email': request.email,
        'soDienThoai': request.soDienThoai,
        'matKhauHash': request.matKhau,
        'phongBan': request.phongBan,
        'chucVu': request.chucVu,
        'luongGio': request.luongGio,
        'trangThai': 'HoatDong',
      };
      
      final response = await _apiService.post(
        AppConstants.employeesEndpoint, // Sử dụng endpoint từ constants
        data: nhanVienData,
      );
      
      // Debug: In ra response để kiểm tra
      print('Full URL: ${AppConstants.baseUrl}${AppConstants.employeesEndpoint}');
      print('Response data: ${response.data}');
      print('Response status: ${response.statusCode}');
      print('Response headers: ${response.headers}');
      
      return DangKyResponse(
        thanhCong: true,
        thongBao: 'Tạo nhân viên thành công',
        id: response.data?['id'] ?? 0,
        tenDangNhap: response.data?['maNhanVien'] ?? request.maNhanVien,
        hoTen: response.data?['hoTen'] ?? request.hoTen,
        email: response.data?['email'] ?? request.email,
      );
    } catch (e) {
      return DangKyResponse(
        thanhCong: false,
        thongBao: 'Tạo tài khoản nhân viên thất bại: ${e.toString()}',
      );
    }
  }
}
