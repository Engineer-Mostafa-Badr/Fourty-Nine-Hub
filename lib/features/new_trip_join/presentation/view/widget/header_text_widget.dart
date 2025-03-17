import 'package:flutter/material.dart';

class HeaderTextWidget extends StatelessWidget {
  const HeaderTextWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      "One Way - One Captain!",
      style: TextStyle(
        color: Colors.red,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    );
  }
}
