import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/auth/auth_state.dart';
import '../../config/theme.dart';
import '../../services/api_service.dart';
import '../../services/nhan_vien_service.dart';
import '../../models/nhan_vien_model.dart';
import 'man_hinh_luong.dart';
import 'man_hinh_chinh_sua_thong_tin.dart';
import 'man_hinh_doi_mat_khau.dart';
import 'man_hinh_cai_dat_thong_bao.dart';
import 'man_hinh_huong_dan_su_dung.dart';

class ManHinhHoSo extends StatefulWidget {
  const ManHinhHoSo({super.key});

  @override
  State<ManHinhHoSo> createState() => _ManHinhHoSoState();
}

class _ManHinhHoSoState extends State<ManHinhHoSo> {
  late NhanVienService _nhanVienService;
  NhanVienModel? _nhanVien;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _nhanVienService = NhanVienService(ApiService());
    _loadNhanVienInfo();
  }

  Future<void> _loadNhanVienInfo() async {
    setState(() => _isLoading = true);
    
    try {
      final authState = context.read<AuthBloc>().state;
      if (authState is AuthAuthenticated && authState.user.nhanVienId != null) {
        final nhanVien = await _nhanVienService.layNhanVienTheoId(authState.user.nhanVienId!);
        if (mounted) {
          setState(() {
            _nhanVien = nhanVien;
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hồ Sơ'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadNhanVienInfo,
            tooltip: 'Làm mới',
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _showLogoutDialog(context),
            tooltip: 'Đăng xuất',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                final user = state is AuthAuthenticated ? state.user : null;

                if (user == null) {
                  return const Center(child: CircularProgressIndicator());
                }

                return RefreshIndicator(
                  onRefresh: _loadNhanVienInfo,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        // Thông tin cá nhân
                        _buildPersonalInfoCard(user),
                        const SizedBox(height: 16),

                        // Menu options
                        _buildMenuOptions(context),
                        const SizedBox(height: 16),

                        // Thông tin ứng dụng
                        _buildAppInfoCard(),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildPersonalInfoCard(dynamic user) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Avatar
            CircleAvatar(
              radius: 50,
              backgroundColor: AppTheme.primaryColor,
              child: Text(
                user.hoTen.isNotEmpty ? user.hoTen[0].toUpperCase() : 'U',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Tên
            Text(
              user.hoTen,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            // Vai trò
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.primaryColor.withOpacity(0.3)),
              ),
              child: Text(
                user.vaiTro,
                style: TextStyle(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Thông tin chi tiết
            _buildInfoRow(Icons.badge, 'Mã NV', _nhanVien?.maNhanVien ?? 'N/A'),
            _buildInfoRow(Icons.email, 'Email', _nhanVien?.email ?? 'N/A'),
            _buildInfoRow(Icons.phone, 'Số điện thoại', _nhanVien?.soDienThoai ?? 'N/A'),
            _buildInfoRow(Icons.business, 'Phòng ban', _nhanVien?.phongBan ?? 'N/A'),
            _buildInfoRow(Icons.work, 'Chức vụ', _nhanVien?.chucVu ?? 'N/A')
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey.shade600),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuOptions(BuildContext context) {
    return Card(
      child: Column(
        children: [
          _buildMenuOption(
            icon: Icons.edit,
            title: 'Chỉnh sửa thông tin',
            subtitle: 'Cập nhật thông tin cá nhân',
            onTap: () async {
              if (_nhanVien != null) {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ManHinhChinhSuaThongTin(
                      nhanVien: _nhanVien!,
                    ),
                  ),
                );
                // Refresh nếu có cập nhật
                if (result == true) {
                  _loadNhanVienInfo();
                }
              }
            },
          ),
          const Divider(height: 1),
          _buildMenuOption(
            icon: Icons.attach_money,
            title: 'Lương',
            subtitle: 'Xem lịch sử lương',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ManHinhLuong()),
              );
            },
          ),
          const Divider(height: 1),
          _buildMenuOption(
            icon: Icons.security,
            title: 'Bảo mật',
            subtitle: 'Đổi mật khẩu, xác thực',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ManHinhDoiMatKhau()),
              );
            },
          ),
          const Divider(height: 1),
          _buildMenuOption(
            icon: Icons.notifications,
            title: 'Thông báo',
            subtitle: 'Cài đặt thông báo',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ManHinhCaiDatThongBao()),
              );
            },
          ),
          const Divider(height: 1),
          _buildMenuOption(
            icon: Icons.help,
            title: 'Trợ giúp',
            subtitle: 'Hướng dẫn sử dụng',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ManHinhHuongDanSuDung()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
        child: Icon(icon, color: AppTheme.primaryColor),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  Widget _buildAppInfoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Thông tin ứng dụng',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildInfoRow(Icons.info, 'Phiên bản', '1.0.0'),
            _buildInfoRow(Icons.update, 'Cập nhật cuối', '20/10/2025'),
            _buildInfoRow(Icons.developer_mode, 'Nhà phát triển', 'Team Dev'),
            const SizedBox(height: 16),
            Center(
              child: Text(
                '© 2025 Ứng dụng điểm danh nhân viên',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Đăng Xuất'),
          ),
        ],
      ),
    );
  }
}
