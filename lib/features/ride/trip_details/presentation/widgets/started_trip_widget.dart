import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/requests_history/domain/entities/trip_entity.dart';
import 'package:google_static_maps_controller/google_static_maps_controller.dart';

import '../../../../../common/functions/helper/launch_url.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateful/maps/static_map.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';

import '../../../../../common/widgets/stateless/buttons/iconAppButton.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/widget/custom_scaffold.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../../requests_history/data/models/driver_model.dart';

class StartedTripWidget extends StatelessWidget {
  final TripEntity trip;
  const StartedTripWidget({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: const BackAppBar(
        label: 'Trip Details',
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            if (trip.driver != null) _buildDriverWidget(driver: trip.driver!),
            const Divider(),
            _buildTripInfoWidget(trip: trip, context: context),
          ],
        ),
      ),
    );
  }

  Widget _buildDriverWidget({required DriverModel driver}) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: Colors.white,
          backgroundImage: NetworkImage(driver.profileImage),
        ),
        const Sizer(),
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Label(text: driver.name),
            Row(
              children: [
                const Icon(Icons.star_rounded, color: AppColors.ACCENT_COLOR),
                Label(
                  text: ' ${driver.rate} . ${driver.numberOfReviews} Reviews',
                  style: Styles.mediumText(color: AppColors.ACCENT_COLOR),
                ),
              ],
            )
          ],
        )),
        IconAppButton(icon: Icons.call, isCircle: true, onPressed: () {}),
        IconAppButton(
            icon: Icons.directions,
            isCircle: true,
            onPressed: () => LaunchURLHelper().openLocation(
                lat: driver.location[0], lng: driver.location[1])),
      ],
    );
  }

  Widget _buildTripInfoWidget(
      {required TripEntity trip, required BuildContext context}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Row(
          children: [
            const Icon(FontAwesomeIcons.car, color: AppColors.PRIMARY_COLOR),
            const Sizer(),
            Label(
              text: context.isArabic
                  ? trip.category?.nameAr ?? ''
                  : trip.category?.nameEn ?? "",
              style: Styles.mediumText(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        InkWell(
          onTap: () => LaunchURLHelper().openLocation(
              lat: trip.fromCoordinates[0], lng: trip.fromCoordinates[1]),
          child: Row(
            children: [
              const Icon(
                Icons.location_searching,
                color: AppColors.PRIMARY_COLOR,
              ),
              const Sizer(),
              Expanded(child: Label(text: trip.fromAddress)),
              IconAppButton(
                  icon: Icons.directions,
                  color: Colors.green,
                  onPressed: () => LaunchURLHelper().openLocation(
                      lat: trip.fromCoordinates[0],
                      lng: trip.fromCoordinates[1]))
            ],
          ),
        ),
        InkWell(
          onTap: () => LaunchURLHelper().openLocation(
              lat: trip.toCoordinates[0], lng: trip.toCoordinates[1]),
          child: Row(
            children: [
              const Icon(
                Icons.location_on,
                color: AppColors.SECONDARY_COLOR,
              ),
              const Sizer(),
              Expanded(child: Label(text: trip.toAddress)),
              IconAppButton(
                  icon: Icons.directions,
                  color: Colors.green,
                  onPressed: () => LaunchURLHelper().openLocation(
                      lat: trip.toCoordinates[0], lng: trip.toCoordinates[1]))
            ],
          ),
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
        const Divider(),
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
        )
      ],
    );
  }
}
