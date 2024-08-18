import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

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

class EmojiBackgroundPainter extends CustomPainter {
  final String emoji;
  final Color color;

  EmojiBackgroundPainter(this.emoji, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: emoji,
        style:
            TextStyle(fontSize: size.width / 6, color: color.withOpacity(0.4)),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    final emojiSize = textPainter.size;
    final positions = [
      Offset(size.width * 0.2, size.height * 0.2),
      Offset(size.width * 0.5, size.height * 0.2),
      Offset(size.width * 0.8, size.height * 0.2),
      Offset(size.width * 0.1, size.height * 0.5),
      Offset(size.width * 0.5, size.height * 0.5),
      Offset(size.width * 0.9, size.height * 0.5),
      Offset(size.width * 0.2, size.height * 0.8),
      Offset(size.width * 0.5, size.height * 0.8),
      Offset(size.width * 0.8, size.height * 0.8),
      Offset(size.width * 0.35, size.height * 0.35),
    ];

    for (final position in positions) {
      textPainter.paint(
          canvas, position - Offset(emojiSize.width / 2, emojiSize.height / 2));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
