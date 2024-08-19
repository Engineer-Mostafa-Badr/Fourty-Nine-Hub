import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/requests_history/domain/entities/trip_entity.dart';


import 'started_trip_widget.dart';
import 'trip_offers_widget.dart';

class TripDetailsWidget extends StatelessWidget {
  final TripEntity trip;
  const TripDetailsWidget({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    return trip.showOffers
        ? TripOffersWidget(
            trip: trip,
          )
        : StartedTripWidget(trip: trip);
  }
}
