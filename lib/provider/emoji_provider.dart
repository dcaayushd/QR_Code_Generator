import 'package:flutter/foundation.dart';

class EmojiProvider extends ChangeNotifier {
  List<Map<String, String>> _recentEmojis = [];

  List<Map<String, String>> get recentEmojis => _recentEmojis;

  void updateRecentEmojis(List<Map<String, String>> updatedEmojis) {
    _recentEmojis = updatedEmojis;
    notifyListeners();
  }

  void addRecentEmoji(String emoji) {
    if (!_recentEmojis.any((map) => map['emoji'] == emoji)) {
      _recentEmojis.insert(0, {'emoji': emoji});
    } else {
      _recentEmojis.removeWhere((map) => map['emoji'] == emoji);
      _recentEmojis.insert(0, {'emoji': emoji});
    }

    if (_recentEmojis.length > 30) {
      _recentEmojis.removeLast();
    }

    notifyListeners();
  }
}