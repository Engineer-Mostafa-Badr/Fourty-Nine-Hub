import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/numbers_extensions.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/custom_empty_widget.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/widgets/cards/health_card_bottom_section.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/widgets/cards/health_custom_card.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

import '../../../../../../core/widget/olx_pagination/banner.dart';
import '../../../../../../core/widget/olx_pagination/olx_pagination_widget.dart';
import '../../../../../../core/widget/custom_loading_search_widget.dart';
import '../../../domain/entities/booking_entity.dart';
import '../../controllers/health_cubit/health_cubit.dart';

class CurrentBookingsScreen extends StatefulWidget {
  const CurrentBookingsScreen({super.key, this.onClose});

  final VoidCallback? onClose;

  @override
  State<CurrentBookingsScreen> createState() => _CurrentBookingsScreenState();
}

class _CurrentBookingsScreenState extends State<CurrentBookingsScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<HealthCubit>().getBookings('current');
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

        // Show loading indicator when initially loading and no bookings exist
        if (state.status == HealthStates.loading &&
            cubit.currentBookings.isEmpty) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * .6,
            child: const Center(child: CustomLoadingSearchWidget()),
          );
        }

        // Show empty state when no bookings exist
        if (cubit.currentBookings.isEmpty) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * .6,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomEmptyWidget(
                  label: context.isArabic
                      ? 'لا توجد حجوزات حالية'
                      : 'No current bookings',
                ),
              ],
            ),
          );
        }

        // Show bookings list with pagination
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.67,
          child: Column(
            children: [
              OlxPaginationWidget(
                itemsPerPage: 2,
                loadPage: (page) =>
                    context.read<HealthCubit>().getBookings('current'),
                banners: bannersList,
                items: List.generate(cubit.currentBookings.length, (index) {
                  final booking = cubit.currentBookings[index];
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: CurrentBookingCard(
                      booking: booking,
                    ),
                  );
                }),
              ),
              if (state.isLoadingMoreBooking == true)
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CustomLoadingSearchWidget(),
                ),
            ],
          ),
        );
      },
    );
  }
}

class CurrentBookingCard extends StatefulWidget {
  const CurrentBookingCard({
    super.key,
    required this.booking,
  });

  final BookingEntity booking;

  @override
  State<CurrentBookingCard> createState() => _CurrentBookingCardState();
}

class _CurrentBookingCardState extends State<CurrentBookingCard> {
  @override
  Widget build(BuildContext context) {
    final doctor = widget.booking.doctor;
    final address = doctor?.address;
    final rating = doctor?.rating;
    final subCategory = doctor?.subCategory;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              HealthCustomCard(
                padding: EdgeInsets.symmetric(horizontal: 16.h),
                radiusGeometry: BorderRadius.circular(20.h),
                children: [
                  const Sizer(),
                  _tripCardInfoWidget(
                    title:
                        '${doctor?.firstName ?? ''} ${doctor?.lastName ?? ''}',
                    icon: doctor?.profilePicture ?? Assets.maleUser,
                    specialty: subCategory?.nameAr ??
                        subCategory?.nameEn ??
                        'Specialty',
                    date: widget.booking.day ?? 'N/A',
                    time: widget.booking.startTime ?? 'N/A',
                    rating: rating?.average?.toStringAsFixed(1) ?? '0.0',
                  ),
                  const Sizer(),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_sharp,
                        color: AppColors.getButtonPrimaryWhiteColor(context),
                        size: 48.h,
                      ),
                      const Sizer(),
                      Label(
                        text: address?.address ??
                            (context.isArabic
                                ? 'عنوان غير معروف'
                                : 'Address not available'),
                        style: Styles.mediumText(fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                  const Sizer(),
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
                          style: Styles.mediumText(
                              fontWeight: FontWeight.w500, fontSize: 32),
                        ),
                      ),
                      Label(
                        text: doctor?.callsPrice?.toArabicNumbers(context) ??
                            '120'.toArabicNumbers(context) +
                                (context.isArabic ? ' ج.م' : ' EGP'),
                        //(context.isArabic?'سعر غير متوفر':'Price not available'),
                        style: Styles.mediumText(
                            fontWeight: FontWeight.w500, fontSize: 32),
                      )
                    ],
                  ),
                  const Sizer(),
                  Row(
                    children: [
                      Icon(Icons.watch_later_outlined,
                          color: AppColors.getButtonPrimaryWhiteColor(context),
                          size: 48.h),
                      const Sizer(),
                      Label(
                        text:
                            '${context.isArabic ? 'وقت الانتظار' : 'Waiting time'}: ${doctor?.waitingTime ?? (context.isArabic ? '' : 'N/A')} ${context.isArabic ? 'دقيقة' : 'min'}'
                                .toArabicNumbers(context),
                        style: Styles.mediumText(
                            fontWeight: FontWeight.w500, fontSize: 32),
                      )
                    ],
                  ),
                  const Sizer(),
                  HealthCardButtonsSection(
                    isButton: false,
                    isSubscribed: doctor?.isPremium ?? false,
                    buttonTitle: '',
                    onTap: () {},
                  ),
                  const Sizer(),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _tripCardInfoWidget({
    required String title,
    required String icon,
    required String specialty,
    required String date,
    required String time,
    required String rating,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          children: [
            Row(
              children: [
                Container(
                  width: 112.h,
                  height: 112.h,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: icon.startsWith('http')
                      ? Image.network(
                          icon,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              Image.asset(Assets.maleUser),
                        )
                      : Image.asset(
                          icon,
                          fit: BoxFit.cover,
                        ),
                ),
                const Sizer(),
              ],
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.cF5F5F5,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Row(children: [
                    SvgPicture.asset(Assets.star2, width: 8, height: 8),
                    const Sizer(width: 4),
                    Label(
                        text: rating.toArabicNumbers(context),
                        style: Styles.smallText(color: Colors.black))
                  ]),
                ),
              ),
            ),
          ],
        ),
        const Sizer(),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Label(
                text: title,
                style: Styles.headerText(
                    fontWeight: FontWeight.w600, fontSize: 32),
              ),
              Label(
                text: specialty,
                style: Styles.mediumText(),
              )
            ],
          ),
        ),
        Column(
          children: [
            Label(
              text: date,
              style: Styles.mediumText(),
            ),
            Label(
              text: time.toArabicNumbers(context),
              style: Styles.mediumText(),
            )
          ],
        )
      ],
    );
  }
}
