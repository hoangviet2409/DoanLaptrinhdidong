import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/auth/auth_state.dart';
import '../../models/dang_ky_request.dart';
import '../../config/theme.dart';

class ManHinhDangKy extends StatefulWidget {
  const ManHinhDangKy({super.key});

  @override
  State<ManHinhDangKy> createState() => _ManHinhDangKyState();
}

class _ManHinhDangKyState extends State<ManHinhDangKy> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  // Admin form
  final _adminFormKey = GlobalKey<FormState>();
  final _adminUsernameController = TextEditingController();
  final _adminPasswordController = TextEditingController();
  final _adminConfirmPasswordController = TextEditingController();
  final _adminEmailController = TextEditingController();
  String _adminRole = 'Admin';
  
  // Employee form
  final _employeeFormKey = GlobalKey<FormState>();
  final _employeeMaNhanVienController = TextEditingController();
  final _employeeHoTenController = TextEditingController();
  final _employeeEmailController = TextEditingController();
  final _employeePhoneController = TextEditingController();
  final _employeePhongBanController = TextEditingController();
  final _employeeChucVuController = TextEditingController();
  final _employeeLuongController = TextEditingController();
  final _employeeBiometricController = TextEditingController();
  final _employeePasswordController = TextEditingController();
  
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _adminUsernameController.dispose();
    _adminPasswordController.dispose();
    _adminConfirmPasswordController.dispose();
    _adminEmailController.dispose();
    _employeeMaNhanVienController.dispose();
    _employeeHoTenController.dispose();
    _employeeEmailController.dispose();
    _employeePhoneController.dispose();
    _employeePhongBanController.dispose();
    _employeeChucVuController.dispose();
    _employeeLuongController.dispose();
    _employeeBiometricController.dispose();
    _employeePasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đăng Ký Tài Khoản'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppTheme.errorColor,
              ),
            );
          } else if (state is AuthAuthenticated) {
            // Navigate based on role
            if (state.user.isAdmin) {
              context.go('/admin/dashboard');
            } else {
              context.go('/employee/home');
            }
          }
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.primaryColor.withOpacity(0.1),
                AppTheme.secondaryColor.withOpacity(0.1),
              ],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Logo và Title
                      const Icon(
                        Icons.person_add,
                        size: 80,
                        color: AppTheme.primaryColor,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Đăng Ký Tài Khoản',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tạo tài khoản mới cho hệ thống',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                      const SizedBox(height: 32),
                      
                      // Tabs
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TabBar(
                          controller: _tabController,
                          indicator: BoxDecoration(
                            color: AppTheme.primaryColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          labelColor: Colors.white,
                          unselectedLabelColor: Colors.grey[700],
                          tabs: const [
                            Tab(text: 'Quản Trị Viên'),
                            Tab(text: 'Nhân Viên'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Tab Content
                      SizedBox(
                        height: 600,
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            _buildAdminForm(),
                            _buildEmployeeForm(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAdminForm() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        
        return Form(
          key: _adminFormKey,
          child: Column(
            children: [
              TextFormField(
                controller: _adminUsernameController,
                decoration: const InputDecoration(
                  labelText: 'Tên đăng nhập',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tên đăng nhập';
                  }
                  if (value.length < 3) {
                    return 'Tên đăng nhập phải ít nhất 3 ký tự';
                  }
                  return null;
                },
                enabled: !isLoading,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _adminEmailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập email';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                    return 'Email không hợp lệ';
                  }
                  return null;
                },
                enabled: !isLoading,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _adminRole,
                decoration: const InputDecoration(
                  labelText: 'Vai trò',
                  prefixIcon: Icon(Icons.admin_panel_settings),
                ),
                items: const [
                  DropdownMenuItem(value: 'Admin', child: Text('Admin')),
                  DropdownMenuItem(value: 'QuanLy', child: Text('Quản Lý')),
                ],
                onChanged: isLoading ? null : (value) {
                  setState(() {
                    _adminRole = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _adminPasswordController,
                decoration: InputDecoration(
                  labelText: 'Mật khẩu',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                obscureText: _obscurePassword,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập mật khẩu';
                  }
                  if (value.length < 6) {
                    return 'Mật khẩu phải ít nhất 6 ký tự';
                  }
                  return null;
                },
                enabled: !isLoading,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _adminConfirmPasswordController,
                decoration: InputDecoration(
                  labelText: 'Xác nhận mật khẩu',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                ),
                obscureText: _obscureConfirmPassword,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng xác nhận mật khẩu';
                  }
                  if (value != _adminPasswordController.text) {
                    return 'Mật khẩu không khớp';
                  }
                  return null;
                },
                enabled: !isLoading,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _handleAdminRegister,
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text('Đăng Ký'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmployeeForm() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        
        return Form(
          key: _employeeFormKey,
          child: Column(
            children: [
              TextFormField(
                controller: _employeeMaNhanVienController,
                decoration: const InputDecoration(
                  labelText: 'Mã nhân viên',
                  prefixIcon: Icon(Icons.badge),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập mã nhân viên';
                  }
                  if (value.length < 3) {
                    return 'Mã nhân viên phải ít nhất 3 ký tự';
                  }
                  return null;
                },
                enabled: !isLoading,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _employeeHoTenController,
                decoration: const InputDecoration(
                  labelText: 'Họ và tên',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập họ tên';
                  }
                  if (value.length < 2) {
                    return 'Họ tên phải ít nhất 2 ký tự';
                  }
                  return null;
                },
                enabled: !isLoading,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _employeeEmailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập email';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                    return 'Email không hợp lệ';
                  }
                  return null;
                },
                enabled: !isLoading,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _employeePhoneController,
                decoration: const InputDecoration(
                  labelText: 'Số điện thoại (tùy chọn)',
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
                enabled: !isLoading,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _employeePhongBanController,
                decoration: const InputDecoration(
                  labelText: 'Phòng ban (tùy chọn)',
                  prefixIcon: Icon(Icons.business),
                ),
                enabled: !isLoading,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _employeeChucVuController,
                decoration: const InputDecoration(
                  labelText: 'Chức vụ (tùy chọn)',
                  prefixIcon: Icon(Icons.work),
                ),
                enabled: !isLoading,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _employeeLuongController,
                decoration: const InputDecoration(
                  labelText: 'Lương giờ (VNĐ)',
                  prefixIcon: Icon(Icons.attach_money),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập lương giờ';
                  }
                  if (double.tryParse(value) == null || double.parse(value) <= 0) {
                    return 'Lương giờ phải là số dương';
                  }
                  return null;
                },
                enabled: !isLoading,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _employeeBiometricController,
                decoration: const InputDecoration(
                  labelText: 'Mã sinh trắc học (tùy chọn)',
                  prefixIcon: Icon(Icons.fingerprint),
                ),
                enabled: !isLoading,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _handleEmployeeRegister,
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text('Đăng Ký'),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  context.go('/login');
                },
                child: const Text('Đã có tài khoản? Đăng nhập ngay'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleAdminRegister() {
    if (_adminFormKey.currentState!.validate()) {
      final request = DangKyAdminRequest(
        tenDangNhap: _adminUsernameController.text.trim(),
        matKhau: _adminPasswordController.text,
        email: _adminEmailController.text.trim(),
        hoTen: _adminUsernameController.text.trim(), // Sử dụng username làm họ tên
        soDienThoai: null,
      );
      context.read<AuthBloc>().add(RegisterAdminRequested(request));
    }
  }

  void _handleEmployeeRegister() {
    if (_employeeFormKey.currentState!.validate()) {
      final request = DangKyNhanVienRequest(
        maNhanVien: _employeeMaNhanVienController.text.trim(),
        tenDangNhap: _employeeMaNhanVienController.text.trim(), // Sử dụng mã NV làm username
        matKhau: _employeePasswordController.text,
        email: _employeeEmailController.text.trim(),
        luongGio: double.parse(_employeeLuongController.text),
        hoTen: _employeeHoTenController.text.trim(),
        soDienThoai: _employeePhoneController.text.trim().isEmpty 
            ? null 
            : _employeePhoneController.text.trim(),
        phongBan: _employeePhongBanController.text.trim().isEmpty 
            ? null 
            : _employeePhongBanController.text.trim(),
        chucVu: _employeeChucVuController.text.trim().isEmpty 
            ? null 
            : _employeeChucVuController.text.trim(),
      );
      context.read<AuthBloc>().add(RegisterEmployeeRequested(request));
    }
  }
}
