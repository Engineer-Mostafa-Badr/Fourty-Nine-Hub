import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/main_category_banner.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/cubit/meal_cubit/restaurants_meal_list_cubit.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../../service_locator/service_locator.dart';
import '../../../../../create_restaurant/cubit/create_resturant_cubit.dart';
import '../../../../../create_restaurant/views/create_resturant_view.dart';

class MealBanner extends StatelessWidget {
  const MealBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RestaurantsMealListCubit, RestaurantsMealListState>(
      builder: (context, state) {
        if (state.isLoading) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[100]!,
            highlightColor: Colors.white,
            child: Container(
              height: 110.h,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
            ),
          );
        }
        if (state.mainCategory != null || state.banner != null) {
          return MainCategoryBanner(
            category: state.mainCategory != null
                ? MainCategoryEntity(
                    id: state.mainCategory?.id ?? "",
                    name: LocaleKeys.meal.tr(),
                    image: state.mainCategory?.image ?? "",
                    banner: state.mainCategory?.banner ?? "",
                    cover: state.mainCategory?.cover ?? "",
                    isFavorite: state.mainCategory?.isFavorite ?? false,
                    total: state.mainCategory?.total ?? 0,
                  )
                : MainCategoryEntity(
                    id: state.banner?.id ?? "",
                    name: LocaleKeys.meal.tr(),
                    image: state.banner?.banner ?? "",
                    banner: state.banner?.banner ?? "",
                    cover: state.banner?.cover ?? "",
                    isFavorite: false,
                    total: state.banner?.numberOfAds ?? 0),
            canRegister: state.isResturant?.isRestaurant == true ? false : true,
            onRegister: () {
              if (context.read<UserCubit>().isLoggedIn) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlocProvider<CreateRestaurantCubit>(
                        create: (context) => serviceLocator(),
                        child: const CreateRestaurantForm(),
                      ),
                    ));
                // context.push(Routes.CREATERESTURANT);
              } else {
                context.push(Routes.REGISTER);
              }
            },
            onFavorite: () {
              context
                  .read<RestaurantsMealListCubit>()
                  .toggleFavoriteCategory(state.mainCategory!.id);
            },
            isFavorite: false,
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
