import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/features/carpool/avaliable_routes/domain/entities/get_all_trips_entity.dart';
import 'package:fourtyninehub/features/carpool/avaliable_routes/presentation/widgets/available_routes_point_widget.dart';

class AvilableRoutesBarInfo extends StatelessWidget {
  const AvilableRoutesBarInfo({
    super.key,
    required this.entity,
  });

  final CarpoolTripParam entity;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300.h,
      child: Row(
        children: [
          Expanded(
            child: AvailableRoutesPointInfo(
                seatId: "first",
                tripId: entity.id,
                userLocation: const [40.0333486, -3.925665899999999],
                isComfort: entity.comfort,
                price: entity.priceForEveryUser,
                dotNumber: 1,
                status: entity.locations[0].booked ? 'Booked' : 'Free',
                gender: entity.locations[0].bookedUser?.gender ?? "NA"),
          ),
          Expanded(
            child: AvailableRoutesPointInfo(
                isComfort: entity.comfort,
                price: entity.priceForEveryUser,
                seatId: "second",
                tripId: entity.id,
                userLocation: const [40.0333486, -3.925665899999999],
                dotNumber: 2,
                status: entity.locations[1].booked ? 'Booked' : 'Free',
                gender: entity.locations[1].bookedUser?.gender ?? "NA"),
          ),
          Expanded(
            child: AvailableRoutesPointInfo(
                isComfort: entity.comfort,
                price: entity.priceForEveryUser,
                dotNumber: 3,
                seatId: "third",
                tripId: entity.id,
                userLocation: const [40.0333486, -3.925665899999999],
                status: entity.locations[2].booked ? 'Booked' : 'Free',
                gender: entity.locations[2].bookedUser?.gender ?? "NA"),
          ),
          Expanded(
            child: AvailableRoutesPointInfo(
              seatId: "",
              tripId: "",
              userLocation: const [40.0333486, -3.925665899999999],
              isComfort: entity.comfort,
              price: entity.priceForEveryUser,
              dotNumber: 4,
              status: '',
              inProgress: true,
            ),
          ),
        ],
      ),
    );
  }
}
