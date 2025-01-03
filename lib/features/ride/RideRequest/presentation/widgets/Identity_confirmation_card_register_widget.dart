import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/register_rider_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/validation_error_widget.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:image_picker/image_picker.dart';

class IdentityConfirmationCardRegisterWidget extends StatefulWidget {
  const IdentityConfirmationCardRegisterWidget({super.key, this.onChange});
  final Function(File image)? onChange;
  @override
  State<IdentityConfirmationCardRegisterWidget> createState() =>
      _IdentityConfirmationCardRegisterWidgetState();
}

class _IdentityConfirmationCardRegisterWidgetState
    extends State<IdentityConfirmationCardRegisterWidget> {
  File? image;
  @override
  Widget build(BuildContext context) {
    return FormField(
      validator: (value) {
        if (image == null) {
          return context.isArabic?"يرجى إضافة صورة":"Please add an image";
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
        border: field.hasError?Border.all(color: AppColors.SECONDARY_COLOR_DARK):null,
          borderRadius: BorderRadius.circular(10),
          color: context.isDarkMode?AppColors.UNSELECTED_DARK_GRAY_COLOR: Colors.white,
          boxShadow: context.isDarkMode?[]: [BoxShadow(color: Colors.grey.shade400, blurRadius: 30)]
          ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Align(
            child: Text(
              context.isArabic?"تاكيد الهوية":"Identity Verification",
              style:
                  Styles.headerText(fontWeight: FontWeight.w500, fontSize: 40),
            ),
          ),
          const Sizer(),
          Container(
            height: 300,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.red, borderRadius: BorderRadius.circular(10),
                image: image == null? null: DecorationImage(image: FileImage(image!), fit: BoxFit.cover,)
                ),
          ),
          const Sizer(),
          Text(
            context.isArabic?"أظهر رخصة السائق أمامك والتقط صورة \n:كمثال":"Show your driver's license in front of you and take a photo\n:For example",
            style: Styles.headerText(fontWeight: FontWeight.w500),
            textAlign: TextAlign.end,
          ),
          const Sizer(),
          Text(
            context.isArabic?"يجب أن ثظهر الصورة بوضوح الوجه ورخصة\nالسائق":"The photo must clearly show the face and driver's license.",
            style: Styles.headerText(fontWeight: FontWeight.w500),
            textAlign: TextAlign.end,
          ),
          const Sizer(),
          Text(
            context.isArabic?"يجب التقاط الصورة في إضاءة جيدة وجودة\nجيدة":"The photo must be taken in good lighting and good quality.",
            style: Styles.headerText(fontWeight: FontWeight.w500),
            textAlign: TextAlign.end,
          ),
          const Sizer(),
          Text(
            context.isArabic?"غير مسموح بالتقاط صور باستخدام نظارة\nشمسية":"No photos with sunglasses allowed",
            style: Styles.headerText(fontWeight: FontWeight.w500),
            textAlign: TextAlign.end,
          ),
          const Sizer(),
          Align(
            child: GestureDetector(
              onTap: () async {
                var pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
                if (pickedImage != null) {
                  image = File(pickedImage.path);
                  context.read<RegisterRiderCubit>().model.verfiyUserImage = image;
                  setState(() {
                    
                  });
                  if (widget.onChange != null) {
                    widget.onChange!(image!);
                  }
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
                  context.isArabic?"إضافة صورة":"Add Image",
                  style: Styles.mediumText(),
                )),
              ),
            ),
          ),
          if(field.hasError)
          Align(child: ValidationErrorWidget(message: field.errorText??"",))
        ],
      ),
    ),
          ],
        );
      },
    );
  }
}
