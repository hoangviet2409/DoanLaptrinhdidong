import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/auth/auth_state.dart';
import '../../config/theme.dart';
import '../../models/dang_ky_request_unified.dart';
import '../../services/admin_service.dart';
import '../../services/api_service.dart';
import '../../services/auth_service.dart';
import 'man_hinh_quan_ly_user.dart';
import 'man_hinh_tao_nhan_vien.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ManHinhTaoTaiKhoan extends StatefulWidget {
  const ManHinhTaoTaiKhoan({super.key});

  @override
  State<ManHinhTaoTaiKhoan> createState() => _ManHinhTaoTaiKhoanState();
}

class _ManHinhTaoTaiKhoanState extends State<ManHinhTaoTaiKhoan> {
  String _selectedAccountType = 'NhanVien';
  late AdminService _adminService;

  @override
  void initState() {
    super.initState();
    _initServices();
  }

  void _initServices() async {
    final prefs = await SharedPreferences.getInstance();
    final apiService = ApiService();
    final authService = AuthService(apiService, prefs);
    _adminService = AdminService(apiService, authService);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tạo Tài Khoản'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thông tin tổng quan
            _buildOverviewCard(),
            const SizedBox(height: 20),
            
            // Chọn loại tài khoản
            _buildAccountTypeSelector(),
            const SizedBox(height: 20),
            
            // Form tạo tài khoản
            _buildCreateAccountForm(),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.admin_panel_settings, color: AppTheme.primaryColor),
                const SizedBox(width: 8),
                const Text(
                  'Tạo Tài Khoản Mới',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Chọn loại tài khoản cần tạo và điền thông tin bên dưới.',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountTypeSelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Loại Tài Khoản',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildAccountTypeOption(
                    'NhanVien',
                    'Nhân Viên',
                    Icons.person,
                    'Tạo tài khoản cho nhân viên mới',
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildAccountTypeOption(
                    'QuanLy',
                    'Quản Lý',
                    Icons.manage_accounts,
                    'Tạo tài khoản quản lý phòng ban',
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildAccountTypeOption(
                    'Admin',
                    'Admin',
                    Icons.admin_panel_settings,
                    'Tạo tài khoản admin mới',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountTypeOption(String value, String title, IconData icon, String description) {
    final isSelected = _selectedAccountType == value;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedAccountType = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor.withOpacity(0.1) : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? AppTheme.primaryColor : Colors.grey,
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isSelected ? AppTheme.primaryColor : Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: TextStyle(
                fontSize: 10,
                color: isSelected ? AppTheme.primaryColor : Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreateAccountForm() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.create, color: AppTheme.primaryColor),
                const SizedBox(width: 8),
                Text(
                  'Tạo Tài Khoản ${_getAccountTypeName()}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Nút tạo tài khoản
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _navigateToCreateForm,
                icon: const Icon(Icons.add),
                label: Text('Tạo Tài Khoản ${_getAccountTypeName()}'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Thông tin bổ sung
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue.shade700, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _getAccountTypeInfo(),
                      style: TextStyle(
                        color: Colors.blue.shade700,
                        fontSize: 12,
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

  String _getAccountTypeName() {
    switch (_selectedAccountType) {
      case 'NhanVien':
        return 'Nhân Viên';
      case 'QuanLy':
        return 'Quản Lý';
      case 'Admin':
        return 'Admin';
      default:
        return 'Nhân Viên';
    }
  }

  String _getAccountTypeInfo() {
    switch (_selectedAccountType) {
      case 'NhanVien':
        return 'Nhân viên có thể chấm công, xem lịch sử và cập nhật thông tin cá nhân.';
      case 'QuanLy':
        return 'Quản lý có thể xem và quản lý nhân viên trong phòng ban, xem báo cáo.';
      case 'Admin':
        return 'Admin có toàn quyền quản lý hệ thống, tạo tài khoản và xem tất cả báo cáo.';
      default:
        return '';
    }
  }

  void _navigateToCreateForm() {
    if (_selectedAccountType == 'NhanVien') {
      // Navigate to employee creation form
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const ManHinhTaoNhanVien(),
        ),
      );
    } else {
      // Navigate to admin/manager creation form
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const ManHinhQuanLyUser(),
        ),
      );
    }
  }
}
