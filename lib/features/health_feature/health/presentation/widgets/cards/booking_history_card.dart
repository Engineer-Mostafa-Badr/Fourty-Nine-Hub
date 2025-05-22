import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/loading/custom_loading.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/widgets/cards/health_card_bottom_section.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/widgets/cards/health_custom_card.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

import '../../controllers/health_cubit/health_cubit.dart';
class BookingHistoryScreen extends StatefulWidget {
  const BookingHistoryScreen({super.key, this.onClose});
  final VoidCallback? onClose;

  @override
  State<BookingHistoryScreen> createState() => _BookingHistoryScreenState();
}

class _BookingHistoryScreenState extends State<BookingHistoryScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<HealthCubit>().getBookings('history');
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

        if (state.status == HealthStates.loading && cubit.historyBookings.isEmpty) {
          return SizedBox(
              height:MediaQuery.of(context).size.height*.6,child: Center(child: CustomLoading()));
        }

        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          child: Column(
            children: [
              Expanded(
                child: cubit.historyBookings.isEmpty
                    ? Center(
                  child: Text(
                    context.isArabic ? 'لا يوجد حجوزات سابقة' : 'No booking history',
                    style: Styles.headerText(
                      fontWeight: FontWeight.w600,
                      color: AppColors.grey,
                    ),
                  ),
                )
                    : ListView.separated(
                  controller: _scrollController,
                  itemCount: cubit.historyBookings.length,
                  itemBuilder: (context, index) {
                    final booking = cubit.historyBookings[index];
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: BookingHistoryCard(
                        title: '${booking.doctor?.firstName ?? ''} ${booking.doctor?.lastName ?? ''}',
                        isSubscribed: booking.doctor?.isPremium ?? false,
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => const Sizer(),
                ),
              ),
              if (state.isLoadingMoreBooking == true)
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                ),
            ],
          ),
        );
      },
    );
  }
}

class BookingHistoryCard extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  const BookingHistoryCard({
    super.key,
    required this.title,
    required this.isSubscribed,
  });

  final String title;
  final bool isSubscribed;

  @override
  State<BookingHistoryCard> createState() => _BookingHistoryCardState();
}

class _BookingHistoryCardState extends State<BookingHistoryCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 10.h,
      ),
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
                    title: widget.title,
                    icon: widget.isSubscribed
                        ? 'assets/images/doctor_profile.jpeg'
                        : Assets.maleUser,
                  ),
                  const Sizer(),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_sharp,
                        color: AppColors.PRIMARY_COLOR,
                        size: 48.h,
                      ),
                      const Sizer(),
                      Label(
                        text: 'Nasr City, Cairo',
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
                          style: Styles.mediumText(fontWeight: FontWeight.w500),
                        ),
                      ),
                      Label(
                        text: '100 ${LocaleKeys.egp.localize}',
                        style: Styles.mediumText(fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                  const Sizer(),
                  if(widget.isSubscribed)
                    Row(
                    children: [
                      Icon(Icons.watch_later_outlined,
                          color: AppColors.black, size: 48.h),
                      const Sizer(),
                      Label(
                        text:
                            '${context.isArabic ? 'وقت الانتظار' : 'Waiting time'}: 10 ${context.isArabic ? 'دقيقة' : 'min'}',
                        style: Styles.mediumText(fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                  const Sizer(),
                  HealthCardButtonsSection(
                    isButton: false,
                    isSubscribed: widget.isSubscribed,
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

  _tripCardInfoWidget({
    required String title,
    required String icon,
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
                  child: Image.asset(
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
                          Label(text: '4.4', style: Styles.smallText())
                        ]))))
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
              if (widget.isSubscribed)
                Label(
                  text: 'Ear/Nose',
                  style: Styles.mediumText(),
                )
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.h,vertical: 10.h),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: AppColors.BG_GRAY_COLOR,
                width: 2,
              )),
          child: Label(
            text: LocaleKeys.expired.localize,
            style: Styles.mediumText(
              color: AppColors.SECONDARY_COLOR,
              fontWeight: FontWeight.w600
            ),
          ),
        )
      ],
    );
  }
}
