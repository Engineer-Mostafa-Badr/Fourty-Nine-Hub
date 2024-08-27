import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/cubit/restaurants_list_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/common/dashboard_banner.dart';
import 'package:fourtyninehub/res/strings/labels.dart';
import 'package:fourtyninehub/routes/routes.dart';

class ResturantDashboardButton extends StatelessWidget {
  const ResturantDashboardButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RestaurantsListCubit, RestaurantsListState>(
      builder: (context, state) {
        if (state.isResturant == true) {
          return const DashboardBanner(
            title: '${Labels.restaurantDashboard}\n',
            subTitle: Labels.resturantDashboardBannerDiscription,
            route: Routes.RestaurantDashboard,
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
