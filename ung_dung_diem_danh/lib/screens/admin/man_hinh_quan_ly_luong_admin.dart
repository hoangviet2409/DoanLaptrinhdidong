import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/theme.dart';
import '../../models/luong_response.dart';
import '../../models/nhan_vien_model.dart';
import '../../services/api_service.dart';
import '../../services/auth_service.dart';
import '../../services/luong_service.dart';
import '../../services/nhan_vien_service.dart';

class ManHinhQuanLyLuongAdmin extends StatefulWidget {
  const ManHinhQuanLyLuongAdmin({super.key});

  @override
  State<ManHinhQuanLyLuongAdmin> createState() => _ManHinhQuanLyLuongAdminState();
}

class _ManHinhQuanLyLuongAdminState extends State<ManHinhQuanLyLuongAdmin> {
  List<LuongDto> _danhSachLuong = [];
  List<NhanVienModel> _danhSachNhanVien = [];
  bool _isLoading = false;
  String? _errorMessage;
  NhanVienModel? _selectedNhanVien;
  final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');

  late ApiService _apiService;
  late LuongService _luongService;
  late NhanVienService _nhanVienService;

  @override
  void initState() {
    super.initState();
    _initServices();
  }

  Future<void> _initServices() async {
    final prefs = await SharedPreferences.getInstance();
    _apiService = ApiService();
    final authService = AuthService(_apiService, prefs);
    
    final token = await authService.getCurrentToken();
    if (token != null) {
      _apiService.setToken(token);
    }

    _luongService = LuongService(_apiService);
    _nhanVienService = NhanVienService(_apiService);

    await _loadDanhSachNhanVien();
  }

  Future<void> _loadDanhSachNhanVien() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final danhSach = await _nhanVienService.layDanhSachNhanVien();
      setState(() {
        _danhSachNhanVien = danhSach;
      });
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

  Future<void> _loadDanhSachLuongTheoNhanVien(int nhanVienId) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await _luongService.layDanhSachLuongTheoNhanVien(nhanVienId);
      
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
        title: const Text('Quản Lý Lương'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.calculate),
            onPressed: _showTinhLuongDialog,
            tooltip: 'Tính lương',
          ),
        ],
      ),
      body: Column(
        children: [
          _buildNhanVienSelector(),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildNhanVienSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Chọn nhân viên',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<NhanVienModel>(
            value: _selectedNhanVien,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              hintText: 'Chọn nhân viên...',
            ),
            items: _danhSachNhanVien.map((nhanVien) {
              return DropdownMenuItem<NhanVienModel>(
                value: nhanVien,
                child: Text('${nhanVien.maNhanVien ?? 'N/A'} - ${nhanVien.hoTen ?? 'N/A'}'),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedNhanVien = value;
                _danhSachLuong = [];
              });
              if (value != null) {
                _loadDanhSachLuongTheoNhanVien(value.id!);
              }
            },
          ),
        ],
      ),
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
          ],
        ),
      );
    }

    if (_selectedNhanVien == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_search, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Vui lòng chọn nhân viên để xem lương',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
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
              'Chưa có dữ liệu lương cho nhân viên này',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _showTinhLuongDialog,
              icon: const Icon(Icons.calculate),
              label: const Text('Tính lương'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _danhSachLuong.length,
      itemBuilder: (context, index) {
        final luong = _danhSachLuong[index];
        return _buildLuongCard(luong);
      },
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
                      isPaid ? 'Đã TT' : 'Chưa TT',
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Giờ làm: ${luong.tongGioLam.toStringAsFixed(1)}h'),
                  Text('Lương: ${currencyFormat.format(luong.tongTien)}'),
                ],
              ),
              if (luong.thuong != null && luong.thuong! > 0 || 
                  luong.truLuong != null && luong.truLuong! > 0) ...[
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (luong.thuong != null && luong.thuong! > 0)
                      Text(
                        'Thưởng: +${currencyFormat.format(luong.thuong)}',
                        style: const TextStyle(color: Colors.green),
                      ),
                    if (luong.truLuong != null && luong.truLuong! > 0)
                      Text(
                        'Trừ: -${currencyFormat.format(luong.truLuong)}',
                        style: const TextStyle(color: Colors.red),
                      ),
                  ],
                ),
              ],
              const Divider(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Tổng cộng:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    currencyFormat.format(luong.tongCong),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: () => _showCapNhatLuongDialog(luong),
                    icon: const Icon(Icons.edit, size: 18),
                    label: const Text('Sửa'),
                  ),
                  const SizedBox(width: 8),
                  TextButton.icon(
                    onPressed: () => _confirmXoaLuong(luong),
                    icon: const Icon(Icons.delete, size: 18),
                    label: const Text('Xóa'),
                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTinhLuongDialog() {
    if (_selectedNhanVien == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn nhân viên trước')),
      );
      return;
    }

    String loaiKy = 'Tuan';
    DateTime ngayBatDau = DateTime.now().subtract(const Duration(days: 7));
    DateTime ngayKetThuc = DateTime.now();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Tính Lương'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nhân viên: ${_selectedNhanVien!.hoTen ?? 'N/A'}'),
              const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: loaiKy,
                  decoration: const InputDecoration(
                    labelText: 'Loại kỳ',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'Tuan', child: Text('Tuần')),
                    DropdownMenuItem(value: 'Thang', child: Text('Tháng')),
                  ],
                  onChanged: (value) {
                    setDialogState(() {
                      loaiKy = value!;
                      if (loaiKy == 'Tuan') {
                        ngayBatDau = DateTime.now().subtract(const Duration(days: 7));
                        ngayKetThuc = DateTime.now();
                      } else {
                        ngayBatDau = DateTime(DateTime.now().year, DateTime.now().month, 1);
                        ngayKetThuc = DateTime.now();
                      }
                    });
                  },
                ),
                const SizedBox(height: 16),
                ListTile(
                  title: const Text('Từ ngày'),
                  subtitle: Text(DateFormat('dd/MM/yyyy').format(ngayBatDau)),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: ngayBatDau,
                      firstDate: DateTime.now().subtract(const Duration(days: 365)),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      setDialogState(() => ngayBatDau = picked);
                    }
                  },
                ),
                ListTile(
                  title: const Text('Đến ngày'),
                  subtitle: Text(DateFormat('dd/MM/yyyy').format(ngayKetThuc)),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: ngayKetThuc,
                      firstDate: ngayBatDau,
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      setDialogState(() => ngayKetThuc = picked);
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                await _tinhLuong(
                  nhanVienId: _selectedNhanVien!.id!,
                  loaiKy: loaiKy,
                  ngayBatDau: ngayBatDau,
                  ngayKetThuc: ngayKetThuc,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('Tính lương'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _tinhLuong({
    required int nhanVienId,
    required String loaiKy,
    required DateTime ngayBatDau,
    required DateTime ngayKetThuc,
  }) async {
    setState(() => _isLoading = true);

    try {
      final response = await _luongService.tinhLuong({
        'nhanVienId': nhanVienId,
        'loaiKy': loaiKy,
        'ngayBatDau': ngayBatDau.toIso8601String(),
        'ngayKetThuc': ngayKetThuc.toIso8601String(),
      });

      if (response.thanhCong) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.thongBao),
            backgroundColor: Colors.green,
          ),
        );
        // Reload danh sách lương
        await _loadDanhSachLuongTheoNhanVien(nhanVienId);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.thongBao), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: ${e.toString()}'), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showCapNhatLuongDialog(LuongDto luong) {
    final thuongController = TextEditingController(text: luong.thuong?.toString() ?? '0');
    final truLuongController = TextEditingController(text: luong.truLuong?.toString() ?? '0');
    final ghiChuController = TextEditingController(text: luong.ghiChu ?? '');
    String trangThai = luong.trangThai;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Cập Nhật Lương'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: thuongController,
                  decoration: const InputDecoration(
                    labelText: 'Thưởng',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.add_circle, color: Colors.green),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: truLuongController,
                  decoration: const InputDecoration(
                    labelText: 'Khấu trừ',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.remove_circle, color: Colors.red),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: trangThai,
                  decoration: const InputDecoration(
                    labelText: 'Trạng thái',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'ChuaTra', child: Text('Chưa thanh toán')),
                    DropdownMenuItem(value: 'DaTra', child: Text('Đã thanh toán')),
                  ],
                  onChanged: (value) {
                    setDialogState(() => trangThai = value!);
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: ghiChuController,
                  decoration: const InputDecoration(
                    labelText: 'Ghi chú',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                await _capNhatLuong(
                  luong.id,
                  thuong: double.tryParse(thuongController.text) ?? 0,
                  truLuong: double.tryParse(truLuongController.text) ?? 0,
                  trangThai: trangThai,
                  ghiChu: ghiChuController.text,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('Cập nhật'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _capNhatLuong(
    int id, {
    required double thuong,
    required double truLuong,
    required String trangThai,
    required String ghiChu,
  }) async {
    setState(() => _isLoading = true);

    try {
      final response = await _luongService.capNhatLuong(id, {
        'thuong': thuong,
        'truLuong': truLuong,
        'trangThai': trangThai,
        'ghiChu': ghiChu,
      });

      if (response['thanhCong']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['thongBao']),
            backgroundColor: Colors.green,
          ),
        );
        // Reload danh sách lương
        if (_selectedNhanVien != null) {
          await _loadDanhSachLuongTheoNhanVien(_selectedNhanVien!.id);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['thongBao']), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: ${e.toString()}'), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _confirmXoaLuong(LuongDto luong) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: const Text('Bạn có chắc chắn muốn xóa bản ghi lương này?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await _xoaLuong(luong.id);
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

  Future<void> _xoaLuong(int id) async {
    setState(() => _isLoading = true);

    try {
      final success = await _luongService.xoaLuong(id);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Xóa lương thành công'),
            backgroundColor: Colors.green,
          ),
        );
        // Reload danh sách lương
        if (_selectedNhanVien != null) {
          await _loadDanhSachLuongTheoNhanVien(_selectedNhanVien!.id);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Xóa lương thất bại'), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: ${e.toString()}'), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showLuongDetail(LuongDto luong) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Chi tiết lương'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDialogRow('Nhân viên', '${luong.maNhanVien} - ${luong.tenNhanVien}'),
              const Divider(),
              _buildDialogRow('Loại kỳ', luong.loaiKy == 'Tuan' ? 'Tuần' : 'Tháng'),
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

