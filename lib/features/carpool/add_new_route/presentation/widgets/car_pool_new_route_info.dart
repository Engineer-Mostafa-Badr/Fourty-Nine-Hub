import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/carpool/add_new_route/domain/entities/get_price_carpool_param.dart';
import 'package:fourtyninehub/features/carpool/add_new_route/presentation/cubits/get_price_carpool/get_price_carpool_cubit.dart';
import 'package:fourtyninehub/features/trip_join/helpers/print_helper.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/widgets/available_trip_button.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class CarPoolNewRouteInfo extends StatefulWidget {
  const CarPoolNewRouteInfo({super.key});

  @override
  State<CarPoolNewRouteInfo> createState() => _CarPoolNewRouteInfoState();
}

class _CarPoolNewRouteInfoState extends State<CarPoolNewRouteInfo> {
  bool isWomanOnly = false;
  bool isDriverWomanOnly = false;
  bool isComfort = false;
  late final GetPriceCarpoolCubit getPriceCarpoolCubit;
  @override
  void initState() {
    getPriceCarpoolCubit = context.read<GetPriceCarpoolCubit>()
      ..getPriceCarpool(
        getPriceCarpoolParam: GetPriceCarpoolParam(
          womenOnly: false,
          womenDriverOnly: false,
          comfort: false,
          startLocation: [39.862808, -4.0273727],
          targetLocation: [40.4165207, -3.705076],
        ),
      );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text('Create Route', style: Styles.headerText()),
      const Sizer(),
      Text('Price Per Seat', style: Styles.mediumText()),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          BlocBuilder<GetPriceCarpoolCubit, GetPriceCarpoolState>(
            builder: (context, state) {
              return Text(
                _getPrice(),
                style: Styles.headerText(
                    fontWeight: FontWeight.bold, fontSize: 50),
              );
            },
          ),
          Text(
            ' EGP',
            style: Styles.mediumText(
                fontWeight: FontWeight.bold, color: AppColors.SECONDARY_COLOR),
          ),
        ],
      ),
      const Sizer(),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Comfort', style: Styles.headerText()),
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
              trackOutlineColor: MaterialStatePropertyAll(Colors.grey),
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
          Text('Woman Only ', style: Styles.headerText()),
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
              trackOutlineColor: MaterialStatePropertyAll(Colors.grey),
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
              Text('Woman Driver Only ', style: Styles.headerText()),
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
                  trackOutlineColor: MaterialStatePropertyAll(Colors.grey),
                  activeTrackColor: Colors.grey,
                  inactiveTrackColor: Colors.white,
                  inactiveThumbColor: Colors.grey,
                ),
              ),
            ],
          ),
          isDriverWomanOnly
              ? Text(
                  "You will find fewer drivers if you select this option",
                  style: Styles.mediumText(color: AppColors.SECONDARY_COLOR),
                )
              : const SizedBox(),
          isDriverWomanOnly ? SizedBox(height: 10.h) : const SizedBox(),
          const Sizer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Payment Option', style: Styles.headerText()),
              const Spacer(),
              Image.asset(Assets.visa, height: 50.h),
              const SizedBox(width: 15),
            ],
          ),
        ],
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
    ]);
  }

  String _getPrice() {
    if (isComfort) {
      return (getPriceCarpoolCubit.carpoolRouteInfoModel?.driverPriceComfort ??
              0)
          .toString();
    } else {
      return (getPriceCarpoolCubit.carpoolRouteInfoModel?.driverPrice ?? 0)
          .toString();
    }
  }
}
