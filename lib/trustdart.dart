
import 'dart:async';

import 'package:flutter/services.dart';

class Trustdart {
  static const MethodChannel _channel =
      const MethodChannel('trustdart');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
