import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/carpool/add_new_route/presentation/cubits/get_price_carpool/get_price_carpool_cubit.dart';
import 'package:fourtyninehub/features/carpool/add_new_route/presentation/cubits/mapBox_cubit/cubit/map_box_cubit_cubit.dart';
import 'package:fourtyninehub/features/carpool/avaliable_routes/presentation/cubits/get_currency/cubit/get_currency_cubit.dart';
import 'package:fourtyninehub/features/carpool/create_carpool/domain/entities/create_carpool.dart';
import 'package:fourtyninehub/features/carpool/create_carpool/presentation/cubits/cubit/create_car_pool_cubit.dart';
import 'package:fourtyninehub/features/trip_join/helpers/print_helper.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/widgets/available_trip_button.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';

class CarPoolNewRouteInfo extends StatefulWidget {
  const CarPoolNewRouteInfo({super.key});
  static double normalPrice = 0;

  @override
  State<CarPoolNewRouteInfo> createState() => _CarPoolNewRouteInfoState();
}

class _CarPoolNewRouteInfoState extends State<CarPoolNewRouteInfo> {
  bool isWomanOnly = false;
  bool isDriverWomanOnly = false;
  bool isComfort = false;
  final userGender = serviceLocator<UserCubit>().isLoggedIn
      ? serviceLocator<UserCubit>().state.data?.gender
      : '';
  late final GetPriceCarpoolCubit getPriceCarpoolCubit;
  late final CreateCarPoolCubit createCarPoolCubit;
  late final GetCurrencyCubit getCurrencyCubit;
  @override
  void initState() {
    createCarPoolCubit = context.read<CreateCarPoolCubit>();
    getPriceCarpoolCubit = context.read<GetPriceCarpoolCubit>();
    super.initState();
    Future.microtask(() {
      getCurrencyCubit = context.read<GetCurrencyCubit>()..getCurrencyData();

      setState(() {}); // Trigger a rebuild once cubits are initialized
    });
  }

  @override
  void dispose() {
    if (!createCarPoolCubit.isClosed) {
      createCarPoolCubit.close();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(LocaleKeys.createRoute.localize, style: Styles.headerText()),
      const Sizer(),
      Text(LocaleKeys.pricePerSeat.localize, style: Styles.mediumText()),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          BlocBuilder<MapBoxCubit, MapBoxCubitState>(
            builder: (context, state) {
              return BlocBuilder<GetPriceCarpoolCubit, GetPriceCarpoolState>(
                builder: (context, state) {
                  if (state is GetPriceCarpoolSuccess) {
                    return Text(
                      _getPrice(),
                      style: Styles.headerText(
                          fontWeight: FontWeight.bold, fontSize: 50),
                    );
                  } else {
                    return Text(
                      _getPrice(),
                      style: Styles.headerText(
                          fontWeight: FontWeight.bold, fontSize: 50),
                    );
                  }
                },
              );
            },
          ),
          BlocBuilder<GetCurrencyCubit, GetCurrencyState>(
            builder: (context, state) {
              return Text(
                context.isArabic
                    ? BlocProvider.of<GetCurrencyCubit>(context).currnecyAr
                    : BlocProvider.of<GetCurrencyCubit>(context).currnecyEn,
                style: Styles.mediumText(
                    fontWeight: FontWeight.bold,
                    color: AppColors.SECONDARY_COLOR),
              );
            },
          ),
        ],
      ),
      const Sizer(),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(LocaleKeys.comfort.localize, style: Styles.headerText()),
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
              trackOutlineColor: const WidgetStatePropertyAll(Colors.grey),
              activeTrackColor: Colors.grey,
              inactiveTrackColor: Colors.white,
              inactiveThumbColor: Colors.grey,
            ),
          ),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(LocaleKeys.womenOnly.localize, style: Styles.headerText()),
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
              trackOutlineColor: const WidgetStatePropertyAll(Colors.grey),
              activeTrackColor: Colors.grey,
              inactiveTrackColor: Colors.white,
              inactiveThumbColor: Colors.grey,
            ),
          ),
        ],
      ),
      Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(LocaleKeys.womenDriverOnly.localize,
                  style: Styles.headerText()),
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
                  trackOutlineColor: const WidgetStatePropertyAll(Colors.grey),
                  activeTrackColor: Colors.grey,
                  inactiveTrackColor: Colors.white,
                  inactiveThumbColor: Colors.grey,
                ),
              ),
            ],
          ),
          isDriverWomanOnly
              ? Text(
                  LocaleKeys.youWillFindFewerOption.localize,
                  style: Styles.mediumText(color: AppColors.SECONDARY_COLOR),
                )
              : const SizedBox(),
          isDriverWomanOnly ? SizedBox(height: 10.h) : const SizedBox(),
          const Sizer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(LocaleKeys.paymentOption.localize,
                  style: Styles.headerText()),
              const Spacer(),
              Image.asset(Assets.visa, height: 50.h),
              const SizedBox(width: 15),
            ],
          ),
        ],
      ),
      const Sizer(height: 30),
      BlocBuilder<CreateCarPoolCubit, CreateCarPoolState>(
        builder: (context, state) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: AvaialbleTripsButton(
                  title: LocaleKeys.regularRequest.localize,
                  color: AppColors.PRIMARY_COLOR,
                  onTap: () async {
                    await createCarPool();
                  },
                ),
              )
            ],
          );
        },
      ),
    ]);
  }

  String _getPrice() {
    num price =
        getPriceCarpoolCubit.carpoolRouteInfoModel?.priceForEveryUser ?? 0;

    if (isComfort) {
      price +=
          getPriceCarpoolCubit.carpoolRouteInfoModel?.driverPriceComfort ?? 0;
      // price += 40;
    }
    if (isWomanOnly) {
      price +=
          getPriceCarpoolCubit.carpoolRouteInfoModel?.priceForWomenOnly ?? 0;
      // price += 14;
    }
    if (isDriverWomanOnly) {
      price +=
          getPriceCarpoolCubit.carpoolRouteInfoModel?.priceDriverWomen ?? 0;
      // price += 25;
    }
    return price.toString();
  }

  num _getPriceNum() {
    // num price = 300;
    num price =
        getPriceCarpoolCubit.carpoolRouteInfoModel?.priceForEveryUser ?? 0;

    if (isComfort) {
      price +=
          getPriceCarpoolCubit.carpoolRouteInfoModel?.driverPriceComfort ?? 0;
      // price += 40;
    }
    if (isWomanOnly) {
      price +=
          getPriceCarpoolCubit.carpoolRouteInfoModel?.priceForWomenOnly ?? 0;
      // price += 14;
    }
    if (isDriverWomanOnly) {
      price +=
          getPriceCarpoolCubit.carpoolRouteInfoModel?.priceDriverWomen ?? 0;
      // price += 25;
    }
    return price;
  }

  Future<void> createCarPool() async {
    final num finalPrice = _getPriceNum();
    if (finalPrice != 0) {
      await createCarPoolCubit.createCarPool(
        createCarpoolParam: CreateCarpoolParam(
          comfort: isComfort,
          destinationAddress:
              getPriceCarpoolCubit.carpoolRouteInfoModel?.destinationAddress,
          distance:
              getPriceCarpoolCubit.carpoolRouteInfoModel?.distance?.toInt(),
          duration:
              getPriceCarpoolCubit.carpoolRouteInfoModel?.duration?.toInt(),
          firstMidpoint: [
            getPriceCarpoolCubit.carpoolRouteInfoModel?.firstMidpoint?["lat"] ??
                0,
            getPriceCarpoolCubit.carpoolRouteInfoModel?.firstMidpoint?["lng"] ??
                0
          ],
          locationForFirstMidpoint: getPriceCarpoolCubit
              .carpoolRouteInfoModel?.locationForFirstMidpoint,
          locationForSecondMidpoint: getPriceCarpoolCubit
              .carpoolRouteInfoModel?.locationForSecondMidpoint,
          originAddress:
              getPriceCarpoolCubit.carpoolRouteInfoModel?.originAddress,
          priceForEveryUser: finalPrice.toInt(),
          secondMidpoint: [
            getPriceCarpoolCubit
                    .carpoolRouteInfoModel?.secondMidpoint?["lat"] ??
                0,
            getPriceCarpoolCubit
                    .carpoolRouteInfoModel?.secondMidpoint?["lng"] ??
                0
          ],
          startLocation:
              getPriceCarpoolCubit.carpoolRouteInfoModel?.startLocation,
          targetLocation:
              getPriceCarpoolCubit.carpoolRouteInfoModel?.targetLocation,
          womenDriverOnly: isDriverWomanOnly,
          womenOnly: isWomanOnly,
        ),
      );
    } else {
      showErrorMessage(context, LocaleKeys.pleaseFillAllFields.localize);
    }
  }
}
