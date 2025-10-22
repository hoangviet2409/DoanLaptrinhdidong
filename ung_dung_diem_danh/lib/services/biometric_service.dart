import 'package:local_auth/local_auth.dart';
import 'package:logger/logger.dart';

class BiometricService {
  final LocalAuthentication _auth = LocalAuthentication();
  final Logger _logger = Logger();

  /// Kiểm tra thiết bị có hỗ trợ sinh trắc học không
  Future<bool> isBiometricAvailable() async {
    try {
      final isAvailable = await _auth.canCheckBiometrics;
      final isDeviceSupported = await _auth.isDeviceSupported();
      
      return isAvailable || isDeviceSupported;
    } catch (e) {
      _logger.e('Lỗi kiểm tra biometric: $e');
      return false;
    }
  }

  /// Lấy danh sách các loại sinh trắc học có sẵn
  /// Ví dụ: fingerprint, face, iris
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _auth.getAvailableBiometrics();
    } catch (e) {
      _logger.e('Lỗi lấy danh sách biometric: $e');
      return [];
    }
  }

  /// Xác thực bằng sinh trắc học
  /// Trả về true nếu xác thực thành công
  Future<bool> authenticate({
    String reason = 'Xác thực để tiếp tục',
    bool useErrorDialogs = true,
    bool stickyAuth = true,
  }) async {
    try {
      // Kiểm tra hỗ trợ
      final isAvailable = await isBiometricAvailable();
      if (!isAvailable) {
        _logger.w('Thiết bị không hỗ trợ sinh trắc học');
        return false;
      }

      // Thực hiện xác thực
      final isAuthenticated = await _auth.authenticate(
        localizedReason: reason,
        options: AuthenticationOptions(
          useErrorDialogs: useErrorDialogs,
          stickyAuth: stickyAuth,
          biometricOnly: false, // Cho phép dùng PIN/Pattern nếu sinh trắc thất bại
        ),
      );

      if (isAuthenticated) {
        _logger.i('✅ Xác thực sinh trắc học thành công');
      } else {
        _logger.w('❌ Xác thực sinh trắc học thất bại');
      }

      return isAuthenticated;
    } catch (e) {
      _logger.e('Lỗi xác thực sinh trắc học: $e');
      return false;
    }
  }

  /// Kiểm tra loại sinh trắc học có sẵn (để hiển thị UI phù hợp)
  Future<String> getBiometricTypeString() async {
    final biometrics = await getAvailableBiometrics();
    
    if (biometrics.isEmpty) {
      return 'Không có sinh trắc học';
    }

    if (biometrics.contains(BiometricType.face)) {
      return 'Face ID';
    } else if (biometrics.contains(BiometricType.fingerprint)) {
      return 'Vân tay';
    } else if (biometrics.contains(BiometricType.iris)) {
      return 'Mống mắt';
    } else if (biometrics.contains(BiometricType.strong)) {
      return 'Sinh trắc học mạnh';
    } else if (biometrics.contains(BiometricType.weak)) {
      return 'Sinh trắc học yếu';
    }

    return 'Sinh trắc học';
  }

  /// Xác thực chỉ dùng sinh trắc học (không dùng PIN/Pattern)
  Future<bool> authenticateBiometricOnly({
    String reason = 'Xác thực sinh trắc học',
  }) async {
    try {
      final isAvailable = await isBiometricAvailable();
      if (!isAvailable) {
        return false;
      }

      final isAuthenticated = await _auth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
          biometricOnly: true, // CHỈ dùng sinh trắc học
        ),
      );

      return isAuthenticated;
    } catch (e) {
      _logger.e('Lỗi xác thực biometric only: $e');
      return false;
    }
  }

  /// Dừng xác thực (nếu đang chờ)
  Future<void> stopAuthentication() async {
    try {
      await _auth.stopAuthentication();
    } catch (e) {
      _logger.e('Lỗi dừng xác thực: $e');
    }
  }
}

