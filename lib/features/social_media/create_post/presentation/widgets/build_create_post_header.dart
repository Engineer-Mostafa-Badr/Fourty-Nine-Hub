import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fourtyninehub/features/social_media/create_post/presentation/widgets/build_drop_down.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

class BuildCreatePostHeader extends StatelessWidget {
  const BuildCreatePostHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Picture
          Container(
            width: 53,
            height: 53,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.GREYBG
            ),
            child: Center(
              child: SvgPicture.asset(Assets.maleIcon,width: 32,height: 35,),
            ),
          ),
          const SizedBox(width: 10),

          // Name
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Mohemed Gamal',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                const SizedBox(
                  height: 11,
                ),
                Row(
                  children: [
                    BuildDropDown(icon:Assets.publicIcon,text:  'Public',width: 16,height: 16,),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                // Dropdown Buttons
                Row(
                  children: [
                    BuildDropDown(icon:Assets.onInstaIcon,text: 'Off',width: 10,height: 10),
                    const SizedBox(width: 5),
                    BuildDropDown(icon:Assets.onTweetIcon,text: 'Off'),
                  ],
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }
}
