import 'dart:async';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';

class NfcService {
  Future<bool> isAvailable() async {
    try {
      final availability = await FlutterNfcKit.nfcAvailability;
      return availability == NFCAvailability.available;
    } catch (e) {
      return false;
    }
  }

  Future<String?> readTagOnce({Duration timeout = const Duration(seconds: 15)}) async {
    if (!await isAvailable()) return null;

    try {
      final tag = await FlutterNfcKit.poll(timeout: timeout);
      return tag.id;
    } catch (e) {
      return null;
    }
  }

  void stopNfc() {
    try {
      FlutterNfcKit.finish();
    } catch (e) {
      // Ignore errors when stopping NFC
    }
  }
}


