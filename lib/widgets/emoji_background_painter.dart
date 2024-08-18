import 'dart:math';
import 'package:flutter/material.dart';

class EmojiBackgroundPainter extends CustomPainter {
  final String emoji;
  final Color color;
  late final Random random;

  EmojiBackgroundPainter(this.emoji, this.color) {
    random =
        Random(emoji.codeUnits.reduce((value, element) => value + element));
  }

  @override
  void paint(Canvas canvas, Size size) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: emoji,
        style:
            TextStyle(fontSize: size.width / 8, color: color.withOpacity(0.9)),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    final emojiSize = textPainter.size;
    final positions = _getPatternPositions(size, emojiSize);

    for (final position in positions) {
      textPainter.paint(
          canvas, position - Offset(emojiSize.width / 2, emojiSize.height / 2));
    }
  }

  List<Offset> _getPatternPositions(Size size, Size emojiSize) {
    final patterns = [
      _diamondPattern,
      _horizontalLinePattern,
      _nPattern,
      _starPattern,
      _verticalLinePattern,
      _zPattern,
    ];
    final selectedPattern = patterns[random.nextInt(patterns.length)];
    return selectedPattern(size, emojiSize);
  }

  List<Offset> _diamondPattern(Size size, Size emojiSize) {
    return [
      Offset(size.width * 0.5, size.height * 0.2),
      Offset(size.width * 0.3, size.height * 0.4),
      Offset(size.width * 0.7, size.height * 0.4),
      Offset(size.width * 0.2, size.height * 0.6),
      Offset(size.width * 0.5, size.height * 0.6),
      Offset(size.width * 0.8, size.height * 0.6),
      Offset(size.width * 0.5, size.height * 0.8),
    ];
  }

  List<Offset> _horizontalLinePattern(Size size, Size emojiSize) {
    return List.generate(5, (index) {
      return Offset(size.width * (index + 1) / 6, size.height * 0.5);
    });
  }

  List<Offset> _verticalLinePattern(Size size, Size emojiSize) {
    return List.generate(5, (index) {
      return Offset(size.width * 0.5, size.height * (index + 1) / 6);
    });
  }

  List<Offset> _zPattern(Size size, Size emojiSize) {
    return [
      Offset(size.width * 0.2, size.height * 0.2),
      Offset(size.width * 0.5, size.height * 0.2),
      Offset(size.width * 0.8, size.height * 0.2),
      Offset(size.width * 0.5, size.height * 0.5),
      Offset(size.width * 0.2, size.height * 0.8),
      Offset(size.width * 0.5, size.height * 0.8),
      Offset(size.width * 0.8, size.height * 0.8),
    ];
  }

  List<Offset> _starPattern(Size size, Size emojiSize) {
    return [
      Offset(size.width * 0.5, size.height * 0.2),
      Offset(size.width * 0.3, size.height * 0.4),
      Offset(size.width * 0.7, size.height * 0.4),
      Offset(size.width * 0.2, size.height * 0.6),
      Offset(size.width * 0.8, size.height * 0.6),
      Offset(size.width * 0.5, size.height * 0.8),
    ];
  }

  List<Offset> _nPattern(Size size, Size emojiSize) {
    return [
      Offset(size.width * 0.2, size.height * 0.2),
      Offset(size.width * 0.2, size.height * 0.5),
      Offset(size.width * 0.2, size.height * 0.8),
      Offset(size.width * 0.5, size.height * 0.5),
      Offset(size.width * 0.8, size.height * 0.2),
      Offset(size.width * 0.8, size.height * 0.5),
      Offset(size.width * 0.8, size.height * 0.8),
    ];
  }

  @override
  bool shouldRepaint(covariant EmojiBackgroundPainter oldDelegate) {
    return oldDelegate.emoji != emoji || oldDelegate.color != color;
  }
}
