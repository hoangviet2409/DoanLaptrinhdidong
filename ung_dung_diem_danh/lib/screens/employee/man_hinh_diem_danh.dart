import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_state.dart';
import '../../config/theme.dart';
import '../../models/diem_danh_request.dart';
import '../../models/diem_danh_response.dart';
import '../../services/api_service.dart';
import '../../services/auth_service.dart';
import '../../services/diem_danh_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ManHinhDiemDanh extends StatefulWidget {
  const ManHinhDiemDanh({super.key});

  @override
  State<ManHinhDiemDanh> createState() => _ManHinhDiemDanhState();
}

class _ManHinhDiemDanhState extends State<ManHinhDiemDanh> {
  DiemDanhDto? _diemDanhHienTai;
  bool _isLoading = false;
  bool _isCheckingLocation = false;
  Position? _currentPosition;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadDiemDanhHienTai();
    _getCurrentLocation();
  }

  Future<void> _loadDiemDanhHienTai() async {
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

      final diemDanhService = DiemDanhService(apiService);
      
      // Sử dụng endpoint cho nhân viên xem thông tin của chính họ
      _diemDanhHienTai = await diemDanhService.layDiemDanhHienTaiCaNhan();
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

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isCheckingLocation = true;
    });

    try {
      // Kiểm tra quyền truy cập vị trí
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _isCheckingLocation = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _isCheckingLocation = false;
        });
        return;
      }

      // Lấy vị trí hiện tại
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentPosition = position;
        _isCheckingLocation = false;
      });
    } catch (e) {
      setState(() {
        _isCheckingLocation = false;
      });
    }
  }

  Future<void> _diemDanhVao() async {
    if (_diemDanhHienTai?.daDiemDanhVao == true) {
      _showMessage('Bạn đã điểm danh vào hôm nay', isError: true);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final apiService = ApiService();
      final authService = AuthService(apiService, prefs);
      
      final token = await authService.getCurrentToken();
      if (token != null) {
        apiService.setToken(token);
      }

      final diemDanhService = DiemDanhService(apiService);
      final maNhanVien = prefs.getString('ma_nhan_vien') ?? '';

      final request = DiemDanhVaoRequest(
        maNhanVien: maNhanVien,
        phuongThuc: 'SinhTracHoc', // Có thể thay đổi thành 'KhuonMat' nếu cần
        viDo: _currentPosition?.latitude,
        kinhDo: _currentPosition?.longitude,
        ghiChu: 'Điểm danh từ ứng dụng di động',
      );

      final response = await diemDanhService.diemDanhVao(request);
      
      if (response.thanhCong) {
        _showMessage(response.thongBao);
        _loadDiemDanhHienTai(); // Reload data
      } else {
        _showMessage(response.thongBao, isError: true);
      }
    } catch (e) {
      _showMessage('Lỗi: ${e.toString()}', isError: true);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _diemDanhRa() async {
    if (_diemDanhHienTai?.daDiemDanhRa == true) {
      _showMessage('Bạn đã điểm danh ra hôm nay', isError: true);
      return;
    }

    if (_diemDanhHienTai?.daDiemDanhVao != true) {
      _showMessage('Bạn chưa điểm danh vào hôm nay', isError: true);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final apiService = ApiService();
      final authService = AuthService(apiService, prefs);
      
      final token = await authService.getCurrentToken();
      if (token != null) {
        apiService.setToken(token);
      }

      final diemDanhService = DiemDanhService(apiService);
      final maNhanVien = prefs.getString('ma_nhan_vien') ?? '';

      final request = DiemDanhRaRequest(
        maNhanVien: maNhanVien,
        phuongThuc: 'SinhTracHoc',
        viDo: _currentPosition?.latitude,
        kinhDo: _currentPosition?.longitude,
        ghiChu: 'Điểm danh ra từ ứng dụng di động',
      );

      final response = await diemDanhService.diemDanhRa(request);
      
      if (response.thanhCong) {
        _showMessage(response.thongBao);
        _loadDiemDanhHienTai(); // Reload data
      } else {
        _showMessage(response.thongBao, isError: true);
      }
    } catch (e) {
      _showMessage('Lỗi: ${e.toString()}', isError: true);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppTheme.errorColor : AppTheme.successColor,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Điểm Danh'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadDiemDanhHienTai,
          ),
        ],
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthAuthenticated) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Thông tin ngày hôm nay
                  _buildTodayInfoCard(),
                  const SizedBox(height: 20),
                  
                  // Thông tin vị trí
                  _buildLocationCard(),
                  const SizedBox(height: 20),
                  
                  // Nút điểm danh
                  _buildAttendanceButtons(),
                  const SizedBox(height: 20),
                  
                  // Thông tin điểm danh hiện tại
                  if (_diemDanhHienTai != null) _buildCurrentAttendanceCard(),
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildTodayInfoCard() {
    final now = DateTime.now();
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.calendar_today, color: AppTheme.primaryColor),
                const SizedBox(width: 8),
                const Text(
                  'Thông tin hôm nay',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Ngày', '${now.day}/${now.month}/${now.year}'),
            _buildInfoRow('Thứ', _getDayOfWeek(now.weekday)),
            _buildInfoRow('Giờ hiện tại', '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}'),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.location_on, color: AppTheme.primaryColor),
                const SizedBox(width: 8),
                const Text(
                  'Vị trí hiện tại',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                if (_isCheckingLocation)
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                else
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: _getCurrentLocation,
                  ),
              ],
            ),
            const SizedBox(height: 16),
            if (_currentPosition != null) ...[
              _buildInfoRow('Vĩ độ', _currentPosition!.latitude.toStringAsFixed(6)),
              _buildInfoRow('Kinh độ', _currentPosition!.longitude.toStringAsFixed(6)),
            ] else ...[
              const Text(
                'Không thể lấy vị trí hiện tại',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: _getCurrentLocation,
                icon: const Icon(Icons.location_on),
                label: const Text('Lấy vị trí'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceButtons() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Điểm danh',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isLoading || _diemDanhHienTai?.daDiemDanhVao == true 
                        ? null 
                        : _diemDanhVao,
                    icon: const Icon(Icons.login),
                    label: const Text('Điểm danh vào'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isLoading || _diemDanhHienTai?.daDiemDanhRa == true 
                        ? null 
                        : _diemDanhRa,
                    icon: const Icon(Icons.logout),
                    label: const Text('Điểm danh ra'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (_isLoading) ...[
              const SizedBox(height: 16),
              const Center(
                child: CircularProgressIndicator(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentAttendanceCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.access_time, color: AppTheme.primaryColor),
                const SizedBox(width: 8),
                const Text(
                  'Thông tin điểm danh hôm nay',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_diemDanhHienTai!.daDiemDanhVao) ...[
              _buildInfoRow('Giờ vào', _formatTime(_diemDanhHienTai!.gioVao!)),
              _buildInfoRow('Phương thức vào', _diemDanhHienTai!.phuongThucVaoText),
            ],
            if (_diemDanhHienTai!.daDiemDanhRa) ...[
              _buildInfoRow('Giờ ra', _formatTime(_diemDanhHienTai!.gioRa!)),
              _buildInfoRow('Phương thức ra', _diemDanhHienTai!.phuongThucRaText),
              _buildInfoRow('Tổng giờ làm', '${_diemDanhHienTai!.tongGioLam?.toStringAsFixed(2) ?? '0'} giờ'),
            ],
            _buildInfoRow('Trạng thái', _diemDanhHienTai!.trangThaiText),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(value),
          ),
        ],
      ),
    );
  }

  String _getDayOfWeek(int weekday) {
    const days = ['CN', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7'];
    return days[weekday % 7];
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}
