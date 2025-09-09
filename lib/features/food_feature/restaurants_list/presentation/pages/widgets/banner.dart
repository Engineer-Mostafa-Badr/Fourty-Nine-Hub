import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../common/widgets/stateful/banners/main_category_banner.dart';
import '../../../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';
import '../../cubit/restaurants_list_cubit.dart';
import '../../../../../../routes/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../common/widgets/dialogs/please_login_dialog.dart';

class MealBanner extends StatelessWidget {
  const MealBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RestaurantsCubit, RestaurantsListState>(
      builder: (context, state) {
        if (state.isLoading) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[100]!,
            highlightColor: Colors.white,
            child: Container(
              height: 150.h,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
            ),
          );
        }
        if (state.mainCategory != null) {
          return MainCategoryBanner(
            fromHome: false,
            category: state.mainCategory!,
            canRegister: state.isResturant == true ? false : true,
            onRegister: () {
              if (context.read<UserCubit>().isLoggedIn) {
                context.push(Routes.CREATERESTURANT);
              } else {
                return pleaseLoginDialog(context);
                // context.push(Routes.REGISTER);
              }
            },
            onFavorite: () {
              return null;
            },
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
