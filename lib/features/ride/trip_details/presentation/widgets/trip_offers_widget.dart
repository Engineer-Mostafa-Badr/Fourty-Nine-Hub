import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateful/maps/map_picker.dart';
import 'package:fourtyninehub/common/widgets/stateless/appbar/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/iconAppButton.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/requests_history/domain/entities/trip_entity.dart';
import 'package:fourtyninehub/features/requests_history/presentation/widgets/offer_ride_card.dart';

import '../../../../../common/functions/helper/launch_url.dart';

import '../../../../../core/messages/messages.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';

class TripOffersWidget extends StatelessWidget {
  final TripEntity trip;
  const TripOffersWidget({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: const BackAppBar(
        label: 'Trip Details',
      ),
      bottomSheet: Container(
        width: double.infinity,
        height: height / 3,
        padding: const EdgeInsets.all(10),
        // margin: const EdgeInsets.all(kToolbarHeight),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            color: Colors.white),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              children: [
                const Icon(FontAwesomeIcons.car,
                    color: AppColors.PRIMARY_COLOR),
                const Sizer(),
                Label(
                  text: trip.category?.name ?? '',
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
                          lat: trip.toCoordinates[0],
                          lng: trip.toCoordinates[1]))
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
            const Sizer(),
            AppButton(
                label: 'Cancel Trip',
                icon: Icons.clear,
                onPressed: () {
                  showErrorMessage(context, 'TODO');
                }),
          ],
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
              child: MapPicker(
            lat: trip.fromCoordinates[0],
            lng: trip.fromCoordinates[1],
            destLat: trip.toCoordinates[0],
            destLng: trip.toCoordinates[1],
          )),
          Positioned(
              right: 10,
              left: 10,
              top: 10,
              bottom: height / 2,
              child: Column(
                children: [
                  const LinearProgressIndicator(),
                  const Sizer(),
                  if (trip.offers.isNotEmpty)
                    Expanded(
                      child: ListView.separated(
                          itemBuilder: (context, index) => OfferRideCard(
                                offer: trip.offers[index],
                              ),
                          separatorBuilder: (context, index) => const Sizer(),
                          itemCount: trip.offers.length),
                    ),
                ],
              )),
        ],
      ),
    );
  }
}
