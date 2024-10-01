// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/presentation/views/widgets/trip_join_body.dart';
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
    // context.read<FetchCarBrandsCubit>().fetchCarBrand(search: 'niss');
    // serviceLocator<FetchCarYearTypeUseCase>().call(brand: 'Toyota', model: 'Corolla');
    return Scaffold(
      appBar: AppBar(
        title: Transform(
          transform: Matrix4.translationValues(-20.0, 0.0, 0.0),
          child: Text(
            LocaleKeys.tripJoin.localize,
            style: Styles.headerText(),
          ),
        ),
      ),
      body: const TripJoinBody(),
    );
  }
}
