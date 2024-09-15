import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/profile_image.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/requests_history/data/models/offer_model.dart';

import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';

class OfferRideCard extends StatelessWidget {
  final OfferModel offer;
  const OfferRideCard({super.key, required this.offer});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          ProfileImage(
            accountId: 0,
            size: 20,
            imageURL: offer.profileImage,
            userId: '',
          ),
          Sizer(),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Label(
                text: offer.name ?? '',
                style: Styles.mediumText(fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  const Icon(
                    Icons.star_rounded,
                    color: AppColors.ACCENT_COLOR,
                  ),
                  Label(
                    text: ' ${offer.rate} . ${offer.numberOfReviews} Review',
                    style: Styles.mediumText(color: AppColors.ACCENT_COLOR),
                  )
                ],
              ),
              RichText(
                  text: TextSpan(children: [
                TextSpan(
                    text: '${offer.price} L.E ',
                    style: Styles.headerText(color: AppColors.PRIMARY_COLOR)),
                TextSpan(
                    text: '${offer.distance} ${offer.time} away',
                    style: Styles.mediumText())
              ])),
            ],
          )),
          AppButton(
              label: 'Accept', padding: 5, icon: Icons.check, onPressed: () {})
        ],
      ),
    );
  }
}
