import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/default_text_form_field.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import '../../../../../../res/style/app_colors.dart';
import '../../../../../../res/style/styles.dart';

class CustomBookingInfoEditableRow extends StatelessWidget {

  final IconData icon;
  final String label;
  // final String value;
  final bool isEditablePhone;
  final bool isEditableName;
  final FocusNode? currentFocusNode;
  final FocusNode? nextFocusNode;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final BuildContext context;
  // Constructor
  const CustomBookingInfoEditableRow({super.key,
  required this.context,
    required this.icon,
    required this.label,
    // required this.value,
    required this.isEditablePhone,
    required this.isEditableName,
   this.currentFocusNode,
     this.nextFocusNode,
    required this.controller,
  r, this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return  Container(
      width: 686.w,
      height: 88.h,
      decoration: BoxDecoration(
        color: AppColors.BG_GRAY_COLOR,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Icon(icon, color: AppColors.PRIMARY_COLOR, size: 48.sp),
          ),
          Expanded(
            child: isEditableName

          ? DefaultTextFormField(currentController: controller, hint: LocaleKeys.fullName.localize,
            fillColor: AppColors.BG_GRAY_COLOR,  borderColor: Colors.transparent)
                : isEditablePhone?

            DefaultTextFormField(currentController: controller, hint: LocaleKeys.name.localize,
    fillColor: AppColors.BG_GRAY_COLOR,keyboardType: TextInputType.phone,
            borderColor: Colors.transparent,)
                : Text(
              controller.text,
              style: Styles.mediumText(color: AppColors.black),
            ),
          ),
        ],
      ),
    );
  }
}
