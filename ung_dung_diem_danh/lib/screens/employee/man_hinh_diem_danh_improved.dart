import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_state.dart';
import '../../config/theme.dart';
import '../../models/diem_danh_request.dart';
import '../../models/diem_danh_response.dart';
import '../../services/api_service.dart';
import '../../services/auth_service.dart';
import '../../services/auth_manager.dart';
import '../../services/diem_danh_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ManHinhDiemDanhImproved extends StatefulWidget {
  const ManHinhDiemDanhImproved({super.key});

  @override
  State<ManHinhDiemDanhImproved> createState() => _ManHinhDiemDanhImprovedState();
}

class _ManHinhDiemDanhImprovedState extends State<ManHinhDiemDanhImproved> {
  DiemDanhDto? _diemDanhHienTai;
  ThongKeDiemDanhResponse? _thongKe;
  bool _isLoading = false;
  bool _isCheckingLocation = false;
  Position? _currentPosition;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadDiemDanhHienTai();
    _loadThongKe();
    _getCurrentLocation();
  }

  Future<void> _loadDiemDanhHienTai() async {
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
      final diemDanh = await diemDanhService.layDiemDanhHienTaiCaNhan();

      if (diemDanh != null) {
        setState(() {
          _diemDanhHienTai = diemDanh;
        });
      } else {
        setState(() {
          _errorMessage = 'Chưa có điểm danh hôm nay';
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Lỗi kết nối: ${e.toString()}';
      });
    } finally {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadThongKe() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final apiService = ApiService();
      final authService = AuthService(apiService, prefs);
      
      final token = await authService.getCurrentToken();
      if (token != null) {
        apiService.setToken(token);
      }

      final diemDanhService = DiemDanhService(apiService);
      final thongKe = await diemDanhService.layThongKeDiemDanhCaNhan();

      if (thongKe.thanhCong) {
        if (!mounted) return;
        setState(() {
          _thongKe = thongKe;
        });
      }
    } catch (e) {
      // Check if it's an authentication error
      if (await AuthManager.handleAuthError(context, e)) {
        return; // Error was handled by AuthManager
      }
      
      // If API fails, use default values
      if (!mounted) return;
      setState(() {
        _thongKe = ThongKeDiemDanhResponse(
          thanhCong: false,
          thongBao: 'Không thể tải thống kê',
          ngayLamViecTrongThang: 0,
          tongGioLamTrongThang: 0,
          gioLamTrungBinh: 0,
          ngayLamViecTrongTuan: 0,
          tongGioLamTrongTuan: 0,
        );
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    if (!mounted) return;
    setState(() {
      _isCheckingLocation = true;
    });

    try {
      // Kiểm tra quyền truy cập vị trí
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (!mounted) return;
          setState(() {
            _isCheckingLocation = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (!mounted) return;
        setState(() {
          _isCheckingLocation = false;
        });
        return;
      }

      // Lấy vị trí hiện tại
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      if (!mounted) return;
      setState(() {
        _currentPosition = position;
        _isCheckingLocation = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isCheckingLocation = false;
      });
    }
  }

  Future<void> _diemDanhVao() async {
    if (_currentPosition == null) {
      _showMessage('Không thể lấy vị trí hiện tại', isError: true);
      return;
    }

    if (!mounted) return;
    setState(() {
      _isLoading = true;
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
      final maNhanVien = prefs.getString('ma_nhan_vien') ?? '';

      final request = DiemDanhVaoRequest(
        maNhanVien: maNhanVien,
        phuongThuc: 'SinhTracHoc',
        viDo: _currentPosition?.latitude,
        kinhDo: _currentPosition?.longitude,
        ghiChu: 'Điểm danh từ ứng dụng di động',
      );

      final response = await diemDanhService.diemDanhVao(request);

      if (response.thanhCong) {
        _showMessage('Điểm danh vào thành công!');
        _loadDiemDanhHienTai(); // Reload data
      } else {
        _showMessage(response.thongBao, isError: true);
      }
    } catch (e) {
      _showMessage('Lỗi: ${e.toString()}', isError: true);
    } finally {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _diemDanhRa() async {
    if (_currentPosition == null) {
      _showMessage('Không thể lấy vị trí hiện tại', isError: true);
      return;
    }

    if (!mounted) return;
    setState(() {
      _isLoading = true;
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
      final maNhanVien = prefs.getString('ma_nhan_vien') ?? '';

      final request = DiemDanhRaRequest(
        maNhanVien: maNhanVien,
        phuongThuc: 'SinhTracHoc',
        viDo: _currentPosition?.latitude,
        kinhDo: _currentPosition?.longitude,
        ghiChu: 'Điểm danh ra từ ứng dụng di động',
      );

      final response = await diemDanhService.diemDanhRa(request);

      if (response.thanhCong) {
        _showMessage('Điểm danh ra thành công!');
        _loadDiemDanhHienTai(); // Reload data
      } else {
        _showMessage(response.thongBao, isError: true);
      }
    } catch (e) {
      _showMessage('Lỗi: ${e.toString()}', isError: true);
    } finally {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppTheme.errorColor : AppTheme.successColor,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final user = state is AuthAuthenticated ? state.user : null;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Chấm Công Chi Tiết'),
            backgroundColor: AppTheme.primaryColor,
            foregroundColor: Colors.white,
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: _loadDiemDanhHienTai,
              ),
            ],
          ),
          body: user == null
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Thông tin ngày hôm nay
                      _buildTodayInfoCard(),
                      const SizedBox(height: 20),
                      
                      // Thông tin vị trí
                      _buildLocationCard(),
                      const SizedBox(height: 20),
                      
                      // Trạng thái điểm danh hiện tại
                      _buildCurrentStatusCard(),
                      const SizedBox(height: 20),
                      
                      // Nút điểm danh
                      _buildCheckInOutButtons(),
                      const SizedBox(height: 20),
                      
                      // Thông tin chi tiết
                      if (_diemDanhHienTai != null) ...[
                        _buildDetailInfoCard(),
                        const SizedBox(height: 20),
                      ],
                      
                      // Thống kê tuần
                      _buildWeeklyStatsCard(),
                    ],
                  ),
                ),
        );
      },
    );
  }

  Widget _buildTodayInfoCard() {
    final now = DateTime.now();
    final vietnamTime = now.add(const Duration(hours: 7)); // UTC+7
    
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: AppTheme.primaryColor,
                ),
                const SizedBox(width: 8),
                Text(
                  'Thông tin ngày hôm nay',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ngày',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        '${vietnamTime.day}/${vietnamTime.month}/${vietnamTime.year}',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Thời gian hiện tại',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        '${vietnamTime.hour.toString().padLeft(2, '0')}:${vietnamTime.minute.toString().padLeft(2, '0')}',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: AppTheme.primaryColor,
                ),
                const SizedBox(width: 8),
                Text(
                  'Vị trí hiện tại',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_isCheckingLocation)
              const Center(child: CircularProgressIndicator())
            else if (_currentPosition == null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning, color: Colors.orange.shade600),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text('Không thể lấy vị trí. Vui lòng kiểm tra quyền truy cập.'),
                    ),
                    TextButton(
                      onPressed: _getCurrentLocation,
                      child: const Text('Thử lại'),
                    ),
                  ],
                ),
              )
            else
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildLocationInfo(
                          'Vĩ độ',
                          _currentPosition!.latitude.toStringAsFixed(6),
                        ),
                      ),
                      Expanded(
                        child: _buildLocationInfo(
                          'Kinh độ',
                          _currentPosition!.longitude.toStringAsFixed(6),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green.shade600),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text('Vị trí đã được xác định'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationInfo(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            fontFamily: 'monospace',
          ),
        ),
      ],
    );
  }

  Widget _buildCurrentStatusCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  color: AppTheme.primaryColor,
                ),
                const SizedBox(width: 8),
                Text(
                  'Trạng thái điểm danh',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_errorMessage != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.red.shade600),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(color: Colors.red.shade600),
                      ),
                    ),
                  ],
                ),
              )
            else if (_diemDanhHienTai == null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue.shade600),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text('Chưa điểm danh hôm nay'),
                    ),
                  ],
                ),
              )
            else
              _buildStatusDetails(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusDetails() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildTimeCard(
                'Giờ vào',
                _diemDanhHienTai!.gioVao?.toString().substring(11, 16) ?? '--:--',
                _diemDanhHienTai!.gioVao != null ? AppTheme.successColor : Colors.grey,
                Icons.login,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildTimeCard(
                'Giờ ra',
                _diemDanhHienTai!.gioRa?.toString().substring(11, 16) ?? '--:--',
                _diemDanhHienTai!.gioRa != null ? AppTheme.errorColor : Colors.grey,
                Icons.logout,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _getStatusColor(_diemDanhHienTai!.trangThai).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _getStatusColor(_diemDanhHienTai!.trangThai)),
          ),
          child: Row(
            children: [
              Icon(
                _getStatusIcon(_diemDanhHienTai!.trangThai),
                color: _getStatusColor(_diemDanhHienTai!.trangThai),
                size: 32,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Trạng thái',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      _diemDanhHienTai!.trangThaiText,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: _getStatusColor(_diemDanhHienTai!.trangThai),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimeCard(String label, String time, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 4),
          Text(
            time,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckInOutButtons() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.touch_app,
                  color: AppTheme.primaryColor,
                ),
                const SizedBox(width: 8),
                Text(
                  'Thao tác điểm danh',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_diemDanhHienTai == null)
              // Chưa điểm danh vào
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _diemDanhVao,
                  icon: _isLoading 
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.login),
                  label: Text(_isLoading ? 'Đang xử lý...' : 'Điểm danh vào'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.successColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              )
            else if (_diemDanhHienTai!.gioRa == null)
              // Đã điểm danh vào, chưa điểm danh ra
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _diemDanhRa,
                  icon: _isLoading 
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.logout),
                  label: Text(_isLoading ? 'Đang xử lý...' : 'Điểm danh ra'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.errorColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              )
            else
              // Đã hoàn thành điểm danh
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green.shade600, size: 32),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Text(
                        'Đã hoàn thành điểm danh hôm nay',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailInfoCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: AppTheme.primaryColor,
                ),
                const SizedBox(width: 8),
                Text(
                  'Thông tin chi tiết',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildDetailRow('Phương thức vào', _diemDanhHienTai!.phuongThucVaoText),
            _buildDetailRow('Phương thức ra', _diemDanhHienTai!.phuongThucRaText),
            if (_diemDanhHienTai!.ghiChu?.isNotEmpty == true)
              _buildDetailRow('Ghi chú', _diemDanhHienTai!.ghiChu!),
            if (_diemDanhHienTai!.viDo != null && _diemDanhHienTai!.kinhDo != null)
              _buildDetailRow('Vị trí', '${_diemDanhHienTai!.viDo!.toStringAsFixed(6)}, ${_diemDanhHienTai!.kinhDo!.toStringAsFixed(6)}'),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyStatsCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.analytics,
                  color: AppTheme.primaryColor,
                ),
                const SizedBox(width: 8),
                Text(
                  'Thống kê tuần này',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'Ngày làm việc',
                    _thongKe?.ngayLamViecTrongTuan.toString() ?? '0',
                    Icons.calendar_today,
                    AppTheme.primaryColor,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Tổng giờ',
                    '${(_thongKe?.tongGioLamTrongTuan ?? 0).toStringAsFixed(0)}h',
                    Icons.access_time,
                    AppTheme.successColor,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Trung bình',
                    _thongKe?.ngayLamViecTrongTuan != null && _thongKe!.ngayLamViecTrongTuan > 0
                        ? '${(_thongKe!.tongGioLamTrongTuan / _thongKe!.ngayLamViecTrongTuan).toStringAsFixed(1)}h/ngày'
                        : '0h/ngày',
                    Icons.trending_up,
                    AppTheme.warningColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Color _getStatusColor(String trangThai) {
    switch (trangThai) {
      case 'DangLam':
        return AppTheme.successColor;
      case 'DaVe':
        return AppTheme.errorColor;
      case 'Nghi':
        return AppTheme.warningColor;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String trangThai) {
    switch (trangThai) {
      case 'DangLam':
        return Icons.work;
      case 'DaVe':
        return Icons.home;
      case 'Nghi':
        return Icons.sick;
      default:
        return Icons.help;
      }
    }
  }

