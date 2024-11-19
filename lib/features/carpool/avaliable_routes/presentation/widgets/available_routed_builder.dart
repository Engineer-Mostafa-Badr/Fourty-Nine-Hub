import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/carpool/avaliable_routes/presentation/cubits/cubit/get_all_trips_cubit.dart';
import 'package:fourtyninehub/features/carpool/avaliable_routes/presentation/cubits/cubit/get_all_trips_state.dart';
import 'package:fourtyninehub/features/carpool/avaliable_routes/presentation/widgets/available_routes_card.dart';
import 'package:fourtyninehub/features/trip_join/helpers/print_helper.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/widgets/available_trip_button.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';

class AvailableRoutesBuilder extends StatefulWidget {
  const AvailableRoutesBuilder({super.key, required this.type});
  final String type;
  @override
  State<AvailableRoutesBuilder> createState() => _AvailableRoutesBuilderState();
}

class _AvailableRoutesBuilderState extends State<AvailableRoutesBuilder> {
  final userId = serviceLocator<UserCubit>().state.data?.id ?? '';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetAllTripsCubit, GetAllTripsState>(
      builder: (context, state) {
        if (state is GetAllTripsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is GetAllTripsSuccess) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: state.trips.length,
              itemBuilder: (context, index) {
                // print(state.trips.length);
                final trip = state.trips[index];
                // print("Sucesss \n");
                // final int time = ;
                // print("time $time \n");
                if (widget.type == "expired" &&
                    DateTime.now()
                            .difference(DateTime.parse(
                                state.trips[index].createdAt.toString()))
                            .inMinutes >
                        60) {
                  return AvaiableRoutesCard(entity: trip);
                }
                if (widget.type == "available" &&
                    DateTime.now()
                            .difference(
                                DateTime.parse(trip.createdAt.toString()))
                            .inMinutes <
                        60) {
                  return AvaiableRoutesCard(entity: trip);
                }

                if (widget.type == "myBookings" &&
                    (trip.ownerId == userId ||
                        trip.locations[0].bookedUser?.id == userId ||
                        trip.locations[1].bookedUser?.id == userId ||
                        trip.locations[2].bookedUser?.id == userId)) {
                  return AvaiableRoutesCard(entity: trip);
                }
                return const SizedBox();
              },
            ),
          );
        } else if (state is GetAllTripsFailure) {
          return Center(child: Text("Error: ${state.errorMessage}"));
        } else {
          return const SizedBox();
        }
      },
    );
  }
}

class AvailableRoutesBottomSheet extends StatefulWidget {
  const AvailableRoutesBottomSheet({
    super.key,
  });

  @override
  State<AvailableRoutesBottomSheet> createState() =>
      _AvailableRoutesBottomSheetState();
}

class _AvailableRoutesBottomSheetState
    extends State<AvailableRoutesBottomSheet> {
  bool isWomanOnly = false;
  bool isDriverWomanOnly = false;
  bool isComfort = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 800.h,
      padding: EdgeInsets.symmetric(horizontal: 50.w),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.w),
        // color: AppColors.PRIMARY_COLOR.withOpacity(0.4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Sizer(height: 50),
          Text('Instantiating Route', style: Styles.headerText()),
          const Sizer(),
          Text('Price Per Seat', style: Styles.mediumText()),
          Text(
            'EGP 77',
            style: Styles.headerText(fontWeight: FontWeight.bold),
          ),
          Text(
            'Premuim',
            style: Styles.mediumText(
              fontWeight: FontWeight.bold,
              color: AppColors.SECONDARY_COLOR,
            ),
          ),
          const Sizer(),
          SizedBox(
            width: 500.w,
            // color: Colors.red,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Comfort', style: Styles.mediumText()),
                Transform.scale(
                  scale: 0.8,
                  child: Switch(
                    value: isComfort,
                    onChanged: (value) {
                      isComfort = !isComfort;
                      pr(isComfort);
                      setState(() {});
                    },
                    activeColor: AppColors.PRIMARY_COLOR,
                    trackColor:
                        const WidgetStatePropertyAll(AppColors.SECONDARY_COLOR),
                    inactiveThumbColor: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 500.w,
            // color: Colors.red,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Woman Only ', style: Styles.mediumText()),
                Transform.scale(
                  scale: 0.8,
                  child: Switch(
                    value: isWomanOnly,
                    onChanged: (value) {
                      isWomanOnly = !isWomanOnly;
                      pr(isWomanOnly);
                      setState(() {});
                    },
                    activeColor: AppColors.PRIMARY_COLOR,
                    trackColor:
                        const WidgetStatePropertyAll(AppColors.SECONDARY_COLOR),
                    inactiveThumbColor: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 500.w,
            // color: Colors.red,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Woman Driver Only ', style: Styles.mediumText()),
                    Transform.scale(
                      scale: 0.8,
                      child: Switch(
                        value: isDriverWomanOnly,
                        onChanged: (value) {
                          isDriverWomanOnly = !isDriverWomanOnly;
                          pr(isDriverWomanOnly);
                          setState(() {});
                        },
                        activeColor: AppColors.PRIMARY_COLOR,
                        trackColor: const WidgetStatePropertyAll(
                            AppColors.SECONDARY_COLOR),
                        inactiveThumbColor: Colors.grey,
                      ),
                    ),
                  ],
                ),
                isDriverWomanOnly
                    ? Text(
                        "You will find fewer drivers if you select this option",
                        style:
                            Styles.mediumText(color: AppColors.SECONDARY_COLOR),
                      )
                    : SizedBox(height: 70.h),
              ],
            ),
          ),
          isDriverWomanOnly ? SizedBox(height: 10.h) : const SizedBox(),
          SizedBox(
            width: 500.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Payment Option', style: Styles.headerText()),
                const Sizer(),
                Image.asset(Assets.visa, height: 50.h),
              ],
            ),
          ),
          const Sizer(height: 30),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: AvaialbleTripsButton(
                  title: LocaleKeys.premuimRequest.localize,
                  // color: testColor,
                  color: AppColors.getSecondryColor(context),
                  onTap: () {},
                ),
              ),
              const Sizer(width: 5),
              Expanded(
                flex: 1,
                child: AvaialbleTripsButton(
                  title: LocaleKeys.regularRequest.localize,
                  color: AppColors.PRIMARY_COLOR,
                  onTap: () {},
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

// List<AvailableRoutesCardEntity> cards = List.generate(
//   10,
//   (index) {
//     return AvailableRoutesCardEntity(
//       price: 100,
//       timeLeft: 20,
//       onlyWomanAllowed: index.isEven,
//       pointOne: PointLocationEntity(
//         isMale: index.isOdd,
//         booked: true,
//         number: 1,
//         addressEn: 'Mansoura, Samya Gamal street near Egyption hospital',
//         addressAr: '',
//       ),
//       pointTwo: PointLocationEntity(
//         isMale: index.isOdd,
//         booked: index.isEven,
//         number: 1,
//         addressEn: 'Mansoura, Samya Gamal street near Egyption hospital',
//         addressAr: '',
//       ),
//       pointThree: PointLocationEntity(
//         isMale: index.isOdd,
//         booked: index.isOdd,
//         number: 1,
//         addressEn: 'Mansoura, Samya Gamal street near Egyption hospital',
//         addressAr: '',
//       ),
//       pointFour: PointLocationEntity(
//         isMale: index.isEven,
//         booked: index.isEven,
//         number: 1,
//         addressEn: 'Mansoura, Samya Gamal street near Egyption hospital',
//         addressAr: '',
//       ),
//     );
//   },
// );
