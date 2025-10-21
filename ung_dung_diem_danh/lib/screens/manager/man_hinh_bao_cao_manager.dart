import 'package:flutter/material.dart';
import '../../config/theme.dart';

class ManHinhBaoCaoManager extends StatelessWidget {
  const ManHinhBaoCaoManager({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Báo Cáo Phòng Ban'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              // TODO: Export report
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bộ lọc thời gian
            _buildTimeFilter(),
            const SizedBox(height: 20),
            
            // Thống kê tổng quan
            _buildOverviewStats(),
            const SizedBox(height: 20),
            
            // Biểu đồ chấm công
            _buildAttendanceChart(),
            const SizedBox(height: 20),
            
            // Báo cáo chi tiết
            _buildDetailedReports(),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeFilter() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bộ Lọc Thời Gian',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Khoảng Thời Gian',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'today', child: Text('Hôm Nay')),
                      DropdownMenuItem(value: 'week', child: Text('Tuần Này')),
                      DropdownMenuItem(value: 'month', child: Text('Tháng Này')),
                      DropdownMenuItem(value: 'quarter', child: Text('Quý Này')),
                      DropdownMenuItem(value: 'year', child: Text('Năm Này')),
                    ],
                    onChanged: (value) {
                      // TODO: Filter by time period
                    },
                  ),
                ),
                const SizedBox(width: 8),
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
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewStats() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Thống Kê Tổng Quan',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                    'Tỷ Lệ Có Mặt',
                    '0%',
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

  Widget _buildAttendanceChart() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Biểu Đồ Chấm Công',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Center(
              child: Column(
                children: [
                  Icon(Icons.bar_chart, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Biểu đồ sẽ hiển thị khi có dữ liệu',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailedReports() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Báo Cáo Chi Tiết',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildReportItem(
              'Báo Cáo Chấm Công Hàng Ngày',
              'Xem chi tiết chấm công của từng nhân viên',
              Icons.access_time,
              () {
                // TODO: Navigate to daily attendance report
              },
            ),
            _buildReportItem(
              'Báo Cáo Tổng Hợp Tháng',
              'Thống kê chấm công theo tháng',
              Icons.calendar_month,
              () {
                // TODO: Navigate to monthly report
              },
            ),
            _buildReportItem(
              'Báo Cáo Nhân Viên Vắng Mặt',
              'Danh sách nhân viên vắng mặt và lý do',
              Icons.person_off,
              () {
                // TODO: Navigate to absence report
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportItem(String title, String subtitle, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
        child: Icon(icon, color: AppTheme.primaryColor),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
