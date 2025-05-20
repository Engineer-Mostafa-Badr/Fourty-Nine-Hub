import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomSupportTextField extends StatelessWidget {
  final String hintText;
  final bool? enabled;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final Function(String?) validator;

  const CustomSupportTextField({Key? key, required this.hintText, required this.controller, required this.validator, this.enabled, this.keyboardType, this.inputFormatters}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color borderColor = isDarkMode ? Colors.grey.shade900 : Colors.grey.shade100;
    final Color fillColor = isDarkMode ? Colors.grey.shade900 : Colors.grey.shade100;
    final Color textColor = isDarkMode ? Colors.white : Colors.black;

    return TextFormField(
      controller: controller,
      style: TextStyle(color: textColor),
      validator: (value) => validator(value),
      enabled: enabled,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: isDarkMode ? Colors.grey.shade500 : Colors.grey.shade600),
        filled: true,
        fillColor: fillColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(color: borderColor, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 13, horizontal: 16),
      ),
    );
  }
}


// class CustomSupportTextField extends StatelessWidget {
//   final String hintText;
//   final TextEditingController controller;
//
//   const CustomSupportTextField({Key? key, required this.hintText, required this.controller}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       controller: controller,
//       decoration: InputDecoration(
//         hintText: hintText,
//         filled: true,
//         fillColor: Colors.grey.shade100,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(50),
//           borderSide: BorderSide(color: Colors.grey.shade100),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(50),
//           borderSide: BorderSide(color: Colors.grey.shade100),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(50),
//           borderSide: BorderSide(color: Colors.grey.shade100, width: 2),
//         ),
//         contentPadding: EdgeInsets.symmetric(vertical: 13, horizontal: 16),
//       ),
//     );
//   }
// }
