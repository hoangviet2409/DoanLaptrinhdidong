import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../services/api_service.dart';

class ManHinhDoiMatKhau extends StatefulWidget {
  const ManHinhDoiMatKhau({super.key});

  @override
  State<ManHinhDoiMatKhau> createState() => _ManHinhDoiMatKhauState();
}

class _ManHinhDoiMatKhauState extends State<ManHinhDoiMatKhau> {
  final _formKey = GlobalKey<FormState>();
  final _matKhauCuController = TextEditingController();
  final _matKhauMoiController = TextEditingController();
  final _xacNhanMatKhauController = TextEditingController();
  
  bool _obscureMatKhauCu = true;
  bool _obscureMatKhauMoi = true;
  bool _obscureXacNhan = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _matKhauCuController.dispose();
    _matKhauMoiController.dispose();
    _xacNhanMatKhauController.dispose();
    super.dispose();
  }

  Future<void> _doiMatKhau() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final apiService = ApiService();
      
      // Gọi API đổi mật khẩu
      await apiService.put(
        '/XacThuc/doi-mat-khau',
        data: {
          'matKhauCu': _matKhauCuController.text,
          'matKhauMoi': _matKhauMoiController.text,
          'xacNhanMatKhauMoi': _xacNhanMatKhauController.text,
        },
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đổi mật khẩu thành công'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đổi Mật Khẩu'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              _buildHeader(),
              const SizedBox(height: 32),

              // Mật khẩu cũ
              _buildPasswordField(
                controller: _matKhauCuController,
                label: 'Mật khẩu hiện tại',
                hint: 'Nhập mật khẩu hiện tại',
                obscure: _obscureMatKhauCu,
                onToggle: () => setState(() => _obscureMatKhauCu = !_obscureMatKhauCu),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập mật khẩu hiện tại';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Mật khẩu mới
              _buildPasswordField(
                controller: _matKhauMoiController,
                label: 'Mật khẩu mới',
                hint: 'Nhập mật khẩu mới',
                obscure: _obscureMatKhauMoi,
                onToggle: () => setState(() => _obscureMatKhauMoi = !_obscureMatKhauMoi),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập mật khẩu mới';
                  }
                  if (value.length < 6) {
                    return 'Mật khẩu phải có ít nhất 6 ký tự';
                  }
                  if (value == _matKhauCuController.text) {
                    return 'Mật khẩu mới phải khác mật khẩu cũ';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Xác nhận mật khẩu
              _buildPasswordField(
                controller: _xacNhanMatKhauController,
                label: 'Xác nhận mật khẩu mới',
                hint: 'Nhập lại mật khẩu mới',
                obscure: _obscureXacNhan,
                onToggle: () => setState(() => _obscureXacNhan = !_obscureXacNhan),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng xác nhận mật khẩu mới';
                  }
                  if (value != _matKhauMoiController.text) {
                    return 'Mật khẩu xác nhận không khớp';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Hướng dẫn
              _buildPasswordRequirements(),
              const SizedBox(height: 32),

              // Nút đổi mật khẩu
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _doiMatKhau,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'Đổi Mật Khẩu',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Card(
      color: AppTheme.primaryColor.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              Icons.security,
              size: 48,
              color: AppTheme.primaryColor,
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bảo mật tài khoản',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Thay đổi mật khẩu định kỳ để bảo vệ tài khoản của bạn',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required bool obscure,
    required VoidCallback onToggle,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(
            obscure ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: onToggle,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppTheme.primaryColor),
        ),
      ),
      validator: validator,
    );
  }

  Widget _buildPasswordRequirements() {
    return Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue.shade700, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Yêu cầu mật khẩu',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildRequirement('Tối thiểu 6 ký tự'),
            _buildRequirement('Nên chứa chữ hoa, chữ thường'),
            _buildRequirement('Nên chứa số và ký tự đặc biệt'),
            _buildRequirement('Không trùng với mật khẩu cũ'),
          ],
        ),
      ),
    );
  }

  Widget _buildRequirement(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 16,
            color: Colors.blue.shade700,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}

