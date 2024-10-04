import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/functions/helper/lang_helper.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/get_requests_for_loading_model/get_requests_for_loading_model.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class TripRatingScreen extends StatelessWidget {
  const TripRatingScreen({super.key, required this.model});
  final GetRequestsForLoadingModel model;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
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
                        Text(
                            "${model.driverId?.userId?.firstName ?? ""} ${model.driverId?.userId?.lastName ?? ""}"),
                        const Spacer(),
                        const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        Text(
                            "${model.driverId?.review?.averageRating?.toStringAsFixed(1) ?? 0}"),
                        const Text(
                          "(1)",
                          style: TextStyle(color: Colors.grey),
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
                                "${"Rider".tr()}(${model.driverId?.review?.ratingDriver?.toStringAsFixed(0) ?? 0})"),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                                "${"Trip".tr()}(${model.driverId?.review?.ratingTrip?.toStringAsFixed(0) ?? 0})"),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                                "${"Service".tr()}(${model.driverId?.review?.ratingService?.toStringAsFixed(0) ?? 0})"),
                          ],
                        ),
                        const SizedBox(
                          width: 3,
                        ),
                        ...List.generate(
                          model.driverId?.review?.comments?.length ?? 0,
                          (index) => Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            child: Text(
                              model.driverId?.review?.comments?[index] ?? "",
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
