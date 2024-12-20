import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/review_ride_trip_model.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class TripRatingRideScreen extends StatelessWidget {
  const TripRatingRideScreen({super.key, required this.model});
  final ReviewRideTripModel model;
  @override
  Widget build(BuildContext context) {
    return SharedScaffold(
      mainCategoryId: 1,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                    // border: Border.all(color: Colors.red)
                    ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(model.fullName),
                        const Spacer(),
                        const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        Text(model.averageRating.toString()),
                        Text(
                          "(${model.numberOfReviewers})",
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: NetworkImage(
                                    UIConst.profilePlaceHolder,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                                "${LocaleKeys.driver.tr()}(${model.driver.toStringAsFixed(0) ?? 0})"),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                                "${LocaleKeys.trip.tr()}(${model.trip.toStringAsFixed(0) ?? 0})"),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                                "${LocaleKeys.service.tr()}(${model.service.toStringAsFixed(0) ?? 0})"),
                          ],
                        ),
                        const SizedBox(
                          width: 3,
                        ),
                        ...List.generate(
                          model.comments.length,
                          (index) => Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            child: Text(
                              model.comments[index] ?? "",
                              style: Styles.mediumText(),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}