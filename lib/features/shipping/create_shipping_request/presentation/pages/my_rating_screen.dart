import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/all_trip_model/all_trip_model.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/widgets/trip_card.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:url_launcher/url_launcher_string.dart';

class MyRatingScreen extends StatelessWidget {
  const MyRatingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 40,
              ),
              Container(
                padding: const EdgeInsets.all(20),
                width: double.infinity,
                // padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.red),
                ),
                child: Column(
                  children: [
                    TripCardWidget(
                      buttons: true,
                      noBracts: true,
                      padding: EdgeInsets.zero,
                      margin: EdgeInsets.zero,
                      title: "",
                      noBoardr: true,
                      model: AllTripModel(price: 20, status: LocaleKeys.completed.tr()),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20)),
                        color: Colors.white,
                      ),
                      // padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // RequestOfferCard(
                          //   isHistory: true,
                          //     model:
                          //         GetRequestsForLoadingModel(
                          //           price: 12
                          //         )),
                          Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                LocaleKeys.trip.tr(),
                                style: Styles.headerText(),
                              ),
                              const Spacer(),
                              Row(
                                children: [1, 2, 3, 4, 5]
                                    .map(
                                      (e) => const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                    )
                                    .toList(),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                "(3)",
                                style: Styles.mediumText(),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                LocaleKeys.driver.tr(),
                                style: Styles.headerText(),
                              ),
                              const Spacer(),
                              Row(
                                children: [1, 2, 3, 4, 5]
                                    .map(
                                      (e) => const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                    )
                                    .toList(),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                "(3)",
                                style: Styles.mediumText(),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                LocaleKeys.service.tr(),
                                style: Styles.headerText(),
                              ),
                              const Spacer(),
                              Row(
                                children: [1, 2, 3, 4, 5].map((e) {
                                  return Icon(
                                    Icons.star,
                                    color: e <= 3 ? Colors.amber : Colors.grey,
                                  );
                                }).toList(),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                "(3)",
                                style: Styles.mediumText(),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              LocaleKeys.comment.tr(),
                              style: Styles.mediumText(),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: AppButton(
                                  label: LocaleKeys.call.tr(),
                                  color: Colors.white,
                                  icon: Icons.call,
                                  backColor: AppColors.DARK_GRAY_COLOR,
                                  onPressed: () {
                                    launchUrlString("tel://21213123123");
                                  },
                                  style: Styles.mediumText(
                                      fontSize: 18, color: Colors.white),
                                ),
                              ),
                              const Sizer(
                                width: 5,
                              ),
                              Expanded(
                                child: AppButton(
                                  label: LocaleKeys.message.tr(),
                                  icon: Icons.message,
                                  backColor: AppColors.DARK_GRAY_COLOR,
                                  style: Styles.mediumText(
                                      fontSize: 18, color: Colors.white),
                                  onPressed: () {},
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
