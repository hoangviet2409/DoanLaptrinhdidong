import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../services/api_service.dart';
import '../../services/nhan_vien_service.dart';
import '../../models/nhan_vien_model.dart';

class ManHinhChinhSuaThongTin extends StatefulWidget {
  final NhanVienModel nhanVien;

  const ManHinhChinhSuaThongTin({
    super.key,
    required this.nhanVien,
  });

  @override
  State<ManHinhChinhSuaThongTin> createState() => _ManHinhChinhSuaThongTinState();
}

class _ManHinhChinhSuaThongTinState extends State<ManHinhChinhSuaThongTin> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _soDienThoaiController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _soDienThoaiController = TextEditingController(
      text: widget.nhanVien.soDienThoai ?? '',
    );
  }

  @override
  void dispose() {
    _soDienThoaiController.dispose();
    super.dispose();
  }

  Future<void> _capNhatThongTin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final nhanVienService = NhanVienService(ApiService());
      
      // Tạo object nhân viên mới với thông tin cập nhật
      final nhanVienCapNhat = NhanVienModel(
        id: widget.nhanVien.id,
        maNhanVien: widget.nhanVien.maNhanVien,
        hoTen: widget.nhanVien.hoTen,
        email: widget.nhanVien.email,
        soDienThoai: _soDienThoaiController.text.trim(),
        maSinhTracHoc: widget.nhanVien.maSinhTracHoc,
        maKhuonMat: widget.nhanVien.maKhuonMat,
        phongBan: widget.nhanVien.phongBan,
        chucVu: widget.nhanVien.chucVu,
        luongGio: widget.nhanVien.luongGio,
        trangThai: widget.nhanVien.trangThai,
        ngayTao: widget.nhanVien.ngayTao,
        ngayCapNhat: widget.nhanVien.ngayCapNhat,
      );

      await nhanVienService.capNhatNhanVien(
        widget.nhanVien.id,
        nhanVienCapNhat,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cập nhật thông tin thành công'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true); // Return true để refresh
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
        title: const Text('Chỉnh Sửa Thông Tin'),
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
              // Avatar section
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: AppTheme.primaryColor,
                      child: Text(
                        widget.nhanVien.hoTen.isNotEmpty
                            ? widget.nhanVien.hoTen[0].toUpperCase()
                            : 'U',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.nhanVien.hoTen,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.nhanVien.maNhanVien,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Thông tin không thể chỉnh sửa
              _buildInfoCard(),
              const SizedBox(height: 24),

              // Thông tin có thể chỉnh sửa
              _buildEditableCard(),
              const SizedBox(height: 32),

              // Nút cập nhật
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _capNhatThongTin,
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
                          'Cập Nhật Thông Tin',
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

  Widget _buildInfoCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, color: Colors.grey.shade700),
                const SizedBox(width: 8),
                const Text(
                  'Thông Tin Cố Định',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildReadOnlyField('Mã nhân viên', widget.nhanVien.maNhanVien),
            _buildReadOnlyField('Email', widget.nhanVien.email),
            _buildReadOnlyField('Phòng ban', widget.nhanVien.phongBan ?? 'N/A'),
            _buildReadOnlyField('Chức vụ', widget.nhanVien.chucVu ?? 'N/A'),
            const SizedBox(height: 8),
            Text(
              'Các thông tin trên không thể tự chỉnh sửa. Vui lòng liên hệ Admin nếu cần thay đổi.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReadOnlyField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditableCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.edit, color: AppTheme.primaryColor),
                const SizedBox(width: 8),
                const Text(
                  'Thông Tin Có Thể Chỉnh Sửa',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _soDienThoaiController,
              decoration: InputDecoration(
                labelText: 'Số điện thoại',
                hintText: 'Nhập số điện thoại',
                prefixIcon: const Icon(Icons.phone),
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
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập số điện thoại';
                }
                if (!RegExp(r'^[0-9]{10,11}$').hasMatch(value)) {
                  return 'Số điện thoại không hợp lệ (10-11 số)';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}

