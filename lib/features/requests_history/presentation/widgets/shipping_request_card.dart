import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/text_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/requests_history/data/models/shipping_request_model/shipping_request_model.dart';
import 'package:go_router/go_router.dart';
import 'package:google_static_maps_controller/google_static_maps_controller.dart';
import '../../../../common/widgets/stateful/maps/static_map.dart';
import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';
import '../../../../routes/routes.dart';

class ShippingRequestCard extends StatelessWidget {
  final ShippingRequestModel trip;
  const ShippingRequestCard({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push(Routes.TRIPDETAILS),
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
                  text: trip.category.name,
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
                  TextAppButton(label: LocaleKeys.offers.localize, onPressed: () {}),
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
