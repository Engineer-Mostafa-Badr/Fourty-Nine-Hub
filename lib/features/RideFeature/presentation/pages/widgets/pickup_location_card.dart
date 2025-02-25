import 'package:flutter/material.dart';

import 'custom_color_circle_widget.dart';

class PickUpLocationCard extends StatelessWidget {
  final String title;
  final Color? firstColor;

  const PickUpLocationCard({super.key, required this.title, this.firstColor});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 48,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            CustomColorCircleWidget(firstColor: firstColor,),
            // Text "PickUp Location"
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ));
  }
}
