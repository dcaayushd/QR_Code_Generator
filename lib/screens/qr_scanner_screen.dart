import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_code_tools/qr_code_tools.dart';
import '../screens/widgets/curve_clippers.dart';
import '../widgets/custom_snackbar.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  QrScannerScreenState createState() => QrScannerScreenState();
}

class QrScannerScreenState extends State<QrScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
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
                          : QRView(
                              key: qrKey,
                              onQRViewCreated: _onQRViewCreated,
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

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      _processQRCode(scanData.code);
    });
  }

  Future<void> _openGallery() async {
    final XFile? pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      try {
        String? qrCode = await QrCodeToolsPlugin.decodeFrom(imageFile.path);
        if (qrCode != null && qrCode.isNotEmpty) {
          setState(() {
            _selectedImage = imageFile;
          });
          _processQRCode(qrCode);
        } else {
          _showErrorSnackBar('No QR code found in the selected image.');
        }
      } catch (e) {
        _showErrorSnackBar('Error processing the selected image.');
      }
    }
  }

  void _processQRCode(String? qrCode) {
    if (qrCode != null && qrCode.isNotEmpty) {
      // Process the QR code data
      if (qrCode.startsWith('http') || qrCode.startsWith('https')) {
        _showErrorSnackBar('Valid URL QR Code: $qrCode');
      } else if (qrCode.startsWith('WIFI:')) {
        _showErrorSnackBar('Valid WiFi QR Code: $qrCode');
      } else {
        _showErrorSnackBar('QR Code scanned: $qrCode');
      }
    } else {
      _showErrorSnackBar('Invalid or empty QR code.');
    }
  }

  void _showErrorSnackBar(String message) {
    CustomSnackBar.show(context, message);
  }

  void _toggleFlash() {
    if (controller != null) {
      controller!.toggleFlash();
      setState(() {
        _isFlashOn = !_isFlashOn;
      });
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}