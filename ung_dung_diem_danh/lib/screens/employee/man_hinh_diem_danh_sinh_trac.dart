import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/theme.dart';
import '../../models/diem_danh_request.dart';
import '../../services/api_service.dart';
import '../../services/auth_service.dart';
import '../../services/biometric_service.dart';
import '../../services/diem_danh_service.dart';
import 'package:geolocator/geolocator.dart';

class ManHinhDiemDanhSinhTrac extends StatefulWidget {
  const ManHinhDiemDanhSinhTrac({super.key});

  @override
  State<ManHinhDiemDanhSinhTrac> createState() => _ManHinhDiemDanhSinhTracState();
}

class _ManHinhDiemDanhSinhTracState extends State<ManHinhDiemDanhSinhTrac>
    with SingleTickerProviderStateMixin {
  final BiometricService _biometricService = BiometricService();
  
  bool _isBiometricAvailable = false;
  bool _isProcessing = false;
  String _message = 'Đang kiểm tra sinh trắc học...';
  String _biometricType = '';
  Position? _currentPosition;
  
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimation();
    _checkBiometric();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _initAnimation() {
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  Future<void> _checkBiometric() async {
    final isAvailable = await _biometricService.isBiometricAvailable();
    final type = await _biometricService.getBiometricTypeString();
    
    if (!mounted) return;
    
    setState(() {
      _isBiometricAvailable = isAvailable;
      _biometricType = type;
      if (isAvailable) {
        _message = 'Sẵn sàng xác thực bằng $type';
      } else {
        _message = 'Thiết bị không hỗ trợ sinh trắc học';
      }
    });
  }

  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      if (!mounted) return;
      setState(() {
        _currentPosition = position;
      });
    } catch (e) {
      // Ignore location errors
    }
  }

  Future<void> _authenticateAndCheckIn() async {
    if (!_isBiometricAvailable) {
      _showMessage('Sinh trắc học không khả dụng', isError: true);
      return;
    }

    setState(() {
      _isProcessing = true;
      _message = 'Đang xác thực...';
    });

    try {
      // Bước 1: Xác thực sinh trắc học
      final isAuthenticated = await _biometricService.authenticate(
        reason: 'Xác thực để điểm danh',
        useErrorDialogs: true,
        stickyAuth: true,
      );

      if (!isAuthenticated) {
        if (!mounted) return;
        setState(() {
          _message = 'Xác thực thất bại';
          _isProcessing = false;
        });
        _showMessage('Xác thực sinh trắc học thất bại', isError: true);
        return;
      }

      // Bước 2: Điểm danh
      await _performCheckIn();
      
    } catch (e) {
      if (!mounted) return;
      _showMessage('Lỗi: $e', isError: true);
      setState(() {
        _isProcessing = false;
      });
    }
  }

  Future<void> _performCheckIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final apiService = ApiService();
      final authService = AuthService(apiService, prefs);

      final token = await authService.getCurrentToken();
      if (token != null) {
        apiService.setToken(token);
      }

      final maNhanVien = prefs.getString('ma_nhan_vien') ?? '';
      final diemDanhService = DiemDanhService(apiService);
      
      // Kiểm tra trạng thái điểm danh hiện tại
      final diemDanhHienTai = await diemDanhService.layDiemDanhHienTaiCaNhan();
      
      if (diemDanhHienTai != null && diemDanhHienTai.gioRa != null) {
        _showMessage('Bạn đã hoàn thành điểm danh hôm nay', isError: true);
        setState(() {
          _isProcessing = false;
        });
        return;
      }

      if (diemDanhHienTai == null) {
        // Điểm danh vào
        final request = DiemDanhVaoRequest(
          maNhanVien: maNhanVien,
          phuongThuc: 'SinhTracHoc',
          viDo: _currentPosition?.latitude,
          kinhDo: _currentPosition?.longitude,
          ghiChu: 'Điểm danh bằng $_biometricType',
        );

        final response = await diemDanhService.diemDanhVao(request);

        if (!mounted) return;
        
        if (response.thanhCong) {
          setState(() {
            _message = '✅ Điểm danh VÀO thành công!';
          });
          _showSuccessDialog('Điểm danh vào', response.thongBao);
        } else {
          _showMessage(response.thongBao, isError: true);
        }
      } else {
        // Điểm danh ra
        final request = DiemDanhRaRequest(
          maNhanVien: maNhanVien,
          phuongThuc: 'SinhTracHoc',
          viDo: _currentPosition?.latitude,
          kinhDo: _currentPosition?.longitude,
          ghiChu: 'Điểm danh bằng $_biometricType',
        );

        final response = await diemDanhService.diemDanhRa(request);

        if (!mounted) return;
        
        if (response.thanhCong) {
          setState(() {
            _message = '✅ Điểm danh RA thành công!';
          });
          _showSuccessDialog('Điểm danh ra', response.thongBao);
        } else {
          _showMessage(response.thongBao, isError: true);
        }
      }
    } catch (e) {
      if (!mounted) return;
      _showMessage('Lỗi điểm danh: $e', isError: true);
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  void _showMessage(String message, {bool isError = false}) {
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );

    setState(() {
      _message = message;
    });
  }

  void _showSuccessDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 32),
            const SizedBox(width: 8),
            Text(title),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Điểm Danh Sinh Trắc Học'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.primaryColor.withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildBiometricIcon(),
                  const SizedBox(height: 40),
                  _buildStatusCard(),
                  const SizedBox(height: 30),
                  if (_isBiometricAvailable) _buildAuthButton(),
                  const SizedBox(height: 20),
                  _buildInstructions(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBiometricIcon() {
    IconData icon;
    if (_biometricType.contains('Face')) {
      icon = Icons.face;
    } else if (_biometricType.contains('Vân tay')) {
      icon = Icons.fingerprint;
    } else {
      icon = Icons.security;
    }

    return ScaleTransition(
      scale: _isProcessing ? _scaleAnimation : const AlwaysStoppedAnimation(1.0),
      child: Container(
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _isBiometricAvailable
              ? (_isProcessing ? AppTheme.primaryColor : Colors.green.shade100)
              : Colors.grey.shade300,
          boxShadow: _isProcessing
              ? [
                  BoxShadow(
                    color: AppTheme.primaryColor.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ]
              : [],
        ),
        child: Icon(
          icon,
          size: 100,
          color: _isBiometricAvailable
              ? (_isProcessing ? Colors.white : AppTheme.primaryColor)
              : Colors.grey.shade600,
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  _isBiometricAvailable ? Icons.check_circle : Icons.error,
                  color: _isBiometricAvailable ? Colors.green : Colors.red,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _isBiometricAvailable 
                        ? 'Sinh trắc học khả dụng' 
                        : 'Không hỗ trợ',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            if (_biometricType.isNotEmpty) ...[
              const SizedBox(height: 12),
              Chip(
                avatar: Icon(
                  _biometricType.contains('Face') ? Icons.face : Icons.fingerprint,
                  size: 18,
                ),
                label: Text(_biometricType),
                backgroundColor: Colors.blue.shade50,
              ),
            ],
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            Text(
              _message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade700,
              ),
            ),
            if (_isProcessing) ...[
              const SizedBox(height: 16),
              const CircularProgressIndicator(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAuthButton() {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton.icon(
        onPressed: _isProcessing ? null : _authenticateAndCheckIn,
        icon: Icon(
          _biometricType.contains('Face') ? Icons.face : Icons.fingerprint,
          size: 28,
        ),
        label: Text(
          _isProcessing ? 'Đang xử lý...' : 'Xác Thực & Điểm Danh',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 8,
        ),
      ),
    );
  }

  Widget _buildInstructions() {
    return Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue.shade700),
                const SizedBox(width: 8),
                Text(
                  'Hướng dẫn',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildInstructionItem('1. Nhấn nút "Xác Thực & Điểm Danh"'),
            _buildInstructionItem('2. Quét vân tay hoặc nhìn vào camera'),
            _buildInstructionItem('3. Chờ xác thực thành công'),
            _buildInstructionItem('4. Hệ thống tự động điểm danh'),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(Icons.check, color: Colors.blue.shade700, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

