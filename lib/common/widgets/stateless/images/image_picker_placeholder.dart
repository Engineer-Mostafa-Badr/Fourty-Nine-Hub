import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/square_image.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerPlaceholder extends StatelessWidget {
  final String? tilte;
  final double? height;
  final double? width;
  final XFile? imageFile;
  final String? imageUrl;
  const ImagePickerPlaceholder(
      {super.key,
      this.tilte,
      this.imageFile,
      this.height,
      this.width,
      this.imageUrl});

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
    if (imageFile != null) {
      return Image.file(File(imageFile!.path));
    } else if (imageUrl == null || imageUrl!.isEmpty) {
      return SquareImage(
        url: imageUrl,
      );
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
