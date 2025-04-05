import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

class TextInputWidget extends StatelessWidget {
  const TextInputWidget(
      {super.key,
      required this.controller,
      this.label,
      required this.validator,
      this.hint,
      this.isDialogField = false,
      this.textInputType,
      this.maxLines,
      this.readOnly = false,
      this.isPassword = false,
      this.prefixIcon,
      this.suffixSvg,
      this.isRateField,
      this.borderRadius,
      this.borderColor,
      this.onFieldTapped,
      this.isReasonOpen,
      this.floatingLabelBehavior,
      this.hintFontSize,
      this.hintFontFamily,
      this.labelFontSize,
      this.labelFontFamily,
      this.enabled,
      this.hintColor,
      this.contentPadding,
      this.prefixOnTap,
      this.onChanged,
      this.prefixWidget,
      this.validMode = AutovalidateMode.onUserInteraction,
      this.suffixWidget,
      this.onSubmitted,
      this.focusNode,
      this.maxLength,
      this.formatters,
      this.counter,
      this.onTapOutside});
  final TextEditingController controller;
  final List<TextInputFormatter>? formatters;
  final Widget? Function(BuildContext,
      {required int currentLength,
      required bool isFocused,
      required int? maxLength})? counter;
  final String? Function(String?)? validator;
  final AutovalidateMode validMode;
  final TextInputType? textInputType;
  final bool readOnly, isPassword, isDialogField;
  final bool? isRateField, isReasonOpen, enabled;
  final String? prefixIcon,
      suffixSvg,
      hint,
      hintFontFamily,
      labelFontFamily,
      label;
  final Widget? prefixWidget, suffixWidget;
  final double? borderRadius, hintFontSize, labelFontSize;
  final Color? borderColor, hintColor;

  final int? maxLines, maxLength;
  final void Function()? onFieldTapped;
  final void Function()? prefixOnTap;
  final void Function(String)? onChanged, onSubmitted;
  final FloatingLabelBehavior? floatingLabelBehavior;
  final EdgeInsetsGeometry? contentPadding;
  final FocusNode? focusNode;
  final void Function(PointerDownEvent)? onTapOutside;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      cursorColor: AppColors.SECONDARY_COLOR,
      style: Theme.of(context).textTheme.headlineMedium,
      keyboardType: textInputType ?? TextInputType.text,
      // textDirection: getLanguagePrefs() == 'ar' ? TextDirection.rtl : TextDirection.ltr,
      maxLines: maxLines,
      maxLength: maxLength,
      enabled: enabled,
      readOnly: readOnly,
      onTap: onFieldTapped,
      focusNode: focusNode,
      inputFormatters: formatters,
      buildCounter: counter,
      obscureText: isPassword,
      onTapOutside: (event) {
        if (onTapOutside != null) {
          onTapOutside!(event);
        } else {
          FocusScope.of(context).unfocus();
        }
      },
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      autovalidateMode: validMode,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.transparent,
        prefixIcon: prefixIcon == null && prefixWidget == null
            ? null
            : InkWell(
                onTap: prefixOnTap,
                child: prefixWidget ??
                    Container(
                      height: 22.h,
                      width: 22.w,
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(
                        left: !context.isArabic? 16.w : 15.w,
                        right:
                        !context.isArabic? 15.w : 16.w,
                      ),
                      child: SvgPicture.asset(
                        prefixIcon!,
                        height: 19.h,
                        width: 19.w,
                        fit: BoxFit.contain,
                        colorFilter: const ColorFilter.mode(
                          AppColors.GREY_DARK_COLOR,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
              ),
        suffixIcon: suffixSvg == null && suffixWidget == null
            ? null
            : suffixWidget ??
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: SvgPicture.asset(
                    suffixSvg!,
                    width: 12.w,
                    colorFilter: const ColorFilter.mode(
                      Colors.black,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
        hintText: hint,
        hintStyle: Theme.of(context).textTheme.displaySmall!.copyWith(
              fontSize: hintFontSize,
              fontFamily: hintFontFamily,
              fontWeight: FontWeight.w600,
              color: hintColor ??
                  Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .color!
                      .withOpacity(.44),
            ),
        floatingLabelBehavior: floatingLabelBehavior,
        labelText: label,
        labelStyle: Theme.of(context).textTheme.displaySmall!.copyWith(
              fontSize: 13.sp,
              fontFamily: labelFontFamily,
              fontWeight: FontWeight.w600,
              color: hintColor ??
                  Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .color!
                      .withOpacity(.33),
            ),
        alignLabelWithHint: true,
        isDense: true,
        isCollapsed: isDialogField,
        contentPadding: contentPadding,
        // isDialogField
        //     ? EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w)
        //     : EdgeInsets.zero,
        focusedBorder: _outlineInputBorder(
            borderRadius: borderRadius, borderColor: borderColor),
        enabledBorder: _outlineInputBorderStyle(
            borderRadius: borderRadius, borderColor: borderColor),
        disabledBorder: _outlineInputBorderStyle(
            borderRadius: borderRadius, borderColor: borderColor),
        errorBorder: _outlineInputBorderErrorStyle(
            borderRadius: borderRadius, borderColor: borderColor),
        focusedErrorBorder: _outlineInputBorderErrorStyle(
            borderRadius: borderRadius, borderColor: borderColor),
      ),
      // style: TextStyle(height: 0.5.h),
      validator: validator,
    );
  }
}

OutlineInputBorder _outlineInputBorder(
    {double? borderRadius, Color? borderColor}) {
  return OutlineInputBorder(
    borderSide: BorderSide(
      color: borderColor ?? AppColors.SECONDARY_COLOR,
      width: 1.w,
    ),
    borderRadius: BorderRadius.all(
      Radius.circular(borderRadius ?? 6.r),
    ),
  );
}

OutlineInputBorder _outlineInputBorderStyle(
    {double? borderRadius, Color? borderColor}) {
  return OutlineInputBorder(
    borderSide: BorderSide(
      color: borderColor ?? AppColors.GREY_DARK_COLOR.withOpacity(.33),
      width: 1.w,
    ),
    borderRadius: BorderRadius.all(
      Radius.circular(borderRadius ?? 6.r),
    ),
  );
}

OutlineInputBorder _outlineInputBorderErrorStyle(
    {double? borderRadius, Color? borderColor}) {
  return OutlineInputBorder(
    borderSide: BorderSide(
      color: borderColor ?? AppColors.SECONDARY_COLOR,
      width: 1.w,
    ),
    borderRadius: BorderRadius.all(
      Radius.circular(borderRadius ?? 6.r),
    ),
  );
}
