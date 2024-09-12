import 'package:flutter/material.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

class AvailableTripsFloatingActionButton extends StatelessWidget {
  const AvailableTripsFloatingActionButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 10,
      right: 10,
      child: FloatingActionButton(
        onPressed: () {
          context.push(Routes.TRIP_JOIN);
        },
        backgroundColor: AppColors.PRIMARY_COLOR,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
