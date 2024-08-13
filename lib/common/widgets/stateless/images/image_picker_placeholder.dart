
import 'package:flutter/material.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/const.dart';

class ImagePickerPlaceholder extends StatelessWidget {
  final String? tilte;
  final double? height;
  final double? width;
  final Widget? image;
  const ImagePickerPlaceholder({
    super.key,
    this.tilte,
    this.image,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: height ?? 100,
      height: width ?? 100,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(UIConst.radius),
      ),
      child: _buildImage(),
    );
  }

  Widget _buildImage() {
    if (image != null) {
      return image!;
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.camera_alt,
            size: 50,
            color: AppColors.LIGHT_GRAY_COLOR,
          ),
          _buildTitle(),
        ],
      );
    }
  }

  Widget _buildTitle() {
    if (tilte == null || tilte!.isEmpty) {
      return const SizedBox.shrink();
    }
    return Text(tilte!);
  }
}
