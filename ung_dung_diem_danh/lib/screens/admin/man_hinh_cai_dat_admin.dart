import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../config/theme.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/auth/auth_state.dart';
import 'man_hinh_cham_cong_thu_cong.dart';
import 'man_hinh_quan_ly_user.dart';

/// Màn hình Cài đặt Admin với menu gọn gàng
class ManHinhCaiDatAdmin extends StatelessWidget {
  const ManHinhCaiDatAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final user = state is AuthAuthenticated ? state.user : null;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Cài Đặt'),
            backgroundColor: AppTheme.primaryColor,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                // Profile Header
                _buildProfileHeader(user),
                const SizedBox(height: 16),
                
                // Quản lý Section
                _buildSection(
                  context,
                  title: 'Quản lý',
                  children: [
                    _buildMenuItem(
                      context,
                      icon: Icons.edit_note,
                      title: 'Chấm Công Thủ Công',
                      subtitle: 'Chấm công cho nhân viên',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ManHinhChamCongThuCong(),
                          ),
                        );
                      },
                    ),
                    _buildMenuItem(
                      context,
                      icon: Icons.admin_panel_settings,
                      title: 'Tạo Tài Khoản Admin/Quản Lý',
                      subtitle: 'Tạo tài khoản quản trị viên mới',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ManHinhQuanLyUser(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                
                // Hệ thống Section
                _buildSection(
                  context,
                  title: 'Hệ thống',
                  children: [
                    _buildMenuItem(
                      context,
                      icon: Icons.info_outline,
                      title: 'Thông tin ứng dụng',
                      subtitle: 'Phiên bản 1.0.0',
                      onTap: () {
                        _showAppInfo(context);
                      },
                    ),
                    _buildMenuItem(
                      context,
                      icon: Icons.help_outline,
                      title: 'Hướng dẫn sử dụng',
                      subtitle: 'Xem hướng dẫn chi tiết',
                      onTap: () {
                        _showUserGuide(context);
                      },
                    ),
                  ],
                ),
                
                // Tài khoản Section
                _buildSection(
                  context,
                  title: 'Tài khoản',
                  children: [
                    _buildMenuItem(
                      context,
                      icon: Icons.logout,
                      title: 'Đăng xuất',
                      subtitle: 'Thoát khỏi tài khoản',
                      isDestructive: true,
                      onTap: () {
                        _showLogoutDialog(context);
                      },
                    ),
                  ],
                ),
                
                const SizedBox(height: 32),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileHeader(dynamic user) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primaryColor, AppTheme.primaryColor.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.admin_panel_settings,
              size: 40,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            user?.hoTen ?? 'Admin',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Quản Trị Viên',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, {required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
        ),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          elevation: 1,
          child: Column(
            children: children,
          ),
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
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: isDestructive 
            ? Colors.red[50] 
            : AppTheme.primaryColor.withOpacity(0.1),
        child: Icon(
          icon,
          color: isDestructive ? Colors.red : AppTheme.primaryColor,
          size: 22,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: isDestructive ? Colors.red : Colors.black87,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 12,
          color: isDestructive ? Colors.red[300] : Colors.grey[600],
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: isDestructive ? Colors.red[300] : Colors.grey[400],
      ),
      onTap: onTap,
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Xác nhận đăng xuất'),
        content: const Text('Bạn có chắc chắn muốn đăng xuất?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<AuthBloc>().add(LogoutRequested());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Đăng xuất'),
          ),
        ],
      ),
    );
  }

  void _showAppInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.info, color: AppTheme.primaryColor),
            const SizedBox(width: 8),
            const Text('Thông tin ứng dụng'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Tên ứng dụng:', 'Điểm Danh Nhân Viên'),
            _buildInfoRow('Phiên bản:', '1.0.0'),
            _buildInfoRow('Phát triển bởi:', 'Nhóm phát triển'),
            const SizedBox(height: 12),
            const Text(
              'Ứng dụng quản lý điểm danh và nhân viên với đầy đủ tính năng cho doanh nghiệp.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }

  void _showUserGuide(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.help, color: AppTheme.primaryColor),
            const SizedBox(width: 8),
            const Text('Hướng dẫn sử dụng'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildGuideItem('📊 Tổng Quan', 'Xem thống kê tổng quan và trạng thái nhân viên'),
              _buildGuideItem('👥 Nhân Viên', 'Quản lý danh sách nhân viên, thêm/sửa/xóa'),
              _buildGuideItem('📈 Báo Cáo', 'Xem báo cáo điểm danh theo tuần/tháng/quý/năm'),
              _buildGuideItem('💰 Lương', 'Quản lý và tính lương cho nhân viên'),
              _buildGuideItem('⚙️ Cài Đặt', 'Chấm công thủ công và quản lý hệ thống'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuideItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

