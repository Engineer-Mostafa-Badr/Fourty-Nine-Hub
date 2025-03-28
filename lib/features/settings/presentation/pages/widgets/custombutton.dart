import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {super.key,
      required this.onPressed,
      required this.color,
      required this.text,
      required this.textStyle});

  final void Function() onPressed;
  final Color color;
  final String text;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width * .4,
      height: 44, // ارتفاع الزر الجديد
      child: RawMaterialButton(
        onPressed: onPressed,
        fillColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 0.0,
        child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
            ),
            child: Text(
              text,
              style: textStyle,
            )),
      ),
    );
  }
}
