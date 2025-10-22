import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../config/theme.dart';
import '../../services/api_service.dart';
import '../../services/bao_cao_service.dart';
import '../../models/bao_cao_response.dart';

class ManHinhBaoCaoManager extends StatefulWidget {
  const ManHinhBaoCaoManager({super.key});

  @override
  State<ManHinhBaoCaoManager> createState() => _ManHinhBaoCaoManagerState();
}

class _ManHinhBaoCaoManagerState extends State<ManHinhBaoCaoManager> {
  late BaoCaoService _baoCaoService;
  BaoCaoResponse? _baoCao;
  bool _isLoading = true;
  String _loaiBaoCao = 'tuan'; // tuan, thang, quy, nam
  DateTime _ngayChon = DateTime.now();

  @override
  void initState() {
    super.initState();
    _initServices();
  }

  Future<void> _initServices() async {
    final apiService = ApiService();
    _baoCaoService = BaoCaoService(apiService);
    
    await _loadBaoCao();
  }

  Future<void> _loadBaoCao() async {
    if (!mounted) return;
    
    setState(() {
      _isLoading = true;
    });

    try {
      BaoCaoResponse baoCao;
      
      switch (_loaiBaoCao) {
        case 'tuan':
          baoCao = await _baoCaoService.layBaoCaoTuan(
            nhanVienId: null,
            ngayBatDau: _ngayChon,
          );
          break;
        case 'thang':
          baoCao = await _baoCaoService.layBaoCaoThang(
            nhanVienId: null,
            thang: _ngayChon.month,
            nam: _ngayChon.year,
          );
          break;
        case 'quy':
          baoCao = await _baoCaoService.layBaoCaoQuy(
            nhanVienId: null,
            quy: ((_ngayChon.month - 1) ~/ 3) + 1,
            nam: _ngayChon.year,
          );
          break;
        case 'nam':
          baoCao = await _baoCaoService.layBaoCaoNam(
            nhanVienId: null,
            nam: _ngayChon.year,
          );
          break;
        default:
          throw Exception('Loại báo cáo không hợp lệ');
      }

      if (!mounted) return;
      
      setState(() {
        _baoCao = baoCao;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi tải báo cáo: $e')),
        );
      }
    }
  }

  String _getTitleBaoCao() {
    switch (_loaiBaoCao) {
      case 'tuan':
        return 'Báo Cáo Tuần';
      case 'thang':
        return 'Báo Cáo Tháng ${_ngayChon.month}/${_ngayChon.year}';
      case 'quy':
        final quy = ((_ngayChon.month - 1) ~/ 3) + 1;
        return 'Báo Cáo Quý $quy/${_ngayChon.year}';
      case 'nam':
        return 'Báo Cáo Năm ${_ngayChon.year}';
      default:
        return 'Báo Cáo';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitleBaoCao()),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadBaoCao,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadBaoCao,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
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
                    
                    // Danh sách điểm danh
                    _buildAttendanceList(),
                  ],
                ),
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
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Loại Báo Cáo',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              value: _loaiBaoCao,
              items: const [
                DropdownMenuItem(value: 'tuan', child: Text('Tuần')),
                DropdownMenuItem(value: 'thang', child: Text('Tháng')),
                DropdownMenuItem(value: 'quy', child: Text('Quý')),
                DropdownMenuItem(value: 'nam', child: Text('Năm')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _loaiBaoCao = value;
                  });
                  _loadBaoCao();
                }
              },
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.calendar_today),
                    label: Text(DateFormat('dd/MM/yyyy').format(_ngayChon)),
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _ngayChon,
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) {
                        setState(() {
                          _ngayChon = picked;
                        });
                        _loadBaoCao();
                      }
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
    final thongKe = _baoCao?.thongKe;
    
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
                    'Tổng Số Ngày',
                    thongKe?.tongSoNgayLamViec.toString() ?? '0',
                    Icons.calendar_today,
                    AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildStatCard(
                    'Ngày Đi Làm',
                    thongKe?.soNgayDiLam.toString() ?? '0',
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
                    thongKe?.soLanDiMuon.toString() ?? '0',
                    Icons.schedule,
                    Colors.orange,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildStatCard(
                    'Về Sớm',
                    thongKe?.soLanVeSom.toString() ?? '0',
                    Icons.exit_to_app,
                    Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Divider(color: Colors.grey[300]),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildInfoItem(
                  'Tổng Giờ Làm',
                  '${(thongKe?.tongGioLam ?? 0).toStringAsFixed(1)} giờ',
                  Icons.access_time,
                ),
                _buildInfoItem(
                  'Tỷ Lệ Đi Làm',
                  '${(thongKe?.tyLeDiLam ?? 0).toStringAsFixed(1)}%',
                  Icons.trending_up,
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

  Widget _buildInfoItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppTheme.primaryColor),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildAttendanceList() {
    final danhSach = _baoCao?.danhSachDiemDanh ?? [];
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Chi Tiết Điểm Danh (${danhSach.length} bản ghi)',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (danhSach.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Column(
                    children: [
                      Icon(Icons.event_busy, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'Chưa có dữ liệu điểm danh',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: danhSach.length,
                itemBuilder: (context, index) {
                  final item = danhSach[index];
                  return _buildAttendanceCard(item);
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceCard(DiemDanhDto diemDanh) {
    final gioVao = diemDanh.gioVao;
    final gioRa = diemDanh.gioRa;
    
    // Calculate hours worked
    double soGioLam = 0;
    if (gioVao != null && gioRa != null) {
      soGioLam = gioRa.difference(gioVao).inMinutes / 60.0;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppTheme.primaryColor.withOpacity(0.2),
          child: Text(
            diemDanh.hoTenNhanVien.substring(0, 1).toUpperCase(),
            style: const TextStyle(
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          diemDanh.hoTenNhanVien,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Ngày: ${DateFormat('dd/MM/yyyy').format(diemDanh.ngay)}'),
            Text('Vào: ${DateFormat('HH:mm').format(gioVao)} | Ra: ${gioRa != null ? DateFormat('HH:mm').format(gioRa) : 'Chưa ra'}'),
          ],
        ),
        trailing: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${soGioLam.toStringAsFixed(1)}h',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              diemDanh.trangThai,
              style: TextStyle(
                fontSize: 10,
                color: _getTrangThaiColor(diemDanh.trangThai),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getTrangThaiColor(String? trangThai) {
    switch (trangThai) {
      case 'DungGio':
        return Colors.green;
      case 'DiMuon':
        return Colors.orange;
      case 'VeSom':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
