import 'dart:developer';

import 'package:explore_wearable_flutter_receiver/watch_device_data.dart';
import 'package:flutter/services.dart';

class WearableListener {
  static const _channel = MethodChannel('watch_channel');

  static Function()? onNextCallback;
  static Function(List<WatchDeviceData>)? onConnectionChanged;

  static Future<void> init() async {
    _channel.setMethodCallHandler((call) async {
      log(
        "Received data from Method Channel: ${call.method}, args: ${call.arguments}",
      );

      if (call.method == 'connectionStatus') {
        try {
          final List<dynamic> args = call.arguments as List<dynamic>;
          if (args.isEmpty) return [];

          final List<WatchDeviceData> devices = args
              .map(
                (e) => WatchDeviceData.fromJson(
                  (e as Map).cast<String, dynamic>(),
                ),
              )
              .toList();
          onConnectionChanged?.call(devices);
        } catch (e, stackTrace) {
          log("Error in connectionStatus handler: $e, $stackTrace");
        }
      }

      if (call.method == 'onNext') {
        log("📩 Event dari watch diterima");
        onNextCallback?.call();
      }
    });
  }
}
