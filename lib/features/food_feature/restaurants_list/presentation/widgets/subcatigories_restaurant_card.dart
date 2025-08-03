import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../../common/widgets/dialogs/please_login_dialog.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../../common/widgets/stateless/images/square_image.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/extensions/context_extension.dart';
import '../../../../../core/extensions/numbers_extensions.dart';
import '../../../../../core/extensions/string_extension.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../helpers/manage_vibration.dart';
import '../../../../../helpers/subscription_method.dart';
import '../../../../../res/assets/assets.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../routes/routes.dart';
import '../../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';
import '../../../../social_media/reels/presentation/widgets/comments.dart';
import '../../../../social_media/twitter/presentation/widgets/report_view.dart';
import '../../domain/entities/restaurant.dart';
import '../cubit/restaurants_list_cubit.dart';
import 'Images_profile_for_restaurant.dart';

class CallMessageReportButtons extends StatefulWidget {
  final GetAllRestaurantEntity item;

  const CallMessageReportButtons({super.key, required this.item});

  @override
  State<CallMessageReportButtons> createState() =>
      _CallMessageReportButtonsState();
}

// class EliteBanner extends StatelessWidget {
//   final String subscriptionType;
//
//   const EliteBanner({super.key, required this.subscriptionType});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       decoration: BoxDecoration(
//         color: subscriptionType == 'Premium subscription'
//             ? const Color(0xFFD4AF37)
//             : AppColors.DARK_GRAY_COLOR,
//         borderRadius: const BorderRadius.only(
//           topLeft: Radius.circular(15),
//           topRight: Radius.circular(15),
//         ),
//       ),
//       padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4),
//       child: Row(
//         children: [
//           Icon(
//             Icons.workspace_premium_outlined,
//             size: 55.w,
//             color: subscriptionType == 'Premium subscription'
//                 ? AppColors.SECONDARY_COLOR
//                 : subscriptionType == 'Regular subscription'
//                     ? AppColors.PRIMARY_COLOR
//                     : null,
//           ),
//           const Sizer(),
//           Text(
//             subscriptionType == 'Premium subscription'
//                 ? LocaleKeys.premium.localize
//                 : subscriptionType == 'Regular subscription'
//                     ? LocaleKeys.regular.localize
//                     : LocaleKeys.notSubscribed.localize,
//             textAlign: TextAlign.start,
//             style: const TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class DetailsSection extends StatelessWidget {
  final GetAllRestaurantEntity item;

  final bool myRestaurant;

  const DetailsSection(
      {super.key, required this.item, required this.myRestaurant});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      // height: MediaQuery.sizeOf(context).height * 0.2,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        // mainAxisAlignment: MainAxisAlignment.spaceAround,
        spacing: 6,
        children: [
          const SizedBox(
            height: 8,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                item.name ?? '',
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  "${context.isArabic ? item.subcategoryId?.nameAr : item.subcategoryId?.nameEn ?? ''}",
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          if (!myRestaurant)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Label(
                      text: (context.isArabic
                              ? item.rateName?.ar
                              : item.rateName?.en) ??
                          "N/A",
                      style: Styles.smallText(
                        fontWeight: FontWeight.w600,
                        // fontSize: 16
                      ),
                    ),
                    RatingBar(
                      initialRating: item.totalRating?.toDouble() ?? 0,
                      ignoreGestures: true,
                      allowHalfRating: true,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 3),
                      ratingWidget: RatingWidget(
                        full: SvgPicture.asset(Assets.star1),
                        half: SvgPicture.asset(Assets.halfStar),
                        empty: SvgPicture.asset(
                          Assets.starEmpty,
                          color: context.isDarkMode
                              ? AppColors.whiteColor
                              : AppColors.PRIMARY_COLOR,
                        ),
                      ),
                      itemSize: 13,
                      onRatingUpdate: (double value) {},
                    ),
                  ],
                ),
              ],
            ),
          if (myRestaurant)
            Row(
              // mainAxisAlignment: MainAxisAlignment.end,
              // crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                    textAlign: TextAlign.end,
                    '${context.isArabic ? item.government?.governorateNameAr ?? '' : item.government?.governorateNameEn ?? ''}, ${context.isArabic ? item.city?.cityNameAr : item.city?.cityNameEn ?? ''}',
                    style: Styles.mediumText()),
                const Spacer(),
                const Icon(
                  Icons.star_rounded,
                  color: AppColors.ACCENT_COLOR,
                ),
                const Sizer(),
                Label(
                  text: '${item.totalRating}',
                  style: Styles.mediumText(fontWeight: FontWeight.w500),
                ),
                Label(
                  text: '(${item.numberOfReviews}+)',
                  style: Styles.mediumText(),
                ),
              ],
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (!myRestaurant)
                  Text(
                    (item.isActive ?? false)
                        ? LocaleKeys.available.localize
                        : LocaleKeys.notAvailable.localize,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      color: AppColors.getRedColor(context),
                    ),
                  ),
                Expanded(
                  // <<< حل المشكلة هنا
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Icon(
                        Icons.location_on_rounded,
                        size: 18,
                      ),
                      SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          '${context.isArabic ? item.government?.governorateNameAr ?? '' : item.government?.governorateNameEn ?? ''}, ${context.isArabic ? item.city?.cityNameAr ?? '' : item.city?.cityNameEn ?? ''}'
                              .toArabicNumbers(context),
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
        ],
      ),
    );
  }
}

class FavoriteButton extends StatelessWidget {
  final GetAllRestaurantEntity item;
  final String mealId;
  final Function(String id) favouriteRestaurant;

  const FavoriteButton(
      {super.key,
      required this.item,
      required this.mealId,
      required this.favouriteRestaurant});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.zero,
      icon: Icon(
        (item.isFavorite ?? false) ? Icons.favorite : Icons.favorite_border,
        color: AppColors.SECONDARY_COLOR,
      ),
      onPressed: () async {
        ManageVibration.vibrate();
        await favouriteRestaurant(item.id!);
      },
    );
  }
}

class HorizontalRestaurantCard extends StatelessWidget {
  final GetAllRestaurantEntity? item;

  const HorizontalRestaurantCard({super.key, this.item});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: kToolbarHeight,
          width: kToolbarHeight,
          child: SquareImage(
            radius: 5,
            url: item?.restaurantMedia?.first.mediaKey,
          ),
        ),
        const Sizer(),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Label(
                text: item?.name ?? "",
                style: Styles.mediumText(fontWeight: FontWeight.w400),
              ),
              Row(
                children: [
                  const Icon(
                    Icons.star_rounded,
                    color: AppColors.ACCENT_COLOR,
                  ),
                  const Sizer(),
                  Label(
                    text: '${item?.totalRating} ',
                    style: Styles.mediumText(fontWeight: FontWeight.w500),
                  ),
                  Label(
                    text: '(${item?.numberOfReviews}+)',
                    style: Styles.mediumText(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class PremiumAndRequestButtons extends StatelessWidget {
  final GetAllRestaurantEntity item;

  const PremiumAndRequestButtons({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 0),
      child: _buildButton(
        context,
        label: LocaleKeys.request.localize,
        color: AppColors.getRedColor(context),
        onPressed: () {
          ManageVibration.vibrate();
          context.push(Routes.RESTAURANTDETAILS, extra: item);
        },
      ),
    );
  }

  Widget _buildButton(
    BuildContext context, {
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return AppButton(
      // Removed the Flexible wrapper
      radius: 15,
      height: 60.h,
      padding: 0,
      margin: 0,
      label: label,
      backColor: color,
      style: Styles.mediumText(color: AppColors.getReversedTextColor(context)),
      onPressed: onPressed,
    );
  }
}

class PropertyCard extends StatelessWidget {
  final GetAllRestaurantEntity item;
  final String mealId;
  final bool myRestaurant;
  final Function(String id) favouriteRestaurant;

  const PropertyCard(
      {super.key,
      required this.item,
      required this.mealId,
      required this.favouriteRestaurant,
      required this.myRestaurant});

  @override
  Widget build(BuildContext context) {
    final hasSubscription = item.isPremium;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          width: 1,
          color: context.isDarkMode
              ? AppColors.whiteColor.withOpacity(0.7)
              : AppColors.black.withOpacity(0.7),
        ),
      ),
      child: Column(
        // spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.symmetric(
                vertical: 8, horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  spacing: 4,
                  children: [
                    SvgPicture.asset(
                      Assets.eyeIcon,
                      color: context.isDarkMode
                          ? AppColors.whiteColor
                          : AppColors.PRIMARY_COLOR,
                    ),
                    Label(
                      text: formatViews(item.totalViews!.toInt())
                          .toArabicNumbers(context),
                      style: Styles.mediumText(
                        // fontSize: 12,
                        fontWeight: FontWeight.w400,
                        // color: AppColors.c6C6C6C,
                        color: context.isDarkMode
                            ? AppColors.whiteColor
                            : AppColors.PRIMARY_COLOR,
                      ),
                    ),
                    Label(
                      text: (item.totalViews!.toInt() >= 3 &&
                              item.totalViews!.toInt() <= 9 &&
                              context.isArabic)
                          ? 'مشاهدات'
                          : LocaleKeys.view.localize,
                      style: Styles.mediumText(
                        // fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: context.isDarkMode
                            ? AppColors.whiteColor
                            : AppColors.PRIMARY_COLOR,
                      ),
                    ),
                  ],
                ),
                Label(
                  text: getSubscriptionType(item.subscriptionType?.en),
                  textAlign: TextAlign.right,
                  style: Styles.mediumText(
                    fontWeight: FontWeight.w700,
                    color: context.isDarkMode
                        ? AppColors.whiteColor
                        : AppColors.PRIMARY_COLOR_DARK,
                    // fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          // if (hasSubscription == true)
          //   EliteBanner(subscriptionType: (context.isArabic ? item.subscriptionType?.ar : item.subscriptionType?.en) ?? ''),
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: ImagesProfileForRestaurant(
                  heightCarousel: 150,
                  autoPlay: true,
                  restaurantMedia: item.restaurantMedia,
                ),
              ),
              if (!myRestaurant && context.read<UserCubit>().isLoggedIn)
                Positioned(
                  top: 0,
                  left: 0,
                  child: FavoriteButton(
                    item: item,
                    mealId: mealId,
                    favouriteRestaurant: (String id) => favouriteRestaurant(id),
                  ),
                ),
            ],
          ),
          DetailsSection(
            item: item,
            myRestaurant: myRestaurant,
          ),
          // if (!myRestaurant) const SizedBox(height: 4),
          if (!myRestaurant)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: PremiumAndRequestButtons(item: item),
                ),
                Flexible(
                  child: CallMessageReportButtons(item: item),
                ),
              ],
            )
        ],
      ),
    );
  }

  String formatViews(int views) {
    if (views >= 1000000) {
      return "${(views / 1000000).toStringAsFixed(1)}M";
    } else if (views >= 1000) {
      return "${(views / 1000).toStringAsFixed(1)}K";
    } else {
      return views.toString();
    }
  }

  String getSubscriptionType(String? subscriptionType) {
    final normalizedType = subscriptionType?.trim().toLowerCase();

    // 'Premium subscription': 2
    // 'Regular subscription': 1
    // 'No subscription': 0
    switch (normalizedType) {
      case ('no subscription'):
        return LocaleKeys.notSubscribed.localize;
      case ('premium subscription'):
        return LocaleKeys.premium2.localize;
      case ('regular subscription'):
        return LocaleKeys.regular.localize;
      default:
        return 'N/A';
    }
  }
}

class PropertyCardShimmer extends StatelessWidget {
  const PropertyCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.92,
        height: MediaQuery.of(context).size.width * 1.1,
        child: Card(
          clipBehavior: Clip.hardEdge,
          color: Colors.grey[300],
          elevation: 5,
        ),
      ),
    );
  }
}

class SubCategoriesRestaurantCard extends StatelessWidget {
  final GetAllRestaurantEntity? item;
  final bool isVertical;
  final String mealId;
  final Function(String id) favouriteRestaurant;

  const SubCategoriesRestaurantCard({
    super.key,
    this.isVertical = true,
    this.item,
    required this.mealId,
    required this.favouriteRestaurant,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(Routes.RESTAURANTDETAILS, extra: item),
      child: isVertical
          ? VerticalRestaurantCard(
              item: item,
              mealId: mealId,
              favouriteRestaurant: (String id) => favouriteRestaurant(id),
            )
          : HorizontalRestaurantCard(item: item),
    );
  }
}

class VerticalRestaurantCard extends StatelessWidget {
  final GetAllRestaurantEntity? item;
  final String mealId;
  final Function(String id) favouriteRestaurant;

  const VerticalRestaurantCard(
      {super.key,
      this.item,
      required this.mealId,
      required this.favouriteRestaurant});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.92,
      // height: MediaQuery.of(context).size.height * 0.50,
      child: PropertyCard(
        item: item!,
        mealId: mealId,
        myRestaurant: false,
        favouriteRestaurant: (String id) => favouriteRestaurant(id),
      ),
    );
  }
}

class _CallMessageReportButtonsState extends State<CallMessageReportButtons> {
  final _formKey = GlobalKey<FormState>();

  final FocusNode myFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final isChatEnabled =
        widget.item.enableOrDisableChat?.toLowerCase() == 'enable';
    return Row(
      // spacing: 15,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: IconButton(
            icon: SvgPicture.asset(
              Assets.phoneIconRed,
              width: 22,
              height: 22,
              color: isChatEnabled
                  ? AppColors.getRedColor(context)
                  : AppColors.GREY_DARK_COLOR,
            ),
            color: isChatEnabled
                ? AppColors.PRIMARY_COLOR
                : AppColors.GREY_DARK_COLOR,
            onPressed: context.read<UserCubit>().isLoggedIn
                ? (isChatEnabled
                    ? () {
                        ManageVibration.vibrate();
                        showModalBottomSheet(
                          context: context,
                          backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(16)),
                          ),
                          builder: (_) {
                            return Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                spacing: 10,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: GestureDetector(
                                      onTap: () => Navigator.of(context).pop(),
                                      child: CircleAvatar(
                                        radius: 24.h,
                                        backgroundColor:
                                            AppColors.getFillColor(context),
                                        child: Icon(
                                          Icons.close,
                                          color:
                                              AppColors.getTextColor(context),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Sizer(),
                                  AppButton(
                                    backColor: AppColors.getButtonPrimaryColor(
                                        context),
                                    color:
                                        AppColors.getReversedTextColor(context),
                                    onPressed: () {
                                      ManageVibration.vibrate();
                                      Navigator.pop(context);
                                      // _showFreeCallBottomSheet(context, item);
                                    },
                                    label: LocaleKeys.freeCall.localize,
                                  ),
                                  AppButton(
                                    backColor: AppColors.getFillColor(context),
                                    color: AppColors.getTextColor(context),
                                    onPressed: () {
                                      ManageVibration.vibrate();
                                      Navigator.pop(context);
                                      _showRegularCallBottomSheet(
                                          context, widget.item, myFocusNode);
                                    },
                                    label: LocaleKeys.regularCall.localize,
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }
                    : () {
                        ManageVibration.vibrate();
                        SubscriptionMethod().subscribe(
                          subscribeId: widget.item.subcategoryId?.id ?? '',
                          title: widget.item.name ?? '',
                        );
                      })
                : () {
                    ManageVibration.vibrate();
                    // ScaffoldMessenger.of(context).showSnackBar(
                    //   SnackBar(
                    //     content: Text(
                    //       LocaleKeys.pleaseLoginRegisterToEnjoyTheApp.localize,
                    //       style: Styles
                    //           .mediumText()
                    //           .copyWith(decoration: TextDecoration.none,
                    //       color: AppColors.whiteColor
                    //       ), // ✅ Safe
                    //     ),
                    //     backgroundColor: Colors.red,
                    //     duration: Duration(seconds: 3),
                    //     action: SnackBarAction(
                    //       label: LocaleKeys.login.localize,
                    //       textColor: Colors.white,
                    //       onPressed: () {
                    //         // context.push(Routes.LOGIN);
                    //       },
                    //     ),
                    //   ),
                    // );
                  },

            // onPressed: isChatEnabled
            //     ? () {
            //         showModalBottomSheet(
            //           context: context,
            //           backgroundColor: cardDarkColor(context),
            //           shape: const RoundedRectangleBorder(
            //             borderRadius:
            //                 BorderRadius.vertical(top: Radius.circular(16)),
            //           ),
            //           builder: (_) {
            //             return Padding(
            //               padding: const EdgeInsets.all(16.0),
            //               child: Column(
            //                 spacing: 16,
            //                 mainAxisSize: MainAxisSize.min,
            //                 children: [
            //                   AppButton(
            //                     backColor: AppColors.PRIMARY_COLOR,
            //                     color: AppColors.whiteColor,
            //                     onPressed: () {
            //                       Navigator.pop(context); // Close first sheet
            //                       // _showFreeCallBottomSheet(context, item);
            //                     },
            //                     label: LocaleKeys.freeCall.localize,
            //                   ),
            //                   AppButton(
            //                     backColor: AppColors.cD9D9D9,
            //                     color: AppColors.black,
            //                     onPressed: () {
            //                       Navigator.pop(context); // Close first sheet
            //                       _showRegularCallBottomSheet(
            //                           context, item); // Open second
            //                     },
            //                     label: LocaleKeys.regularCall.localize,
            //                   ),
            //                 ],
            //               ),
            //             );
            //           },
            //         );
            //       }
            //     : () {
            //         SubscriptionMethod().subscribe(
            //           subscribeId: item.subcategoryId?.id ?? '',
            //           title: item.name ?? '',
            //         );
            //       },
          ),
        ),
        Expanded(
          child: IconButton(
            icon: SvgPicture.asset(
              Assets.mailIconRed,
              width: 18,
              height: 18,
              color: isChatEnabled
                  ? AppColors.getRedColor(context)
                  : AppColors.GREY_DARK_COLOR,
            ),
            color: isChatEnabled
                ? AppColors.PRIMARY_COLOR
                : AppColors.GREY_DARK_COLOR,
            onPressed: context.read<UserCubit>().isLoggedIn
                ? (isChatEnabled
                    ? () {
                        ManageVibration.vibrate();
                        BlocProvider.of<RestaurantsCubit>(context)
                            .getExpiredOrders();
                        // Implement message functionality here
                      }
                    : () {
                        ManageVibration.vibrate();
                        SubscriptionMethod().subscribe(
                          subscribeId: widget.item.subcategoryId?.id ?? '',
                          title: widget.item.name ?? '',
                        );
                      })
                : () {
                    ManageVibration.vibrate();
                    return pleaseLoginDialog(context);

                    // ScaffoldMessenger.of(context).showSnackBar(
                    //   SnackBar(
                    //     content: Text(
                    //       LocaleKeys.pleaseLoginRegisterToEnjoyTheApp.localize,
                    //       style: Styles
                    //           .mediumText()
                    //           .copyWith(decoration: TextDecoration.none,
                    //           color: AppColors.whiteColor
                    //       ), // ✅ Safe
                    //     ),
                    //     backgroundColor: Colors.red,
                    //     duration: Duration(seconds: 3),
                    //     action: SnackBarAction(
                    //       label: LocaleKeys.login.localize,
                    //       textColor: Colors.white,
                    //       onPressed: () {
                    //         // context.push(Routes.LOGIN);
                    //       },
                    //     ),
                    //   ),
                    // );
                  },
          ),
        ),
        Expanded(
          child: IconButton(
            icon: SvgPicture.asset(
              Assets.reportRed,
              width: 18,
              height: 18,
              color: isChatEnabled
                  ? AppColors.getRedColor(context)
                  : AppColors.GREY_DARK_COLOR,
            ),
            color: AppColors.getRedColor(context),
            onPressed: () async {
              ManageVibration.vibrate();
              if (!context.read<UserCubit>().isLoggedIn) {
                return pleaseLoginDialog(context);
              } else {
                await showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  builder: (context) {
                    return SizedBox(
                      height: isKeyboardVisible(context) ? 0.8.sh : 0.6.sh,
                      child: ReportView(
                        id: widget.item.id!,
                        categoryId: widget.item.subcategoryId!.id!,
                      ),
                    );
                  },
                );
              }

              // Implement report functionality here
            },
          ),
        )
      ],
    );
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    super.dispose();
  }

  // void _showRegularCallBottomSheet(BuildContext context,
  //     GetAllRestaurantEntity item, FocusNode myFocusNode) {
  //   bool isBookingForAnotherClient = false;
  //   bool hasPhoneError = false;
  //   final TextEditingController phoneController =
  //       TextEditingController(text: item.phone ?? '');

  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     backgroundColor: Theme.of(context).scaffoldBackgroundColor,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
  //     ),
  //     builder: (context) {
  //       return StatefulBuilder(
  //         builder: (context, setState) {
  //           phoneController.addListener(() {
  //             if (hasPhoneError && phoneController.text.isNotEmpty) {
  //               setState(() {
  //                 hasPhoneError = false;
  //               });
  //             }
  //           });

  //           return Padding(
  //             padding: EdgeInsets.only(
  //               left: 16,
  //               right: 16,
  //               bottom: MediaQuery.of(context).viewInsets.bottom + 16,
  //               top: 16,
  //             ),
  //             child: Form(
  //               key: _formKey,
  //               child: Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: [
  //                   CheckboxListTile(
  //                     activeColor: context.isDarkMode
  //                         ? AppColors.whiteColor
  //                         : AppColors.PRIMARY_COLOR,
  //                     contentPadding: EdgeInsets.zero,
  //                     value: isBookingForAnotherClient,
  //                     onChanged: (value) {
  //                       setState(() {
  //                         isBookingForAnotherClient = value!;
  //                         hasPhoneError = false;
  //                         if (isBookingForAnotherClient) {
  //                           phoneController.clear();
  //                         } else {
  //                           phoneController.text = item.phone ?? '';
  //                         }
  //                       });
  //                     },
  //                     title: Text(
  //                       LocaleKeys.imBookingOfAnotherClient.localize,
  //                       style: TextStyle(
  //                         fontWeight: FontWeight.w600,
  //                         fontSize: 16,
  //                         color: AppColors.getTextColor(context),
  //                       ),
  //                       maxLines: 2,
  //                       overflow: TextOverflow.ellipsis,
  //                     ),
  //                     controlAffinity: ListTileControlAffinity.leading,
  //                     dense: true,
  //                     visualDensity:
  //                         VisualDensity(horizontal: -4, vertical: -4),
  //                   ),
  //                   const SizedBox(height: 10),
  //                   TextFormField(
  //                     enabled: isBookingForAnotherClient,
  //                     focusNode: myFocusNode,
  //                     controller: phoneController,
  //                     keyboardType: TextInputType.phone,
  //                     validator: (value) {
  //                       if (value == null || value.isEmpty) {
  //                         return LocaleKeys.please_enter_phone_number.localize;
  //                       }
  //                       final regex = RegExp(r'^(010|011|012|015)\d{8}$');
  //                       if (!regex.hasMatch(value)) {
  //                         return LocaleKeys.invalidPhoneNumber.localize;
  //                       }
  //                       return null;
  //                     },
  //                     style: TextStyle(
  //                       color: AppColors.getTextColor(context),
  //                     ),
  //                     decoration: InputDecoration(
  //                       hintStyle: Styles.mediumText(
  //                           color: AppColors.getTextColor(context)),
  //                       prefixIcon: Padding(
  //                         padding: const EdgeInsets.all(12.0),
  //                         child: SvgPicture.asset(
  //                           color: AppColors.getTextColor(context),
  //                           Assets.phoneIconRed,
  //                           width: 18,
  //                           height: 18,
  //                           fit: BoxFit.contain,
  //                         ),
  //                       ),
  //                       hintText: LocaleKeys.phone.localize,
  //                       errorText: hasPhoneError
  //                           ? LocaleKeys.enterPhoneNumber.localize
  //                           : null,
  //                       filled: true,
  //                       fillColor: AppColors.getFillColor(context),
  //                       border: OutlineInputBorder(
  //                         borderRadius: BorderRadius.circular(12),
  //                         borderSide: BorderSide.none,
  //                       ),
  //                     ),
  //                   ),
  //                   const SizedBox(height: 20),
  //                   SizedBox(
  //                     width: double.infinity,
  //                     child: AppButton(
  //                       backColor: AppColors.getButtonPrimaryColor(context),
  //                       color: AppColors.getReversedTextColor(context),
  //                       label: LocaleKeys.submit.localize,
  //                       onPressed: () {
  //                         if (_formKey.currentState?.validate() ?? false) {
  //                           final enteredNumber = phoneController.text.trim();
  //                           final phoneToDial = isBookingForAnotherClient
  //                               ? enteredNumber
  //                               : item.phone;

  //                           launchUrlString("tel://$phoneToDial");
  //                           Navigator.pop(context);
  //                         }
  //                       },
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           );
  //         },
  //       );
  //     },
  //   );
  // }

  void _showRegularCallBottomSheet(BuildContext context,
      GetAllRestaurantEntity item, FocusNode myFocusNode) {
    bool isBookingForAnotherClient = false;
    bool hasPhoneError = false;
    final TextEditingController phoneController =
        TextEditingController(text: item.phone ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            phoneController.addListener(() {
              if (hasPhoneError && phoneController.text.isNotEmpty) {
                setState(() {
                  hasPhoneError = false;
                });
              }
            });

            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                top: 16,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CheckboxListTile(
                      activeColor: context.isDarkMode
                          ? AppColors.whiteColor
                          : AppColors.PRIMARY_COLOR,
                      contentPadding: EdgeInsets.zero,
                      value: isBookingForAnotherClient,
                      onChanged: (value) {
                        setState(() {
                          isBookingForAnotherClient = value!;
                          hasPhoneError = false;
                          if (isBookingForAnotherClient) {
                            phoneController.clear();
                            // إضافة تأخير بسيط لضمان أن الـ TextFormField أصبح enabled
                            // ثم طلب الفوكس لإظهار الكيبورد
                            Future.delayed(Duration(milliseconds: 100), () {
                              myFocusNode.requestFocus();
                            });
                          } else {
                            phoneController.text = item.phone ?? '';
                            myFocusNode.unfocus(); // إخفاء الكيبورد
                          }
                        });
                      },
                      title: Text(
                        LocaleKeys.imBookingOfAnotherClient.localize,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: AppColors.getTextColor(context),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      controlAffinity: ListTileControlAffinity.leading,
                      dense: true,
                      visualDensity:
                          VisualDensity(horizontal: -4, vertical: -4),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      enabled: isBookingForAnotherClient,
                      focusNode: myFocusNode,
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return LocaleKeys.please_enter_phone_number.localize;
                        }
                        final regex = RegExp(r'^(010|011|012|015)\d{8}$');
                        if (!regex.hasMatch(value)) {
                          return LocaleKeys.invalidPhoneNumber.localize;
                        }
                        return null;
                      },
                      style: TextStyle(
                        color: AppColors.getTextColor(context),
                      ),
                      decoration: InputDecoration(
                        hintStyle: Styles.mediumText(
                            color: AppColors.getTextColor(context)),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: SvgPicture.asset(
                            color: AppColors.getTextColor(context),
                            Assets.phoneIconRed,
                            width: 18,
                            height: 18,
                            fit: BoxFit.contain,
                          ),
                        ),
                        hintText: LocaleKeys.phone.localize,
                        errorText: hasPhoneError
                            ? LocaleKeys.enterPhoneNumber.localize
                            : null,
                        filled: true,
                        fillColor: AppColors.getFillColor(context),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: AppButton(
                        backColor: AppColors.getButtonPrimaryColor(context),
                        color: AppColors.getReversedTextColor(context),
                        label: LocaleKeys.submit.localize,
                        onPressed: () {
                          ManageVibration.vibrate();
                          if (_formKey.currentState?.validate() ?? false) {
                            final enteredNumber = phoneController.text.trim();
                            final phoneToDial = isBookingForAnotherClient
                                ? enteredNumber
                                : item.phone;

                            launchUrlString("tel://$phoneToDial");
                            Navigator.pop(context);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
