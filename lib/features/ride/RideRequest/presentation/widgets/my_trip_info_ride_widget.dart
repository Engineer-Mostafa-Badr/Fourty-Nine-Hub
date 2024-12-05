import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/default_text_form_field.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/my_trip_ride_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/rating_driver_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/review_ride_trip_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/NoSocket/accept_offer_no_socket_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/NoSocket/complete_no_socket_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/NoSocket/decline_offer_no_socket_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/NoSocket/delete_offer_ride_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/NoSocket/get_trip_offers_no_socket_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/NoSocket/get_user_login_trip_no_socket_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/NoSocket/rating_driver_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';

class MyTripInfoRideWidget extends StatefulWidget {
  const MyTripInfoRideWidget({super.key, required this.model});
  final MyTripRideModel model;

  @override
  State<MyTripInfoRideWidget> createState() => _MyTripInfoRideWidgetState();
}

class _MyTripInfoRideWidgetState extends State<MyTripInfoRideWidget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<GetTripOffersNoSocketCubit>().get(id: widget.model.id ?? "");
    context.read<GetUserLoginTripNoSocketCubit>().get();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RatingDriverCubit, RiderState>(
      listener: (context, state) {
        if (state is SuccessRateDvierState) {
          context.pop();
          context
              .read<CompleteNoSocketCubit>()
              .complete(id: widget.model.id ?? "");
        }
      },
      child: BlocListener<DeleteOfferRideCubit, RiderState>(
        listener: (context, state) {
          if (state is SuccessDeleteTripNoSocketState) {
            context.read<GetUserLoginTripNoSocketCubit>().get();
            setState(() {});
            showSuccessMessage(context, LocaleKeys.successCancelTrip.tr());
          }
          if (state is FailureRiderState) {
            showErrorMessage(
                context, getFailureMessage(state.failure, context));
          }
        },
        child: BlocListener<CompleteNoSocketCubit, RiderState>(
          listener: (context, state) {
            if (state is SuccessCompleteOfferNoSocketState) {
              context.read<GetUserLoginTripNoSocketCubit>().get();
              showSuccessMessage(context, LocaleKeys.tripIsCompleted.tr());

              setState(() {});
            }
            if (state is FailureRiderState) {
              showErrorMessage(
                  context, getFailureMessage(state.failure, context));
            }
          },
          child: BlocListener<DeclineOfferNoSocketCubit, RiderState>(
            listener: (context, state) {
              if (state is SuccessRejectOfferNoSocketState) {
                context
                    .read<GetTripOffersNoSocketCubit>()
                    .get(id: widget.model.id ?? "");
                setState(() {});
                showSuccessMessage(context, "Success Decline Offer");
              }
              if (state is FailureRiderState) {
                showErrorMessage(
                    context, getFailureMessage(state.failure, context));
              }
            },
            child: BlocListener<AcceptOfferNoSocketCubit, RiderState>(
                listener: (context, state) {
              if (state is SuccessAcceptOfferNoSocketState) {
                context.read<GetUserLoginTripNoSocketCubit>().get();
                context
                    .read<GetTripOffersNoSocketCubit>()
                    .get(id: widget.model.id ?? "");
                setState(() {});
                showSuccessMessage(context, "Success Accept Offer");
              }
              if (state is FailureRiderState) {
                showErrorMessage(
                    context, getFailureMessage(state.failure, context));
              }
            }, child: BlocBuilder<GetUserLoginTripNoSocketCubit, RiderState>(
              builder: (context, state) {
                log(state.toString(), name: "lsdjflsdfjdkdkdkdkd");
                if (state is SuccessGetUserLoginTripNoSocketState) {
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black, width: 3),
                              borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Row(
                                      children: [
                                        Text(
                                          LocaleKeys.newRide.tr(),
                                          style: TextStyle(
                                            color:
                                                Theme.of(context).brightness ==
                                                        Brightness.dark
                                                    ? Colors.white
                                                    : AppColors.PRIMARY_COLOR,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 22,
                                          ),
                                        ),
                                        Flexible(
                                          child: Text(
                                            " ${state.model.status}",
                                            style: const TextStyle(
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 22,
                                                overflow:
                                                    TextOverflow.ellipsis),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        '${state.model.price?.toStringAsFixed(0)}',
                                        style: const TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Icon(Icons.calendar_month),
                                        Flexible(
                                          child: Text(
                                            "25 August, 09:47",
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
                              const Row(
                                children: [
                                  Icon(Icons.people),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Flexible(
                                    child: Text(
                                      "1",
                                      style: TextStyle(fontSize: 12),
                                    ),
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
                                        border: Border.all(
                                            color: Colors.blue, width: 5),
                                        shape: BoxShape.circle),
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  Expanded(
                                    child: Text(
                                      state.model.fromTitle ?? "",
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
                                        border: Border.all(
                                            color: Colors.green, width: 5),
                                        shape: BoxShape.circle),
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  Expanded(
                                    child: Text(
                                      widget.model.toTitle ?? "",
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                      const Sizer(),
                      AppButton(
                        label: state.model.status == "Accepted"
                            ? LocaleKeys.complete.tr()
                            : LocaleKeys.cancel.tr(),
                        backColor: state.model.status == "Accepted"
                            ? AppColors.PRIMARY_COLOR
                            : Colors.red,
                        color: Colors.white,
                        onPressed: () {
                          if (state.model.status == "Accepted") {
                            showModalBottomSheet(
                              backgroundColor: Colors.white,
                              context: context,
                              builder: (context) => BlocProvider(
                                create: (context) => RatingDriverCubit(
                                    repository: serviceLocator()),
                                child: RattingDriverWidget(
                                  onPressed: (model) {
                                    context.read<RatingDriverCubit>().rate(
                        model: model
                      );
                                  },
                                  driverId: state.model.driverId,
                                  tripId: state.model.id ?? "",
                                ),
                              ),
                            );
                          } else {
                            context
                                .read<DeleteOfferRideCubit>()
                                .delete(id: state.model.id ?? "");
                          }
                        },
                      ),
                      const Sizer(),
                      state.model.status == "Accepted"
                          ? Container()
                          : BlocBuilder<GetTripOffersNoSocketCubit, RiderState>(
                              builder: (context, state) {
                                if (state is SuccessGetAllOfferNoSocketState) {
                                  return Column(
                                    children: [
                                      ...List.generate(
                                        state.list.length,
                                        (index) => Column(
                                          children: [
                                            Column(
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              top: 5),
                                                      width: double.infinity,
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 10,
                                                          vertical: 5),
                                                      decoration: BoxDecoration(
                                                          color: Theme.of(context)
                                                                      .brightness ==
                                                                  Brightness
                                                                      .dark
                                                              ? Colors.black38
                                                              : Colors.white,
                                                          border: Border.all(
                                                              color: AppColors
                                                                  .PRIMARY_COLOR,
                                                              width: 3),
                                                          // ignore: prefer_const_literals_to_create_immutables
                                                          boxShadow: [
                                                            const BoxShadow(
                                                                color: Colors
                                                                    .black12,
                                                                blurRadius: 10),
                                                          ],
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15)),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        6),
                                                                child: Text(
                                                                  LocaleKeys
                                                                      .newOffer
                                                                      .tr(),
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          20,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                              ),
                                                              Text(
                                                                "${state.list[index].price}",
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        20,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .green),
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                            height: 7,
                                                          ),
                                                          Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Container(
                                                                width: 80,
                                                                height: 80,
                                                                decoration:
                                                                    BoxDecoration(
                                                                        color: Colors
                                                                            .red,
                                                                        image:
                                                                            DecorationImage(
                                                                          image:
                                                                              NetworkImage(state.list[index].driverId?.userId?.userProfile?.profilePictureKey?.mediaKey ?? ""),
                                                                          fit: BoxFit
                                                                              .cover,
                                                                        ),
                                                                        borderRadius:
                                                                            BorderRadius.circular(15)),
                                                              ),
                                                              const SizedBox(
                                                                width: 10,
                                                              ),
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    LocaleKeys
                                                                        .carModel
                                                                        .tr(),
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            15),
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 5,
                                                                  ),
                                                                  Text(
                                                                    state
                                                                            .list[index]
                                                                            .driverId
                                                                            ?.userId
                                                                            ?.firstName ??
                                                                        "",
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            15),
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 5,
                                                                  ),
                                                                  Text(
                                                                    "${0} ${LocaleKeys.orders.tr()}",
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            15),
                                                                  )
                                                                ],
                                                              ),
                                                              const Spacer(),
                                                              Column(
                                                                children: [
                                                                  GestureDetector(
                                                                    onTap: () {
                                                                      context.push(
                                                                          Routes
                                                                              .TripRideRating,
                                                                          extra:
                                                                              ReviewRideTripModel(
                                                                            comments:
                                                                                state.list[index].driverId?.review?.comments ?? [],
                                                                            fullName:
                                                                                "${state.list[index].driverId?.userId?.firstName} ${state.list[index].driverId?.userId?.lastName}",
                                                                            driver:
                                                                                state.list[index].driverId?.review?.ratingDriver ?? 0,
                                                                            service:
                                                                                state.list[index].driverId?.review?.ratingService ?? 0,
                                                                            averageRating:
                                                                                state.list[index].driverId?.review?.averageRating ?? 0,
                                                                            trip:
                                                                                state.list[index].driverId?.review?.ratingTrip ?? 0,
                                                                            numberOfReviewers:
                                                                                state.list[index].driverId?.review?.numberOfReviewers ?? 0,
                                                                          ));
                                                                    },
                                                                    child: Row(
                                                                      children: [
                                                                        const Icon(
                                                                          Icons
                                                                              .star,
                                                                          color:
                                                                              Colors.amber,
                                                                        ),
                                                                        Text(
                                                                            "${state.list[index].driverId?.review?.averageRating}"),
                                                                        Text(
                                                                          "(${state.list[index].driverId?.review?.numberOfReviewers})",
                                                                          style:
                                                                              const TextStyle(color: Colors.grey),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  // if (model.isPremium ?? false)
                                                                  Text(LocaleKeys
                                                                      .premium
                                                                      .tr())
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                            height: 10,
                                                          ),
                                                          Row(
                                                            children: [
                                                              Flexible(
                                                                child:
                                                                    AppButton(
                                                                  label:
                                                                      LocaleKeys
                                                                          .decline
                                                                          .tr(),
                                                                  onPressed:
                                                                      () {
                                                                    context
                                                                        .read<
                                                                            DeclineOfferNoSocketCubit>()
                                                                        .decline(
                                                                            id: state.list[index].id ??
                                                                                "");
                                                                  },
                                                                ),
                                                              ),
                                                              const Sizer(),
                                                              Flexible(
                                                                child:
                                                                    AppButton(
                                                                  color: Colors
                                                                      .white,
                                                                  backColor:
                                                                      AppColors
                                                                          .PRIMARY_COLOR,
                                                                  label: LocaleKeys
                                                                          .Accept
                                                                      .tr(),
                                                                  onPressed:
                                                                      () {
                                                                    context
                                                                        .read<
                                                                            AcceptOfferNoSocketCubit>()
                                                                        .accept(
                                                                            id: state.list[index].id ??
                                                                                "");
                                                                  },
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                            height: 10,
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
                                        ),
                                      ),
                                    ],
                                  );
                                } else {
                                  return Center(
                                      child: Text(
                                    LocaleKeys
                                        .yourRequestHasBeenSentYouWillReceiveOffersShortly
                                        .tr(),
                                  ));
                                }
                              },
                            )
                    ],
                  );
                } else {
                  return Container();
                }
              },
            )),
          ),
        ),
      ),
    );
  }
}

class RattingDriverWidget extends StatefulWidget {
  const RattingDriverWidget(
      {super.key,
      required this.driverId,
      required this.tripId,
      required this.onPressed});
  final String driverId;
  final String tripId;
  final Function(RattingDriverModel model) onPressed;
  @override
  State<RattingDriverWidget> createState() => _RattingDriverWidgetState();
}

class _RattingDriverWidgetState extends State<RattingDriverWidget> {
  double service = 0;
  double trip = 0;
  double driver = 0;
  final TextEditingController comment = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LocaleKeys.service.tr(),
              style: Styles.headerText(),
            ),
            RatingBar.builder(
              initialRating: 1,
              minRating: 1,
              direction: Axis.horizontal,
              itemSize: 25,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                service = rating;
              },
            ),
            const Sizer(),
            Text(
              LocaleKeys.driver.tr(),
              style: Styles.headerText(),
            ),
            RatingBar.builder(
              initialRating: 1,
              minRating: 1,
              direction: Axis.horizontal,
              itemSize: 25,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                driver = rating;
              },
            ),
            const Sizer(),
            Text(
              LocaleKeys.trip.tr(),
              style: Styles.headerText(),
            ),
            RatingBar.builder(
              initialRating: 1,
              minRating: 1,
              direction: Axis.horizontal,
              itemSize: 25,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                trip = rating;
              },
            ),
            const Sizer(
              height: 30,
            ),
            DefaultTextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return LocaleKeys.thisFieldIsRequired.tr();
                  }
                  return null;
                },
                currentController: comment,
                hint: LocaleKeys.comment.tr()),
            const Spacer(),
            AppButton(
              label: LocaleKeys.review.tr(),
              onPressed: () {
                if (formKey.currentState?.validate() == true) {
                  widget.onPressed(RattingDriverModel(
                      rate: [service, trip, driver],
                      comment: comment.text,
                      driverId: widget.driverId,
                      tripId: widget.tripId));
                }
              },
            ),
            const Sizer()
          ],
        ),
      ),
    );
  }
}
