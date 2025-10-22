import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_state.dart';
import '../../config/theme.dart';
import '../../models/admin_dashboard_response.dart';
import '../../services/api_service.dart';
import '../../services/auth_service.dart';
import '../../services/auth_manager.dart';
import '../../services/diem_danh_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'man_hinh_cham_cong_thu_cong.dart';

class ManHinhTongQuanAdmin extends StatefulWidget {
  const ManHinhTongQuanAdmin({super.key});

  @override
  State<ManHinhTongQuanAdmin> createState() => _ManHinhTongQuanAdminState();
}

class _ManHinhTongQuanAdminState extends State<ManHinhTongQuanAdmin> {
  AdminDashboardResponse? _dashboardData;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    try {
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
      final dashboardData = await diemDanhService.layThongTinDashboardAdmin();

      if (dashboardData.thanhCong) {
        setState(() {
          _dashboardData = dashboardData;
        });
      } else {
        setState(() {
          _errorMessage = dashboardData.thongBao;
        });
      }
    } catch (e) {
      // Check if it's an authentication error
      if (await AuthManager.handleAuthError(context, e)) {
        return; // Error was handled by AuthManager
      }
      
      setState(() {
        _errorMessage = 'Lỗi kết nối: ${e.toString()}';
      });
    } finally {
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
            title: const Text('Tổng Quan Admin'),
            backgroundColor: AppTheme.primaryColor,
            foregroundColor: Colors.white,
          ),
          body: user == null
              ? const Center(child: CircularProgressIndicator())
              : _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _errorMessage != null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error_outline,
                                size: 64,
                                color: Colors.red[300],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                _errorMessage!,
                                style: Theme.of(context).textTheme.bodyLarge,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: _loadDashboardData,
                                child: const Text('Thử lại'),
                              ),
                            ],
                          ),
                        )
                      : SingleChildScrollView(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                      // Welcome Card
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              const CircleAvatar(
                                radius: 30,
                                backgroundColor: AppTheme.primaryColor,
                                child: Icon(
                                  Icons.admin_panel_settings,
                                  size: 30,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Xin chào, ${user.hoTen}',
                                      style: Theme.of(context).textTheme.titleLarge,
                                    ),
                                    Text(
                                      'Quản Trị Viên',
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                            color: Colors.grey[600],
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Statistics Cards
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Thống Kê Hôm Nay',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          IconButton(
                            onPressed: _loadDashboardData,
                            icon: const Icon(Icons.refresh),
                            tooltip: 'Làm mới',
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      // Thống kê tổng quan
                      if (_dashboardData != null) ...[
                        Row(
                          children: [
                            Expanded(
                              child: _buildStatCard(
                                context,
                                icon: Icons.people,
                                title: 'Tổng NV',
                                value: _dashboardData!.thongKeTongQuan.tongNhanVien.toString(),
                                color: AppTheme.primaryColor,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildStatCard(
                                context,
                                icon: Icons.work,
                                title: 'Đang Làm',
                                value: _dashboardData!.thongKeTongQuan.nhanVienDangLamViec.toString(),
                                color: AppTheme.successColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _buildStatCard(
                                context,
                                icon: Icons.home,
                                title: 'Đã Về',
                                value: _dashboardData!.thongKeTongQuan.nhanVienNghi.toString(),
                                color: AppTheme.primaryColor,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildStatCard(
                                context,
                                icon: Icons.warning,
                                title: 'Chưa ĐD',
                                value: _dashboardData!.thongKeTongQuan.nhanVienChuaDiemDanh.toString(),
                                color: AppTheme.errorColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _buildStatCard(
                                context,
                                icon: Icons.trending_up,
                                title: 'Tỷ lệ CC',
                                value: '${_dashboardData!.thongKeTongQuan.tyLeChuyenCan.toStringAsFixed(1)}%',
                                color: AppTheme.successColor,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildStatCard(
                                context,
                                icon: Icons.access_time,
                                title: 'Giờ TB',
                                value: '${_dashboardData!.thongKeTongQuan.gioLamTrungBinh.toStringAsFixed(1)}h',
                                color: AppTheme.warningColor,
                              ),
                            ),
                          ],
                        ),
                      ] else ...[
                        // Fallback khi chưa có dữ liệu
                        Row(
                          children: [
                            Expanded(
                              child: _buildStatCard(
                                context,
                                icon: Icons.people,
                                title: 'Đang Làm',
                                value: '--',
                                color: AppTheme.successColor,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildStatCard(
                                context,
                                icon: Icons.home,
                                title: 'Đã Về',
                                value: '--',
                                color: AppTheme.primaryColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _buildStatCard(
                                context,
                                icon: Icons.sick,
                                title: 'Nghỉ',
                                value: '--',
                                color: AppTheme.errorColor,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildStatCard(
                                context,
                                icon: Icons.access_time,
                                title: 'Đi Muộn',
                                value: '--',
                                color: Colors.orange,
                              ),
                            ),
                          ],
                        ),
                      ],
                      
                      const SizedBox(height: 24),
                      
                      // Quick Actions
                      Text(
                        'Truy Cập Nhanh',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      
                      Row(
                        children: [
                          Expanded(
                            child: _buildQuickActionCard(
                              context,
                              icon: Icons.edit_note,
                              title: 'Chấm Công',
                              color: Colors.blue,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const ManHinhChamCongThuCong(),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildQuickActionCard(
                              context,
                              icon: Icons.person_add,
                              title: 'Thêm NV',
                              color: Colors.green,
                              onTap: () {
                                Navigator.pushNamed(context, '/tao-nhan-vien');
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      
                      // Nhân viên chưa điểm danh
                      if (_dashboardData != null && _dashboardData!.nhanVienChuaDiemDanh.isNotEmpty) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Nhân Viên Chưa Điểm Danh',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            Text(
                              '${_dashboardData!.nhanVienChuaDiemDanh.length}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.errorColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ..._dashboardData!.nhanVienChuaDiemDanh.take(5).map(
                          (nv) => Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.red[100],
                                child: Text(
                                  nv.maNhanVien,
                                  style: TextStyle(
                                    color: Colors.red[700],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              title: Text(nv.hoTen),
                              subtitle: Text('${nv.phongBan} - ${nv.chucVu}'),
                              trailing: IconButton(
                                icon: Icon(Icons.edit_note, color: AppTheme.primaryColor),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const ManHinhChamCongThuCong(),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ).toList(),
                        const SizedBox(height: 16),
                      ],
                      
                      // Nhân viên đang làm việc
                      if (_dashboardData != null && _dashboardData!.nhanVienDangLamViec.isNotEmpty) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Nhân Viên Đang Làm Việc',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            Text(
                              '${_dashboardData!.nhanVienDangLamViec.length}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.successColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ..._dashboardData!.nhanVienDangLamViec.map(
                          (nv) => Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.green[100],
                                child: Text(
                                  nv.maNhanVien,
                                  style: TextStyle(
                                    color: Colors.green[700],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              title: Text(nv.hoTen),
                              subtitle: Text('${nv.phongBan} - ${nv.chucVu}\nĐã làm: ${nv.soGioLam.toStringAsFixed(1)}h'),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.work, color: Colors.green[700], size: 20),
                                  const SizedBox(height: 4),
                                  Text(
                                    nv.trangThai,
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.green[700],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ).toList(),
                      ],
                      
                    ],
                  ),
                ),
        );
      },
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: color.withOpacity(0.1),
                child: Icon(
                  icon,
                  size: 28,
                  color: color,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

}

