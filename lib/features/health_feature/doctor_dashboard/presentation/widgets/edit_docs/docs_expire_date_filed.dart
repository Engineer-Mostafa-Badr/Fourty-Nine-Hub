import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateful/picker/date_picker.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/res/strings/labels.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class DoctorDocsExpireDateField extends StatelessWidget {
  const DoctorDocsExpireDateField({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Label(text: Labels.expireDate, style: Styles.headerText()),
        const Sizer(),
        DatePickerField(
          title: Labels.expireDate,
          initialDate: now,
          minDate: now,
          maxDate: DateTime(now.year + 5, now.month, now.day),
          onDateSelected: (date) {},
        ),
      ],
    );
  }
}
