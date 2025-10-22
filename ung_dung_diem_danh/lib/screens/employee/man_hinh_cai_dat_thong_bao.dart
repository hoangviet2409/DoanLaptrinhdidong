import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/theme.dart';

class ManHinhCaiDatThongBao extends StatefulWidget {
  const ManHinhCaiDatThongBao({super.key});

  @override
  State<ManHinhCaiDatThongBao> createState() => _ManHinhCaiDatThongBaoState();
}

class _ManHinhCaiDatThongBaoState extends State<ManHinhCaiDatThongBao> {
  bool _thongBaoDiemDanh = true;
  bool _thongBaoLuong = true;
  bool _thongBaoHeThong = true;
  bool _thongBaoNhacNho = true;
  bool _amThanh = true;
  bool _rung = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    setState(() => _isLoading = true);
    
    try {
      final prefs = await SharedPreferences.getInstance();
      if (mounted) {
        setState(() {
          _thongBaoDiemDanh = prefs.getBool('notif_diem_danh') ?? true;
          _thongBaoLuong = prefs.getBool('notif_luong') ?? true;
          _thongBaoHeThong = prefs.getBool('notif_he_thong') ?? true;
          _thongBaoNhacNho = prefs.getBool('notif_nhac_nho') ?? true;
          _amThanh = prefs.getBool('notif_am_thanh') ?? true;
          _rung = prefs.getBool('notif_rung') ?? true;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('notif_diem_danh', _thongBaoDiemDanh);
      await prefs.setBool('notif_luong', _thongBaoLuong);
      await prefs.setBool('notif_he_thong', _thongBaoHeThong);
      await prefs.setBool('notif_nhac_nho', _thongBaoNhacNho);
      await prefs.setBool('notif_am_thanh', _amThanh);
      await prefs.setBool('notif_rung', _rung);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đã lưu cài đặt thông báo'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cài Đặt Thông Báo'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveSettings,
            tooltip: 'Lưu cài đặt',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Header
                _buildHeader(),
                const SizedBox(height: 24),

                // Loại thông báo
                _buildSection(
                  title: 'Loại Thông Báo',
                  icon: Icons.notifications_active,
                  children: [
                    _buildSwitchTile(
                      title: 'Điểm danh',
                      subtitle: 'Nhận thông báo về điểm danh',
                      value: _thongBaoDiemDanh,
                      onChanged: (value) {
                        setState(() => _thongBaoDiemDanh = value);
                      },
                      icon: Icons.access_time,
                    ),
                    _buildSwitchTile(
                      title: 'Lương',
                      subtitle: 'Nhận thông báo về lương và thưởng',
                      value: _thongBaoLuong,
                      onChanged: (value) {
                        setState(() => _thongBaoLuong = value);
                      },
                      icon: Icons.attach_money,
                    ),
                    _buildSwitchTile(
                      title: 'Hệ thống',
                      subtitle: 'Nhận thông báo từ hệ thống',
                      value: _thongBaoHeThong,
                      onChanged: (value) {
                        setState(() => _thongBaoHeThong = value);
                      },
                      icon: Icons.info,
                    ),
                    _buildSwitchTile(
                      title: 'Nhắc nhở',
                      subtitle: 'Nhắc nhở điểm danh, công việc',
                      value: _thongBaoNhacNho,
                      onChanged: (value) {
                        setState(() => _thongBaoNhacNho = value);
                      },
                      icon: Icons.alarm,
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Cài đặt âm thanh
                _buildSection(
                  title: 'Âm Thanh & Rung',
                  icon: Icons.volume_up,
                  children: [
                    _buildSwitchTile(
                      title: 'Âm thanh',
                      subtitle: 'Phát âm thanh khi có thông báo',
                      value: _amThanh,
                      onChanged: (value) {
                        setState(() => _amThanh = value);
                      },
                      icon: Icons.music_note,
                    ),
                    _buildSwitchTile(
                      title: 'Rung',
                      subtitle: 'Rung khi có thông báo',
                      value: _rung,
                      onChanged: (value) {
                        setState(() => _rung = value);
                      },
                      icon: Icons.vibration,
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Lưu ý
                _buildNotice(),
              ],
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
              Icons.notifications,
              size: 48,
              color: AppTheme.primaryColor,
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quản lý thông báo',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Tùy chỉnh các loại thông báo bạn muốn nhận',
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

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: AppTheme.primaryColor),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Card(
          elevation: 2,
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required IconData icon,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: value
            ? AppTheme.primaryColor.withOpacity(0.1)
            : Colors.grey.shade100,
        child: Icon(
          icon,
          color: value ? AppTheme.primaryColor : Colors.grey,
        ),
      ),
      title: Text(title),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey.shade600,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppTheme.primaryColor,
      ),
    );
  }

  Widget _buildNotice() {
    return Card(
      color: Colors.amber.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.lightbulb_outline,
              color: Colors.amber.shade700,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Lưu ý',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber.shade900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Để nhận được thông báo, vui lòng cấp quyền thông báo cho ứng dụng trong cài đặt hệ thống.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.amber.shade900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Nhấn nút "Lưu" trên thanh AppBar để lưu các thay đổi.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.amber.shade900,
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
}

