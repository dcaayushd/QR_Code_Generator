import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'emoji_background_painter.dart'; 

class QrDisplay extends StatelessWidget {
  final String data;
  final Size size;
  final Color color;
  final String? emoji;
  final String style;

  const QrDisplay({
    super.key,
    required this.data,
    this.size = const Size(250, 250),
    required this.color,
    this.emoji,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        if (emoji != null)
          CustomPaint(
            size: size,
            painter: EmojiBackgroundPainter(emoji!, color),
          ),
        QrImageView(
          data: data,
          version: QrVersions.auto,
          size: size.width,
          backgroundColor: Colors.transparent,
          eyeStyle: QrEyeStyle(
            eyeShape: style == 'Classic' || style == 'Emboss'
                ? QrEyeShape.square
                : QrEyeShape.circle,
            color: color,
          ),
          dataModuleStyle: QrDataModuleStyle(
            dataModuleShape: style == 'Dots' || style == 'Emboss'
                ? QrDataModuleShape.circle
                : QrDataModuleShape.square,
            color: color,
          ),
        ),
      ],
    );
  }
}