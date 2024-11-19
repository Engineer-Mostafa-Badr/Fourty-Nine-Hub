import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateful/picker/date_picker.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
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
    return FormField(
      validator: validator,
      builder: (field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DatePickerField(
              isAuthentcation: isAuthentcation,
              borderWidth: borderWidth,
              borderColor: field.hasError ? Colors.red : borderColor,
              title: title ?? LocaleKeys.idExpiryDate.tr(),
              initialDate: now,
              textStyle: textStyle ?? Styles.mediumText(),
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
