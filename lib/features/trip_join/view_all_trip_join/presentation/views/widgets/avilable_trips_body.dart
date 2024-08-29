import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/domain/entities/trip_join_card_entity.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/widgets/available_trip_card.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class AvailableTripsBody extends StatelessWidget {
  const AvailableTripsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                // 'These trips are for users who own cars and they want to share with other users ',
                'Users own cars/share the trip with them! ',
                style: Styles.headerText(color: AppColors.SECONDARY_COLOR, fontSize: 35),
                textAlign: TextAlign.start,
              ),
            ),
            AvailableTripCard(
              tripJoinCardEntity: TripJoinCardEntity(
                brand: 'Toyota',
                model: 'Corolla',
                publishDate: DateTime.fromMillisecondsSinceEpoch(1724952027000),
                seatNumber: 1,
                isRepeated: true,
                startingAddress: 'Cairo, Slaim Al Awal 21 (Zeitoun)',
                destinationAddress: 'Cairo, Slaim Al Awal 21 (Zeitoun)',
                isActive: true,
                price: 30,
                status: 'Premuim',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
