import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/default_button.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/all_trip_model/all_trip_model.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/widgets/trip_card.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class RequestDetialsScreen extends StatelessWidget {
  const RequestDetialsScreen({super.key, required this.model});
  final AllTripModel model;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
