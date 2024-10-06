import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class MyTextField extends StatelessWidget {
  MyTextField(
      {super.key,
        this.initialValue,
        this.hintStyle,
        this.action,
        this.maxLength,
        this.obsecure,
        this.borderRadius,
        this.prefix,
        this.noBorder = false,
        this.constraints,
        this.fillColor,
        this.hint,
        this.label,
        this.info,
        this.autofill,
        this.suffix,
        this.type,
        this.isEmail,
        this.enabled,
        this.onConfirm,
        this.textAlignVertical,
        this.extraValidationMessage,
        this.extraValidation,
        this.onTap,
        this.height,
        this.maxLines,
        this.style,
        this.validator,
        this.required,
        this.controller,
        this.textStyle});

  bool validate = false;
  final String? initialValue;
  final bool? obsecure;
  final bool? enabled;
  final bool? required;
  final Function(String)? action;
  final Widget? prefix, suffix;
  final String? hint, label, info;
  final TextInputType? type;
  final TextEditingController? controller;
  final Function? onTap;
  final Iterable<String>? autofill;
  final bool? isEmail;
  final Function? onConfirm;
  final bool? extraValidation;
  final String? extraValidationMessage;
  final TextAlignVertical? textAlignVertical;
  final int? maxLines;
  int? maxLength;
  final double? height;
  final TextStyle? style;
  final String? Function(String?)? validator;
  final Color? fillColor;
  final bool noBorder;
  final TextStyle? hintStyle;
  final BorderRadius? borderRadius;
  final BoxConstraints? constraints;
  final TextStyle? textStyle;


  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: Styles.mediumText(color: AppColors.QUANTITY_COLOR),
      textAlignVertical: textAlignVertical,
      maxLines: maxLines ?? null,
      maxLength: maxLength,
      onFieldSubmitted: (v) {
        if (onConfirm != null) {
          onConfirm!();
        }
      },
      validator: validator ??
              (value) {
            validate = true;
            final RegExp emailRegExp = RegExp(r'^[^@]+@[^@]+\.[^@]+$');

            //   setState(() {});
            if ((value == null || value.isEmpty) && (required ?? true)) {
              return LocaleKeys.required.localize;
            } else if (extraValidation ?? false) {
              return extraValidationMessage ?? '';
            } else if (!emailRegExp.hasMatch(value!.trim()) &&
                (isEmail ?? false)) {
              return LocaleKeys.emailFormat.localize;
            } else {
              validate = false;
              // setState(() {});
              return null;
            }
          },
      onTap: () {
        if (onTap != null) {
          onTap!();
        }
      },
      enabled: enabled ?? true,
      controller: controller,
      autofillHints: autofill,
      keyboardType: type,
      initialValue: initialValue,
      obscureText: obsecure ?? false,
      onChanged: action,
      decoration: InputDecoration(
        constraints: constraints,
        hintText: hint,
        filled: true,
        fillColor: fillColor ?? Colors.transparent,
        labelText: label,
        // hintStyle: style ??
        //     TextStyle(fontSize: 30.sp, color: AppColors.QUANTITY_COLOR),
        // labelStyle: style ??
        //     TextStyle(fontSize: 30.sp, color: AppColors.QUANTITY_COLOR),
        prefixIcon: prefix,
        suffixIcon: suffix,
        enabledBorder: noBorder
            ? InputBorder.none
            : OutlineInputBorder(
          borderSide: const BorderSide(
            color: AppColors.LIGHT_GRAY_COLOR,
          ),
          borderRadius: borderRadius ?? BorderRadius.circular(10),
        ),
        focusedBorder: noBorder
            ? InputBorder.none
            : OutlineInputBorder(
          borderSide: const BorderSide(
            color: AppColors.PRIMARY_COLOR,
          ),
          borderRadius: borderRadius ?? BorderRadius.circular(10),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.red,
          ),
          borderRadius: borderRadius ?? BorderRadius.circular(10),
        ),
        focusedErrorBorder: noBorder
            ? InputBorder.none
            : OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.red,
          ),
          borderRadius: borderRadius ?? BorderRadius.circular(10),
        ),
      ),
    );
  }
}
