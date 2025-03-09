import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

class CustomDropDown extends StatelessWidget {
  const CustomDropDown({
    super.key,
    required this.list,
    this.hasTranslation=false,
    this.onTap,
    required this.hint,
    required this.onSelect, this.value, this.height, this.verticalPadding, this.validator,
  });

  final List<dynamic> list;
  final String hint;
  final dynamic value;
  final double? height;
  final double? verticalPadding;
  final bool? hasTranslation;
  final FormFieldValidator<dynamic>? validator;
  final VoidCallback? onTap;

  final Function(dynamic) onSelect;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: height??42.h, // Adjusted height
        child: DropdownButtonFormField<dynamic>(
          hint: Text(
            hint,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          padding: EdgeInsets.zero,
          isDense: true,
          icon:Icon(Icons.arrow_forward_ios,size: 14.w,),
          borderRadius: BorderRadius.circular(6.r),
          dropdownColor: AppColors.whiteColor,
          onTap: onTap,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
            ),
            contentPadding: EdgeInsets.symmetric(vertical:verticalPadding?? 8.h, horizontal: 10.w),
            border: const OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.GREY_DARK_COLOR)),
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.GREY_DARK_COLOR)),
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.GREY_DARK_COLOR)),
            disabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.GREY_DARK_COLOR)),
            focusedErrorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.GREY_DARK_COLOR)),
            errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.GREY_DARK_COLOR)),
          ),
          value: value,
          items: list.map((item) {
            return DropdownMenuItem<dynamic>(
              value: item,
              child: Text(
                hasTranslation==true?context.isArabic?item.nameAr:item.nameEn:item,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }).toList(),
          onChanged: (value) {
            onSelect(value);
          },
          validator:validator?? (value) {
            if (value == null) {
              return 'Please select an item';
            }
            return null;
          },
        ),
      ),
    );
  }
}
