import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:ui' as ui;

import '../widgets/custom_snackbar.dart';

class QrUtils {
  static Future<void> saveQrCode(BuildContext context, GlobalKey qrKey) async {
    try {
      RenderRepaintBoundary boundary =
          qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      final result =
          await ImageGallerySaver.saveImage(byteData!.buffer.asUint8List());

      if (result['isSuccess']) {
        if (context.mounted) {
          CustomSnackBar.show(
              context, 'QR Code Saved to Gallery', Colors.green);
        }
      } else {
        if (context.mounted) {
          CustomSnackBar.show(context, 'Failed to Save QR Code', Colors.red);
        }
      }
    } catch (e) {
      if (context.mounted) {
        CustomSnackBar.show(context, 'Error Saving QR Code: $e', Colors.red);
      }
    }
  }

  static Future<void> shareQrCode(BuildContext context, GlobalKey qrKey) async {
    try {
      RenderRepaintBoundary boundary =
          qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/qr_code.png').create();
      await file.writeAsBytes(byteData!.buffer.asUint8List());

      await Share.shareXFiles([XFile(file.path)],
          text: 'Check out this QR Code!');
    } catch (e) {
      if (context.mounted) {
        CustomSnackBar.show(context, 'Error Sharing QR Code: $e', Colors.red);
      }
    }
  }
}
