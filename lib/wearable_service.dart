import 'package:flutter/services.dart';

class WearableService {
  static const _channel = MethodChannel('watch_channel');

  static Future<void> sendToWatch(String message) async {
    await _channel.invokeMethod('sendToWatch', {
      "message": message,
      "path": "/notify",
    });
  }
}