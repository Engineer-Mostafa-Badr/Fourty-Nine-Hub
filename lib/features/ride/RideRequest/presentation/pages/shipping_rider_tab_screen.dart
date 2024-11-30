import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/functions/helper/routing_helper.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/check_accept_by_driver_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/check_accept_by_rider_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/get_trip_info_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_trip_reel_time_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/select_cateogry_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/create_trip_rider_form.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/map_and_address_finder_ride.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/rider_banner_widget.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/shipping_banner_widget.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/sub_cateogry_ride_widget.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/sub_cateogry_shipping_widget.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/trip_info_request_widget.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:fourtyninehub/secrets/controller/secrets_cubit.dart';

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
    super.initState();
    BlocProvider.of<SecretsCubit>(context).getAllSecrets();
    // context.read<CheckDriverTypeCubit>().checkDriverType();
    if (!isCheck) {
      context.read<CheckAcceptByDriverCubit>().check();
      context.read<CheckAcceptByRiderCubit>().check();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SharedScaffold(
      mainCategoryId: 1,
      body: Form(
        key: formKey,
        child: BlocListener<CheckAcceptByDriverCubit, RiderState>(
          listener: (context, state) {
            log(state.toString(),
                name: "lskdfjslkdfjslkdfjslkdjfslkdjfslkdjfslkdjfslkdfj");
            if (state is SuccessCheckAcceptByDriverState) {
              log(isCheck.toString(), name: "lskdjflskdjfdkddddddhhhhhhhhhh");
              isCheck = true;
              log(isCheck.toString(), name: "lskdjflskdjfdkddddddhhhhhhhhhh");
              context.pushAndRemoveUntil(
                Routes.TRIPINFOBYRIDERSCREEN,
                extra: state.model,
                (route) => false,
              );
            }
          },
          child: BlocListener<CheckAcceptByRiderCubit, RiderState>(
            listener: (context, state) {
              if (state is SuccessCheckAcceptByRiderState) {
                isCheck = true;
                context.pushAndRemoveUntil(
                  Routes.TRIPINFOBYDRIVERSCREEN,
                  extra: state.model,
                  (route) => false,
                );
              }
            },
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Sizer(),
                      Flexible(
                        child: RiderBannerWidget(),
                      ),
                      Sizer(),
                      Flexible(
                        child: ShippingBannerWidget(),
                      ),
                      Sizer(),
                    ],
                  ),
                  const SubCateogryRideWidget(),
                  SubCateogryShippingWidget(
                    formKey: formKey,
                  ),
                  BlocBuilder<SelectCateogryCubit, RiderState>(
                    builder: (context, state) {
                      if (state is SuccessSelectCateogryState) {
                        if (state.type == 0) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Column(
                              children: [
                                const Sizer(),
                                BlocBuilder<RiderTripReelTimeCubit, RiderState>(
                                  builder: (context, state) {
                                    if (state is ViewPickTripDataState) {
                                      print("hello from ride ==== \n");
                                      return Column(
                                        children: [
                                          const MapAndAddressFinderRide(),
                                          BlocBuilder<GetTripInfoCubit,
                                              RiderState>(
                                            builder: (context, state) {
                                              if (state
                                                  is SuccessGetTripInfoState) {
                                                return TripInfoRequestWidget(
                                                  model: state.model,
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
                                      return const CreateTripRiderForm();
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
      ),
    );
  }
}
