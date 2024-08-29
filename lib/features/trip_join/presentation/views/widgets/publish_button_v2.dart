import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/trip_join/presentation/cubits/destination_location/destination_location_cubit.dart';
import 'package:fourtyninehub/features/trip_join/presentation/cubits/fetch_car_brands/fetch_car_brands_cubit.dart';
import 'package:fourtyninehub/features/trip_join/presentation/cubits/fetch_car_models/fetch_car_models_cubit.dart';
import 'package:fourtyninehub/features/trip_join/presentation/cubits/fetch_price_distance/fetch_price_distance_cubit.dart';
import 'package:fourtyninehub/features/trip_join/presentation/cubits/publish_trip_join/publish_trip_join_cubit.dart';
import 'package:fourtyninehub/features/trip_join/presentation/cubits/starting_location/starting_location_cubit.dart';
import 'package:fourtyninehub/features/trip_join/presentation/cubits/trip_join_view/trip_join_view_cubit.dart';
import 'package:fourtyninehub/features/trip_join/presentation/views/widgets/button.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class PublishButton extends StatefulWidget {
  const PublishButton({
    super.key,
  });

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
    return BlocConsumer<PublishTripJoinCubit, PublishTripJoinState>(
      listener: (context, state) {
        if (state is PublishTripJoinFailed) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage, style: Styles.headerText(color: Colors.white)),
              backgroundColor: Colors.red[500],
              duration: const Duration(seconds: 2),
            ),
          );
        }
      },
      builder: (context, state) {
        return CustomButton(
          height: 50,
          onTap: () async {
            await fetchData();
            if ([
              publishTripJoinCubit.tripJoinPublishParam.vehicleBrand,
              publishTripJoinCubit.tripJoinPublishParam.vehicleModel
            ].contains(null)) {
              if (publishTripJoinCubit.tripJoinPublishParam.vehicleBrand == null) {
                publishTripJoinCubit.emitFailure('Vechile Brand is Required');
              }
              if (publishTripJoinCubit.tripJoinPublishParam.vehicleModel == null) {
                publishTripJoinCubit.emitFailure('Vechile Model is Required');
              }
              return;
            }
            print(' ========= ${publishTripJoinCubit.tripJoinPublishParam}');
            // return;
            await publishTripJoinCubit.publishTripJoin();
          },
          title: 'Publish',
        );
      },
    );
  }

  Future<void> fetchData() async {
    publishTripJoinCubit.tripJoinPublishParam = publishTripJoinCubit.tripJoinPublishParam.copyWith(
      from: fetchPriceDistanceCubit.tripInfoEntity?.originAddress,
      to: fetchPriceDistanceCubit.tripInfoEntity?.destinationAddress,
      distance: fetchPriceDistanceCubit.tripInfoEntity?.distance,
      duration: fetchPriceDistanceCubit.tripInfoEntity?.duration,
      price: fetchPriceDistanceCubit.tripInfoEntity?.price,
      categoryId: '62ea00e269ea29c91dfc390c',
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
