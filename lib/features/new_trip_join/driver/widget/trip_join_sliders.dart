import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/carousel_slider.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/features/trip_join/presentation/views/widgets/captain_share_screen.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

class TripJoinSliders extends StatelessWidget {
  const TripJoinSliders({super.key});

  @override
  Widget build(BuildContext context) {
    return CarouselSliderWidget(
        height: 150.h,
        autoPlay: true,
        widgets: [
          ClickableWidget(
            onTap: (){
              ManageVibration.vibrate();
              context.push(Routes.captainShareScreen);
            },
            child: ListView(
                // crossAxisAlignment: CrossAxisAlignment.start,
              children:[
                Text(context.isArabic?"مشاركة كابتن!":"Captain Share!",style:
                TextStyle(
                    color: context.isDarkMode? AppColors.SECONDARY_COLOR :AppColors.PRIMARY_COLOR,
                    fontWeight: FontWeight.w600,
                    fontSize: 30
                ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12,),
                context.isDarkMode?Image.asset(Assets.captainDarkInfoIcon,
                  height: MediaQuery.of(context).size.height*0.2,fit: BoxFit.cover,):SvgPicture.asset(Assets.captainInfoIcon,height: MediaQuery.of(context).size.height*0.2),
                const SizedBox(height: 44,),
                BulletPoint(text: context.isArabic?"وفر المال واحجز مقعدًا واحدًا.":"Save money & Book 1 seat."),
                BulletPoint(text: context.isArabic?"اتجه إلى الوجهة النهائية.":"Heading final destination."),
                BulletPoint(text: context.isArabic?"انتظر اخرين لمشاركة رحلتك مع الكابتن الخاص بك.":"Wait for others to share route seats with your captain."),
              ]
            ),
          ),
          ClickableWidget(
            onTap: (){
              ManageVibration.vibrate();
              context.push(Routes.AVAILABLE_TRIPS);
            },
            child: ListView(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(context.isArabic?"جاي معاك !":"Trip Join!",style:
                TextStyle(
                    color: context.isDarkMode? AppColors.SECONDARY_COLOR :AppColors.PRIMARY_COLOR,
                    fontWeight: FontWeight.w600,
                    fontSize: 30
                ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12,),
                context.isDarkMode?Image.asset(Assets.tripDarkInfoIcon,
                  height: MediaQuery.of(context).size.height*0.25,
                  fit: BoxFit.cover,):SvgPicture.asset(Assets.tripInfoIcon,
                    height: MediaQuery.of(context).size.height*0.25),
                const SizedBox(height: 44,),
                BulletPoint(text: context.isArabic?"انت مالك سيارة.":"You are a car Owner."),
                BulletPoint(text: context.isArabic?"قم بالإعلان عن رحلتك المتكررة يوميًا.":"Advertise your daily repeat trip."),
                BulletPoint(text: context.isArabic?"انتظر حتى يتواصل معك المستخدمون.":"Wait for users to contact you."),
                BulletPoint(text: context.isArabic?"قم بمشاركة رحلتك واحصل على المال.":"Share your trip & gain money."),
              ],
            ),
          ),
          ClickableWidget(
            onTap: (){
              ManageVibration.vibrate();
              context.push(Routes.All_PickMe_View);
            },
            child: ListView(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(context.isArabic?"وصلني معاك !":"Pick me!",style:
                TextStyle(
                    color: context.isDarkMode? AppColors.SECONDARY_COLOR :AppColors.PRIMARY_COLOR,
                    fontWeight: FontWeight.w600,
                    fontSize: 30
                ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12,),
                context.isDarkMode?Image.asset(Assets.pickMeDarkInfoIcon,
                  height: MediaQuery.of(context).size.height*0.25,
                  fit: BoxFit.cover,):Image.asset(Assets.pickMe,
                    height: MediaQuery.of(context).size.height*0.25),

                // Image.asset(Assets.pickMe),
                const SizedBox(height: 44,),
                BulletPoint(text: context.isArabic?"لا يوجد لديك سيارة؟":"Don't have a car?!"),
                BulletPoint(text: context.isArabic?"تعبت من السعر العالي.":"Tired from the expensive price."),
                BulletPoint(text: context.isArabic?"قم بالإعلان عن رحلتك المتكررة يوميًا.":"Advertise your daily repeat trip."),
                BulletPoint(text: context.isArabic?"انتظر حتى يتواصل معك مالك السياره.":"Wait for car Owners to contact you."),
                BulletPoint(text: context.isArabic?"قم بمشاركة رحلتك ووفر المال.":"Share your trip & save money."),
              ],
            ),
          )
        ]
    );
  }


}
