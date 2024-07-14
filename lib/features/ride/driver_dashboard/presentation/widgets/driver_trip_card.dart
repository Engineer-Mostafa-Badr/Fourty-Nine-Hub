import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:go_router/go_router.dart';
import 'package:google_static_maps_controller/google_static_maps_controller.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateful/maps/static_map.dart';
import '../../../../../common/widgets/stateless/buttons/progress_button.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../routes/routes.dart';
import '../../../../requests_history/data/models/trip_model.dart';
import 'driver_trip_details.dart';

class DriverTripCard extends StatelessWidget {
  final TripModel trip;
  const DriverTripCard({super.key, required this.trip});
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key('${trip.fromAddress}-${trip.id}'),
      child: InkWell(
        onTap: () => bottomSheet(
            context: context,
            isScrollControlled: true,
            widget: DriverTripDetails(
              trip: trip,
            )),
        child: Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: .5),
              borderRadius: BorderRadius.circular(10)),
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(FontAwesomeIcons.car,
                      color: AppColors.PRIMARY_COLOR),
                  const Sizer(),
                  Label(
                    text: trip.category?.name??'',
                    style: Styles.mediumText(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(
                    Icons.location_searching,
                    color: AppColors.PRIMARY_COLOR,
                  ),
                  const Sizer(),
                  Expanded(child: Label(text: trip.fromAddress)),
                ],
              ),
              Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    color: AppColors.SECONDARY_COLOR,
                  ),
                  const Sizer(),
                  Expanded(child: Label(text: trip.toAddress)),
                ],
              ),
              const Divider(),
              Row(
                children: [
                  Expanded(
                      child: Row(
                    children: [
                      const Icon(Icons.monetization_on_rounded),
                      const Sizer(),
                      Label(text: '${trip.price} L.E')
                    ],
                  )),
                  Expanded(
                      child: Row(
                    children: [
                      const Icon(Icons.timer),
                      const Sizer(),
                      Label(text: trip.time.toString())
                    ],
                  )),
                  Expanded(
                      child: Row(
                    children: [
                      const Icon(Icons.add_road),
                      const Sizer(),
                      Label(text: trip.distance.toString())
                    ],
                  )),
                ],
              ),
              const Sizer(),
              StaticMapWidget(
                height: kToolbarHeight * 1.5,
                radius: 10,
                markers: [
                  Marker(locations: [
                    Location(trip.fromCoordinates[0], trip.fromCoordinates[1]),
                    Location(trip.toCoordinates[0], trip.toCoordinates[1]),
                  ])
                ],
                paths: [
                  Location(trip.fromCoordinates[0], trip.fromCoordinates[1]),
                  Location(trip.toCoordinates[0], trip.toCoordinates[1]),
                ],
              ),
              const Sizer(),
              ProgressButton(
                label: 'Accept',
                width: double.infinity,
                onPressed: () => context.push(Routes.TRIPDETAILS),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
