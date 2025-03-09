import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../../../../core/widget/custom_scaffold.dart';
import '../createOrder/map_picker.dart';
import 'offer_card.dart';
import 'offer_control.dart';

class WaitingOffers extends StatelessWidget {
  const WaitingOffers({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: Column(
        children: [
          Expanded(
              child: Stack(
            children: [
              Positioned.fill(
                child: MapPicker(
                  showAddress: false,
                  onMoving: (CameraPosition v) {
                    // controller.fromLocation.value = LatLng(v.target.latitude, v.target.longitude);
                  },

                  // onAddressPicked: (String v){
                  //   // controller.fromAddress.value = v;
                  // },
                ),
              ),
              Positioned.fill(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(.2),
                  ),
                  child: RefreshIndicator(
                    onRefresh: () async {},
                    child: ListView.builder(
                        itemCount: 3,
                        itemBuilder: (context, index) {
                          return const OfferCard();
                        }),
                  ),
                ),
              )
            ],
          )),
          const OfferControl(),
        ],
      ),
    );
  }
}
