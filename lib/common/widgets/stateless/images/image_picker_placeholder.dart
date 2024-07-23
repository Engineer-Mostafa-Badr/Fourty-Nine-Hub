import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerPlaceholder extends StatefulWidget {
  final String? tilte;
  final double height;
  final double width;
  final XFile? image;
  const ImagePickerPlaceholder(
      {super.key,
      this.tilte,
      this.image,
      this.height = 100,
      this.width = 100});

  @override
  State<ImagePickerPlaceholder> createState() => _ImagePickerPlaceholderState();
}

class _ImagePickerPlaceholderState extends State<ImagePickerPlaceholder> {
  

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.height,
      height: widget.width,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(UIConst.radius),
      ),
      child: _buildImage(),
    );
  }

  Widget _buildImage() {
    if (widget.image == null) {
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
    return Image.file(File(widget.image!.path));
  }

  Widget _buildTitle() {
    if (widget.tilte == null || widget.tilte!.isEmpty) {
      return const SizedBox.shrink();
    }
    return Text(widget.tilte!);
  }
}
