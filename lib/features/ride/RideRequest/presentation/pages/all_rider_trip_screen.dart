import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/functions/helper/routing_helper.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/accept_offer_by_driver_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/check_accept_by_driver_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/check_accept_by_rider_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/get_all_trip_rider_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/send_offer_by_driver_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/ride_trip_card.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

class AllRiderTripScreen extends StatefulWidget {
  const AllRiderTripScreen({super.key});

  @override
  State<AllRiderTripScreen> createState() => _AllRiderTripScreenState();
}

class _AllRiderTripScreenState extends State<AllRiderTripScreen> {
  @override
  void initState() {
    super.initState();
    context.read<GetAllTripRiderCubit>().getAllTrip();
  }

  @override
  Widget build(BuildContext context) {
    return SharedScaffold(
      mainCategoryId: 1,
      body: BlocListener<CheckAcceptByDriverCubit, RiderState>(
        listener: (context, state) {
          log(state.toString(),
              name: "lskdfjslkdfjslkdfjslkdjfslkdjfslkdjfslkdjfslkdfj");
          if (state is SuccessCheckAcceptByDriverState) {
            context.pushAndRemoveUntil(Routes.TRIPINFOBYRIDERSCREEN, extra: state.model, (route) => false,);
          }
        },
        child: BlocListener<CheckAcceptByRiderCubit, RiderState>(
          listener: (context, state) {
            log(state.toString(),
                name: "lskdfjslkdfjslkdfjslkdjfslkdjfslkdjfslkdjfslkdfj");
            if (state is SuccessCheckAcceptByRiderState) {
              context.pushAndRemoveUntil(Routes.TRIPINFOBYDRIVERSCREEN, extra: state.model,  (route) => false,);
            }
          },
          child: BlocConsumer<AcceptOfferByDriverCubit, RiderState>(
            listener: (context, state) {
              if (state is FailureRiderState) {
                context.pop();
                showErrorMessage(
                    context, getFailureMessage(state.failure, context));
              }
              if (state is SuccessAcceptOfferByDriverState) {
                context.pushAndRemoveUntil(Routes.TRIPINFOBYDRIVERSCREEN, extra: state.model, (route) => false,);
              }
            },
            builder: (context, state) {
              log(state.toString(), name: "slkfjsldkjfdkdkkkkdddddddddd");
              if (state is LoadingRiderState) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return BlocConsumer<SendOfferByDriverCubit, RiderState>(
                listener: (context, state) {
                  if (state is FailureRiderState) {
                    context.pop();
                    showErrorMessage(
                        context, getFailureMessage(state.failure, context));
                  }
                  if (state is SuccessSendOfferByDriverState) {
                    context.pop();
                    showSuccessMessage(context, LocaleKeys.yourOfferSendSuccess.tr());
                  }
                },
                builder: (context, state) {
                  // log(state.toString(), name: "lsdkjfsdlkjfldksjkdd");
                  if (state is LoadingRiderState) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return Column(
                    children: [
                      Expanded(
                        child: BlocBuilder<GetAllTripRiderCubit, RiderState>(
                          builder: (context, state) {
                            if (state is LoadingRiderState) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.PRIMARY_COLOR,
                                ),
                              );
                            }
                            if (state is SuccessGetAllTripsRiderState) {
                              return SingleChildScrollView(
                                child: Column(
                                  children: state.list
                                      .map(
                                        (e) {
                                          return RideTripCard(
                                            model: e,
                                          );
                                        },
                                      )
                                      .toList()
                                      .reversed
                                      .toList(),
                                ),
                              );
                            } else {
                              return Container();
                            }
                          },
                        ),
                      )
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
