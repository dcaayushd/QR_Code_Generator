import 'package:flutter/material.dart';
import 'url_qr_screen.dart';
import 'wifi_qr_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code Generator'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UrlQrScreen(),
                  ),
                );
              },
              child: const Text('Generate URL QR Code'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WifiQrScreen(),
                  ),
                );
              },
              child: const Text('Generate WiFi QR Code'),
            ),
          ],
        ),
      ),
    );
  }
}
