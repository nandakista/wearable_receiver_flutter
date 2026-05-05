import 'package:explore_wearable_flutter_receiver/watch_listener.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = false;
  final bool connectionStatus = false;

  @override
  void initState() {
    super.initState();

    WatchListener.onNextCallback = () async {
      await handleNextFromWatch();
    };
  }

  Future<void> handleNextFromWatch() async {
    setState(() => isLoading = true);

    try {
      await Future.delayed(Duration(seconds: 2));
      // final response = await http.post(
      //   Uri.parse('https://your-api.com/step'),
      //   body: '{"action":"next"}',
      // );

      if (!mounted) return;

      setState(() => isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("✅ Next berhasil"),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() => isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("❌ Gagal kirim"),
        ),
      );
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
                Text('Connection Status: $connectionStatus'),
                ElevatedButton(
                  onPressed: () async {
                    handleNextFromWatch();
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
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }
}
