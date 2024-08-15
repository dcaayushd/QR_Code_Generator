import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';

Future<bool?> showQrCustomizationDialog({
  required BuildContext context,
  required Color initialColor,
  required String initialStyle,
  required String? initialEmoji,
  required Function(Color color, String style, String? emoji) onCustomize,
}) {
  Color selectedColor = initialColor;
  String selectedStyle = initialStyle;
  String? selectedEmoji = initialEmoji;

  final List<Color> availableColors = [
    Colors.black,
    Colors.purple,
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.pink,
    Colors.teal,
    Colors.indigo,
  ];

  final List<String> availableStyles = [
    'classic',
    'dots',
    'squares',
    'rounded',
  ];

  Widget buildColorSelector() {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: availableColors.length,
            itemBuilder: (context, index) {
              final color = availableColors[index];
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedColor = color;
                  });
                  onCustomize(selectedColor, selectedStyle, selectedEmoji);
                },
                child: Container(
                  width: 40,
                  height: 40,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: selectedColor == color
                          ? Colors.white
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget buildStyleSelector() {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return SizedBox(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: availableStyles.map((style) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Radio<String>(
                      value: style,
                      groupValue: selectedStyle,
                      onChanged: (String? value) {
                        if (value != null) {
                          setState(() {
                            selectedStyle = value;
                          });
                          onCustomize(
                              selectedColor, selectedStyle, selectedEmoji);
                        }
                      },
                    ),
                    Text(style),
                  ],
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget buildEmojiSelector() {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return ElevatedButton(
          child: Text(selectedEmoji ?? 'Select Emoji'),
          onPressed: () {
            if (Platform.isIOS) {
              showCupertinoModalPopup(
                context: context,
                builder: (BuildContext context) {
                  return SizedBox(
                    height: 300,
                    child: CupertinoTextField(
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (String value) {
                        if (value.isNotEmpty) {
                          setState(() {
                            selectedEmoji = value;
                          });
                          onCustomize(
                              selectedColor, selectedStyle, selectedEmoji);
                          Navigator.pop(context);
                        }
                      },
                    ),
                  );
                },
              );
            } else {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return SizedBox(
                    height: 250,
                    child: EmojiPicker(
                      onEmojiSelected: (category, emoji) {
                        setState(() {
                          selectedEmoji = emoji.emoji;
                        });
                        onCustomize(
                            selectedColor, selectedStyle, selectedEmoji);
                        Navigator.pop(context);
                      },
                      config: const Config(
                        height: 256,
                        emojiViewConfig: EmojiViewConfig(
                          emojiSizeMax: 32.0,
                        ),
                        swapCategoryAndBottomBar: false,
                        skinToneConfig: SkinToneConfig(),
                        categoryViewConfig: CategoryViewConfig(
                          initCategory: Category.SMILEYS,
                        ),
                        bottomActionBarConfig: BottomActionBarConfig(),
                        searchViewConfig: SearchViewConfig(),
                      ),
                    ),
                  );
                },
              );
            }
          },
        );
      },
    );
  }

  Widget content = Material(
    color: Colors.transparent,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select QR Code Color:',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        buildColorSelector(),
        const SizedBox(height: 16),
        const Text(
          'Select QR Code Style:',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        buildStyleSelector(),
        const SizedBox(height: 16),
        const Text(
          'Select Emoji:',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        buildEmojiSelector(),
      ],
    ),
  );

  if (Theme.of(context).platform == TargetPlatform.iOS) {
    return showCupertinoDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text(
            'Customize QR Code',
            style: TextStyle(fontSize: 24),
          ),
          content: content,
          actions: [
            CupertinoDialogAction(
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                onCustomize(initialColor, initialStyle, initialEmoji);
                Navigator.of(context).pop(false);
              },
            ),
            CupertinoDialogAction(
              child: const Text('Done'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  } else {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Customize QR Code',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                content,
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.red),
                      ),
                      onPressed: () {
                        onCustomize(initialColor, initialStyle, initialEmoji);
                        Navigator.of(context).pop(false);
                      },
                    ),
                    TextButton(
                      child: const Text('Done'),
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
