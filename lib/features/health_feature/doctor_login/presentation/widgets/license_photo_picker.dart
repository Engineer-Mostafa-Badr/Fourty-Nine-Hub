import 'package:flutter/widgets.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateful/picker/image_picker.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class DoctorLoginLicensePhotoPicker extends StatelessWidget {
  const DoctorLoginLicensePhotoPicker({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Label(
          text: "License",
          style: Styles.headerText(),
        ),
        const Sizer(),
        Row(
          children: [
            ImagePickerWidget(onImagePicked: (value) {}, tilte: "Front"),
            const Sizer(),
            ImagePickerWidget(onImagePicked: (value) {}, tilte: "Back"),
          ],
        ),
      ],
    );
  }
}
