import 'package:flutter/material.dart';
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
      width: width ?? 100,
      height: height ?? 100,
      decoration: BoxDecoration(
        border: Border.all(color: borderColor ?? Colors.black),
        borderRadius: BorderRadius.circular(UIConst.radius),
        // image: image != null
        //     ? DecorationImage(
        //         image: FileImage(File(image!.path)), fit: BoxFit.cover)
        //     : null
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
    } else {
      return image!;
    }
  }

  Widget _buildTitle() {
    if (tilte == null || tilte!.isEmpty) {
      return const SizedBox.shrink();
    }
    return Text(tilte!);
  }
}
