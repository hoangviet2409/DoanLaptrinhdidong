import 'package:flutter/material.dart';
import '../../config/theme.dart';

class ManHinhHuongDanSuDung extends StatelessWidget {
  const ManHinhHuongDanSuDung({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hướng Dẫn Sử Dụng'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header
          _buildHeader(),
          const SizedBox(height: 24),

          // Hướng dẫn điểm danh
          _buildGuideSection(
            title: '1. Điểm Danh',
            icon: Icons.access_time,
            color: Colors.blue,
            steps: [
              GuideStep(
                title: 'Điểm danh vào',
                description:
                    'Vào tab "Chấm Công" và nhấn nút "Điểm danh vào" khi bắt đầu làm việc. Hệ thống sẽ tự động lấy vị trí GPS của bạn.',
                icon: Icons.login,
              ),
              GuideStep(
                title: 'Điểm danh ra',
                description:
                    'Khi kết thúc ca làm, nhấn nút "Điểm danh ra". Hệ thống sẽ tính toán giờ làm việc của bạn.',
                icon: Icons.logout,
              ),
              GuideStep(
                title: 'Xem lịch sử',
                description:
                    'Vào tab "Lịch Sử" để xem chi tiết các lần điểm danh của bạn theo ngày, tuần, tháng.',
                icon: Icons.history,
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Hướng dẫn xem lương
          _buildGuideSection(
            title: '2. Xem Lương',
            icon: Icons.attach_money,
            color: Colors.green,
            steps: [
              GuideStep(
                title: 'Truy cập màn hình lương',
                description:
                    'Từ Trang Chủ, nhấn vào "Lương" hoặc vào tab "Hồ Sơ" → chọn "Lương".',
                icon: Icons.open_in_new,
              ),
              GuideStep(
                title: 'Xem chi tiết',
                description:
                    'Danh sách hiển thị lịch sử lương theo tháng, bao gồm lương cơ bản, thưởng, phạt và trạng thái thanh toán.',
                icon: Icons.receipt_long,
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Hướng dẫn cập nhật thông tin
          _buildGuideSection(
            title: '3. Quản Lý Tài Khoản',
            icon: Icons.person,
            color: Colors.orange,
            steps: [
              GuideStep(
                title: 'Xem hồ sơ',
                description:
                    'Vào tab "Hồ Sơ" để xem thông tin cá nhân, email, số điện thoại, phòng ban, chức vụ.',
                icon: Icons.badge,
              ),
              GuideStep(
                title: 'Chỉnh sửa thông tin',
                description:
                    'Nhấn "Chỉnh sửa thông tin" để cập nhật số điện thoại. Các thông tin khác cần liên hệ Admin.',
                icon: Icons.edit,
              ),
              GuideStep(
                title: 'Đổi mật khẩu',
                description:
                    'Nhấn "Bảo mật" → "Đổi mật khẩu". Nhập mật khẩu cũ và mật khẩu mới (tối thiểu 6 ký tự).',
                icon: Icons.security,
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Hướng dẫn thông báo
          _buildGuideSection(
            title: '4. Cài Đặt Thông Báo',
            icon: Icons.notifications,
            color: Colors.purple,
            steps: [
              GuideStep(
                title: 'Tùy chỉnh thông báo',
                description:
                    'Vào "Hồ Sơ" → "Thông báo" để bật/tắt các loại thông báo: điểm danh, lương, hệ thống, nhắc nhở.',
                icon: Icons.tune,
              ),
              GuideStep(
                title: 'Âm thanh và rung',
                description:
                    'Bật/tắt âm thanh và rung cho thông báo theo ý muốn. Nhấn "Lưu" để áp dụng thay đổi.',
                icon: Icons.volume_up,
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Tips & Tricks
          _buildTipsSection(),
          const SizedBox(height: 20),

          // Liên hệ hỗ trợ
          _buildSupportSection(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Card(
      color: AppTheme.primaryColor.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Icon(
              Icons.help_outline,
              size: 56,
              color: AppTheme.primaryColor,
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Chào mừng!',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Hướng dẫn sử dụng ứng dụng điểm danh nhân viên một cách đơn giản và hiệu quả.',
                    style: TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuideSection({
    required String title,
    required IconData icon,
    required Color color,
    required List<GuideStep> steps,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: color.withOpacity(0.1),
                  child: Icon(icon, color: color),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...steps.asMap().entries.map((entry) {
              final index = entry.key;
              final step = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildStepItem(
                  step: step,
                  number: index + 1,
                  color: color,
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildStepItem({
    required GuideStep step,
    required int number,
    required Color color,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            step.icon,
            size: 18,
            color: color,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                step.title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                step.description,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTipsSection() {
    return Card(
      color: Colors.amber.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.lightbulb, color: Colors.amber.shade700),
                const SizedBox(width: 8),
                Text(
                  'Mẹo Hữu Ích',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber.shade900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildTipItem('Điểm danh đúng giờ để tránh bị ghi nhận muộn'),
            _buildTipItem('Kiểm tra vị trí GPS trước khi điểm danh'),
            _buildTipItem('Xem lịch sử điểm danh thường xuyên để theo dõi'),
            _buildTipItem('Bật thông báo nhắc nhở để không bỏ lỡ điểm danh'),
            _buildTipItem('Cập nhật thông tin cá nhân khi có thay đổi'),
          ],
        ),
      ),
    );
  }

  Widget _buildTipItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle,
            size: 16,
            color: Colors.amber.shade700,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                color: Colors.amber.shade900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportSection() {
    return Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.support_agent, color: Colors.blue.shade700),
                const SizedBox(width: 8),
                Text(
                  'Cần Hỗ Trợ?',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Nếu bạn gặp vấn đề hoặc cần hỗ trợ thêm, vui lòng liên hệ:',
              style: TextStyle(
                fontSize: 13,
                color: Colors.blue.shade900,
              ),
            ),
            const SizedBox(height: 8),
            _buildContactItem(Icons.email, 'Email: support@company.com'),
            _buildContactItem(Icons.phone, 'Hotline: 1900-xxxx'),
            _buildContactItem(Icons.admin_panel_settings, 'Hoặc liên hệ Admin công ty'),
          ],
        ),
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.blue.shade700),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: Colors.blue.shade900,
            ),
          ),
        ],
      ),
    );
  }
}

class GuideStep {
  final String title;
  final String description;
  final IconData icon;

  GuideStep({
    required this.title,
    required this.description,
    required this.icon,
  });
}

