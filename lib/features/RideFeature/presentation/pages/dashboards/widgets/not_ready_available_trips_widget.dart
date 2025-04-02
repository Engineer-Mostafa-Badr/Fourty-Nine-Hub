import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/utils/media_query_values.dart';

import '../../../../../../res/style/app_colors.dart';

class NotReadyAvailableTripsWidget extends StatelessWidget {
  const NotReadyAvailableTripsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 70.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline,
                color: AppColors.SECONDARY_COLOR_DARK2, size: 80),
            const Text(
              'You are not ready!',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            SizedBox(
              width: context.width / 1.3,
              child: const Text(
                'If you are ready, please go to settings and change your status.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: AppColors.GREYICON),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
