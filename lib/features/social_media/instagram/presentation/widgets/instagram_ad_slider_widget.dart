import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class InstagramAdSliderWidget extends StatelessWidget {
  const InstagramAdSliderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
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
              Spacer(),
              Text(
                "See all",
                style: Styles.headerText(
                    fontSize: 41,
                    fontWeight: FontWeight.w800,
                    color: Color(0xff1198F8)),
              ),
            ],
          ),
          Sizer(),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ...List.generate(
                  10,
                  (index) {
                    return Container(
                      
                      margin: EdgeInsets.symmetric(horizontal: 7),
                      width: MediaQuery.of(context).size.width-60,
                      height: 450,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black.withValues(alpha: 0.2)),
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            child: Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.red,
                                  ),
                                ),
                                Sizer(),
                                Text("axiombyartal", style: Styles.headerText(fontWeight: FontWeight.bold),),
                                Spacer(),
                                Icon(Icons.more_vert_rounded)
                              ],
                            ),
                          ),
                          Sizer(),
                          Container(
                            width: double.infinity,
                            height: 300,
                            color: Colors.red,
                          ),
                          Sizer(),
                          Container(
                            padding: EdgeInsets.all(10),
                            height: 50,
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color(0xff4B5EFA)
                            ),
                            child: Center(
                              child: Text(
                    "Sign Up",
                    style: Styles.headerText(
                        fontSize: 41, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                            ),
                          ),
                          Sizer()
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
