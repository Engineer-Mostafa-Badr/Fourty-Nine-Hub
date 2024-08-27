import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateful/picker/date_picker.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class CreateDoctorIDExpiryDatePicker extends StatelessWidget {
  const CreateDoctorIDExpiryDatePicker(
      {super.key,
      this.validator,
      this.onDateSelected,
      this.title,
      this.textStyle,
      this.borderColor,
      this.borderWidth});
  final String? Function(Object? value)? validator;
  final dynamic Function(DateTime? date)? onDateSelected;
  final String? title;
  final Color? borderColor;
  final TextStyle? textStyle;
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
              borderWidth: borderWidth,
              borderColor: field.hasError ? Colors.red : borderColor,
              title: title ?? "ID Expiry Date",
              initialDate: now,
              textStyle: textStyle,
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
                  const SizedBox(height: 8),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      field.errorText ?? "",
                      style: Styles.mediumText(color: Colors.red),
                    ),
                  ),
                ],
              )
          ],
        );
      },
    );
  }
}
