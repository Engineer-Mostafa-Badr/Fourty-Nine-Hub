import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../common/widgets/form/text_fields/first_name_text_form_field.dart';
import '../../../../../../common/widgets/form/text_fields/phone_number_text_field.dart';
import '../../../../../../res/style/app_colors.dart';
import '../../../../../../res/style/styles.dart';

class CustomBookingInfoEditableRow extends StatelessWidget {

  final IconData icon;
  final String label;
  final String value;
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
    required this.value,
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
                ? FirstNameTextFormField(
              currentController: controller,
              fillColor: AppColors.BG_GRAY_COLOR,
            )
                : isEditablePhone
                ? CustomPhoneTextFormField(
              fillColor: AppColors.BG_GRAY_COLOR,
              currentFocusNode: currentFocusNode!,
              nextFocusNode: nextFocusNode!,
              currentController: controller,
              onInputChanged: (String value) {},
            )
                : Text(
              value,
              style: Styles.mediumText(color: AppColors.black),
            ),
          ),
        ],
      ),
    );
  }
}
