import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';

import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../res/style/app_colors.dart';

class ImageTextRow extends StatelessWidget {
  final String imagePath;
  final String text;
  final double imageSize;

  const ImageTextRow({
    Key? key,
    required this.imagePath,
    required this.text,
    this.imageSize = 32.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          imagePath,
          height: imageSize,
          width: imageSize,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Label(
            maxLines: 5,
            text: text,
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: context.isDarkMode ? AppColors.whiteColor : AppColors.black.withOpacity(0.7)),
          ),
        ),
      ],
    );
  }
}