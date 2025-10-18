import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:intl/intl.dart';

import '../../../../common/widgets/form/text_fields/default_text_form_field.dart';

class BirthDatePicker extends StatefulWidget {
  final TextEditingController controller;
  final Function(String? date) onDateChanged;
  const BirthDatePicker({super.key, required this.controller,required this.onDateChanged});

  @override
  _BirthDatePickerState createState() => _BirthDatePickerState();
}

class _BirthDatePickerState extends State<BirthDatePicker> {
  DateTime? selectedDate;
  final DateFormat dateFormat =
      DateFormat('dd/MM/yyyy'); // Formatting as 05/04/2001

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DefaultTextFormField(
          readOnly: true,
          borderColor: Colors.black,
          currentController: widget.controller,
          hint: LocaleKeys.birthDate.localize,
          prefixIcon: const Icon(Icons.calendar_today),
          onTap: () => _selectDate(context),
          validator: (s) {
            return null;
          },
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime initialDate = DateTime(2000); // Default year if none is selected
    DateTime firstDate = DateTime(1900); // Minimum selectable date
    DateTime lastDate = DateTime.now(); // Maximum selectable date (today)

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }

    widget.onDateChanged(selectedDate?.toIso8601String());
    widget.controller.text = dateFormat.format(selectedDate!);
    print("widget.controller.text${widget.controller.text}");
  }
}
