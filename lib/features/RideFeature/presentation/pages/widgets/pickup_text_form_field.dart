import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';

enum FieldType { text, phone }

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

        hintText: hintText,
        labelStyle: Styles.mediumText(
          color: AppColors.PRIMARY_COLOR
        ),
        hintStyle: TextStyle(
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
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      style: const TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 16,
          color: AppColors.PRIMARY_COLOR
      ),
    );
  }
}
