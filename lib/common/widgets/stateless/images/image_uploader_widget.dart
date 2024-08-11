import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/functions/global/upload_file.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/image_picker_placeholder.dart';
import 'package:image_picker/image_picker.dart';

// ignore: must_be_immutable
class ImageUploaderWidget extends StatefulWidget {
  final String? tilte;
  final double? height;
  final double? width;
  XFile? imageFile;
  final String? imageUrl;
  final String subCategoryId;
  final Function(UploadFileEntity)? onUploaded;
  ImageUploaderWidget({
    super.key,
    this.tilte,
    this.height,
    this.width,
    this.imageFile,
    required this.subCategoryId,
    this.onUploaded,
    this.imageUrl,
  });

  @override
  State<ImageUploaderWidget> createState() => _ImageUploaderWidgetState();
}

class _ImageUploaderWidgetState extends State<ImageUploaderWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        UploadFile().uploadImage(
          subCategoryId: widget.subCategoryId,
          onUploaded: (value) {
            setState(() {
              widget.imageFile = value.file;
            });
            widget.onUploaded?.call(value);
          },
        );
      },
      child: ImagePickerPlaceholder(
        height: widget.height,
        width: widget.width,
        imageFile: widget.imageFile,
        tilte: widget.tilte,
        imageUrl: widget.imageUrl,
      ),
    );
  }
}
