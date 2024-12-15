import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

class ImageDetailsScreen extends StatefulWidget {
  const ImageDetailsScreen({
    super.key,
    required this.image,
    required this.onRemoveImage,
    this.fromPost = false,
    this.isFile = false,
  });

  final String image;
  final bool? fromPost;
  final bool? isFile;
  final Function onRemoveImage;

  @override
  _ImageDetailsScreenState createState() => _ImageDetailsScreenState();
}

class _ImageDetailsScreenState extends State<ImageDetailsScreen> {
  double _scale = 1.0;
  double _previousScale = 1.0;
  final double _minScale = 1.0;
  final double _maxScale = 4.0; // Maximum scale factor
  Offset _position = Offset.zero;
  Offset _previousPosition = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: AppColors.BACKGROUND_COLOR,
      //   leading: IconButton(
      //     onPressed: () {
      //       widget.onRemoveImage();
      //     },
      //     icon: widget.fromPost == true
      //         ? const Icon(
      //             Icons.arrow_back,
      //             color: Colors.black,
      //           )
      //         : const Icon(
      //             Icons.close,
      //             color: Colors.black,
      //           ),
      //   ),
      // ),
      body: GestureDetector(
        onScaleStart: (ScaleStartDetails details) {
          _previousScale = _scale;
          _previousPosition = details.focalPoint;
        },
        onScaleUpdate: (ScaleUpdateDetails details) {
          setState(() {
            _scale =
                (_previousScale * details.scale).clamp(_minScale, _maxScale);

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
        child: Container(
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
              child: widget.fromPost == false || widget.isFile == true
                  ? Image.file(
                      File(widget.image),
                      fit: BoxFit.contain,
                    )
                  : ImageFromInternet(
                      image: widget.image,
                    ),

              // Image.network(
              //   widget.image,
              //   fit: BoxFit.contain,
              // ),
            ),
          ),
        ),
      ),
    );
  }
}
