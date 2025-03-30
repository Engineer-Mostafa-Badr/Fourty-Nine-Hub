import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class CustomDateTextFieldHealth extends StatelessWidget {
  const CustomDateTextFieldHealth({
    super.key,
    this.onChanged,
    required this.hintText,
    required this.keyboardType,
    this.validator,
    required this.controller,
    required this.onTap,
  });

  final Function(String)? onChanged;
  final String hintText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final TextEditingController controller;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 42,
      constraints: const BoxConstraints(
        minHeight: 44,
      ),
      child: TextFormField(
        controller: controller,
        maxLines: 1,
        keyboardType: keyboardType,
        readOnly: true,
        onTap: () {},
        onChanged: onChanged,
        style: Styles.mediumText(
          fontSize: 32,
          color: const Color(0xCC000000),
          height: 1.60,
        ),
        decoration: InputDecoration(
          suffixIconConstraints: const BoxConstraints(
            // maxHeight: 20,
            // maxWidth: 20,
            minHeight: 40,
            minWidth: 40,
          ),
          suffixIcon: Padding(
            padding: const EdgeInsetsDirectional.only(end: 18),
            child: SvgPicture.asset(
              Assets.calendarIcon,
            ),
          ),
          fillColor: const Color(0xffD9D9D9),
          filled: true,
          contentPadding: const EdgeInsetsDirectional.only(start: 16),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(
              color: Color(0xffD9D9D9), // Use grey as the default border color
            ),
          ),
          // Border when the field is focused
          focusedBorder: const OutlineInputBorder(
            // borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(
              color: Color(0xffD9D9D9), // Grey border when focused
            ),
          ),
          // Default border (same as enabledBorder)
          border: const OutlineInputBorder(
            // borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(
              color: Color(0xffD9D9D9),
            ),
          ),
          // Error border when validation fails
          errorBorder: const OutlineInputBorder(
            // borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(
              color: Colors.red, // Red border when there's an error
            ),
          ),
          // Error border when focused and invalid
          focusedErrorBorder: const OutlineInputBorder(
            // borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(
              color: Colors.red, // Keep red border when focused with an error
            ),
          ),
          hintStyle: Styles.mediumText(fontSize: 32),
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
