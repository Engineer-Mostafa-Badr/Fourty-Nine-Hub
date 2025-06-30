import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/common/widgets/dialogs/please_login_dialog.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/core/utils/format_numbers.dart';
import 'package:fourtyninehub/features/ads_feature/ads/domain/entities/ad_entity.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/cubit/ads_cubit.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/widgets/marriage_call_message_buttons.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/widgets/premium_request_button.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/widgets/request_button.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/domain/entities/create_ad_entity.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import 'package:fourtyninehub/features/subcategories/presentation/widgets/are_you_sure_delete_ad_widget.dart';
import 'package:fourtyninehub/features/subcategories/presentation/widgets/build_tag_ads_widget.dart';
import 'package:fourtyninehub/features/subcategories/presentation/widgets/image_ads_widget.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';

import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../routes/routes.dart';

class MyAdCard extends StatefulWidget {
  final AdEntity item;

  const MyAdCard({
    super.key,
    required this.item,
    required this.onFav,
    required this.onRemoveFav,
    this.deleteAd,
    this.showSubCategory = false,
  });

  final Function(String) onFav;
  final Function(String) onRemoveFav;
  final Function(String)? deleteAd;
  final bool showSubCategory;

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
      onTap: () {
        if( widget.item.userId!=userId) {
          serviceLocator<AdvertisementCubit>().adViewToAds(widget.item.id);
        }
        context.push(Routes.ADdetails, extra: widget.item.id);
      },
      child: IntrinsicHeight(
        child: Container(
          // width: kToolbarHeight * 2.5,
          // height: 600.h,
          // margin: EdgeInsetsDirectional.all(10.w),
          padding: const EdgeInsetsDirectional.only(bottom: 8),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            // border: Border.all(
            //     color: context.isDarkMode
            //         ? AppColors.LIGHT_COLOR
            //         : AppColors.GREY_DARK_COLOR,
            //     width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (context.read<UserCubit>().isLoggedIn)
                BuildTagAdsWidget(
                    status: widget.item.ownerSubscriptionStatus ?? '',
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
                    setState(() {});
                  },
                  isVerified:  widget.item.user!.isAccountVerified ?? false,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  spacing: 4,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Label(
                      text:
                          '${FormatNumbers().formatNumberByComma(widget.item.price.toString(), isArabic: context.isArabic)} ${context.isArabic ? widget.item.currencyAr : widget.item.currencyEn}',
                      style: Styles.mediumText(
                          fontWeight: FontWeight.bold,
                          color: AppColors.PRIMARY_COLOR),
                      maxLines: 1,
                    ),
                    Label(
                      text: widget.item.title,
                      style: Styles.headerText(
                        fontSize: 32,
                        height: 1.6,
                      ),
                    ),
                    /* Row(
                      children: [
                        Label(
                          text: widget.item.title,
                          style: Styles.headerText(
                            fontSize: 32,
                            height: 1.6,
                          ),
                        ),
                        const Spacer(),
                        SvgPicture.asset(Assets.adsCashIcon),
                        const Sizer(width: 5),
                        Label(
                          text:
                              '${FormatNumbers().formatNumberByComma(widget.item.price.toString(), isArabic: context.isArabic)} ${context.isArabic ? widget.item.currencyAr : widget.item.currencyEn}',
                          style: Styles.mediumText(
                              fontWeight: FontWeight.bold,
                              color: AppColors.SECONDARY_COLOR),
                          maxLines: 1,
                        ),
                      ],
                    ),*/
                    // اذا كان الاعلان من نوع المركبات
                    if (widget.item.mainCategoryId ==
                        '62c8b5889332225799fe3316') ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: widget.item.details
                            .where((e) =>
                                e.propId == '66ec666f12cfcdf9779dfcc5' ||
                                e.propId == '66ec666f12cfcdf9779dfd05' ||
                                e.propId == '66ec666f12cfcdf9779dfcc6')
                            .map((e) {
                          return Row(
                            children: [
                              ImageFromInternet(
                                image: e.image ?? '',
                                width: 24,
                                height: 24,
                                defaultLogo: true,
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              Label(
                                text: context.isArabic
                                    ? e.value.nameAr
                                    : e.value.nameEn,
                                style: Styles.headerText(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w700,
                                  height: 1.60,
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ] else
                      Column(
                        children: widget.item.details
                            .where((e) => e.nameEn == 'experience level')
                            .map((e) {
                          return Row(
                            children: [
                              ImageFromInternet(
                                image: e.image ?? '',
                                width: 30.w,
                                height: 30.h,
                                defaultLogo: true,
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              Label(
                                text: context.isArabic
                                    ? e.value.nameAr
                                    : e.value.nameEn,
                                style: Styles.headerText(
                                  fontSize: 24,
                                  height: 1.60,
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
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
                        if (widget.showSubCategory)
                          Label(
                            text: (context.isArabic
                                    ? widget.item.subCategoryNameAr
                                    : widget.item.subCategoryNameEn) ??
                                'N/A',
                            style: Styles.smallText(
                              color: const Color(0xFFF33D49),
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              height: 1.60,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    userId == widget.item.user?.id
                        ? AppButton(
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
                                      if (widget.deleteAd != null) {
                                        widget.deleteAd!(widget.item.id);
                                      }
                                    },
                                  ));
                            },
                          )
                        : _buildRequestsButton(
                            adId: widget.item.id,
                            userIdOfAd: widget.item.user?.id ?? '',
                            subcategoryId: widget.item.subCategoryId ?? '',
                            phone: widget.item.user?.phone ?? '',
                            subscriptionStatus:
                                widget.item.userSubscriptionStatus ?? '',
                          )
                  ],
                ),
              ),
              /*   if (false)
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
                ),*/
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRequestsButton({
    required String userIdOfAd,
    required String subcategoryId,
    required String phone,
    required String adId,
    required String subscriptionStatus,
  }) {
    return Padding(
      padding: const EdgeInsets.only(
          // left: 16,
          // right: 16,
          // bottom: 32,
          // top: 8,
          ),
      child: Row(
        children: [
          Expanded(
            child: AppButton(
              label: LocaleKeys.request.localize,
              height: 30,
              backColor: AppColors.SECONDARY_COLOR_DARK2,
              onPressed: () async {
                if (!context.read<UserCubit>().isLoggedIn) {
                  return pleaseLoginDialog(context);
                  // context.push(Routes.LOGIN);
                } else {
                  bottomSheet(
                    context: context,
                    widget: BlocProvider(
                      create: (context) => serviceLocator<AdvertisementCubit>(),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(
                            height: 24,
                            width: 24,
                            child: IconButton(
                              iconSize: 20,
                              padding: EdgeInsets.zero,
                              style: IconButton.styleFrom(
                                backgroundColor: const Color(0xffD9D9D9),
                              ),
                              icon: const Icon(
                                Icons.close,
                                color: Colors.black,
                              ),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          PremiumRequestButton(
                            adId: adId,
                            subCategoryId: subcategoryId,
                            subscriptionStatus: subscriptionStatus,
                            dontPop: true,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          RequestButton(
                            adId: adId,
                            subscriptionStatus: subscriptionStatus,
                            dontPop: true,
                            successRequest: () {
                              context.pop();
                              showSuccessMessage(
                                  context,
                                  context.isArabic
                                      ? 'تم ارسال طلب التواصل'
                                      : 'Request Sent Successfully');
                              context.read<AdvertisementCubit>().resetRequest();
                            },
                            errorRequest: (failure) {
                              context.pop();
                              context.pop();
                              showErrorMessage(
                                  context,
                                  getFailureMessage(
                                      failure ?? UnknownFailure(''), context));
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }
              },
              style: Styles.headerText(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: Colors.white,
                height: 1.60,
              ),
            ),
          ),
          SizedBox(
            width: 80.w,
          ),
          Expanded(
            child: MarriageCallMessageButtons(
              otherUserId: userIdOfAd,
              subcategoryId: subcategoryId,
              phone: phone,
              id: adId,
              hasReport: true,
            ),
          ),
        ],
      ),
    );
  }
}
