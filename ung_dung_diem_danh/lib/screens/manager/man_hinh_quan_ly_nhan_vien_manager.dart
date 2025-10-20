import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/auth/auth_state.dart';
import '../../config/theme.dart';

class ManHinhQuanLyNhanVienManager extends StatefulWidget {
  const ManHinhQuanLyNhanVienManager({super.key});

  @override
  State<ManHinhQuanLyNhanVienManager> createState() => _ManHinhQuanLyNhanVienManagerState();
}

class _ManHinhQuanLyNhanVienManagerState extends State<ManHinhQuanLyNhanVienManager> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản Lý Nhân Viên'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Search employees
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // TODO: Filter employees
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thống kê phòng ban
            _buildDepartmentStats(),
            const SizedBox(height: 20),
            
            // Bộ lọc
            _buildFilters(),
            const SizedBox(height: 20),
            
            // Danh sách nhân viên
            _buildEmployeeList(),
          ],
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
                    '0',
                    Icons.people,
                    AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildStatCard(
                    'Có Mặt Hôm Nay',
                    '0',
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
                    'Đi Muộn',
                    '0',
                    Icons.schedule,
                    Colors.orange,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildStatCard(
                    'Vắng Mặt',
                    '0',
                    Icons.cancel,
                    Colors.red,
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

  Widget _buildFilters() {
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
                    items: const [
                      DropdownMenuItem(value: 'all', child: Text('Tất Cả')),
                      DropdownMenuItem(value: 'it', child: Text('IT')),
                      DropdownMenuItem(value: 'hr', child: Text('Nhân Sự')),
                      DropdownMenuItem(value: 'finance', child: Text('Tài Chính')),
                    ],
                    onChanged: (value) {
                      // TODO: Filter by department
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
                    items: const [
                      DropdownMenuItem(value: 'all', child: Text('Tất Cả')),
                      DropdownMenuItem(value: 'active', child: Text('Hoạt Động')),
                      DropdownMenuItem(value: 'inactive', child: Text('Tạm Khóa')),
                    ],
                    onChanged: (value) {
                      // TODO: Filter by status
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
                const Text(
                  'Danh Sách Nhân Viên',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () {
                    // TODO: Refresh employee list
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
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
                    'Nhân viên sẽ hiển thị khi được Admin tạo',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
