import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_event.dart';
import '../blocs/auth/auth_state.dart';
import '../config/theme.dart';
import 'admin/man_hinh_tong_quan_admin.dart';
import 'admin/man_hinh_quan_ly_nhan_vien_admin.dart';
import 'admin/man_hinh_tao_tai_khoan.dart';
import 'admin/man_hinh_bao_cao_tuan.dart';
import 'admin/man_hinh_bao_cao_thang.dart';
import 'admin/man_hinh_bao_cao_quy.dart';
import 'admin/man_hinh_bao_cao_nam.dart';
import 'manager/man_hinh_quan_ly_nhan_vien_manager.dart';
import 'manager/man_hinh_tong_quan_manager.dart';
import 'manager/man_hinh_bao_cao_manager.dart';
import 'employee/man_hinh_chu_nhan_vien_improved.dart';
import 'employee/man_hinh_diem_danh_improved.dart';
import 'employee/man_hinh_lich_su_diem_danh.dart';

class MainManHinh extends StatefulWidget {
  const MainManHinh({super.key});

  @override
  State<MainManHinh> createState() => _MainManHinhState();
}

class _MainManHinhState extends State<MainManHinh> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final user = state is AuthAuthenticated ? state.user : null;

        if (user == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Xác định bottom navigation items dựa trên role
        List<BottomNavigationBarItem> bottomNavItems;
        List<Widget> screens;

        if (user.isAdmin) {
          bottomNavItems = [
            const BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: 'Tổng Quan',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: 'Quản Lý NV',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.admin_panel_settings),
              label: 'Tạo Tài Khoản',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.analytics),
              label: 'Báo Cáo',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Cài Đặt',
            ),
          ];

          screens = [
            const ManHinhTongQuanAdmin(),
            const ManHinhQuanLyNhanVienAdmin(),
            const ManHinhTaoTaiKhoan(),
            const ManHinhBaoCao(),
            const ManHinhCaiDat(),
          ];
        } else if (user.isManager) {
          bottomNavItems = [
            const BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: 'Tổng Quan',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: 'Quản Lý NV',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.analytics),
              label: 'Báo Cáo',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Cài Đặt',
            ),
          ];

          screens = [
            const ManHinhTongQuanManager(),
            const ManHinhQuanLyNhanVienManager(),
            const ManHinhBaoCaoManager(),
            const ManHinhCaiDat(),
          ];
        } else {
          bottomNavItems = [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Trang Chủ',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.access_time),
              label: 'Chấm Công',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'Lịch Sử',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Hồ Sơ',
            ),
          ];

        screens = [
          ManHinhChuNhanVienImproved(onNavigateToTab: (index) {
            setState(() {
              _selectedIndex = index;
            });
          }),
          const ManHinhDiemDanhImproved(),
          const ManHinhLichSuDiemDanh(),
          const ManHinhHoSo(),
        ];
        }

        return Scaffold(
          body: IndexedStack(
            index: _selectedIndex,
            children: screens,
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: _selectedIndex,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            selectedItemColor: AppTheme.primaryColor,
            unselectedItemColor: Colors.grey,
            items: bottomNavItems,
          ),
        );
      },
    );
  }
}

// Placeholder screens cho các chức năng chưa implement
class ManHinhQuanLyNhanVien extends StatelessWidget {
  const ManHinhQuanLyNhanVien({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản Lý Nhân Viên'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Chức năng đang phát triển',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class ManHinhBaoCao extends StatelessWidget {
  const ManHinhBaoCao({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Báo Cáo'),
        backgroundColor: AppTheme.primaryColor,
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
                        Icon(Icons.analytics, color: AppTheme.primaryColor),
                        const SizedBox(width: 8),
                        Text(
                          'Báo Cáo Điểm Danh',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Xem các báo cáo điểm danh theo thời gian',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Report Options
            Text(
              'Loại Báo Cáo',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),

            _buildReportCard(
              context,
              icon: Icons.calendar_today,
              title: 'Báo Cáo Tuần',
              subtitle: 'Xem báo cáo điểm danh theo tuần',
              color: Colors.blue,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ManHinhBaoCaoTuan(),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),

            _buildReportCard(
              context,
              icon: Icons.calendar_month,
              title: 'Báo Cáo Tháng',
              subtitle: 'Xem báo cáo điểm danh theo tháng',
              color: Colors.green,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ManHinhBaoCaoThang(),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),

            _buildReportCard(
              context,
              icon: Icons.calendar_view_month,
              title: 'Báo Cáo Quý',
              subtitle: 'Xem báo cáo điểm danh theo quý',
              color: Colors.orange,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ManHinhBaoCaoQuy(),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),

            _buildReportCard(
              context,
              icon: Icons.calendar_month,
              title: 'Báo Cáo Năm',
              subtitle: 'Xem báo cáo điểm danh theo năm',
              color: Colors.purple,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ManHinhBaoCaoNam(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey[400],
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ManHinhCaiDat extends StatelessWidget {
  const ManHinhCaiDat({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cài Đặt'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _showLogoutDialog(context);
            },
          ),
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.settings, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Chức năng đang phát triển',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class ManHinhChamCong extends StatelessWidget {
  const ManHinhChamCong({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chấm Công'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.access_time, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Chức năng đang phát triển',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class ManHinhLichSu extends StatelessWidget {
  const ManHinhLichSu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lịch Sử'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Chức năng đang phát triển',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class ManHinhHoSo extends StatelessWidget {
  const ManHinhHoSo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hồ Sơ'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _showLogoutDialog(context);
            },
          ),
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Chức năng đang phát triển',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

void _showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Đăng Xuất'),
      content: const Text('Bạn có chắc chắn muốn đăng xuất?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: const Text('Hủy'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(dialogContext).pop();
            context.read<AuthBloc>().add(LogoutRequested());
            context.go('/login');
          },
          child: const Text('Đăng Xuất'),
        ),
      ],
    ),
  );
}
