import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fourtyninehub/common/functions/helper/lang_helper.dart';
import 'package:fourtyninehub/common/functions/helper/numbers_helper.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/constants/subscription_status.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/call_message_buttons.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/font_manager.dart';
import 'package:fourtyninehub/features/ads_feature/ad_requests/domain/entities/ad_request_entity.dart';
import 'package:fourtyninehub/features/ads_feature/ads/domain/entities/ad_entity.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/cubit/ads_cubit.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/widgets/premium_request_button.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/widgets/request_button.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/domain/entities/create_ad_entity.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/widgets/available_trip_button.dart';
import 'package:fourtyninehub/helpers/subscription_method.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/buttons/iconAppButton.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../routes/routes.dart';

class AdsRequestLogCard extends StatefulWidget {
  final AdRequestEntity? item;
  const AdsRequestLogCard({
    super.key,
    this.item,
  });

  @override
  State<AdsRequestLogCard> createState() => _AdsRequestLogCardState();
}

class _AdsRequestLogCardState extends State<AdsRequestLogCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(32.w),
      decoration: BoxDecoration(
        color: context.isDarkMode ? AppColors.GREY_DARK_COLOR : AppColors.whiteColor,
        border: Border.all(color: context.isDarkMode ? AppColors.LIGHT_COLOR : AppColors.black.withValues(alpha: 0.7), width: 1),
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 4.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: Row(
                  children: [
                    SvgPicture.asset(
                      Assets.viewsIcon,
                      color: context.isDarkMode ? AppColors.LIGHT_COLOR : null,
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Text(
                      '437K views',
                      style: TextStyle(color: context.isDarkMode ? AppColors.LIGHT_COLOR : AppColors.black, fontSize: FontSize.s12, fontWeight: FontWeight.w400),
                    ),
                  ],
                )),
                SizedBox(
                  width: 10.w,
                ),
                const Label(
                  text: 'Premium',
                  style: TextStyle(color: AppColors.SECONDARY_COLOR, fontSize: FontSize.s16, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          Divider(
            color: context.isDarkMode ? AppColors.LIGHT_COLOR : AppColors.black.withValues(alpha: 0.7),
            thickness: 1,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
            child: Column(
              children: [
                Row(
                  children: [
                    ImageFromInternet(
                      image: 'image',
                      width: 80.w,
                      height: 80.w,
                      isCircle: true,
                    ),
                    SizedBox(
                      width: 16.w,
                    ),
                    Text(
                      'Mona',
                      style: TextStyle(color: context.isDarkMode ? AppColors.whiteColor : AppColors.black, fontSize: FontSize.s18, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8.h,
                ),
                Text(
                  'Figma is a free design tool for teams who build products together. Born on the Web, Figma helps the entire product more the',
                  style: TextStyle(
                    color: context.isDarkMode ? AppColors.whiteColor : AppColors.black,
                    fontSize: FontSize.s12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SvgPicture.asset(Assets.locationIcon,color: context.isDarkMode?AppColors.whiteColor:AppColors.PRIMARY_COLOR,),
                    SizedBox(
                      width: 12.h,
                    ),
                    Text(
                      'Giza , Egypt',
                      style: TextStyle(
                        color: context.isDarkMode ? AppColors.whiteColor : AppColors.black,
                        fontSize: FontSize.s12,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          Divider(
            color: context.isDarkMode ? AppColors.LIGHT_COLOR : AppColors.black.withValues(alpha: 0.7),
            thickness: 1,
          ),
          CallMessageButtons(otherUserId: 'otherUserId', subcategoryId: 'subcategoryId', phone: 'phone', id: 'id',hasReport: true,flex:1)

        ],
      ),
    );
  }
}
