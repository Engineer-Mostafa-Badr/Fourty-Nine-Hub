import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/widget/common/profile_picture_widget.dart';

import '../../../../../res/style/app_colors.dart';

class PersonTripWidget extends StatelessWidget {
  final String? image;
  final String? name;
  final String? rate;
  final bool isVerified;

  const PersonTripWidget({
    super.key,
    required this.image,
    required this.name,
    required this.rate,
    required this.isVerified,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              if (image != null && image != '')
                ProfilePictureWidget(
                    image: image,
                    hasStories: false,
                    rating: int.tryParse(rate ?? '0'),
                    isVerified: isVerified),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          if (name != 'null' && name != null)
            SizedBox(
              width: 70,
              child: Text(
                _capitalize(name ?? ''),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: context.isDarkMode
                      ? AppColors.whiteColor
                      : AppColors.black,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }

  String _capitalize(String? s) {
    if (s == null || s.isEmpty) return '';
    return s[0].toUpperCase() + s.substring(1).toLowerCase();
  }
}
