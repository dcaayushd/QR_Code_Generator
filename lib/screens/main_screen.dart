import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'qr_scanner_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      HomeScreen(onBottomNavIndexChanged: _onItemTapped),
      const QrScannerScreen(),
    ];

    return Scaffold(
      body: screens[_selectedIndex],
      bottomNavigationBar: Container(
        height: 80,
        margin: const EdgeInsets.all(0),
        padding: const EdgeInsets.only(bottom: 20, top: 10),
        decoration: const BoxDecoration(
          color: Color(0xFF2A2D3E),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50),
            topRight: Radius.circular(50),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () => _onItemTapped(0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.home_filled,
                    color: _selectedIndex == 0 ? Colors.white : Colors.grey,
                    size: 34,
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => _onItemTapped(1),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.qr_code_scanner,
                    color: _selectedIndex == 1 ? Colors.white : Colors.grey,
                    size: 34,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}