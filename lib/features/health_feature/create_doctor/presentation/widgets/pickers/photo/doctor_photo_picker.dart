import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateful/picker/image_picker.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class CreateDoctorPhotoPicker extends StatelessWidget {
  const CreateDoctorPhotoPicker({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Label(
          text: "Photo",
          style: Styles.headerText(),
        ),
        const Sizer(),
        ImagePickerWidget(
          onImagePicked: (value) {},
        ),
      ],
    );
  }
}
