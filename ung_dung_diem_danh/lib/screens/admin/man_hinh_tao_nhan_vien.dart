import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../models/dang_ky_request.dart';
import '../../services/admin_service.dart';
import '../../services/api_service.dart';
import '../../services/auth_service.dart';
import '../../services/nfc_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ManHinhTaoNhanVien extends StatefulWidget {
  const ManHinhTaoNhanVien({super.key});

  @override
  State<ManHinhTaoNhanVien> createState() => _ManHinhTaoNhanVienState();
}

class _ManHinhTaoNhanVienState extends State<ManHinhTaoNhanVien> {
  final _formKey = GlobalKey<FormState>();
  final _maNhanVienController = TextEditingController();
  final _hoTenController = TextEditingController();
  final _emailController = TextEditingController();
  final _soDienThoaiController = TextEditingController();
  final _phongBanController = TextEditingController();
  final _chucVuController = TextEditingController();
  final _luongGioController = TextEditingController();
  final _maSinhTracHocController = TextEditingController();
  final _maKhuonMatController = TextEditingController();
  final _maTheNfcController = TextEditingController();
  final _matKhauController = TextEditingController();

  String _selectedTrangThai = 'HoatDong';
  bool _isLoading = false;
  bool _dangQuetNfc = false;
  final _nfcService = NfcService();

  @override
  void dispose() {
    _maNhanVienController.dispose();
    _hoTenController.dispose();
    _emailController.dispose();
    _soDienThoaiController.dispose();
    _phongBanController.dispose();
    _chucVuController.dispose();
    _luongGioController.dispose();
    _maSinhTracHocController.dispose();
    _maKhuonMatController.dispose();
    _maTheNfcController.dispose();
    _matKhauController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tạo Tài Khoản Nhân Viên'),
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
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.person_add, color: AppTheme.primaryColor),
                          const SizedBox(width: 8),
                          const Text(
                            'Thông Tin Nhân Viên',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Điền đầy đủ thông tin để tạo tài khoản nhân viên mới',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Form fields
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Mã nhân viên
                      TextFormField(
                        controller: _maNhanVienController,
                        decoration: const InputDecoration(
                          labelText: 'Mã Nhân Viên *',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.badge),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Mã nhân viên là bắt buộc';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Họ tên
                      TextFormField(
                        controller: _hoTenController,
                        decoration: const InputDecoration(
                          labelText: 'Họ Tên *',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Họ tên là bắt buộc';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Email
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email *',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.email),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email là bắt buộc';
                          }
                          if (!value.contains('@')) {
                            return 'Email không hợp lệ';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Số điện thoại
                      TextFormField(
                        controller: _soDienThoaiController,
                        decoration: const InputDecoration(
                          labelText: 'Số Điện Thoại',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.phone),
                        ),
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 16),

                      // Phòng ban
                      TextFormField(
                        controller: _phongBanController,
                        decoration: const InputDecoration(
                          labelText: 'Phòng Ban',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.business),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Chức vụ
                      TextFormField(
                        controller: _chucVuController,
                        decoration: const InputDecoration(
                          labelText: 'Chức Vụ',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.work),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Lương giờ
                      TextFormField(
                        controller: _luongGioController,
                        decoration: const InputDecoration(
                          labelText: 'Lương Giờ (VNĐ) *',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.attach_money),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Lương giờ là bắt buộc';
                          }
                          final luong = double.tryParse(value);
                          if (luong == null || luong <= 0) {
                            return 'Lương giờ phải là số dương';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Trạng thái
                      DropdownButtonFormField<String>(
                        value: _selectedTrangThai,
                        decoration: const InputDecoration(
                          labelText: 'Trạng Thái',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.toggle_on),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'HoatDong', child: Text('Hoạt Động')),
                          DropdownMenuItem(value: 'TamKhoa', child: Text('Tạm Khóa')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedTrangThai = value!;
                          });
                        },
                      ),
                      const SizedBox(height: 16),

                      // Mã sinh trắc học
                      TextFormField(
                        controller: _maSinhTracHocController,
                        decoration: const InputDecoration(
                          labelText: 'Mã Sinh Trắc Học',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.fingerprint),
                          helperText: 'Mã vân tay hoặc sinh trắc học (tùy chọn)',
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Mã khuôn mặt
                      TextFormField(
                        controller: _maKhuonMatController,
                        decoration: const InputDecoration(
                          labelText: 'Mã Khuôn Mặt',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.face),
                          helperText: 'Mã nhận diện khuôn mặt (tùy chọn)',
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Mã thẻ NFC
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _maTheNfcController,
                              decoration: const InputDecoration(
                                labelText: 'Mã Thẻ NFC',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.nfc),
                                helperText: 'Mã thẻ NFC để điểm danh (tùy chọn)',
                              ),
                              validator: (value) {
                                if (value != null && value.isNotEmpty) {
                                  if (!RegExp(r'^[0-9A-Fa-f]{8,16}$').hasMatch(value)) {
                                    return 'Mã thẻ NFC phải là chuỗi hex 8-16 ký tự';
                                  }
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          SizedBox(
                            height: 48,
                            child: OutlinedButton.icon(
                              onPressed: _dangQuetNfc ? null : _quetTheNfc,
                              icon: _dangQuetNfc
                                  ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                                  : const Icon(Icons.sensors),
                              label: Text(_dangQuetNfc ? 'Đưa thẻ gần...' : 'Quét thẻ'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Mật khẩu đăng nhập
                      TextFormField(
                        controller: _matKhauController,
                        decoration: const InputDecoration(
                          labelText: 'Mật Khẩu Đăng Nhập *',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.lock),
                          helperText: 'Tối thiểu 6 ký tự',
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Mật khẩu là bắt buộc';
                          }
                          if (value.length < 6) {
                            return 'Mật khẩu phải có ít nhất 6 ký tự';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
                      child: const Text('Hủy'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _createEmployee,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
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
                          : const Text('Tạo Nhân Viên'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _createEmployee() async {
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

      final request = DangKyNhanVienRequest(
        maNhanVien: _maNhanVienController.text.trim(),
        tenDangNhap: _maNhanVienController.text.trim(), // Sử dụng mã NV làm username
        matKhau: _matKhauController.text.trim(),
        email: _emailController.text.trim(),
        luongGio: double.tryParse(_luongGioController.text.trim()) ?? 0.0,
        hoTen: _hoTenController.text.trim(),
        soDienThoai: _soDienThoaiController.text.trim().isEmpty 
            ? null 
            : _soDienThoaiController.text.trim(),
        phongBan: _phongBanController.text.trim().isEmpty 
            ? null 
            : _phongBanController.text.trim(),
        chucVu: _chucVuController.text.trim().isEmpty 
            ? null 
            : _chucVuController.text.trim(),
        maTheNfc: _maTheNfcController.text.trim().isEmpty
            ? null
            : _maTheNfcController.text.trim().toUpperCase(),
      );

      final response = await adminService.taoTaiKhoanNhanVien(request);
      
      if (response.thanhCong) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Tạo nhân viên ${_hoTenController.text} thành công!'),
            backgroundColor: AppTheme.successColor,
          ),
        );
        _clearForm();
        Navigator.of(context).pop();
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

  Future<void> _quetTheNfc() async {
    setState(() { _dangQuetNfc = true; });
    try {
      final maThe = await _nfcService.readTagOnce();
      if (maThe != null && mounted) {
        _maTheNfcController.text = maThe.toUpperCase();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đã đọc thẻ: $maThe')),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Không đọc được thẻ NFC')), 
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi NFC: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() { _dangQuetNfc = false; });
      }
    }
  }

  void _clearForm() {
    _maNhanVienController.clear();
    _hoTenController.clear();
    _emailController.clear();
    _soDienThoaiController.clear();
    _phongBanController.clear();
    _chucVuController.clear();
    _luongGioController.clear();
    _maSinhTracHocController.clear();
    _maKhuonMatController.clear();
    _matKhauController.clear();
    _selectedTrangThai = 'HoatDong';
  }
}
