import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/emoji_provider.dart';
import '../screens/widgets/curve_clippers.dart';
import '../screens/widgets/qr_customization_dialog.dart';
import '../utils/qr_generator.dart';
import '../utils/qr_utils.dart';
import '../widgets/action_button.dart';
import '../widgets/custom_snackbar.dart';
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
  final GlobalKey _qrKey = GlobalKey();

  Color _qrColor = Colors.black;
  String _qrStyle = 'Classic';
  String? _selectedEmoji;


  List<Map<String, String>> get recentEmojis =>
      Provider.of<EmojiProvider>(context, listen: false).recentEmojis;
  Color _tempQrColor = Colors.black;
  String _tempQrStyle = 'Classic';
  String? _tempSelectedEmoji;



  void _customizeQrCode() {
    // Initialize temporary variables with current saved values
    _tempQrColor = _qrColor;
    _tempQrStyle = _qrStyle;
    _tempSelectedEmoji = _selectedEmoji;

    showQrCustomizationDialog(
      context: context,
      initialColor: _qrColor,
      initialStyle: _qrStyle,
      initialEmoji: _selectedEmoji,
      recentEmojis: recentEmojis,
      onCustomize: (Color color, String style, String? emoji) {
        setState(() {
          _tempQrColor = color;
          _tempQrStyle = style;
          _tempSelectedEmoji = emoji;
        });
      },
      onSave: (Color color, String style, String? emoji,
          List<Map<String, String>> updatedRecentEmojis) {
        setState(() {
          // Save changes permanently
          _qrColor = color;
          _qrStyle = style;
          _selectedEmoji = emoji;
          // Update temporary variables to match saved state
          _tempQrColor = color;
          _tempQrStyle = style;
          _tempSelectedEmoji = emoji;
        });
        Provider.of<EmojiProvider>(context, listen: false)
            .updateRecentEmojis(updatedRecentEmojis);
      },
    ).then((value) {
      if (value == false) {
        // If canceled, revert temporary variables to the last saved state
        setState(() {
          _tempQrColor = _qrColor;
          _tempQrStyle = _qrStyle;
          _tempSelectedEmoji = _selectedEmoji;
        });
      }
    });
  }

  void _showErrorSnackBar(String message) {
    CustomSnackBar.show(context, message, Colors.red);
  }

  void _generateQrCode() {
    final ssid = _ssidController.text.trim();
    final password = _passwordController.text.trim();

    if (ssid.isEmpty && password.isEmpty) {
      _showErrorSnackBar('Please Enter both SSID and Password');
    } else if (ssid.isEmpty) {
      _showErrorSnackBar('Please Enter the SSID');
    } else if (password.isEmpty) {
      _showErrorSnackBar('Please Enter the Password');
    } else if (password.length < 8) {
      _showErrorSnackBar('Password must be at least 8 characters long');
    } else {
      setState(() {
        _qrData = QrGenerator.getWifiString(
          ssid: ssid,
          password: password,
        );
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
          'WiFi QR Code',
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
                        controller: _ssidController,
                        decoration: InputDecoration(
                          labelText: 'Enter WiFi SSID',
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
                    const SizedBox(height: 10),
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
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Enter WiFi Password',
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
                        obscureText: true,
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
                      Stack(
                        alignment: Alignment.topRight,
                        children: [
            
                          RepaintBoundary(
                            key: _qrKey,
                            child: QrDisplay(
                              data: _qrData!,
                              size: const Size(300, 300),
                              color: _tempQrColor,
                              emoji: _tempSelectedEmoji,
                              style: _tempQrStyle,
                            ),
                          ),
                          Positioned(
                            top: 10,
                            right: 10,
                            child: GestureDetector(
                              onTap: _customizeQrCode,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      spreadRadius: 1,
                                      blurRadius: 3,
                                      offset: const Offset(0, 1),
                                    ),
                                  ],
                                ),
                                child: const Icon(Icons.edit,
                                    color: Colors.black, size: 20),
                              ),
                            ),
                          ),
                        ],
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
    _ssidController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
