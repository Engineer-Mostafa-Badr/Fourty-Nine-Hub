import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class InstagramUsersMentionBottomSheetWidget extends StatelessWidget {
  const InstagramUsersMentionBottomSheetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
          Sizer(),
          Text("Collaborators", style: Styles.headerText(),),
          Sizer(),
          Sizer(),
          Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red,
                ),
              ),
              Sizer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("edwardfouad", style: Styles.headerText(),),
                  Text("Edward", style: Styles.mediumText(color: Colors.grey, fontWeight: FontWeight.w300),),
                ],
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: AppColors.PRIMARY_COLOR
                ),
                child: Text("Follow", style: Styles.headerText(fontWeight: FontWeight.w500, color: Colors.white),),
              )
            ],
          ),
          Sizer(),
          Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red,
                ),
              ),
              Sizer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("edwardfouad", style: Styles.headerText(),),
                  Text("Edward", style: Styles.mediumText(color: Colors.grey, fontWeight: FontWeight.w300),),
                ],
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
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