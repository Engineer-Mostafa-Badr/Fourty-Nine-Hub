import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
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
          log("${state.isResturant}aaaaaaaa");
          if (state.isResturant!.isRestaurant == true) {
            return DashboardBanner(
              title: '${LocaleKeys.restaurantDashboard.tr()}\n',
              subTitle: LocaleKeys.newBookingsAreWaitingYouGoToResturantDashboardAndExploreMore.tr(),
              route: Routes.RestaurantDashboard,
            );
          } else {
            return const SizedBox.shrink();
          }
        },
        listener: (BuildContext context, RestaurantsListState state) {},
      ),
    );
  }
}
