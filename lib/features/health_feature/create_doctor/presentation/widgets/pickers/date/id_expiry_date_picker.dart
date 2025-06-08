import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/common/widgets/stateful/picker/date_picker.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/widgets/custom_date_text_field_health.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CreateDoctorIDExpiryDatePicker extends StatelessWidget {
  const CreateDoctorIDExpiryDatePicker(
      {super.key,
      this.validator,
      this.onDateSelected,
      this.title,
      this.textStyle,
      this.borderColor,
      this.isAuthentcation = false,
      this.borderWidth});
  final String? Function(Object? value)? validator;
  final dynamic Function(DateTime? date)? onDateSelected;
  final String? title;
  final Color? borderColor;
  final TextStyle? textStyle;
  final bool isAuthentcation;
  final double? borderWidth;
  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    CustomDateTextFieldHealth(
      controller: TextEditingController(),
      hintText: LocaleKeys.idExpiryDate.localize,
      keyboardType: TextInputType.datetime,
      onTap: () {},
    );
    return FormField(
      validator: validator,
      builder: (field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DatePickerField(
              backgroundColor: AppColors.getFindFillColor(context),
              isAuthentcation: isAuthentcation,
              borderWidth: borderWidth,
              borderColor:
                  field.hasError ? Colors.red :  AppColors.getFindFillColor(context),
              icon: SvgPicture.asset(Assets.calendarIcon,color: context.isDarkMode?AppColors.getTextColor(context):null,),
              title: title ?? LocaleKeys.idExpiryDate.localize,
              // (context.isArabic ? 'تاريخ انتهاء الهوية' : 'ID Expiry Date'),
              initialDate: now,
              textStyle: textStyle ??
                  Styles.mediumText(
                    fontSize: 32,
                    height: 1.60,
                  ),
              minDate: now,
              maxDate: DateTime(now.year + 5, now.month, now.day),
              onDateSelected: (date) {
                if (date != null) {
                  if (onDateSelected != null) {
                    onDateSelected!(date);
                  }
                }
              },
            ),
            if (field.hasError)
              Column(
                children: [
                  SizedBox(height: 8.h),
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
