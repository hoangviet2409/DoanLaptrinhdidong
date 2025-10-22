import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/theme.dart';
import '../../models/luong_response.dart';
import '../../services/api_service.dart';
import '../../services/auth_service.dart';
import '../../services/luong_service.dart';

class ManHinhLuong extends StatefulWidget {
  const ManHinhLuong({super.key});

  @override
  State<ManHinhLuong> createState() => _ManHinhLuongState();
}

class _ManHinhLuongState extends State<ManHinhLuong> {
  List<LuongDto> _danhSachLuong = [];
  bool _isLoading = false;
  String? _errorMessage;
  final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');

  @override
  void initState() {
    super.initState();
    _loadDanhSachLuong();
  }

  Future<void> _loadDanhSachLuong() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final apiService = ApiService();
      final authService = AuthService(apiService, prefs);
      
      final token = await authService.getCurrentToken();
      if (token != null) {
        apiService.setToken(token);
      }

      final luongService = LuongService(apiService);
      final response = await luongService.layLichSuLuongCaNhan();
      
      if (response.thanhCong) {
        setState(() {
          _danhSachLuong = response.danhSachLuong;
        });
      } else {
        setState(() {
          _errorMessage = response.thongBao;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lương'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadDanhSachLuong,
            tooltip: 'Làm mới',
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              style: const TextStyle(fontSize: 16, color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _loadDanhSachLuong,
              icon: const Icon(Icons.refresh),
              label: const Text('Thử lại'),
            ),
          ],
        ),
      );
    }

    if (_danhSachLuong.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.money_off, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Chưa có dữ liệu lương',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadDanhSachLuong,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _danhSachLuong.length,
        itemBuilder: (context, index) {
          final luong = _danhSachLuong[index];
          return _buildLuongCard(luong);
        },
      ),
    );
  }

  Widget _buildLuongCard(LuongDto luong) {
    final isPaid = luong.trangThai == 'DaTra';
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _showLuongDetail(luong),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '${luong.loaiKy == 'Tuan' ? 'Tuần' : 'Tháng'} ${DateFormat('dd/MM/yyyy').format(luong.ngayBatDau)} - ${DateFormat('dd/MM/yyyy').format(luong.ngayKetThuc)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isPaid ? Colors.green[100] : Colors.orange[100],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      isPaid ? 'Đã thanh toán' : 'Chưa thanh toán',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isPaid ? Colors.green[800] : Colors.orange[800],
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(height: 24),
              
              // Chi tiết
              _buildDetailRow('Tổng giờ làm', '${luong.tongGioLam.toStringAsFixed(1)} giờ', Icons.access_time),
              const SizedBox(height: 8),
              _buildDetailRow('Lương giờ', currencyFormat.format(luong.luongGio), Icons.attach_money),
              const SizedBox(height: 8),
              _buildDetailRow('Tổng tiền', currencyFormat.format(luong.tongTien), Icons.money),
              
              if (luong.thuong != null && luong.thuong! > 0) ...[
                const SizedBox(height: 8),
                _buildDetailRow('Thưởng', '+${currencyFormat.format(luong.thuong)}', Icons.card_giftcard, Colors.green),
              ],
              
              if (luong.truLuong != null && luong.truLuong! > 0) ...[
                const SizedBox(height: 8),
                _buildDetailRow('Khấu trừ', '-${currencyFormat.format(luong.truLuong)}', Icons.remove_circle, Colors.red),
              ],
              
              const Divider(height: 24),
              
              // Tổng cộng
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Tổng cộng',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    currencyFormat.format(luong.tongCong),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
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

  Widget _buildDetailRow(String label, String value, IconData icon, [Color? color]) {
    return Row(
      children: [
        Icon(icon, size: 20, color: color ?? Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: color ?? Colors.black87,
          ),
        ),
      ],
    );
  }

  void _showLuongDetail(LuongDto luong) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Chi tiết lương'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDialogRow('Loại kỳ', luong.loaiKy == 'Tuan' ? 'Tuần' : 'Tháng'),
              const Divider(),
              _buildDialogRow('Từ ngày', DateFormat('dd/MM/yyyy').format(luong.ngayBatDau)),
              _buildDialogRow('Đến ngày', DateFormat('dd/MM/yyyy').format(luong.ngayKetThuc)),
              const Divider(),
              _buildDialogRow('Tổng giờ làm', '${luong.tongGioLam.toStringAsFixed(1)} giờ'),
              _buildDialogRow('Lương giờ', currencyFormat.format(luong.luongGio)),
              _buildDialogRow('Tổng tiền', currencyFormat.format(luong.tongTien)),
              if (luong.thuong != null && luong.thuong! > 0)
                _buildDialogRow('Thưởng', '+${currencyFormat.format(luong.thuong)}'),
              if (luong.truLuong != null && luong.truLuong! > 0)
                _buildDialogRow('Khấu trừ', '-${currencyFormat.format(luong.truLuong)}'),
              const Divider(),
              _buildDialogRow('Tổng cộng', currencyFormat.format(luong.tongCong), isBold: true),
              const Divider(),
              _buildDialogRow('Trạng thái', luong.trangThai == 'DaTra' ? 'Đã thanh toán' : 'Chưa thanh toán'),
              _buildDialogRow('Ngày tạo', DateFormat('dd/MM/yyyy HH:mm').format(luong.ngayTao)),
              if (luong.ngayThanhToan != null)
                _buildDialogRow('Ngày thanh toán', DateFormat('dd/MM/yyyy HH:mm').format(luong.ngayThanhToan!)),
              if (luong.ghiChu != null && luong.ghiChu!.isNotEmpty) ...[
                const Divider(),
                const Text('Ghi chú:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(luong.ghiChu!),
              ],
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

  Widget _buildDialogRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[700],
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

