import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/functions/global/upload_file.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/image_picker_placeholder.dart';

class ImageUploaderWidget extends StatefulWidget {
  final String? tilte;
  final double? height;
  final double? width;
  final Widget? image;
  final String subCategoryId;
  final Function(UploadFileEntity)? onUploaded;
  const ImageUploaderWidget({
    super.key,
    this.tilte,
    this.height,
    this.width,
    required this.subCategoryId,
    this.onUploaded,
    this.image,
  });

  @override
  State<ImageUploaderWidget> createState() => _ImageUploaderWidgetState();
}

class _ImageUploaderWidgetState extends State<ImageUploaderWidget> {
  late Widget? _image;
  @override
  void initState() {
    _image = widget.image;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        UploadFile().uploadImage(
          subCategoryId: widget.subCategoryId,
          onUploaded: (value) {
            setState(() {
              _image = Image.file(File(value.file.path));
            });
            widget.onUploaded?.call(value);
          }, context: context,
        );
      },
      child: ImagePickerPlaceholder(
        height: widget.height,
        width: widget.width,
        image: _image,
        title: widget.tilte,
      ),
    );
  }
}
