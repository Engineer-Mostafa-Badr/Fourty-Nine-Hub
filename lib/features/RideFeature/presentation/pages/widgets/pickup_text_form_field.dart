import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';

enum FieldType { text, phone, number }

class PickUpTextFormField extends StatefulWidget {
  const PickUpTextFormField({
    super.key,
    required this.hintText,
    this.maxLines,
    this.onFieldSubmitted,
    this.onChanged,
    this.controller,
    this.fieldType = FieldType.text,
    this.validator,
    this.icon,
    this.isArabic = false,
    this.fillColor,
    this.textColor,
  });

  final String hintText;
  final TextEditingController? controller;
  final int? maxLines;
  final Function(String)? onFieldSubmitted;
  final Function(String)? onChanged;
  final FieldType fieldType;
  final String? Function(String?)? validator;
  final Widget? icon;
  final Color? fillColor;
  final Color? textColor;
  final bool isArabic;

  @override
  State<PickUpTextFormField> createState() => _PickUpTextFormFieldState();
}

class _PickUpTextFormFieldState extends State<PickUpTextFormField> {
  late bool _isArabic;

  @override
  void initState() {
    super.initState();
    _isArabic = widget.isArabic;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final locale = Localizations.localeOf(context);
    final isNowArabic = locale.languageCode == 'ar';

    if (isNowArabic != _isArabic) {
      _isArabic = isNowArabic;
      _updateControllerText();
    }
  }

  void _updateControllerText() {
    if (widget.controller != null &&
        (widget.fieldType == FieldType.phone ||
            widget.fieldType == FieldType.number)) {
      final currentText = widget.controller!.text;
      final updatedText = _isArabic
          ? _convertToArabicDigits(currentText)
          : _convertToEnglishDigits(currentText);

      widget.controller!.value = widget.controller!.value.copyWith(
        text: updatedText,
        selection: TextSelection.collapsed(offset: updatedText.length),
      );
    }
  }

  String _convertToEnglishDigits(String input) {
    const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];

    String output = input;
    for (int i = 0; i < arabic.length; i++) {
      output = output.replaceAll(arabic[i], english[i]);
    }
    return output;
  }

  String _convertToArabicDigits(String input) {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

    String output = input;
    for (int i = 0; i < english.length; i++) {
      output = output.replaceAll(english[i], arabic[i]);
    }
    return output;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      maxLines: widget.maxLines ??
          (widget.fieldType == FieldType.phone ||
                  widget.fieldType == FieldType.number
              ? 1
              : 1),
      keyboardType: widget.fieldType == FieldType.phone ||
              widget.fieldType == FieldType.number
          ? TextInputType.phone
          : TextInputType.multiline,
      validator: widget.validator != null
          ? (value) {
              final englishValue =
                  value != null ? _convertToEnglishDigits(value) : null;
              return widget.validator!(englishValue);
            }
          : null,
      inputFormatters: widget.fieldType == FieldType.phone
          ? [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9٠-٩]')),
              LengthLimitingTextInputFormatter(11),
            ]
          : widget.fieldType == FieldType.number
              ? [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9٠-٩]')),
                ]
              : [],
      enableInteractiveSelection: false,
      contextMenuBuilder: (context, editableTextState) =>
          const SizedBox.shrink(),
      cursorColor: widget.textColor ?? AppColors.PRIMARY_COLOR,
      decoration: InputDecoration(
        prefixIcon: widget.icon,
        hintText: _isArabic &&
                (widget.fieldType == FieldType.phone ||
                    widget.fieldType == FieldType.number)
            ? _convertToArabicDigits(widget.hintText)
            : widget.hintText,
        labelStyle: Styles.mediumText(
            color: widget.textColor ?? AppColors.PRIMARY_COLOR),
        hintStyle: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 16,
          color: widget.textColor ?? AppColors.black,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsetsDirectional.only(start: 16, top: 10),
        filled: true,
        fillColor: widget.fillColor ?? const Color(0xFFF5F5F5),
      ),
      onChanged: (value) {
        if (widget.onChanged != null) {
          if ((widget.fieldType == FieldType.phone ||
                  widget.fieldType == FieldType.number) &&
              _isArabic) {
            final newValue = _convertToArabicDigits(value);
            if (newValue != value && widget.controller != null) {
              widget.controller!.value = widget.controller!.value.copyWith(
                text: newValue,
                selection: TextSelection.collapsed(offset: newValue.length),
              );
            }
            widget.onChanged!(_convertToEnglishDigits(newValue));
          } else {
            widget.onChanged!(value);
          }
        }
      },
      onFieldSubmitted: widget.onFieldSubmitted,
      style: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 16,
        color: widget.textColor ?? AppColors.PRIMARY_COLOR,
      ),
    );
  }
}

/*
class PickUpTextFormField extends StatelessWidget {
  const PickUpTextFormField({
    super.key,
    required this.hintText,
    this.maxLines,
    this.onFieldSubmitted,
    this.onChanged,
    this.controller,
    this.fieldType = FieldType.text,
    this.validator,
  });

  final String hintText;
  final TextEditingController? controller;
  final int? maxLines;
  final Function(String)? onFieldSubmitted;
  final Function(String)? onChanged;
  final FieldType fieldType;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines ?? (fieldType == FieldType.phone ? 1 :  1),
      keyboardType: fieldType == FieldType.phone
          ? TextInputType.phone
          : TextInputType.multiline,
      validator: validator,
      inputFormatters: fieldType == FieldType.phone
          ? [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(11),
      ]
          : [],
      enableInteractiveSelection: false,
      contextMenuBuilder: (context, editableTextState) => const SizedBox.shrink(),
      cursorColor: AppColors.PRIMARY_COLOR,
      decoration: InputDecoration(
        prefixIcon: icon,
        hintText: isArabic && fieldType == FieldType.phone
            ? _convertToArabicDigits(hintText)
            : hintText,
        labelStyle: Styles.mediumText(
            color: AppColors.PRIMARY_COLOR
        ),
        hintStyle: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 16,
          color: AppColors.black,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsetsDirectional.only(start: 16, top: 10),
        filled: true,
        fillColor: const Color(0xFFF5F5F5),
      ),
      onChanged: (value) {
        if (onChanged != null) {
          if (fieldType == FieldType.phone && isArabic) {
            // Convert to Arabic digits in real-time
            final newValue = _convertToArabicDigits(value);
            if (newValue != value && controller != null) {
              controller!.value = controller!.value.copyWith(
                text: newValue,
                selection: TextSelection.collapsed(offset: newValue.length),
              );
            }
            // Call callback with English digits for storage
            onChanged!(_convertToEnglishDigits(newValue));
          } else {
            onChanged!(value);
          }
        }
      },
      onFieldSubmitted: onFieldSubmitted,
      style: const TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 16,
        color: AppColors.PRIMARY_COLOR,
      ),
    );
  }
}
*/

// class PickUpTextFormField extends StatelessWidget {
//   const PickUpTextFormField({
//     super.key,
//     required this.hintText,
//     this.maxLines,
//     this.onFieldSubmitted,
//     this.onChanged,
//     this.controller,
//     this.fieldType = FieldType.text,
//     this.validator,
//     this.icon,
//   });
//
//   final String hintText;
//   final TextEditingController? controller;
//   final int? maxLines;
//   final Function(String)? onFieldSubmitted;
//   final Function(String)? onChanged;
//   final FieldType fieldType;
//   final String? Function(String?)? validator;
//   final Widget? icon;
//
//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       controller: controller,
//       maxLines: fieldType == FieldType.phone ? 1 : maxLines ?? 1,
//       keyboardType: fieldType == FieldType.phone
//           ? TextInputType.phone
//           : TextInputType.multiline,
//       validator: validator,
//       inputFormatters: fieldType == FieldType.phone
//           ? [
//         FilteringTextInputFormatter.digitsOnly,
//         LengthLimitingTextInputFormatter(11),
//       ]
//           : [],
//       enableInteractiveSelection: false,
//       contextMenuBuilder: (context, editableTextState) => const SizedBox.shrink(),
//       cursorColor: AppColors.PRIMARY_COLOR,
//       decoration: InputDecoration(
//         prefixIcon: icon,
//         hintText: hintText,
//         labelStyle: Styles.mediumText(
//           color: AppColors.PRIMARY_COLOR
//         ),
//         hintStyle: TextStyle(
//           fontWeight: FontWeight.w400,
//           fontSize: 16,
//           color: AppColors.black,
//         ),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: BorderSide.none,
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: BorderSide.none,
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: BorderSide.none,
//         ),
//         errorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: BorderSide.none,
//         ),
//         focusedErrorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: BorderSide.none,
//         ),
//         contentPadding: const EdgeInsetsDirectional.only(start: 16, top: 10),
//         filled: true,
//         fillColor: const Color(0xFFF5F5F5),
//       ),
//       onChanged: onChanged,
//       onFieldSubmitted: onFieldSubmitted,
//       style: const TextStyle(
//         fontWeight: FontWeight.w500,
//         fontSize: 16,
//           color: AppColors.PRIMARY_COLOR
//       ),
//     );
//   }
// }
