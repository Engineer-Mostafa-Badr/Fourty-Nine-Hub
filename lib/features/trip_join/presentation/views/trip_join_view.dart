// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/trip_join/presentation/cubits/fetch_car_models/fetch_car_models_cubit.dart';
import 'package:fourtyninehub/features/trip_join/presentation/views/widgets/trip_join_body.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class TripJoinView extends StatelessWidget {
  const TripJoinView({super.key});

  @override
  Widget build(BuildContext context) {
    // serviceLocator<FetchLocationCordinatesUseCase>().call(address: 'المنصورة شارع سامية الجمل بجوار قصر البارون');
    // context.read<StartingLocationCubit>().getStartingLocation(address: 'المنصورة شارع سامية الجمل بجوار قصر البارون');
    // context
    //     .read<DestinationLocationCubit>()
    //     .getDestinationLocation(address: 'المنصورة شارع الجمهورية بجوار قصر البارون');
    // serviceLocator<FetchPriceDistanceUsecase>().call(
    //   startLocation: const LatLng(29.962565, 31.261392),
    //   destiantionLocation: const LatLng(30.098281, 31.329383),
    // );
    // context.read<FetchCarBrandsCubit>().fetchCarBrand(search: 'niss');
    context.read<FetchCarModelsCubit>().fetchCarModel(brand: 'Nissan');
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
