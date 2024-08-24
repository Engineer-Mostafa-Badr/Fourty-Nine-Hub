import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/trip_join/presentation/views/widgets/avilable_trips_body.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

class AvailableTripsView extends StatelessWidget {
  const AvailableTripsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // centerTitle: true,
        title: Text(
          'Available Trips',
          style: Styles.headerText(fontSize: 24),
        ),
      ),
      body: const AvailableTripsBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push(Routes.TRIP_JOIN);
        },
        backgroundColor: AppColors.PRIMARY_COLOR,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
