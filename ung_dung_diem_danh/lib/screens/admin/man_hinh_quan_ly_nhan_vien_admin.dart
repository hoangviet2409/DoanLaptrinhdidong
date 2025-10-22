import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../models/nhan_vien_model.dart';
import '../../services/nhan_vien_service.dart';
import '../../services/api_service.dart';
import '../../services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'man_hinh_chi_tiet_nhan_vien.dart';
import 'man_hinh_tao_nhan_vien.dart';
import 'man_hinh_quan_ly_user.dart';

class ManHinhQuanLyNhanVienAdmin extends StatefulWidget {
  const ManHinhQuanLyNhanVienAdmin({super.key});

  @override
  State<ManHinhQuanLyNhanVienAdmin> createState() => _ManHinhQuanLyNhanVienAdminState();
}

class _ManHinhQuanLyNhanVienAdminState extends State<ManHinhQuanLyNhanVienAdmin> {
  List<NhanVienModel> _danhSachNhanVien = [];
  List<NhanVienModel> _filteredNhanVien = [];
  bool _isLoading = false;
  String? _errorMessage;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadDanhSachNhanVien();
    _searchController.addListener(_filterEmployees);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadDanhSachNhanVien() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final apiService = ApiService();
      final authService = AuthService(apiService, prefs);
      
      // Set token từ SharedPreferences
      final token = await authService.getCurrentToken();
      if (token != null) {
        apiService.setToken(token);
      }
      
      final nhanVienService = NhanVienService(apiService);
      final danhSach = await nhanVienService.layDanhSachNhanVien();
      
      setState(() {
        _danhSachNhanVien = danhSach;
        _filteredNhanVien = danhSach;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  void _filterEmployees() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredNhanVien = _danhSachNhanVien;
      } else {
        _filteredNhanVien = _danhSachNhanVien.where((nhanVien) {
          return nhanVien.hoTen.toLowerCase().contains(query) ||
                 nhanVien.maNhanVien.toLowerCase().contains(query) ||
                 nhanVien.email.toLowerCase().contains(query) ||
                 (nhanVien.phongBan?.toLowerCase().contains(query) ?? false) ||
                 (nhanVien.chucVu?.toLowerCase().contains(query) ?? false);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản Lý Nhân Viên'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 'create_admin') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ManHinhQuanLyUser(),
                  ),
                );
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'create_admin',
                child: Row(
                  children: [
                    Icon(Icons.admin_panel_settings, size: 20),
                    SizedBox(width: 12),
                    Text('Tạo Admin/Quản Lý'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ManHinhTaoNhanVien(),
            ),
          );
          if (result == true) {
            _loadDanhSachNhanVien();
          }
        },
        backgroundColor: AppTheme.primaryColor,
        icon: const Icon(Icons.person_add, color: Colors.white),
        label: const Text('Thêm NV', style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thống kê nhanh
            _buildStatsCards(),
            const SizedBox(height: 20),
            
            // Search bar
            _buildSearchBar(),
            const SizedBox(height: 16),
            
            // Danh sách nhân viên
            _buildEmployeeList(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Tìm kiếm theo tên, mã, email, phòng ban...',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                    },
                  )
                : null,
            border: const OutlineInputBorder(),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ),
    );
  }

  Widget _buildStatsCards() {
    final tongNhanVien = _filteredNhanVien.length;
    final dangLam = _filteredNhanVien.where((nv) => nv.trangThai == 'HoatDong').length;
    final tamKhoa = _filteredNhanVien.where((nv) => nv.trangThai == 'TamKhoa').length;

    return Row(
      children: [
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Icon(Icons.people, size: 32, color: AppTheme.primaryColor),
                  const SizedBox(height: 8),
                  const Text('Tổng Nhân Viên', style: TextStyle(fontSize: 12)),
                  Text('$tongNhanVien', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Icon(Icons.check_circle, size: 32, color: Colors.green),
                  const SizedBox(height: 8),
                  const Text('Đang Làm', style: TextStyle(fontSize: 12)),
                  Text('$dangLam', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Icon(Icons.pause_circle, size: 32, color: Colors.orange),
                  const SizedBox(height: 8),
                  const Text('Tạm Khóa', style: TextStyle(fontSize: 12)),
                  Text('$tamKhoa', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmployeeList() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Danh Sách Nhân Viên',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: _isLoading 
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.refresh),
                  onPressed: _isLoading ? null : _loadDanhSachNhanVien,
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            if (_isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (_errorMessage != null)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    children: [
                      Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                      const SizedBox(height: 16),
                      Text(
                        'Lỗi khi tải dữ liệu',
                        style: TextStyle(fontSize: 16, color: Colors.red[700]),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _errorMessage!,
                        style: TextStyle(fontSize: 12, color: Colors.red[600]),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadDanhSachNhanVien,
                        child: const Text('Thử lại'),
                      ),
                    ],
                  ),
                ),
              )
            else if (_filteredNhanVien.isEmpty)
              const Center(
                child: Column(
                  children: [
                    Icon(Icons.people_outline, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'Chưa có nhân viên nào',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    Text(
                      'Vào tab "Tạo Tài Khoản" để tạo nhân viên mới',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _filteredNhanVien.length,
                itemBuilder: (context, index) {
                  final nhanVien = _filteredNhanVien[index];
                  return _buildEmployeeCard(nhanVien);
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmployeeCard(NhanVienModel nhanVien) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: nhanVien.trangThai == 'HoatDong' 
              ? Colors.green 
              : Colors.orange,
          child: Text(
            nhanVien.maNhanVien,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
        title: Text(
          nhanVien.hoTen,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Mã: ${nhanVien.maNhanVien}'),
            Text('Email: ${nhanVien.email}'),
            if (nhanVien.phongBan != null) Text('Phòng ban: ${nhanVien.phongBan}'),
            if (nhanVien.chucVu != null) Text('Chức vụ: ${nhanVien.chucVu}'),
            Text('Lương: ${_formatCurrency(nhanVien.luongGio)}/giờ'),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: nhanVien.trangThai == 'HoatDong' 
                    ? Colors.green[100] 
                    : Colors.orange[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                nhanVien.trangThai == 'HoatDong' ? 'Hoạt động' : 'Tạm khóa',
                style: TextStyle(
                  color: nhanVien.trangThai == 'HoatDong' 
                      ? Colors.green[700] 
                      : Colors.orange[700],
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Tạo: ${_formatDate(nhanVien.ngayTao)}',
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ],
        ),
        onTap: () async {
          final result = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ManHinhChiTietNhanVien(nhanVien: nhanVien),
            ),
          );
          
          if (result == true) {
            // Refresh data if employee was updated/deleted
            _loadDanhSachNhanVien();
          }
        },
      ),
    );
  }

  String _formatCurrency(double amount) {
    return '${amount.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    )} VNĐ';
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }


}
