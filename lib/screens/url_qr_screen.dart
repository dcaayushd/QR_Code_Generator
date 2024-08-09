import 'package:flutter/material.dart';
import '../widgets/qr_display.dart';

class UrlQrScreen extends StatefulWidget {
  const UrlQrScreen({super.key});

  @override
  UrlQrScreenState createState() => UrlQrScreenState();
}

class UrlQrScreenState extends State<UrlQrScreen> {
  final _urlController = TextEditingController();
  String? _qrData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'URL QR Code',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _urlController,
              decoration: const InputDecoration(
                labelText: 'Enter URL',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(
                  () {
                    _qrData = _urlController.text;
                  },
                );
              },
              child: const Text(
                'Generate QR Code',
              ),
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
    _urlController.dispose();
    super.dispose();
  }
}
