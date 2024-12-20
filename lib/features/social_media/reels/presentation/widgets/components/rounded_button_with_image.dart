import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RoundedButtonWithImage extends StatelessWidget {
  final String imagePath;
  final VoidCallback onPressed;

  const RoundedButtonWithImage({
    super.key,
    required this.imagePath,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 50,
      child: FittedBox(
        child: ElevatedButton.icon(
          onPressed: onPressed,
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.resolveWith(
              (states) => Colors.blueGrey.withOpacity(0.2),
            ),
          ),
          icon: const Icon(
            FontAwesomeIcons.music,
            color: Colors.white,
          ),
          label: const Text(
            'Audio',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
