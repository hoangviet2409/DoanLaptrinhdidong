import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ung_dung_diem_danh/models/bao_cao_response.dart';
import 'package:ung_dung_diem_danh/services/api_service.dart';
import 'package:ung_dung_diem_danh/services/bao_cao_service.dart';
import 'package:ung_dung_diem_danh/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ManHinhBaoCaoThang extends StatefulWidget {
  const ManHinhBaoCaoThang({super.key});

  @override
  State<ManHinhBaoCaoThang> createState() => _ManHinhBaoCaoThangState();
}

class _ManHinhBaoCaoThangState extends State<ManHinhBaoCaoThang> {
  late BaoCaoService _baoCaoService;
  BaoCaoResponse? _reportResult;
  String _errorMessage = '';
  bool _isLoading = false;
  int _selectedMonth = DateTime.now().month;
  int _selectedYear = DateTime.now().year;

  @override
  void initState() {
    super.initState();
    _initializeService();
  }

  Future<void> _initializeService() async {
    final prefs = await SharedPreferences.getInstance();
    final apiService = ApiService();
    final authService = AuthService(apiService, prefs);
    final token = await authService.getCurrentToken();
    if (token != null) {
      apiService.setToken(token);
    }
    _baoCaoService = BaoCaoService(apiService);
  }

  Future<void> _fetchReport() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
      _reportResult = null;
    });
    try {
      final result = await _baoCaoService.layBaoCaoThang(thang: _selectedMonth, nam: _selectedYear);
      setState(() {
        _reportResult = result;
      });
      _showSnackBar('Lấy báo cáo tháng thành công!', isError: false);
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
      _showSnackBar('Lỗi: $_errorMessage', isError: true);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Báo Cáo Tháng'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.calendar_month, color: Colors.green[700]),
                        const SizedBox(width: 8),
                        Text(
                          'Báo Cáo Điểm Danh Tháng',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.green[700],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Xem báo cáo điểm danh của tất cả nhân viên trong tháng',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Month/Year Selection
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Chọn Tháng/Năm',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<int>(
                            value: _selectedMonth,
                            decoration: const InputDecoration(
                              labelText: 'Tháng',
                              border: OutlineInputBorder(),
                            ),
                            items: List.generate(12, (index) {
                              return DropdownMenuItem(
                                value: index + 1,
                                child: Text('Tháng ${index + 1}'),
                              );
                            }),
                            onChanged: (value) {
                              setState(() {
                                _selectedMonth = value!;
                              });
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
                            items: List.generate(5, (index) {
                              final year = DateTime.now().year - 2 + index;
                              return DropdownMenuItem(
                                value: year,
                                child: Text('Năm $year'),
                              );
                            }),
                            onChanged: (value) {
                              setState(() {
                                _selectedYear = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Fetch Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _fetchReport,
                icon: _isLoading 
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.refresh),
                label: Text(_isLoading ? 'Đang tải...' : 'Lấy Báo Cáo'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Results
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_errorMessage.isNotEmpty)
              Card(
                color: Colors.red[50],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(Icons.error, color: Colors.red[700]),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Lỗi: $_errorMessage',
                          style: TextStyle(color: Colors.red[700]),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else if (_reportResult != null)
              _buildReportResultCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildReportResultCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Kết Quả Báo Cáo Tháng ${_selectedMonth}/${_selectedYear}',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.green[700],
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // Statistics
            if (_reportResult!.thongKe != null) ...[
              Text(
                'Thống Kê Tổng Quan',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              _buildStatCard('Tổng số ngày làm việc', '${_reportResult!.thongKe!.tongSoNgayLamViec}', Icons.calendar_today),
              _buildStatCard('Tổng giờ làm', '${_reportResult!.thongKe!.tongGioLam.toStringAsFixed(2)} giờ', Icons.access_time),
              _buildStatCard('Số ngày đi làm', '${_reportResult!.thongKe!.soNgayDiLam}', Icons.check_circle),
              _buildStatCard('Số ngày nghỉ', '${_reportResult!.thongKe!.soNgayNghi}', Icons.people),
              _buildStatCard('Số lần về sớm', '${_reportResult!.thongKe!.soLanVeSom}', Icons.schedule),
              _buildStatCard('Tỷ lệ đi làm', '${(_reportResult!.thongKe!.tyLeDiLam * 100).toStringAsFixed(1)}%', Icons.analytics),
              const SizedBox(height: 20),
            ],
            
            // Attendance Details
            Text(
              'Chi Tiết Điểm Danh',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            if (_reportResult!.danhSachDiemDanh?.isEmpty ?? true)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(
                    child: Text('Không có dữ liệu điểm danh trong tháng này.'),
                  ),
                ),
              )
            else
              ...(_reportResult!.danhSachDiemDanh?.map((diemDanh) => 
                _buildAttendanceCard(diemDanh)
              ).toList() ?? []),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Icon(icon, color: Colors.green[700], size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
            ),
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green[700],
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceCard(DiemDanhDto diemDanh) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.person, color: Colors.green[700], size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    diemDanh.hoTenNhanVien,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  '(${diemDanh.maNhanVien})',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  'Ngày: ${DateFormat('dd/MM/yyyy').format(diemDanh.ngay)}',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.login, size: 16, color: Colors.green[600]),
                const SizedBox(width: 4),
                Text(
                  'Vào: ${DateFormat('HH:mm').format(diemDanh.gioVao)}',
                  style: TextStyle(color: Colors.green[600]),
                ),
                const SizedBox(width: 16),
                Icon(Icons.logout, size: 16, color: Colors.red[600]),
                const SizedBox(width: 4),
                Text(
                  'Ra: ${diemDanh.gioRa != null ? DateFormat('HH:mm').format(diemDanh.gioRa!) : 'N/A'}',
                  style: TextStyle(color: Colors.red[600]),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Row(
                children: [
                  Icon(Icons.info, size: 16, color: Colors.blue[600]),
                  const SizedBox(width: 4),
                  Text(
                    'Trạng thái: ${diemDanh.trangThai}',
                    style: TextStyle(color: Colors.blue[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
