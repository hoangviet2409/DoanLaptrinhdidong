import 'package:shared_preferences/shared_preferences.dart';
import '../config/constants.dart';
import '../models/dang_nhap_request.dart';
import '../models/dang_nhap_response.dart';
import '../models/dang_ky_request.dart';
import '../models/dang_ky_response.dart';
import '../models/user_model.dart';
import 'api_service.dart';

class AuthService {
  final ApiService _apiService;
  final SharedPreferences _prefs;

  AuthService(this._apiService, this._prefs);

  // Đăng nhập Admin
  Future<UserModel> dangNhapQuanTri(DangNhapRequest request) async {
    try {
      final response = await _apiService.post(
        AppConstants.loginAdminEndpoint,
        data: request.toJson(),
      );

      final dangNhapResponse = DangNhapResponse.fromJson(response.data);

      if (!dangNhapResponse.thanhCong || dangNhapResponse.token == null) {
        throw Exception(dangNhapResponse.thongBao);
      }

      final user = UserModel(
        token: dangNhapResponse.token!,
        vaiTro: dangNhapResponse.vaiTro!,
        nhanVienId: dangNhapResponse.nhanVienId,
        hoTen: dangNhapResponse.hoTen!,
      );

      // Lưu thông tin user
      await _saveUserInfo(user);
      
      // Set token cho API service
      _apiService.setToken(user.token);

      return user;
    } catch (e) {
      throw Exception('Đăng nhập thất bại: ${e.toString()}');
    }
  }

  // Đăng nhập Nhân viên
  Future<UserModel> dangNhapNhanVien(DangNhapNhanVienRequest request) async {
    try {
      final response = await _apiService.post(
        AppConstants.loginEmployeeEndpoint,
        data: request.toJson(),
      );

      final dangNhapResponse = DangNhapResponse.fromJson(response.data);

      if (!dangNhapResponse.thanhCong || dangNhapResponse.token == null) {
        throw Exception(dangNhapResponse.thongBao);
      }

      final user = UserModel(
        token: dangNhapResponse.token!,
        vaiTro: dangNhapResponse.vaiTro!,
        nhanVienId: dangNhapResponse.nhanVienId,
        hoTen: dangNhapResponse.hoTen!,
      );

      // Lưu thông tin user
      await _saveUserInfo(user);
      await _prefs.setString(AppConstants.biometricIdKey, request.matKhau);
      await _prefs.setString(AppConstants.maNhanVienKey, request.maNhanVien);
      
      // Set token cho API service
      _apiService.setToken(user.token);

      return user;
    } catch (e) {
      throw Exception('Đăng nhập thất bại: ${e.toString()}');
    }
  }

  // Xác thực sinh trắc học
  Future<UserModel> xacThucSinhTracHoc(DangNhapNhanVienRequest request) async {
    try {
      final response = await _apiService.post(
        AppConstants.verifyBiometricEndpoint,
        data: request.toJson(),
      );

      final dangNhapResponse = DangNhapResponse.fromJson(response.data);

      if (!dangNhapResponse.thanhCong || dangNhapResponse.token == null) {
        throw Exception(dangNhapResponse.thongBao);
      }

      final user = UserModel(
        token: dangNhapResponse.token!,
        vaiTro: dangNhapResponse.vaiTro!,
        nhanVienId: dangNhapResponse.nhanVienId,
        hoTen: dangNhapResponse.hoTen!,
      );

      // Lưu thông tin user
      await _saveUserInfo(user);
      
      // Set token cho API service
      _apiService.setToken(user.token);

      return user;
    } catch (e) {
      throw Exception('Xác thực thất bại: ${e.toString()}');
    }
  }

  // Lưu thông tin user vào SharedPreferences
  Future<void> _saveUserInfo(UserModel user) async {
    await _prefs.setString(AppConstants.tokenKey, user.token);
    await _prefs.setString(AppConstants.userRoleKey, user.vaiTro);
    await _prefs.setString(AppConstants.userNameKey, user.hoTen);
    if (user.nhanVienId != null) {
      await _prefs.setInt(AppConstants.userIdKey, user.nhanVienId!);
    }
  }

  // Lấy user từ SharedPreferences
  Future<UserModel?> getUserFromStorage() async {
    final token = _prefs.getString(AppConstants.tokenKey);
    if (token == null) return null;

    final vaiTro = _prefs.getString(AppConstants.userRoleKey);
    final hoTen = _prefs.getString(AppConstants.userNameKey);
    final nhanVienId = _prefs.getInt(AppConstants.userIdKey);

    if (vaiTro == null || hoTen == null) return null;

    // Set token cho API service
    _apiService.setToken(token);

    return UserModel(
      token: token,
      vaiTro: vaiTro,
      nhanVienId: nhanVienId,
      hoTen: hoTen,
    );
  }

  // Đăng xuất
  Future<void> dangXuat() async {
    await _prefs.remove(AppConstants.tokenKey);
    await _prefs.remove(AppConstants.userRoleKey);
    await _prefs.remove(AppConstants.userIdKey);
    await _prefs.remove(AppConstants.userNameKey);
    await _prefs.remove(AppConstants.maNhanVienKey);
    await _prefs.remove(AppConstants.biometricIdKey);
    
    // Remove token từ API service
    _apiService.removeToken();
  }


  // Đăng ký Admin/Quản lý (Chỉ Admin mới có thể gọi)
  Future<UserModel> dangKyAdmin(DangKyRequest request) async {
    try {
      final response = await _apiService.post(
        AppConstants.registerAdminEndpoint,
        data: request.toJson(),
      );

      final dangKyResponse = DangKyResponse.fromJson(response.data);

      if (!dangKyResponse.thanhCong || dangKyResponse.token == null) {
        throw Exception(dangKyResponse.thongBao);
      }

      final user = UserModel(
        token: dangKyResponse.token!,
        vaiTro: dangKyResponse.vaiTro!,
        nhanVienId: dangKyResponse.id,
        hoTen: dangKyResponse.hoTen!,
      );

      // Lưu thông tin user
      await _saveUserInfo(user);
      
      // Set token cho API service
      _apiService.setToken(user.token);

      return user;
    } catch (e) {
      throw Exception('Đăng ký thất bại: ${e.toString()}');
    }
  }

  // Kiểm tra đã đăng nhập chưa
  Future<bool> isLoggedIn() async {
    final token = _prefs.getString(AppConstants.tokenKey);
    return token != null;
  }

  // Lấy token hiện tại
  Future<String?> getCurrentToken() async {
    return _prefs.getString(AppConstants.tokenKey);
  }

  // Đăng ký Nhân viên
  Future<UserModel> dangKyNhanVien(DangKyNhanVienRequest request) async {
    try {
      final response = await _apiService.post(
        AppConstants.registerEndpoint,
        data: request.toJson(),
      );

      final dangKyResponse = DangKyResponse.fromJson(response.data);

      if (!dangKyResponse.thanhCong || dangKyResponse.token == null) {
        throw Exception(dangKyResponse.thongBao);
      }

      final user = UserModel(
        token: dangKyResponse.token!,
        vaiTro: dangKyResponse.vaiTro!,
        hoTen: dangKyResponse.hoTen ?? '',
        nhanVienId: dangKyResponse.id ?? 0,
      );

      await _saveUserInfo(user);
      return user;
    } catch (e) {
      throw Exception('Lỗi đăng ký nhân viên: ${e.toString()}');
    }
  }
}

