import 'dart:developer';

import 'package:flutter/services.dart';

class WatchListener {
  static const _channel = MethodChannel('watch_channel');

  static Function()? onNextCallback;

  static Future<void> init() async {
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'onNext') {
        log("📩 Event dari watch diterima");
        onNextCallback?.call();
      }
    });
  }
}
