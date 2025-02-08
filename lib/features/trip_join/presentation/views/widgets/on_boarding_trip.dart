import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/features/trip_join/presentation/views/widgets/test_screen.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

import '../../../../../res/assets/assets.dart';

class OnBoardingTrip extends StatelessWidget {
  const OnBoardingTrip({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// Background gradient covering the full screen
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF0B1035), // #0B1035
                  Color(0xFFFF3308), // #FF3308
                ],
              ),
            ),
          ),

          /// Content placed on top of the gradient
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 12),

                /// Image should take full width
                Image.asset(
                  Assets.onBoardingTrip,
                  width: double.infinity,
                  // fit: BoxFit.cover, // Ensures full visibility
                ),

                const SizedBox(height: 44),
                const SizedBox(height: 36),

                /// Join Now Button
                AppButton(
                  radius: 22,
                  color: AppColors.LIGHT_COLOR,
                  backColor: AppColors.PRIMARY_COLOR,
                  height: 55,
                  width: 204,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    color: AppColors.LIGHT_COLOR,
                  ),
                  label: "Join Now!",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TestScreen1()),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class BulletPoint extends StatelessWidget {
  final String text;
  BulletPoint({required this.text});

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