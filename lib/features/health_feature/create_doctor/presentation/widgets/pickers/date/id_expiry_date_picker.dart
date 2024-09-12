import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateful/picker/date_picker.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CreateDoctorIDExpiryDatePicker extends StatelessWidget {
  const CreateDoctorIDExpiryDatePicker(
      {super.key, this.validator, this.onDateSelected});
  final String? Function(Object? value)? validator;
  final dynamic Function(DateTime? date)? onDateSelected;
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
              borderColor: field.hasError ? Colors.red : null,
              title: "ID Expiry Date",
              initialDate: now,
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
