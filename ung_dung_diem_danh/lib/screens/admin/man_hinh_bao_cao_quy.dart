import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../config/theme.dart';
import '../../models/bao_cao_response.dart';
import '../../services/api_service.dart';
import '../../services/auth_service.dart';
import '../../services/bao_cao_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/auth_manager.dart';

class ManHinhBaoCaoQuy extends StatefulWidget {
  const ManHinhBaoCaoQuy({super.key});

  @override
  State<ManHinhBaoCaoQuy> createState() => _ManHinhBaoCaoQuyState();
}

class _ManHinhBaoCaoQuyState extends State<ManHinhBaoCaoQuy> {
  int _selectedQuarter = 1;
  int _selectedYear = DateTime.now().year;
  BaoCaoResponse? _baoCaoQuy;
  bool _isLoading = false;
  String? _errorMessage;
  BaoCaoService? _baoCaoService;

  @override
  void initState() {
    super.initState();
    _initializeServiceAndFetchReport();
  }

  Future<void> _initializeServiceAndFetchReport() async {
    final prefs = await SharedPreferences.getInstance();
    final apiService = ApiService();
    final authService = AuthService(apiService, prefs);
    
    final token = await authService.getCurrentToken();
    if (token != null) {
      apiService.setToken(token);
      _baoCaoService = BaoCaoService(apiService);
      _fetchBaoCaoQuy();
    } else {
      AuthManager.handleAuthError(context, Exception('Chưa đăng nhập'));
    }
  }

  Future<void> _fetchBaoCaoQuy() async {
    if (_baoCaoService == null) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await _baoCaoService!.layBaoCaoQuy(
        quy: _selectedQuarter,
        nam: _selectedYear,
      );
      setState(() {
        _baoCaoQuy = response;
      });
    } catch (e) {
      if (await AuthManager.handleAuthError(context, e)) {
        return;
      }
      setState(() {
        _errorMessage = 'Lỗi khi lấy báo cáo quý: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _getQuarterDescription(int quarter) {
    switch (quarter) {
      case 1: return 'Quý 1: Tháng 1-3';
      case 2: return 'Quý 2: Tháng 4-6';
      case 3: return 'Quý 3: Tháng 7-9';
      case 4: return 'Quý 4: Tháng 10-12';
      default: return 'Quý $quarter';
    }
  }

  String _getQuarterName(int quarter) {
    switch (quarter) {
      case 1: return 'Quý 1';
      case 2: return 'Quý 2';
      case 3: return 'Quý 3';
      case 4: return 'Quý 4';
      default: return 'Quý $quarter';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Báo Cáo Quý'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildQuarterYearSelectionCard(context),
            const SizedBox(height: 16),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _errorMessage != null
                      ? Center(
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                        )
                      : _baoCaoQuy == null || !_baoCaoQuy!.thanhCong
                          ? Center(
                              child: Text(
                                _baoCaoQuy?.thongBao ?? 'Không có dữ liệu báo cáo quý.',
                                style: const TextStyle(color: Colors.grey),
                                textAlign: TextAlign.center,
                              ),
                            )
                          : _buildReportContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuarterYearSelectionCard(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Chọn Quý và Năm',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              _getQuarterDescription(_selectedQuarter),
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<int>(
                    value: _selectedQuarter,
                    decoration: const InputDecoration(
                      labelText: 'Quý',
                      border: OutlineInputBorder(),
                    ),
                    items: List.generate(4, (index) => index + 1)
                        .map((quarter) => DropdownMenuItem(
                              value: quarter,
                              child: Text(_getQuarterName(quarter)),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedQuarter = value;
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<int>(
                    value: _selectedYear,
                    decoration: const InputDecoration(
                      labelText: 'Năm',
                      border: OutlineInputBorder(),
                    ),
                    items: List.generate(10, (index) => DateTime.now().year - 5 + index)
                        .map((year) => DropdownMenuItem(
                              value: year,
                              child: Text('$year'),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedYear = value;
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _fetchBaoCaoQuy,
                icon: const Icon(Icons.refresh),
                label: const Text('Lấy Báo Cáo'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportContent() {
    final thongKe = _baoCaoQuy!.thongKe;
    final danhSachDiemDanh = _baoCaoQuy!.danhSachDiemDanh;

    return ListView(
      children: [
        _buildStatisticsCard(thongKe!),
        const SizedBox(height: 16),
        if (danhSachDiemDanh != null && danhSachDiemDanh.isNotEmpty) ...[
          const Text(
            'Chi Tiết Điểm Danh',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...danhSachDiemDanh.map((diemDanh) => _buildAttendanceCard(diemDanh)).toList(),
        ] else
          const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('Không có bản ghi điểm danh nào trong quý này.'),
            ),
          ),
      ],
    );
  }

  Widget _buildStatisticsCard(ThongKeBaoCaoDto thongKe) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Thống Kê Tổng Quan',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildStatRow('Tổng số ngày làm việc:', '${thongKe.tongSoNgayLamViec} ngày'),
            _buildStatRow('Số ngày đi làm:', '${thongKe.soNgayDiLam} ngày'),
            _buildStatRow('Số ngày nghỉ:', '${thongKe.soNgayNghi} ngày'),
            _buildStatRow('Số lần đi muộn:', '${thongKe.soLanDiMuon} lần'),
            _buildStatRow('Số lần về sớm:', '${thongKe.soLanVeSom} lần'),
            _buildStatRow('Tổng giờ làm:', '${thongKe.tongGioLam.toStringAsFixed(2)} giờ'),
            _buildStatRow('Tỷ lệ đi làm:', '${(thongKe.tyLeDiLam * 100).toStringAsFixed(2)}%'),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 15)),
          Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildAttendanceCard(DiemDanhDto diemDanh) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${diemDanh.hoTenNhanVien} (${diemDanh.maNhanVien})',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildDetailRow('Ngày:', DateFormat('dd/MM/yyyy').format(diemDanh.ngay)),
            _buildDetailRow('Giờ vào:', DateFormat('HH:mm').format(diemDanh.gioVao)),
            _buildDetailRow('Giờ ra:', diemDanh.gioRa != null ? DateFormat('HH:mm').format(diemDanh.gioRa!) : 'Chưa ra'),
            _buildDetailRow('Trạng thái:', diemDanh.trangThai),
            if (diemDanh.ghiChu != null && diemDanh.ghiChu!.isNotEmpty)
              _buildDetailRow('Ghi chú:', diemDanh.ghiChu!),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
