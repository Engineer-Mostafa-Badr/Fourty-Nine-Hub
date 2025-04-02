import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/post_image_instagram.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/value_and_title_header_profile_instagram.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

class HeaderProfileInstagram extends StatelessWidget {
  const HeaderProfileInstagram({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Stack(
            children: [
              const ImageFromInternet(
                image: testImage,
                isCircle: true,
                height: 86,
                width: 86,
                fit: BoxFit.cover,
              ),
              PositionedDirectional(
                bottom: 0,
                end: 5,
                child: Container(
                  width: 29,
                  height: 29,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Color(0xFF0B1035), Color(0xFFFF3308)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  padding: const EdgeInsets.all(3),
                  child: const CircleAvatar(
                    backgroundColor: AppColors.PRIMARY_COLOR,
                    radius: 18,
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Spacer(
            flex: 2,
          ),
          const ValueAndTitleHeaderProfileInstagram(
            value: '2',
            title: 'Post',
          ),
          const Spacer(),
          const ValueAndTitleHeaderProfileInstagram(
            value: '12',
            title: 'Friend',
          ),
           const Spacer(),
          const ValueAndTitleHeaderProfileInstagram(
            value: '23',
            title: 'Follower',
          ),
          const Spacer(),
          const ValueAndTitleHeaderProfileInstagram(
            value: '23',
            title: 'view',
          ),
        ],
      ),
    );
  }
}
