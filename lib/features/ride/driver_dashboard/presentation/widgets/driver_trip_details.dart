import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fourtyninehub/common/widgets/stateful/maps/map_picker.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/ride/driver_dashboard/domain/usecases/create_rider_offer_usecase.dart';
import 'package:go_router/go_router.dart';

import '../../../../../common/functions/helper/launch_url.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../../common/widgets/stateless/buttons/iconAppButton.dart';
import '../../../../../common/widgets/stateless/buttons/progress_button.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../../requests_history/data/models/trip_model.dart';

class DriverTripDetails extends StatelessWidget {
  final TripModel trip;
  final Function(CreateRiderOfferParams) createOffer;
  final Function(String) acceptRide;
  const DriverTripDetails(
      {super.key,
      required this.trip,
      required this.acceptRide,
      required this.createOffer});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Container(
      height: height * .8,
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(10), topLeft: Radius.circular(10))),
      child: Column(
        children: [
          Expanded(
              child: MapPicker(
            lat: trip.fromCoordinates[0],
            lng: trip.fromCoordinates[1],
            destLat: trip.toCoordinates[0],
            destLng: trip.toCoordinates[1],
          )),
          const Sizer(),
          Row(
            children: [
              const Icon(FontAwesomeIcons.car, color: AppColors.PRIMARY_COLOR),
              const Sizer(),
              Label(
                text: context.isArabic?trip.category?.nameAr ?? "":trip.category?.nameEn ?? "",
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
          const Sizer(),
          ProgressButton(
            label: 'Accept',
            width: double.infinity,
            onPressed: () => acceptRide(trip.id),
          ),
          const Sizer(),
          const Label(text: 'Offer your price'),
          const Sizer(),
          Row(
            children: [
              Expanded(
                  child: AppButton(
                      label:
                          '${(trip.price) + offerIncreaseValue(price: trip.price)} L.E',
                      onPressed: () {
                        createOffer(CreateRiderOfferParams(
                            tripId: trip.id,
                            price: (trip.price) +
                                offerIncreaseValue(price: trip.price),
                            lat: 50.00,
                            lng: 30.450));
                      })),
              const Sizer(),
              Expanded(
                  child: AppButton(
                      label:
                          '${(trip.price) + offerIncreaseValue(price: trip.price) * 2} L.E',
                      onPressed: () {
                        createOffer(CreateRiderOfferParams(
                            tripId: trip.id,
                            price: (trip.price) +
                                offerIncreaseValue(price: trip.price * 2),
                            lat: 50.00,
                            lng: 30.450));
                      })),
              const Sizer(),
              Expanded(
                  child: AppButton(
                      label:
                          '${(trip.price) + offerIncreaseValue(price: trip.price) * 3} L.E',
                      onPressed: () {
                        createOffer(CreateRiderOfferParams(
                            tripId: trip.id,
                            price: (trip.price) +
                                offerIncreaseValue(price: trip.price * 3),
                            lat: 50.00,
                            lng: 30.450));
                      })),
            ],
          ),
          const Sizer(),
          AppButton(
              backColor: Colors.grey.withAlpha(30),
              textColor: Colors.black,
              label: 'Close',
              onPressed: () => context.pop())
        ],
      ),
    );
  }
}

int offerIncreaseValue({
  num? price,
}) {
  return double.parse('${(price ?? 0) / 7}').toInt();
}
