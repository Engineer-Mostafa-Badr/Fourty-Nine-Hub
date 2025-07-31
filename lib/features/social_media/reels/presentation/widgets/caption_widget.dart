import 'package:flutter/material.dart';

class CaptionWidget extends StatelessWidget {
  final String caption;
  const CaptionWidget({
    super.key,
    required this.caption,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        // context.isArabic ? 'وصف الريل' : 'Caption of the post ',
        caption,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Colors.white,
        ),
      ),
    );
  }
}
