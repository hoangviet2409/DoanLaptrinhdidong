import 'package:dio/dio.dart';
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
        return DangKyResponse(
          thanhCong: false,
          thongBao: 'Chưa đăng nhập',
        );
      }
      
      // Set token cho API service
      _apiService.setToken(token);
      
      final response = await _apiService.post(
        AppConstants.registerAdminEndpoint,
        data: request.toJson(),
      );

      return DangKyResponse.fromJson(response.data);
    } on DioException catch (e) {
      // Parse error response từ backend
      if (e.response?.data != null) {
        print('🔴 ERROR RESPONSE DATA: ${e.response!.data}');
        print('🔴 ERROR RESPONSE TYPE: ${e.response!.data.runtimeType}');
        
        if (e.response!.data is Map) {
          final errorData = e.response!.data as Map<String, dynamic>;
          
          // Kiểm tra ModelState errors từ ASP.NET
          if (errorData.containsKey('errors')) {
            final errors = errorData['errors'] as Map<String, dynamic>;
            final errorMessages = errors.values
                .expand((e) => e as List)
                .join(', ');
            return DangKyResponse(
              thanhCong: false,
              thongBao: errorMessages,
            );
          }
          
          return DangKyResponse(
            thanhCong: false,
            thongBao: errorData['thongBao'] ?? errorData['message'] ?? errorData['title'] ?? 'Tạo tài khoản thất bại',
          );
        }
      }
      return DangKyResponse(
        thanhCong: false,
        thongBao: 'Tạo tài khoản thất bại: ${e.message}',
      );
    } catch (e) {
      return DangKyResponse(
        thanhCong: false,
        thongBao: 'Lỗi không xác định: ${e.toString()}',
      );
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
