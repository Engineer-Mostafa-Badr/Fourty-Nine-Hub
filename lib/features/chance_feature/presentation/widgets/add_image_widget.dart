import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';

import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';


class AddImageWidget extends StatelessWidget {
  const AddImageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){},
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          boxShadow: AppColors.SHADOW_LIGHT,
          color: Theme.of(context).scaffoldBackgroundColor
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/image.png",
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              height: 40.h,
              decoration: BoxDecoration(
                color: AppColors.SECONDARY_COLOR,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(LocaleKeys.addImages.localize, textAlign: TextAlign.center,
                  style: Styles.smallText(
                      color: Colors.white,
                    fontSize: 50.sp
                  ) ,),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
