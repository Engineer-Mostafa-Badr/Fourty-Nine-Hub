import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/trip_join/trip_join_requests_history/presentation/cubits/delete_trips/delete_trips_cubit.dart';
import 'package:fourtyninehub/features/trip_join/trip_join_requests_history/presentation/cubits/fetch_my_trip_join_ads/fetch_my_trip_join_ads_cubit.dart';
import 'package:fourtyninehub/features/trip_join/trip_join_requests_history/presentation/widgets/trip_join_request_body.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';

class TripJoinRequestView extends StatelessWidget {
  const TripJoinRequestView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<FetchMyTripJoinAdsCubit>(
          create: (context) => FetchMyTripJoinAdsCubit(fetchMyTripJoinAdsUseCase: serviceLocator()),
        ),
        BlocProvider<DeleteTripsCubit>(
          create: (context) => DeleteTripsCubit(deleteTripUseCase: serviceLocator()),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<FetchMyTripJoinAdsCubit, FetchMyTripJoinAdsState>(
            listener: (context, state) {
              if (state is FetchMyTripJoinAdsFailed) {
                showErrorMessage(context, state.message);
              }
            },
          ),
          BlocListener<DeleteTripsCubit, DeleteTripsState>(
            listener: (context, state) {
              if (state is DeleteTripsFailed) {
                showErrorMessage(context, state.message);
              }
            },
          ),
        ],
        child: const TripJoinRequestBody(),
      ),
    );
  }
}
