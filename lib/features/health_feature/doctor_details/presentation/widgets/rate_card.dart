import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/review_card.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/domain/entities/user_doctor_rate.dart';
import 'package:fourtyninehub/features/ride/RideRequest/domain/entity/driver_review_entity.dart';

class UserDoctorRateCard extends StatelessWidget {
  final UserDoctorRateEntity rate;
  const UserDoctorRateCard({super.key, required this.rate});

  @override
  Widget build(BuildContext context) {
    return ReviewCard(
      review: ReviewEntity(
        comment: rate.comment,
        name: rate.userName,
        rate: rate.rate,
        createdAt: rate.createdAt??'',
        id: rate.id,
      ),
    );
  }
}
