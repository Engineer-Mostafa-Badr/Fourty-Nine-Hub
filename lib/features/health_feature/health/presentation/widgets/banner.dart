import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/main_category_banner.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/controllers/health_cubit/health_cubit.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

import '../../../../../common/widgets/dialogs/please_login_dialog.dart';

class HealthBanner extends StatefulWidget {
  const HealthBanner({super.key});

  @override
  State<HealthBanner> createState() => _HealthBannerState();
}

class _HealthBannerState extends State<HealthBanner> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HealthCubit, HealthState>(
      builder: (context, state) {
        if (state.mainCategory != null || state.banner != null) {
          return MainCategoryBanner(
            fromHome: false,
            category: state.mainCategory != null
                ? MainCategoryEntity(
                    id: state.mainCategory?.id ?? "",
                    name: context.isArabic ? 'صحة' : 'Health',
                    image: state.mainCategory?.image ?? "",
                    banner: state.mainCategory?.banner ?? "",
                    cover: state.mainCategory?.cover ?? "",
                    isFavorite: state.mainCategory?.isFavorite ?? false,
                    total: state.mainCategory?.total ?? 0,
                    nameEn: context.isArabic ? 'صحة' : 'Health',
                  )
                : MainCategoryEntity(
                    id: state.banner?.id ?? "",
                    name: context.isArabic ? 'صحة' : 'Health',
                    image: state.banner?.banner ?? "",
                    banner: state.banner?.banner ?? "",
                    cover: state.banner?.cover ?? "",
                    isFavorite: false,
                    total: state.banner?.numberOfAds ?? 0,
                    nameEn: context.isArabic ? 'صحة' : 'Health'),
            canRegister: state.isDoctor == true ? false : true,
            onRegister: () {
              if (context.read<UserCubit>().isLoggedIn) {
                context.push(Routes.CREATEDOCTOR);
              } else {
                return pleaseLoginDialog(context);
                // context.push(Routes.REGISTER);
              }
            },
            onFavorite: () {
              context
                  .read<HealthCubit>()
                  .toggleFavoriteCategory(state.mainCategory!.id);
            },
            isFavorite:
                context.read<HealthCubit>().state.mainCategory?.isFavorite ??
                    false,
          );
        } else {
          return const SizedBox.shrink();
        }
      },
      listener: (BuildContext context, HealthState state) {},
    );
  }
}
