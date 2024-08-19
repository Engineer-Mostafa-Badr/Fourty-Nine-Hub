// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/trip_join/domain/usecases/fetch_location_cordinates_usecase.dart';
import 'package:fourtyninehub/features/trip_join/presentation/views/widgets/trip_join_body.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';

class TripJoinView extends StatelessWidget {
  const TripJoinView({super.key});

  @override
  Widget build(BuildContext context) {
    serviceLocator<FetchLocationCordinatesUseCase>().call(address: 'المنصورة شارع سامية الجمل بجوار قصر البارون');
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
