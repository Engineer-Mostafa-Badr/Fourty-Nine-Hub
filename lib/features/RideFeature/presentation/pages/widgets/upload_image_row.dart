import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

class UploadImageRow extends StatelessWidget {
  const UploadImageRow({super.key, required this.title, this.onTap, this.disableUpload=false});
  final String title;
  final GestureTapCallback? onTap;
  final bool? disableUpload;
  @override
  Widget build(BuildContext context) {
    print("disableUpload$disableUpload");
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16),
        ),
        Row(
          children: [
            Text(
              disableUpload==true?context.isArabic?'تعديل':"Update":context.isArabic?'تحميل':"Upload",
              style: TextStyle(color: disableUpload==true?AppColors.GREY_DARK_COLOR:AppColors.SECONDARY_COLOR,fontSize: 36.sp),
            ),
            const SizedBox(width: 5),
            ClickableWidget(
              onTap:
              // disableUpload==true?null:
              onTap,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                decoration: BoxDecoration(
                  border: Border.all(color:context.isDarkMode ? AppColors.GREY_DARK_COLOR :AppColors.PRIMARY_COLOR),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: context.isDarkMode ? AppColors.GREY_DARK_COLOR :Colors.black,
                  ),
                  child: const Icon(
                    Icons.arrow_upward,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
