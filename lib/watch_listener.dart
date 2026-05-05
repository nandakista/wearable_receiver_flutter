import 'dart:developer';

import 'package:flutter/services.dart';

class WatchListener {
  static const _channel = MethodChannel('watch_channel');

  static Future<void> init() async {
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'onNext') {
        log("📩 Event dari watch diterima");

        await sendNextToApi();
      }
    });
  }

  static Future<void> sendNextToApi() async {
    try {
      log("Sending to API");
      await Future.delayed(Duration(seconds: 1));
      // final response = await http.post(
      //   Uri.parse('https://your-api.com/step'),
      //   headers: {
      //     'Content-Type': 'application/json',
      //     // 'Authorization': 'Bearer TOKEN' // kalau ada
      //   },
      //   body: '{"action":"next"}',
      // );

      // log("✅ API response: ${response.statusCode}");
      log("✅ Successfully send to API");
    } catch (e) {
      log("❌ API error: $e");
    }
  }
}