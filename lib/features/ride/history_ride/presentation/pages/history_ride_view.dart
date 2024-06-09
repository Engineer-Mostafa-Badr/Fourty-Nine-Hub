import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/appbar/back_appbar.dart';
import 'package:fourtyninehub/features/ride/history_ride/presentation/cubit/history_ride_cubit.dart';
import 'package:fourtyninehub/features/ride/history_ride/presentation/widgets/trip_card.dart';

class HistoryRideView extends StatelessWidget {
  const HistoryRideView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<HistoryRideCubit>();
    return BlocBuilder<HistoryRideCubit, HistoryRideState>(
        builder: (context, state) {
      return Scaffold(
        appBar: const BackAppBar(
          label: 'Trips History',
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: RefreshIndicator(
            onRefresh: () async => controller.loadData(),
            child: state.isLoading
                ? const Center(
                    child: CircularProgressIndicator.adaptive(),
                  )
                : ListView.separated(
                    itemCount: state.trips?.length ?? 0,
                    separatorBuilder: (context, index) => const Sizer(),
                    itemBuilder: (context, index) {
                      return TripCard(trip: state.trips![index]);
                    }),
          ),
        ),
      );
    });
  }
}
