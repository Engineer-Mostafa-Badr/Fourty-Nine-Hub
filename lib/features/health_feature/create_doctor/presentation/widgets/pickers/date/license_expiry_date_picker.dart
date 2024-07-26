import 'package:flutter/widgets.dart';
import 'package:fourtyninehub/common/widgets/stateful/picker/date_picker.dart';

class CreateDoctorLicenseExpiryDatePicker extends StatelessWidget {
  const CreateDoctorLicenseExpiryDatePicker({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    return DatePickerWidget(
      title: "License Expiry Date",
      initialDate: now,
      minDate: now,
      maxDate: DateTime(now.year + 5, now.month, now.day),
      onDateSelected: (date) {},
    );
  }
}
