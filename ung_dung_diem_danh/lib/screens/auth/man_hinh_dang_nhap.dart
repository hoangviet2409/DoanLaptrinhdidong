import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/auth/auth_state.dart';
import '../../models/dang_nhap_request.dart';
import '../../config/theme.dart';

class ManHinhDangNhap extends StatefulWidget {
  const ManHinhDangNhap({super.key});

  @override
  State<ManHinhDangNhap> createState() => _ManHinhDangNhapState();
}

class _ManHinhDangNhapState extends State<ManHinhDangNhap> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  // Admin form
  final _adminFormKey = GlobalKey<FormState>();
  final _adminUsernameController = TextEditingController();
  final _adminPasswordController = TextEditingController();
  
  // Employee form
  final _employeeFormKey = GlobalKey<FormState>();
  final _employeeMaNhanVienController = TextEditingController();
  final _employeeBiometricController = TextEditingController();
  
  bool _obscurePassword = true;

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
    _employeeMaNhanVienController.dispose();
    _employeeBiometricController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                AppTheme.primaryColor,
                AppTheme.secondaryColor,
              ],
            ),
          ),
          child: SafeArea(
            child: Center(
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
                          Icons.fingerprint,
                          size: 80,
                          color: AppTheme.primaryColor,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Điểm Danh Nhân Viên',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: AppTheme.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Chào mừng quay trở lại',
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
                          height: 300,
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
                  return null;
                },
                enabled: !isLoading,
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
                  return null;
                },
                enabled: !isLoading,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _handleAdminLogin,
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text('Đăng Nhập'),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.orange.shade700, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Tài khoản được cấp bởi Admin. Liên hệ Admin để được cấp tài khoản.',
                        style: TextStyle(
                          color: Colors.orange.shade700,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
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
                  return null;
                },
                enabled: !isLoading,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _employeeBiometricController,
                decoration: const InputDecoration(
                  labelText: 'Mật khẩu',
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập mật khẩu';
                  }
                  return null;
                },
                enabled: !isLoading,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _handleEmployeeLogin,
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text('Đăng Nhập'),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.orange.shade700, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Tài khoản được cấp bởi Admin. Liên hệ Admin để được cấp tài khoản.',
                        style: TextStyle(
                          color: Colors.orange.shade700,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleAdminLogin() {
    if (_adminFormKey.currentState!.validate()) {
      final request = DangNhapRequest(
        tenDangNhap: _adminUsernameController.text.trim(),
        matKhau: _adminPasswordController.text,
      );
      context.read<AuthBloc>().add(LoginAdminRequested(request));
    }
  }

  void _handleEmployeeLogin() {
    if (_employeeFormKey.currentState!.validate()) {
      final request = DangNhapNhanVienRequest(
        maNhanVien: _employeeMaNhanVienController.text.trim(),
        matKhau: _employeeBiometricController.text.trim(),
      );
      context.read<AuthBloc>().add(LoginEmployeeRequested(request));
    }
  }
}

