import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class InstagramAdSliderWidget extends StatelessWidget {
  const InstagramAdSliderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "You might like",
                    style: Styles.headerText(
                        fontSize: 41, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Sponsored",
                    style: Styles.headerText(color: Colors.grey),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                "See all",
                style: Styles.headerText(
                    fontSize: 41,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xff1198F8)),
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
                      width: MediaQuery.of(context).size.width-60,
                      height: 450,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black.withValues(alpha: 0.2)),
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.red,
                                  ),
                                ),
                                const Sizer(),
                                Text("axiombyartal", style: Styles.headerText(fontWeight: FontWeight.bold),),
                                const Spacer(),
                                const Icon(Icons.more_vert_rounded)
                              ],
                            ),
                          ),
                          const Sizer(),
                          Container(
                            width: double.infinity,
                            height: 300,
                            color: Colors.red,
                          ),
                          const Sizer(),
                          Container(
                            padding: const EdgeInsets.all(10),
                            height: 50,
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color(0xff4B5EFA)
                            ),
                            child: Center(
                              child: Text(
                    "Sign Up",
                    style: Styles.headerText(
                        fontSize: 41, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                            ),
                          ),
                          const Sizer()
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
