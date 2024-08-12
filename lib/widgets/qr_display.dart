import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrDisplay extends StatelessWidget {
  final String data;
  final Size size;

  const QrDisplay({
    super.key,
    required this.data,
    Size? size,
  }) : size = size ?? const Size(250, 250);

  @override
  Widget build(BuildContext context) {
    return QrImageView(
      data: data,
      version: QrVersions.auto,
      size: size.width,
    );
  }
}
