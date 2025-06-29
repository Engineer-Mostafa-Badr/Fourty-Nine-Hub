import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/utils/format_numbers.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/widgets/cards/health_card_bottom_section.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/widgets/cards/health_custom_card.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:fourtyninehub/core/widget/custom_circular_progress_indicator.dart';

import '../../../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../../../helpers/subscription_method.dart';
import '../../../../../food_feature/food_cart/presentation/pages/cart_view.dart';
import '../../../../../social_media/instagram/presentation/widgets/comment_widget_insta.dart';
import '../../../../../social_media/twitter/presentation/widgets/report_view.dart';
import '../../../domain/entities/most_booking_entity.dart';
import '../../controllers/health_cubit/health_cubit.dart';

class DoctorsListView extends StatefulWidget {
  const DoctorsListView({super.key, this.onClose});
  final VoidCallback? onClose;

  @override
  State<DoctorsListView> createState() => _DoctorsListViewState();
}

class _DoctorsListViewState extends State<DoctorsListView> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<HealthCubit>().getMostBookings();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HealthCubit, HealthState>(
      builder: (context, state) {
        final cubit = context.read<HealthCubit>();

        if (state.status == HealthStates.loading) {
          return const Center(child: CustomCircularProgressIndicator());
        }
        if (cubit.mostBooking.isEmpty) {
          return Center(
            child: Text(
              context.isArabic ? 'لا يوجد حجوزات سابقة' : 'No booking history',
              style: Styles.headerText(
                fontWeight: FontWeight.w600,
                color: AppColors.grey,
              ),
            ),
          );
        }
        return SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Expanded(
                child: cubit.mostBooking.isEmpty
                    ? Center(
                        child: Text(
                          context.isArabic
                              ? 'لا يوجد حجوزات سابقة'
                              : 'No booking history',
                          style: Styles.headerText(
                            fontWeight: FontWeight.w600,
                            color: AppColors.grey,
                          ),
                        ),
                      )
                    : ListView.separated(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.sizeOf(context).height * 0.35),
                        controller: _scrollController,
                        itemCount: cubit.mostBooking.length,
                        itemBuilder: (context, index) {
                          final booking = cubit.mostBooking[index];
                          return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: DoctorListCard(
                              data: booking,
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => const Sizer(),
                      ),
              ),
              if (state.isLoadingMoreMostBooking ?? false)
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CustomCircularProgressIndicator(),
                ),
            ],
          ),
        );
      },
    );
  }
}

class DoctorListCard extends StatefulWidget {
  const DoctorListCard({
    super.key,
    required this.data,
  });

  final MostBookingEntity data;

  @override
  State<DoctorListCard> createState() => _DoctorListCardState();
}

class _DoctorListCardState extends State<DoctorListCard> {
  String formatViews(int views) {
    // if (views >= 1000000) {
    //   return "${(views / 1000000).toStringAsFixed(1)}M";
    // } else if (views >= 1000) {
    //   return "${(views / 1000).toStringAsFixed(1)}K";
    // } else {
    //   return views.toString();
    // }

    return FormatNumbers()
        .formatNumber(views, useArabicNumerals: context.isArabic);
  }

  String getSubscriptionType(int subscriptionRank) {
    // 'Premium subscription': 2
    // 'Regular subscription': 1
    // 'No subscription': 0
    switch (subscriptionRank) {
      case 0:
        return LocaleKeys.noSubscription.localize;
      case 1:
        return LocaleKeys.regularSubscription.localize;
      case 2:
        return LocaleKeys.premium2.localize;
      default:
        return 'N/A';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 10.h,
      ),
      child: Container(
        // padding:const EdgeInsets.all(10) ,
        decoration: BoxDecoration(
            border:
                Border.all(color: AppColors.black.withOpacity(0.7), width: 1),
            borderRadius: BorderRadius.circular(15)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.symmetric(
                  vertical: 8, horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    spacing: 2,
                    children: [
                      SvgPicture.asset(
                        Assets.viewCountIcon,
                        color: Colors.grey,
                      ),
                      if ((widget.data.viewCount ?? 0) == 0) ...[
                        Label(
                          text: LocaleKeys.noViews.localize,
                          style: Styles.mediumText(
                              // fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: context.isDarkMode
                                  ? AppColors.whiteColor
                                  : AppColors.c6C6C6C),
                        ),
                      ] else if (widget.data.viewCount == 1) ...[
                        // Label(
                        //     text:
                        //         ' ${formatViews(widget.data.viewCount?.toInt() ?? 0)} ',
                        //     style: Styles.mediumText(
                        //       color: context.isDarkMode
                        //           ? Colors.white
                        //           : AppColors.c6C6C6C,
                        //       // fontSize: 12
                        //     )),
                        Label(
                          text: LocaleKeys.oneView.localize,
                          style: Styles.mediumText(
                              // fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: context.isDarkMode
                                  ? AppColors.whiteColor
                                  : AppColors.c6C6C6C),
                        ),
                      ] else if (widget.data.viewCount == 2) ...[
                        // Label(
                        //     text:
                        //         ' ${formatViews(widget.data.viewCount?.toInt() ?? 0)} ',
                        //     style: Styles.mediumText(
                        //       color: context.isDarkMode
                        //           ? Colors.white
                        //           : AppColors.c6C6C6C,
                        //       // fontSize: 12
                        //     )),
                        Label(
                          text: LocaleKeys.twoViews.localize,
                          style: Styles.mediumText(
                              // fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: context.isDarkMode
                                  ? AppColors.whiteColor
                                  : AppColors.c6C6C6C),
                        ),
                      ] else if (widget.data.viewCount! >= 3 &&
                          widget.data.viewCount! <= 10) ...[
                        Label(
                            text:
                                ' ${FormatNumbers().formatNumber(widget.data.viewCount ?? 0, useArabicNumerals: context.isArabic)} ',
                            // ' ${formatViews(widget.data.viewCount ?? 0)} ',
                            style: Styles.mediumText(
                              color: context.isDarkMode
                                  ? Colors.white
                                  : AppColors.c6C6C6C,
                              // fontSize: 12
                            )),
                        Label(
                          text: LocaleKeys.views.localize,
                          style: Styles.mediumText(
                              // fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: context.isDarkMode
                                  ? AppColors.whiteColor
                                  : AppColors.c6C6C6C),
                        ),
                      ] else ...[
                        Label(
                            text:
                                ' ${FormatNumbers().formatNumber(widget.data.viewCount ?? 0, useArabicNumerals: context.isArabic)} ',
                            // ' ${formatViews(widget.data.viewCount?.toInt() ?? 0)} ',
                            style: Styles.mediumText(
                              color: context.isDarkMode
                                  ? Colors.white
                                  : AppColors.c6C6C6C,
                              // fontSize: 12
                            )),
                        Label(
                          text: context.isArabic ? 'مشاهدة' : 'Views',
                          style: Styles.mediumText(
                              // fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: context.isDarkMode
                                  ? AppColors.whiteColor
                                  : AppColors.c6C6C6C),
                        ),
                      ],
                      // Label(
                      //   text: formatViews(widget.data.viewCount?.toInt() ?? 0),
                      //   style: Styles.smallText(
                      //     fontWeight: FontWeight.w400,
                      //     color: AppColors.c6C6C6C,
                      //     fontSize: 12,
                      //   ),
                      // ),
                      // Label(
                      //   text: LocaleKeys.views.localize,
                      //   style: const TextStyle(
                      //       fontSize: 12,
                      //       fontWeight: FontWeight.w400,
                      //       color: AppColors.c6C6C6C),
                      // ),
                    ],
                  ),
                  Label(
                    text:
                        getSubscriptionType(widget.data.subscriptionRank ?? 0),
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                        color: AppColors.PRIMARY_COLOR_DARK,
                        fontWeight: FontWeight.w700,
                        fontSize: 16),
                  ),
                ],
              ),
            ),
            const Divider(
              height: 1,
            ),
            const SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                spacing: 8,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(
                              widget.data.profilePicture ?? '',
                              width: 56,
                              height: 56,
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Container(
                                  width: 56,
                                  height: 56,
                                  alignment: Alignment.center,
                                  child: const CustomCircularProgressIndicator(
                                      strokeWidth: 2),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 56,
                                  height: 56,
                                  color: Colors.grey[300],
                                  alignment: Alignment.center,
                                  child: const Icon(Icons.error,
                                      color: Colors.red, size: 24),
                                );
                              },
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: -6,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.cF5F5F5,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.star,
                                      color: Colors.amber, size: 12),
                                  const SizedBox(width: 2),
                                  Text(
                                    "${widget.data.averageRating ?? 0}",
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                          width: 8), // spacing between image and text
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${widget.data.firstName ?? "N/A"} ${widget.data.lastName ?? ""}",
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              context.isArabic
                                  ? widget.data.subCategory?.first.nameAr ??
                                      "N/A"
                                  : widget.data.subCategory?.first.nameEn ??
                                      "N/A",
                              style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    spacing: 8,
                    children: [
                      Icon(
                        Icons.location_on_rounded,
                        color: context.isDarkMode
                            ? AppColors.PRIMARY_COLOR_DARK
                            : AppColors.PRIMARY_COLOR,
                      ),
                      Expanded(
                        child: Label(
                          text: context.isArabic
                              ? "${widget.data.address?.governorate?.governorateNameAr ?? "N/A"} , ${widget.data.address?.city?.cityNameAr ?? "N/A"}"
                              : "${widget.data.address?.governorate?.governorateNameEn ?? "N/A"} , ${widget.data.address?.city?.cityNameEn ?? "N/A"}",
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SvgPicture.asset(
                        Assets.cash,
                        fit: BoxFit.cover,
                        height: 48.h,
                        width: 48.h,
                      ),
                      const Sizer(),
                      Expanded(
                        child: Label(
                          text: context.isArabic ? 'خدمة' : 'Fees',
                          style: Styles.mediumText(fontWeight: FontWeight.w500),
                        ),
                      ),
                      Label(
                        text: '${widget.data.price}',
                        style: Styles.mediumText(fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                  // if(widget.data.isPremium == true)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.watch_later_outlined,
                              color: AppColors.black, size: 48.h),
                          const Sizer(),
                          Label(
                            text:
                                '${context.isArabic ? 'وقت الانتظار' : 'Waiting time'}: ${context.isArabic ? widget.data.waitingTimeAr : widget.data.waitingTimeEn}',
                            style:
                                Styles.mediumText(fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                      Label(
                        text:
                            '${FormatNumbers().formatNumber(widget.data.bookingCount ?? 0, useArabicNumerals: context.isArabic)}/${LocaleKeys.book.localize}',
                        style: Styles.mediumText(
                            fontWeight: FontWeight.w500,
                            color: AppColors.PRIMARY_COLOR_DARK),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                          width: 180,
                          child: PremiumAndRequestButtons(item: widget.data)),
                      CallMessageReportButtons(item: widget.data),
                    ],
                  ),
                  // HealthCardButtonsSection(
                  //   isButton: true,
                  //   isSubscribed: widget.data.isPremium == true,
                  //   buttonTitle: '${LocaleKeys.book.localize}',
                  //   onTap: () {},
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PremiumAndRequestButtons extends StatelessWidget {
  final MostBookingEntity item;

  const PremiumAndRequestButtons({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 0),
      child: Row(
        children: [
          _buildButton(
            label: LocaleKeys.book.localize,
            color: AppColors.PRIMARY_COLOR_DARK,
            onPressed: () {
              // context.push(Routes.RESTAURANTDETAILS, extra: item);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Flexible(
      child: AppButton(
        radius: 15,
        height: 35,
        padding: 0,
        margin: 0,
        label: label,
        backColor: color,
        style: Styles.mediumText(color: Colors.white),
        onPressed: onPressed,
      ),
    );
  }
}

class CallMessageReportButtons extends StatelessWidget {
  final MostBookingEntity item;

  const CallMessageReportButtons({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final isChatEnabled = item.isPremium;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0),
      child: Row(
        children: [
          IconButton(
            icon: SvgPicture.asset(
              Assets.phoneIconRed,
              width: 18,
              height: 18,
              color: isChatEnabled == true
                  ? AppColors.PRIMARY_COLOR_DARK
                  : AppColors.GREY_DARK_COLOR,
            ),
            color: isChatEnabled == true
                ? AppColors.PRIMARY_COLOR
                : AppColors.GREY_DARK_COLOR,
            onPressed: isChatEnabled == true
                ? () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: cardDarkColor(context),
                      shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(16)),
                      ),
                      builder: (_) {
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            spacing: 16,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AppButton(
                                backColor: AppColors.PRIMARY_COLOR,
                                color: AppColors.whiteColor,
                                onPressed: () {
                                  Navigator.pop(context); // Close first sheet
                                  // _showFreeCallBottomSheet(context, item);
                                },
                                label: "Free Call",
                              ),
                              AppButton(
                                backColor: AppColors.cD9D9D9,
                                color: AppColors.black,
                                onPressed: () {
                                  Navigator.pop(context); // Close first sheet
                                  _showRegularCallBottomSheet(
                                      context, item); // Open second
                                },
                                label: "Regular Call",
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                : () {
                    SubscriptionMethod().subscribe(
                      subscribeId: item.subCategory?.first.id ?? '',
                      title: item.firstName ?? '',
                    );
                  },
          ),

          // const SizedBox(width: 4),
          IconButton(
            icon: SvgPicture.asset(
              Assets.mailIconRed,
              color: isChatEnabled == true
                  ? AppColors.PRIMARY_COLOR_DARK
                  : AppColors.GREY_DARK_COLOR,
            ),
            color: isChatEnabled == true
                ? AppColors.PRIMARY_COLOR
                : AppColors.GREY_DARK_COLOR,
            onPressed: isChatEnabled == true
                ? () {
                    // BlocProvider.of<RestaurantsCubit>(context)
                    //     .getExpiredOrders();
                    // Implement message functionality here
                  }
                : () {
                    SubscriptionMethod().subscribe(
                        subscribeId: item.subCategory?.first.id ?? '',
                        title: item.firstName ?? '');
                  },
          ),
          // const SizedBox(width: 4),
          IconButton(
            icon: const Icon(Icons.report),
            color: AppColors.PRIMARY_COLOR_DARK,
            onPressed: () async {
              await showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: cardDarkColor(context),
                builder: (context) {
                  return SizedBox(
                    height: isKeyboardVisible(context) ? 0.8.sh : 0.6.sh,
                    child: ReportView(
                      id: item.id!,
                      categoryId: item.subCategory?.first.id ?? '',
                    ),
                  );
                },
              );

              // Implement report functionality here
            },
          ),
        ],
      ),
    );
  }

  void _showRegularCallBottomSheet(
      BuildContext context, MostBookingEntity item) {
    bool isBookingForAnotherClient = false;
    bool hasPhoneError = false;
    final TextEditingController phoneController =
        TextEditingController(text: "phone" ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: cardDarkColor(context),
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CheckboxListTile(
                    activeColor: AppColors.PRIMARY_COLOR,
                    contentPadding: EdgeInsets.zero,
                    value: isBookingForAnotherClient,
                    onChanged: (value) {
                      setState(() {
                        isBookingForAnotherClient = value!;
                        hasPhoneError = false;
                        if (isBookingForAnotherClient) {
                          phoneController.clear();
                        } else {
                          // phoneController.text = item.number ?? '';
                        }
                      });
                    },
                    title: Text(
                      LocaleKeys.imBookingOfAnotherClient.localize,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: AppColors.c717171,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    controlAffinity: ListTileControlAffinity.leading,
                    dense: true,
                    visualDensity:
                        const VisualDensity(horizontal: -4, vertical: -4),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    enabled: isBookingForAnotherClient,
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.8),
                    ),
                    decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: SvgPicture.asset(
                          color: AppColors.PRIMARY_COLOR,
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
                      fillColor: Colors.grey.shade200,
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
                      backColor: AppColors.PRIMARY_COLOR,
                      color: AppColors.whiteColor,
                      label: LocaleKeys.submit.localize,
                      onPressed: () {
                        final enteredNumber = phoneController.text.trim();
                        if (isBookingForAnotherClient) {
                          if (enteredNumber.isEmpty) {
                            setState(() {
                              hasPhoneError = true;
                            });
                            return;
                          }
                          launchUrlString("tel://$enteredNumber");
                        } else {
                          // launchUrlString("tel://${item.number}");
                        }

                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildButtonWithIcon({
    required String label,
    required IconData icon,
    required Color color,
    required Function onPressed,
  }) {
    return Expanded(
      child: AppButton(
        padding: 0,
        margin: 0,
        height: 60.h,
        label: label,
        icon: icon,
        iconSize: 70.h,
        backColor: color,
        style: Styles.mediumText(color: Colors.white),
        onPressed: onPressed,
      ),
    );
  }
}
