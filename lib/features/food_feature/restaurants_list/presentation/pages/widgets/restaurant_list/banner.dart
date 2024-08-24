import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/functions/helper/lang_helper.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/main_category_banner.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/cubit/restaurants_list_cubit.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

class MealBanner extends StatelessWidget {
  const MealBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RestaurantsListCubit, RestaurantsListState>(
      builder: (context, state) {
        if (state.isLoading) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[100]!,
            highlightColor: Colors.white,
            child: Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
            ),
          );
        }
        if (state.mainCategory != null || state.banner != null) {
          return MainCategoryBanner(
              color: AppColors.ACCENT_COLOR,
              category: state.mainCategory ??
                  MainCategoryEntity(
                      id: state.banner?.id ?? "",
                      name: (getLang() == "ar"
                              ? state.banner?.nameAr
                              : state.banner?.nameEn) ??
                          LocaleKeys.meal.tr(),
                      image: state.banner?.banner ?? "",
                      banner: state.banner?.banner ?? "",
                      cover: state.banner?.cover ?? "",
                      isFavorite: false,
                      total: state.banner?.numberOfAds ?? 0),
              canRegister: state.isResturant == true ? false : true,
              onRegister: () {
                if (context.read<UserCubit>().isLoggedIn) {
                  context.push(Routes.CREATERESTURANT);
                } else {
                  context.push(Routes.REGISTER);
                }
              });
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
