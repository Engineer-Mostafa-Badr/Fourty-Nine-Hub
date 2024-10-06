import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';


class ImageCardWidget extends StatelessWidget {
  const ImageCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return    Expanded(
      flex: context.screenWidth > 600 ? 1 : 2,
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: const DecorationImage(
              image: AssetImage(
                'assets/images/doctor.png',
              ),
              fit: BoxFit.cover,
            ),
          ),
          height: context.screenWidth > 600 ? 200 : 150
      ),
    );
  }
}
