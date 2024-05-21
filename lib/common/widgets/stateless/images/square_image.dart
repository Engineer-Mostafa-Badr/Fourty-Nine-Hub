import 'package:flutter/material.dart';

class SquareImage extends StatelessWidget {
  final ImageProvider source;
  final double? height, width, radius;
  final BoxFit? fit;

  const SquareImage(
      {super.key,
      required this.source,
      this.height,
      this.width,
      this.radius,
      this.fit});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius ?? 0),
      child: Image(
        image: source,
        fit: fit ?? BoxFit.cover,
        height: height,
        width: width,
      ),
    );
  }
}
