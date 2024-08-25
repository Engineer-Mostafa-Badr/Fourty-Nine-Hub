import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/cubit/restaurants_list_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/common/dashboard_banner.dart';
import 'package:fourtyninehub/routes/routes.dart';

class ResturantDashboardButton extends StatelessWidget {
  const ResturantDashboardButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RestaurantsListCubit, RestaurantsListState>(
      builder: (context, state) {
        if (state.isResturant == true) {
          return DashboardBanner(
            title: '${LocaleKeys.restaurantDashboard.tr()}\n',
            subTitle: LocaleKeys
                .newBookingsAreWaitingYouGoToResturantDashboardAndExploreMore
                .tr(),
            route: Routes.RestaurantDashboard,
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
