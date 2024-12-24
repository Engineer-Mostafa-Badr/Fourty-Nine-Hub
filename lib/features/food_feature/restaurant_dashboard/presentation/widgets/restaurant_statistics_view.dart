import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_dashboard/presentation/cubit/restaurant_dashboard_cubit.dart';

import '../../../../../res/style/styles.dart';

class RestaurantStatisticsView extends StatelessWidget {
  const RestaurantStatisticsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RestaurantDashboardCubit, RestaurantDashboardState>(
        builder: (context, state) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label(
          //   text: 'Statistics',
          //   style: Styles.headerText(),
          // ),
          Container(
            decoration: const BoxDecoration(
                // color: AppColors.PRIMARY_COLOR,
                borderRadius: BorderRadius.all(Radius.circular(6))),
            width: 1.sw,
            // height: 0.3.sw,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // crossAxisAlignment: WrapCrossAlignment.center,
              // alignment: WrapAlignment.center,
              children: [
                _buildStatisticColumn(
                    LocaleKeys.totalOrder.localize,
                    // 'Total Orders',
                    state.statistics!.data.totalOrders.toString()),
                _buildStatisticColumn(
                    // 'Total Revenue'
                    LocaleKeys.totalRevenue.localize,
                    state.statistics!.data.totalRevenue.ceil().toString()),
                _buildStatisticColumn(
                    // 'Avg Rating',
                    LocaleKeys.avgRating.localize,
                    state.statistics!.data.totalRating.toString()),
                _buildStatisticColumn(
                    LocaleKeys.review.localize,
                    // 'Reviews',
                    state.statistics!.data.numberOfReviews.toString()),
                _buildStatisticColumn(
                    LocaleKeys.subscriptionDeadline.localize,

                    // 'Subscription Deadline',
                    state.statistics!.data.deadLineSubscription.toString()),
                // Text(
                //   state.statistics!.data.totalRating.toString(),
                //   style: const TextStyle(color: Colors.white),
                // ),
                // Text(
                //   state.statistics!.data.deadLineSubscription
                //       .toString(),
                //   style: const TextStyle(color: Colors.white),
                // ),
                // Text(
                //   state.statistics!.data.numberOfReviews.toString(),
                //   style: const TextStyle(color: Colors.white),
                // ),
                // Text(
                //   state.statistics!.data.totalOrders.toString(),
                //   style: const TextStyle(color: Colors.white),
                // ),
                // Text(
                //   state.statistics!.data.totalRevenue.toString(),
                //   style: const TextStyle(color: Colors.white),
                // ),
              ],
            ),
          ),
        ],
      );
    });
  }

  Widget _buildStatisticColumn(String label, String value) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: Styles.mediumText(fontSize: 30),
          ),
          const Spacer(),
          Text(
            value,
            style: Styles.mediumText(fontSize: 30),
          ),
          SizedBox(
            width: 0.04.sw,
          )
        ],
      ),
    );
  }
}
