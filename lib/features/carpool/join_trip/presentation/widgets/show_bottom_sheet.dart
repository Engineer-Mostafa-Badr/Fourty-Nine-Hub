import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/carpool/avaliable_routes/presentation/cubits/get_currency/cubit/get_currency_cubit.dart';
import 'package:fourtyninehub/features/carpool/join_trip/domain/entities/join_trip_entity.dart';
import 'package:fourtyninehub/features/carpool/join_trip/presentation/cubits/cubit/join_trip_car_pool_cubit.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/widgets/available_trip_button.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';

void showCreateRouteModalSheet(BuildContext context,
    {required String seatId,
    required List<double> userLocation,
    required String tripId,
    required bool isComfort,
    required num price}) {
  //  final joinTripCarpoolRepo = JoinTripCarpoolRepoImp(joinTripRemoteDataSource: null);

  // final joinTripCarpoolUsecase = JoinTripCarpoolUsecase(joinTripCarpoolRepo: joinTripCarpoolRepo);

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      // return BlocProvider<JoinTripCarPoolCubit>(
      //   create: (context) => serviceLocator(),
      //   child: CreateRouteBottomSheet(isComfort: isComfort),
      // );
      return MultiBlocProvider(
          providers: [
            BlocProvider<JoinTripCarPoolCubit>(
                create: (context) => serviceLocator()),
            BlocProvider<GetCurrencyCubit>(
                create: (context) => serviceLocator()),
          ],
          child: CreateRouteBottomSheet(
            seatId: seatId,
            tripId: tripId,
            userLocation: userLocation,
            isComfort: isComfort,
            price: price,
          ));
    },
  );
}

class CreateRouteBottomSheet extends StatefulWidget {
  bool isComfort;
  final num price;
  final String seatId;
  final String tripId;
  final List<double> userLocation;
  CreateRouteBottomSheet(
      {super.key,
      required this.isComfort,
      required this.price,
      required this.seatId,
      required this.tripId,
      required this.userLocation});

  @override
  _CreateRouteBottomSheetState createState() => _CreateRouteBottomSheetState();
}

class _CreateRouteBottomSheetState extends State<CreateRouteBottomSheet> {
  bool isWomanOnly = false;
  bool isDriverWomanOnly = false;
  late final JoinTripCarPoolCubit joinTripCarPoolCubit;
  late final GetCurrencyCubit getCurrencyCubit;

  @override
  void initState() {
    getCurrencyCubit = context.read<GetCurrencyCubit>()..getCurrencyData();

    joinTripCarPoolCubit = context.read<JoinTripCarPoolCubit>();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    joinTripCarPoolCubit.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: BlocBuilder<JoinTripCarPoolCubit, JoinTripCarPoolState>(
        builder: (context, state) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(LocaleKeys.bookSeat.localize, style: Styles.headerText()),
              const Sizer(),
              Text(LocaleKeys.pricePerSeat.localize,
                  style: Styles.mediumText()),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // BlocBuilder<GetPriceCarpoolCubit, GetPriceCarpoolState>(
                  //   builder: (context, state) {
                  //     return
                  Text(
                    "${widget.price}",
                    style: Styles.headerText(
                        fontWeight: FontWeight.bold, fontSize: 50),
                  ),
                  //   },
                  // ),
                  BlocBuilder<GetCurrencyCubit, GetCurrencyState>(
                    builder: (context, state) {
                      // if (state is GetCurrencySuccess) {
                      //   return Text(
                      //     " ${state.currency}",
                      //     style: Styles.mediumText(
                      //         fontWeight: FontWeight.bold,
                      //         color: AppColors.SECONDARY_COLOR),
                      //   );
                      // } else {
                      //   return Text(
                      //     "",
                      //     style: Styles.mediumText(
                      //         fontWeight: FontWeight.bold,
                      //         color: AppColors.SECONDARY_COLOR),
                      //   );
                      // }
                      return Text(
                        BlocProvider.of<GetCurrencyCubit>(context).currency,
                        style: Styles.mediumText(
                            fontWeight: FontWeight.bold,
                            color: AppColors.SECONDARY_COLOR),
                      );
                    },
                  ),
                ],
              ),
              const Sizer(),
              !widget.isComfort
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(LocaleKeys.comfort.localize,
                            style: Styles.headerText()),
                        Transform.scale(
                          scale: 0.8,
                          child: Switch(
                            value: widget.isComfort,
                            onChanged: (value) {
                              setState(() {
                                widget.isComfort = value; // Update the state
                              });
                            },
                            activeColor: AppColors.PRIMARY_COLOR,
                            trackOutlineColor:
                                WidgetStatePropertyAll(Colors.grey),
                            activeTrackColor: Colors.grey,
                            inactiveTrackColor: Colors.white,
                            inactiveThumbColor: Colors.grey,
                          ),
                        ),
                      ],
                    )
                  : const SizedBox(),
              const Sizer(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(LocaleKeys.paymentOptions.localize,
                      style: Styles.headerText()),
                  const Spacer(),
                  Image.asset(Assets.visa, height: 50.h),
                  const SizedBox(width: 15),
                ],
              ),
              const Sizer(height: 30),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: AvaialbleTripsButton(
                      title: LocaleKeys.book.localize,
                      color: AppColors.PRIMARY_COLOR,
                      onTap: () {
                        print("object");
                        bookTrip(
                          isComfort: widget.isComfort,
                          seat: widget.seatId,
                          tripId: widget.tripId,
                          userLocation: widget.userLocation,
                        ); // Call the booking function here
                      },
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  void bookTrip(
      {required String seat,
      required String tripId,
      required List<double> userLocation,
      required bool isComfort}) {
    joinTripCarPoolCubit.joinTripCarPool(
      joinTripCarPoolParam: JoinTripCarPoolParam(
        seatName: seat,
        tripId: tripId,
        userLocation: userLocation,
        comfort: isComfort,
      ),
    );
    Navigator.pop(context);
    // Optionally, show a success or loading message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Booking in progress...')),
    );
  }
}
