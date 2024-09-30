import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/functions/helper/routing_helper.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/presentation/cubits/destination_location/destination_location_cubit.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/presentation/cubits/fetch_car_brands/fetch_car_brands_cubit.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/presentation/cubits/fetch_car_models/fetch_car_models_cubit.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/presentation/cubits/fetch_price_distance/fetch_price_distance_cubit.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/presentation/cubits/publish_trip_join/publish_trip_join_cubit.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/presentation/cubits/starting_location/starting_location_cubit.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/presentation/cubits/trip_join_view/trip_join_view_cubit.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/presentation/views/widgets/button.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:fourtyninehub/routes/routes.dart';

class PublishButton extends StatefulWidget {
  const PublishButton({
    super.key,
    required this.formKey,
  });
  final GlobalKey<FormState> formKey;
  @override
  State<PublishButton> createState() => _PublishButtonState();
}

class _PublishButtonState extends State<PublishButton> {
  late final TripJoinViewCubit tripJoinViewCubit;
  late final StartingLocationCubit startingCubit;
  late final DestinationLocationCubit destinationCubit;
  late final FetchCarBrandsCubit fetchCarBrandsCubit;
  late final FetchCarModelsCubit fetchCarModelCubit;
  late final PublishTripJoinCubit publishTripJoinCubit;
  late final FetchPriceDistanceCubit fetchPriceDistanceCubit;
  @override
  void initState() {
    tripJoinViewCubit = context.read<TripJoinViewCubit>();
    startingCubit = context.read<StartingLocationCubit>();
    destinationCubit = context.read<DestinationLocationCubit>();
    fetchCarBrandsCubit = context.read<FetchCarBrandsCubit>();
    fetchCarModelCubit = context.read<FetchCarModelsCubit>();
    publishTripJoinCubit = context.read<PublishTripJoinCubit>();
    fetchPriceDistanceCubit = context.read<FetchPriceDistanceCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PublishTripJoinCubit, PublishTripJoinState>(
        listener: (context, state) {
          if (state is PublishTripJoinSuccess) {
            Future.delayed(const Duration(seconds: 1)).then((value) {
              context.pushAndRemoveUntil(
                  Routes.AVAILABLE_TRIPS, (route) => true);
            });
          }
          if (state is PublishTripJoinFailed) {
            showErrorMessage(context, state.errorMessage);
          }
        },
        child: Stack(
          children: [
            CustomButton(
              height: 80.h,
              onTap: () async {
                if (widget.formKey.currentState!.validate()) {
                  await fetchData();
                  // pr('${publishTripJoinCubit.tripJoinPublishParam}');
                  // return;
                  await publishTripJoinCubit.publishTripJoin();
                }
              },
              title: 'Publish',
            ),
            Positioned(
              top: 0,
              right: 20,
              child: SizedBox(
                height: 80.h,
                child: BlocBuilder<PublishTripJoinCubit, PublishTripJoinState>(
                  builder: (context, state) {
                    if (state is PublishTripJoinLoading) {
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      );
                    }
                    if (state is PublishTripJoinSuccess) {
                      return Center(
                        child: Icon(Icons.check,
                            color: Colors.green[400], size: 30),
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
            )
          ],
        ));
  }

  Future<void> fetchData() async {
    publishTripJoinCubit.tripJoinPublishParam =
        publishTripJoinCubit.tripJoinPublishParam.copyWith(
      fromAr: fetchPriceDistanceCubit.tripInfoEntity?.originAddress ?? '',
      toAr: fetchPriceDistanceCubit.tripInfoEntity?.destinationAddress ?? '',
      fromEn: startingCubit.startingLocation?.address,
      toEn: destinationCubit.destinationLocation?.address,
      distance: fetchPriceDistanceCubit.tripInfoEntity?.distance,
      duration: fetchPriceDistanceCubit.tripInfoEntity?.duration,
      price: fetchPriceDistanceCubit.tripInfoEntity?.price,
      categoryId: UIConst.addTripJoinCategoryId,
      vehicleBrand: fetchCarBrandsCubit.brand,
      vehicleModel: fetchCarModelCubit.model,
      passengers: tripJoinViewCubit.numberOfSeats,
      phone: tripJoinViewCubit.phoneNumber,
      time: _timeStamp(),
      isRepeat: tripJoinViewCubit.repeate,
    );
  }

  int _timeStamp() {
    int year = tripJoinViewCubit.tripJoinDate.year;
    int month = tripJoinViewCubit.tripJoinDate.month;
    int day = tripJoinViewCubit.tripJoinDate.day;
    int hour = tripJoinViewCubit.tripJoinTimeOfDay.hour;
    int minute = tripJoinViewCubit.tripJoinTimeOfDay.minute;
    return DateTime(year, month, day, hour, minute).millisecondsSinceEpoch;
  }
}
