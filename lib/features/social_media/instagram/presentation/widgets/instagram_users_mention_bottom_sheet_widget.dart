import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class InstagramUsersMentionBottomSheetWidget extends StatelessWidget {
  const InstagramUsersMentionBottomSheetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 1.5,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          const Sizer(),
          Text("Collaborators", style: Styles.headerText(),),
          const Sizer(),
          const Sizer(),
          Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red,
                ),
              ),
              const Sizer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("edwardfouad", style: Styles.headerText(),),
                  Text("Edward", style: Styles.mediumText(color: Colors.grey, fontWeight: FontWeight.w300),),
                ],
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: AppColors.PRIMARY_COLOR
                ),
                child: Text("Follow", style: Styles.headerText(fontWeight: FontWeight.w500, color: Colors.white),),
              )
            ],
          ),
          const Sizer(),
          Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red,
                ),
              ),
              const Sizer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("edwardfouad", style: Styles.headerText(),),
                  Text("Edward", style: Styles.mediumText(color: Colors.grey, fontWeight: FontWeight.w300),),
                ],
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: AppColors.PRIMARY_COLOR
                ),
                child: Text("Follow", style: Styles.headerText(fontWeight: FontWeight.w500, color: Colors.white),),
              )
            ],
          )
        ],
      ),
    );
  }
}