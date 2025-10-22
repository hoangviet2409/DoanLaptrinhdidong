import 'dart:io';
import 'dart:math' as math;
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image/image.dart' as img;
import 'package:logger/logger.dart';

class FaceRecognitionService {
  final Logger _logger = Logger();
  late FaceDetector _faceDetector;

  FaceRecognitionService() {
    // Cấu hình face detector
    final options = FaceDetectorOptions(
      enableContours: true,
      enableLandmarks: true,
      enableClassification: true,
      enableTracking: false,
      performanceMode: FaceDetectorMode.accurate,
    );
    _faceDetector = FaceDetector(options: options);
  }

  /// Phát hiện khuôn mặt trong ảnh
  /// Trả về danh sách Face nếu có
  Future<List<Face>> detectFaces(String imagePath) async {
    try {
      final inputImage = InputImage.fromFilePath(imagePath);
      final faces = await _faceDetector.processImage(inputImage);
      
      _logger.i('[FACE] Phát hiện ${faces.length} khuôn mặt');
      
      return faces;
    } catch (e) {
      _logger.e('[FACE] Lỗi phát hiện khuôn mặt: $e');
      return [];
    }
  }

  /// Kiểm tra ảnh có đúng 1 khuôn mặt không
  Future<bool> hasSingleFace(String imagePath) async {
    final faces = await detectFaces(imagePath);
    return faces.length == 1;
  }

  /// Crop khuôn mặt từ ảnh
  Future<File?> cropFace(String imagePath, Face face) async {
    try {
      final imageFile = File(imagePath);
      final bytes = await imageFile.readAsBytes();
      final image = img.decodeImage(bytes);
      
      if (image == null) {
        _logger.e('[FACE] Không thể decode ảnh');
        return null;
      }

      final boundingBox = face.boundingBox;
      
      // Crop với padding 20%
      const padding = 0.2;
      final x = (boundingBox.left - boundingBox.width * padding).toInt().clamp(0, image.width);
      final y = (boundingBox.top - boundingBox.height * padding).toInt().clamp(0, image.height);
      final w = (boundingBox.width * (1 + 2 * padding)).toInt();
      final h = (boundingBox.height * (1 + 2 * padding)).toInt();

      final croppedImage = img.copyCrop(
        image,
        x: x,
        y: y,
        width: w.clamp(1, image.width - x),
        height: h.clamp(1, image.height - y),
      );

      // Resize về 160x160 (chuẩn FaceNet)
      final resized = img.copyResize(croppedImage, width: 160, height: 160);

      // Lưu ảnh đã crop
      final croppedPath = imagePath.replaceAll('.jpg', '_cropped.jpg');
      final croppedFile = File(croppedPath);
      await croppedFile.writeAsBytes(img.encodeJpg(resized));

      _logger.i('[FACE] Đã crop khuôn mặt: $croppedPath');
      return croppedFile;
    } catch (e) {
      _logger.e('[FACE] Lỗi crop khuôn mặt: $e');
      return null;
    }
  }

  /// Kiểm tra chất lượng khuôn mặt
  /// Trả về true nếu khuôn mặt đủ chất lượng để nhận diện
  bool isFaceQualityGood(Face face) {
    // Kiểm tra góc nghiêng đầu
    final headEulerAngleY = face.headEulerAngleY; // Trái/phải
    final headEulerAngleZ = face.headEulerAngleZ; // Nghiêng

    if (headEulerAngleY != null && headEulerAngleY.abs() > 20) {
      _logger.w('[FACE] Đầu quay ngang quá nhiều: $headEulerAngleY°');
      return false;
    }

    if (headEulerAngleZ != null && headEulerAngleZ.abs() > 20) {
      _logger.w('[FACE] Đầu nghiêng quá nhiều: $headEulerAngleZ°');
      return false;
    }

    // Kiểm tra xác suất mắt mở
    final leftEyeOpenProbability = face.leftEyeOpenProbability;
    final rightEyeOpenProbability = face.rightEyeOpenProbability;

    if (leftEyeOpenProbability != null && leftEyeOpenProbability < 0.5) {
      _logger.w('[FACE] Mắt trái nhắm');
      return false;
    }

    if (rightEyeOpenProbability != null && rightEyeOpenProbability < 0.5) {
      _logger.w('[FACE] Mắt phải nhắm');
      return false;
    }

    // Kiểm tra kích thước khuôn mặt (phải đủ lớn)
    final boundingBox = face.boundingBox;
    if (boundingBox.width < 100 || boundingBox.height < 100) {
      _logger.w('[FACE] Khuôn mặt quá nhỏ: ${boundingBox.width}x${boundingBox.height}');
      return false;
    }

    _logger.i('[FACE] ✅ Chất lượng khuôn mặt tốt');
    return true;
  }

  /// Lấy thông tin chi tiết về khuôn mặt
  Map<String, dynamic> getFaceInfo(Face face) {
    return {
      'boundingBox': {
        'left': face.boundingBox.left,
        'top': face.boundingBox.top,
        'width': face.boundingBox.width,
        'height': face.boundingBox.height,
      },
      'headEulerAngleY': face.headEulerAngleY,
      'headEulerAngleZ': face.headEulerAngleZ,
      'leftEyeOpenProbability': face.leftEyeOpenProbability,
      'rightEyeOpenProbability': face.rightEyeOpenProbability,
      'smilingProbability': face.smilingProbability,
      'trackingId': face.trackingId,
    };
  }

  /// So sánh 2 ảnh khuôn mặt
  /// Trả về độ tương đồng (0-100)
  /// NOTE: Đây là so sánh đơn giản bằng histogram
  /// Để chính xác hơn, cần dùng FaceNet embeddings (backend hoặc tflite)
  Future<double> compareFaces(String image1Path, String image2Path) async {
    try {
      // Đọc 2 ảnh
      final bytes1 = await File(image1Path).readAsBytes();
      final bytes2 = await File(image2Path).readAsBytes();

      final img1 = img.decodeImage(bytes1);
      final img2 = img.decodeImage(bytes2);

      if (img1 == null || img2 == null) {
        return 0.0;
      }

      // Resize về cùng kích thước
      final resized1 = img.copyResize(img1, width: 100, height: 100);
      final resized2 = img.copyResize(img2, width: 100, height: 100);

      // Tính histogram
      final hist1 = _calculateHistogram(resized1);
      final hist2 = _calculateHistogram(resized2);

      // So sánh histogram (correlation)
      final similarity = _compareHistograms(hist1, hist2);

      _logger.i('[FACE] Độ tương đồng: ${similarity.toStringAsFixed(1)}%');
      return similarity;
    } catch (e) {
      _logger.e('[FACE] Lỗi so sánh khuôn mặt: $e');
      return 0.0;
    }
  }

  /// Tính histogram của ảnh (đơn giản hóa)
  List<int> _calculateHistogram(img.Image image) {
    final histogram = List<int>.filled(256, 0);

    for (var pixel in image) {
      // Lấy giá trị grayscale
      final r = pixel.r.toInt();
      final g = pixel.g.toInt();
      final b = pixel.b.toInt();
      final gray = ((r + g + b) / 3).round();
      histogram[gray]++;
    }

    return histogram;
  }

  /// So sánh 2 histogram
  /// Trả về độ tương đồng (0-100)
  double _compareHistograms(List<int> hist1, List<int> hist2) {
    double sum1 = 0, sum2 = 0, sumProduct = 0;

    for (int i = 0; i < 256; i++) {
      sum1 += hist1[i] * hist1[i];
      sum2 += hist2[i] * hist2[i];
      sumProduct += hist1[i] * hist2[i];
    }

    // Correlation coefficient
    final correlation = sumProduct / (math.sqrt(sum1) * math.sqrt(sum2));
    return correlation * 100;
  }

  /// Giải phóng tài nguyên
  void dispose() {
    _faceDetector.close();
  }
}

