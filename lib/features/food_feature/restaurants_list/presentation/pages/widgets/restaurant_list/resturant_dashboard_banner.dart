import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_dashboard/presentation/cubit/restaurant_dashboard_cubit.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_dashboard/presentation/pages/restaurant_dashboard_view.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/cubit/meal_cubit/restaurants_meal_list_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/common/dashboard_banner.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';

import '../../../cubit/restaurants_list_cubit.dart';

class ResturantDashboardButton extends StatelessWidget {
  const ResturantDashboardButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: serviceLocator<RestaurantsCubit>()..isRestaurant(),
      child: BlocConsumer<RestaurantsCubit, RestaurantsListState>(
        builder: (context, state) {
          log(state.isResturant!.restaurantId.toString() + "aaaa33aaaa");
          if (state.isResturant!.isRestaurant == true) {
            return DashboardBanner(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MultiBlocProvider(
                          providers: [
                            BlocProvider(
                              create: (context) => RestaurantDashboardCubit(
                                  serviceLocator(), serviceLocator()),
                            ),
                            BlocProvider.value(
                              value: serviceLocator<RestaurantsCubit>()..isRestaurant(),
                            ),
                          ],
                          child: RestaurantDashboardView(
                              isRestaurantModel: state.isResturant!),
                        ),
                      ));
                },
                title: '${LocaleKeys.restaurantDashboard.tr()}\n',
                subTitle: LocaleKeys
                    .newBookingsAreWaitingYouGoToResturantDashboardAndExploreMore
                    .tr(),
                route: Routes.RestaurantDashboard,
                isRestaurantModel: state.isResturant);
          } else {
            return SizedBox.shrink();
          }
        },
        listener: (BuildContext context, RestaurantsListState state) {},
      ),
    );
  }
}
