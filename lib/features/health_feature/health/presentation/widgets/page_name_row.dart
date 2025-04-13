import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class PageNameRow extends StatelessWidget {
  const PageNameRow({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        IconButton(
            visualDensity:
            const VisualDensity(horizontal: -4, vertical: -4),
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.arrow_back,
              color: AppColors.black,
            )),
        Label(
          text: title,
          style: Styles.headerText(fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}
