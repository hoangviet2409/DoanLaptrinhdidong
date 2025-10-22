import 'package:ung_dung_diem_danh/config/constants.dart';
import 'package:ung_dung_diem_danh/models/bao_cao_response.dart';
import 'package:ung_dung_diem_danh/services/api_service.dart';

class BaoCaoService {
  final ApiService _apiService;

  BaoCaoService(this._apiService);

  Future<BaoCaoResponse> layBaoCaoTuan({int? nhanVienId, required DateTime ngayBatDau}) async {
    try {
      final response = await _apiService.get(
        AppConstants.reportWeekEndpoint,
        queryParameters: {
          'nhanVienId': nhanVienId,
          'ngayBatDau': ngayBatDau.toIso8601String().split('T')[0],
        },
      );
      return BaoCaoResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Lấy báo cáo tuần thất bại: ${e.toString()}');
    }
  }

  Future<BaoCaoResponse> getReportWeek(int? nhanVienId, DateTime ngayBatDau) async {
    try {
      final response = await _apiService.get(
        AppConstants.reportWeekEndpoint,
        queryParameters: {
          'nhanVienId': nhanVienId,
          'ngayBatDau': ngayBatDau.toIso8601String(),
        },
      );
      return BaoCaoResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Lấy báo cáo tuần thất bại: $e');
    }
  }

  Future<BaoCaoResponse> layBaoCaoThang({int? nhanVienId, required int thang, required int nam}) async {
    try {
      final response = await _apiService.get(
        AppConstants.reportMonthEndpoint,
        queryParameters: {
          'nhanVienId': nhanVienId,
          'thang': thang,
          'nam': nam,
        },
      );
      return BaoCaoResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Lấy báo cáo tháng thất bại: ${e.toString()}');
    }
  }

  Future<BaoCaoResponse> getReportMonth(int? nhanVienId, int thang, int nam) async {
    try {
      final response = await _apiService.get(
        AppConstants.reportMonthEndpoint,
        queryParameters: {
          'nhanVienId': nhanVienId,
          'thang': thang,
          'nam': nam,
        },
      );
      return BaoCaoResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Lấy báo cáo tháng thất bại: $e');
    }
  }

  Future<BaoCaoResponse> layBaoCaoQuy({int? nhanVienId, required int quy, required int nam}) async {
    try {
      final response = await _apiService.get(
        AppConstants.reportQuarterEndpoint,
        queryParameters: {
          'nhanVienId': nhanVienId,
          'quy': quy,
          'nam': nam,
        },
      );
      return BaoCaoResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Lấy báo cáo quý thất bại: ${e.toString()}');
    }
  }

  Future<BaoCaoResponse> getReportQuarter(int? nhanVienId, int quy, int nam) async {
    try {
      final response = await _apiService.get(
        AppConstants.reportQuarterEndpoint,
        queryParameters: {
          'nhanVienId': nhanVienId,
          'quy': quy,
          'nam': nam,
        },
      );
      return BaoCaoResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Lấy báo cáo quý thất bại: $e');
    }
  }

  Future<BaoCaoResponse> layBaoCaoNam({int? nhanVienId, required int nam}) async {
    try {
      final response = await _apiService.get(
        AppConstants.reportYearEndpoint,
        queryParameters: {
          'nhanVienId': nhanVienId,
          'nam': nam,
        },
      );
      return BaoCaoResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Lấy báo cáo năm thất bại: ${e.toString()}');
    }
  }

  Future<BaoCaoResponse> getReportYear(int? nhanVienId, int nam) async {
    try {
      final response = await _apiService.get(
        AppConstants.reportYearEndpoint,
        queryParameters: {
          'nhanVienId': nhanVienId,
          'nam': nam,
        },
      );
      return BaoCaoResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Lấy báo cáo năm thất bại: $e');
    }
  }

  Future<void> sendReportEmail(String email, String loaiBaoCao, int? nhanVienId, DateTime? ngayBatDau, int? thang, int? nam, int? quy) async {
    try {
      final data = {
        'email': email,
        'loaiBaoCao': loaiBaoCao,
        'nhanVienId': nhanVienId,
        'ngayBatDau': ngayBatDau?.toIso8601String(),
        'thang': thang,
        'nam': nam,
        'quy': quy,
      };
      await _apiService.post(
        AppConstants.reportSendEmailEndpoint,
        data: data,
      );
    } catch (e) {
      throw Exception('Gửi email báo cáo thất bại: $e');
    }
  }

  /// Gửi email báo cáo đơn giản (backend tự xử lý chi tiết)
  Future<bool> guiEmailBaoCao(int nhanVienId, String loaiBaoCao) async {
    try {
      final response = await _apiService.post(
        '/BaoCao/gui-email',
        data: {
          'nhanVienId': nhanVienId,
          'loaiBaoCao': loaiBaoCao,
        },
      );
      return response.data['thanhCong'] ?? false;
    } catch (e) {
      throw Exception('Gửi email báo cáo thất bại: $e');
    }
  }
}
