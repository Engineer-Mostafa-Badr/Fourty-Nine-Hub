import 'package:flutter/material.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../pages/suggested_for_you_instagram_screen.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../helpers/manage_vibration.dart';

class InstagramForYouSliderWidget extends StatelessWidget {
  const InstagramForYouSliderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "Suggested for you",
                style: Styles.headerText(
                    fontSize: 41, fontWeight: FontWeight.w500),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
      ManageVibration.vibrate();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const SuggestedForYouInstagramScreen(),
                      ));
                },
                child: Text(
                  "See all",
                  style: Styles.headerText(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: AppColors.PRIMARY_COLOR),
                ),
              ),
            ],
          ),
          const Sizer(),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ...List.generate(
                  10,
                  (index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 7),
                      width: MediaQuery.of(context).size.width * 0.65,
                      // height: 350,
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black.withValues(alpha: 0.2),
                          ),
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Sizer(),
                          Container(
                            width: double.infinity,
                            height: 160,
                            decoration: const BoxDecoration(
                                color: Colors.red, shape: BoxShape.circle),
                          ),
                          const Sizer(),
                          Align(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "zyad mohamed",
                                  style: Styles.headerText(
                                      fontSize: 41,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        Positioned(
                                          right: 14,
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
                                    const Sizer(),
                                    Text(
                                      "Followed by micaljohan,\nanthonymark + 67 morea",
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.black.withOpacity(0.6)),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          const Sizer(),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            height: 40,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: AppColors.PRIMARY_COLOR,
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                              child: Text(
                                "Follow",
                                style: Styles.headerText(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                          const Sizer(),
                        ],
                      ),
                    );
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}