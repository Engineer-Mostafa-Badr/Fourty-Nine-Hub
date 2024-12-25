import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/functions/helper/routing_helper.dart';
import 'package:fourtyninehub/common/widgets/dynamic/bottom_navigator.dart';
import 'package:fourtyninehub/common/widgets/dynamic/drawer.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/carpool/add_new_route/presentation/cubits/verify_complet_driver/cubit/verify_complete_driver_cubit.dart';
import 'package:fourtyninehub/features/carpool/avaliable_routes/presentation/cubits/accept_trip/cubit/accept_trip_for_driver_cubit.dart';
import 'package:fourtyninehub/features/carpool/avaliable_routes/presentation/cubits/get_available_trips_for_drivers/cubit/get_available_trips_for_drivers_cubit.dart';
import 'package:fourtyninehub/features/carpool/avaliable_routes/presentation/cubits/get_currency/cubit/get_currency_cubit.dart';
import 'package:fourtyninehub/features/carpool/avaliable_routes/presentation/widgets/accepted_card_for_driver.dart';
import 'package:fourtyninehub/features/carpool/avaliable_routes/presentation/widgets/test_card_dashboard.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/accept_offer_by_driver_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/change_driver_status_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/check_accept_by_driver_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/check_accept_by_rider_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/get_all_trip_rider_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/send_offer_by_driver_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/ride_trip_card.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';

class AllRiderTripScreen extends StatefulWidget {
  const AllRiderTripScreen({super.key});

  @override
  State<AllRiderTripScreen> createState() => _AllRiderTripScreenState();
}

bool? isReady;

class _AllRiderTripScreenState extends State<AllRiderTripScreen> {
  @override
  void initState() {
    BlocProvider.of<ChangeDriverStatusCubit>(context).getDriverStatus();

    BlocProvider.of<GetCurrencyCubit>(context).getCurrencyData();
    BlocProvider.of<GetAvailableTripsForDriversCubit>(context)
        .fetchAllCarpoolTripsForDriver();
    BlocProvider.of<VerifyCompleteDriverCubit>(context).getAcceptedTrips();
    super.initState();
    context.read<GetAllTripRiderCubit>().getAllTrip();
  }

  @override
  Widget build(BuildContext context) {
    return SharedScaffold(
      mainCategoryId: 1,
      body: DefaultTabController(
        length: 2,
        initialIndex: 0,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    context.isArabic ? "مستعد" : "Ready",
                    style: Styles.headerText(fontWeight: FontWeight.w500),
                  ),
                  BlocListener<ChangeDriverStatusCubit, RiderState>(
                    listener: (context, state) {
                      if (state is SuccessGetDriverStatus) {
                        setState(() {
                          isReady = state.status;
                        });
                      }
                    },
                    child: Switch(
                      activeTrackColor: AppColors.PRIMARY_COLOR,
                      inactiveTrackColor: Colors.grey,
                      value: isReady ?? false,
                      onChanged: (value) {
                        setState(() async {
                          await BlocProvider.of<ChangeDriverStatusCubit>(
                                  context)
                              .changeDriverStatus();
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            TabBar(
              labelColor: AppColors.PRIMARY_COLOR,
              unselectedLabelColor: AppColors.GREY_DARK_COLOR,
              indicatorColor: AppColors.PRIMARY_COLOR,
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: [
                Tab(text: LocaleKeys.ride.localize),
                Tab(text: LocaleKeys.carpool.localize),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  BlocListener<CheckAcceptByDriverCubit, RiderState>(
                    listener: (context, state) {
                      log(state.toString(),
                          name:
                              "lskdfjslkdfjslkdfjslkdjfslkdjfslkdjfslkdjfslkdfj");
                      if (state is SuccessCheckAcceptByDriverState) {
                        context.pushAndRemoveUntil(
                          Routes.TRIPINFOBYRIDERSCREEN,
                          extra: state.model,
                          (route) => false,
                        );
                      }
                    },
                    child: BlocListener<CheckAcceptByRiderCubit, RiderState>(
                      listener: (context, state) {
                        log(state.toString(),
                            name:
                                "lskdfjslkdfjslkdfjslkdjfslkdjfslkdjfslkdjfslkdfj");
                        if (state is SuccessCheckAcceptByRiderState) {
                          context.pushAndRemoveUntil(
                            Routes.TRIPINFOBYDRIVERSCREEN,
                            extra: state.model,
                            (route) => false,
                          );
                        }
                      },
                      child: BlocConsumer<AcceptOfferByDriverCubit, RiderState>(
                        listener: (context, state) {
                          if (state is FailureRiderState) {
                            context.pop();
                            showErrorMessage(context,
                                getFailureMessage(state.failure, context));
                          }
                          if (state is SuccessAcceptOfferByDriverState) {
                            context.pushAndRemoveUntil(
                              Routes.TRIPINFOBYDRIVERSCREEN,
                              extra: state.model,
                              (route) => false,
                            );
                          }
                        },
                        builder: (context, state) {
                          log(state.toString(),
                              name: "slkfjsldkjfdkdkkkkdddddddddd");
                          if (state is LoadingRiderState) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return BlocConsumer<SendOfferByDriverCubit,
                              RiderState>(
                            listener: (context, state) {
                              if (state is FailureRiderState) {
                                context.pop();
                                showErrorMessage(context,
                                    getFailureMessage(state.failure, context));
                              }
                              if (state is SuccessSendOfferByDriverState) {
                                context.pop();
                                showSuccessMessage(context,
                                    LocaleKeys.yourOfferSendSuccess.tr());
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
                                    child: BlocBuilder<GetAllTripRiderCubit,
                                        RiderState>(
                                      builder: (context, state) {
                                        if (state is LoadingRiderState) {
                                          return const Center(
                                            child: CircularProgressIndicator(
                                              color: AppColors.PRIMARY_COLOR,
                                            ),
                                          );
                                        }
                                        if (state
                                            is SuccessGetAllTripsRiderState) {
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
                  DefaultTabController(
                    length: 2,
                    child: Column(
                      children: [
                        TabBar(
                          labelColor: AppColors.PRIMARY_COLOR,
                          unselectedLabelColor: AppColors.GREY_DARK_COLOR,
                          indicatorColor: AppColors.PRIMARY_COLOR,
                          tabs: [
                            Tab(text: LocaleKeys.availableTrips.localize),
                            Tab(text: context.isArabic ? "رحلاتي" : "My trips"),
                          ],
                        ),
                        Expanded(
                          child: TabBarView(
                            children: [
                              BlocProvider(
                                create: (context) =>
                                    AcceptTripForDriverCubit(serviceLocator()),
                                child: BlocListener<AcceptTripForDriverCubit,
                                    AcceptTripForDriverState>(
                                  listener: (context, state) {
                                    if (state is AcceptTripForDriverFailure) {
                                      showErrorMessage(
                                          context, state.errorMessage);
                                    }
                                    if (state is AcceptTripForDriverSuccess) {
                                      showSuccessMessage(
                                          context,
                                          LocaleKeys.acceptRequestSuccessfully
                                              .localize);
                                    }
                                    BlocProvider.of<
                                                GetAvailableTripsForDriversCubit>(
                                            context)
                                        .fetchAllCarpoolTripsForDriver();
                                  },
                                  child: BlocBuilder<
                                      GetAvailableTripsForDriversCubit,
                                      GetAvailableTripsForDriversState>(
                                    builder: (context, state) {
                                      if (state
                                          is GetAvailableTripsForDriversLoading) {
                                        return const Center(
                                            child: CircularProgressIndicator(
                                          color: AppColors.PRIMARY_COLOR,
                                        ));
                                      } else if (state
                                          is GetAvailableTripsForDriversSuccess) {
                                        return ListView.builder(
                                          itemCount: state.trips.length,
                                          itemBuilder: (context, index) {
                                            final trip = state.trips[index];
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 16),
                                              child: TestCardDashboard(
                                                  entity: trip),
                                            );
                                          },
                                        );
                                      } else if (state
                                          is GetAvailableTripsForDriversFailure) {
                                        return Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(LocaleKeys
                                                  .noTripsAvailable.localize),
                                              const SizedBox(height: 16),
                                              ElevatedButton(
                                                style: const ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStatePropertyAll(
                                                            AppColors
                                                                .PRIMARY_COLOR)),
                                                onPressed: () {
                                                  context
                                                      .read<
                                                          GetAvailableTripsForDriversCubit>()
                                                      .fetchAllCarpoolTripsForDriver();
                                                },
                                                child: Text(
                                                  context.isArabic
                                                      ? "اعادة التحميل"
                                                      : "Reload",
                                                  style: const TextStyle(
                                                      color: AppColors
                                                          .AUTH_CONTAINER_COLOR),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                      return const Center(
                                          child: Text('No data available.'));
                                    },
                                  ),
                                ),
                              ),
                              BlocProvider(
                                  create: (context) => VerifyCompleteDriverCubit(
                                      verifyOtpCompleteSeatDriverRemoteDataSource:
                                          serviceLocator())
                                    ..getAcceptedTrips(),
                                  child: BlocBuilder<VerifyCompleteDriverCubit,
                                      VerifyCompleteDriverState>(
                                    builder: (context, state) {
                                      if (state is GetAcceptedTripLoading) {
                                        return const Center(
                                            child: CircularProgressIndicator(
                                                color:
                                                    AppColors.PRIMARY_COLOR));
                                      } else if (state
                                          is GetAcceptedTripSuccess) {
                                        final tripParam =
                                            state.carpoolTripParam;

                                        return ListView.builder(
                                          itemCount: 1,
                                          itemBuilder: (context, index) {
                                            final trip = tripParam;
                                            return BlocProvider.value(
                                              value: context.read<
                                                  VerifyCompleteDriverCubit>(),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 16,
                                                        horizontal: 8),
                                                child: AcceptedCardForDriver(
                                                    entity: trip),
                                              ),
                                            );
                                          },
                                        );
                                      } else if (state
                                          is GetAcceptedTripFailure) {
                                        return Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(LocaleKeys
                                                  .noTripsAvailable.localize),
                                              const SizedBox(height: 16),
                                              ElevatedButton(
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          AppColors
                                                              .PRIMARY_COLOR),
                                                ),
                                                onPressed: () {
                                                  context
                                                      .read<
                                                          VerifyCompleteDriverCubit>()
                                                      .getAcceptedTrips();
                                                },
                                                child: Text(
                                                  context.isArabic
                                                      ? "اعادة التحميل"
                                                      : "Reload",
                                                  style: const TextStyle(
                                                      color: AppColors
                                                          .AUTH_CONTAINER_COLOR),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                      return const Center(
                                          child: Text(
                                              'No accepted trips available.'));
                                    },
                                  ))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
