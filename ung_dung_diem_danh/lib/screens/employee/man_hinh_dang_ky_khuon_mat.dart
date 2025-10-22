import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/theme.dart';
import '../../services/api_service.dart';
import '../../services/auth_service.dart';
import '../../services/face_recognition_service.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class ManHinhDangKyKhuonMat extends StatefulWidget {
  const ManHinhDangKyKhuonMat({super.key});

  @override
  State<ManHinhDangKyKhuonMat> createState() => _ManHinhDangKyKhuonMatState();
}

class _ManHinhDangKyKhuonMatState extends State<ManHinhDangKyKhuonMat> {
  final ImagePicker _picker = ImagePicker();
  final FaceRecognitionService _faceService = FaceRecognitionService();
  
  bool _isProcessing = false;
  String _message = 'Chụp ảnh khuôn mặt để đăng ký';
  File? _capturedImage;
  File? _croppedFaceImage;
  Face? _detectedFace;
  
  @override
  void dispose() {
    _faceService.dispose();
    super.dispose();
  }

  Future<void> _capturePhoto() async {
    try {
      print('[REGISTER] Mở camera...');
      
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.front,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 90,
      );

      if (photo == null) {
        return;
      }

      final File imageFile = File(photo.path);

      setState(() {
        _isProcessing = true;
        _message = 'Đang phát hiện khuôn mặt...';
      });

      // Phát hiện khuôn mặt
      final faces = await _faceService.detectFaces(photo.path);

      if (faces.isEmpty) {
        _showMessage('❌ Không phát hiện khuôn mặt. Thử lại!', isError: true);
        setState(() {
          _isProcessing = false;
          _message = 'Không phát hiện khuôn mặt';
        });
        return;
      }

      if (faces.length > 1) {
        _showMessage('❌ Phát hiện nhiều khuôn mặt. Chỉ 1 người!', isError: true);
        setState(() {
          _isProcessing = false;
          _message = 'Phát hiện ${faces.length} khuôn mặt';
        });
        return;
      }

      final face = faces.first;

      // Kiểm tra chất lượng khuôn mặt
      if (!_faceService.isFaceQualityGood(face)) {
        _showMessage('❌ Chất lượng khuôn mặt không đủ. Thử lại!', isError: true);
        setState(() {
          _isProcessing = false;
          _message = 'Khuôn mặt không đủ rõ hoặc không nhìn thẳng';
        });
        return;
      }

      // Crop khuôn mặt
      final croppedFace = await _faceService.cropFace(photo.path, face);

      if (croppedFace == null) {
        _showMessage('❌ Lỗi xử lý ảnh. Thử lại!', isError: true);
        setState(() {
          _isProcessing = false;
        });
        return;
      }

      setState(() {
        _capturedImage = imageFile;
        _croppedFaceImage = croppedFace;
        _detectedFace = face;
        _isProcessing = false;
        _message = '✅ Phát hiện khuôn mặt thành công!';
      });

      _showMessage('✅ Khuôn mặt hợp lệ! Nhấn "Xác nhận" để lưu', isError: false);

    } catch (e) {
      print('[REGISTER] 💥 Lỗi: $e');
      _showMessage('Lỗi: $e', isError: true);
      setState(() {
        _isProcessing = false;
      });
    }
  }

  Future<void> _confirmAndRegister() async {
    if (_croppedFaceImage == null) {
      _showMessage('Vui lòng chụp ảnh trước', isError: true);
      return;
    }

    setState(() {
      _isProcessing = true;
      _message = 'Đang lưu khuôn mặt...';
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

      // Convert ảnh sang base64
      final bytes = await _croppedFaceImage!.readAsBytes();
      final base64Image = base64Encode(bytes);

      print('[REGISTER] Gửi ảnh khuôn mặt lên server...');
      print('[REGISTER] Kích thước: ${bytes.length} bytes');

      // Gọi API đăng ký khuôn mặt
      // TODO: Cần thêm endpoint này vào backend
      final response = await apiService.post(
        '/api/NhanVien/dang-ky-khuon-mat',
        data: {
          'maNhanVien': maNhanVien,
          'faceImage': base64Image,
          'faceInfo': _faceService.getFaceInfo(_detectedFace!),
        },
      );

      if (response.statusCode == 200) {
        // Lưu local để dùng offline
        await prefs.setString('face_image_$maNhanVien', base64Image);
        
        _showSuccessDialog(
          'Đăng ký thành công',
          'Khuôn mặt đã được lưu. Bạn có thể dùng để điểm danh!',
        );
      } else {
        _showMessage('Lỗi lưu khuôn mặt', isError: true);
      }

    } catch (e) {
      print('[REGISTER] 💥 Lỗi lưu: $e');
      
      // Fallback: Lưu local nếu server lỗi
      try {
        final prefs = await SharedPreferences.getInstance();
        final maNhanVien = prefs.getString('ma_nhan_vien') ?? '';
        final bytes = await _croppedFaceImage!.readAsBytes();
        final base64Image = base64Encode(bytes);
        
        await prefs.setString('face_image_$maNhanVien', base64Image);
        
        _showSuccessDialog(
          'Đăng ký offline',
          'Khuôn mặt đã lưu tạm thời trên thiết bị. Sẽ đồng bộ khi có mạng.',
        );
      } catch (e2) {
        _showMessage('Lỗi: $e', isError: true);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  void _showMessage(String message, {required bool isError}) {
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showSuccessDialog(String title, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
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
            onPressed: () {
              Navigator.of(context).pop(); // Đóng dialog
              Navigator.of(context).pop(); // Về trang trước
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _retakePhoto() {
    setState(() {
      _capturedImage = null;
      _croppedFaceImage = null;
      _detectedFace = null;
      _message = 'Chụp ảnh khuôn mặt để đăng ký';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đăng Ký Khuôn Mặt'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.purple.withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                if (_croppedFaceImage == null) ...[
                  _buildInstructionsCard(),
                  const SizedBox(height: 30),
                  _buildCaptureButton(),
                ] else ...[
                  _buildPreviewCard(),
                  const SizedBox(height: 20),
                  _buildActionButtons(),
                ],
                const SizedBox(height: 20),
                _buildStatusCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInstructionsCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(
              Icons.face_retouching_natural,
              size: 80,
              color: Colors.purple,
            ),
            const SizedBox(height: 16),
            const Text(
              'Hướng dẫn chụp ảnh',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildInstruction(Icons.wb_sunny, 'Chụp ở nơi đủ sáng'),
            _buildInstruction(Icons.face, 'Nhìn thẳng vào camera'),
            _buildInstruction(Icons.remove_red_eye, 'Mở to mắt'),
            _buildInstruction(Icons.sentiment_neutral, 'Giữ biểu cảm tự nhiên'),
            _buildInstruction(Icons.person, 'Chỉ 1 người trong khung hình'),
          ],
        ),
      ),
    );
  }

  Widget _buildInstruction(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.purple, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCaptureButton() {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton.icon(
        onPressed: _isProcessing ? null : _capturePhoto,
        icon: _isProcessing
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Icon(Icons.camera_alt, size: 28),
        label: Text(
          _isProcessing ? 'Đang xử lý...' : 'Chụp Ảnh',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.purple,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 8,
        ),
      ),
    );
  }

  Widget _buildPreviewCard() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.file(
              _capturedImage!,
              height: 300,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          if (_croppedFaceImage != null) ...[
            const Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                'Khuôn mặt đã phát hiện:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(80),
                child: Image.file(
                  _croppedFaceImage!,
                  width: 160,
                  height: 160,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 60,
          child: ElevatedButton.icon(
            onPressed: _isProcessing ? null : _confirmAndRegister,
            icon: _isProcessing
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.check_circle, size: 28),
            label: Text(
              _isProcessing ? 'Đang lưu...' : 'Xác Nhận & Lưu',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 8,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: OutlinedButton.icon(
            onPressed: _isProcessing ? null : _retakePhoto,
            icon: const Icon(Icons.refresh),
            label: const Text('Chụp Lại'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.purple,
              side: const BorderSide(color: Colors.purple),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusCard() {
    return Card(
      color: _detectedFace != null ? Colors.green.shade50 : Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              _detectedFace != null ? Icons.check_circle : Icons.info,
              color: _detectedFace != null ? Colors.green : Colors.blue,
              size: 32,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _message,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

