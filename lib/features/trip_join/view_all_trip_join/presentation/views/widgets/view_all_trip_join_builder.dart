import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/cubits/view_all_trip_join_cubit/view_all_trip_join_cubit.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/widgets/available_trip_card.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/widgets/available_trips_card_loading.dart';

class ViewAllTripJoinCardBuilder extends StatefulWidget {
  const ViewAllTripJoinCardBuilder({
    super.key,
  });

  @override
  State<ViewAllTripJoinCardBuilder> createState() => _ViewAllTripJoinCardBuilderState();
}

class _ViewAllTripJoinCardBuilderState extends State<ViewAllTripJoinCardBuilder> {
  late final ViewAllTripJoinCubit viewAllTripJoinCubit;

  @override
  void initState() {
    viewAllTripJoinCubit = context.read<ViewAllTripJoinCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ViewAllTripJoinCubit, ViewAllTripJoinState>(
      builder: (context, state) {
        return ListView.builder(
          itemCount: viewAllTripJoinCubit.tripJoinCards.length + 1,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            if (index < viewAllTripJoinCubit.tripJoinCards.length) {
              return AvailableTripCard(
                tripJoinCardEntity: viewAllTripJoinCubit.tripJoinCards[index],
              );
            }
            return state is ViewAllTripJoinLoading && !viewAllTripJoinCubit.noMoreDataInDatabase
                ? const AvailableTripCardLoadingList()
                : const SizedBox();
          },
        );
      },
    );
  }
}
