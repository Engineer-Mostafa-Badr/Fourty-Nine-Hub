import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/const.dart';

class ImagePickerPlaceholder extends StatelessWidget {
  final String? tilte;
  final double? height;
  final double? width;
  final Widget? image;
  final Color? iconColor;
  final Color? borderColor;

  const ImagePickerPlaceholder(
      {super.key,
      this.tilte,
      this.image,
      this.height,
      this.width,
      this.iconColor,
      this.borderColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: height ?? 150.h,
      height: width ?? 150.h,
      decoration: BoxDecoration(
        border: Border.all(color: borderColor ?? Colors.grey),
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
              color: iconColor ?? AppColors.LIGHT_GRAY_COLOR,
            ),
          ),
          Expanded(child: _buildTitle()),
        ],
      );
    } else {
      return image!;
    }
  }

  Widget _buildTitle() {
    if (tilte == null || tilte!.isEmpty) {
      return SizedBox.shrink();
    }
    return Center(
        child: Text(
      tilte!,
      textAlign: TextAlign.center,
    ));
  }
}
