import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/emoji_provider.dart';
import '../screens/widgets/curve_clippers.dart';
import '../screens/widgets/qr_customization_dialog.dart';
import '../utils/qr_utils.dart';
import '../widgets/action_button.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/qr_display.dart';

class UrlQrScreen extends StatefulWidget {
  const UrlQrScreen({super.key});

  @override
  UrlQrScreenState createState() => UrlQrScreenState();
}

class UrlQrScreenState extends State<UrlQrScreen> {
  final _urlController = TextEditingController();
  String? _qrData;
  final GlobalKey _qrKey = GlobalKey();
  Color _qrColor = Colors.black;
  String _qrStyle = 'Classic';
  String? _selectedEmoji;

  late Color _initialQrColor;
  late String _initialQrStyle;
  String? _initialSelectedEmoji;



List<Map<String, String>> get recentEmojis => Provider.of<EmojiProvider>(context, listen: false).recentEmojis;

  @override
  void initState() {
    super.initState();
    _qrColor = _initialQrColor = Colors.black;
    _qrStyle = _initialQrStyle = 'Classic';
    _selectedEmoji = _initialSelectedEmoji = null;
  }

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


  void _customizeQrCode() {
  showQrCustomizationDialog(
    context: context,
    initialColor: _qrColor,
    initialStyle: _qrStyle,
    initialEmoji: _selectedEmoji,
    recentEmojis: recentEmojis,
    onCustomize: (Color color, String style, String? emoji) {
      setState(() {
        _qrColor = color;
        _qrStyle = style;
        _selectedEmoji = emoji;
      });
    },
    onSave: (Color color, String style, String? emoji, List<Map<String, String>> updatedRecentEmojis) {
      setState(() {
        _qrColor = color;
        _qrStyle = style;
        _selectedEmoji = emoji;
      });
      Provider.of<EmojiProvider>(context, listen: false).updateRecentEmojis(updatedRecentEmojis);
    },
  ).then((value) {
    if (value == false) {
      setState(() {
        _qrColor = _initialQrColor;
        _qrStyle = _initialQrStyle;
        _selectedEmoji = _initialSelectedEmoji;
      });
    }
  });
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
                            borderSide: const BorderSide(
                              color: Color(0xFF2A2D3E),
                            ),
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
                          horizontal: 20,
                          vertical: 15,
                        ),
                        minimumSize:
                            Size(MediaQuery.of(context).size.width * 0.8, 70),
                      ),
                      child: const Text(
                        'Generate QR Code',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (_qrData != null) ...[
                      Column(
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
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
                                child: const Icon(
                                  Icons.edit,
                                  color: Colors.black,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          RepaintBoundary(
                            key: _qrKey,
                            child: QrDisplay(
                              data: _qrData!,
                              size: const Size(300, 300),
                              color: _qrColor,
                              emoji: _selectedEmoji,
                              style: _qrStyle,
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
    _urlController.dispose();
    super.dispose();
  }
}