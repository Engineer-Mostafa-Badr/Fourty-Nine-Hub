import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/features/trip_join/view_all_pick_me/presentation/views/all_pickme_view.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/widgets/available_trips_floating_action_button.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/widgets/avilable_trips_body.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

import '../../../../../core/localization/locale_keys.g.dart';

class AvailableTripsView extends StatelessWidget {
  const AvailableTripsView({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    // FirebaseHelper.getToken();
    // FirebaseHelper.setupInteractedMessage();
    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Transform(
              transform: Matrix4.translationValues(-20.0, 0.0, 0.0),
              child: Text(
                LocaleKeys.availableTrips.localize,
                style: Styles.headerText(),
              ),
            ),
          ),
          body: Column(
            children: [
              Builder(builder: (context) {
                const double size = 40;
                return TabBar(
                  dividerColor: context.isDarkMode ? Colors.grey : null,
                  tabs: [
                    TripJoinTabIcon(
                      icon: Image.asset(Assets.tripjoin, width: size.h, height: size.h, fit: BoxFit.fill),
                      title: LocaleKeys.carTrips.localize,
                      height: size + 15,
                    ),
                    TripJoinTabIcon(
                      icon: Image.asset(Assets.autoComplete, width: size.h, height: size.h, fit: BoxFit.fill),
                      title: LocaleKeys.userTrips.localize,
                      height: size + 15,
                    ),
                  ],
                );
              }),
              const Sizer(height: 20),
              const Expanded(
                child: TabBarView(
                  children: [
                    Stack(
                      children: [
                        SizedBox(width: double.infinity, height: double.infinity),
                        AvailableTripsBody(),
                        AvailableTripsFloatingActionButton(),
                      ],
                    ),
                    AllPickMeView(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class TripJoinTabIcon extends StatelessWidget {
  const TripJoinTabIcon({
    super.key,
    required this.icon,
    required this.title,
    required this.height,
    this.spaceBetween = 5,
  });
  final Widget icon;
  final String title;
  final double spaceBetween;
  final double height;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 5.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Tab(
            icon: icon,
            height: height.h,
          ),
          Sizer(width: spaceBetween.w),
          Text(
            title,
            style: Styles.mediumText(color: context.isDarkMode ? Colors.white : AppColors.PRIMARY_COLOR),
          ),
        ],
      ),
    );
  }
}
