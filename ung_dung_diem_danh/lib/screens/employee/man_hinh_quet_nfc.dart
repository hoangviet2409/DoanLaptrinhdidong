import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/theme.dart';
import '../../models/diem_danh_request.dart';
import '../../services/api_service.dart';
import '../../services/auth_service.dart';
import '../../services/diem_danh_service.dart';
import '../../services/nfc_service.dart';
import 'package:geolocator/geolocator.dart';

class ManHinhQuetNFC extends StatefulWidget {
  const ManHinhQuetNFC({super.key});

  @override
  State<ManHinhQuetNFC> createState() => _ManHinhQuetNFCState();
}

class _ManHinhQuetNFCState extends State<ManHinhQuetNFC>
    with SingleTickerProviderStateMixin {
  final NFCService _nfcService = NFCService();
  
  bool _isNFCAvailable = false;
  bool _isScanning = false;
  bool _isProcessing = false;
  String _message = 'Đang kiểm tra NFC...';
  String? _lastScannedTag;
  Position? _currentPosition;
  
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimation();
    _checkNFC();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nfcService.stopSession();
    super.dispose();
  }

  void _initAnimation() {
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  Future<void> _checkNFC() async {
    final isAvailable = await _nfcService.isNFCAvailable();
    
    if (!mounted) return;
    
    setState(() {
      _isNFCAvailable = isAvailable;
      if (isAvailable) {
        _message = 'Sẵn sàng quét thẻ NFC';
      } else {
        _message = 'Thiết bị không hỗ trợ NFC';
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

  Future<void> _startNFCScan() async {
    if (!_isNFCAvailable) {
      _showMessage('NFC không khả dụng', isError: true);
      return;
    }

    if (_isScanning) return;

    setState(() {
      _isScanning = true;
      _message = 'Đang quét... Đưa thẻ NFC gần điện thoại';
    });

    try {
      print('[NFC] Bắt đầu quét thẻ NFC...');
      
      final tagId = await _nfcService.readNFCTag(
        onTagDetected: (tag) {
          print('[NFC] ✅ Phát hiện thẻ: $tag');
          if (mounted) {
            setState(() {
              _lastScannedTag = tag;
              _message = 'Đã quét thẻ: $tag\nĐang xử lý...';
            });
          }
        },
        onError: (error) {
          print('[NFC] ❌ Lỗi quét: $error');
          if (mounted) {
            setState(() {
              _message = 'Lỗi: $error';
              _isScanning = false;
            });
          }
        },
      );

      if (tagId != null && mounted) {
        print('[NFC] Xử lý tag ID: $tagId');
        await _processNFCTag(tagId);
      } else {
        print('[NFC] ⚠️ Không đọc được tag ID');
        if (mounted) {
          setState(() {
            _message = 'Không đọc được thẻ NFC. Thử lại!';
          });
        }
      }
    } catch (e) {
      print('[NFC] 💥 Exception: $e');
      if (!mounted) return;
      setState(() {
        _message = 'Lỗi quét thẻ: $e';
        _isScanning = false;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isScanning = false;
        });
      }
    }
  }

  Future<void> _processNFCTag(String tagId) async {
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
      _message = 'Đang xác thực thẻ NFC...';
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final apiService = ApiService();
      final authService = AuthService(apiService, prefs);

      final token = await authService.getCurrentToken();
      if (token != null) {
        apiService.setToken(token);
      }

      final maNhanVien = prefs.getString('ma_nhan_vien') ?? '';

      // Kiểm tra thẻ có hợp lệ không (tùy chọn)
      // Bạn có thể gọi API kiểm tra thẻ trước khi điểm danh

      // Thực hiện điểm danh
      final diemDanhService = DiemDanhService(apiService);
      
      // Kiểm tra nhân viên đã điểm danh vào chưa
      final diemDanhHienTai = await diemDanhService.layDiemDanhHienTaiCaNhan();
      
      if (diemDanhHienTai != null && diemDanhHienTai.gioRa != null) {
        // Đã điểm danh đủ cả vào và ra
        _showMessage('Bạn đã hoàn thành điểm danh hôm nay', isError: true);
        setState(() {
          _isProcessing = false;
        });
        return;
      }

      if (diemDanhHienTai == null) {
        // Chưa điểm danh vào => Điểm danh vào
        final request = DiemDanhVaoRequest(
          maNhanVien: maNhanVien,
          phuongThuc: 'NFC',
          viDo: _currentPosition?.latitude,
          kinhDo: _currentPosition?.longitude,
          ghiChu: 'Điểm danh NFC - Mã thẻ: $tagId',
        );

        final response = await diemDanhService.diemDanhVao(request);

        if (!mounted) return;
        
        if (response.thanhCong) {
          setState(() {
            _message = '✅ Điểm danh VÀO thành công!\n${response.thongBao}';
          });
          _showSuccessDialog('Điểm danh vào', response.thongBao);
        } else {
          _showMessage(response.thongBao, isError: true);
        }
      } else {
        // Đã điểm danh vào, chưa điểm danh ra => Điểm danh ra
        final request = DiemDanhRaRequest(
          maNhanVien: maNhanVien,
          phuongThuc: 'NFC',
          viDo: _currentPosition?.latitude,
          kinhDo: _currentPosition?.longitude,
          ghiChu: 'Điểm danh NFC - Mã thẻ: $tagId',
        );

        final response = await diemDanhService.diemDanhRa(request);

        if (!mounted) return;
        
        if (response.thanhCong) {
          setState(() {
            _message = '✅ Điểm danh RA thành công!\n${response.thongBao}';
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
        title: const Text('Điểm Danh bằng NFC'),
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
                  _buildNFCIcon(),
                  const SizedBox(height: 40),
                  _buildStatusCard(),
                  const SizedBox(height: 30),
                  if (_isNFCAvailable) _buildScanButton(),
                  const SizedBox(height: 20),
                  if (_lastScannedTag != null) _buildLastScannedCard(),
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

  Widget _buildNFCIcon() {
    return ScaleTransition(
      scale: _isScanning ? _pulseAnimation : const AlwaysStoppedAnimation(1.0),
      child: Container(
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _isNFCAvailable
              ? (_isScanning ? AppTheme.primaryColor : Colors.blue.shade100)
              : Colors.grey.shade300,
          boxShadow: _isScanning
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
          Icons.nfc,
          size: 100,
          color: _isNFCAvailable
              ? (_isScanning ? Colors.white : AppTheme.primaryColor)
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
                  _isNFCAvailable ? Icons.check_circle : Icons.error,
                  color: _isNFCAvailable ? Colors.green : Colors.red,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _isNFCAvailable ? 'NFC Khả Dụng' : 'NFC Không Khả Dụng',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
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

  Widget _buildScanButton() {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton.icon(
        onPressed: (_isScanning || _isProcessing) ? null : _startNFCScan,
        icon: Icon(
          _isScanning ? Icons.sensors : Icons.nfc,
          size: 28,
        ),
        label: Text(
          _isScanning
              ? 'Đang quét...'
              : _isProcessing
                  ? 'Đang xử lý...'
                  : 'Bắt Đầu Quét',
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

  Widget _buildLastScannedCard() {
    return Card(
      color: Colors.green.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.green),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Thẻ vừa quét:',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _lastScannedTag!,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'monospace',
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
            _buildInstructionItem('1. Nhấn nút "Bắt Đầu Quét"'),
            _buildInstructionItem('2. Đưa thẻ NFC gần mặt sau điện thoại'),
            _buildInstructionItem('3. Giữ thẻ trong vài giây'),
            _buildInstructionItem('4. Chờ xác nhận điểm danh'),
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

