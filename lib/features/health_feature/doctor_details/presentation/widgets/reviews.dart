import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/elevated_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/review_card.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/presentation/widgets/divider.dart';
import 'package:fourtyninehub/features/ride/RideRequest/domain/entity/driver_review_entity.dart';
import 'package:fourtyninehub/res/strings/labels.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class DoctorDetailsReviewsWidget extends StatelessWidget {
  const DoctorDetailsReviewsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // final doctorDetailsCubit = context.read<DoctorDetailsCubit>();
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Labels.patientsReviews,
            style: Styles.headerText(),
          ),
          // SizedBox(height: 8),
          // Text('Overall rating from 757 visitors'),
          // SizedBox(height: 8),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     RatingCard(title: 'Doctor rating', rating: 4.5),
          //     RatingCard(title: 'Overall Rating', rating: 4.5),
          //   ],
          // ),
          const Sizer(height: 20),
          SizedBox(
            height: 300,
            child: ListView.separated(
              itemCount: 5,
              separatorBuilder: (context, index) =>
                  const DoctorDetailsDivider(),
              itemBuilder: (context, index) => ReviewCard(
                  review: ReviewEntity(
                      comment: "تم العثور على الدكتور كويس بالتقييم 4.5",
                      name: "عبير م.",
                      rate: 4.5,
                      createdAt: "23 July 2024",
                      id: '')),
            ),
          ),
          const Sizer(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedAppButton(
                  onPressed: () {
                    // Handle view more action
                  },
                  
                  label: Labels.viewMore,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
