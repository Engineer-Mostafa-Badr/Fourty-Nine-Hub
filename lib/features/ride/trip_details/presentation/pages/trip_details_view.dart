import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/ride/trip_details/presentation/cubit/trip_details_cubit.dart';
import 'package:fourtyninehub/features/ride/trip_details/presentation/widgets/trip_details.dart';
import 'package:fourtyninehub/core/widget/custom_circular_progress_indicator.dart';

class TripDetailsView extends StatelessWidget {
  const TripDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TripDetailsCubit, TripDetailsState>(
        builder: (context, state) {
      return state.trip == null
          ? const Center(
              child: CustomCircularProgressIndicator(),
            )
          : TripDetailsWidget(trip: state.trip!);
    });
  }
}
