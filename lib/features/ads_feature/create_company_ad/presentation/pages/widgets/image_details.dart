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
    double _scale = 1.0;
    double _previousScale = 1.0;
    final double _minScale = 1.0;
    final double _maxScale = 4.0; // Maximum scale factor
    Offset _position = Offset.zero;
    Offset _previousPosition = Offset.zero;

    return GestureDetector(
      onScaleStart: (ScaleStartDetails details) {
        _previousScale = _scale;
        _previousPosition = details.focalPoint;
      },
      onScaleUpdate: (ScaleUpdateDetails details) {
        setState(() {
          _scale = (_previousScale * details.scale).clamp(_minScale, _maxScale);

          if (_scale > _minScale) {
            final Offset delta = details.focalPoint - _previousPosition;
            _previousPosition = details.focalPoint;
            _position += delta;
          } else {
            _position = Offset.zero;
          }
        });
      },
      onScaleEnd: (ScaleEndDetails details) {
        _previousScale = 1.0;
        _previousPosition = Offset.zero;
      },
      onDoubleTap: () {
        setState(() {
          if (_scale > _minScale) {
            _scale = _minScale;
            _position = Offset.zero;
          } else {
            _scale = 2.0; // Zoom-in scale factor on double-tap
            _position = Offset.zero; // Center the image
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
                  ..translate(_position.dx, _position.dy)
                  ..scale(_scale),
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
