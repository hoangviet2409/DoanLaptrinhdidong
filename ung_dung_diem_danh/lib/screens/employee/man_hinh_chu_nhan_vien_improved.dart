import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_state.dart';
import '../../config/theme.dart';
import '../../services/diem_danh_service.dart';
import '../../services/api_service.dart';
import '../../services/auth_service.dart';
import '../../services/auth_manager.dart';
import '../../models/diem_danh_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'man_hinh_luong.dart';

class ManHinhChuNhanVienImproved extends StatefulWidget {
  final Function(int)? onNavigateToTab;
  
  const ManHinhChuNhanVienImproved({super.key, this.onNavigateToTab});

  @override
  State<ManHinhChuNhanVienImproved> createState() => _ManHinhChuNhanVienImprovedState();
}

class _ManHinhChuNhanVienImprovedState extends State<ManHinhChuNhanVienImproved> {
  DiemDanhDto? _diemDanhHienTai;
  bool _isLoading = true;
  String? _errorMessage;
  ThongKeDiemDanhResponse? _thongKe;

  @override
  void initState() {
    super.initState();
    _loadDiemDanhHienTai();
    _loadThongKe();
  }

  Future<void> _loadDiemDanhHienTai() async {
    try {
      if (!mounted) return;
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

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
        if (!mounted) return;
        setState(() {
          _diemDanhHienTai = diemDanh;
        });
      } else {
        if (!mounted) return;
        setState(() {
          _errorMessage = 'Chưa có điểm danh hôm nay';
        });
      }
    } catch (e) {
      // Check if it's an authentication error
      if (await AuthManager.handleAuthError(context, e)) {
        return; // Error was handled by AuthManager
      }
      
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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final user = state is AuthAuthenticated ? state.user : null;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Trang Chủ Nhân Viên'),
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
                      // User Info Card
                      _buildUserInfoCard(context, user),
                      const SizedBox(height: 24),

                      // Trạng thái điểm danh hôm nay
                      _buildAttendanceStatusCard(context),
                      const SizedBox(height: 24),

                      // Quick Action - Điểm danh thông minh
                      _buildSmartCheckInCard(context),
                      const SizedBox(height: 24),

                      // Thống kê nhanh
                      _buildQuickStatsCard(context),
                      const SizedBox(height: 24),

                      // Menu Items
                      _buildMenuSection(context),
                    ],
                  ),
                ),
        );
      },
    );
  }

  Widget _buildUserInfoCard(BuildContext context, dynamic user) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundColor: AppTheme.primaryColor,
              child: Icon(
                Icons.person,
                size: 40,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Xin chào,',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    user.hoTen,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.successColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Đang hoạt động',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Hiển thị thời gian hiện tại
            Column(
              children: [
                Text(
                  _getCurrentTime(),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _getCurrentDate(),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceStatusCard(BuildContext context) {
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
                  'Trạng thái hôm nay',
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
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.orange.shade600),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text('Chưa điểm danh hôm nay'),
                    ),
                  ],
                ),
              )
            else
              _buildAttendanceDetails(context, _diemDanhHienTai!),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceDetails(BuildContext context, DiemDanhDto diemDanh) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildTimeInfo(
                'Giờ vào',
                diemDanh.gioVao?.toString().substring(11, 16) ?? '--:--',
                diemDanh.gioVao != null ? AppTheme.successColor : Colors.grey,
              ),
            ),
            Expanded(
              child: _buildTimeInfo(
                'Giờ ra',
                diemDanh.gioRa?.toString().substring(11, 16) ?? '--:--',
                diemDanh.gioRa != null ? AppTheme.errorColor : Colors.grey,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _getStatusColor(diemDanh.trangThai).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: _getStatusColor(diemDanh.trangThai)),
          ),
          child: Row(
            children: [
              Icon(
                _getStatusIcon(diemDanh.trangThai),
                color: _getStatusColor(diemDanh.trangThai),
              ),
              const SizedBox(width: 8),
              Text(
                'Trạng thái: ${diemDanh.trangThaiText}',
                style: TextStyle(
                  color: _getStatusColor(diemDanh.trangThai),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimeInfo(String label, String time, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          time,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildSmartCheckInCard(BuildContext context) {
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
                  'Điểm danh nhanh',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildSmartCheckInButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSmartCheckInButton(BuildContext context) {
    if (_diemDanhHienTai == null) {
      // Chưa điểm danh vào
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () {
            // Navigate to check-in page using bottom navigation
            _navigateToTab(1); // Index 1 is Chấm Công
          },
          icon: const Icon(Icons.login),
          label: const Text('Điểm danh vào'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.successColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      );
    } else if (_diemDanhHienTai!.gioRa == null) {
      // Đã điểm danh vào, chưa điểm danh ra
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () {
            // Navigate to check-out page using bottom navigation
            _navigateToTab(1); // Index 1 is Chấm Công
          },
          icon: const Icon(Icons.logout),
          label: const Text('Điểm danh ra'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.errorColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      );
    } else {
      // Đã hoàn thành điểm danh
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.green.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.green.shade200),
        ),
        child: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green.shade600),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'Đã hoàn thành điểm danh hôm nay',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildQuickStatsCard(BuildContext context) {
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
                  'Thống kê nhanh',
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
                    _thongKe?.ngayLamViecTrongThang.toString() ?? '0',
                    Icons.calendar_today,
                    AppTheme.primaryColor,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Giờ làm TB',
                    '${(_thongKe?.gioLamTrungBinh ?? 0).toStringAsFixed(1)}h',
                    Icons.access_time,
                    AppTheme.successColor,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Tháng này',
                    '${(_thongKe?.tongGioLamTrongThang ?? 0).toStringAsFixed(0)}h',
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

  Widget _buildMenuSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Menu',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildMenuItem(
          context,
          icon: Icons.history,
          title: 'Lịch Sử Điểm Danh',
          subtitle: 'Xem lịch sử điểm danh của bạn',
          onTap: () {
            // Navigate to history page using bottom navigation
            _navigateToTab(2); // Index 2 is Lịch Sử
          },
        ),
        const SizedBox(height: 12),
        _buildMenuItem(
          context,
          icon: Icons.attach_money,
          title: 'Lương',
          subtitle: 'Xem thông tin lương',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ManHinhLuong(),
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        _buildMenuItem(
          context,
          icon: Icons.person,
          title: 'Thông Tin Cá Nhân',
          subtitle: 'Xem và chỉnh sửa hồ sơ',
          onTap: () {
            // Navigate to profile page using bottom navigation
            _navigateToTab(3); // Index 3 is Hồ Sơ
          },
        ),
      ],
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
          child: Icon(
            icon,
            color: AppTheme.primaryColor,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  String _getCurrentTime() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }

  String _getCurrentDate() {
    final now = DateTime.now();
    return '${now.day}/${now.month}/${now.year}';
  }

  void _navigateToTab(int index) {
    if (widget.onNavigateToTab != null) {
      widget.onNavigateToTab!(index);
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
