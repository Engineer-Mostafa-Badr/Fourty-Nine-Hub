import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class ReelSliderWidget extends StatelessWidget {
  const ReelSliderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text("Suggested reels", style: Styles.headerText(fontWeight: FontWeight.bold),),
          ),
          Sizer(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 6),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ...List.generate(
                    10,
                    (index) {
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 4),
                        height: 320,
                        width: 180,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10)
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
