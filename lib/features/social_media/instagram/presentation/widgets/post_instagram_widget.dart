import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/entities/instagram_post_entity.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/instagram_post_review_widget.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/instgram_images_post_widget.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';

class PostInstagramWidget extends StatelessWidget {
  const PostInstagramWidget({
    super.key,
    required this.posts,
    required this.currentIndex,
    required this.instagramPostEntity,
  });

  final List<InstagramPostEntity> posts;
  final int currentIndex;
  final InstagramPostEntity instagramPostEntity;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InstgramImagesPostWidget(
          instagramPostEntity: instagramPostEntity,
        ),
        const Sizer(),
        InstagramPostReviewWidget(
          // instagramPostEntity: instagramPostEntity,
          posts: posts,
          currentPost: currentIndex,
        ),
      ],
    );
  }
}

const String testImage =
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRQT08_1dF0iNLYfRnL2lbqnlXg5QKKofxDew&s';
const String testImage2 =
    'https://media.istockphoto.com/id/1144235214/photo/children-reading.jpg?s=170667a&w=0&k=20&c=VXqyVg8fnch5yQZMZNpOAenr58QvqvGgDpNwa1uNIow=';
