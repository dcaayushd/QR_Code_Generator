import 'package:flutter/material.dart';
import 'url_qr_screen.dart';
import 'wifi_qr_screen.dart';
import 'widgets/curve_clippers.dart';

class HomeScreen extends StatelessWidget {
  final Function(int) onBottomNavIndexChanged;

  const HomeScreen({super.key, required this.onBottomNavIndexChanged});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'QR Code Generator',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.camera_alt, color: Colors.white),
            onPressed: () {
              onBottomNavIndexChanged(1);
            },
          ),
        ],
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
          // Main content
          Positioned(
            top: MediaQuery.of(context).size.height * 0.15,
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildHomeContent(context),
          ),
        ],
      ),
    );
  }

  Widget _buildHomeContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildButton(
            context,
            icon: Icons.link,
            text: 'Generate Link QR Code',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const UrlQrScreen(),
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildButton(
            context,
            icon: Icons.wifi,
            text: 'Generate WIFI QR Code',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const WifiQrScreen(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(BuildContext context,
      {required IconData icon,
      required String text,
      required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF2A2D3E),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        minimumSize: Size(MediaQuery.of(context).size.width * 0.8, 70),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 24),
          const SizedBox(width: 10),
          Text(text, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
