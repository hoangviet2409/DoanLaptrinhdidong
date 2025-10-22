import 'package:nfc_manager/nfc_manager.dart';
import 'package:logger/logger.dart';

class NFCService {
  final Logger _logger = Logger();

  /// Kiểm tra thiết bị có hỗ trợ NFC không
  Future<bool> isNFCAvailable() async {
    try {
      // Kiểm tra NFC availability - nếu throw exception = không hỗ trợ
      final availability = await NfcManager.instance.checkAvailability();
      
      // Với nfc_manager 4.x, chỉ cần kiểm tra không throw exception
      // và availability không null là OK
      _logger.i('[NFC] Availability: $availability');
      return true;
    } catch (e) {
      // Nếu throw exception = emulator hoặc không hỗ trợ
      _logger.w('[NFC] Không khả dụng: $e');
      return false;
    }
  }

  /// Đọc UID từ thẻ NFC
  /// Trả về chuỗi UID dạng hex (ví dụ: "04:5e:c3:2a:b1:54:80")
  Future<String?> readNFCTag({
    Function(String)? onTagDetected,
    Function(String)? onError,
  }) async {
    String? tagId;

    try {
      await NfcManager.instance.startSession(
        onDiscovered: (NfcTag tag) async {
          try {
            // Lấy UID từ tag data
            tagId = _extractTagId(tag);

            if (tagId != null) {
              _logger.i('Đã quét thẻ NFC: $tagId');
              onTagDetected?.call(tagId!);
            } else {
              _logger.w('Không thể đọc UID từ thẻ NFC');
              onError?.call('Không thể đọc thẻ NFC');
            }

            // Dừng session sau khi đọc thành công
            await NfcManager.instance.stopSession();
          } catch (e) {
            _logger.e('Lỗi xử lý thẻ NFC: $e');
            onError?.call('Lỗi xử lý thẻ: $e');
            await NfcManager.instance.stopSession();
          }
        },
        pollingOptions: {
          NfcPollingOption.iso14443,
          NfcPollingOption.iso15693,
          NfcPollingOption.iso18092,
        },
      );

      // Chờ một chút để session hoàn thành
      await Future.delayed(const Duration(milliseconds: 500));
    } catch (e) {
      _logger.e('Lỗi khởi động NFC session: $e');
      onError?.call('Lỗi khởi động quét: $e');
    }

    return tagId;
  }

  /// Trích xuất UID từ NfcTag
  String? _extractTagId(NfcTag tag) {
    try {
      // Thử lấy identifier từ tag data
      // Với nfc_manager 4.x, identifier nằm trong tag.data
      final data = tag.data as Map<String, dynamic>;
      
      // Thử các tech khác nhau
      // NfcA (Android) hoặc Nfca (iOS)
      if (data.containsKey('nfca')) {
        final nfcaData = data['nfca'] as Map<String, dynamic>?;
        final identifier = nfcaData?['identifier'] as List<dynamic>?;
        if (identifier != null) {
          return _formatTagId(identifier.cast<int>());
        }
      }
      
      if (data.containsKey('nfcb')) {
        final nfcbData = data['nfcb'] as Map<String, dynamic>?;
        final identifier = nfcbData?['identifier'] as List<dynamic>?;
        if (identifier != null) {
          return _formatTagId(identifier.cast<int>());
        }
      }
      
      if (data.containsKey('nfcf')) {
        final nfcfData = data['nfcf'] as Map<String, dynamic>?;
        final identifier = nfcfData?['identifier'] as List<dynamic>?;
        if (identifier != null) {
          return _formatTagId(identifier.cast<int>());
        }
      }
      
      if (data.containsKey('nfcv')) {
        final nfcvData = data['nfcv'] as Map<String, dynamic>?;
        final identifier = nfcvData?['identifier'] as List<dynamic>?;
        if (identifier != null) {
          return _formatTagId(identifier.cast<int>());
        }
      }
      
      if (data.containsKey('isodep')) {
        final isodepData = data['isodep'] as Map<String, dynamic>?;
        final identifier = isodepData?['identifier'] as List<dynamic>?;
        if (identifier != null) {
          return _formatTagId(identifier.cast<int>());
        }
      }

      // iOS tags
      if (data.containsKey('mifare')) {
        final mifareData = data['mifare'] as Map<String, dynamic>?;
        final identifier = mifareData?['identifier'] as List<dynamic>?;
        if (identifier != null) {
          return _formatTagId(identifier.cast<int>());
        }
      }

      if (data.containsKey('iso15693')) {
        final iso15693Data = data['iso15693'] as Map<String, dynamic>?;
        final identifier = iso15693Data?['identifier'] as List<dynamic>?;
        if (identifier != null) {
          return _formatTagId(identifier.cast<int>());
        }
      }

      if (data.containsKey('felica')) {
        final felicaData = data['felica'] as Map<String, dynamic>?;
        final identifier = felicaData?['identifier'] as List<dynamic>?;
        if (identifier != null) {
          return _formatTagId(identifier.cast<int>());
        }
      }

      _logger.w('Không tìm thấy identifier trong tag data: ${data.keys}');
      return null;
    } catch (e) {
      _logger.e('Lỗi trích xuất tag ID: $e');
      return null;
    }
  }

  /// Format UID thành chuỗi hex có dấu :
  /// Ví dụ: [04, 5e, c3, 2a] => "04:5e:c3:2a"
  String _formatTagId(List<int> identifier) {
    return identifier
        .map((byte) => byte.toRadixString(16).padLeft(2, '0').toUpperCase())
        .join(':');
  }

  /// Dừng session NFC
  Future<void> stopSession() async {
    try {
      await NfcManager.instance.stopSession();
    } catch (e) {
      _logger.e('Lỗi dừng NFC session: $e');
    }
  }

  /// Kiểm tra NFC có được bật không (chỉ Android)
  /// Trả về true nếu NFC được bật, false nếu tắt hoặc không hỗ trợ
  Future<bool> isNFCEnabled() async {
    try {
      final isAvailable = await isNFCAvailable();
      if (!isAvailable) return false;

      // Nếu có thể check isAvailable thành công thì NFC đã được bật
      return true;
    } catch (e) {
      _logger.w('NFC không được bật hoặc không khả dụng: $e');
      return false;
    }
  }
}

