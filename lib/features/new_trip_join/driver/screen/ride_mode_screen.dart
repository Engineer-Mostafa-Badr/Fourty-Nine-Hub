import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/stateless/appbar/home_appbar.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:go_router/go_router.dart';

import '../../../../res/assets/assets.dart';
import '../../../../routes/routes.dart';
import '../../presentation/view/widget/trip_option_widget.dart';

class RideModeScreen extends StatelessWidget {
  const RideModeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: HomeAppbar(
        isWithBackArrow: false,
        language: true,
        isMenu: true,
        inNotifications: true,
      ),
      body: RideModeBody(),
    );
  }
}

class RideModeBody extends StatelessWidget {
  const RideModeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(15.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20.h),
          RideModeButton(
            onTap: () {
              context.push(Routes.runningAndPastTripsScreen);
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TripOptionWidget(
                imagePath: Assets.locationTripIcon,
                title: context.isArabic ? 'مشاركة كابتن' : 'Captain\nShare',
                onTap: () {
                  context.push(Routes.captainShareScreen);
                },
              ),
              TripOptionWidget(
                icon: Assets.car,
                imagePath: Assets.locationTripIcon,
                title: context.isArabic ? "جاي معاك" : "Trip Join",
                onTap: () {},
              ),
              TripOptionWidget(
                icon: Assets.pickMeIcon,
                imagePath: Assets.locationTripIcon,
                title: context.isArabic ? "وصلني معاك" : "Pick me",
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class RideModeButton extends StatelessWidget {
  final void Function()? onTap;
  const RideModeButton({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(5.w),
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xffF33D49),
              Color(0xffC0303A),
              Color(0xffA72A32),
              Color(0xff9A272E),
              Color(0xff93252C),
              Color(0xff90242B),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15), // حواف دائرية مثل الصورة
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 100,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withAlpha(55),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  context.isArabic ? 'وضع الركوب' : 'Ride Mode',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
