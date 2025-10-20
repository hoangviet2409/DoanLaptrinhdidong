import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_state.dart';
import '../../config/theme.dart';
import '../../models/diem_danh_response.dart';
import '../../services/api_service.dart';
import '../../services/auth_service.dart';
import '../../services/diem_danh_service.dart';

class ManHinhLichSuDiemDanh extends StatefulWidget {
  const ManHinhLichSuDiemDanh({super.key});

  @override
  State<ManHinhLichSuDiemDanh> createState() => _ManHinhLichSuDiemDanhState();
}

class _ManHinhLichSuDiemDanhState extends State<ManHinhLichSuDiemDanh> {
  List<DiemDanhDto> _lichSuDiemDanh = [];
  bool _isLoading = false;
  String? _errorMessage;
  DateTime? _tuNgay;
  DateTime? _denNgay;

  @override
  void initState() {
    super.initState();
    _loadLichSuDiemDanh();
  }

  Future<void> _loadLichSuDiemDanh() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final apiService = ApiService();
      final authService = AuthService(apiService, prefs);
      
      final token = await authService.getCurrentToken();
      if (token != null) {
        apiService.setToken(token);
      }

      final diemDanhService = DiemDanhService(apiService);
      
      // Lấy lịch sử điểm danh cá nhân
      final response = await diemDanhService.layLichSuDiemDanhCaNhan(
        tuNgay: _tuNgay,
        denNgay: _denNgay,
      );
      
      if (response.thanhCong) {
        setState(() {
          _lichSuDiemDanh = response.danhSachDiemDanh;
        });
      } else {
        setState(() {
          _errorMessage = response.thongBao;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
      initialDateRange: _tuNgay != null && _denNgay != null
          ? DateTimeRange(start: _tuNgay!, end: _denNgay!)
          : null,
    );

    if (picked != null) {
      setState(() {
        _tuNgay = picked.start;
        _denNgay = picked.end;
      });
      _loadLichSuDiemDanh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lịch Sử Điểm Danh'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.date_range),
            onPressed: _selectDateRange,
            tooltip: 'Chọn khoảng thời gian',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadLichSuDiemDanh,
            tooltip: 'Làm mới',
          ),
        ],
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          final user = state is AuthAuthenticated ? state.user : null;

          if (user == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              // Thông tin khoảng thời gian
              if (_tuNgay != null && _denNgay != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  color: Colors.blue.shade50,
                  child: Text(
                    'Từ ${_formatDate(_tuNgay!)} đến ${_formatDate(_denNgay!)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

              // Nội dung chính
              Expanded(
                child: _buildContent(),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              'Lỗi: $_errorMessage',
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadLichSuDiemDanh,
              child: const Text('Thử lại'),
            ),
          ],
        ),
      );
    }

    if (_lichSuDiemDanh.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history,
              size: 64,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            const Text(
              'Không có dữ liệu điểm danh',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Hãy chọn khoảng thời gian khác',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _lichSuDiemDanh.length,
      itemBuilder: (context, index) {
        final diemDanh = _lichSuDiemDanh[index];
        return _buildDiemDanhCard(diemDanh);
      },
    );
  }

  Widget _buildDiemDanhCard(DiemDanhDto diemDanh) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ngày điểm danh
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: AppTheme.primaryColor,
                ),
                const SizedBox(width: 8),
                Text(
                  _formatDate(diemDanh.ngay),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: diemDanh.trangThai == 'HoanThanh' 
                        ? Colors.green.shade100 
                        : Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    diemDanh.trangThai == 'HoanThanh' ? 'Hoàn thành' : 'Chưa hoàn thành',
                    style: TextStyle(
                      fontSize: 12,
                      color: diemDanh.trangThai == 'HoanThanh' 
                          ? Colors.green.shade700 
                          : Colors.orange.shade700,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Thông tin giờ vào/ra
            Row(
              children: [
                Expanded(
                  child: _buildTimeInfo(
                    'Giờ vào',
                    diemDanh.gioVao,
                    Icons.login,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTimeInfo(
                    'Giờ ra',
                    diemDanh.gioRa,
                    Icons.logout,
                    Colors.red,
                  ),
                ),
              ],
            ),

            // Thông tin vị trí
            if (diemDanh.viDo != null && diemDanh.kinhDo != null) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 16,
                    color: Colors.blue.shade600,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Vị trí: ${diemDanh.viDo!.toStringAsFixed(6)}, ${diemDanh.kinhDo!.toStringAsFixed(6)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue.shade600,
                      ),
                    ),
                  ),
                ],
              ),
            ],

            // Ghi chú
            if (diemDanh.ghiChu != null && diemDanh.ghiChu!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.note,
                    size: 16,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      diemDanh.ghiChu!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTimeInfo(String label, DateTime? time, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            time != null ? _formatTime(time) : 'Chưa có',
            style: TextStyle(
              fontSize: 14,
              color: time != null ? color : Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}
