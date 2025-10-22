import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/nhan_vien_model.dart';
import '../../services/api_service.dart';
import '../../services/auth_service.dart';
import '../../services/nhan_vien_service.dart';
import '../../services/diem_danh_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ManHinhChamCongThuCong extends StatefulWidget {
  const ManHinhChamCongThuCong({super.key});

  @override
  State<ManHinhChamCongThuCong> createState() => _ManHinhChamCongThuCongState();
}

class _ManHinhChamCongThuCongState extends State<ManHinhChamCongThuCong> {
  final _formKey = GlobalKey<FormState>();
  
  // State
  int? _selectedNhanVienId;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay? _gioVao;
  TimeOfDay? _gioRa;
  final _ghiChuController = TextEditingController();
  
  bool _isLoading = false;
  List<NhanVienModel> _danhSachNhanVien = [];
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadDanhSachNhanVien();
  }

  Future<void> _loadDanhSachNhanVien() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final prefs = await SharedPreferences.getInstance();
      final apiService = ApiService();
      final authService = AuthService(apiService, prefs);
      
      final token = await authService.getCurrentToken();
      if (token == null) {
        setState(() => _errorMessage = 'Chưa đăng nhập. Vui lòng đăng nhập lại.');
        return;
      }

      apiService.setToken(token);
      
      final nhanVienService = NhanVienService(apiService);
      final danhSach = await nhanVienService.layDanhSachNhanVien();

      setState(() {
        _danhSachNhanVien = danhSach;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Lỗi khi tải danh sách nhân viên: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _chamCongThuCong() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_gioVao == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn giờ vào')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final apiService = ApiService();
      final authService = AuthService(apiService, prefs);
      
      final token = await authService.getCurrentToken();
      if (token == null) {
        throw Exception('Chưa đăng nhập. Vui lòng đăng nhập lại.');
      }

      apiService.setToken(token);
      
      // Tạo DateTime cho giờ vào
      final gioVaoDateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _gioVao!.hour,
        _gioVao!.minute,
      );

      // Tạo DateTime cho giờ ra (nếu có)
      DateTime? gioRaDateTime;
      if (_gioRa != null) {
        gioRaDateTime = DateTime(
          _selectedDate.year,
          _selectedDate.month,
          _selectedDate.day,
          _gioRa!.hour,
          _gioRa!.minute,
        );
      }

      final request = {
        'nhanVienId': _selectedNhanVienId,
        'ngay': DateFormat('yyyy-MM-dd').format(_selectedDate),
        'gioVao': gioVaoDateTime.toIso8601String(),
        'gioRa': gioRaDateTime?.toIso8601String(),
        'phuongThucVao': 'ThuCong',
        'phuongThucRa': _gioRa != null ? 'ThuCong' : null,
        'ghiChu': _ghiChuController.text.isNotEmpty ? _ghiChuController.text : null,
      };

      final diemDanhService = DiemDanhService(apiService);
      await diemDanhService.chamCongThuCong(request);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Chấm công thành công'),
          backgroundColor: Colors.green,
        ),
      );
      
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _selectTime(bool isGioVao) async {
    final initialTime = isGioVao
        ? (_gioVao ?? const TimeOfDay(hour: 8, minute: 0))
        : (_gioRa ?? const TimeOfDay(hour: 17, minute: 0));

    final picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isGioVao) {
          _gioVao = picked;
        } else {
          _gioRa = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chấm Công Thủ Công'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: _isLoading && _danhSachNhanVien.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 64, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadDanhSachNhanVien,
                        child: const Text('Thử lại'),
                      ),
                    ],
                  ),
                )
              : Form(
                  key: _formKey,
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      // Card thông tin
                      Card(
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.info_outline, color: Colors.blue[700]),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Thông tin chấm công',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              
                              // Dropdown chọn nhân viên
                              DropdownButtonFormField<int>(
                                decoration: const InputDecoration(
                                  labelText: 'Nhân viên *',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.person),
                                ),
                                value: _selectedNhanVienId,
                                items: _danhSachNhanVien.map((nv) {
                                  return DropdownMenuItem<int>(
                                    value: nv.id,
                                    child: Text('${nv.maNhanVien} - ${nv.hoTen}'),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() => _selectedNhanVienId = value);
                                },
                                validator: (value) {
                                  if (value == null) {
                                    return 'Vui lòng chọn nhân viên';
                                  }
                                  return null;
                                },
                              ),
                              
                              const SizedBox(height: 16),
                              
                              // DatePicker chọn ngày
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: const Text('Ngày *'),
                                subtitle: Text(
                                  DateFormat('dd/MM/yyyy').format(_selectedDate),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                leading: Icon(Icons.calendar_today, color: Theme.of(context).primaryColor),
                                trailing: const Icon(Icons.arrow_drop_down),
                                onTap: _selectDate,
                                tileColor: Colors.grey[50],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: BorderSide(color: Colors.grey[300]!),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Card giờ vào/ra
                      Card(
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.access_time, color: Colors.green[700]),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Thời gian',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              
                              // TimePicker giờ vào
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: const Text('Giờ vào *'),
                                subtitle: Text(
                                  _gioVao?.format(context) ?? 'Chưa chọn',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: _gioVao == null ? Colors.grey : Colors.black,
                                  ),
                                ),
                                leading: Icon(Icons.login, color: Colors.green[600]),
                                trailing: const Icon(Icons.arrow_drop_down),
                                onTap: () => _selectTime(true),
                                tileColor: Colors.grey[50],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: BorderSide(color: Colors.grey[300]!),
                                ),
                              ),
                              
                              const SizedBox(height: 12),
                              
                              // TimePicker giờ ra
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: const Text('Giờ ra (Tùy chọn)'),
                                subtitle: Text(
                                  _gioRa?.format(context) ?? 'Chưa chọn',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: _gioRa == null ? Colors.grey : Colors.black,
                                  ),
                                ),
                                leading: Icon(Icons.logout, color: Colors.orange[600]),
                                trailing: const Icon(Icons.arrow_drop_down),
                                onTap: () => _selectTime(false),
                                tileColor: Colors.grey[50],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: BorderSide(color: Colors.grey[300]!),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Card ghi chú
                      Card(
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.note, color: Colors.orange[700]),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Ghi chú',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              
                              // TextField ghi chú
                              TextFormField(
                                controller: _ghiChuController,
                                decoration: const InputDecoration(
                                  labelText: 'Ghi chú (Tùy chọn)',
                                  border: OutlineInputBorder(),
                                  hintText: 'Lý do chấm công thủ công...',
                                  prefixIcon: Icon(Icons.edit_note),
                                ),
                                maxLines: 3,
                                maxLength: 200,
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Button Lưu
                      SizedBox(
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed: _isLoading ? null : _chamCongThuCong,
                          icon: _isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : const Icon(Icons.save),
                          label: Text(
                            _isLoading ? 'Đang lưu...' : 'Lưu Chấm Công',
                            style: const TextStyle(fontSize: 16),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Note
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.blue[200]!),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.info, size: 20, color: Colors.blue[700]),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                '* Chấm công thủ công dùng cho trường hợp nhân viên quên điểm danh hoặc có vấn đề kỹ thuật.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.blue[900],
                                ),
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

  @override
  void dispose() {
    _ghiChuController.dispose();
    super.dispose();
  }
}

