import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerPlaceholder extends StatelessWidget {
  final String? tilte;
  final double? height;
  final double? width;
  final XFile? image;
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
      width: height ?? 100,
      height: width ?? 100,
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
    return Image.file(File(image!.path));
  }

  Widget _buildTitle() {
    if (tilte == null || tilte!.isEmpty) {
      return const SizedBox.shrink();
    }
    return Text(tilte!);
  }
}
