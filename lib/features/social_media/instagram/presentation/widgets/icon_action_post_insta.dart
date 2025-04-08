import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/utils/format_numbers.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/icon_and_value_widget.dart';
import 'package:fourtyninehub/res/assets/assets.dart';

class IconsActionPostInsta extends StatelessWidget {
  const IconsActionPostInsta({
    super.key,
    required this.likes,
    required this.comments,
    required this.shares,
  });

  final num likes;
  final num comments;
  final num shares;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          IconAndValueWidget(
            icon: const Icon(
              Icons.favorite,
              color: Color(0xffFE0135),
            ),
            value: FormatNumbers().formatNumber(likes),
            onPressed: () {},
          ),
          const SizedBox(
            width: 9,
          ),
          IconAndValueWidget(
            icon: Image.asset(
              Assets.instagramCommentIcon,
              width: 30,
            ),
            value: FormatNumbers().formatNumber(comments),
            onPressed: () {
              showBottomSheet(
                context: context,
                builder: (context) {
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: DraggableScrollableSheet(
                      maxChildSize: 1,
                      initialChildSize: 1,
                      minChildSize: 0.3,
                      builder: (context, scrollController) {
                        return Container();
                      },
                    ),
                  );
                },
              );
            },
          ),
          // Image.asset(
          //   Assets.instagramCommentIcon,
          //   width: 30,
          // ),
          // const Sizer(
          //   width: 6,
          // ),
          // const Text(
          //   "34.6",
          //   style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900),
          // ),
          const SizedBox(
            width: 9,
          ),
          IconAndValueWidget(
            icon: Image.asset(
              Assets.instagramSharePostIcon,
              width: 30,
            ),
            value: FormatNumbers().formatNumber(shares),
            onPressed: () {},
          ),
          // Image.asset(
          //   Assets.instagramSharePostIcon,
          //   width: 30,
          // ),
          // const Sizer(
          //   width: 6,
          // ),
          // const Text(
          //   "34.6",
          //   style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900),
          // ),
          const Spacer(),
          const Icon(
            Icons.bookmark_border_outlined,
            size: 22,
          )
        ],
      ),
    );
  }
}
