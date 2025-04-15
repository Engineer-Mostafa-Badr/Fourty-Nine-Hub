import 'package:flutter/material.dart';

import '../../../../../res/style/app_colors.dart';

class PickUpTextFormField extends StatelessWidget {
  const PickUpTextFormField(
      {super.key,
      required this.hintText,
      this.maxLines,
      this.onFieldSubmitted,
      this.onChanged,
      this.controller});

  final String hintText;
  final TextEditingController? controller;
  final int? maxLines;
  final Function(String)? onFieldSubmitted;
  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines ?? 1,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
            fontWeight: FontWeight.w400, fontSize: 16, color: AppColors.black),
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
      onFieldSubmitted: onFieldSubmitted,
      style: const TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 16,
      ),
    );
  }
}
