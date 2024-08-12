import 'package:flutter/material.dart';
import '../utils/qr_utils.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/qr_display.dart';
import '../widgets/action_button.dart';
import '../screens/widgets/curve_clippers.dart';

class UrlQrScreen extends StatefulWidget {
  const UrlQrScreen({super.key});

  @override
  UrlQrScreenState createState() => UrlQrScreenState();
}

class UrlQrScreenState extends State<UrlQrScreen> {
  final _urlController = TextEditingController();
  String? _qrData;
  final GlobalKey _qrKey = GlobalKey();

  bool _isValidUrl(String url) {
    final urlPattern = RegExp(
      r'^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$',
    );
    return urlPattern.hasMatch(url);
  }

  void _showErrorSnackBar(String message) {
    CustomSnackBar.show(context, message, Colors.red);
  }

  void _generateQrCode() {
    final url = _urlController.text.trim();
    if (url.isEmpty) {
      _showErrorSnackBar('Please enter a URL');
    } else if (!_isValidUrl(url)) {
      _showErrorSnackBar('Please enter a valid URL');
    } else {
      setState(() {
        _qrData = url;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'URL QR Code',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipPath(
              clipper: TopCurveClipper(),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.4,
                color: const Color(0xFF2A2D3E),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ClipPath(
              clipper: BottomCurveClipper(),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.7,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.25,
            left: 0,
            right: 0,
            bottom: 0,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _urlController,
                        decoration: InputDecoration(
                          labelText: 'Enter URL',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide:
                                const BorderSide(color: Color(0xFF2A2D3E)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _generateQrCode,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2A2D3E),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15),
                        minimumSize:
                            Size(MediaQuery.of(context).size.width * 0.8, 70),
                      ),
                      child: const Text('Generate QR Code',
                          style: TextStyle(fontSize: 16)),
                    ),
                    const SizedBox(height: 20),
                    if (_qrData != null) ...[
                      RepaintBoundary(
                        key: _qrKey,
                        child: QrDisplay(
                          data: _qrData!,
                          size: const Size(300, 300),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ActionButton(
                            icon: Icons.save_alt,
                            label: 'Save',
                            onPressed: () =>
                                QrUtils.saveQrCode(context, _qrKey),
                          ),
                          ActionButton(
                            icon: Icons.share,
                            label: 'Share',
                            onPressed: () =>
                                QrUtils.shareQrCode(context, _qrKey),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }
}
