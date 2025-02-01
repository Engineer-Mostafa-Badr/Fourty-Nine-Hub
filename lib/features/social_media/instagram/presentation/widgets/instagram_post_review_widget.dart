import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class InstagramPostReviewWidget extends StatelessWidget {
  const InstagramPostReviewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.favorite,
                size: 35,
                color: Color(0xffFE0135),
              ),
              const Sizer(
                width: 6,
              ),
              const Text(
                "34.6 k",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900),
              ),
              const Sizer(
                width: 20,
              ),
              Image.asset(
                Assets.instagramCommentIcon,
                width: 30,
              ),
              const Sizer(width: 6,),
              const Text(
                "34.6",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900),
              ),
              const Sizer(
                width: 20,
              ),
              Image.asset(
                Assets.instagramSharePostIcon,
                width: 30,
              ),
              const Sizer(width: 6,),
              const Text(
                "34.6",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900),
              ),
              const Spacer(),
              const Icon(
                Icons.bookmark_border_outlined,
                size: 35,
              )
            ],
          ),
          const Sizer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                Row(
            children: [
              Row(
            children: [
              Container(
                width: 25,
                height: 25,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red
                ),
              ),
              const Sizer(),
              Text.rich(TextSpan(children: [
                const TextSpan(
                    text: "Liked by ",
                    style: TextStyle(fontSize: 18)),
                TextSpan(
                    text: "craig_love",
                    style: Styles.headerText(fontWeight: FontWeight.w900)),

                const TextSpan(
                    text: " and 44,686 others",
                    style: TextStyle(fontSize: 18))
              ])),
            ],
          ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Text.rich(TextSpan(children: [
              TextSpan(
                      text: "craig_love",
                      style: Styles.headerText(fontWeight: FontWeight.w900)),
              const TextSpan(
                text: " Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ",
                style: TextStyle(fontSize: 18))
            ])),
          ),
          const Sizer(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Row(
              children: [
                Text(
                  "September 19",
                  style: TextStyle(fontSize: 17, color: Colors.black.withOpacity(0.4)),
                ),
              ],
            ),
          )
              ],
            ),
          )
      ],
    );
  }
}