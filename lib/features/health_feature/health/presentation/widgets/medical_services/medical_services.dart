import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/controllers/health_cubit/health_cubit.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/widgets/medical_services/medical_service_card.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:shimmer/shimmer.dart';

class HealthMedicalServices extends StatefulWidget {
  const HealthMedicalServices({
    super.key,
  });

  @override
  State<HealthMedicalServices> createState() => _HealthMedicalServicesState();
}

class _HealthMedicalServicesState extends State<HealthMedicalServices> {
  ScrollController? _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HealthCubit, HealthState>(builder: (context, state) {
      return SizedBox(
        height: 0.28.sh,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SingleChildScrollView(
            //   scrollDirection: Axis.horizontal,
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       const SizedBox(
            //         width: 16,
            //       ),
            //       Icon(
            //         Icons.search,
            //         size: 50.sp,
            //       ),
            //       const Sizer(),

            //       /// Favourite Ads
            //       CurrentHistoryBooking(
            //         title: LocaleKeys.mostBooking.localize,
            //         isSelected: false, // _showMost,
            //         onTap: () {}, // => _toggleView('most'),
            //       ),
            //       const Sizer(),

            //       /// History
            //       CurrentHistoryBooking(
            //         title: context.isArabic ? 'سجل حجوزات' : 'Booking History',
            //         isSelected: false, //_showHistory,
            //         onTap: () {},
            //         //  {
            //         //   if (!context.read<UserCubit>().isLoggedIn) {
            //         //     return pleaseLoginDialog(context);
            //         //   } else {
            //         //     _toggleView('history');
            //         //   }
            //         // },
            //       ),
            //       const Sizer(),

            //       /// Current Booking
            //       CurrentHistoryBooking(
            //         title:
            //             context.isArabic ? 'حجوزات حالية' : 'Current Booking',
            //         isSelected: false, // _showCurrent,
            //         onTap: () {
            //           // if (!context.read<UserCubit>().isLoggedIn) {
            //           //   return pleaseLoginDialog(context);
            //           // } else {
            //           //   _toggleView('current');
            //           // }
            //         },
            //       ),
            //       const SizedBox(
            //         width: 16,
            //       ),
            //     ],
            //   ),
            // ),

            state.medicalServices == null
                ? Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Label(
                      text: LocaleKeys.medicalService.localize,
                      style: Styles.headerText(),
                    ),
                  )
                : state.medicalServices == []
                    ? const SizedBox.shrink()
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Label(
                              text: LocaleKeys.medicalService.localize,
                              style: Styles.headerText(),
                            ),
                            ClickableWidget(
                              onTap: () {
                                _scrollController?.animateTo(
                                  (_scrollController?.position.pixels ?? 0) +
                                      0.8.sw,
                                  duration: const Duration(seconds: 1),
                                  curve: Curves.easeInOut,
                                );
                              },
                              child: Row(
                                children: [
                                  Label(
                                    text: context.isArabic
                                        ? 'مشاهدة المزيد'
                                        : 'See More',
                                    style: Styles.mediumText(
                                        decoration: TextDecoration.underline,
                                        color: AppColors.getRedColor(context)),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: AppColors.getRedColor(context),
                                    size: 30.h,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
            const Sizer(),
            Expanded(
              child: state.medicalServices != null &&
                      state.medicalServices != []
                  ? ListView.separated(
                      controller: _scrollController,
                      separatorBuilder: (context, index) => const Sizer(),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) => Padding(
                        padding: EdgeInsetsDirectional.only(
                            start: index == 0 ? 16 : 0,
                            end: index == state.medicalServices!.length - 1
                                ? 16
                                : 0),
                        child: HealthMedicalServiceCard(
                          subCategory: state.medicalServices![index],
                        ),
                      ),
                      itemCount: state.medicalServices!.length,
                    )
                  : state.medicalServices == null
                      ? Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade100,
                          child: ListView.separated(
                            controller: _scrollController,
                            separatorBuilder: (context, index) => const Sizer(),
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) => Container(
                              width: 200,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            itemCount: 10,
                          ),
                        )
                      : const SizedBox.shrink(),
            ),
            const Sizer(),
          ],
        ),
      );
    });
  }
}
