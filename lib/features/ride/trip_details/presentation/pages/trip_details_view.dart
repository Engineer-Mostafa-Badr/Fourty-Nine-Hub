import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/ride/trip_details/presentation/cubit/trip_details_cubit.dart';
import 'package:fourtyninehub/features/ride/trip_details/presentation/widgets/trip_details.dart';

class TripDetailsView extends StatelessWidget {
  const TripDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TripDetailsCubit, TripDetailsState>(
        builder: (context, state) {
      return state.trip == null
          ? const Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : TripDetailsWidget(trip: state.trip!);
    });
  }
}
