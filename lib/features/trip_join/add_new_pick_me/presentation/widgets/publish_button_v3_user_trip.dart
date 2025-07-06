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
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:fourtyninehub/core/widget/custom_circular_progress_indicator.dart';

import '../../../../../res/style/app_colors.dart';

class PublishButtonV3UserTrip extends StatelessWidget {
  const PublishButtonV3UserTrip({
    super.key,
    required this.formKey,
    this.text,
    this.color = AppColors.PRIMARY_COLOR,
  });

  final GlobalKey<FormState> formKey;
  final Color color;
  final String? text;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddNewPickMeTripCubit, AddNewPickMeTripState>(
      listener: (context, state) {

      },
      child: Stack(
        children: [
          InkWell(
            onTap: () async {
              if (formKey.currentState!.validate()) {
                await _submitPickMeTrip(context);
              }
            },
            child: Container(
              height: 80.h,
        
              //  padding: EdgeInsets.symmetric(vertical: 7.5.h, horizontal: 30.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: color,
              ),
              alignment: Alignment.center,
              child: Text(
              text??  LocaleKeys.publish.localize,
                style: Styles.headerText(color: Colors.white),
              ),
            ),
          ),
          Positioned.directional(
            top: 0,
            end: 20,
            textDirection:
                context.isArabic ? TextDirection.rtl : TextDirection.ltr,
            child: SizedBox(
              height: 80.h,
              child: BlocBuilder<AddNewPickMeTripCubit, AddNewPickMeTripState>(
                buildWhen: (previous, current) =>
                    previous.runtimeType != current.runtimeType,
                builder: (context, state) {
                  if (state.status==AddNewPickMeTripStateStatus.loading) {
                    return const Center(
                      child: CustomCircularProgressIndicator(color: Colors.white),
                    );
                  }
                  if (state.status==AddNewPickMeTripStateStatus.success) {
                    return Center(
                      child:
                          Icon(Icons.check, color: Colors.green[400], size: 30),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _submitPickMeTrip(BuildContext context) async {
    final tripJoinViewCubit = context.read<TripJoinViewCubit>();
    final fetchPriceDistanceCubit = context.read<FetchPriceDistanceCubit>();
    final getLatAndLongCubit = context.read<GetLatAndLongCubit>();
    final destGetLatAndLongCubit = context.read<DestGetLatAndLongCubit>();
    final addNewPickMeTripCubit = context.read<AddNewPickMeTripCubit>();

    final tripInfo = fetchPriceDistanceCubit.tripInfoEntity;

    final AddNewPickMeParam addNewPickMeParam = AddNewPickMeParam(
      categoryId: "62ea008d69ea29c91dfc3908",
      distance: tripInfo?.distance,
      duration: tripInfo?.duration ?? 0,
      fromAr: tripInfo?.originAddress ?? '',
      isRepeat: tripJoinViewCubit.repeate,
      passengers: tripJoinViewCubit.numberOfSeats,
      phone: tripJoinViewCubit.phoneNumber,
      price: tripInfo?.price,
      time: _getTimeStamp(tripJoinViewCubit),
      toAr: tripInfo?.destinationAddress ?? '',
      fromEn: getLatAndLongCubit.fromEn,
      toEn: destGetLatAndLongCubit.toEn,
    );

    await addNewPickMeTripCubit.addNewPickMeTrip(
        addNewPickMeParam: addNewPickMeParam);
  }

  int _getTimeStamp(TripJoinViewCubit tripJoinViewCubit) {
    final date = tripJoinViewCubit.tripJoinDate;
    final time = tripJoinViewCubit.tripJoinTimeOfDay;
    return DateTime(date.year, date.month, date.day, time.hour, time.minute)
        .millisecondsSinceEpoch;
  }
}
