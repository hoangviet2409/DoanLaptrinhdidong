import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../services/api_service.dart';
import '../../services/nhan_vien_service.dart';
import '../../models/nhan_vien_model.dart';
import '../admin/man_hinh_chi_tiet_nhan_vien.dart';

class ManHinhQuanLyNhanVienManager extends StatefulWidget {
  const ManHinhQuanLyNhanVienManager({super.key});

  @override
  State<ManHinhQuanLyNhanVienManager> createState() => _ManHinhQuanLyNhanVienManagerState();
}

class _ManHinhQuanLyNhanVienManagerState extends State<ManHinhQuanLyNhanVienManager> {
  late NhanVienService _nhanVienService;
  List<NhanVienModel> _danhSachNhanVien = [];
  List<NhanVienModel> _danhSachNhanVienFiltered = [];
  bool _isLoading = true;
  String _searchQuery = '';
  String? _selectedPhongBan;
  String? _selectedTrangThai;

  @override
  void initState() {
    super.initState();
    _initServices();
  }

  Future<void> _initServices() async {
    final apiService = ApiService();
    _nhanVienService = NhanVienService(apiService);
    
    await _loadData();
  }

  Future<void> _loadData() async {
    if (!mounted) return;
    
    setState(() {
      _isLoading = true;
    });

    try {
      final danhSach = await _nhanVienService.layDanhSachNhanVien();
      if (!mounted) return;
      
      setState(() {
        _danhSachNhanVien = danhSach;
        _applyFilters();
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi tải dữ liệu: $e')),
        );
      }
    }
  }

  void _applyFilters() {
    var filtered = _danhSachNhanVien.where((nv) {
      // Search filter
      if (_searchQuery.isNotEmpty) {
        final searchLower = _searchQuery.toLowerCase();
        final matchesSearch = 
            nv.hoTen?.toLowerCase().contains(searchLower) == true ||
            nv.email?.toLowerCase().contains(searchLower) == true ||
            nv.maNhanVien?.toString().contains(searchLower) == true;
        if (!matchesSearch) return false;
      }

      // Department filter
      if (_selectedPhongBan != null && _selectedPhongBan != 'all') {
        if (nv.phongBan != _selectedPhongBan) return false;
      }

      // Status filter
      if (_selectedTrangThai != null && _selectedTrangThai != 'all') {
        if (_selectedTrangThai == 'active' && nv.trangThai != 'HoatDong') return false;
        if (_selectedTrangThai == 'inactive' && nv.trangThai == 'HoatDong') return false;
      }

      return true;
    }).toList();

    setState(() {
      _danhSachNhanVienFiltered = filtered;
    });
  }

  List<String> _layDanhSachPhongBan() {
    final phongBans = <String>{};
    for (var nv in _danhSachNhanVien) {
      if (nv.phongBan != null && nv.phongBan!.isNotEmpty) {
        phongBans.add(nv.phongBan!);
      }
    }
    return phongBans.toList();
  }

  int get _tongNhanVien => _danhSachNhanVien.length;
  int get _nhanVienCoMat => _danhSachNhanVien.where((nv) => nv.trangThai == 'HoatDong').length;
  int get _nhanVienVangMat => _tongNhanVien - _nhanVienCoMat;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản Lý Nhân Viên'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Thống kê phòng ban
                    _buildDepartmentStats(),
                    const SizedBox(height: 20),
                    
                    // Search bar
                    _buildSearchBar(),
                    const SizedBox(height: 12),
                    
                    // Bộ lọc
                    _buildFilters(),
                    const SizedBox(height: 20),
                    
                    // Danh sách nhân viên
                    _buildEmployeeList(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildDepartmentStats() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Thống Kê Phòng Ban',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Tổng Nhân Viên',
                    _tongNhanVien.toString(),
                    Icons.people,
                    AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildStatCard(
                    'Hoạt Động',
                    _nhanVienCoMat.toString(),
                    Icons.check_circle,
                    Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Tạm Khóa',
                    _nhanVienVangMat.toString(),
                    Icons.block,
                    Colors.orange,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildStatCard(
                    'Đang Hiển Thị',
                    _danhSachNhanVienFiltered.length.toString(),
                    Icons.filter_list,
                    Colors.blue,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 10,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Tìm kiếm nhân viên...',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: _searchQuery.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  setState(() {
                    _searchQuery = '';
                    _applyFilters();
                  });
                },
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.grey[100],
      ),
      onChanged: (value) {
        setState(() {
          _searchQuery = value;
          _applyFilters();
        });
      },
    );
  }

  Widget _buildFilters() {
    final phongBans = _layDanhSachPhongBan();
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bộ Lọc',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Phòng Ban',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    value: _selectedPhongBan,
                    items: [
                      const DropdownMenuItem(value: 'all', child: Text('Tất Cả')),
                      ...phongBans.map((pb) => DropdownMenuItem(value: pb, child: Text(pb))),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedPhongBan = value;
                        _applyFilters();
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Trạng Thái',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    value: _selectedTrangThai,
                    items: const [
                      DropdownMenuItem(value: 'all', child: Text('Tất Cả')),
                      DropdownMenuItem(value: 'active', child: Text('Hoạt Động')),
                      DropdownMenuItem(value: 'inactive', child: Text('Tạm Khóa')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedTrangThai = value;
                        _applyFilters();
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
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
                Text(
                  'Danh Sách Nhân Viên (${_danhSachNhanVienFiltered.length})',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_danhSachNhanVienFiltered.isEmpty)
              const Center(
                child: Column(
                  children: [
                    Icon(Icons.people_outline, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'Không tìm thấy nhân viên',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _danhSachNhanVienFiltered.length,
                itemBuilder: (context, index) {
                  final nhanVien = _danhSachNhanVienFiltered[index];
                  return _buildEmployeeCard(nhanVien);
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmployeeCard(NhanVienModel nhanVien) {
    final isActive = nhanVien.trangThai == 'HoatDong';
    
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isActive 
              ? Colors.green.withOpacity(0.2) 
              : Colors.orange.withOpacity(0.2),
          child: Text(
            nhanVien.hoTen?.substring(0, 1).toUpperCase() ?? 'N',
            style: TextStyle(
              color: isActive ? Colors.green : Colors.orange,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          nhanVien.hoTen ?? 'N/A',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Mã NV: ${nhanVien.maNhanVien ?? 'N/A'}'),
            Text('${nhanVien.phongBan ?? 'N/A'} - ${nhanVien.chucVu ?? 'N/A'}'),
          ],
        ),
        trailing: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isActive 
                    ? Colors.green.withOpacity(0.2) 
                    : Colors.orange.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                isActive ? 'Hoạt động' : 'Tạm khóa',
                style: TextStyle(
                  fontSize: 10,
                  color: isActive ? Colors.green : Colors.orange,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ManHinhChiTietNhanVien(nhanVien: nhanVien),
            ),
          ).then((_) => _loadData()); // Reload after returning
        },
      ),
    );
  }
}
