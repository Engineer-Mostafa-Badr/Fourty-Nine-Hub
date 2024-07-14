import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateful/maps/map_picker.dart';
import 'package:fourtyninehub/common/widgets/stateless/appbar/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/iconAppButton.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/requests_history/domain/entities/trip_entity.dart';
import 'package:fourtyninehub/features/requests_history/presentation/widgets/offer_ride_card.dart';

import '../../../../../common/functions/helper/launch_url.dart';

import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../../requests_history/data/models/trip_model.dart';
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
        :  StartedTripWidget(trip: trip);
  }
}
