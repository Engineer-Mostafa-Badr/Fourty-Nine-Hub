import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/common/functions/helper/lang_helper.dart';
import 'package:fourtyninehub/common/functions/helper/numbers_helper.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/are_you_sure.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/constants/subscription_status.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/utils/format_numbers.dart';
import 'package:fourtyninehub/core/widget/call_message_buttons.dart';
import 'package:fourtyninehub/features/ads_feature/ad_requests/presentation/pages/ad_requests_view.dart';
import 'package:fourtyninehub/features/ads_feature/ads/domain/entities/ad_entity.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/cubit/ads_cubit.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/widgets/premium_request_button.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/widgets/request_button.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/domain/entities/create_ad_entity.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import 'package:fourtyninehub/features/subcategories/presentation/widgets/are_you_sure_delete_ad_widget.dart';
import 'package:fourtyninehub/features/subcategories/presentation/widgets/build_tag_ads_widget.dart';
import 'package:fourtyninehub/features/subcategories/presentation/widgets/image_ads_widget.dart';
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

class MyAdCard extends StatefulWidget {
  final AdEntity item;
  const MyAdCard(
      {super.key,
      required this.item,
      required this.onFav,
      required this.onRemoveFav});
  final Function(String) onFav;
  final Function(String) onRemoveFav;

  @override
  State<MyAdCard> createState() => _MyAdCardState();
}

class _MyAdCardState extends State<MyAdCard> {
  @override
  Widget build(BuildContext context) {
    final userId = serviceLocator<UserCubit>().state.data?.id ?? '';
    print(userId);
    print(widget.item.userId);
    List<CreateAdEntity> details = widget.item.details
        .where((e) => e.value.nameAr != 'السعر' && e.value.nameAr != 'المرتب')
        .toList();
    return InkWell(
      splashColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () => context.push(Routes.ADdetails, extra: widget.item.id),
      child: IntrinsicHeight(
        child: Container(
          // width: kToolbarHeight * 2.5,
          // height: 600.h,
          // margin: EdgeInsetsDirectional.all(10.w),
          padding: EdgeInsetsDirectional.only(bottom: 8),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
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
                BuildTagAdsWidget(
                    status: widget.item.subscriptionStatus ?? '',
                    views: widget.item.views ?? 0),
              Expanded(
                child: ImageAdsWidget(
                  images: widget.item.images,
                  isFavourite: widget.item.isFavourite ?? false,
                  onPressedFavorite: () async {
                    if (widget.item.isFavourite == false) {
                      var result = await widget.onFav(widget.item.id);
                      if (result == true) {
                        widget.item.isFavourite = !widget.item.isFavourite!;
                      }
                    } else {
                      var result = await widget.onRemoveFav(widget.item.id);
                      if (result == true) {
                        widget.item.isFavourite = !widget.item.isFavourite!;
                      }
                    }
                  },
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Label(
                          text: widget.item.title,
                          style: Styles.headerText(
                            fontSize: 32,
                            height: 1.6,
                          ),
                        ),
                        Spacer(),
                        SvgPicture.asset(Assets.adsCashIcon),
                        const Sizer(width: 5),
                        Label(
                          text:
                              '${FormatNumbers().formatNumberByComma(widget.item.price.toString(), isArabic: context.isArabic)} *****',
                          style: Styles.mediumText(
                              fontWeight: FontWeight.bold,
                              color: AppColors.SECONDARY_COLOR),
                          maxLines: 1,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Row(
                      children: [
                        SvgPicture.asset(Assets.adsTimeIcon),
                        const SizedBox(
                          width: 4,
                        ),
                        Label(
                          text: '***** / years',
                          style: Styles.headerText(
                            fontSize: 24,
                            height: 1.60,
                          ),
                          maxLines: 1,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Row(
                      children: [
                        SvgPicture.asset(Assets.adsBagIcon),
                        const SizedBox(
                          width: 4,
                        ),
                        Label(
                          text: '${LocaleKeys.exp.localize}: *****',
                          style: Styles.headerText(
                            fontSize: 24,
                            height: 1.60,
                          ),
                          maxLines: 1,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Row(
                      children: [
                        SvgPicture.asset(Assets.adsLocationIcon),
                        const SizedBox(
                          width: 4,
                        ),
                        Label(
                          text:
                              '${context.isArabic ? widget.item.address?.addressAr : widget.item.address?.addressEn}',
                          style: Styles.headerText(
                            fontSize: 24,
                            height: 1.60,
                          ),
                          maxLines: 1,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    AppButton(
                      label: LocaleKeys.deleteAd.localize,
                      height: 30,
                      style: Styles.headerText(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        height: 1.60,
                      ),
                      onPressed: () {
                        bottomSheet(
                            context: context,
                            isFloating: true,
                            asAlertDialog: true,
                            widget: AreYouSureDeleteAdWidget(
                              title: LocaleKeys.alert.localize,
                              subTitle: LocaleKeys
                                  .areYouSureAboutDeletingTheAD.localize,
                              action: () {
                                // TODO: delete ad
                              },
                            ));
                      },
                    ),
                  ],
                ),
              ),
              if (false)
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
                                  WidgetSpan(
                                      child: Sizer(
                                    width: 5.w,
                                  )),
                                  WidgetSpan(
                                      child: ImageFromInternet(
                                    image: e.image ?? '',
                                    width: 25.w,
                                    height: 25.h,
                                    defaultLogo: true,
                                  )),
                                  WidgetSpan(
                                      child: Sizer(
                                    width: 5.w,
                                  )),
                                  TextSpan(
                                    text:
                                        "${getLang() == 'ar' ? e.value.nameAr : e.value.nameEn}    ",
                                    style: Styles.mediumText(
                                        color: context.isDarkMode
                                            ? AppColors.LIGHT_COLOR
                                            : AppColors.GREY_DARK_COLOR),
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
                      Row(
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
      ),
    );
  }

  Widget _buildRequestsButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 32, top: 8),
      child: Row(
        children: [
          Expanded(
            child: AppButton(
              label: LocaleKeys.deleteRequest.localize,
              height: 38,
              backColor: AppColors.SECONDARY_COLOR_DARK2,
              onPressed: () async {
                // TODO: delete request
              },
              style: Styles.headerText(
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Expanded(
            child: AppButton(
              height: 38,
              backColor: AppColors.c0B1035,
              onPressed: () async {
                context.push(Routes.ADRequests,
                    extra: AdRequestParams(id: widget.item.id, userName: ''));
              },
              label: LocaleKeys.showAdRequests.localize,
              style: Styles.headerText(
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
