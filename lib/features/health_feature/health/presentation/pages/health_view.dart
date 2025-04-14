import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/controllers/health_cubit/health_cubit.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/widgets/banner.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/widgets/booking/bookgins.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/widgets/cards/booking_history_card.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/widgets/cards/current_booking_card.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/widgets/current_history_booking.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/widgets/doctor_mode_banner.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/widgets/medical_services/medical_services.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/widgets/booking_types/booking_types.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/widgets/registration_banner.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/widgets/sub_categories/sub_categories.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';

import '../widgets/cards/favourite_ads_card.dart';

class HealthView extends StatefulWidget {
  HealthView({super.key});

  @override
  State<HealthView> createState() => _HealthViewState();
}

class _HealthViewState extends State<HealthView> {
  int history = 0;

  @override
  Widget build(BuildContext context) {
    bool isWaitingApproval = true;
    return SharedScaffold(
        mainCategoryId: 1,
        body: BlocBuilder<HealthCubit, HealthState>(
          builder: (context, state) {
            // var controller = context.read<HealthCubit>();
            // if (state.isLoading) {
            //   return const Center(child: CircularProgressIndicator());
            // } else {
              return ListView(
                    padding: EdgeInsets.all(16.0.w),
                    children: [
                      const HealthBanner(),
                      const Sizer(),
                      state.isDoctor == false? const RegistrationBanner():  DoctorModeBanner(
            isWaitingApproval: isWaitingApproval,
            ),

                      if (isWaitingApproval) WaitingAprovalText(),
                      const Sizer(),
                      Padding(
                        padding:  EdgeInsets.symmetric(horizontal: 20.0.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.search,size: 50.sp,),
                            const Sizer(),
                            /// current historu
                            Expanded(
                                child: CurrentHistoryBooking(
                                  title: LocaleKeys.favouriteAds.localize,
                                  isSelected: history == 3 ? true : false,
                                  onTap: () {
                                    setState(() {
                                      history = 3;
                                    });
                                  },
                                )),
                            const Sizer(),
                            /// current booking
                            Expanded(
                                child: CurrentHistoryBooking(
                                  title: context.isArabic
                                      ? 'تاريخ الحجوزات'
                                      : 'Booking History',
                                  isSelected: history == 2 ? true : false,
                                  onTap: () {
                                    setState(() {
                                      history = 2;
                                    });
                                  },
                                )),
                          const  Sizer(),
                            /// current booking
                            Expanded(
                                child: CurrentHistoryBooking(
                              title: context.isArabic
                                  ? 'الحجوزات الحالية'
                                  : 'Current Booking',
                              isSelected: history == 1 ? true : false,
                              onTap: () {
                                setState(() {
                                  history = 1;
                                });
                              },
                            )),

                          ],
                        ),
                      ),
                      const Sizer(
                        height: 20,
                      ),
                      if(history==0)
                        const Column(
                          children: [
                            HealthBookingTypesWidgt(),
                            Sizer(),
                            HealthSubCategories(),
                            Sizer(),
                            HealthMedicalServices(),
                            Sizer(),
                            HealthBookings(),
                            Sizer(),
                          ],
                        ),
                      if(history==1)
                        const Column(
                          children: [
                            CurrentBookingCard(title: 'Ibrahim',isSubscribed: false,),
                            CurrentBookingCard(title: 'Ibrahim',isSubscribed: false,),
                          ],
                        ),
                      if(history==2)
                        const Column(
                          children: [
                            BookingHistoryCard(title: 'Dr.Ahmed Ibrahim',isSubscribed: true,),
                            BookingHistoryCard(title: 'Dr.Ahmed Ibrahim',isSubscribed: true,),
                          ],
                        ),      if(history==3)
                        Column(
                          children: [

                            FavouriteAdsCard (onFavourite: () {  }, onRequest: () {  },),
                          ],
                        ),

                    ],
                  );
            //}
          },
        ));
  }

  Widget WaitingAprovalText() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.h, 5.h, 20.h, 0),
      child: Row(
        children: [
          Expanded(child: Container()),
          Text(
            LocaleKeys.waitingApproval.localize,
            style: Styles.headerText(
              color: AppColors.SECONDARY_COLOR,
              fontSize: 30,
            ),
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }
}
