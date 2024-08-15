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
        QrImageView(
          data: data,
          version: QrVersions.auto,
          size: size.width,
          backgroundColor: Colors.white,
          eyeStyle: QrEyeStyle(
            eyeShape:
                style == 'rounded' ? QrEyeShape.square : QrEyeShape.circle,
            color: color,
          ),
          dataModuleStyle: QrDataModuleStyle(
            dataModuleShape: style == 'dots'
                ? QrDataModuleShape.circle
                : QrDataModuleShape.square,
            color: color,
          ),
          embeddedImageStyle: QrEmbeddedImageStyle(
            size: Size(size.width * 0.2, size.width * 0.2),
          ),
        ),
        if (emoji != null)
          Text(
            emoji!,
            style: TextStyle(
              fontSize: size.width * 0.2,
              color: color,
            ),
          ),
      ],
    );
  }
}
