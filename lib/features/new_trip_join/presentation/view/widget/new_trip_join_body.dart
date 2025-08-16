import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:go_router/go_router.dart';
import '../../../../../res/assets/assets.dart';
import '../../../../../routes/routes.dart';
import 'trip_option_widget.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

class NewTripJoinBody extends StatelessWidget {
  const NewTripJoinBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TripOptionWidget(
                imagePath: Assets.locationTripIcon,
                title: context.isArabic ? 'مشاركة كابتن' : 'Captain Share',
                onTap: () {
                  ManageVibration.vibrate();
                  context.pushNamed(Routes.captainShareScreen);
                },
              ),
              TripOptionWidget(
                imagePath: Assets.locationTripIcon,
                title: context.isArabic ? "جاي معاك" : "Trip Join",
                icon: Assets.car,
                onTap: () {
                  ManageVibration.vibrate();
                },
              ),
              TripOptionWidget(
                imagePath: Assets.locationTripIcon,
                title: context.isArabic ? "وصلني معاك" : "Pick me",
                onTap: () {
                  ManageVibration.vibrate();
                },
                icon: Assets.pickMeImage,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
