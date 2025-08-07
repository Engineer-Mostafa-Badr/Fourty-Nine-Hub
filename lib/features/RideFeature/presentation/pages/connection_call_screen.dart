import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/ride_status_screen.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

import 'widgets/map_section.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

class ConnectionCallScreen extends StatelessWidget {
  const ConnectionCallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Stack(
        children: [
          MapSection(),
          Align(
            alignment: Alignment.bottomCenter,
            child: CallCard(),
          ),
        ],
      ),
    );
  }
}

class CallCard extends StatelessWidget {

  final driverName = 'Mohamed';
  final driverRating = 8.2;
  final driverImage =
      'https://maps.gstatic.com/tactile/pane/default_geocode-2x.png';

  const CallCard({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 60,
                height: 60,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Container(
                    height: 30,
                    width: 30,
                    alignment: Alignment.center,
                    decoration:const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.DIVIDER_GRAY_COLOR
                    ),
                    child: const Icon(Icons.close,color: AppColors.black,),
                  )
                ],),
              ),
              const Expanded(
                child: Text(
                  "Connecting  Mohamed",
                  textAlign: TextAlign.end,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),

              buildDriverCircle(driverImageUrl: driverImage,driverName: driverName, driverRating: driverRating, context: context,),

            ],
          ),
          const SizedBox(height: 8),

          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.buttonDialog,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
      ManageVibration.vibrate();
              context.push(Routes.safetyRideScreen);

            },
            child:  Center(child: Text(LocaleKeys.freeCall.localize)),
          ),
          const SizedBox(height: 14),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[200],
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
      ManageVibration.vibrate();
              context.push(Routes.safetyRideScreen);
            },
            child:  Center(child: Text(LocaleKeys.regularCall.localize)),
          ),
        ],
      ),
    );
  }
}