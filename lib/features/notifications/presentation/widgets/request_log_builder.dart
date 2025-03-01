import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/ride_widget.dart';

class RequestLogBuilder extends StatelessWidget {
  const RequestLogBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: RideWidget(),
        );
      },
    );
  }
}
