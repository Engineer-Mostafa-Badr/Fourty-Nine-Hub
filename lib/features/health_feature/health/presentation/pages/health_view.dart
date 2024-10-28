import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/controllers/health_cubit/health_cubit.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/widgets/banner.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/widgets/booking/bookgins.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/widgets/doctor_dashboard_banner.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/widgets/medical_services/medical_services.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/widgets/booking_types/booking_types.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/widgets/sub_categories/sub_categories.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';

class HealthView extends StatelessWidget {
  const HealthView({super.key});

  @override
  Widget build(BuildContext context) {
    return SharedScaffold(
        mainCategoryId: 1,
        body: BlocBuilder<HealthCubit, HealthState>(
          builder: (context, state) {
            // var controller = context.read<HealthCubit>();
            return ListView(
              padding: EdgeInsets.all(16.0.w),
              children: [
                BlocProvider.value(
                  value: serviceLocator<HealthCubit>(),
                  child: const HealthBanner(),
                ),
                if (state.isDoctor == false)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: InkWell(
                      onTap: () {
                        if (context.read<UserCubit>().isLoggedIn) {
                          context.push(Routes.CREATERESTURANT);
                        } else {
                          context.push(Routes.REGISTER);
                        }
                      },
                      child: Text(
            LocaleKeys
                .serveClientsByClickRegister
                .tr(),
                        style: const TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                const Sizer(),
                if (state.isApproved == true) const DoctorDashboardBanner(),
                const Sizer(),
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
}
