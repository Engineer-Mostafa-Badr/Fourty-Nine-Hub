import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/default_text_form_field.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/common/widgets/dialogs/please_login_dialog.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

class DatePickerTextField extends StatefulWidget {
  final String? title;
  final String? hintText;
  final DateTime initialDate;
  final TextEditingController controller;
  final DateTime minDate;
  final TextStyle? textStyle;
  final DateTime maxDate;
  final bool isAuthentcation;
  final double? borderWidth;
  final Color? borderColor;
  final EdgeInsetsGeometry? contentPadding;
  final Color? color;
  final Widget? icon;
  final Function(DateTime?) onDateSelected;

  const DatePickerTextField(
      {super.key,
      this.title,
      this.hintText,
      this.color,
      this.borderWidth,
      this.contentPadding,
      required this.initialDate,
      required this.controller,
      this.textStyle,
      this.isAuthentcation = false,
      required this.minDate,
      this.borderColor,
      required this.maxDate,
      required this.onDateSelected,
      this.icon});

  @override
  State<DatePickerTextField> createState() => _DatePickerTextFieldState();
}

class _DatePickerTextFieldState extends State<DatePickerTextField> {
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return DefaultTextFormField(
      currentController: widget.controller,
      fillColor: widget.color ?? AppColors.GREYBG,
      borderColor: Colors.transparent,
      readOnly: true,
      onTap: () async {
        ManageVibration.vibrate();
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
          } else {
            return pleaseLoginDialog(context);
            // context.pushNamed(Routes.LOGIN);
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
      hint: widget.hintText ?? '',
      keyboardType: TextInputType.number,
      validator: (v) {
        if (v == null || v.isEmpty) {
          return LocaleKeys.required.localize;
        }
        return null;
      },
    );
  }
}
