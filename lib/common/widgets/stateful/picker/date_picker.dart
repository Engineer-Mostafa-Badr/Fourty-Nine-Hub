import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class DatePickerField extends StatefulWidget {
  final String? title;
  final DateTime initialDate;
  final DateTime minDate;
  final DateTime maxDate;
  final Color? borderColor;
  final Function(DateTime?) onDateSelected;
  const DatePickerField(
      {super.key,
      this.title,
      required this.initialDate,
      required this.minDate,
      this.borderColor,
      required this.maxDate,
      required this.onDateSelected});

  @override
  State<DatePickerField> createState() => _DatePickerFieldState();
}

class _DatePickerFieldState extends State<DatePickerField> {
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
        padding:  EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
        decoration: BoxDecoration(
          border:
              Border.all(width: .5, color: widget.borderColor ?? Colors.black),
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
            Sizer(),
            const Icon(Icons.calendar_month),
          ],
        ),
      ),
    );
  }
}
