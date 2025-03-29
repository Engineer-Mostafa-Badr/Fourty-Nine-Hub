import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/instagram_post_buttom_sheet_without_mention_widget.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/instagram_post_review_widget.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/post_image_instagram.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/instagram_user_info_with_mention_post_widget.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/instagram_users_mention_bottom_sheet_widget.dart';

class InstagramVideoPostWidget extends StatelessWidget {
  const InstagramVideoPostWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
                color: Colors.grey,
                image: DecorationImage(
                    image: NetworkImage(
                        "https://s3-alpha-sig.figma.com/img/0bc9/9b33/fd3c921dc7e2bc5b7088deb7a22440e1?Expires=1739145600&Key-Pair-Id=APKAQ4GOSFWCW27IBOMQ&Signature=Q5w1W4UBIARlKqcTvrrCNdwqYNoheZyKYo8Iz4-9-LjCHNHCmzFfhpXqUIRYsiTogoqGrQixrfRABx~L7MpyRt9q-icdAGba3nmK6iRKab8pwSOmEZhbzoKK7CLqZJR1uifF0XVGbHitut9YpMQBeytWZdlPrZZMPaukRpJn6gAwe7EElrjrdt7cz9itzgbDLmEeDKQ9aGeGyVn-ZHd0xayy34hdYzdKpiNqiMVj6y9XjJ8A9oZlHMrhRjhj4GClBqDVg6IqGWRXtnqypiQ~9uefKq5CDv14AVULrf2qOgjFiVYNOfN~494obslsRuvsEDD-p4O8Peb3iaIKo4NYaw__"),
                    fit: BoxFit.cover)),
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  children: [
                    const InstagramUserInfoWithMentionPostWidget(
                      imageUrl: testImage,
                      userName: 'joshua_l',
                      isMenchan: false,
                      isReel: true,
                      thereMusic: true,
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
                        child: const Icon(
                          Icons.more_vert_sharp,
                          color: Colors.white,
                        )),
                  ],
                ),
                const Sizer(),
                Container(
                  height: 400,
                  decoration: const BoxDecoration(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.white,
                          builder: (context) {
                            return const InstagramUsersMentionBottomSheetWidget();
                          },
                        );
                      },
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                            child: Icon(
                          Icons.person,
                          size: 20,
                          color: Colors.white,
                        )),
                      ),
                    ),
                    Container(
                      width: 30,
                      height: 30,
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                          child: Icon(
                        Icons.volume_off_rounded,
                        size: 20,
                        color: Colors.white,
                      )),
                    )
                  ],
                )
              ],
            ),
          ),
          const Sizer(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: const Column(
              children: [InstagramPostReviewWidget()],
            ),
          )
        ],
      ),
    );
  }
}
