//
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/default_text_form_field.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/requests_history/data/models/shipping_request_model/shipping_request_model.dart';
import 'package:fourtyninehub/features/requests_history/presentation/cubit/ratin_state.dart';
import 'package:fourtyninehub/features/requests_history/presentation/cubit/rating_cubit.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/get_requests_for_loading_model/driver_id.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/get_requests_for_loading_model/get_requests_for_loading_model.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/get_requests_for_loading_model/profile_picture_key.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/get_requests_for_loading_model/user_id.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/get_requests_for_loading_model/user_profile.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/call_message_cubit.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/shipping_state.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/trip_cubit.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/pages/create_shipping_view.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/widgets/report_view.dart';
import 'package:fourtyninehub/res/strings/labels.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ShppingHistoryCard extends StatefulWidget {
  const ShppingHistoryCard(
      {super.key,
      required this.model,
      required this.priceFontSize,
      this.isHistory = false});
  final ShippingRequestModel model;
  final bool isHistory;
  final double priceFontSize;
  @override
  State<ShppingHistoryCard> createState() => _ShppingHistoryCardState();
}

class _ShppingHistoryCardState extends State<ShppingHistoryCard> {
  TextEditingController price = TextEditingController();
  TextEditingController comment = TextEditingController();
  TextEditingController midifyComment = TextEditingController();
  PageController controller = PageController();
  int tripRating = 1;
  int driverRating = 1;
  int serviceRating = 1;
  @override
  void initState() {
    super.initState();
    price.text = widget.model.price?.toStringAsFixed(0) ?? "0";
    context.read<CallMessageCubit>().getCallMessage(
        ownerId: widget.model.userId ?? "",
        subcategoryId: widget.model.categoryId ?? "");
  }

  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    var tripCubit = context.read<TripCubit>();
    var ratingCubit = context.read<RatingCubit>();
    return BlocConsumer<TripCubit, ShippingState>(
      listener: (context, state) {
        if (state is SuccessAcceptOfferState) {
          showSuccessMessage(context, state.message);
        }
        if (state is SuccessSendNewOfferState) {
          context.pop();
          showSuccessMessage(context, state.message);
        }
        if (state is SuccessAcceptPremiumOfferState) {
          showSuccessMessage(context, state.message);
        }
        if (state is FailureShippingState) {
          showErrorMessage(context, getFailureMessage(state.failure, context));
        }
        if (state is SuccessReportState) {
          showSuccessMessage(context, 'you have reported this trip.');
        }
      },
      builder: (context, state) {
        return BlocListener<RatingCubit, RatingState>(
          listener: (context, state) {
            log(state.toString(), name: "Lkdjfslkdjfslkdf");
            if (state is SuccessRatingTripState) {
              context.pop();
              showSuccessMessage(context, "Rate Success");
            }
            if (state is FailiureRatingState) {
              showErrorMessage(
                  context, getFailureMessage(state.failure, context));
            }
          },
          child: GestureDetector(
            onTap: () {},
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 3),
                  borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          if (!widget.isHistory)
                            const Text(
                              'New Ride ',
                              style: TextStyle(
                                color: AppColors.PRIMARY_COLOR,
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                            ),
                          Text(
                            widget.isHistory
                                ? '${widget.model.status}'
                                : '(status)',
                            // ignore: prefer_const_constructors
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            '${widget.model.price?.toStringAsFixed(0)}',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: widget.priceFontSize,
                            ),
                          ),
                          const Text("Premium")
                        ],
                      ),
                    ],
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Icon(Icons.calendar_month),
                            Flexible(
                              child: Text(
                                "${5} August, 09:47",
                                style: TextStyle(fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(Icons.chat),
                      const SizedBox(
                        width: 6,
                      ),
                      Text(
                        widget.model.desc ?? "",
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue, width: 5),
                            shape: BoxShape.circle),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Expanded(
                        child: Text(
                          widget.model.startLocation ?? "",
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.green, width: 5),
                            shape: BoxShape.circle),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Expanded(
                        child: Text(
                          widget.model.targetLocation ?? "",
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  const SizedBox(height: 5),
                  widget.isHistory
                      ? Row(
                          children: [
                            Flexible(
                              child: AppButton(
                                width: double.infinity,
                                onPressed: () {
                                  showBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return StatefulBuilder(
                                        builder: (context, setStates) {
                                          return Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15, vertical: 10),
                                            color: Colors.white,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      "Trip",
                                                      style:
                                                          Styles.headerText(),
                                                    ),
                                                    const Spacer(),
                                                    Row(children: [
                                                      ...List.generate(
                                                        5,
                                                        (index) {
                                                          return GestureDetector(
                                                            onTap: () {
                                                              setStates(() {
                                                                tripRating =
                                                                    index + 1;
                                                              });
                                                            },
                                                            child: Icon(
                                                              Icons.star,
                                                              color: index <=
                                                                      tripRating -
                                                                          1
                                                                  ? Colors.amber
                                                                  : Colors.grey,
                                                            ),
                                                          );
                                                        },
                                                      )
                                                    ]),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                      "($tripRating)",
                                                      style:
                                                          Styles.mediumText(),
                                                    )
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "Driver",
                                                      style:
                                                          Styles.headerText(),
                                                    ),
                                                    const Spacer(),
                                                    Row(children: [
                                                      ...List.generate(
                                                        5,
                                                        (index) {
                                                          return GestureDetector(
                                                            onTap: () {
                                                              setStates(() {
                                                                driverRating =
                                                                    index + 1;
                                                              });
                                                            },
                                                            child: Icon(
                                                              Icons.star,
                                                              color: index <=
                                                                      driverRating -
                                                                          1
                                                                  ? Colors.amber
                                                                  : Colors.grey,
                                                            ),
                                                          );
                                                        },
                                                      )
                                                    ]),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                      "($driverRating)",
                                                      style:
                                                          Styles.mediumText(),
                                                    )
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "Service",
                                                      style:
                                                          Styles.headerText(),
                                                    ),
                                                    const Spacer(),
                                                    Row(children: [
                                                      ...List.generate(
                                                        5,
                                                        (index) {
                                                          return GestureDetector(
                                                            onTap: () {
                                                              setStates(() {
                                                                serviceRating =
                                                                    index + 1;
                                                              });
                                                            },
                                                            child: Icon(
                                                              Icons.star,
                                                              color: index <=
                                                                      serviceRating -
                                                                          1
                                                                  ? Colors.amber
                                                                  : Colors.grey,
                                                            ),
                                                          );
                                                        },
                                                      )
                                                    ]),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                      "(${serviceRating})",
                                                      style:
                                                          Styles.mediumText(),
                                                    )
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                DefaultTextFormField(
                                                  currentController: comment,
                                                  hint: "Comment",
                                                ),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                AppButton(
                                                  backColor:
                                                      AppColors.PRIMARY_COLOR,
                                                  color: Colors.white,
                                                  label: "Add Rating",
                                                  onPressed: () {
                                                    ratingCubit.rating(
                                                      trip: tripRating,
                                                      driver: driverRating,
                                                      service: serviceRating,
                                                      comment: comment.text,
                                                      driverId: widget.model
                                                              .driverId?.id ??
                                                          "",
                                                      loadingTripId:
                                                          widget.model.id ?? "",
                                                      categoryId: widget.model
                                                              .categoryId ??
                                                          "",
                                                    );
                                                  },
                                                )
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  );
                                },
                                label: "Trip rating",
                                backColor: AppColors.PRIMARY_COLOR,
                                style: Styles.mediumText(
                                    fontSize: 28, color: Colors.white),
                              ),
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            Flexible(
                              child: AppButton(
                                width: double.infinity,
                                onPressed: () {
                                  if (widget.model.isUserRate != null) {
                                    serviceRating = widget
                                            .model.isUserRate?.ratingService ??
                                        1;
                                    driverRating =
                                        widget.model.isUserRate?.ratingDriver ??
                                            1;
                                    tripRating =
                                        widget.model.isUserRate?.ratingTrip ??
                                            1;
                                    midifyComment.text =
                                        widget.model.isUserRate?.comment ?? "";
                                    showBottomSheet(
                                      context: context,
                                      builder: (context) {
                                        return StatefulBuilder(
                                          builder: (context, setStates) {
                                            return Container(
                                              decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(20),
                                                    topRight:
                                                        Radius.circular(20)),
                                                color: Colors.white,
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 20),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  // RequestOfferCard(
                                                  //     isHistory: true,
                                                  //     model:
                                                  //         GetRequestsForLoadingModel(
                                                  //             price: widget.model.price??0, driverId: DriverId(
                                                  //               userId: UserId(
                                                  //                 userProfile: UserProfile(
                                                  //                   profilePictureKey: ProfilePictureKey(
                                                  //                     mediaKey: widget.model.
                                                  //                   )
                                                  //                 )
                                                  //               )
                                                  //             )),),
                                                  Row(
                                                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text(
                                                        "Trip",
                                                        style:
                                                            Styles.headerText(),
                                                      ),
                                                      const Spacer(),
                                                      Row(children: [
                                                        ...List.generate(
                                                          5,
                                                          (index) {
                                                            return GestureDetector(
                                                              onTap: () {
                                                                setStates(() {
                                                                  tripRating =
                                                                      index + 1;
                                                                });
                                                              },
                                                              child: Icon(
                                                                Icons.star,
                                                                color: index <=
                                                                        tripRating -
                                                                            1
                                                                    ? Colors
                                                                        .amber
                                                                    : Colors
                                                                        .grey,
                                                              ),
                                                            );
                                                          },
                                                        )
                                                      ]),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                        "($tripRating)",
                                                        style:
                                                            Styles.mediumText(),
                                                      )
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        "Driver",
                                                        style:
                                                            Styles.headerText(),
                                                      ),
                                                      const Spacer(),
                                                      Row(children: [
                                                        ...List.generate(
                                                          5,
                                                          (index) {
                                                            return GestureDetector(
                                                              onTap: () {
                                                                setStates(() {
                                                                  driverRating =
                                                                      index + 1;
                                                                });
                                                              },
                                                              child: Icon(
                                                                Icons.star,
                                                                color: index <=
                                                                        driverRating -
                                                                            1
                                                                    ? Colors
                                                                        .amber
                                                                    : Colors
                                                                        .grey,
                                                              ),
                                                            );
                                                          },
                                                        )
                                                      ]),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                        "($driverRating)",
                                                        style:
                                                            Styles.mediumText(),
                                                      )
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        "Service",
                                                        style:
                                                            Styles.headerText(),
                                                      ),
                                                      const Spacer(),
                                                      Row(children: [
                                                        ...List.generate(
                                                          5,
                                                          (index) {
                                                            return GestureDetector(
                                                              onTap: () {
                                                                setStates(() {
                                                                  serviceRating =
                                                                      index + 1;
                                                                });
                                                              },
                                                              child: Icon(
                                                                Icons.star,
                                                                color: index <=
                                                                        serviceRating -
                                                                            1
                                                                    ? Colors
                                                                        .amber
                                                                    : Colors
                                                                        .grey,
                                                              ),
                                                            );
                                                          },
                                                        )
                                                      ]),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                        "(${serviceRating})",
                                                        style:
                                                            Styles.mediumText(),
                                                      )
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  DefaultTextFormField(
                                                    currentController:
                                                        midifyComment,
                                                    hint: "Comment",
                                                  ),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  AppButton(
                                                    backColor:
                                                        AppColors.PRIMARY_COLOR,
                                                    color: Colors.white,
                                                    label: "Modify Rating",
                                                    onPressed: () {
                                                      ratingCubit.rating(
                                                        trip: tripRating,
                                                        driver: driverRating,
                                                        service: serviceRating,
                                                        comment:
                                                            midifyComment.text,
                                                        driverId: widget.model
                                                                .driverId?.id ??
                                                            "",
                                                        loadingTripId:
                                                            widget.model.id ??
                                                                "",
                                                        categoryId: widget.model
                                                                .categoryId ??
                                                            "",
                                                      );
                                                    },
                                                  )
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    );
                                  }
                                },
                                label: "Modify rating",
                                style: Styles.mediumText(
                                    fontSize: 28, color: Colors.white),
                              ),
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: AppButton(
                                    style: Styles.mediumText(
                                        fontSize: 18, color: Colors.white),
                                    label: "Send Offer",
                                    onPressed: () {
                                      tripCubit.newOffer(
                                          id: widget.model.id ?? "",
                                          price: widget.model.price ?? 0,
                                          message:
                                              "The request has been successfully approved.");
                                    },
                                    backColor: AppColors.PRIMARY_COLOR,
                                    color: Colors.white,
                                    // height: 40,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: DefaultTextFormField(
                                    currentFocusNode: FocusNode(),
                                    currentController: price,
                                    hint: widget.model.price.toString(),
                                    constraints: const BoxConstraints(
                                      maxHeight: kToolbarHeight * .6,
                                      minHeight: kToolbarHeight * .6,
                                    ),
                                    keyboardType: TextInputType.number,
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            BlocBuilder<CallMessageCubit, ShippingState>(
                              builder: (context, state) {
                                if (state is FailureShippingState) {
                                  log(getFailureMessage(state.failure, context),
                                      name: "lskdjflskdjfslkdjfslkdjfslkdjf");
                                }
                                log(state.toString(),
                                    name: "lskdjflskdjfslkdjfslkdjfslkdjf");
                                if (state is SuccessGetCallMessageState) {
                                  log(state.data.toString(),
                                      name: "lskdjflskdjfslkdjfslkdjfslkdjf");
                                  return Row(
                                    children: [
                                      Expanded(
                                        child: AppButton(
                                          label: Labels.call,
                                          color: Colors.white,
                                          icon: Icons.call,
                                          backColor: state.data
                                              ? AppColors.PRIMARY_COLOR
                                              : AppColors.DARK_GRAY_COLOR,
                                          onPressed: () {},
                                          style: Styles.mediumText(
                                              fontSize: 18,
                                              color: Colors.white),
                                        ),
                                      ),
                                      const Sizer(),
                                      Expanded(
                                        child: AppButton(
                                          label: Labels.message,
                                          icon: Icons.message,
                                          backColor: state.data
                                              ? AppColors.PRIMARY_COLOR
                                              : AppColors.DARK_GRAY_COLOR,
                                          style: Styles.mediumText(
                                              fontSize: 15,
                                              color: Colors.white),
                                          onPressed: () {},
                                        ),
                                      ),
                                      const Sizer(),
                                      Expanded(
                                        child: AppButton(
                                          label: Labels.report,
                                          icon: Icons.report,
                                          backColor: Colors.red,
                                          style: Styles.mediumText(
                                              fontSize: 18,
                                              color: Colors.white),
                                          onPressed: () {
                                            // tripCubit.report(
                                            //     loadingTripId: widget.model.id ?? "");
                                            showBottomSheet(
                                              context: context,
                                              builder: (context) => Padding(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                child: ReportView(
                                                  categoryId:
                                                      widget.model.categoryId ??
                                                          "",
                                                  id: widget.model.id ?? "",
                                                  loadingTripId:
                                                      widget.model.id ?? "",
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
                                          label: Labels.call,
                                          color: Colors.white,
                                          icon: Icons.call,
                                          backColor: AppColors.DARK_GRAY_COLOR,
                                          onPressed: () {
                                            launchUrlString(
                                                "tel://21213123123");
                                          },
                                          style: Styles.mediumText(
                                              fontSize: 18,
                                              color: Colors.white),
                                        ),
                                      ),
                                      const Sizer(),
                                      Expanded(
                                        child: AppButton(
                                          label: Labels.message,
                                          icon: Icons.message,
                                          backColor: AppColors.DARK_GRAY_COLOR,
                                          style: Styles.mediumText(
                                            fontSize: 18,
                                            color: Colors.white,
                                          ),
                                          onPressed: () {},
                                        ),
                                      ),
                                      const Sizer(),
                                      Expanded(
                                        child: AppButton(
                                          label: Labels.report,
                                          icon: Icons.report,
                                          backColor: Colors.red,
                                          style: Styles.mediumText(
                                            fontSize: 15,
                                            color: Colors.white,
                                          ),
                                          onPressed: () {
                                            showBottomSheet(
                                              context: context,
                                              builder: (context) =>
                                                  const ReportView(
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String getMonthName(int month) {
    List<String> monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];

    // للتحقق من أن رقم الشهر في النطاق الصحيح
    if (month < 1 || month > 12) {
      return 'Invalid month';
    }

    return monthNames[month - 1];
  }
}
