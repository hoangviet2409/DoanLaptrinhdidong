import '../models/luong_response.dart';
import 'api_service.dart';

class LuongService {
  final ApiService _apiService;

  LuongService(this._apiService);

  // Lấy lịch sử lương cá nhân (cho nhân viên)
  Future<LuongResponse> layLichSuLuongCaNhan() async {
    try {
      final response = await _apiService.get('/Luong/lich-su-ca-nhan');
      return LuongResponse.fromJson(response.data);
    } catch (e) {
      return LuongResponse(
        thanhCong: false,
        thongBao: 'Lỗi: ${e.toString()}',
        danhSachLuong: [],
      );
    }
  }

  // Lấy danh sách lương theo nhân viên (cho admin)
  Future<LuongResponse> layDanhSachLuongTheoNhanVien(int nhanVienId) async {
    try {
      final response = await _apiService.get('/Luong/lich-su/$nhanVienId');
      return LuongResponse.fromJson(response.data);
    } catch (e) {
      return LuongResponse(
        thanhCong: false,
        thongBao: 'Lỗi: ${e.toString()}',
        danhSachLuong: [],
      );
    }
  }

  // Tính lương cho nhân viên (admin)
  Future<LuongResponse> tinhLuong(Map<String, dynamic> request) async {
    try {
      final response = await _apiService.post('/Luong/tinh-luong', data: request);
      return LuongResponse.fromJson(response.data);
    } catch (e) {
      return LuongResponse(
        thanhCong: false,
        thongBao: 'Lỗi: ${e.toString()}',
        danhSachLuong: [],
      );
    }
  }

  // Cập nhật lương (admin)
  Future<Map<String, dynamic>> capNhatLuong(int id, Map<String, dynamic> request) async {
    try {
      final response = await _apiService.put('/Luong/$id', data: request);
      return {
        'thanhCong': true,
        'thongBao': 'Cập nhật lương thành công',
        'data': response.data,
      };
    } catch (e) {
      return {
        'thanhCong': false,
        'thongBao': 'Lỗi: ${e.toString()}',
      };
    }
  }

  // Xóa lương (admin)
  Future<bool> xoaLuong(int id) async {
    try {
      await _apiService.delete('/Luong/$id');
      return true;
    } catch (e) {
      return false;
    }
  }
}

