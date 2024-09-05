import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/image_picker_placeholder.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:image_picker/image_picker.dart';

class ImageValidation extends StatefulWidget {
  const ImageValidation(
      {super.key,
      this.onTap,
      this.validator,
      this.title,
      this.hint,
      this.networkImage,
      this.iconColor,
      this.height,
      this.noTextError = false,
      this.textStyle,
      this.width});
  final void Function(File image)? onTap;
  final String? Function(Object? value)? validator;
  final String? title;
  final String? hint;
  final Color? iconColor;
  final double? height;
  final TextStyle? textStyle;
  final double? width;
  final bool noTextError;
  final String? networkImage;
  @override
  State<ImageValidation> createState() => _ImageValidationState();
}

class _ImageValidationState extends State<ImageValidation> {
  XFile? image;
  @override
  Widget build(BuildContext context) {
    return FormField(
      validator: widget.validator,
      builder: (field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.title != null)
              Column(
                children: [
                  Label(
                    text: widget.title ?? "",
                    style: widget.textStyle ?? Styles.headerText(),
                  ),
                  const Sizer(),
                ],
              ),
            GestureDetector(
              onTap: () async {
                var pickedFlie =
                    await ImagePicker().pickImage(source: ImageSource.gallery);
                if (pickedFlie != null) {
                  image = pickedFlie;
                  if (widget.onTap != null) {
                    widget.onTap!(File(pickedFlie.path));
                  }
                }
                setState(() {});
              },
              child: ImagePickerPlaceholder(
                width: widget.width,
                height: widget.height,
                borderColor: field.hasError ? Colors.red : null,
                tilte: widget.hint,
                image: image != null
                    ? Container(
                        width: widget.width ?? 100,
                        height: widget.height ?? 100,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(UIConst.radius),
                            image: DecorationImage(
                              image: FileImage(
                                File(image?.path ?? ""),
                              ),
                              fit: BoxFit.cover,
                            )),
                      )
                    : widget.networkImage != null
                        ? Container(
                            width: widget.width ?? 100,
                            height: widget.height ?? 100,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(UIConst.radius),
                                image: DecorationImage(
                                  image:
                                      NetworkImage(widget.networkImage ?? ""),
                                  fit: BoxFit.cover,
                                )),
                          )
                        : null,
                iconColor: widget.iconColor,
              ),
            ),
            if (!widget.noTextError)
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
