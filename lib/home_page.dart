import 'package:explore_wearable_flutter_receiver/watch_listener.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final bool connectionStatus = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Flutter Wearable Receiver")),
      body: Center(
        child: Column(
          spacing: 12,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Connection Status: $connectionStatus'),
            ElevatedButton(
              onPressed: () async {
                WatchListener.sendNextToApi();
              },
              child: Text("Send to API"),
            ),
          ],
        ),
      ),
    );
  }
}
