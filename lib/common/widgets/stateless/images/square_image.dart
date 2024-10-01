import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/res/style/const.dart';

class SquareImage extends StatelessWidget {
  final ImageProvider? source;
  final String? url;
  final double? height, width, radius;
  final BoxFit? fit;

  const SquareImage(
      {super.key,
      this.source,
      this.height,
      this.width,
      this.url,
      this.radius,
      this.fit});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius ?? 0),
      child: SizedBox(
        height: height,
        width: width,
        child: url == null
            ? source != null
                ? Image(
                    image: source!,
                    fit: fit ?? BoxFit.cover,
                  )
                : const SizedBox()
            : CachedNetworkImage(
                fit: fit ?? BoxFit.cover,
                errorWidget: (context, i, v) {
                  return Image.network(UIConst.imagePlaceHolder);
                },
                imageUrl: url!,
              ),
      ),
    );
  }
}
