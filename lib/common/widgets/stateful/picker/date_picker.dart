import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class DatePickerWidget extends StatefulWidget {
  final String? title;
  final DateTime initialDate;
  final DateTime minDate;
  final DateTime maxDate;
  final Function(DateTime?) onDateSelected;
  const DatePickerWidget(
      {super.key,
      this.title,
      required this.initialDate,
      required this.minDate,
      required this.maxDate,
      required this.onDateSelected});

  @override
  State<DatePickerWidget> createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget> {
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: widget.initialDate,
          firstDate: widget.minDate,
          lastDate: widget.maxDate,
        );
        if (picked != null && picked != _selectedDate) {
          setState(() {
            _selectedDate = picked;
          });

          widget.onDateSelected(_selectedDate);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        decoration: BoxDecoration(
          border: Border.all(width: .5),
          borderRadius: BorderRadius.circular(UIConst.radius),
        ),
        child: Row(
          children: [
            Expanded(
              child: _selectedDate == null
                  ? Text(
                      widget.title ?? 'No date selected!',
                      style:
                          Styles.mediumText(color: AppColors.DARK_GRAY_COLOR),
                    )
                  : Text(
                      _selectedDate!.toLocal().toString().split(' ')[0],
                      style:
                          Styles.mediumText(color: AppColors.DARK_GRAY_COLOR),
                    ),
            ),
            const Sizer(),
            const Icon(Icons.calendar_month),
          ],
        ),
      ),
    );
  }
}
