import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../models/nhan_vien_model.dart';
import '../../services/nhan_vien_service.dart';
import '../../services/api_service.dart';
import '../../services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'man_hinh_chinh_sua_nhan_vien.dart';

class ManHinhChiTietNhanVien extends StatefulWidget {
  final NhanVienModel nhanVien;

  const ManHinhChiTietNhanVien({
    super.key,
    required this.nhanVien,
  });

  @override
  State<ManHinhChiTietNhanVien> createState() => _ManHinhChiTietNhanVienState();
}

class _ManHinhChiTietNhanVienState extends State<ManHinhChiTietNhanVien> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết: ${widget.nhanVien.hoTen}'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _navigateToEdit,
          ),
          PopupMenuButton<String>(
            onSelected: _handleMenuAction,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'toggle_status',
                child: Row(
                  children: [
                    Icon(Icons.toggle_on),
                    SizedBox(width: 8),
                    Text('Đổi trạng thái'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Xóa nhân viên', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            _buildHeaderCard(),
            const SizedBox(height: 16),

            // Thông tin cơ bản
            _buildBasicInfoCard(),
            const SizedBox(height: 16),

            // Thông tin công việc
            _buildWorkInfoCard(),
            const SizedBox(height: 16),

            // Thông tin sinh trắc học
            _buildBiometricInfoCard(),
            const SizedBox(height: 16),

            // Thông tin hệ thống
            _buildSystemInfoCard(),
            const SizedBox(height: 16),

            // Action Buttons
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: widget.nhanVien.trangThai == 'HoatDong' 
                  ? Colors.green 
                  : Colors.orange,
              child: Text(
                widget.nhanVien.maNhanVien,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.nhanVien.hoTen,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.nhanVien.maNhanVien,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: widget.nhanVien.trangThai == 'HoatDong' 
                          ? Colors.green[100] 
                          : Colors.orange[100],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      widget.nhanVien.trangThai == 'HoatDong' ? 'Hoạt động' : 'Tạm khóa',
                      style: TextStyle(
                        color: widget.nhanVien.trangThai == 'HoatDong' 
                            ? Colors.green[700] 
                            : Colors.orange[700],
                        fontWeight: FontWeight.bold,
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

  Widget _buildBasicInfoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.person, color: AppTheme.primaryColor),
                const SizedBox(width: 8),
                const Text(
                  'Thông tin cơ bản',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Họ tên', widget.nhanVien.hoTen),
            _buildInfoRow('Mã nhân viên', widget.nhanVien.maNhanVien),
            _buildInfoRow('Email', widget.nhanVien.email),
            if (widget.nhanVien.soDienThoai != null)
              _buildInfoRow('Số điện thoại', widget.nhanVien.soDienThoai!),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkInfoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.work, color: AppTheme.primaryColor),
                const SizedBox(width: 8),
                const Text(
                  'Thông tin công việc',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (widget.nhanVien.phongBan != null)
              _buildInfoRow('Phòng ban', widget.nhanVien.phongBan!),
            if (widget.nhanVien.chucVu != null)
              _buildInfoRow('Chức vụ', widget.nhanVien.chucVu!),
            _buildInfoRow('Lương giờ', _formatCurrency(widget.nhanVien.luongGio)),
            _buildInfoRow('Trạng thái', 
                widget.nhanVien.trangThai == 'HoatDong' ? 'Hoạt động' : 'Tạm khóa'),
          ],
        ),
      ),
    );
  }

  Widget _buildBiometricInfoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.fingerprint, color: AppTheme.primaryColor),
                const SizedBox(width: 8),
                const Text(
                  'Thông tin sinh trắc học',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Mã sinh trắc học', 
                widget.nhanVien.maSinhTracHoc ?? 'Chưa đăng ký'),
            _buildInfoRow('Mã khuôn mặt', 
                widget.nhanVien.maKhuonMat ?? 'Chưa đăng ký'),
            const SizedBox(height: 8),
            if (widget.nhanVien.maSinhTracHoc == null || widget.nhanVien.maKhuonMat == null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning, color: Colors.orange[700], size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Nhân viên chưa đăng ký đầy đủ sinh trắc học',
                        style: TextStyle(
                          color: Colors.orange[700],
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

  Widget _buildSystemInfoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info, color: AppTheme.primaryColor),
                const SizedBox(width: 8),
                const Text(
                  'Thông tin hệ thống',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Ngày tạo', _formatDate(widget.nhanVien.ngayTao)),
            if (widget.nhanVien.ngayCapNhat != null)
              _buildInfoRow('Ngày cập nhật', _formatDate(widget.nhanVien.ngayCapNhat!)),
            _buildInfoRow('ID', widget.nhanVien.id.toString()),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
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
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _navigateToEdit,
            icon: const Icon(Icons.edit),
            label: const Text('Chỉnh sửa'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _toggleStatus,
            icon: Icon(
              widget.nhanVien.trangThai == 'HoatDong' 
                  ? Icons.pause 
                  : Icons.play_arrow,
            ),
            label: Text(
              widget.nhanVien.trangThai == 'HoatDong' 
                  ? 'Tạm khóa' 
                  : 'Kích hoạt',
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.nhanVien.trangThai == 'HoatDong' 
                  ? Colors.orange 
                  : Colors.green,
              foregroundColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  void _navigateToEdit() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ManHinhChinhSuaNhanVien(nhanVien: widget.nhanVien),
      ),
    );

    if (result == true) {
      // Refresh data if needed
      Navigator.of(context).pop(true);
    }
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'toggle_status':
        _toggleStatus();
        break;
      case 'delete':
        _showDeleteConfirmation();
        break;
    }
  }

  void _toggleStatus() async {
    final newStatus = widget.nhanVien.trangThai == 'HoatDong' ? 'TamKhoa' : 'HoatDong';
    
    setState(() {
      _isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final apiService = ApiService();
      final authService = AuthService(apiService, prefs);
      
      final token = await authService.getCurrentToken();
      if (token != null) {
        apiService.setToken(token);
      }
      
      final nhanVienService = NhanVienService(apiService);
      final success = await nhanVienService.capNhatTrangThai(widget.nhanVien.id, newStatus);
      
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              newStatus == 'HoatDong' 
                  ? 'Đã kích hoạt nhân viên' 
                  : 'Đã tạm khóa nhân viên',
            ),
            backgroundColor: AppTheme.successColor,
          ),
        );
        Navigator.of(context).pop(true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Không thể cập nhật trạng thái'),
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

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text('Bạn có chắc chắn muốn xóa nhân viên "${widget.nhanVien.hoTen}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deleteEmployee();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
  }

  void _deleteEmployee() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final apiService = ApiService();
      final authService = AuthService(apiService, prefs);
      
      final token = await authService.getCurrentToken();
      if (token != null) {
        apiService.setToken(token);
      }
      
      final response = await apiService.delete('/NhanVien/${widget.nhanVien.id}');
      
      if (response.statusCode == 204) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đã xóa nhân viên ${widget.nhanVien.hoTen}'),
            backgroundColor: AppTheme.successColor,
          ),
        );
        Navigator.of(context).pop(true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Không thể xóa nhân viên'),
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

  String _formatCurrency(double amount) {
    return '${amount.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    )} VNĐ';
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
