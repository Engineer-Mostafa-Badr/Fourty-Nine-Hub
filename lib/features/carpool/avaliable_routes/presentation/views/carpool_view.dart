import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/carpool/avaliable_routes/presentation/cubits/cubit/get_all_trips_cubit.dart';
import 'package:fourtyninehub/features/carpool/avaliable_routes/presentation/cubits/get_available_trips_for_drivers/cubit/get_available_trips_for_drivers_cubit.dart';
import 'package:fourtyninehub/features/carpool/avaliable_routes/presentation/widgets/car_pool_body.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';

class CarPoolView extends StatelessWidget {
  const CarPoolView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Transform(
            transform: Matrix4.translationValues(-20.0, 0.0, 0.0),
            child: Text(
              LocaleKeys.carpool.localize,
              style: Styles.headerText(),
            ),
          ),
        ),
        body: BlocProvider(
          create: (context) => GetAllTripsCubit(),
          child: BlocProvider(
            create: (context) =>
                GetAvailableTripsForDriversCubit(),
            child: const CarPoolBody(),
          ),
        ),
      ),
    );
  }
}
