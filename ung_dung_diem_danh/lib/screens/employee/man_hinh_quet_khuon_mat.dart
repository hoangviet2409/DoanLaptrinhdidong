import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/theme.dart';
import '../../models/diem_danh_request.dart';
import '../../services/api_service.dart';
import '../../services/auth_service.dart';
import '../../services/diem_danh_service.dart';
import '../../services/face_recognition_service.dart';
import 'package:geolocator/geolocator.dart';
import 'man_hinh_dang_ky_khuon_mat.dart';

class ManHinhQuetKhuonMat extends StatefulWidget {
  const ManHinhQuetKhuonMat({super.key});

  @override
  State<ManHinhQuetKhuonMat> createState() => _ManHinhQuetKhuonMatState();
}

class _ManHinhQuetKhuonMatState extends State<ManHinhQuetKhuonMat>
    with SingleTickerProviderStateMixin {
  final ImagePicker _picker = ImagePicker();
  final FaceRecognitionService _faceService = FaceRecognitionService();
  
  final bool _isCameraAvailable = true;
  bool _isProcessing = false;
  bool _isRegistered = false;
  String _message = 'Đang kiểm tra đăng ký...';
  File? _capturedImage;
  File? _croppedFaceImage;
  Position? _currentPosition;
  String? _registeredFaceImage; // Base64
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimation();
    _getCurrentLocation();
    _checkRegistration();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _faceService.dispose();
    super.dispose();
  }
  
  Future<void> _checkRegistration() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final maNhanVien = prefs.getString('ma_nhan_vien') ?? '';
      final faceImage = prefs.getString('face_image_$maNhanVien');
      
      if (!mounted) return;
      
      if (faceImage != null) {
        setState(() {
          _isRegistered = true;
          _registeredFaceImage = faceImage;
          _message = 'Sẵn sàng nhận diện khuôn mặt';
        });
      } else {
        setState(() {
          _isRegistered = false;
          _message = 'Chưa đăng ký khuôn mặt. Vui lòng đăng ký trước!';
        });
      }
    } catch (e) {
      print('[FACE] Lỗi kiểm tra đăng ký: $e');
    }
  }

  void _initAnimation() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);

    _fadeAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
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

  Future<void> _capturePhoto() async {
    if (!_isRegistered) {
      _showMessage('Bạn chưa đăng ký khuôn mặt!', isError: true);
      return;
    }

    try {
      print('[FACE] Mở camera để chụp...');
      
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.front,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 90,
      );

      if (photo == null) {
        print('[FACE] ❌ Người dùng hủy chụp ảnh');
        return;
      }

      print('[FACE] ✅ Đã chụp ảnh: ${photo.path}');

      setState(() {
        _isProcessing = true;
        _message = 'Đang phát hiện & nhận diện khuôn mặt...';
      });

      // Phát hiện khuôn mặt
      final faces = await _faceService.detectFaces(photo.path);

      if (faces.isEmpty) {
        _showMessage('❌ Không phát hiện khuôn mặt', isError: true);
        setState(() {
          _isProcessing = false;
          _message = 'Không phát hiện khuôn mặt. Thử lại!';
        });
        return;
      }

      if (faces.length > 1) {
        _showMessage('❌ Phát hiện nhiều khuôn mặt', isError: true);
        setState(() {
          _isProcessing = false;
          _message = 'Phát hiện ${faces.length} khuôn mặt. Chỉ 1 người!';
        });
        return;
      }

      final face = faces.first;

      // Kiểm tra chất lượng
      if (!_faceService.isFaceQualityGood(face)) {
        _showMessage('❌ Chất lượng khuôn mặt không đủ', isError: true);
        setState(() {
          _isProcessing = false;
          _message = 'Khuôn mặt không rõ hoặc không nhìn thẳng';
        });
        return;
      }

      // Crop khuôn mặt
      final croppedFace = await _faceService.cropFace(photo.path, face);

      if (croppedFace == null) {
        _showMessage('❌ Lỗi xử lý ảnh', isError: true);
        setState(() {
          _isProcessing = false;
        });
        return;
      }

      // So sánh với ảnh đã đăng ký
      setState(() {
        _message = 'Đang so sánh khuôn mặt...';
      });

      final similarity = await _compareFaces(croppedFace);

      print('[FACE] Độ tương đồng: $similarity%');

      if (similarity >= 70.0) { // Threshold: 70%
        setState(() {
          _capturedImage = File(photo.path);
          _croppedFaceImage = croppedFace;
          _isProcessing = false;
          _message = '✅ Nhận diện thành công! (${similarity.toStringAsFixed(1)}%)';
        });
        _showMessage('✅ Khuôn mặt khớp! Nhấn "Xác nhận" để điểm danh', isError: false);
      } else {
        _showMessage('❌ Khuôn mặt không khớp! (${similarity.toStringAsFixed(1)}%)', isError: true);
        setState(() {
          _isProcessing = false;
          _message = '❌ Khuôn mặt không khớp. Độ tương đồng: ${similarity.toStringAsFixed(1)}%';
        });
      }

    } catch (e) {
      print('[FACE] 💥 Lỗi: $e');
      _showMessage('Lỗi: $e', isError: true);
      setState(() {
        _isProcessing = false;
      });
    }
  }

  Future<double> _compareFaces(File currentFace) async {
    try {
      // Lưu ảnh đã đăng ký ra file tạm
      final tempDir = Directory.systemTemp;
      final registeredFile = File('${tempDir.path}/registered_face.jpg');
      
      final registeredBytes = base64Decode(_registeredFaceImage!);
      await registeredFile.writeAsBytes(registeredBytes);

      // So sánh 2 ảnh
      final similarity = await _faceService.compareFaces(
        registeredFile.path,
        currentFace.path,
      );

      // Xóa file tạm
      await registeredFile.delete();

      return similarity;
    } catch (e) {
      print('[FACE] Lỗi so sánh: $e');
      return 0.0;
    }
  }

  Future<void> _confirmAndCheckIn() async {
    if (_capturedImage == null) {
      _showMessage('Vui lòng chụp ảnh trước', isError: true);
      return;
    }

    setState(() {
      _isProcessing = true;
      _message = 'Đang xử lý ảnh khuôn mặt...';
    });

    try {
      // Chuyển ảnh sang base64 để gửi lên server
      final bytes = await _capturedImage!.readAsBytes();
      final base64Image = base64Encode(bytes);

      print('[FACE] Kích thước ảnh: ${bytes.length} bytes');
      print('[FACE] Gửi lên server...');

      // Gọi API điểm danh
      await _performFaceCheckIn(base64Image);

    } catch (e) {
      print('[FACE] 💥 Lỗi: $e');
      _showMessage('Lỗi: $e', isError: true);
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  Future<void> _performFaceCheckIn(String base64Image) async {
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
      
      // Kiểm tra trạng thái điểm danh
      final diemDanhHienTai = await diemDanhService.layDiemDanhHienTaiCaNhan();
      
      if (diemDanhHienTai != null && diemDanhHienTai.gioRa != null) {
        _showMessage('Bạn đã hoàn thành điểm danh hôm nay', isError: true);
        return;
      }

      // NOTE: Backend cần thêm logic nhận và xử lý ảnh khuôn mặt
      // Hiện tại chỉ gửi request bình thường với ghi chú có chứa thông tin ảnh
      
      if (diemDanhHienTai == null) {
        // Điểm danh vào
        final request = DiemDanhVaoRequest(
          maNhanVien: maNhanVien,
          phuongThuc: 'KhuonMat',
          viDo: _currentPosition?.latitude,
          kinhDo: _currentPosition?.longitude,
          ghiChu: 'Điểm danh bằng nhận diện khuôn mặt',
          // TODO: Thêm field imageData vào request nếu backend hỗ trợ
        );

        final response = await diemDanhService.diemDanhVao(request);

        if (!mounted) return;
        
        if (response.thanhCong) {
          setState(() {
            _message = '✅ Điểm danh VÀO thành công!';
          });
          _showSuccessDialog('Điểm danh vào', 'Đã xác nhận khuôn mặt và điểm danh thành công!');
          // Xóa ảnh sau khi thành công
          setState(() {
            _capturedImage = null;
          });
        } else {
          _showMessage(response.thongBao, isError: true);
        }
      } else {
        // Điểm danh ra
        final request = DiemDanhRaRequest(
          maNhanVien: maNhanVien,
          phuongThuc: 'KhuonMat',
          viDo: _currentPosition?.latitude,
          kinhDo: _currentPosition?.longitude,
          ghiChu: 'Điểm danh bằng nhận diện khuôn mặt',
        );

        final response = await diemDanhService.diemDanhRa(request);

        if (!mounted) return;
        
        if (response.thanhCong) {
          setState(() {
            _message = '✅ Điểm danh RA thành công!';
          });
          _showSuccessDialog('Điểm danh ra', 'Đã xác nhận khuôn mặt và điểm danh thành công!');
          setState(() {
            _capturedImage = null;
          });
        } else {
          _showMessage(response.thongBao, isError: true);
        }
      }
    } catch (e) {
      if (!mounted) return;
      _showMessage('Lỗi điểm danh: $e', isError: true);
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

  void _retakePhoto() {
    setState(() {
      _capturedImage = null;
      _message = 'Sẵn sàng quét khuôn mặt';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quét Khuôn Mặt'),
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
                  if (_capturedImage == null) ...[
                    _buildCameraIcon(),
                    const SizedBox(height: 40),
                    _buildStatusCard(),
                    const SizedBox(height: 30),
                    _buildCaptureButton(),
                  ] else ...[
                    _buildPreviewImage(),
                    const SizedBox(height: 20),
                    _buildActionButtons(),
                  ],
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

  Widget _buildCameraIcon() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.purple.shade100,
          boxShadow: [
            BoxShadow(
              color: Colors.purple.withOpacity(0.3),
              blurRadius: 15,
              spreadRadius: 3,
            ),
          ],
        ),
        child: Icon(
          Icons.face_retouching_natural,
          size: 100,
          color: AppTheme.primaryColor,
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
                  _isCameraAvailable ? Icons.check_circle : Icons.error,
                  color: _isCameraAvailable ? Colors.green : Colors.red,
                  size: 24,
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Camera Sẵn Sàng',
                    style: TextStyle(
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

  Widget _buildCaptureButton() {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton.icon(
        onPressed: (_isProcessing || !_isRegistered) ? null : _capturePhoto,
        icon: const Icon(Icons.camera_alt, size: 28),
        label: Text(
          _isRegistered ? 'Mở Camera' : 'Cần đăng ký trước',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: _isRegistered ? Colors.purple : Colors.grey,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 8,
        ),
      ),
    );
  }

  Widget _buildPreviewImage() {
    return Column(
      children: [
        Card(
          elevation: 8,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.file(
              _capturedImage!,
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ),
        if (_croppedFaceImage != null) ...[
          const SizedBox(height: 12),
          const Text(
            'Khuôn mặt đã nhận diện:',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(80),
            child: Image.file(
              _croppedFaceImage!,
              width: 160,
              height: 160,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 60,
          child: ElevatedButton.icon(
            onPressed: _isProcessing ? null : _confirmAndCheckIn,
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
              _isProcessing ? 'Đang xử lý...' : 'Xác Nhận & Điểm Danh',
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
              foregroundColor: AppTheme.primaryColor,
              side: BorderSide(color: AppTheme.primaryColor),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInstructions() {
    return Card(
      color: _isRegistered ? Colors.purple.shade50 : Colors.orange.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _isRegistered ? Icons.info_outline : Icons.warning,
                  color: _isRegistered ? Colors.purple.shade700 : Colors.orange.shade700,
                ),
                const SizedBox(width: 8),
                Text(
                  _isRegistered ? 'Hướng dẫn' : 'Chưa đăng ký',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _isRegistered ? Colors.purple.shade700 : Colors.orange.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (!_isRegistered) ...[
              const Text(
                'Bạn cần đăng ký khuôn mặt trước khi sử dụng tính năng này.',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ManHinhDangKyKhuonMat(),
                      ),
                    );
                    // Refresh sau khi đăng ký
                    _checkRegistration();
                  },
                  icon: const Icon(Icons.face),
                  label: const Text('Đăng Ký Khuôn Mặt'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ] else ...[
              _buildInstructionItem('1. Nhấn "Mở Camera" để chụp ảnh'),
              _buildInstructionItem('2. Đảm bảo khuôn mặt rõ ràng, đủ sáng'),
              _buildInstructionItem('3. Hệ thống tự động nhận diện'),
              _buildInstructionItem('4. Nếu khớp, nhấn "Xác Nhận" để điểm danh'),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.shade300),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green.shade700, size: 20),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        '✨ AI nhận diện khuôn mặt đã kích hoạt! Ngưỡng: 70%',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
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
          Icon(Icons.check, color: Colors.purple.shade700, size: 16),
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

