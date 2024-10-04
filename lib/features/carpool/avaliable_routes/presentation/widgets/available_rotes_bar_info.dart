import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/features/carpool/avaliable_routes/domain/entities/available_routes_card_entity.dart';
import 'package:fourtyninehub/features/carpool/avaliable_routes/presentation/widgets/available_routes_point_widget.dart';

class AvilableRoutesBarInfo extends StatelessWidget {
  const AvilableRoutesBarInfo({
    super.key,
    required this.entity,
  });

  final AvailableRoutesCardEntity entity;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300.h,
      child: Row(
        children: [
          Expanded(
            child: AvailableRoutesPointInfo(
              dotNumber: 1,
              status: entity.pointOne?.booked == true ? 'Booked' : 'Free',
              gender: entity.pointOne?.isMale == true ? 'male' : 'female',
            ),
          ),
          Expanded(
            child: AvailableRoutesPointInfo(
              dotNumber: 2,
              status: entity.pointTwo?.booked == true ? 'Booked' : 'Free',
              gender: entity.pointTwo?.isMale == true ? 'male' : 'female',
            ),
          ),
          Expanded(
            child: AvailableRoutesPointInfo(
              dotNumber: 3,
              status: entity.pointThree?.booked == true ? 'Booked' : 'Free',
              gender: entity.pointThree?.isMale == true ? 'male' : 'female',
            ),
          ),
          const Expanded(
            child: AvailableRoutesPointInfo(
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
