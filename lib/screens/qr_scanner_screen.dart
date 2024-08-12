import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart'
    as ml_kit;
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart' as mobile_scanner;
import 'package:url_launcher/url_launcher.dart';
import 'package:wifi_iot/wifi_iot.dart';

import '../screens/widgets/curve_clippers.dart';
import '../widgets/custom_snackbar.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  QrScannerScreenState createState() => QrScannerScreenState();
}

class QrScannerScreenState extends State<QrScannerScreen> {
  mobile_scanner.MobileScannerController cameraController =
      mobile_scanner.MobileScannerController();
  bool _isFlashOn = false;
  final ImagePicker _imagePicker = ImagePicker();
  File? _selectedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'QR Scanner',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Top curved container
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
          // Bottom curved container
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
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!kIsWeb)
                  Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: const Color(0xFF2A2D3E), width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: _selectedImage != null
                          ? Image.file(_selectedImage!, fit: BoxFit.cover)
                          : mobile_scanner.MobileScanner(
                              controller: cameraController,
                              onDetect: (capture) {
                                final List<mobile_scanner.Barcode> barcodes =
                                    capture.barcodes;
                                for (final barcode in barcodes) {
                                  _processQRCode(barcode.rawValue);
                                }
                              },
                            ),
                    ),
                  )
                else
                  const Text('QR scanning is not available on web'),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildOptionButton(
                      icon: Icons.photo_library,
                      onPressed: _openGallery,
                    ),
                    const SizedBox(width: 20),
                    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS))
                      _buildOptionButton(
                        icon: _isFlashOn ? Icons.flash_on : Icons.flash_off,
                        onPressed: _toggleFlash,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF2A2D3E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(12),
      ),
      child: Icon(icon, color: Colors.white),
    );
  }

  Future<void> _openGallery() async {
    final XFile? pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      try {
        final inputImage = ml_kit.InputImage.fromFilePath(imageFile.path);
        final barcodeScanner = ml_kit.BarcodeScanner();
        final List<ml_kit.Barcode> barcodes =
            await barcodeScanner.processImage(inputImage);

        if (barcodes.isNotEmpty) {
          setState(() {
            _selectedImage = imageFile;
          });
          _processQRCode(barcodes.first.rawValue);
        } else {
          _showErrorSnackBar('No QR code found in the selected image.');
        }

        await barcodeScanner.close();
      } catch (e) {
        _showErrorSnackBar('Error processing the selected image: $e');
      }
    }
  }

  void _processQRCode(String? qrCode) {
    if (qrCode != null && qrCode.isNotEmpty) {
      if (qrCode.startsWith('http') || qrCode.startsWith('https')) {
        _handleUrlQrCode(qrCode);
      } else if (qrCode.startsWith('WIFI:')) {
        _handleWifiQrCode(qrCode);
      } else {
        _showErrorSnackBar('QR Code scanned: $qrCode');
      }
    } else {
      _showErrorSnackBar('Invalid or empty QR code.');
    }
  }

  void _handleUrlQrCode(String url) {
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: const Text('URL QR Code Detected'),
            content: Text('Would you like to open this URL?\n\n$url'),
            actions: <Widget>[
              CupertinoDialogAction(
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              CupertinoDialogAction(
                child: const Text('Open'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _launchUrl(url);
                },
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('URL QR Code Detected'),
            content: Text('Would you like to open this URL?\n\n$url'),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Open'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _launchUrl(url);
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      _showErrorSnackBar('Could not launch $url');
    }
  }

  void _handleWifiQrCode(String wifiString) {
    final regex = RegExp(r'WIFI:S:(.*?);T:(.*?);P:(.*?);');
    final match = regex.firstMatch(wifiString);

    if (match != null) {
      final ssid = match.group(1);
      final type = match.group(2);
      final password = match.group(3);

      if (Platform.isIOS) {
        showCupertinoDialog(
          context: context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: const Text('WiFi QR Code Detected'),
              content: Text(
                  'Would you like to connect to this WiFi network?\n\nSSID: $ssid\nType: $type'),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                CupertinoDialogAction(
                  child: const Text('Connect'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _connectToWifi(ssid!, type!, password!);
                  },
                ),
              ],
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('WiFi QR Code Detected'),
              content: Text(
                  'Would you like to connect to this WiFi network?\n\nSSID: $ssid\nType: $type'),
              actions: <Widget>[
                TextButton(
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('Connect'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _connectToWifi(ssid!, type!, password!);
                  },
                ),
              ],
            );
          },
        );
      }
    } else {
      _showErrorSnackBar('Invalid WiFi QR code format.');
    }
  }

  void _connectToWifi(String ssid, String type, String password) async {
    try {
      await WiFiForIoTPlugin.connect(ssid,
          password: password,
          security: type == 'WPA' ? NetworkSecurity.WPA : NetworkSecurity.NONE);
      _showSuccessSnackBar('Connected to $ssid');
    } catch (e) {
      _showErrorSnackBar('Failed to connect to WiFi: $e');
    }
  }

  void _showErrorSnackBar(String message) {
    CustomSnackBar.show(context, message, Colors.red);
  }

  void _showSuccessSnackBar(String message) {
    CustomSnackBar.show(context, message, Colors.green);
  }

  void _toggleFlash() {
    cameraController.toggleTorch();
    setState(() {
      _isFlashOn = !_isFlashOn;
    });
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }
}

class BrowserInfo {
  final String appName;
  final String packageName;

  BrowserInfo(this.appName, this.packageName);
}
