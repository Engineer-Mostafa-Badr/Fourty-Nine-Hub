import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../res/style/app_colors.dart';

class NewRouteTextWidget extends StatelessWidget {
  const NewRouteTextWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: GestureDetector(
        onTap: () {
          context.pop();
        },
        child: Row(
          children: [
            const Icon(Icons.arrow_back),
            SizedBox(width: 10.w),
            Text(
              LocaleKeys.newRoute.localize,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppColors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
