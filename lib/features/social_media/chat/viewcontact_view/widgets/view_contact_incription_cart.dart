
import 'package:flutter/material.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class ViewContactEncriptionCart extends StatelessWidget {
  const ViewContactEncriptionCart({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.lock,
            color: AppColors.GREY_DARK_COLOR,
            size: 24,
          ),
          const SizedBox(
            width: 32.0,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Encryption',
                style: Styles.mediumText(
                  fontWeight: FontWeight.w600,
                  color: AppColors.PRIMARY_COLOR,
                ),
              ),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.75,
                ),
                child: Text(
                  'Messages and calls are end-to-end encrypted. Tap to verify.',
                  style: Styles.mediumText(
                    fontWeight: FontWeight.w400,
                    color: AppColors.DARK_GRAY_COLOR,
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
