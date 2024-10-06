import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_dashboard/presentation/cubit/restaurant_statistics_cubit.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';

import '../../../../../res/style/styles.dart';

class RestaurantStatisticsView extends StatelessWidget {
  const RestaurantStatisticsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RestaurantStatisticsCubit(serviceLocator())
        ..fetchRestaurantStatistics(),
      child: Column(
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
            child: BlocBuilder<RestaurantStatisticsCubit,
                RestaurantStatisticsState>(
              builder: (context, statea) {
                final state = context.read<RestaurantStatisticsCubit>();
                if (state.restaurantStatistics != null) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // crossAxisAlignment: WrapCrossAlignment.center,
                    // alignment: WrapAlignment.center,
                    children: [
                      _buildStatisticColumn(
                          'Total Orders',
                          state.restaurantStatistics!.data.totalOrders
                              .toString()),
                      _buildStatisticColumn(
                          'Total Revenue',
                          state.restaurantStatistics!.data.totalRevenue
                              .ceil()
                              .toString()),
                      _buildStatisticColumn(
                          'Avg Rating',
                          state.restaurantStatistics!.data.totalRating
                              .toString()),
                      _buildStatisticColumn(
                          'Reviews',
                          state.restaurantStatistics!.data.numberOfReviews
                              .toString()),
                      _buildStatisticColumn(
                          'Subscription Deadline',
                          state.restaurantStatistics!.data.deadLineSubscription
                              .toString()),
                      // Text(
                      //   state.restaurantStatistics!.data.totalRating.toString(),
                      //   style: const TextStyle(color: Colors.white),
                      // ),
                      // Text(
                      //   state.restaurantStatistics!.data.deadLineSubscription
                      //       .toString(),
                      //   style: const TextStyle(color: Colors.white),
                      // ),
                      // Text(
                      //   state.restaurantStatistics!.data.numberOfReviews.toString(),
                      //   style: const TextStyle(color: Colors.white),
                      // ),
                      // Text(
                      //   state.restaurantStatistics!.data.totalOrders.toString(),
                      //   style: const TextStyle(color: Colors.white),
                      // ),
                      // Text(
                      //   state.restaurantStatistics!.data.totalRevenue.toString(),
                      //   style: const TextStyle(color: Colors.white),
                      // ),
                    ],
                  );
                } else {
                  return const Sizer();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticColumn(String label, String value) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              // fontSize: 14.sp,
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
          ),
          Spacer(),
          Text(
            value,
            style: const TextStyle(
              // fontSize: 16.sp,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            width: 0.06.sw,
          )
        ],
      ),
    );
  }
}
