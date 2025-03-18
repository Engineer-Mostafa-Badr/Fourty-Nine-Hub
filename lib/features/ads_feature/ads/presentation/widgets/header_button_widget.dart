import 'package:flutter/material.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class HeaderButtonWidget extends StatelessWidget {
  const HeaderButtonWidget({
    super.key,
    required this.title,
    required this.onPressed,
  });
  final String title;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        // width: double.infinity,
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: ShapeDecoration(
          color: const Color(0xFFD9D9D9),
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1, color: Color(0xFF0B1035)),
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Center(
          child: Text(
            title,
            style: Styles.headerText(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
