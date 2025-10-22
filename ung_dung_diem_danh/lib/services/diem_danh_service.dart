import 'package:equatable/equatable.dart';
import '../models/diem_danh_request.dart';
import '../models/diem_danh_response.dart';
import '../models/admin_dashboard_response.dart';
import 'api_service.dart';

class DiemDanhService {
  final ApiService _apiService;

  DiemDanhService(this._apiService);

  /// Điểm danh vào
  Future<DiemDanhResponse> diemDanhVao(DiemDanhVaoRequest request) async {
    try {
      final response = await _apiService.post(
        '/DiemDanh/diem-danh-vao',
        data: request.toJson(),
      );
      
      if (response.statusCode == 200) {
        return DiemDanhResponse.fromJson(response.data);
      } else {
        throw Exception('Lỗi khi điểm danh vào: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Lỗi kết nối khi điểm danh vào: $e');
    }
  }

  /// Điểm danh ra
  Future<DiemDanhResponse> diemDanhRa(DiemDanhRaRequest request) async {
    try {
      final response = await _apiService.post(
        '/DiemDanh/diem-danh-ra',
        data: request.toJson(),
      );
      
      if (response.statusCode == 200) {
        return DiemDanhResponse.fromJson(response.data);
      } else {
        throw Exception('Lỗi khi điểm danh ra: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Lỗi kết nối khi điểm danh ra: $e');
    }
  }

  /// Điểm danh bằng thẻ NFC (toggle vào/ra)
  Future<DiemDanhResponse> diemDanhNfc({required String maTheNfc, double? viDo, double? kinhDo, String? ghiChu}) async {
    try {
      final response = await _apiService.post(
        '/DiemDanh/diem-danh-nfc',
        data: {
          'maTheNfc': maTheNfc,
          if (viDo != null) 'viDo': viDo,
          if (kinhDo != null) 'kinhDo': kinhDo,
          if (ghiChu != null) 'ghiChu': ghiChu,
        },
      );
      if (response.statusCode == 200) {
        return DiemDanhResponse.fromJson(response.data);
      } else {
        throw Exception('Lỗi khi điểm danh NFC: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Lỗi kết nối khi điểm danh NFC: $e');
    }
  }

  /// Chấm công thủ công (Admin only)
  Future<DiemDanhResponse> chamCongThuCong(dynamic request) async {
    try {
      final response = await _apiService.post(
        '/DiemDanh/cham-cong-thu-cong',
        data: request is Map ? request : request.toJson(),
      );
      
      if (response.statusCode == 200) {
        return DiemDanhResponse.fromJson(response.data);
      } else {
        throw Exception('Lỗi khi chấm công thủ công: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Lỗi kết nối khi chấm công thủ công: $e');
    }
  }

  /// Lấy lịch sử điểm danh theo ID nhân viên
  Future<LichSuDiemDanhResponse> layLichSuDiemDanh(
    int nhanVienId, {
    DateTime? tuNgay,
    DateTime? denNgay,
  }) async {
    try {
      String url = '/DiemDanh/lich-su/$nhanVienId';
      
      // Thêm query parameters nếu có
      Map<String, dynamic> queryParams = {};
      if (tuNgay != null) {
        queryParams['tuNgay'] = tuNgay.toIso8601String();
      }
      if (denNgay != null) {
        queryParams['denNgay'] = denNgay.toIso8601String();
      }

      final response = await _apiService.get(url, queryParameters: queryParams);
      
      if (response.statusCode == 200) {
        return LichSuDiemDanhResponse.fromJson(response.data);
      } else {
        throw Exception('Lỗi khi lấy lịch sử điểm danh: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Lỗi kết nối khi lấy lịch sử điểm danh: $e');
    }
  }

  /// Lấy lịch sử điểm danh theo mã nhân viên
  Future<LichSuDiemDanhResponse> layLichSuDiemDanhTheoMa(
    String maNhanVien, {
    DateTime? tuNgay,
    DateTime? denNgay,
  }) async {
    try {
      String url = '/DiemDanh/lich-su-ma/$maNhanVien';
      
      // Thêm query parameters nếu có
      Map<String, dynamic> queryParams = {};
      if (tuNgay != null) {
        queryParams['tuNgay'] = tuNgay.toIso8601String();
      }
      if (denNgay != null) {
        queryParams['denNgay'] = denNgay.toIso8601String();
      }

      final response = await _apiService.get(url, queryParameters: queryParams);
      
      if (response.statusCode == 200) {
        return LichSuDiemDanhResponse.fromJson(response.data);
      } else {
        throw Exception('Lỗi khi lấy lịch sử điểm danh: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Lỗi kết nối khi lấy lịch sử điểm danh: $e');
    }
  }

  /// Lấy thông tin điểm danh hiện tại theo ID nhân viên
  Future<DiemDanhDto?> layDiemDanhHienTai(int nhanVienId) async {
    try {
      final response = await _apiService.get('/DiemDanh/hien-tai/$nhanVienId');
      
      if (response.statusCode == 200) {
        return DiemDanhDto.fromJson(response.data);
      } else if (response.statusCode == 404) {
        return null; // Chưa có điểm danh hôm nay
      } else {
        throw Exception('Lỗi khi lấy thông tin điểm danh hiện tại: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Lỗi kết nối khi lấy thông tin điểm danh hiện tại: $e');
    }
  }

  /// Lấy thông tin điểm danh hiện tại theo mã nhân viên (Admin/Manager only)
  Future<DiemDanhDto?> layDiemDanhHienTaiTheoMa(String maNhanVien) async {
    try {
      final response = await _apiService.get('/DiemDanh/hien-tai-ma/$maNhanVien');
      
      if (response.statusCode == 200) {
        return DiemDanhDto.fromJson(response.data);
      } else if (response.statusCode == 404) {
        return null; // Chưa có điểm danh hôm nay
      } else {
        throw Exception('Lỗi khi lấy thông tin điểm danh hiện tại: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Lỗi kết nối khi lấy thông tin điểm danh hiện tại: $e');
    }
  }

  /// Lấy thông tin điểm danh hiện tại của nhân viên (cho chính nhân viên đó)
  Future<DiemDanhDto?> layDiemDanhHienTaiCaNhan() async {
    try {
      final response = await _apiService.get('/DiemDanh/hien-tai-ca-nhan');
      
      if (response.statusCode == 200) {
        return DiemDanhDto.fromJson(response.data);
      } else if (response.statusCode == 404) {
        return null; // Chưa có điểm danh hôm nay
      } else {
        throw Exception('Lỗi khi lấy thông tin điểm danh hiện tại: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Lỗi kết nối khi lấy thông tin điểm danh hiện tại: $e');
    }
  }

  /// Lấy lịch sử điểm danh cá nhân (cho chính nhân viên đó)
  Future<LichSuDiemDanhResponse> layLichSuDiemDanhCaNhan({
    DateTime? tuNgay,
    DateTime? denNgay,
  }) async {
    try {
      String url = '/DiemDanh/lich-su-ca-nhan';
      
      // Thêm query parameters nếu có
      Map<String, dynamic> queryParams = {};
      if (tuNgay != null) {
        queryParams['tuNgay'] = tuNgay.toIso8601String();
      }
      if (denNgay != null) {
        queryParams['denNgay'] = denNgay.toIso8601String();
      }

      final response = await _apiService.get(url, queryParameters: queryParams);
      
      if (response.statusCode == 200) {
        return LichSuDiemDanhResponse.fromJson(response.data);
      } else {
        throw Exception('Lỗi khi lấy lịch sử điểm danh: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Lỗi kết nối khi lấy lịch sử điểm danh: $e');
    }
  }

  /// Xóa bản ghi điểm danh (Admin only)
  Future<bool> xoaDiemDanh(int id) async {
    try {
      final response = await _apiService.delete('/DiemDanh/$id');
      
      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Lỗi kết nối khi xóa bản ghi điểm danh: $e');
    }
  }

  /// Lấy thống kê điểm danh cá nhân
  Future<ThongKeDiemDanhResponse> layThongKeDiemDanhCaNhan() async {
    try {
      final response = await _apiService.get('/DiemDanh/thong-ke-ca-nhan');
      
      if (response.statusCode == 200) {
        return ThongKeDiemDanhResponse.fromJson(response.data);
      } else {
        throw Exception('Lỗi khi lấy thống kê điểm danh: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Lỗi kết nối khi lấy thống kê điểm danh: $e');
    }
  }

  /// Lấy thông tin dashboard admin
  Future<AdminDashboardResponse> layThongTinDashboardAdmin() async {
    try {
      final response = await _apiService.get('/DiemDanh/dashboard-admin');
      
      if (response.statusCode == 200) {
        return AdminDashboardResponse.fromJson(response.data);
      } else {
        throw Exception('Lỗi khi lấy thông tin dashboard: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Lỗi kết nối khi lấy thông tin dashboard: $e');
    }
  }
}

class ThongKeDiemDanhResponse extends Equatable {
  final bool thanhCong;
  final String thongBao;
  final int ngayLamViecTrongThang;
  final double tongGioLamTrongThang;
  final double gioLamTrungBinh;
  final int ngayLamViecTrongTuan;
  final double tongGioLamTrongTuan;

  const ThongKeDiemDanhResponse({
    required this.thanhCong,
    required this.thongBao,
    required this.ngayLamViecTrongThang,
    required this.tongGioLamTrongThang,
    required this.gioLamTrungBinh,
    required this.ngayLamViecTrongTuan,
    required this.tongGioLamTrongTuan,
  });

  factory ThongKeDiemDanhResponse.fromJson(Map<String, dynamic> json) {
    return ThongKeDiemDanhResponse(
      thanhCong: json['thanhCong'] ?? false,
      thongBao: json['thongBao'] ?? '',
      ngayLamViecTrongThang: json['ngayLamViecTrongThang'] ?? 0,
      tongGioLamTrongThang: (json['tongGioLamTrongThang'] ?? 0).toDouble(),
      gioLamTrungBinh: (json['gioLamTrungBinh'] ?? 0).toDouble(),
      ngayLamViecTrongTuan: json['ngayLamViecTrongTuan'] ?? 0,
      tongGioLamTrongTuan: (json['tongGioLamTrongTuan'] ?? 0).toDouble(),
    );
  }

  @override
  List<Object?> get props => [
    thanhCong,
    thongBao,
    ngayLamViecTrongThang,
    tongGioLamTrongThang,
    gioLamTrungBinh,
    ngayLamViecTrongTuan,
    tongGioLamTrongTuan,
  ];
}
