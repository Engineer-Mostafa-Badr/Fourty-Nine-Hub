import 'package:flutter/material.dart';

class CustomRow extends StatelessWidget {
  const CustomRow({super.key, required this.children});
  final List<Widget> children;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 1,
          child: children[0],
        ),
        Expanded(
          flex: 2,
          child: children[1],
        ),
        Expanded(
          flex: 1,
          child: children[2],
        ),
        Expanded(
          flex: 1,
          child: children[3],
        ),
      ],
    );
  }
}
