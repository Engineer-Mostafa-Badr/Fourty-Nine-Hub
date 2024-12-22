import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/features/carpool/avaliable_routes/domain/entities/get_all_trips_entity.dart';
import 'package:fourtyninehub/features/carpool/avaliable_routes/presentation/widgets/available_routes_point_widget.dart';
import 'package:fourtyninehub/features/carpool/avaliable_routes/presentation/widgets/get_current_location_driver.dart';

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
                tripStatus: entity.tripStatus ?? "",
                entity: entity,
                defaultGender: entity.locations[0].gender ?? "male",
                createdAt: entity.createdAt,
                seatId: "first",
                tripId: entity.id,
                userLocation: [
                  GetCurrentLocationDriver.position?.latitude ?? 0,
                  GetCurrentLocationDriver.position?.longitude ?? 0
                ],
                isComfort: entity.comfort,
                price: entity.priceForEveryUser,
                dotNumber: 1,
                otpVerified: entity.locations[0].verifiedOtp,
                status: entity.locations[0].booked ? 'Booked' : 'Free',
                gender: entity.locations[0].bookedUser?.gender ?? "NA"),
          ),
          Expanded(
            child: AvailableRoutesPointInfo(
                tripStatus: entity.tripStatus ?? "",
                entity: entity,
                defaultGender: entity.locations[1].gender ?? "male",
                createdAt: entity.createdAt,
                isComfort: entity.comfort,
                price: entity.priceForEveryUser,
                seatId: "second",
                tripId: entity.id,
                userLocation: [
                  GetCurrentLocationDriver.position?.latitude ?? 0,
                  GetCurrentLocationDriver.position?.longitude ?? 0
                ],
                dotNumber: 2,
                otpVerified: entity.locations[1].verifiedOtp,
                status: entity.locations[1].booked ? 'Booked' : 'Free',
                gender: entity.locations[1].bookedUser?.gender ?? "NA"),
          ),
          Expanded(
            child: AvailableRoutesPointInfo(
                defaultGender: entity.locations[2].gender ?? "male",
                tripStatus: entity.tripStatus ?? "",
                entity: entity,
                otpVerified: entity.locations[2].verifiedOtp,
                createdAt: entity.createdAt,
                isComfort: entity.comfort,
                price: entity.priceForEveryUser,
                dotNumber: 3,
                seatId: "third",
                tripId: entity.id,
                userLocation: [
                  GetCurrentLocationDriver.position?.latitude ?? 0,
                  GetCurrentLocationDriver.position?.longitude ?? 0
                ],
                status: entity.locations[2].booked ? 'Booked' : 'Free',
                gender: entity.locations[2].bookedUser?.gender ?? "NA"),
          ),
          Expanded(
            child: AvailableRoutesPointInfo(
              tripStatus: entity.tripStatus ?? "",
              otpVerified: false,
              defaultGender: "",
              entity: entity,
              createdAt: entity.createdAt,
              seatId: "",
              tripId: "",
              userLocation: [
                GetCurrentLocationDriver.position?.latitude ?? 0,
                GetCurrentLocationDriver.position?.longitude ?? 0
              ],
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
