import 'package:flutter/material.dart';

import '../../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../res/style/app_colors.dart';
import '../../../../../../res/style/const.dart';
import '../../../../../../res/style/styles.dart';

class Stories extends StatelessWidget {
  const Stories({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kToolbarHeight * 2.5,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        children: [
          const Sizer(),
          _buildYourStory(),
          const Sizer(),
          SizedBox(
            height: kToolbarHeight * 2.5,
            child: ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemBuilder: (context, index) => _buildOthersStories(),
                separatorBuilder: (context, index) => const Sizer(),
                itemCount: 10),
          )
        ],
      ),
    );
  }

  Widget _buildOthersStories() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Container(
        height: kToolbarHeight * 2.5,
        width: kToolbarHeight * 1.5,
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Stack(
          children: [
            Positioned.fill(
                child: Image.network(
              UIConst.imagePlaceHolder,
              fit: BoxFit.cover,
            )),
            Positioned.fill(
                child: Container(
              color: Colors.black.withOpacity(.2),
            )),
            Positioned.fill(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const CircleAvatar(
                    backgroundColor: AppColors.PRIMARY_COLOR,
                    radius: 16,
                    child: CircleAvatar(
                      radius: 14,
                      backgroundColor: Colors.white,
                      backgroundImage: NetworkImage(UIConst.profilePlaceHolder),
                    ),
                  ),
                  Label(
                      text: 'Mohamed Ayman',
                      textAlign: TextAlign.end,
                      style: Styles.smallText(
                          color: Colors.white, fontWeight: FontWeight.bold))
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }

  Widget _buildYourStory() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Container(
        height: kToolbarHeight * 2,
        width: kToolbarHeight * 1.5,
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Stack(
          children: [
            Positioned.fill(
                child: Column(
              children: [
                Expanded(child: Image.network(UIConst.profilePlaceHolder)),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Label(text: 'Create Story', style: Styles.smallText())
                    ],
                  ),
                ))
              ],
            )),
            const Positioned.fill(
                child: Center(
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 15,
                  backgroundColor: AppColors.PRIMARY_COLOR,
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }
}
