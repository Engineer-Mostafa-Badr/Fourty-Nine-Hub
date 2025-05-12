import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class CreateAdTextFormField extends StatelessWidget {
  const CreateAdTextFormField({
    super.key,
    required this.onChanged,
    required this.hintText,
    required this.keyboardType,
    this.validator,
    this.inputFormatters,
  });

  final Function(String)? onChanged;
  final String hintText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 42,
      constraints: const BoxConstraints(
        minHeight: 42,
      ),
      child: TextFormField(
        maxLines: 1,
        keyboardType: keyboardType,
        onChanged: onChanged,
        inputFormatters: inputFormatters,
        style: Styles.mediumText(fontSize: 32, color: context.isDarkMode?AppColors.whiteColor:Colors.black),
        decoration: InputDecoration(
          fillColor:AppColors.getFillColor(context),
          //context.isDarkMode?AppColors.GREY_DARK_COLOR:const Color(0xffF5F5F5),
          filled: true,
          contentPadding: const EdgeInsetsDirectional.only(start: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide.none,
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide.none,
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide.none,
          ),
          hintStyle: Styles.mediumText(fontSize: 32,color: context.isDarkMode?AppColors.whiteColor:Colors.black),
          hintText: hintText,
          // prefix: Sizer(
          //   width: 20.w,
          // ),
        ),
        // keyboardType: TextInputType.number,
        validator: validator,
      ),
    );
  }
}
