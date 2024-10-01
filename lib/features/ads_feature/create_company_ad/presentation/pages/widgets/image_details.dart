import 'package:flutter/material.dart';

import '../../../../../../res/style/app_colors.dart';

class ImageDetails extends StatefulWidget {
  const ImageDetails({super.key, required this.image, required this.function});

  final String image;
  final Function function;

  @override
  State<ImageDetails> createState() => _ImageDetailsState();
}

class _ImageDetailsState extends State<ImageDetails> {
  @override
  Widget build(BuildContext context) {
    double scale = 1.0;
    double previousScale = 1.0;
    const double minScale = 1.0;
    const double maxScale = 4.0; // Maximum scale factor
    Offset position = Offset.zero;
    Offset previousPosition = Offset.zero;

    return GestureDetector(
      onScaleStart: (ScaleStartDetails details) {
        previousScale = scale;
        previousPosition = details.focalPoint;
      },
      onScaleUpdate: (ScaleUpdateDetails details) {
        setState(() {
          scale = (previousScale * details.scale).clamp(minScale, maxScale);

          if (scale > minScale) {
            final Offset delta = details.focalPoint - previousPosition;
            previousPosition = details.focalPoint;
            position += delta;
          } else {
            position = Offset.zero;
          }
        });
      },
      onScaleEnd: (ScaleEndDetails details) {
        previousScale = 1.0;
        previousPosition = Offset.zero;
      },
      onDoubleTap: () {
        setState(() {
          if (scale > minScale) {
            scale = minScale;
            position = Offset.zero;
          } else {
            scale = 2.0; // Zoom-in scale factor on double-tap
            position = Offset.zero; // Center the image
          }
        });
      },
      child: Stack(
        alignment: AlignmentDirectional.topStart,
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: AppColors.BACKGROUND_COLOR,
            ),
            child: Center(
              child: Transform(
                transform: Matrix4.identity()
                  ..translate(position.dx, position.dy)
                  ..scale(scale),
                child: Image.network(
                  widget.image,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back))
        ],
      ),
    );
  }
}
