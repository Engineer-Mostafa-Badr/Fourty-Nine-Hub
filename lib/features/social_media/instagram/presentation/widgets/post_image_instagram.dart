import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/header_post_instagram.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/instagram_post_review_widget.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/instgram_images_post_widget.dart';

class PostImageInstagram extends StatelessWidget {
  const PostImageInstagram({
    super.key,
    required this.isMenchan,
    required this.userImageUrl,
    required this.userName,
    required this.images,
    required this.isReal,
    this.country,
    this.songName,
    this.userNameMenchan,
    this.numberUserNamesMenchan,
    this.userImageMenchan,
  });

  final bool isMenchan;
  final String userImageUrl;
  final String userName;
  final List<String> images;
  final bool isReal;
  final String? country;
  final String? songName;
  final String? userNameMenchan;
  final int? numberUserNamesMenchan;
  final String? userImageMenchan;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HeaderPostInstagram(
          imageUrl: userImageUrl,
          userName: userName,
          isMenchan: isMenchan,
          isReel: isReal,
          country: country,
          songName: songName,
          numberUserNamesMenchan: numberUserNamesMenchan,
          userNameMenchan: userNameMenchan,
          userImageMenchan: userImageMenchan,
        ),
        const SizedBox(
          height: 5,
        ),
        InstgramImagesPostWidget(
          images: images,
        ),
        const SizedBox(
          height: 10,
        ),
        const InstagramPostReviewWidget()
      ],
    );
  }
}

const String testImage =
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRQT08_1dF0iNLYfRnL2lbqnlXg5QKKofxDew&s';
const String testImage2 =
    'https://media.istockphoto.com/id/1144235214/photo/children-reading.jpg?s=170667a&w=0&k=20&c=VXqyVg8fnch5yQZMZNpOAenr58QvqvGgDpNwa1uNIow=';
