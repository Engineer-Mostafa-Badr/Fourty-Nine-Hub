import 'package:flutter/material.dart';
import '../../data/models/all_trip_model/all_trip_model.dart';
import '../widgets/trip_card.dart';

import '../../../../../core/widget/custom_scaffold.dart';

class RequestDetialsScreen extends StatelessWidget {
  const RequestDetialsScreen({super.key, required this.model});
  final AllTripModel model;
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          TripCardWidget(
            model: model,
            buttons: true,
          )
        ],
      ),
    );
  }
}
