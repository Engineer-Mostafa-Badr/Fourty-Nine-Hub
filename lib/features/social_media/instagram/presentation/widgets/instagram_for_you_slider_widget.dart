import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/pages/suggested_for_you_instagram_screen.dart';
import 'package:fourtyninehub/res/style/styles.dart';

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
                    fontSize: 41, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SuggestedForYouInstagramScreen(),
                      ));
                },
                child: Text(
                  "See all",
                  style: Styles.headerText(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xff1198F8)),
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
                      width: MediaQuery.of(context).size.width * 0.7,
                      // height: 350,
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.black.withValues(alpha: 0.2)),
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Icon(Icons.close),
                          const Sizer(),
                          Container(
                            width: double.infinity,
                            height: 220,
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
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                Text(
                                  "Suggested for you",
                                  style: Styles.headerText(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          const Sizer(),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            height: 40,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.blue,
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
