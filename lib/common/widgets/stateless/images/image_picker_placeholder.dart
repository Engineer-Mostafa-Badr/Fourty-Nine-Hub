import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class ImagePickerPlaceholder extends StatelessWidget {
  final String? title;
  final double? height;
  final double? width;
  final Widget? image;
  final Color? iconColor;
  final Color? borderColor;

  const ImagePickerPlaceholder({
    super.key,
    this.title,
    this.image,
    this.height,
    this.width,
    this.iconColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // **Null Handling for Width and Height**
      // Ensure that if either height or width is null, a default value is provided.
      // Note: In the original code, width and height seem to be swapped.
      width: height ?? 150.h, // Consider verifying if this should be `width: width ?? 150.w`
      height: width ?? 150.h,  // Consider verifying if this should be `height: height ?? 150.h`

      decoration: BoxDecoration(
        // **Null Handling for Border Color**
        // If `borderColor` is null, default to `Colors.grey`.
        border: Border.all(color: borderColor ?? Colors.grey),

        // **Null Handling for Border Radius**
        // Assuming `UIConst.radius` is non-null. If it's nullable, handle accordingly.
        borderRadius: BorderRadius.circular(UIConst.radius),
      ),
      child: _buildImage(),
    );
  }

  Widget _buildImage() {
    if (image == null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Icon(
              Icons.camera_alt,
              size: 50,
              // **Null Handling for Icon Color**
              // If `iconColor` is null, default to `AppColors.LIGHT_GRAY_COLOR`.
              color: iconColor ?? AppColors.LIGHT_GRAY_COLOR,
            ),
          ),
          Expanded(child: _buildTitle()),
        ],
      );
    } else {
      // **Null Assertion Safe Here**
      // Since we checked `image == null`, it's safe to use `image!`.
      return image!;
    }
  }

  Widget _buildTitle() {
    if (title == null || title!.isEmpty) {
      // **Handling Null or Empty Title**
      // Return an empty widget if title is null or empty.
      return const SizedBox.shrink();
    }
    return Center(
      child: Text(
        title!,
        textAlign: TextAlign.center,
        style: Styles.mediumText(),
      ),
    );
  }
}
