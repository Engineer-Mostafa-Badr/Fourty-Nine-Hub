import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/features/trip_join/presentation/views/widgets/test_screen.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

import '../../../../../res/assets/assets.dart';

class CaptainShareScreen extends StatelessWidget {
  const CaptainShareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 89,),
          const Text("Captain Share!",style:
            TextStyle(
              color: AppColors.PRIMARY_COLOR,
              fontWeight: FontWeight.w600,
              fontSize: 30
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12,),
          Image.asset(Assets.captainShare),
          const SizedBox(height: 44,),
          BulletPoint(text: "Save money & Book 1 seat."),
          BulletPoint(text: "Heading final destination."),
          BulletPoint(text: "Wait for others to share route seats with your captain."),
          const SizedBox(height: 36,),
          AppButton(
            radius: 22,
            color: AppColors.LIGHT_COLOR,
            backColor: AppColors.PRIMARY_COLOR,
              height: 55,
              width: 204,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 20,
                color:  AppColors.LIGHT_COLOR,
              ),
              label: "Join Now!", onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> TestScreen1()));
          })
        ],
      ),
    );
  }
}
class BulletPoint extends StatelessWidget {
  final String text;
  const BulletPoint({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("• ", style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700)),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 20,
          fontWeight: FontWeight.w700,
            color: AppColors.black
          ))),
        ],
      ),
    );
  }
}