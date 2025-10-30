import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/core/widget/common/global_card.dart';
import 'package:fourtyninehub/core/widget/common/price_widget.dart';
import '../../../../common/widgets/dialogs/please_login_dialog.dart';
import '../../../../common/widgets/dialogs/show_bottom_sheet.dart';
import '../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../common/widgets/stateless/labels/label.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/extensions/string_extension.dart';
import '../../../../core/localization/locale_keys.g.dart';
import '../../../../core/messages/messages.dart';
import '../../../../core/utils/format_numbers.dart';
import '../../../ads_feature/ads/domain/entities/ad_entity.dart';
import '../../../ads_feature/ads/presentation/cubit/ads_cubit.dart';
import '../../../ads_feature/ads/presentation/widgets/marriage_call_message_buttons.dart';
import '../../../ads_feature/ads/presentation/widgets/premium_request_button.dart';
import '../../../ads_feature/ads/presentation/widgets/request_button.dart';
import '../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';
import '../../../social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import '../widgets/are_you_sure_delete_ad_widget.dart';
import '../widgets/image_ads_widget.dart';
import '../../../../res/assets/assets.dart';
import '../../../../service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';

import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../routes/routes.dart';
import '../../../../common/widgets/dynamic/sizer.dart';
import '../../../../core/constants/subscription_status.dart';
import '../../../social_media/instagram/presentation/widgets/read_more_text.dart';
import '../../../../helpers/manage_vibration.dart';

class MyAdCard extends StatefulWidget {
  final AdEntity item;

  const MyAdCard({
    super.key,
    required this.item,
    required this.onFav,
    required this.onRemoveFav,
    this.deleteAd,
    this.showSubCategory = true,
    this.onRefresh,
  });

  final Function(String) onFav;
  final Function(String) onRemoveFav;
  final Function(String)? deleteAd;
  final bool showSubCategory;
  final VoidCallback? onRefresh;

  @override
  State<MyAdCard> createState() => _MyAdCardState();
}

class _MyAdCardState extends State<MyAdCard> {
  @override
  Widget build(BuildContext context) {
    final userId = serviceLocator<UserCubit>().state.data?.id ?? '';
    print('🔥🔥🔥 MyAdCard Debug 🔥🔥🔥');
    print('Current userId: $userId');
    print('Ad userId: ${widget.item.userId}');
    print('Ad user?.id: ${widget.item.user?.id}');
    print('Is owner: ${userId == widget.item.user?.id}');
    print('userSubscriptionStatus: ${widget.item.userSubscriptionStatus}');
    print('ownerSubscriptionStatus: ${widget.item.ownerSubscriptionStatus}');
    print('🔥🔥🔥 End MyAdCard Debug 🔥🔥🔥');
    return GlobalCard(
      subcategoryId: widget.item.subCategoryId ?? '',
      phone: widget.item.phone ?? "",
      reportId: widget.item.user?.id ?? '',
      otherUserId: '',
      onTap: () async {
        ManageVibration.vibrate();
        if (widget.item.userId != userId) {
          bool result = await serviceLocator<AdvertisementCubit>()
              .adViewToAds(widget.item.id);
          if (result == true) {
            setState(() {
              widget.item.views = (widget.item.views ?? 0) + 1;
            });
            await context.push(Routes.ADdetails, extra: widget.item.id);
          } else {
            await context.push(Routes.ADdetails, extra: widget.item.id);
          }
        } else {
          await context.push(Routes.ADdetails, extra: widget.item.id);
        }

        // Refresh data when returning from ad details view
        if (widget.onRefresh != null) {
          widget.onRefresh!();
        }
      },
      isButtonEnabled: () {
        final isOwner = userId == widget.item.user?.id;
        final result = isOwner
            ? true
            : (SubscriptionStatus.notSubscribed.status !=
                    widget.item.userSubscriptionStatus ||
                SubscriptionStatus.notSubscribed.status !=
                    widget.item.ownerSubscriptionStatus);
        print('isButtonEnabled: $result (isOwner: $isOwner)');
        return result;
      }(),
      isPremium: () {
        final isOwner = userId == widget.item.user?.id;
        final result = isOwner
            ? true
            : (SubscriptionStatus.premium.status ==
                widget.item.ownerSubscriptionStatus);
        print('isPremium: $result (isOwner: $isOwner)');
        return result;
      }(),
      hasReport: true,
      hasTopSide: true,
      hasBottomSide: widget.item.user?.id != userId,
      isView: null,
      subCategoryTitle: context.isArabic
          ? widget.item.subCategoryNameAr
          : widget.item.subCategoryNameEn,
      subscriptionType: () {
        // If current user is the owner, show their subscription status
        if (userId == widget.item.user?.id) {
          return widget.item.userSubscriptionStatus ==
                  SubscriptionStatus.premium.status
              ? LocaleKeys.premium2.localize
              : widget.item.userSubscriptionStatus ==
                      SubscriptionStatus.regular.status
                  ? LocaleKeys.regular.localize
                  : LocaleKeys.notSubscribed.localize;
        }
        // If viewing someone else's ad, show their subscription status
        return widget.item.ownerSubscriptionStatus ==
                SubscriptionStatus.premium.status
            ? LocaleKeys.premium2.localize
            : widget.item.ownerSubscriptionStatus ==
                    SubscriptionStatus.regular.status
                ? LocaleKeys.regular.localize
                : LocaleKeys.notSubscribed.localize;
      }(),
      views: widget.item.views,
      onRequest: () {
        ManageVibration.vibrate();
        if (!context.read<UserCubit>().isLoggedIn) {
          return pleaseLoginDialog(context);
          // context.push(Routes.LOGIN);
        } else {
          bottomSheet(
            context: context,
            backColor: Theme.of(context).scaffoldBackgroundColor,
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
                    adId: widget.item.id,
                    subCategoryId: widget.item.subCategoryId ?? '',
                    subscriptionStatus:
                        widget.item.userSubscriptionStatus ?? '',
                    dontPop: true,
                    onSubscriptionSuccess: () {
                      // إغلاق الديالوج الحالي عند نجاح الاشتراك
                      context.pop();
                    },
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  RequestButton(
                    adId: widget.item.id,
                    subscriptionStatus:
                        widget.item.userSubscriptionStatus ?? '',
                    dontPop: true,
                    successRequest: () {
                      context.pop();
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
      onShowViewers: () {},
      // onSubscribe: (success) {
      //   // context.pop();
      // },
      body: Column(children: [
        ImageAdsWidget(
          isMyAd: widget.item.user?.id == userId,
          images: widget.item.images.isNotEmpty
              ? widget.item.images
              : [Assets.logo],
          isFavourite: widget.item.isFavourite ?? false,
          onPressedFavorite: () async {
            if (widget.item.isFavourite == false) {
              var result = await widget.onFav(widget.item.id);
              if (result == true) {
                setState(() {
                  widget.item.isFavourite = true;
                });
              }
            } else {
              var result = await widget.onRemoveFav(widget.item.id);
              if (result == true) {
                setState(() {
                  widget.item.isFavourite = false;
                });
              }
            }
          },
          isVerified: widget.item.user!.isAccountVerified ?? false,
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min, // ADDED
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (widget.item.price != null && (widget.item.price ?? 0) > 0)
                    PriceWidget(
                      price: widget.item.price ?? 0,
                      currency:
                          '${context.isArabic ? widget.item.currencyAr : widget.item.currencyEn}',
                    ),
                  Sizer(width: 16),
                  if (widget.item.mainCategoryId == '62c8b5849332225799fe3310')
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.getButtonPrimaryColor(context)
                            .withValues(alpha: .7),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Center(
                        child: Label(
                            text:
                                '${context.isArabic ? 'مقدم' : 'Deposit'} ${FormatNumbers().formatNumberByComma(widget.item.price.toString(), isArabic: context.isArabic)} ${context.isArabic ? widget.item.currencyAr : widget.item.currencyEn}',
                            style: Styles.mediumText(
                                color:
                                    AppColors.getReversedTextColor(context))),
                      ),
                    )
                ],
              ),

              // ReadMoreText with proper localization
              ReadMoreText(
                // text:
                //     'floor for rent in shubra floor for rent in shubra floor for rent in shubra floor for rent in shubra floor for rent in shubra',
                text: widget.item.title,
                trimLines: 1,
                style: Styles.headerText(fontWeight: FontWeight.normal),
                moreText: context.isArabic ? "...قراءة المزيد" : '...Read More',
                // FIXED localization
                lessText: context.isArabic
                    ? "قراءة اقل"
                    : 'Read Less', // FIXED localization
                // moreStyle: Styles.smallText(
                //     fontWeight: FontWeight.bold,
                //     color: AppColors.SECONDARY_COLOR),
              ),

              // ... rest of your content (conditionals, buttons, etc.) ...
              Sizer(height: 8),
              if (widget.item.mainCategoryId == '62c8b5849332225799fe3310')
                Row(
                  spacing: 16,
                  children: List.generate(3, (index) {
                    return Row(
                      children: [
                        Image.asset(
                          index == 0
                              ? Assets.bedroomIcon
                              : index == 1
                                  ? Assets.bathroomIcon
                                  : Assets.areaIcon,
                          width: index == 1
                              ? 18
                              : index == 2
                                  ? 20
                                  : 24,
                          color: AppColors.getTextColor(context),
                        ),
                        const Sizer(width: 16),
                        Label(
                          text: index == 0
                              ? '3'
                              : index == 1
                                  ? '4'
                                  : '155',
                          style: Styles.mediumText(
                              fontWeight: FontWeight.bold,
                              color: AppColors.getTextColor(context)),
                        ),
                        const Sizer(width: 12),
                      ],
                    );
                  }),
                ),

              if (widget.item.mainCategoryId == '62c8b5889332225799fe3316')
                Row(
                  spacing: 8,
                  children: List.generate(3, (index) {
                    return Row(
                      children: [
                        Image.asset(
                          index == 0
                              ? Assets.bedroomIcon
                              : index == 1
                                  ? Assets.bathroomIcon
                                  : Assets.areaIcon,
                          height: 24,
                          color: AppColors.getTextColor(context),
                        ),
                        const Sizer(width: 8),
                        Label(
                          text: index == 0
                              ? '3'
                              : index == 1
                                  ? '4'
                                  : '155',
                          style: Styles.mediumText(
                              fontWeight: FontWeight.bold,
                              color: AppColors.getTextColor(context)),
                        ),
                        const Sizer(width: 12),
                      ],
                    );
                  }),
                ),

              if (widget.item.mainCategoryId == '62c8b5889332225799fe3316') ...[
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
                        const SizedBox(width: 4),
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
                        const SizedBox(width: 4),
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
              Sizer(height: 8),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(Assets.adsLocationIcon,
                          color: AppColors.getButtonPrimaryWhiteColor(context)),
                      const SizedBox(width: 4),
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
                  // if (widget.showSubCategory)
                  Label(
                    text: (context.isArabic
                            ? widget.item.subCategoryNameAr
                            : widget.item.subCategoryNameEn) ??
                        'N/A',
                    style: Styles.smallText(
                      color: context.isDarkMode
                          ? AppColors.whiteColor
                          : AppColors.SECONDARY_COLOR,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      height: 1.60,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Label(
                      text: context.isArabic ? 'منذ ٨ ساعات' : '8 hours ago',
                      style: Styles.smallText(
                        color: AppColors.getButtonPrimaryColor(context),
                      )),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
        userId == widget.item.user?.id
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: AppButton(
                  label: LocaleKeys.deleteAd.localize,
                  height: 30,
                  style: Styles.headerText(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    height: 1.60,
                  ),
                  onPressed: () {
                    ManageVibration.vibrate();
                    bottomSheet(
                        context: context,
                        isFloating: true,
                        asAlertDialog: true,
                        widget: AreYouSureDeleteAdWidget(
                          title: LocaleKeys.alert.localize,
                          subTitle:
                              LocaleKeys.areYouSureAboutDeletingTheAD.localize,
                          action: () {
                            print("widget.deleteAd ${widget.item.id}");
                            if (widget.deleteAd != null) {
                              widget.deleteAd!(widget.item.id);
                            }
                          },
                        ));
                  },
                ),
              )
            : SizedBox.shrink()
      ]),
    );
    // return Column(
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: [
    //     InkWell(
    //       splashColor: Colors.transparent,
    //       hoverColor: Colors.transparent,
    //       highlightColor: Colors.transparent,
    //       onTap: () {
    //         ManageVibration.vibrate();
    //         if (widget.item.userId != userId) {
    //           serviceLocator<AdvertisementCubit>().adViewToAds(widget.item.id);
    //         }
    //         context.push(Routes.ADdetails, extra: widget.item.id);
    //       },
    //       child: Container(
    //         // REMOVED IntrinsicHeight and Column wrapper
    //         padding: const EdgeInsetsDirectional.only(bottom: 8),
    //         clipBehavior: Clip.antiAlias,
    //         decoration: BoxDecoration(
    //           borderRadius: BorderRadius.circular(15),
    //           border: Border.all(
    //             color: context.isDarkMode
    //                 ? AppColors.LIGHT_COLOR
    //                 : AppColors.GREY_DARK_COLOR,
    //             width: 1,
    //           ),
    //         ),
    //         child: Column(
    //           mainAxisSize: MainAxisSize.min,
    //           // ADDED to prevent unbounded height
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             if (context.read<UserCubit>().isLoggedIn)
    //               BuildTagAdsWidget(
    //                   status: widget.item.ownerSubscriptionStatus ?? '',
    //                   views: widget.item.views ?? 0),
    //
    //             // Fixed height for image
    //             ImageAdsWidget(
    //               // images: widget.item.images,
    //               isMyAd:widget.item.user?.id == userId,
    //               images: widget.item.images.isNotEmpty ? widget.item.images : [Assets.logo],
    //               isFavourite: widget.item.isFavourite ?? false,
    //               onPressedFavorite: () async {
    //                 if (widget.item.isFavourite == false) {
    //                   var result = await widget.onFav(widget.item.id);
    //                   if (result == true) {
    //                     setState(() {
    //                       widget.item.isFavourite = !widget.item.isFavourite!;
    //                     });
    //                   }
    //                 } else {
    //                   var result = await widget.onRemoveFav(widget.item.id);
    //                   if (result == true) {
    //                     setState(() {
    //                       widget.item.isFavourite = !widget.item.isFavourite!;
    //                     });
    //                   }
    //                 }
    //               },
    //               isVerified: widget.item.user!.isAccountVerified ?? false,
    //             ),
    //
    //             const SizedBox(height: 8),
    //             Padding(
    //               padding: const EdgeInsets.symmetric(horizontal: 16),
    //               child: Column(
    //                 mainAxisSize: MainAxisSize.min, // ADDED
    //                 crossAxisAlignment: CrossAxisAlignment.start,
    //                 children: [
    //                   Row(
    //                     children: [
    //                       Label(
    //                         text:
    //                             '${FormatNumbers().formatNumberByComma(widget.item.price.toString(), isArabic: context.isArabic)} ${context.isArabic ? widget.item.currencyAr : widget.item.currencyEn}',
    //                         style: Styles.headerText(
    //                             fontSize: 50,
    //                             fontWeight: FontWeight.bold,
    //                             color: context.isDarkMode
    //                                 ? AppColors.whiteColor
    //                                 : AppColors.SECONDARY_COLOR),
    //                         maxLines: 1,
    //                       ),
    //                       Sizer(width: 16),
    //                       if (widget.item.mainCategoryId ==
    //                           '62c8b5849332225799fe3310')
    //                         Container(
    //                           padding: const EdgeInsets.symmetric(
    //                               horizontal: 8, vertical: 4),
    //                           decoration: BoxDecoration(
    //                             color: AppColors.getButtonPrimaryColor(context)
    //                                 .withValues(alpha: .7),
    //                             borderRadius: BorderRadius.circular(6),
    //                           ),
    //                           child: Center(
    //                             child: Label(
    //                                 text:
    //                                     '${context.isArabic ? 'مقدم' : 'Deposit'} ${FormatNumbers().formatNumberByComma(widget.item.price.toString(), isArabic: context.isArabic)} ${context.isArabic ? widget.item.currencyAr : widget.item.currencyEn}',
    //                                 style: Styles.mediumText(
    //                                     color: AppColors.getReversedTextColor(
    //                                         context))),
    //                           ),
    //                         )
    //                     ],
    //                   ),
    //
    //                   // ReadMoreText with proper localization
    //                   ReadMoreText(
    //                     // text:
    //                     //     'floor for rent in shubra floor for rent in shubra floor for rent in shubra floor for rent in shubra floor for rent in shubra',
    //                     text: widget.item.title,
    //                     trimLines: 1,
    //                     style: Styles.headerText(fontWeight: FontWeight.normal),
    //                     moreText: context.isArabic
    //                         ? "...قراءة المزيد"
    //                         : '...Read More',
    //                     // FIXED localization
    //                     lessText: context.isArabic
    //                         ? "قراءة اقل"
    //                         : 'Read Less', // FIXED localization
    //                     // moreStyle: Styles.smallText(
    //                     //     fontWeight: FontWeight.bold,
    //                     //     color: AppColors.SECONDARY_COLOR),
    //                   ),
    //
    //                   // ... rest of your content (conditionals, buttons, etc.) ...
    //                   Sizer(height: 8),
    //                   if (widget.item.mainCategoryId ==
    //                       '62c8b5849332225799fe3310')
    //                     Row(
    //                       spacing: 16,
    //                       children: List.generate(3, (index) {
    //                         return Row(
    //                           children: [
    //                             Image.asset(
    //                               index == 0
    //                                   ? Assets.bedroomIcon
    //                                   : index == 1
    //                                       ? Assets.bathroomIcon
    //                                       : Assets.areaIcon,
    //                               width: index == 1
    //                                   ? 18
    //                                   : index == 2
    //                                       ? 20
    //                                       : 24,
    //                               color: AppColors.getTextColor(context),
    //                             ),
    //                             const Sizer(width: 16),
    //                             Label(
    //                               text: index == 0
    //                                   ? '3'
    //                                   : index == 1
    //                                       ? '4'
    //                                       : '155',
    //                               style: Styles.mediumText(
    //                                   fontWeight: FontWeight.bold,
    //                                   color: AppColors.getTextColor(context)),
    //                             ),
    //                             const Sizer(width: 12),
    //                           ],
    //                         );
    //                       }),
    //                     ),
    //
    //                   if (widget.item.mainCategoryId ==
    //                       '62c8b5889332225799fe3316')
    //                     Row(
    //                       spacing: 8,
    //                       children: List.generate(3, (index) {
    //                         return Row(
    //                           children: [
    //                             Image.asset(
    //                               index == 0
    //                                   ? Assets.bedroomIcon
    //                                   : index == 1
    //                                       ? Assets.bathroomIcon
    //                                       : Assets.areaIcon,
    //                               height: 24,
    //                               color: AppColors.getTextColor(context),
    //                             ),
    //                             const Sizer(width: 8),
    //                             Label(
    //                               text: index == 0
    //                                   ? '3'
    //                                   : index == 1
    //                                       ? '4'
    //                                       : '155',
    //                               style: Styles.mediumText(
    //                                   fontWeight: FontWeight.bold,
    //                                   color: AppColors.getTextColor(context)),
    //                             ),
    //                             const Sizer(width: 12),
    //                           ],
    //                         );
    //                       }),
    //                     ),
    //
    //                   if (widget.item.mainCategoryId ==
    //                       '62c8b5889332225799fe3316') ...[
    //                     Row(
    //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                       children: widget.item.details
    //                           .where((e) =>
    //                               e.propId == '66ec666f12cfcdf9779dfcc5' ||
    //                               e.propId == '66ec666f12cfcdf9779dfd05' ||
    //                               e.propId == '66ec666f12cfcdf9779dfcc6')
    //                           .map((e) {
    //                         return Row(
    //                           children: [
    //                             ImageFromInternet(
    //                               image: e.image ?? '',
    //                               width: 24,
    //                               height: 24,
    //                               defaultLogo: true,
    //                             ),
    //                             const SizedBox(width: 4),
    //                             Label(
    //                               text: context.isArabic
    //                                   ? e.value.nameAr
    //                                   : e.value.nameEn,
    //                               style: Styles.headerText(
    //                                 fontSize: 28,
    //                                 fontWeight: FontWeight.w700,
    //                                 height: 1.60,
    //                               ),
    //                             ),
    //                           ],
    //                         );
    //                       }).toList(),
    //                     ),
    //                   ] else
    //                     Column(
    //                       children: widget.item.details
    //                           .where((e) => e.nameEn == 'experience level')
    //                           .map((e) {
    //                         return Row(
    //                           children: [
    //                             ImageFromInternet(
    //                               image: e.image ?? '',
    //                               width: 30.w,
    //                               height: 30.h,
    //                               defaultLogo: true,
    //                             ),
    //                             const SizedBox(width: 4),
    //                             Label(
    //                               text: context.isArabic
    //                                   ? e.value.nameAr
    //                                   : e.value.nameEn,
    //                               style: Styles.headerText(
    //                                 fontSize: 24,
    //                                 height: 1.60,
    //                               ),
    //                             ),
    //                           ],
    //                         );
    //                       }).toList(),
    //                     ),
    //                   Sizer(height: 8),
    //
    //                   Row(
    //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                     children: [
    //                       Row(
    //                         children: [
    //                           SvgPicture.asset(Assets.adsLocationIcon,
    //                               color: AppColors.getButtonPrimaryWhiteColor(
    //                                   context)),
    //                           const SizedBox(width: 4),
    //                           Label(
    //                             text:
    //                                 '${context.isArabic ? widget.item.address?.addressAr : widget.item.address?.addressEn}',
    //                             style: Styles.headerText(
    //                               fontSize: 24,
    //                               height: 1.60,
    //                             ),
    //                             maxLines: 1,
    //                           ),
    //                         ],
    //                       ),
    //                       // if (widget.showSubCategory)
    //                       Label(
    //                         text: (context.isArabic
    //                                 ? widget.item.subCategoryNameAr
    //                                 : widget.item.subCategoryNameEn) ??
    //                             'N/A',
    //                         style: Styles.smallText(
    //                           color: context.isDarkMode
    //                               ? AppColors.whiteColor
    //                               : AppColors.SECONDARY_COLOR,
    //                           fontSize: 24,
    //                           fontWeight: FontWeight.w700,
    //                           height: 1.60,
    //                         ),
    //                       ),
    //                     ],
    //                   ),
    //                   Row(
    //                     mainAxisAlignment: MainAxisAlignment.end,
    //                     children: [
    //                       Label(
    //                           text: context.isArabic
    //                               ? 'منذ ٨ ساعات'
    //                               : '8 hours ago',
    //                           style: Styles.smallText(
    //                             color: AppColors.getButtonPrimaryColor(context),
    //                           )),
    //                     ],
    //                   ),
    //                   const SizedBox(height: 8),
    //
    //                   userId == widget.item.user?.id
    //                       ? AppButton(
    //                           label: LocaleKeys.deleteAd.localize,
    //                           height: 30,
    //                           style: Styles.headerText(
    //                             fontSize: 24,
    //                             color: Colors.white,
    //                             fontWeight: FontWeight.w500,
    //                             height: 1.60,
    //                           ),
    //                           onPressed: () {
    //                             ManageVibration.vibrate();
    //                             bottomSheet(
    //                                 context: context,
    //                                 isFloating: true,
    //                                 asAlertDialog: true,
    //                                 widget: AreYouSureDeleteAdWidget(
    //                                   title: LocaleKeys.alert.localize,
    //                                   subTitle: LocaleKeys
    //                                       .areYouSureAboutDeletingTheAD
    //                                       .localize,
    //                                   action: () {
    //                                     if (widget.deleteAd != null) {
    //                                       widget.deleteAd!(widget.item.id);
    //                                     }
    //                                   },
    //                                 ));
    //                           },
    //                         )
    //                       : _buildRequestsButton(
    //                           adId: widget.item.id,
    //                           userIdOfAd: widget.item.user?.id ?? '',
    //                           subcategoryId: widget.item.subCategoryId ?? '',
    //                           phone: widget.item.user?.phone ?? '',
    //                           subscriptionStatus:
    //                               widget.item.userSubscriptionStatus ?? '',
    //                         ),
    //                 ],
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ),
    //     // Subscription message at the bottom
    //     if (SubscriptionStatus.notSubscribed.status ==
    //             widget.item.userSubscriptionStatus &&
    //         SubscriptionStatus.notSubscribed.status ==
    //             widget.item.ownerSubscriptionStatus)
    //       if (userId != widget.item.user?.id)
    //         Padding(
    //           padding: const EdgeInsetsDirectional.only(start: 10.0, top: 8),
    //           child: Label(
    //             text: LocaleKeys.pleaseSubscribeToContactTheClient.localize,
    //             style: Styles.headerText(
    //               fontSize: 28,
    //               color: AppColors.getRedColor(context),
    //               height: 1.57,
    //             ),
    //           ),
    //         ),
    //   ],
    // );
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
                ManageVibration.vibrate();
                if (!context.read<UserCubit>().isLoggedIn) {
                  return pleaseLoginDialog(context);
                  // context.push(Routes.LOGIN);
                } else {
                  bottomSheet(
                    context: context,
                    backColor: Theme.of(context).scaffoldBackgroundColor,
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
            width: 32,
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
