import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/controllers/health_cubit/health_cubit.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/widgets/banner.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/widgets/booking/bookgins.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/widgets/current_history_booking.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/widgets/doctor_dashboard_banner.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/widgets/doctor_mode_banner.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/widgets/medical_services/medical_services.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/widgets/booking_types/booking_types.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/widgets/registration_banner.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/widgets/sub_categories/sub_categories.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';

class HealthView extends StatelessWidget {
  const HealthView({super.key});

  @override
  Widget build(BuildContext context) {
    bool isWaitingApproval = true;
    return SharedScaffold(
        mainCategoryId: 1,
        body: BlocBuilder<HealthCubit, HealthState>(
          builder: (context, state) {
            // var controller = context.read<HealthCubit>();
            return state.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView(
                    padding: EdgeInsets.all(16.0.w),
                    children: [
                      const HealthBanner(),
                      // if (state.isDoctor == false)
                      //   Padding(
                      //     padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      //     child: ClickableWidget(
                      //       onTap: () {
                      //         if (context.read<UserCubit>().isLoggedIn) {
                      //           context.push(Routes.CREATEDOCTOR);
                      //           // context.push(Routes.CREATERESTURANT);
                      //         }
                      //       },
                      //       child: Text(
                      //         LocaleKeys.serveClientsByClickRegister.localize,
                      //         style: const TextStyle(
                      //           color: Colors.red,
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      const Sizer(),
                      // if (state.isApproved == true)
                      //   const DoctorDashboardBanner(),
                      //RegistrationBanner(),
                       DoctorModeBanner(
                        isWaitingApproval: isWaitingApproval,
                      ),
                      if(isWaitingApproval)
                        WaitingAprovalText(),
                      const Sizer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: CurrentHistoryBooking(
                            title: context.isArabic
                                ? 'الحجوزات الحالية'
                                : 'Current Booking',
                          )),
                          const Sizer(),
                          Expanded(
                              child: CurrentHistoryBooking(
                            title: context.isArabic
                                ? 'تاريخ الحجوزات'
                                : 'Booking History',
                          )),
                        ],
                      ),
                      const Sizer(
                        height: 20,
                      ),
                      const HealthBookingTypesWidgt(),
                      const Sizer(),
                      const HealthSubCategories(),
                      const Sizer(),
                      const HealthMedicalServices(),
                      const Sizer(),
                      const HealthBookings(),
                      const Sizer(),
                    ],
                  );
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
