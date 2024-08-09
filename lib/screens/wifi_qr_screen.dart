import 'package:flutter/material.dart';
import '../utils/qr_generator.dart';
import '../widgets/qr_display.dart';

class WifiQrScreen extends StatefulWidget {
  const WifiQrScreen({super.key});

  @override
  WifiQrScreenState createState() => WifiQrScreenState();
}

class WifiQrScreenState extends State<WifiQrScreen> {
  final _ssidController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _qrData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'WiFi QR Code',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _ssidController,
              decoration: const InputDecoration(
                labelText: 'Enter WiFi SSID',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Enter WiFi Password',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(
                  () {
                    _qrData = QrGenerator.getWifiString(
                      ssid: _ssidController.text,
                      password: _passwordController.text,
                    );
                  },
                );
              },
              child: const Text('Generate QR Code'),
            ),
            const SizedBox(height: 20),
            if (_qrData != null) QrDisplay(data: _qrData!),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _ssidController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
