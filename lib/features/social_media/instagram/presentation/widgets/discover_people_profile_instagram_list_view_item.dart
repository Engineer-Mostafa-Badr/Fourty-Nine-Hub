import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/post_image_instagram.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class DiscoverPeopleProfileInstagramListViewItem extends StatelessWidget {
  const DiscoverPeopleProfileInstagramListViewItem({super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      // width: MediaQuery.of(context).size.width * 0.3,
      aspectRatio: 121 / 151,
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const ImageFromInternet(
                image: testImage,
                height: 60,
                width: 60,
                isCircle: true,
                fit: BoxFit.cover,
              ),
              const SizedBox(
                height: 4,
              ),
              Label(
                text: 'ahmed mohamed',
                style: Styles.mediumText(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Label(
                text: 'followed by',
                style: Styles.mediumText(
                  fontSize: 22,
                  color: Colors.black.withValues(alpha: 153),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Label(
                  text: 'mohamed ahmed + 4',
                  style: Styles.mediumText(
                    fontSize: 22,
                    color: Colors.black.withValues(alpha: 153),
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              AppButton(
                height: 24,
                width: 121,
                label: 'follow',
                style: Styles.headerText(
                  fontSize: 24,
                  color: Colors.white,
                  height: 1.50,
                ),
                backColor: const Color(0xFF0B1035),
                onPressed: () {},
              ),
            ],
          ),
          PositionedDirectional(
            top: 0,
            end: 0,
            child: InkWell(
              onTap: () {},
              child: const Icon(
                Icons.close,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
