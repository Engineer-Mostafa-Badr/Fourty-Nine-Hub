import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/instagram_users_mention_bottom_sheet_widget.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class InstagramUserInfoWithMentionPostWidget extends StatelessWidget {
  const InstagramUserInfoWithMentionPostWidget(
      {super.key, this.subTitle = "Tokyo, Japan", required this.isMenchan, this.isReel = false, this.thereMusic = false});
  final String subTitle;
  final bool isMenchan;
  final bool isReel;
  final bool thereMusic;
  @override
  Widget build(BuildContext context) {
    if (isMenchan) {
      return Row(
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
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  bottom: 7,
                  right: 7,
                  child: Container(
                    width: 25,
                    height: 25,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green,
                    ),
                  ),
                ),
                Container(
                  width: 25,
                  height: 25,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
          const Sizer(
            width: 30,
          ),
          const Text.rich(TextSpan(children: [
            TextSpan(
                text: "janegoodallinst",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            TextSpan(
                text: " and",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400)),
            TextSpan(
                text: " 2 others",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
          ]))
        ],
      );
    }
    return Row(
      children: [
        Container(
          width: 35,
          height: 35,
          decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.green,
              image: DecorationImage(
                  image: NetworkImage(
                      "https://s3-alpha-sig.figma.com/img/1f61/ca60/cbc85c23d3705e0ea9b22359ff9489cc?Expires=1739145600&Key-Pair-Id=APKAQ4GOSFWCW27IBOMQ&Signature=Uyugms~Fmw4vVcu1BrEVL5YlZLyB97nb4-coe-gLrCto0hRqLbU13MJyfj7TDtrbcj8Lduqdcq2YksEMH01--21mg~UNZ1uEBi4JWcbzHMV9Pk6sxt7qQKWINCezuAbam8~TBNkpJV3mzg5P4HTJ211hWNcnC86CT1B9Yj0O9ywIHM~W~SxE~Onla1PmcbRXhYmcWIL1GUMyPxwZfY9zQ3pa8PdPPTaKA-Y-WinGBeVfwZmxXFva0VmgNrBvl35bL40yjXx0WVKE01zPd5GENLH~iU4IdIj48eTeFK5NJNDYu7yZYViGhl322v3iUmQS~js-0wSqfaSVi1Pu6dLPyQ__"),
                  fit: BoxFit.cover)),
        ),
        const Sizer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "joshua_l",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: isReel? Colors.white:Colors.black),
            ),
            Row(
              children: [
                if(thereMusic)
                Image.asset(Assets.musicalNote, color: Colors.white, width: 17,),
                Text(
                  subTitle,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400,  color: isReel? Colors.white:Colors.black),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
