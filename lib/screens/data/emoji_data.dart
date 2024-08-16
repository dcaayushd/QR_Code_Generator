import 'package:emojis/emoji.dart';

class EmojiData {
  static List<Map<String, String>> getEmojis() {
    return Emoji.all().map((emoji) {
      return {
        "emoji": emoji.char,
        "description": emoji.shortName,
      };
    }).toList();
  }
}