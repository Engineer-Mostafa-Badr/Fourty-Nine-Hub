import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/functions/helper/routing_helper.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/carpool/add_new_route/presentation/cubits/get_llat_and_long/cubit/cubit/dest_get_lat_and_long_cubit.dart';
import 'package:fourtyninehub/features/carpool/add_new_route/presentation/cubits/get_llat_and_long/cubit/get_lat_and_long_cubit.dart';
import 'package:fourtyninehub/features/trip_join/add_new_pick_me/domain/entities/add_new_pick_me_param.dart';
import 'package:fourtyninehub/features/trip_join/add_new_pick_me/presentation/cubits/cubit/add_new_pick_me_trip_cubit.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/presentation/cubits/destination_location/destination_location_cubit.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/presentation/cubits/fetch_price_distance/fetch_price_distance_cubit.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/presentation/cubits/starting_location/starting_location_cubit.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/presentation/cubits/trip_join_view/trip_join_view_cubit.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/presentation/views/widgets/button.dart';
import 'package:fourtyninehub/routes/routes.dart';

class PublishButtonV3UserTrip extends StatefulWidget {
  const PublishButtonV3UserTrip({
    super.key,
    required this.formKey,
  });
  final GlobalKey<FormState> formKey;
  @override
  State<PublishButtonV3UserTrip> createState() =>
      _PublishButtonV3UserTripState();
}

class _PublishButtonV3UserTripState extends State<PublishButtonV3UserTrip> {
  late final TripJoinViewCubit tripJoinViewCubit;
  late final StartingLocationCubit startingCubit;
  late final DestinationLocationCubit destinationCubit;

  // late final FetchCarBrandsCubit fetchCarBrandsCubit;
  // late final FetchCarModelsCubit fetchCarModelCubit;
  late final AddNewPickMeTripCubit addNewPickMeTripCubit;
  late final FetchPriceDistanceCubit fetchPriceDistanceCubit;
  @override
  void initState() {
    tripJoinViewCubit = context.read<TripJoinViewCubit>();
    startingCubit = context.read<StartingLocationCubit>();
    destinationCubit = context.read<DestinationLocationCubit>();
    // fetchCarBrandsCubit = context.read<FetchCarBrandsCubit>();
    // fetchCarModelCubit = context.read<FetchCarModelsCubit>();
    addNewPickMeTripCubit = context.read<AddNewPickMeTripCubit>();
    fetchPriceDistanceCubit = context.read<FetchPriceDistanceCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddNewPickMeTripCubit, AddNewPickMeTripState>(
        listener: (context, state) {
          if (state is AddNewPickMeTripSuccess) {
            Future.delayed(const Duration(seconds: 1)).then((value) {
              context.pushAndRemoveUntil(
                  Routes.AVAILABLE_TRIPS, (route) => true);
            });
          }
          if (state is AddNewPickMeTripFailure) {
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
                }
              },
              title: LocaleKeys.publish.localize,
            ),
            Positioned.directional(
              top: 0,
              end: 20,
              textDirection:
                  context.isArabic ? TextDirection.rtl : TextDirection.ltr,
              child: SizedBox(
                height: 80.h,
                child:
                    BlocBuilder<AddNewPickMeTripCubit, AddNewPickMeTripState>(
                  builder: (context, state) {
                    if (state is AddNewPickMeTripLoading) {
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      );
                    }
                    if (state is AddNewPickMeTripSuccess) {
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
    AddNewPickMeParam addNewPickMeParam = AddNewPickMeParam(
      categoryId: "62ea008d69ea29c91dfc3908",
      distance: fetchPriceDistanceCubit.tripInfoEntity?.distance,
      duration: fetchPriceDistanceCubit.tripInfoEntity?.duration ?? 0,
      fromAr: fetchPriceDistanceCubit.tripInfoEntity?.originAddress ?? '',
      // fromEn: startingCubit.startingLocation?.address ?? ' ',
      isRepeat: tripJoinViewCubit.repeate,
      passengers: tripJoinViewCubit.numberOfSeats,
      phone: tripJoinViewCubit.phoneNumber,
      price: fetchPriceDistanceCubit.tripInfoEntity?.price,
      time: _timeStamp(),
      toAr: fetchPriceDistanceCubit.tripInfoEntity?.destinationAddress ?? '',
      // toEn: destinationCubit.destinationLocation?.address ?? ' ',
      fromEn: BlocProvider.of<GetLatAndLongCubit>(context).fromEn,
      toEn: BlocProvider.of<DestGetLatAndLongCubit>(context).toEn,
    );
    print(
      "addNewPickMeParam ----------$addNewPickMeParam /n",
    );
    await addNewPickMeTripCubit.addNewPickMeTrip(
        addNewPickMeParam: addNewPickMeParam);
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
