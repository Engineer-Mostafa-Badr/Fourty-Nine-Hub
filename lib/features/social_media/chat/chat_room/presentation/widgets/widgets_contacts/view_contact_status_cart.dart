import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class ViewContactStatusCart extends StatelessWidget {
  const ViewContactStatusCart({
    super.key,
    required this.bio,
  });
  final String bio;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.9,
                ),
                child: Text(
                  bio == ''
                      ? context.isArabic
                          ? 'مرحبا أنا استخدم تطبيق 49Hub'
                          : 'Hi I am using 49Hub App'
                      : bio,
                  style: Styles.mediumText(
                    fontWeight: FontWeight.w600,
                    color: context.isDarkMode
                        ? AppColors.BACKGROUND_COLOR
                        : AppColors.PRIMARY_COLOR,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
