import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateful/picker/date_picker.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/cubit/create_doctor_cubit.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/shipping_cubit.dart';
import 'package:fourtyninehub/res/style/styles.dart';

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
