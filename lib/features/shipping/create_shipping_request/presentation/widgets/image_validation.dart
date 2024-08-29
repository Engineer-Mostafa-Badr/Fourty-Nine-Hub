import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/image_picker_placeholder.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:image_picker/image_picker.dart';

class ImageValidation extends StatelessWidget {
  const ImageValidation(
      {super.key,
      this.onTap,
      this.validator,
      this.tilte,
      this.hint,
      this.iconColor});
  final void Function(File image)? onTap;
  final String? Function(Object? value)? validator;
  final String? tilte;
  final String? hint;
  final Color? iconColor;
  @override
  Widget build(BuildContext context) {
    return FormField(
      validator: validator,
      builder: (field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (tilte != null)
              Column(
                children: [
                  Label(
                    text: tilte ?? "",
                    style: Styles.headerText(),
                  ),
                  const Sizer(),
                ],
              ),
            GestureDetector(
              onTap: () async {
                var pickedFlie =
                    await ImagePicker().pickImage(source: ImageSource.gallery);
                if (pickedFlie != null) {
                  if (onTap != null) {
                    onTap!(File(pickedFlie.path));
                  }
                }
              },
              child: ImagePickerPlaceholder(
                borderColor: field.hasError ? Colors.red : null,
                tilte: hint,
                iconColor: iconColor,
              ),
            ),
            if (field.hasError)
              Column(
                children: [
                  const SizedBox(height: 8),
                  Text(
                    field.errorText ?? "",
                    style: Styles.mediumText(color: Colors.red),
                  ),
                ],
              )
          ],
        );
      },
    );
  }
}
