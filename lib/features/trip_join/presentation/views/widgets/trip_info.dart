import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/features/trip_join/presentation/cubits/fetch_price_distance/fetch_price_distance_cubit.dart';
import 'package:fourtyninehub/features/trip_join/presentation/cubits/trip_join_view/trip_join_view_cubit.dart';
import 'package:fourtyninehub/features/trip_join/presentation/views/widgets/card.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class TripInfoBuilder extends StatelessWidget {
  const TripInfoBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FetchPriceDistanceCubit, FetchPriceDistanceState>(
      buildWhen: (previous, current) => current is FetchPriceDistanceSuccess,
      builder: (context, state) {
        if (state is FetchPriceDistanceSuccess) {
          return TripInfo(
            distance: state.tripInfoEntity.distance ?? 0,
            price: state.tripInfoEntity.price ?? 0,
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}

class TripInfo extends StatelessWidget {
  const TripInfo({
    super.key,
    required this.distance,
    required this.price,
  });
  final double distance;
  final double price;
  final double totalPrice = 0;

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      title: 'Trip Info',
      children: [
        const Sizer(),
        Row(
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.directions_car, color: AppColors.SECONDARY_COLOR),
                Sizer(),
                Icon(Icons.money, color: AppColors.SECONDARY_COLOR),
                Sizer(),
                Icon(Icons.hail, color: AppColors.SECONDARY_COLOR),
              ],
            ),
            const Sizer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Distance',
                  style: Styles.headerText(),
                ),
                const Sizer(),
                Text(
                  'Total Trip Price',
                  style: Styles.headerText(),
                ),
                const Sizer(),
                Text(
                  'Price/Passenger',
                  style: Styles.headerText(),
                ),
              ],
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _formatDistance(),
                  style: Styles.headerText(),
                ),
                const Sizer(),
                BlocBuilder<TripJoinViewCubit, TripJoinViewState>(
                  buildWhen: (previous, current) => current is TripJoinViewSeatNumberState,
                  builder: (context, state) {
                    double totalPrice = context.read<TripJoinViewCubit>().numberOfSeats * price;
                    return Text(
                      '$totalPrice',
                      style: Styles.headerText(),
                    );
                  },
                ),
                const Sizer(),
                Text(
                  '$price',
                  style: Styles.headerText(),
                ),
              ],
            ),
          ],
        ),
        Text('You will take this price for every passenger join this trip with you', style: Styles.mediumText()),
        const Sizer(),
      ],
    );
  }

  String _formatDistance() {
    return '${(distance / 1000).toStringAsFixed(1)} KM';
  }
}
