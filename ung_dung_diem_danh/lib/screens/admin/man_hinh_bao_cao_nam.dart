import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../config/theme.dart';
import '../../models/bao_cao_response.dart';
import '../../services/api_service.dart';
import '../../services/auth_service.dart';
import '../../services/bao_cao_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/auth_manager.dart';

class ManHinhBaoCaoNam extends StatefulWidget {
  const ManHinhBaoCaoNam({super.key});

  @override
  State<ManHinhBaoCaoNam> createState() => _ManHinhBaoCaoNamState();
}

class _ManHinhBaoCaoNamState extends State<ManHinhBaoCaoNam> {
  int _selectedYear = DateTime.now().year;
  BaoCaoResponse? _baoCaoNam;
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
      _fetchBaoCaoNam();
    } else {
      AuthManager.handleAuthError(context, Exception('Chưa đăng nhập'));
    }
  }

  Future<void> _fetchBaoCaoNam() async {
    if (_baoCaoService == null) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await _baoCaoService!.layBaoCaoNam(
        nam: _selectedYear,
      );
      setState(() {
        _baoCaoNam = response;
      });
    } catch (e) {
      if (await AuthManager.handleAuthError(context, e)) {
        return;
      }
      setState(() {
        _errorMessage = 'Lỗi khi lấy báo cáo năm: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Báo Cáo Năm'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildYearSelectionCard(context),
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
                      : _baoCaoNam == null || !_baoCaoNam!.thanhCong
                          ? Center(
                              child: Text(
                                _baoCaoNam?.thongBao ?? 'Không có dữ liệu báo cáo năm.',
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

  Widget _buildYearSelectionCard(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Chọn Năm',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
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
                              child: Text('Năm $year'),
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
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.primaryColor.withOpacity(0.3)),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.calendar_month, color: AppTheme.primaryColor),
                        const SizedBox(height: 4),
                        Text(
                          'Năm $_selectedYear',
                          style: TextStyle(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _fetchBaoCaoNam,
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
    final thongKe = _baoCaoNam!.thongKe;
    final danhSachDiemDanh = _baoCaoNam!.danhSachDiemDanh;

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
              child: Text('Không có bản ghi điểm danh nào trong năm này.'),
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
            Text(
              'Thống Kê Tổng Quan Năm $_selectedYear',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
