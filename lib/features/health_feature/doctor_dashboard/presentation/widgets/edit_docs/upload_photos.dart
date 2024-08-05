import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/image_uploader_widget.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/res/strings/labels.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class UploadDoctorDocsPhotos extends StatelessWidget {
  const UploadDoctorDocsPhotos({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Label(text: Labels.uploadPhotos, style: Styles.headerText()),
        const Sizer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ImageUploaderWidget(
              subCategoryId: '1',
              tilte: Labels.front,
            ),
            ImageUploaderWidget(
              tilte: Labels.back,
              subCategoryId: '',
            ),
          ],
        ),
      ],
    );
  }
}
