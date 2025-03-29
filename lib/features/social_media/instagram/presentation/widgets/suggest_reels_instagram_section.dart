import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/header_suggest_reels_instagram.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/vedio_suggest_reels_item.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';

class SuggestReelsInstagramSection extends StatelessWidget {
  const SuggestReelsInstagramSection({
    super.key,
    required this.vediosSuggestReels,
  });
  final List<String> vediosSuggestReels;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const HeaderSuggestReelsInstagram(),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 340,
          child: ListView.separated(
            itemCount: vediosSuggestReels.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsetsDirectional.only(
                  start: index == 0 ? 20 : 0,
                  end: index == vediosSuggestReels.length - 1 ? 20 : 0,
                ),
                child: VedioSuggestReelsItem(
                  videoReelUrl: vediosSuggestReels[index],
                ),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(
              width: 9,
            ),
          ),
        ),
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 6),
        //   child: SingleChildScrollView(
        //     scrollDirection: Axis.horizontal,
        //     child: Row(
        //       children: [
        //         ...List.generate(
        //           10,
        //           (index) {
        //             return Container(
        //               margin: const EdgeInsets.symmetric(horizontal: 4),
        //               height: 320,
        //               width: 180,
        //               decoration: BoxDecoration(
        //                   color: Colors.red,
        //                   borderRadius: BorderRadius.circular(10)),
        //             );
        //           },
        //         )
        //       ],
        //     ),
        //   ),
        // ),
      ],
    );
  }
}

const String testVideoUrl =
    'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4';

const String testVideoUrl2 =
    'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4';

const String testVideoUrl3 =
    'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4';
