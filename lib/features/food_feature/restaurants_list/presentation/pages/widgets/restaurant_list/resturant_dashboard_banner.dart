import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/common/dashboard_banner.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

import '../../../cubit/restaurants_list_cubit.dart';

class ResturantDashboardButton extends StatelessWidget {
  const ResturantDashboardButton({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<RestaurantsCubit>().state;

    return DashboardBanner(
        onTap: () async {
          var result = await context.push(Routes.RestaurantDashboard,
              extra: state.isResturant!.restaurantId!);
          if (result == true) {
            context.read<RestaurantsCubit>().loadData();
          }
        },
        title: LocaleKeys.restaurantDashboard.localize,
        subTitle: LocaleKeys
            .newBookingsAreWaitingYouGoToResturantDashboardAndExploreMore
            .tr(),
        route: Routes.RestaurantDashboard,
        restaurantId: state.isResturant!.restaurantId);
  }
}
