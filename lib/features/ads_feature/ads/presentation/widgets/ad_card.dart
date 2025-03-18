import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/functions/helper/lang_helper.dart';
import 'package:fourtyninehub/common/functions/helper/numbers_helper.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/constants/subscription_status.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/call_message_buttons.dart';
import 'package:fourtyninehub/features/ads_feature/ads/domain/entities/ad_entity.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/cubit/ads_cubit.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/widgets/premium_request_button.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/widgets/request_button.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/domain/entities/create_ad_entity.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/widgets/available_trip_button.dart';
import 'package:fourtyninehub/helpers/subscription_method.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/buttons/iconAppButton.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../routes/routes.dart';

class AdCard extends StatefulWidget {
  final AdEntity item;
  const AdCard(
      {super.key,
      required this.item,
      required this.onFav,
      required this.onRemoveFav});
  final Function(String) onFav;
  final Function(String) onRemoveFav;

  @override
  State<AdCard> createState() => _AdCardState();
}

class _AdCardState extends State<AdCard> {
  @override
  Widget build(BuildContext context) {
    final userId = serviceLocator<UserCubit>().state.data?.id ?? '';
    print(userId);
    print(widget.item.userId);
    List<CreateAdEntity> details = widget.item.details
        .where((e) => e.value.nameAr != 'السعر' && e.value.nameAr != 'المرتب')
        .toList();
    return BlocBuilder<AdvertisementCubit, AdsState>(builder: (context, state) {
      return InkWell(
        splashColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () => context.push(Routes.ADdetails, extra: widget.item.id),
        child: Container(
          width: kToolbarHeight * 2.5,
          height: 600.h,
          margin: EdgeInsetsDirectional.all(10.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.r),
            border: Border.all(
                color: context.isDarkMode
                    ? AppColors.LIGHT_COLOR
                    : AppColors.GREY_DARK_COLOR,
                width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (context.read<UserCubit>().isLoggedIn)
                _buildTag(status: widget.item.subscriptionStatus ?? ''),
              Expanded(
                child: Stack(
                  alignment: AlignmentDirectional.topStart,
                  children: [
                    SizedBox(
                      height: kToolbarHeight * 4,
                      width: double.infinity,
                      child: Swiper(
                        itemCount: widget.item.images.length > 4
                            ? 4
                            : widget.item.images.length,
                        onIndexChanged: (i) {},
                        outer: false,
                        loop: false,
                        physics: widget.item.images.length > 1
                            ? null
                            : const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) => Padding(
                          padding: EdgeInsets.only(bottom: 5.h),
                          child: Stack(
                            children: [
                              ImageFromInternet(
                                width: double.infinity,
                                image: widget.item.images[index],
                                defaultLogo: true,
                                fit: BoxFit.cover,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(5.r),
                                    topRight: Radius.circular(5.r)),
                              ),
                              if (index == 3)
                                Positioned.fill(
                                    child: Container(
                                  color: Colors.black.withOpacity(0.8),
                                  alignment: AlignmentDirectional.center,
                                  child: Label(
                                    text: LocaleKeys.seeAll.localize,
                                    style: Styles.headerText(
                                        color: Colors.white,
                                        decoration: TextDecoration.underline),
                                  ),
                                ))
                            ],
                          ),
                        ),
                        pagination: SwiperPagination(builder:
                            SwiperCustomPagination(builder: (context, config) {
                          return const DotSwiperPaginationBuilder(
                                  color: AppColors.GREY_DARK_COLOR,
                                  activeColor: AppColors.SECONDARY_COLOR,
                                  size: 10.0,
                                  activeSize: 10.0)
                              .build(context, config);
                        })),
                      ),
                    ),
                    PositionedDirectional(
                      start: 10.w,
                      child: IconAppButton(
                          size: 18,
                          icon: widget.item.isFavourite == false
                              ? Icons.favorite_border
                              : Icons.favorite,
                          color: AppColors.SECONDARY_COLOR,
                          onPressed: () async {
                            if (widget.item.isFavourite == false) {
                              var result = await widget.onFav(widget.item.id);
                              if (result == true) {
                                widget.item.isFavourite =
                                    !widget.item.isFavourite!;
                              }
                            } else {
                              var result =
                                  await widget.onRemoveFav(widget.item.id);
                              if (result == true) {
                                widget.item.isFavourite =
                                    !widget.item.isFavourite!;
                              }
                            }
                          }),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.symmetric(vertical: 8.0.h, horizontal: 15.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Label(
                                  text:
                                      '${NumbersHelper.formatThousands(number: widget.item.price ?? 0)} ${LocaleKeys.currency.localize}',
                                  style: Styles.mediumText(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.SECONDARY_COLOR),
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                          Sizer(
                            height: 4.h,
                          ),
                          Row(
                            children: [
                              Label(
                                  text: '${LocaleKeys.title.localize} : ',
                                  style: Styles.mediumText(
                                      color: AppColors.SECONDARY_COLOR)),
                              Label(
                                text: widget.item.title,
                                style: Styles.mediumText(
                                  fontWeight: FontWeight.w500,
                                  color: context.isDarkMode
                                      ? AppColors.LIGHT_COLOR
                                      : AppColors.GREY_DARK_COLOR,
                                ),
                                maxLines: 1,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Label(
                                  text: '${LocaleKeys.desc.localize} : ',
                                  style: Styles.mediumText(
                                      color: AppColors.SECONDARY_COLOR)),
                              Expanded(
                                child: Label(
                                  text: widget.item.description,
                                  style: Styles.mediumText(
                                    fontWeight: FontWeight.w500,
                                    color: context.isDarkMode
                                        ? AppColors.LIGHT_COLOR
                                        : AppColors.GREY_DARK_COLOR,
                                  ),
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                          RichText(
                              text: TextSpan(
                                  children: details.map((e) {
                            return TextSpan(
                              children: [
                                TextSpan(
                                  text:
                                      '${getLang() == 'ar' ? e.nameAr : e.nameEn} : ',
                                  style: Styles.mediumText(
                                      color: AppColors.SECONDARY_COLOR),
                                ),
                                WidgetSpan(child: Sizer(width: 5.w,)),
                                WidgetSpan(child: ImageFromInternet(image: e.image??'',width: 25.w,height: 25.h,defaultLogo: true,)),
                                WidgetSpan(child: Sizer(width: 5.w,)),
                                TextSpan(
                                  text:
                                      "${getLang() == 'ar' ? e.value.nameAr : e.value.nameEn}    ",
                                  style: Styles.mediumText(
                                      color: AppColors.GREY_DARK_COLOR),
                                ),
                              ],
                            );
                          }).toList())),
                          Label(
                            text: widget.item.formattedRestTime,
                            style: Styles.mediumText(
                              color: context.isDarkMode
                                  ? AppColors.LIGHT_COLOR
                                  : AppColors.GREY_DARK_COLOR,
                            ),
                            maxLines: 1,
                          ),
                        ]),
                    Divider(
                      color: context.isDarkMode
                          ? AppColors.LIGHT_COLOR
                          : AppColors.GREY_DARK_COLOR,
                    ),
                    const Sizer(),
                    widget.item.userId != userId
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Row(
                                children: [
                                  if(widget.item.userSubscriptionStatus==SubscriptionStatus.notSubscribed.status)AvaialbleTripsButton(
                                    title: LocaleKeys.request.localize,
                                    color:AppColors.SECONDARY_COLOR,
                                    padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                                    onTap: (){
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
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Expanded(
                                                    flex: 3,
                                                    child: PremiumRequestButton(
                                                      adId: widget.item.id,
                                                      subCategoryId:
                                                      widget.item.subCategoryId ?? '',
                                                      subscriptionStatus:
                                                      widget.item.subscriptionStatus ?? '',
                                                    ),
                                                  ),
                                                  const Sizer(width: 5),
                                                  Expanded(
                                                    flex: 3,
                                                    child: RequestButton(
                                                      adId: widget.item.id,
                                                      subscriptionStatus:
                                                      widget.item.subscriptionStatus ?? '',
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },),
                                  Expanded(
                                    child: CallMessageButtons(
                                      otherUserId: widget.item.userId ?? '',
                                      subcategoryId: widget.item.subCategoryId ?? '',
                                      phone: widget.item.phone ?? '',
                                      id: widget.item.id,
                                      hasReport: true, senderName: widget.item.user?.fullName??'',senderImage: widget.item.user?.profilePicture??'',
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        : Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 60.h,
                                  child: AvaialbleTripsButton(
                                    title: LocaleKeys.edit.localize,
                                    color: AppColors.SECONDARY_COLOR,
                                    onTap: () async {},
                                  ),
                                ),
                              ),
                              const Sizer(),
                              Expanded(
                                child: SizedBox(
                                  height: 60.h,
                                  child: AvaialbleTripsButton(
                                    title: LocaleKeys.subscription.localize,
                                    color: AppColors.SECONDARY_COLOR,
                                    onTap: () async {
                                      SubscriptionMethod().subscribe(
                                          subscribeId:
                                              widget.item.subCategoryId ?? '',
                                          title: LocaleKeys.ads.localize);
                                    },
                                  ),
                                ),
                              )
                            ],
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildTag({required String status}) {
    // super premium
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10.w),
      color: status == SubscriptionStatus.premium.status
          ? Colors.amber
          :Colors.grey,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (status !=SubscriptionStatus.notSubscribed.status) ...[
            Icon(
              Icons.workspace_premium_outlined,
              size: 55.w,
              color: status == SubscriptionStatus.premium.status
                  ? AppColors.SECONDARY_COLOR
                  : status == SubscriptionStatus.regular.status
                      ? AppColors.PRIMARY_COLOR
                      : null,
            ),
            const Sizer(width: 5)
          ],
          Label(
            text: status == SubscriptionStatus.premium.status
                ? LocaleKeys.premiumSubscription.localize
                : status == SubscriptionStatus.regular.status
                    ? LocaleKeys.regularRequest.localize
                    : LocaleKeys.notSubscribed.localize,
            style: Styles.mediumText(
                color: Colors.white, fontSize: 35, fontWeight: FontWeight.bold),
            maxLines: 1,
          ),
        ],
      ),
    );
    // premium
    // regular
  }
}
