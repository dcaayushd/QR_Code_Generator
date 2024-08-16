import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'provider/emoji_provider.dart';
import '../screens/main_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => EmojiProvider(),
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QR Code Generator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainScreen(),
    );
  }
}
