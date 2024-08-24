import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerPlaceholder extends StatelessWidget {
  final String? title;
  final double? height;
  final double? width;
  final XFile? image;
  final Color? iconColor;
  final Color? borderColor;

  final BoxFit? fit;
  const ImagePickerPlaceholder(
      {super.key,
      this.title,
      this.image,
      this.height,
      this.width,
      this.iconColor,
      this.borderColor,
      this.fit});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: height ?? 100,
      height: width ?? 100,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: borderColor ?? Colors.black),
        borderRadius: BorderRadius.circular(UIConst.radius),
      ),
      child: _buildImage(),
    );
  }

  Widget _buildImage() {
    if (image == null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.camera_alt,
            size: 50,
            color: iconColor ?? AppColors.LIGHT_GRAY_COLOR,
          ),
          _buildTitle(),
        ],
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(UIConst.radius - 2),
      child: Image.file(
        File(image!.path),
        width: height ?? 100,
        height: width ?? 100,
        fit: fit,
      ),
    );
  }

  Widget _buildTitle() {
    if (title == null || title!.isEmpty) {
      return const SizedBox.shrink();
    }
    return Text(
      title!,
      textAlign: TextAlign.center,
    );
  }
}
