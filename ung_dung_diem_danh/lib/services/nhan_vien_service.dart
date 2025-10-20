import 'dart:convert';
import 'package:dio/dio.dart';
import '../config/constants.dart';
import '../models/nhan_vien_model.dart';
import 'api_service.dart';

class NhanVienService {
  final ApiService _apiService;

  NhanVienService(this._apiService);

  /// Lấy danh sách tất cả nhân viên
  Future<List<NhanVienModel>> layDanhSachNhanVien() async {
    try {
      final response = await _apiService.get(AppConstants.employeesEndpoint);
      
      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> data = response.data;
        return data.map((json) => NhanVienModel.fromJson(json)).toList();
      } else {
        throw Exception('Không thể lấy danh sách nhân viên');
      }
    } catch (e) {
      throw Exception('Lỗi khi lấy danh sách nhân viên: ${e.toString()}');
    }
  }

  /// Lấy thông tin nhân viên theo ID
  Future<NhanVienModel?> layNhanVienTheoId(int id) async {
    try {
      final response = await _apiService.get('${AppConstants.employeesEndpoint}/$id');
      
      if (response.statusCode == 200 && response.data != null) {
        return NhanVienModel.fromJson(response.data);
      } else {
        return null;
      }
    } catch (e) {
      throw Exception('Lỗi khi lấy thông tin nhân viên: ${e.toString()}');
    }
  }

  /// Lấy thông tin nhân viên theo mã nhân viên
  Future<NhanVienModel?> layNhanVienTheoMa(String maNhanVien) async {
    try {
      final response = await _apiService.get('${AppConstants.employeesEndpoint}/ma/$maNhanVien');
      
      if (response.statusCode == 200 && response.data != null) {
        return NhanVienModel.fromJson(response.data);
      } else {
        return null;
      }
    } catch (e) {
      throw Exception('Lỗi khi lấy thông tin nhân viên: ${e.toString()}');
    }
  }

  /// Cập nhật trạng thái nhân viên
  Future<bool> capNhatTrangThai(int id, String trangThai) async {
    try {
      final response = await _apiService.put(
        '${AppConstants.employeesEndpoint}/$id/trang-thai',
        data: jsonEncode(trangThai),
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );
      
      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Lỗi khi cập nhật trạng thái nhân viên: ${e.toString()}');
    }
  }

  /// Đăng ký sinh trắc học cho nhân viên
  Future<bool> dangKySinhTracHoc(int id, String maSinhTracHoc) async {
    try {
      final response = await _apiService.put(
        '${AppConstants.employeesEndpoint}/$id/dang-ky-sinh-trac-hoc',
        data: maSinhTracHoc,
      );
      
      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Lỗi khi đăng ký sinh trắc học: ${e.toString()}');
    }
  }
}
