import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/register_rider_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/validation_error_widget.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:image_picker/image_picker.dart';

class FrontCarLicenseRegisterCardWidget extends StatefulWidget {
  const FrontCarLicenseRegisterCardWidget({super.key});

  @override
  State<FrontCarLicenseRegisterCardWidget> createState() =>
      _FrontCarLicenseRegisterCardWidgetState();
}

class _FrontCarLicenseRegisterCardWidgetState
    extends State<FrontCarLicenseRegisterCardWidget> {
  File? image;
  @override
  Widget build(BuildContext context) {
    return FormField(
      validator: (value) {
        if (image == null) {
          return context.isArabic ? "يرجى إضافة صورة" : "Please add an image";
        }
        return null;
      },
      builder: (field) {
        return Column(
          children: [
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  border: field.hasError
                      ? Border.all(color: AppColors.SECONDARY_COLOR_DARK)
                      : null,
                  borderRadius: BorderRadius.circular(10),
                  color: context.isDarkMode
                      ? AppColors.UNSELECTED_DARK_GRAY_COLOR
                      : Colors.white,
                  boxShadow: context.isDarkMode
                      ? []
                      : [
                          BoxShadow(color: Colors.grey.shade400, blurRadius: 30)
                        ]),
              child: Column(
                children: [
                  Text(
                    context.isArabic
                        ? "شهادة تسجيل السيارة"
                        : "Car Registration Certificate",
                    style: Styles.headerText(
                        fontWeight: FontWeight.w500, fontSize: 40),
                  ),
                  const Sizer(),
                  Container(
                    width: double.infinity - 30,
                    height: 200,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: image != null
                                ? FileImage(image!)
                                : AssetImage(Assets.driversLicense)
                                    as ImageProvider,
                            fit: BoxFit.cover),
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  const Sizer(),
                  GestureDetector(
                    onTap: () async {
                      var pickedImage = await ImagePicker()
                          .pickImage(source: ImageSource.gallery);
                      if (pickedImage != null) {
                        image = File(pickedImage.path);
                        context
                            .read<RegisterRiderCubit>()
                            .model
                            .carLicenseFrontImage = image;
                      }
                      setState(() {});
                    },
                    child: Container(
                      width: 130,
                      height: 40,
                      decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(30)),
                      child: Center(
                          child: Text(
                        context.isArabic ? "إضافة صورة" : "Add Image",
                        style: Styles.mediumText(),
                      )),
                    ),
                  ),
                  if (field.hasError)
                    ValidationErrorWidget(
                      message: field.errorText ?? "",
                    )
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
