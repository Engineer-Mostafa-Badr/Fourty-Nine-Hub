import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';

class ImageCardWidget extends StatelessWidget {
  const ImageCardWidget({super.key, required this.image});
  final String image;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: context.screenWidth > 600 ? 1 : 2,
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(
              image: NetworkImage(
                image,
              ),
              fit: BoxFit.cover,
            ),
          ),
          height: context.screenWidth > 600 ? 200 : 150),
    );
  }
}
