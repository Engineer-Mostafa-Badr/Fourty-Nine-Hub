import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/ride_widget.dart';

class RequestLogBuilder extends StatelessWidget {
  const RequestLogBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      itemCount: 10,
      itemBuilder: (context, index) {
        return const RideWidget();
      }, separatorBuilder: (BuildContext context, int index) =>const Sizer(),
    );
  }
}
