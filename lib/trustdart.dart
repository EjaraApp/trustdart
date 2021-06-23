
import 'dart:async';

import 'package:flutter/services.dart';

class Trustdart {
  static const MethodChannel _channel =
      const MethodChannel('trustdart');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String> createWallet() async {
    final mnemonic = await _channel.invokeMethod('createWallet');
    return mnemonic;
  }

  static Future<bool> importWalletFromMnemonic(String mnemonic) async {
    final importStatus = await _channel.invokeMethod('importWalletFromMnemonic', mnemonic);
    return importStatus;
  }

  static Future<Map> generateAddressForCoin(String path, String coin) async {
    final address = await _channel.invokeMethod('generateAddressForCoin', <String, String> {
      'coin': coin,
      'path': path,
    });
    return address;
  }
}
