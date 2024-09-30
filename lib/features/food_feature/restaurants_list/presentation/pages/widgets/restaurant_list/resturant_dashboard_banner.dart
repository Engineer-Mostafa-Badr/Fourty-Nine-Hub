import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/cubit/meal_cubit/restaurants_meal_list_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/common/dashboard_banner.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';

class ResturantDashboardButton extends StatelessWidget {
  const ResturantDashboardButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: serviceLocator<RestaurantsMealListCubit>()..isRestaurant(),
      child: BlocConsumer<RestaurantsMealListCubit, RestaurantsMealListState>(
        builder: (context, state) {
          log( state.isResturant.toString()+"aaaaaaaa");
          if (state.isResturant!.isRestaurant == true) {
            return DashboardBanner(
              title: '${LocaleKeys.restaurantDashboard.tr()}\n',
              subTitle: LocaleKeys
                  .newBookingsAreWaitingYouGoToResturantDashboardAndExploreMore
                  .tr(),
              route: Routes.RestaurantDashboard,
            );
          } else {
            return SizedBox.shrink();
          }
        }, listener: (BuildContext context, RestaurantsMealListState state) {  },
      ),
    );
  }
}
