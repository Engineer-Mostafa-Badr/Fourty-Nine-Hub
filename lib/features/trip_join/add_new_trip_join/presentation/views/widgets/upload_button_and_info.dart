import 'package:flutter/material.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UploadButtonAndInfo extends StatelessWidget {
  const UploadButtonAndInfo({
    super.key,
    this.number,
    this.isCarImage = false,
    this.isSuccess = false,
    this.onTap,
  });
  final bool isCarImage;
  final bool isSuccess;
  final int? number;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    Color color = isSuccess ? Colors.green[400]! : AppColors.SECONDARY_COLOR;
    String text =
        isCarImage ? 'Upload Car Image $number' : 'Upload Number plate Image';
    IconData icon = isSuccess ? Icons.check : Icons.close;

    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5.h),
        width: double.infinity,
        height: 45.h,
        padding: const EdgeInsets.symmetric(horizontal: 7),
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          // color: Colors.white,
          border: Border.all(color: AppColors.PRIMARY_COLOR, width: 3),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: AppColors.PRIMARY_COLOR.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 12.0,
            ),
            BoxShadow(
              color: AppColors.PRIMARY_COLOR_LIGHT.withOpacity(0.1),
              spreadRadius: -12.0,
              blurRadius: 12.0,
            ),
          ],
        ),
        child: Row(
          children: [
            Text(text, style: Styles.headerText()),
            const Spacer(),
            Container(
              alignment: Alignment.center,
              width: 80,
              child: Icon(
                icon,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
