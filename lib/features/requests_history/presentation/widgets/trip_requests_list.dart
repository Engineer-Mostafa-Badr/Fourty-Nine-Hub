import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/appbar/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';

import '../../../../common/widgets/dynamic/sizer.dart';
import '../../../../res/strings/labels.dart';
import '../../../ride/trip_details/domain/entities/trip_request_entity.dart';

class TripRequestsList extends StatelessWidget {
  final List<TripRequestEntity> requests;
  const TripRequestsList({super.key, required this.requests});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(
        label: Labels.requestsHistory,
      ),
      body: ListView.builder(
          itemCount: requests.length,
          itemBuilder: (context, index) {
            return _buildRequestCard(request: requests[index]);
          }),
    );
  }

  Widget _buildRequestCard({required TripRequestEntity request}) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Label(text: request.user?.fullName ?? ''),
          Label(text: request.phone),
          Row(
            children: [
              Expanded(child: AppButton(label: 'Reject', onPressed: () {})),
              const Sizer(),
              Expanded(
                  child: AppButton(
                      label: 'Accept',
                      backColor: Colors.green,
                      onPressed: () {})),
            ],
          )
        ],
      ),
    );
  }
}
