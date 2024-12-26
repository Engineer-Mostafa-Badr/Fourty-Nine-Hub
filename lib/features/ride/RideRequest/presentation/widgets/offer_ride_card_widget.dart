import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/my_trip_offer_ride_model/my_trip_offer_ride_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/review_ride_trip_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/NoSocket/accept_offer_no_socket_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/NoSocket/decline_offer_no_socket_cubit.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/call_message_cubit.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/shipping_state.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/widgets/report_view.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher_string.dart';

class OfferRideCardWidget extends StatelessWidget {
  const OfferRideCardWidget({super.key, required this.model, this.onAccept});
  final MyTripOfferRideModel model;
  final Function(MyTripOfferRideModel model)? onAccept;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.black38
                          : Colors.white,
                      border:
                          Border.all(color: AppColors.PRIMARY_COLOR, width: 3),
                      // ignore: prefer_const_literals_to_create_immutables
                      boxShadow: [
                        const BoxShadow(color: Colors.black12, blurRadius: 10),
                      ],
                      borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: Text(
                              LocaleKeys.newOffer.tr(),
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Text(
                            "${model.price}",
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.green),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 7,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            width: 60,
                            model.driverId?.userId?.gender?.toLowerCase() ==
                                    'female'
                                ? Assets.femaleImagePlacehlder
                                : Assets.maleImagePlaceholder,
                            fit: BoxFit.cover, // Cover the entire circle
                          ),
                          // Container(
                          //   width: 80,
                          //   height: 80,
                          //   decoration:
                          //       BoxDecoration(
                          //           color: Colors
                          //               .red,
                          //           image:
                          //               DecorationImage(
                          //             image:
                          //                 NetworkImage(model.driverId?.userId?.userProfile?.profilePictureKey?.mediaKey ?? ""),
                          //             fit: BoxFit
                          //                 .cover,
                          //           ),
                          //           borderRadius:
                          //               BorderRadius.circular(15)),
                          // ),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                model.driverId?.carModel ?? "",
                                style: const TextStyle(fontSize: 15),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                model.driverId?.userId?.firstName ?? "",
                                style: const TextStyle(fontSize: 15),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                "${model.driverId?.trips ?? 0} ${LocaleKeys.orders.tr()}",
                                style: const TextStyle(fontSize: 15),
                              )
                            ],
                          ),
                          const Spacer(),
                          Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  context.push(Routes.TripRideRating,
                                      extra: ReviewRideTripModel(
                                        comments:
                                            model.driverId?.review?.comments ??
                                                [],
                                        fullName:
                                            "${model.driverId?.userId?.firstName} ${model.driverId?.userId?.lastName}",
                                        driver: model.driverId?.review
                                                ?.ratingDriver ??
                                            0,
                                        service: model.driverId?.review
                                                ?.ratingService ??
                                            0,
                                        averageRating: model.driverId?.review
                                                ?.averageRating ??
                                            0,
                                        trip: model
                                                .driverId?.review?.ratingTrip ??
                                            0,
                                        numberOfReviewers: model.driverId
                                                ?.review?.numberOfReviewers ??
                                            0,
                                      ));
                                },
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    Text(
                                        "${model.driverId?.review?.averageRating}"),
                                    Text(
                                      "(${model.driverId?.review?.numberOfReviewers})",
                                      style:
                                          const TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                              if (model.isPremium ?? false)
                                Text(LocaleKeys.premium.tr())
                            ],
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      if (onAccept != null)
                        Row(
                          children: [
                            Flexible(
                              child: AppButton(
                                label: LocaleKeys.decline.tr(),
                                onPressed: () {
                                  context
                                      .read<DeclineOfferNoSocketCubit>()
                                      .decline(id: model.id ?? "");
                                },
                              ),
                            ),
                            const Sizer(),
                            Flexible(
                              child: AppButton(
                                color: Colors.white,
                                backColor: AppColors.PRIMARY_COLOR,
                                label: LocaleKeys.Accept.tr(),
                                onPressed: () {
                                  context
                                      .read<AcceptOfferNoSocketCubit>()
                                      .accept(id: model.id ?? "");
                                  if (onAccept != null) {
                                    onAccept!(model);
                                  }
                                },
                              ),
                            )
                          ],
                        ),
                      const SizedBox(
                        height: 10,
                      ),
                      BlocBuilder<CallMessageCubit, ShippingState>(
                        builder: (context, callState) {
                          if (callState is FailureShippingState) {}
                          if (callState is SuccessGetCallMessageState) {
                            return Row(
                              children: [
                                Expanded(
                                  child: AppButton(
                                    label: LocaleKeys.call.tr(),
                                    color: Colors.white,
                                    icon: Icons.call,
                                    backColor: callState.data &&
                                            (model.isAccepted ?? false)
                                        ? AppColors.PRIMARY_COLOR
                                        : AppColors.DARK_GRAY_COLOR,
                                    onPressed: () {
                                      if (callState.data &&
                                          (model.isAccepted ?? false)) {
                                        launchUrlString(
                                            "tel://${model.driverId?.phone}");
                                      }
                                    },
                                    style: Styles.mediumText(
                                        fontSize: 18, color: Colors.white),
                                  ),
                                ),
                                const Sizer(),
                                Expanded(
                                  child: AppButton(
                                    label: LocaleKeys.message.tr(),
                                    icon: Icons.message,
                                    backColor: callState.data &&
                                            (model.isAccepted ?? false)
                                        ? AppColors.PRIMARY_COLOR
                                        : AppColors.DARK_GRAY_COLOR,
                                    style: Styles.mediumText(
                                        fontSize: 15, color: Colors.white),
                                    onPressed: () {},
                                  ),
                                ),
                                const Sizer(),
                                Expanded(
                                  child: AppButton(
                                    label: LocaleKeys.report.tr(),
                                    icon: Icons.report,
                                    backColor: Colors.red,
                                    style: Styles.mediumText(
                                        fontSize: 18, color: Colors.white),
                                    onPressed: () {
                                      // tripCubit.report(
                                      //     loadingTripId: widget.model.id ?? "");
                                      showBottomSheet(
                                        context: context,
                                        builder: (context) => Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: ReportView(
                                            categoryId:
                                                model.subcategoryId ?? "",
                                            id: model.id ?? "",
                                            loadingTripId: model.id ?? "",
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return Row(
                              children: [
                                Expanded(
                                  child: AppButton(
                                    label: LocaleKeys.call.tr(),
                                    color: Colors.white,
                                    icon: Icons.call,
                                    backColor: AppColors.DARK_GRAY_COLOR,
                                    onPressed: () {
                                      // launchUrlString(
                                      //     "tel://${model.driverId?.phone}");
                                    },
                                    style: Styles.mediumText(
                                        fontSize: 18, color: Colors.white),
                                  ),
                                ),
                                const Sizer(),
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
                                const Sizer(),
                                Expanded(
                                  child: AppButton(
                                    label: LocaleKeys.report.tr(),
                                    icon: Icons.report,
                                    backColor: Colors.red,
                                    style: Styles.mediumText(
                                        fontSize: 15, color: Colors.white),
                                    onPressed: () {
                                      showBottomSheet(
                                        context: context,
                                        builder: (context) => const ReportView(
                                          categoryId: "",
                                          id: "",
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ],
        ),
        const Sizer(),
      ],
    );
  }
}
