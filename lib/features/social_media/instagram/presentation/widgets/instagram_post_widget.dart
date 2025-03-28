import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/instagram_post_buttom_sheet_without_mention_widget.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/instagram_post_review_widget.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/instagram_user_info_with_mention_post_widget.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/instgram_images_post_widget.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class InstagramPostWidget extends StatelessWidget {
  const InstagramPostWidget(
      {super.key, required this.multiImage, required this.mechan});
  final bool multiImage;
  final bool mechan;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 19),
          child: Row(
            children: [
              InstagramUserInfoWithMentionPostWidget(
                isMenchan: mechan,
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    backgroundColor: Colors.white,
                    context: context,
                    builder: (context) =>
                        const InstagramPostButtomSheetWithoutMentionWidget(),
                  );
                },
                child: const Icon(Icons.more_vert_sharp),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        InstgramImagesPostWidget(
          images: multiImage
              ? [
                  testImage2,
            testImage2,
            testImage2,
                      ]
              : [
            testImage2,
                ],
        ),
        const SizedBox(
          height: 10,
        ),
        const InstagramPostReviewWidget()
      ],
    );
  }
}

const String testImage = 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRQT08_1dF0iNLYfRnL2lbqnlXg5QKKofxDew&s';
const String testImage2 = 'https://media.istockphoto.com/id/1144235214/photo/children-reading.jpg?s=170667a&w=0&k=20&c=VXqyVg8fnch5yQZMZNpOAenr58QvqvGgDpNwa1uNIow=';