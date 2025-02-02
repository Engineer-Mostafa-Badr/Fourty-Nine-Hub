import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/main_category_banner.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../../service_locator/service_locator.dart';
import '../../../../../create_restaurant/cubit/create_resturant_cubit.dart';
import '../../../../../create_restaurant/views/create_resturant_view.dart';
import '../../../cubit/restaurants_list_cubit.dart';

class MealBanner extends StatelessWidget {
  const MealBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RestaurantsCubit, RestaurantsListState>(
      builder: (context, state) {
        if (state.mainCategory == null) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[100]!,
            highlightColor: Colors.white,
            child: Container(
              height: MediaQuery.sizeOf(context).height * 0.13.h,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
            ),
          );
        }
        return MainCategoryBanner(
          fromHome:false,
          category: state.mainCategory != null
              ? MainCategoryEntity(
                  id: state.mainCategory?.id ?? "",
                  name: context.isArabic ? 'أكلة' : 'Meal',
                  image: state.mainCategory?.image ?? "",
                  banner: state.mainCategory?.banner ?? "",
                  cover: state.mainCategory?.cover ?? "",
                  isFavorite: state.mainCategory?.isFavorite ?? false,
                  total: state.mainCategory?.total ?? 0,
                  nameEn: context.isArabic ? 'أكلة' : 'Meal',
                )
              : MainCategoryEntity(
                  id: state.banner?.id ?? "",
                  name: context.isArabic ? 'أكلة' : 'Meal',
                  image: state.banner?.banner ?? "",
                  banner: state.banner?.banner ?? "",
                  cover: state.banner?.cover ?? "",
                  isFavorite: false,
                  total: state.banner?.numberOfAds ?? 0,
                  nameEn: context.isArabic ? 'أكلة' : 'Meal'),
          canRegister: state.isResturant?.isRestaurant == true ? false : true,
          onRegister: () {
            if (context.read<UserCubit>().isLoggedIn) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider<CreateRestaurantCubit>(
                      create: (context) => serviceLocator()..loadData(),
                      child: CreateRestaurantForm(
                        from: 'create',
                        restaurantId: state.isResturant!.restaurantId,
                      ),
                    ),
                  ));
              // context.push(Routes.CREATERESTURANT);
            } else {
              context.push(Routes.REGISTER);
            }
          },
          onFavorite: () {
            print("object");
            context
                .read<RestaurantsCubit>()
                .toggleFavoriteCategory(state.mainCategory!.id);
          },
          isFavorite: !(state.mainCategory?.isFavorite ?? false),
        );
      },
    );
  }
}
