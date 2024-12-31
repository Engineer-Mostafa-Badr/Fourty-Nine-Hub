import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/functions/helper/routing_helper.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/check_accept_by_rider_model/check_accept_by_rider_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/check_accept_trip_from_driver_model/check_accept_trip_from_driver_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/NoSocket/check_trip_end_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/NoSocket/get_user_login_trip_no_socket_cubit.dart';
import 'package:fourtyninehub/features/carpool/avaliable_routes/presentation/cubits/get_currency/cubit/get_currency_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/TripCubit/check_start_record_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/TripCubit/check_stop_record_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/check_accept_by_driver_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/check_accept_by_rider_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/get_ride_currentTrip_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/get_trip_info_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_trip_reel_time_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/select_cateogry_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/create_trip_rider_form.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/map_and_address_finder_ride.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/my_trip_info_ride_widget.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/ride_banner_widget.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/rider_banner_widget.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/shipping_banner_widget.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/sub_cateogry_ride_widget.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/sub_cateogry_shipping_widget.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/trip_info_request_widget.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:fourtyninehub/secrets/controller/secrets_cubit.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';

class ShippingRiderTabScreen extends StatefulWidget {
  const ShippingRiderTabScreen({super.key});

  @override
  State<ShippingRiderTabScreen> createState() => _ShippingRiderTabScreenState();
}

class _ShippingRiderTabScreenState extends State<ShippingRiderTabScreen> {
  bool isButtonSheet = false;
  GlobalKey<FormState> formKey = GlobalKey();
  bool isCheck = false;
  @override
  void initState() {
    BlocProvider.of<GetCurrencyCubit>(context).getCurrencyData();
    context.read<CheckTripEndCubit>().check();
    BlocProvider.of<GetCurrencyCubit>(context).getCurrencyData();
    // context.read<GetRideCurrenttripCubit>().get();
    super.initState();
    context.read<CheckStopRecordCubit>().checkStop();
    context.read<CheckStartRecordCubit>().checkStart();
    BlocProvider.of<SecretsCubit>(context).getAllSecrets();
    // context.read<CheckDriverTypeCubit>().checkDriverType();
    if (!isCheck) {
      context.read<CheckAcceptByDriverCubit>().check();
      context.read<CheckAcceptByRiderCubit>().check();
      context.read<GetUserLoginTripNoSocketCubit>().get();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SharedScaffold(
      mainCategoryId: 1,
      body: Form(
        key: formKey,
        child: BlocListener<GetRideCurrenttripCubit, RiderState>(
          listener: (context, state) {
            if (state is SuccessGetCurrentTripState) {
              if (state.model.isDriver ?? false) {
                context.pushAndRemoveUntil(
                  Routes.TRIPINFOBYDRIVERSCREEN,
                  extra: CheckAcceptByRiderModel.fromJson(state.model.toJson()),
                  (route) => false,
                );
              } else {
                context.pushAndRemoveUntil(
                  Routes.TRIPINFOBYRIDERSCREEN,
                  extra: CheckAcceptTripFromDriverModel.fromJson(
                      state.model.toJson()),
                  (route) => false,
                );
              }
            }
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                // const Row(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     Sizer(),
                //     Flexible(
                //       child: RiderBannerWidget(),
                //     ),
                //     Sizer(),
                //     Flexible(
                      // child: ShippingBannerWidget(),
                //     ),
                //     Sizer(),
                //   ],
                // ),
                RideBannerWidget(),
                const SubCateogryRideWidget(),
                SubCateogryShippingWidget(
                  formKey: formKey,
                ),
                BlocBuilder<SelectCateogryCubit, RiderState>(
                  builder: (context, state) {
                    if (state is SuccessSelectCateogryState) {
                      if (state.type == 0) {
                        return Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 12),
                          child: Column(
                            children: [
                              const Sizer(),
                              BlocBuilder<RiderTripReelTimeCubit,
                                  RiderState>(
                                builder: (context, state) {
                                  if (state is ViewPickTripDataState) {
                                    return Column(
                                      children: [
                                        const MapAndAddressFinderRide(),
                                        BlocBuilder<GetTripInfoCubit,
                                            RiderState>(
                                          builder: (context, state) {
                                            if (state
                                                is SuccessGetTripInfoState) {
                                              return BlocProvider(
                                                create: (context) =>
                                                    GetCurrencyCubit(
                                                        serviceLocator()),
                                                child:
                                                    TripInfoRequestWidget(
                                                  model: state.model,
                                                ),
                                              );
                                            } else {
                                              return Container();
                                            }
                                          },
                                        )
                                      ],
                                    );
                                  } else if (state
                                      is NotViewPickTripDataState) {
                                    return BlocBuilder<
                                        GetUserLoginTripNoSocketCubit,
                                        RiderState>(
                                      builder: (context, state) {
                                        if (state
                                            is SuccessGetUserLoginTripNoSocketState) {
                                          return MyTripInfoRideWidget(
                                            model: state.model,
                                          );
                                        } else {
                                          return const CreateTripRiderForm();
                                        }
                                      },
                                    );
                                  } else {
                                    return Container();
                                  }
                                },
                              ),
                            ],
                          ),
                        );
                      } else {
                        return Container();
                      }
                    } else {
                      return Container();
                    }
                  },
                ),
                const Sizer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
