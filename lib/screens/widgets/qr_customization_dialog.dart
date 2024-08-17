import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_generator/screens/data/emoji_data.dart';

import '../../provider/emoji_provider.dart';

Future<bool?> showQrCustomizationDialog({
  required BuildContext context,
  required Color initialColor,
  required String initialStyle,
  required String? initialEmoji,
  required List<Map<String, String>> recentEmojis,
  required Function(Color color, String style, String? emoji) onCustomize,
  required Function(Color color, String style, String? emoji,
          List<Map<String, String>> updatedRecentEmojis)
      onSave,
}) {
  Color selectedColor = initialColor;
  String selectedStyle = initialStyle;
  String? selectedEmoji = initialEmoji;


  final List<Color> availableColors = [
    Colors.black,
    Colors.amber,
    Colors.blue,
    Colors.brown,
    Colors.cyan,
    Colors.green,
    Colors.grey,
    Colors.indigo,
    Colors.orange,
    Colors.pink,
    Colors.purple,
    Colors.red,
    Colors.teal,
  ];

  final List<String> availableStyles = [
    'Classic',
    'Dots',
    'Stripe',
    'Emboss',
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
                      activeColor: selectedColor,
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
        List<Map<String, String>> allEmojis = EmojiData.getEmojis();
        List<Map<String, String>> filteredEmojis = allEmojis;
        TextEditingController searchController = TextEditingController();
        PageController pageController = PageController(initialPage: 1);
        int currentPage = 1; // 0 for Recent, 1 for All

        Future<void> selectEmoji(
            String? emoji, StateSetter setModalState) async {
          if (emoji != null) {
            Provider.of<EmojiProvider>(context, listen: false)
                .addRecentEmoji(emoji);
            setState(() {
              selectedEmoji = emoji;
            });
            onCustomize(selectedColor, selectedStyle, selectedEmoji);
          }
        }

        return GestureDetector(
          onTap: () async {
            final String? result = await showModalBottomSheet<String>(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (BuildContext context) {
                return StatefulBuilder(
                  builder: (BuildContext context, StateSetter setModalState) {
                    return DraggableScrollableSheet(
                      initialChildSize: 0.5,
                      minChildSize: 0.2,
                      maxChildSize: 0.75,
                      builder: (_, controller) {
                        return Container(
                          decoration: BoxDecoration(
                            color: CupertinoColors.systemBackground
                                .resolveFrom(context),
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(20)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Center(
                                  child: Container(
                                    width: 40,
                                    height: 5,
                                    decoration: BoxDecoration(
                                      color: CupertinoColors.separator
                                          .resolveFrom(context),
                                      borderRadius: BorderRadius.circular(2.5),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                child: CupertinoSearchTextField(
                                  controller: searchController,
                                  placeholder: 'Search',
                                  onChanged: (String value) {
                                    setModalState(() {
                                      filteredEmojis = allEmojis
                                          .where((emojiMap) =>
                                              emojiMap["emoji"]!
                                                  .contains(value) ||
                                              emojiMap["description"]!
                                                  .toLowerCase()
                                                  .contains(
                                                      value.toLowerCase()))
                                          .toList();
                                    });
                                  },
                                  suffixMode: OverlayVisibilityMode.editing,
                                ),
                              ),
                              Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: currentPage == 0
                                            ? CupertinoColors.activeBlue
                                            : CupertinoColors.inactiveGray,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: currentPage == 1
                                            ? CupertinoColors.activeBlue
                                            : CupertinoColors.inactiveGray,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 16, top: 8, bottom: 8),
                                child: Text(
                                  currentPage == 1 ? 'All' : 'Recent',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: CupertinoColors.label
                                        .resolveFrom(context),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: PageView(
                                  controller: pageController,
                                  onPageChanged: (index) {
                                    setModalState(() {
                                      currentPage = index;
                                    });
                                  },
                                  children: [
                                    // Recent page
                                    GridView.builder(
                                      controller: controller,
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 6,
                                        childAspectRatio: 1,
                                      ),
                                      itemCount: recentEmojis.length,
                                      itemBuilder: (context, index) {
                                        final emojiMap = recentEmojis[index];
                                        return GestureDetector(
                                          onTap: () {
                                            selectEmoji(emojiMap["emoji"],
                                                setModalState);
                                            Navigator.of(context)
                                                .pop(emojiMap["emoji"]);
                                          },
                                          child: Center(
                                            child: Text(
                                              emojiMap["emoji"]!,
                                              style:
                                                  const TextStyle(fontSize: 30),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    // All page
                                    GridView.builder(
                                      controller: controller,
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 6,
                                        childAspectRatio: 1,
                                      ),
                                      itemCount: filteredEmojis.length,
                                      itemBuilder: (context, index) {
                                        final emojiMap = filteredEmojis[index];
                                        return GestureDetector(
                                          onTap: () {
                                            selectEmoji(emojiMap["emoji"],
                                                setModalState);
                                            Navigator.of(context)
                                                .pop(emojiMap["emoji"]);
                                          },
                                          child: Center(
                                            child: Text(
                                              emojiMap["emoji"]!,
                                              style:
                                                  const TextStyle(fontSize: 30),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              },
            );

            if (result != null) {
              setState(() {
                selectedEmoji = result;
              });
              onCustomize(selectedColor, selectedStyle, selectedEmoji);
            }
          },
          child: selectedEmoji == null
              ? const Icon(Icons.insert_emoticon, size: 24)
              : Text(
                  selectedEmoji!,
                  style: const TextStyle(fontSize: 24),
                ),
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
        const Center(
          child: Text(
            'Select QR Code Color:',
          ),
        ),
        const SizedBox(height: 8),
        buildColorSelector(),
        const SizedBox(height: 16),
        const Center(
          child: Text(
            'Select QR Code Style:',
          ),
        ),
        const SizedBox(height: 8),
        buildStyleSelector(),
        const SizedBox(height: 16),
        const Center(
          child: Text(
            'Select Emoji:',
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: buildEmojiSelector(),
        ),
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
                Navigator.of(context).pop(false);
              },
            ),
            CupertinoDialogAction(
              child: const Text('Done'),
              onPressed: () {
                onSave(
                    selectedColor, selectedStyle, selectedEmoji, recentEmojis);
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
                        Navigator.of(context).pop(false);
                      },
                    ),
                    TextButton(
                      child: const Text('Done'),
                      onPressed: () {
                        onSave(selectedColor, selectedStyle, selectedEmoji,
                            recentEmojis);
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
