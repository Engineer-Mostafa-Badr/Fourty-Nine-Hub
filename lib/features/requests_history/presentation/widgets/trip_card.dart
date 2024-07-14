import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/text_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/requests_history/domain/entities/trip_entity.dart';
import 'package:google_static_maps_controller/google_static_maps_controller.dart';

import '../../../../common/widgets/stateful/maps/static_map.dart';
import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';

import '../../../ride/trip_details/domain/entities/trip_request_entity.dart';
import '../../../ride/trip_details/presentation/widgets/trip_details.dart';
import 'trip_requests_list.dart';

class TripCard extends StatelessWidget {
  final TripEntity trip;
  final List<TripRequestEntity>? requests;
  const TripCard({super.key, required this.trip, this.requests});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => bottomSheet(
          context: context,
          isScrollControlled: true,
          widget: TripDetailsWidget(
            trip: trip,
          )),
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: .5),
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
            if (trip.offers.isNotEmpty)
              Row(
                children: [
                  TextAppButton(label: 'Offers', onPressed: () {}),
                  const Sizer(),
                  Expanded(
                    child: SizedBox(
                      height: kToolbarHeight * .5,
                      child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            final offer = trip.offers[index];
                            return CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 10,
                              backgroundImage:
                                  NetworkImage(offer.profileImage ?? ''),
                            );
                          },
                          separatorBuilder: (context, index) =>
                              const SizedBox(),
                          itemCount: trip.offers.length),
                    ),
                  ),
                ],
              ),
            const Sizer(),
            if (requests?.isNotEmpty ?? false)
              RichText(
                text: TextSpan(children: [
                  TextSpan(
                      text: 'Requests: ',
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          bottomSheet(
                              isScrollControlled: true,
                              context: context,
                              widget: TripRequestsList(
                                requests: requests ?? [],
                              ));
                        },
                      style: Styles.mediumText()),
                  ...requests?.map((e) {
                        return TextSpan(
                            text: '${e.user?.fullName ?? ''} ,',
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                bottomSheet(
                                    isScrollControlled: true,
                                    context: context,
                                    widget: TripRequestsList(
                                      requests: requests ?? [],
                                    ));
                              },
                            style: Styles.mediumText(
                                color: AppColors.PRIMARY_COLOR));
                      }).toList() ??
                      []
                ]),
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
            )
          ],
        ),
      ),
    );
  }
}
