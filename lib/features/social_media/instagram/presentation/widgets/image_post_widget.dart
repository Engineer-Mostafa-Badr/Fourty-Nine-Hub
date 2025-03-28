import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';

class ImagePostWidget extends StatelessWidget {
  const ImagePostWidget({super.key, required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    ImageFromInternet(
      image: imageUrl,
      defaultLogo: false,
    );
    return Container(
      height: 400,
      decoration: BoxDecoration(
          color: Colors.green,
          image: DecorationImage(
              image: NetworkImage(imageUrl), fit: BoxFit.cover)),
    );
  }
}
