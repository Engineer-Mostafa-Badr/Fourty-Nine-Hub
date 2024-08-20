import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/functions/global/upload_file.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/image_picker_placeholder.dart';
import 'package:image_picker/image_picker.dart';

class ImageUploaderWidget extends StatefulWidget {
  final String? tilte;
  final double? height;
  final double? width;
  final XFile? image;
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
  late XFile? _image;
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
              _image = XFile(value.file.path);
            });
            widget.onUploaded?.call(value);
          },
        );
      },
      child: ImagePickerPlaceholder(
        height: widget.height,
        width: widget.width,
        image: _image,
        tilte: widget.tilte,
      ),
    );
  }
}
