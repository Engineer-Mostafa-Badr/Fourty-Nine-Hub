import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

class DatePickerField extends StatefulWidget {
  final String? title;
  final DateTime initialDate;
  final DateTime minDate;
  final TextStyle? textStyle;
  final DateTime maxDate;
  final bool isAuthentcation;
  final double? borderWidth;
  final Color? borderColor;
  final Widget? icon;
  final Function(DateTime?) onDateSelected;
  final Color? backgroundColor;

  const DatePickerField({
    super.key,
    this.title,
    this.borderWidth,
    required this.initialDate,
    this.textStyle,
    this.isAuthentcation = false,
    required this.minDate,
    this.borderColor,
    required this.maxDate,
    required this.onDateSelected,
    this.icon,
    this.backgroundColor,
  });

  @override
  State<DatePickerField> createState() => _DatePickerFieldState();
}

class _DatePickerFieldState extends State<DatePickerField> {
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (widget.isAuthentcation) {
          if (context.isUserLoggedIn) {
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
          }
        } else {
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
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 15.h),
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          border: Border.all(
              width: widget.borderWidth ?? .5,
              color: widget.borderColor ?? Colors.black),
          borderRadius: BorderRadius.circular(UIConst.radius),
        ),
        child: Row(
          children: [
            Expanded(
              child: _selectedDate == null
                  ? Text(
                      widget.title ?? 'No date selected!',
                      style: widget.textStyle ??
                          Styles.mediumText(color: AppColors.DARK_GRAY_COLOR),
                    )
                  : Text(
                      _selectedDate!.toLocal().toString().split(' ')[0],
                      style:
                          Styles.mediumText(color: Colors.black, fontSize: 30),
                    ),
            ),
            const Sizer(),
            widget.icon ?? const Icon(Icons.calendar_month),
          ],
        ),
      ),
    );
  }
}
