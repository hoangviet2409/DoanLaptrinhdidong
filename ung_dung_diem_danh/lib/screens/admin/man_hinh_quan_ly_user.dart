import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../models/dang_ky_request_unified.dart';
import '../../models/dang_ky_response.dart';
import '../../services/admin_service.dart';
import '../../services/api_service.dart';
import '../../services/auth_service.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/theme.dart';

class ManHinhQuanLyUser extends StatefulWidget {
  const ManHinhQuanLyUser({super.key});

  @override
  State<ManHinhQuanLyUser> createState() => _ManHinhQuanLyUserState();
}

class _ManHinhQuanLyUserState extends State<ManHinhQuanLyUser> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _soDienThoaiController = TextEditingController();
  final _tenDangNhapController = TextEditingController();
  final _matKhauController = TextEditingController();
  final _xacNhanMatKhauController = TextEditingController();

  String _selectedRole = 'QuanLy';
  bool _isLoading = false;
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
  void dispose() {
    _emailController.dispose();
    _soDienThoaiController.dispose();
    _tenDangNhapController.dispose();
    _matKhauController.dispose();
    _xacNhanMatKhauController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản Lý Người Dùng'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tạo Tài Khoản Mới',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Role Selection
                    _buildRoleSelector(),
                    const SizedBox(height: 24),

                    // Form Fields
                    _buildFormFields(),
                    const SizedBox(height: 24),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : const Text('Tạo Tài Khoản'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
  }

  Widget _buildRoleSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Chọn vai trò',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            children: [
              Expanded(
                child: _buildRoleOption('QuanLy', 'Quản Lý'),
              ),
              Expanded(
                child: _buildRoleOption('Admin', 'Admin'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRoleOption(String value, String label) {
    final isSelected = _selectedRole == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedRole = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildFormFields() {
    return Column(
      children: [
        TextFormField(
          controller: _tenDangNhapController,
          decoration: InputDecoration(
            labelText: 'Tên đăng nhập *',
            hintText: 'Nhập tên đăng nhập',
            prefixIcon: const Icon(Icons.person),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Vui lòng nhập tên đăng nhập';
            }
            if (value.length < 3) {
              return 'Tên đăng nhập phải có ít nhất 3 ký tự';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'Email *',
            hintText: 'Nhập email',
            prefixIcon: const Icon(Icons.email),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Vui lòng nhập email';
            }
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return 'Email không hợp lệ';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _soDienThoaiController,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            labelText: 'Số điện thoại (tùy chọn)',
            hintText: 'Nhập số điện thoại',
            prefixIcon: const Icon(Icons.phone),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _matKhauController,
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Mật khẩu *',
            hintText: 'Nhập mật khẩu',
            prefixIcon: const Icon(Icons.lock),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Vui lòng nhập mật khẩu';
            }
            if (value.length < 6) {
              return 'Mật khẩu phải có ít nhất 6 ký tự';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _xacNhanMatKhauController,
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Xác nhận mật khẩu *',
            hintText: 'Nhập lại mật khẩu',
            prefixIcon: const Icon(Icons.lock_outline),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Vui lòng xác nhận mật khẩu';
            }
            if (value != _matKhauController.text) {
              return 'Mật khẩu không khớp';
            }
            return null;
          },
        ),
      ],
    );
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Tạo AdminService với token hiện tại
      final prefs = await SharedPreferences.getInstance();
      final apiService = ApiService();
      final authService = AuthService(apiService, prefs);
      final adminService = AdminService(apiService, authService);

      final request = DangKyRequest(
        vaiTro: _selectedRole,
        email: _emailController.text.trim(),
        soDienThoai: _soDienThoaiController.text.trim().isEmpty 
            ? null 
            : _soDienThoaiController.text.trim(),
        tenDangNhap: _tenDangNhapController.text.trim(),
        matKhau: _matKhauController.text,
      );

      final response = await adminService.taoTaiKhoanAdmin(request);
      
      if (response.thanhCong) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Tạo tài khoản ${_selectedRole} thành công!'),
            backgroundColor: AppTheme.successColor,
          ),
        );
        _clearForm();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.thongBao),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi: ${e.toString()}'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _clearForm() {
    _emailController.clear();
    _soDienThoaiController.clear();
    _tenDangNhapController.clear();
    _matKhauController.clear();
    _xacNhanMatKhauController.clear();
    setState(() {
      _selectedRole = 'QuanLy';
    });
  }
}
