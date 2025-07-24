import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/routes/pages.dart';

import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../res/style/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../res/style/app_colors.dart';

class CarContainer extends StatelessWidget {
  final String? image;
  final String? title;

  const CarContainer({
    super.key,
    required this.image,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final currentContext = AppPages.router.configuration.navigatorKey.currentContext!;
    return Container(
      decoration: BoxDecoration(
        color: currentContext.isDarkMode?AppColors.GREY_DARK_COLOR:AppColors.cE8E8E8,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.symmetric(horizontal: 4),
      width: 80,
      height: 80,
      child: Column(
        spacing: 4,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 4,
          ),
          if(image != null)
            Image.network(
              image!,
              height: 25,
              width: 50,
            ),
          if(title != null)
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Label(
                text: title!,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: currentContext.isDarkMode?AppColors.whiteColor:AppColors.black,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
/*
class CarContainer extends StatelessWidget {
  final String? image;
  final String? title;

  const CarContainer({
    super.key,
    required this.image,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cE8E8E8,
        borderRadius: BorderRadius.circular(10),
      ),
      // width: 50,
      // height: 50,
      child: Column(
        spacing: 4,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 4,
          ),
          if(image != null)
          Image.network(
            image!,
            height: 15,
            width: 30,
          ),
          if(title != null)
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Label(
              text: title!,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
                color: AppColors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
*/