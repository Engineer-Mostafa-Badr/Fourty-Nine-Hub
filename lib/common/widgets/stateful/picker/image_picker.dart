import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/functions/helper/file_picker_helper.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends StatefulWidget {
  final String? tilte;
  final Function(XFile?) onImagePicked;
  final double height;
  final double width;
  const ImagePickerWidget(
      {super.key,
      this.tilte,
      required this.onImagePicked,
      this.height = 100,
      this.width = 100});

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  XFile? image;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        FilePickerHelper().pickImage().then((value) {
          setState(() {
            image = value;
          });

          widget.onImagePicked(image);
        });
      },
      child: Container(
        width: widget.height,
        height: widget.width,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(UIConst.radius),
        ),
        child: _buildImage(),
      ),
    );
  }

  Widget _buildImage() {
    if (image == null) {
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
    return Image.file(File(image!.path));
  }

  Widget _buildTitle() {
    if (widget.tilte == null || widget.tilte!.isEmpty) {
      return const SizedBox.shrink();
    }
    return Text(widget.tilte!);
  }
}
