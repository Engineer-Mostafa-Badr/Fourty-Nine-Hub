// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/trip_join/presentation/cubits/destination_location/destination_location_cubit.dart';
import 'package:fourtyninehub/features/trip_join/presentation/cubits/starting_location/starting_location_cubit.dart';
import 'package:fourtyninehub/features/trip_join/presentation/views/widgets/trip_join_body.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class TripJoinView extends StatelessWidget {
  const TripJoinView({super.key});

  @override
  Widget build(BuildContext context) {
    // serviceLocator<FetchLocationCordinatesUseCase>().call(address: 'المنصورة شارع سامية الجمل بجوار قصر البارون');
    context.read<StartingLocationCubit>().getStartingLocation(address: 'المنصورة شارع سامية الجمل بجوار قصر البارون');
    context
        .read<DestinationLocationCubit>()
        .getDestinationLocation(address: 'المنصورة شارع الجمهورية بجوار قصر البارون');
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Trip Join',
          style: Styles.headerText(fontSize: 24),
        ),
      ),
      body: const TripJoinBody(),
    );
  }
}
