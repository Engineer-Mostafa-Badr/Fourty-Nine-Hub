import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/main_category_banner.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/cubit/restaurants_list_cubit.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

class MealBanner extends StatelessWidget {
  const MealBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RestaurantsListCubit, RestaurantsListState>(
      builder: (context, state) {
        if (state.mainCategory != null) {
          return MainCategoryBanner(
              color: AppColors.ACCENT_COLOR,
              category: state.mainCategory!,
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
