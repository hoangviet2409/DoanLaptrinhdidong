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
  Future<DangKyResponse> taoTaiKhoanNhanVien(DangKyRequest request) async {
    try {
      // Lấy token từ AuthService
      final token = await _authService.getCurrentToken();
      if (token == null) {
        throw Exception('Chưa đăng nhập');
      }
      
      // Set token cho API service
      _apiService.setToken(token);
      
      final response = await _apiService.post(
        AppConstants.registerAdminEndpoint, // Admin có thể tạo nhân viên qua endpoint này
        data: request.toJson(),
      );
      return DangKyResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Tạo tài khoản nhân viên thất bại: ${e.toString()}');
    }
  }
}
