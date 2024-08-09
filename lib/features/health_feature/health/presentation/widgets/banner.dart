import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/main_category_banner.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/controllers/health_cubit/health_cubit.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/controllers/shared_data/health_shared_data.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';

class HealthBanner extends StatelessWidget {
  const HealthBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HealthCubit, HealthState>(
      builder: (context, state) {
        return MainCategoryBanner(
            category: serviceLocator<HealthSharedData>().mainCategory,
            canRegister: state.isDoctor == true ? false : true,
            onRegister: () {
              if (context.read<UserCubit>().isLoggedIn) {
                context.push(Routes.CREATEDOCTOR);
              } else {
                context.push(Routes.REGISTER);
              }
            });
      },
    );
  }
}
