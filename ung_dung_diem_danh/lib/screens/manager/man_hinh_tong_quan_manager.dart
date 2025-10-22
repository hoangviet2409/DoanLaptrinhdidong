import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_state.dart';
import '../../config/theme.dart';
import '../../services/api_service.dart';
import '../../services/nhan_vien_service.dart';
import '../../models/nhan_vien_model.dart';

class ManHinhTongQuanManager extends StatefulWidget {
  final Function(int)? onTabChange;
  
  const ManHinhTongQuanManager({
    super.key,
    this.onTabChange,
  });

  @override
  State<ManHinhTongQuanManager> createState() => _ManHinhTongQuanManagerState();
}

class _ManHinhTongQuanManagerState extends State<ManHinhTongQuanManager> {
  late NhanVienService _nhanVienService;
  List<NhanVienModel> _danhSachNhanVien = [];
  bool _isLoading = true;

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

  int get _tongNhanVien => _danhSachNhanVien.length;
  int get _nhanVienHoatDong => _danhSachNhanVien.where((nv) => nv.trangThai == 'HoatDong').length;
  int get _nhanVienTamKhoa => _danhSachNhanVien.where((nv) => nv.trangThai != 'HoatDong').length;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final user = state is AuthAuthenticated ? state.user : null;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Tổng Quan Quản Lý'),
            backgroundColor: AppTheme.primaryColor,
            foregroundColor: Colors.white,
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: _loadData,
              ),
            ],
          ),
          body: user == null
              ? const Center(child: CircularProgressIndicator())
              : _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : RefreshIndicator(
                      onRefresh: _loadData,
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Welcome Card
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              const CircleAvatar(
                                radius: 30,
                                backgroundColor: AppTheme.primaryColor,
                                child: Icon(
                                  Icons.manage_accounts,
                                  size: 30,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Xin chào, ${user.hoTen}',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Quản Lý Phòng Ban',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                        // Thống kê nhanh
                        const Text(
                          'Thống Kê Phòng Ban',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
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
                                _nhanVienHoatDong.toString(),
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
                                _nhanVienTamKhoa.toString(),
                                Icons.block,
                                Colors.orange,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _buildStatCard(
                                'Phòng Ban',
                                _layDanhSachPhongBan().length.toString(),
                                Icons.business,
                                Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(height: 20),

                      // Chức năng chính
                      const Text(
                        'Chức Năng Chính',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                        _buildMenuItem(
                          context,
                          icon: Icons.people,
                          title: 'Quản Lý Nhân Viên',
                          subtitle: 'Xem và quản lý $_tongNhanVien nhân viên',
                          onTap: () {
                            // Switch to tab 1 (Employee Management)
                            widget.onTabChange?.call(1);
                          },
                        ),
                        _buildMenuItem(
                          context,
                          icon: Icons.analytics,
                          title: 'Báo Cáo Phòng Ban',
                          subtitle: 'Xem thống kê và báo cáo chấm công',
                          onTap: () {
                            // Switch to tab 2 (Reports)
                            widget.onTabChange?.call(2);
                          },
                        ),
                        _buildMenuItem(
                          context,
                          icon: Icons.business,
                          title: 'Thông Tin Phòng Ban',
                          subtitle: 'Xem thông tin và phân bổ nhân sự',
                          onTap: () {
                            _showPhongBanInfo(context);
                          },
                        ),
                      ],
                    ),
                  ),
                      ),
        );
      },
    );
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

  void _showPhongBanInfo(BuildContext context) {
    final phongBans = _layDanhSachPhongBan();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.business, color: AppTheme.primaryColor),
            const SizedBox(width: 8),
            const Text('Thông Tin Phòng Ban'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (phongBans.isEmpty)
                const Text(
                  'Chưa có phân chia phòng ban',
                  style: TextStyle(color: Colors.grey),
                )
              else
                ...phongBans.map((phongBan) {
                  final soNhanVien = _danhSachNhanVien
                      .where((nv) => nv.phongBan == phongBan)
                      .length;
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                        child: Text(
                          phongBan[0].toUpperCase(),
                          style: TextStyle(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(phongBan),
                      subtitle: Text('$soNhanVien nhân viên'),
                      trailing: Icon(
                        Icons.people,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  );
                }),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
          child: Icon(icon, color: AppTheme.primaryColor),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
