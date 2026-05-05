import 'package:explore_wearable_flutter_receiver/wearable_listener.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String status = "Connecting...";
  bool isLoading = false;
  final bool connectionStatus = false;

  @override
  void initState() {
    super.initState();

    WearableListener.onNextCallback = () async {
      await sendToAPI();
    };

    WearableListener.onConnectionChanged = (devices) {
      setState(() {
        if (devices.isEmpty) {
          status = "🔴 Not connected";
        } else {
          final deviceNames = devices.map((d) => d.deviceName).join(", ");
          status = "🟢 Connected to: $deviceNames";
        }
      });
    };
  }

  Future<void> sendToAPI() async {
    setState(() => isLoading = true);

    try {
      await Future.delayed(Duration(seconds: 2));
      // final response = await http.post(
      //   Uri.parse('https://your-api.com/step'),
      //   body: '{"action":"next"}',
      // );

      if (!mounted) return;

      setState(() => isLoading = false);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("✅ Simulate push berhasil")));
    } catch (e) {
      if (!mounted) return;

      setState(() => isLoading = false);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("❌ Gagal kirim")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(title: Text("Flutter Wearable Receiver")),
          body: Center(
            child: Column(
              spacing: 12,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(status),
                ElevatedButton(
                  onPressed: () async {
                    sendToAPI();
                  },
                  child: Text("Send to API"),
                ),
              ],
            ),
          ),
        ),
        if (isLoading)
          Container(
            color: Colors.black54,
            child: const Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }
}
