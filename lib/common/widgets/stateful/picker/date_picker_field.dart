import 'package:bottom_picker/bottom_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dialogs/please_login_dialog.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/default_text_form_field.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

class DatePickerTextField extends StatefulWidget {
  final String? title;
  final String? hintText;
  final String? pickerTitle;
  final DateTime initialDate;
  final TextEditingController controller;
  final DateTime? minDate;
  final TextStyle? textStyle;
  final DateTime? maxDate;
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
      this.pickerTitle,
      this.color,
      this.borderWidth,
      this.contentPadding,
      required this.initialDate,
      required this.controller,
      this.textStyle,
      this.isAuthentcation = false, this.minDate,
      this.borderColor,
       this.maxDate,
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
            BottomPicker.date(
              headerBuilder: (context) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.pickerTitle??(context.isArabic?'تحديد تاريخ الميلاد':'Set your Birthday'),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: context.isDarkMode?AppColors.whiteColor:AppColors.PRIMARY_COLOR,
                      ),
                    ),
                  ],
                );
              },
              buttonSingleColor: AppColors.PRIMARY_COLOR,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              buttonContent: Text(
                context.isArabic?'تحديد':'Select',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppColors.whiteColor,
                ),
              ),
              initialDateTime: widget.minDate??DateTime(1996, 10, 22),
              maxDateTime: widget.maxDate??DateTime(2012),
              minDateTime: widget.minDate??DateTime(1980),
              onChange: (index) {
                debugPrint("onChange $index");
              },
              pickerThemeData: CupertinoTextThemeData(
                  primaryColor: AppColors.PRIMARY_COLOR,
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: context.isDarkMode?AppColors.whiteColor:AppColors.PRIMARY_COLOR,
                  ),
                  dateTimePickerTextStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: context.isDarkMode?AppColors.whiteColor:AppColors.PRIMARY_COLOR,
                  )
              ) ,
              onSubmit: (index) {
                debugPrint("onSubmit $index");
                _selectedDate = index;
                widget.onDateSelected(_selectedDate);
              },
              onDismiss: (p0) {
                debugPrint('onDismiss $p0');
              },
              // bottomPickerTheme: BottomPickerTheme.plumPlate,
            ).show(context);
            // final DateTime? picked = await showDatePicker(
            //   context: context,
            //   initialDate: widget.initialDate,
            //   firstDate: widget.minDate,
            //   lastDate: widget.maxDate,
            // );
            // if (picked != null && picked != _selectedDate) {
            //   setState(() {
            //     _selectedDate = picked;
            //   });
            //
            //   widget.onDateSelected(_selectedDate);
            // }
          } else {
            return pleaseLoginDialog(context);
            // context.push(Routes.LOGIN);
          }
        } else {
          BottomPicker.date(
            headerBuilder: (context) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.pickerTitle??(context.isArabic?'تحديد تاريخ الميلاد':'Set your Birthday'),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: context.isDarkMode?AppColors.whiteColor:AppColors.PRIMARY_COLOR,
                    ),
                  ),
                ],
              );
            },
            buttonSingleColor: AppColors.PRIMARY_COLOR,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            buttonContent: Text(
              context.isArabic?'تحديد':'Select',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: AppColors.whiteColor,
              ),
            ),
            initialDateTime: widget.minDate??DateTime(1996, 10, 22),
            maxDateTime: widget.maxDate??DateTime(2012),
            minDateTime: widget.minDate??DateTime(1980),
            onChange: (index) {
              debugPrint("onChange $index");
            },
            pickerThemeData: CupertinoTextThemeData(
                primaryColor: AppColors.PRIMARY_COLOR,
                textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: context.isDarkMode?AppColors.whiteColor:AppColors.PRIMARY_COLOR,
                ),
                dateTimePickerTextStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: context.isDarkMode?AppColors.whiteColor:AppColors.PRIMARY_COLOR,
                )
            ) ,
            onSubmit: (index) {
              debugPrint("onSubmit $index");
              _selectedDate = index;
              widget.onDateSelected(_selectedDate);
            },
            onDismiss: (p0) {
              debugPrint('onDismiss $p0');
            },
            // bottomPickerTheme: BottomPickerTheme.plumPlate,
          ).show(context);
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
