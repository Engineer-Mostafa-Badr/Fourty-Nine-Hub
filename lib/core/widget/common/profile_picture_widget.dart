import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/build_gradient_border.dart';

class ProfilePictureWidget extends StatelessWidget {
  const ProfilePictureWidget({super.key, this.width, this.height,this.hasStories=true, this.isViewed, this.segments, this.firstChar, this.image});
  final double? width;
  final double? height;
  final bool? isViewed;
  final bool? hasStories;
  final int? segments;
  final String? firstChar;
  final String? image;
  @override
  Widget build(BuildContext context) {
    return GradientProfileBorder(
        imageUrl:  image??"",
        imageWidth: 46,
        fullWidth: 54,
        hasStories: hasStories,
        isViewed: isViewed??false,
        segments: segments??1,
        firstChar: firstChar??'M');
  }
}
