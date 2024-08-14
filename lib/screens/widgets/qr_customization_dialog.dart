import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

void showQrCustomizationDialog({
  required BuildContext context,
  required Color initialColor,
  required String initialStyle,
  required IconData? initialIcon,
  required Function(Color color, String style, IconData? icon) onCustomize,
}) {
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
    'dots',
    'squares',
    'rounded',
    'classic'
  ];

  final List<IconData> availableIcons = [
    Icons.favorite,
    Icons.star,
    Icons.home,
    Icons.music_note,
    Icons.emoji_emotions,
  ];

  Color selectedColor = initialColor;
  String selectedStyle = initialStyle;
  IconData? selectedIcon = initialIcon;

  Widget buildColorSelector() {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: availableColors.length,
        itemBuilder: (context, index) {
          final color = availableColors[index];
          return GestureDetector(
            onTap: () {
              selectedColor = color;
              onCustomize(selectedColor, selectedStyle, selectedIcon);
              Navigator.of(context).pop();
              showQrCustomizationDialog(
                context: context,
                initialColor: selectedColor,
                initialStyle: selectedStyle,
                initialIcon: selectedIcon,
                onCustomize: onCustomize,
              );
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
  }

  Widget buildStyleSelector() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: availableStyles.length,
        itemBuilder: (context, index) {
          final style = availableStyles[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ChoiceChip(
              label: Text(style),
              selected: selectedStyle == style,
              onSelected: (selected) {
                if (selected) {
                  selectedStyle = style;
                  onCustomize(selectedColor, selectedStyle, selectedIcon);
                  Navigator.of(context).pop();
                  showQrCustomizationDialog(
                    context: context,
                    initialColor: selectedColor,
                    initialStyle: selectedStyle,
                    initialIcon: selectedIcon,
                    onCustomize: onCustomize,
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }

  Widget buildIconSelector() {
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: availableIcons.length,
        itemBuilder: (context, index) {
          final icon = availableIcons[index];
          return GestureDetector(
            onTap: () {
              selectedIcon = icon;
              onCustomize(selectedColor, selectedStyle, selectedIcon);
              Navigator.of(context).pop();
              showQrCustomizationDialog(
                context: context,
                initialColor: selectedColor,
                initialStyle: selectedStyle,
                initialIcon: selectedIcon,
                onCustomize: onCustomize,
              );
            },
            child: Container(
              width: 50,
              height: 50,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: selectedIcon == icon
                    ? Colors.grey[300]
                    : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 30),
            ),
          );
        },
      ),
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
          'Select Icon:',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        buildIconSelector(),
      ],
    ),
  );

  if (Theme.of(context).platform == TargetPlatform.iOS) {
    showCupertinoDialog(
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
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: const Text('Done'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  } else {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Customize QR Code',
            style: TextStyle(fontSize: 24),
          ),
          content: SingleChildScrollView(child: content),
          actions: [
            TextButton(
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Done'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
