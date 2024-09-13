import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/main_category_banner.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/controllers/health_cubit/health_cubit.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

class HealthBanner extends StatefulWidget {
  const HealthBanner({super.key});

  @override
  State<HealthBanner> createState() => _HealthBannerState();
}

class _HealthBannerState extends State<HealthBanner> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HealthCubit, HealthState>(
      builder: (context, state) {
        if (state.mainCategory != null) {
          return MainCategoryBanner(
              isFavorite: state.mainCategory!.isFavorite ?? false,
              onFavorite: () async {
                // context.read<HealthCubit>().toggleFavoriteMedicalService(state.mainCategory!.id);
                print(state.mainCategory!.id);
                setState(() {});
                return await state.mainCategory!.isFavorite == true
                    ? context
                        .read<HealthCubit>()
                        .deleteMedicalService(state.mainCategory!.id)
                    : context
                        .read<HealthCubit>()
                        .toggleFavoriteMedicalService(state.mainCategory!.id);
              },
              category: state.mainCategory!,
              canRegister: state.isDoctor == true ? false : true,
              onRegister: () {
                if (context.read<UserCubit>().isLoggedIn) {
                  context.push(Routes.CREATEDOCTOR);
                } else {
                  context.push(Routes.REGISTER);
                }
              });
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }
}
