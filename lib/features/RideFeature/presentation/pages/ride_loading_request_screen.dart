import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/dashboards/widgets/truk_bus_widget.dart';

import '../../../../common/widgets/stateless/labels/label.dart';
import '../../../../core/localization/locale_keys.g.dart';

class RideLoadingRequestScreen extends StatefulWidget {
  const RideLoadingRequestScreen({super.key});

  @override
  State<RideLoadingRequestScreen> createState() => _RideLoadingRequestScreenState();
}

class _RideLoadingRequestScreenState extends State<RideLoadingRequestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          scrolledUnderElevation: 0,
          leadingWidth: 30,
          title: Label(
              text: LocaleKeys.rideDetails.tr(),
              style:
                  const TextStyle(fontWeight: FontWeight.w600, fontSize: 20))),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.separated(
            itemBuilder: (context, index) => const TrukBusWidget(),
            separatorBuilder:(context, index) =>  const SizedBox(height: 5),
            itemCount: 10),
      ),
    );
  }
}
