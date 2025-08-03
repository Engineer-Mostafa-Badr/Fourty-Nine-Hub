import 'package:flutter/material.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import 'image_story_instagram_header.dart';
import 'stores_instagram_widget.dart';
import '../../../../../res/style/styles.dart';

class StoryInstagramHeaderItem extends StatelessWidget {
  final StoryItemEntity storyItemEntity;

  const StoryInstagramHeaderItem({super.key, required this.storyItemEntity});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      child: Column(
        children: [
          ImageStoryInstagramHeader(
            storyCount: storyItemEntity.storyCount,
            currentSegment: storyItemEntity.storyCount,
            imageUrl: storyItemEntity.imageUrl,
          ),
          const SizedBox(
            height: 4,
          ),
          SizedBox(
            width: 62,
            child: Label(
              text: storyItemEntity.userName,
              textAlign: TextAlign.center,
              style: Styles.mediumText(
                fontSize: 26,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// class StoryInstagramHeaderItem extends StatelessWidget {
//   const StoryInstagramHeaderItem({
//     super.key,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       // margin: const EdgeInsets.symmetric(horizontal: 5),
//       width: 63,
//       height: 63,
//       padding: const EdgeInsets.all(2),
//       decoration: const BoxDecoration(
//           shape: BoxShape.circle,
//           gradient: LinearGradient(
//               begin: Alignment.bottomLeft,
//               end: Alignment.topRight,
//               colors: [ Color(0xff0B1035), Color(0xffFF3308)])
//       ),
//       child: Container(
//         width: 62,
//         height: 62,
//         decoration: BoxDecoration(
//             image: const DecorationImage(image: NetworkImage("https://s3-alpha-sig.figma.com/img/a677/a41f/027410390877dbe19c213b2e6ee60b75?Expires=1739145600&Key-Pair-Id=APKAQ4GOSFWCW27IBOMQ&Signature=trQX6rLzjb2KRVVX2b7OTmfE69SHVesB4Zxz5~W0xrsT-0eGVGlVydBvDHFIXvG67eSnD951UOaz52LjUpX-f~E~FILgg26ieyspu-ifFKbB~JUrPS23hjBog~lcv~k9sv3JmT8mn10UHRnLdO0tAjYluVqjHwsPDMPC-b91LQm61GxL0GTJ1YdKihu2zyE9bLKlUHLriTxG-mUaZI1eytj0zuJBv-FwfHGPrJOSEplqy2RxoANRCpAef-k2uDqdds5WB1-R1baLF3Tfif~kMraTEq4lSYxEppQ6Dti2WOxzpsq80Sp9sOUBCF6tqxqEddd5FAoY2vhOqDQfHJHlLQ__"), fit: BoxFit.cover),
//             shape: BoxShape.circle,
//             border: Border.all(color: Colors.white, width: 1.5)
//         ),
//       ),
//     );
//   }
// }
