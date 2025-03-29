import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../routes/routes.dart';
import 'available_ride_mode_widget.dart';

class PastTripsWidget extends StatelessWidget {
  final List<String> content;
  const PastTripsWidget({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return content.isEmpty
        ? _emptyMessage()
        : SingleChildScrollView(
            child: Column(
              children: [
                AvailableRideModeWidget(
                  onTap: () {
                    context.push(Routes.captainRideDetails);
                  },
                  cancelButton: false,
                  statusDriver: "Expired",
                  requestType: 'Regular',
                ),
                AvailableRideModeWidget(
                  onTap: () {},
                  statusDriver: "Expired",
                  requestType: 'Regular',
                ),
              ],
            ),
          );
  }
}

Widget _emptyMessage() {
  return const Center(
    child: Text(
      'Your running trip right now.',
      style: TextStyle(fontSize: 16, color: Colors.grey),
    ),
  );
}
