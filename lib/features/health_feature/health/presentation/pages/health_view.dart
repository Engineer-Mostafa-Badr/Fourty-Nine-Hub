import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dialogs/please_login_dialog.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/controllers/health_cubit/health_cubit.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/widgets/banner.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/widgets/booking/bookgins.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/widgets/cards/booking_history_card.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/widgets/cards/current_booking_card.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/widgets/cards/most_booking_card.dart';
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

import '../../../../../service_locator/service_locator.dart';

class HealthView extends StatefulWidget {
  const HealthView({super.key});

  @override
  State<HealthView> createState() => _HealthViewState();
}

class _HealthViewState extends State<HealthView> {
  bool _showMost = false;
  bool _showHistory = false;
  bool _showCurrent = false;

// When buttons are clicked:
  void _toggleView(String viewType) {
    final cubit = context.read<HealthCubit>();

    setState(() {
      if (viewType == 'most') {
        _showMost = !_showMost;
        if (_showMost) {
          _showHistory = false;
          _showCurrent = false;
        }
      } else if (viewType == 'history') {
        _showHistory = !_showHistory;
        if (_showHistory) {
          _showMost = false;
          _showCurrent = false;
          cubit.switchBookingType('history');
        }
      } else if (viewType == 'current') {
        _showCurrent = !_showCurrent;
        if (_showCurrent) {
          _showMost = false;
          _showHistory = false;
          cubit.switchBookingType('current');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isWaitingApproval = false;
    return SharedScaffold(
      mainCategoryId: 1,
      body: BlocBuilder<HealthCubit, HealthState>(
        builder: (context, state) {
          return ListView(
            padding: EdgeInsets.all(16.0.w),
            children: [
              const HealthBanner(),
              const Sizer(),
              state.isDoctor == false
                  ? const RegistrationBanner()
                  : DoctorModeBanner(
                      isWaitingApproval: isWaitingApproval,
                    ),
              if (isWaitingApproval) WaitingAprovalText(),
              const Sizer(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0.w),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.search,
                        size: 50.sp,
                      ),
                      const Sizer(),

                      /// Favourite Ads
                      CurrentHistoryBooking(
                        title: LocaleKeys.mostBooking.localize,
                        isSelected: _showMost,
                        onTap: () => _toggleView('most'),
                      ),
                      const Sizer(),

                      /// History
                      CurrentHistoryBooking(
                        title: context.isArabic
                            ? 'سجل حجوزات'
                            : 'Booking History',
                        isSelected: _showHistory,
                        onTap: () {
                          if (!context.read<UserCubit>().isLoggedIn) {
                            return pleaseLoginDialog(context);
                          } else {
                            _toggleView('history');
                          }
                        },
                      ),
                      const Sizer(),

                      /// Current Booking
                      CurrentHistoryBooking(
                        title: context.isArabic
                            ? 'حجوزات حالية'
                            : 'Current Booking',
                        isSelected: _showCurrent,
                        onTap: () {
                          if (!context.read<UserCubit>().isLoggedIn) {
                            return pleaseLoginDialog(context);
                          } else {
                            _toggleView('current');
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const Sizer(height: 20),

              // Default view when none are selected
              if (!_showMost && !_showHistory && !_showCurrent)
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

              // Current Booking view
              if (_showCurrent)
                BlocProvider(
                  create: (context) => serviceLocator<HealthCubit>(
                      // Pass your dependencies here
                      )
                    ..loadInitialBooking('current'),
                  child: CurrentBookingsScreen(
                    onClose: () => setState(() => _showCurrent = false),
                  ),
                ),

              // History view
              if (_showHistory)
                BlocProvider(
                  create: (context) => serviceLocator<HealthCubit>()
                    ..loadInitialBooking('history'),
                  child: BookingHistoryScreen(
                    onClose: () => setState(() => _showHistory = false),
                  ),
                ),

              // Favourite Ads view
              if (_showMost)
                BlocProvider(
                  key: ValueKey('MostBookingScreen'),
                  create: (context) =>
                      serviceLocator<HealthCubit>()..loadInitialMostBooking(),
                  child: MostBookingScreen(
                    onClose: () => setState(() => _showMost = false),
                  ),
                ),
            ],
          );
        },
      ),
    );
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
