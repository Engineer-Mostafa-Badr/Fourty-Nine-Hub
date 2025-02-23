import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/carpool/avaliable_routes/presentation/cubits/get_currency/cubit/get_currency_cubit.dart';
import 'package:fourtyninehub/features/carpool/avaliable_routes/presentation/widgets/car_pool_body.dart';
import 'package:fourtyninehub/features/trip_join/view_all_pick_me/presentation/views/all_pickme_view.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/widgets/available_trips_floating_action_button.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/widgets/avilable_trips_body.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

import '../../../../../core/widget/custom_scaffold.dart';

import '../../../../RideFeature/presentation/pages/expired_trips_screen.dart';
import '../../../../RideFeature/presentation/pages/receipt_trip_screen.dart';
import '../../../../RideFeature/presentation/pages/ride_personal_more_info_screen.dart';
import '../../../../RideFeature/presentation/pages/running_trips_screen.dart';
import '../../../presentation/views/widgets/on_boarding_trip.dart';
import '../../../presentation/views/widgets/pick_me_screen.dart';
import '../../../presentation/views/widgets/trip_join_screen.dart';


class AvailableTripsView extends StatefulWidget {
  const AvailableTripsView({
    super.key,
  });

  @override
  State<AvailableTripsView> createState() => _AvailableTripsViewState();
}

class _AvailableTripsViewState extends State<AvailableTripsView> {
  @override
  void initState() {
    BlocProvider.of<GetCurrencyCubit>(context).getCurrencyData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // FirebaseHelper.getToken();
    // FirebaseHelper.setupInteractedMessage();
    return DefaultTabController(
      length: 3,
      child: SafeArea(
        child: CustomScaffold(
          appBar: AppBar(
            titleSpacing: 0,
            centerTitle: false,
            title: Transform(
              transform: Matrix4.translationValues(-0.0, 0.0, 0.0),
              child: Text(
                // LocaleKeys.availableTrips.localize,
                context.isArabic
                    ? "جاي معاك"
                    : "Trip Join",
                style: Styles.headerText(),
              ),
            ),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElevatedButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> RidePersonalMoreInfoScreen()));
              }, child: Text("Move")),
              Center(
                child: Text(
                  // LocaleKeys.availableTrips.localize,
                  context.isArabic
                      ? "رحلات مخفضة - وفر فلوسك وسافر بأسعار أقل"
                      : "Discounted Trips - Save money and travel for less",
                  style: Styles.mediumText(
                    color: AppColors.PRIMARY_COLOR,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              Builder(builder: (context) {
                const double size = 40;
                return TabBar(
                  dividerColor: context.isDarkMode ? Colors.grey : null,
                  indicatorColor: AppColors.PRIMARY_COLOR_DARK,
                  padding: EdgeInsets.zero,
                  labelPadding: EdgeInsets.zero,
                  indicatorPadding: EdgeInsets.zero,
                  tabs: [
                    TripJoinTabIcon(
                      icon: Image.asset(Assets.carpool,
                          width: size.h, height: size.h, fit: BoxFit.fill),
                      // title: LocaleKeys.carpool.localize,
                      title:
                          context.isArabic ? "مشاركة كابتن" : "Captain Share",
                      height: size + 15,
                    ),
                    TripJoinTabIcon(
                      icon: Image.asset(Assets.tripjoin,
                          width: size.h, height: size.h, fit: BoxFit.fill),
                      // title: LocaleKeys.carTrips.localize,
                      title: context.isArabic ? "تعالي اوصلك" : "Trip Join",
                      height: size + 15,
                    ),
                    TripJoinTabIcon(
                      icon: Image.asset(Assets.autoComplete,
                          width: size.h, height: size.h, fit: BoxFit.fill),
                      // title: LocaleKeys.userTrips.localize,
                      title: context.isArabic ? "وصلني معاك" : "Pick Me",
                      height: size + 15,
                    ),
                  ],
                );
              }),
              const Sizer(height: 20),
              const Expanded(
                child: TabBarView(
                  children: [
                     CarPoolBody(),
                    Stack(
                      children: [
                        SizedBox(
                            width: double.infinity, height: double.infinity),
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
            style: Styles.mediumText(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: context.isDarkMode
                    ? Colors.white
                    : AppColors.PRIMARY_COLOR),
          ),
        ],
      ),
    );
  }
}
