import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/call_message_buttons.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/features/ads_feature/ads/data/models/Ad_model.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/cubit/ads_cubit.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/widgets/premium_request_button.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/widgets/request_button.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import 'package:fourtyninehub/features/subcategories/presentation/cubit/subcategories_cubit.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/widgets/available_trip_button.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';

import '../../../../../res/assets/assets.dart';
import '../../../../../res/style/styles.dart';

class MarriageAdsListViewItem extends StatelessWidget {
  const MarriageAdsListViewItem({
    super.key,
    required this.marriageAds,
    required this.state,
  });

  final AdModel marriageAds;
  final SubcategoriesState state;

  @override
  Widget build(BuildContext context) {
    return ClickableWidget(
      onTap: () {
        context.push(Routes.ADdetails, extra: marriageAds.id);
      },
      child: Container(
        // margin: EdgeInsets.only(bottom: 20.h),
        // padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Colors.black.withValues(alpha: 178),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(left: 18, right: 18, top: 8, bottom: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ImageFromInternet(
                        image: marriageAds.images.first,
                        height: 40,
                        width: 40,
                        isCircle: true,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Label(
                        text: marriageAds.title,
                        style: Styles.headerText(
                          height: 1.60,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Label(
                    text: marriageAds.description,
                    style: Styles.mediumText(fontSize: 24, height: 1.40),
                    maxLines: 5,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SvgPicture.asset(Assets.mapPinIcon),
                    const  SizedBox(
                        width: 4,
                      ),
                      Label(
                        text: 'Giza , Egypt',
                        style: Styles.headerText(fontSize: 24, color: Colors.black,),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.black.withValues(alpha: 178),
              height: 0,
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 18, right: 18, top: 4, bottom: 8),
              child: Column(
                children: [
                  Row(
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Expanded(
                      //   flex: 3,
                      //   child: BlocProvider(
                      //     create: (BuildContext context) =>serviceLocator<AdvertisementCubit>(),
                      //     child: PremiumRequestButton(
                      //       adId: controller.marriageAds[index].id,
                      //       subCategoryId:
                      //       controller.marriageAds[index].subCategoryId ?? '',
                      //       subscriptionStatus:
                      //       controller.marriageAds[index].subscriptionStatus ?? '',
                      //     ),
                      //   ),
                      // ),

                      Expanded(
                        child: SizedBox(
                          height: 30,
                          child: AvaialbleTripsButton(
                            title: LocaleKeys.request.localize,
                            color: AppColors.SECONDARY_COLOR_DARK2,
                            radius: 15,
                            // padding: const EdgeInsets.symmetric(
                            //     horizontal: 15, vertical: 5,),
                            onTap: () {
                              showModalBottomSheet(
                                backgroundColor: context.isDarkMode
                                    ? AppColors.DARK_BLUE_COLOR.withOpacity(0.95)
                                    : AppColors.LIGHT_COLOR,
                                context: context,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(32.0),
                                    topRight: Radius.circular(32.0),
                                  ),
                                ),
                                isDismissible: true,
                                isScrollControlled: true,
                                builder: (BuildContext context) {
                                  return BlocProvider.value(
                                    value: serviceLocator<AdvertisementCubit>(),
                                    child: AnimatedPadding(
                                      padding: MediaQuery.of(context).viewInsets,
                                      duration: const Duration(milliseconds: 50),
                                      child: Container(
                                        height: 150.h,
                                        padding: EdgeInsets.symmetric(
                                          vertical: 10.h,
                                          horizontal: 10,
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              flex: 3,
                                              child: PremiumRequestButton(
                                                adId: marriageAds.id,
                                                subCategoryId:
                                                    marriageAds.subCategoryId ?? '',
                                                subscriptionStatus: marriageAds
                                                        .subscriptionStatus ??
                                                    '',
                                              ),
                                            ),
                                            const Sizer(width: 5),
                                            Expanded(
                                              flex: 3,
                                              child: RequestButton(
                                                adId: marriageAds.id,
                                                subscriptionStatus: marriageAds
                                                        .subscriptionStatus ??
                                                    '',
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: CallMessageButtons(
                          otherUserId: marriageAds.userId ?? '',
                          subcategoryId: state
                                  .subCategories?[state.subCategories
                                          ?.indexWhere((element) =>
                                              element.isSelected == true) ??
                                      0]
                                  .id ??
                              '',
                          phone: marriageAds.phone ?? '',
                          id: marriageAds.id,
                          hasReport: true,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
