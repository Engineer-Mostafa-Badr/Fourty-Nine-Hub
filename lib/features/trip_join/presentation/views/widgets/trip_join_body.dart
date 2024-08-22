import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/features/trip_join/presentation/cubits/destination_location/destination_location_cubit.dart';
import 'package:fourtyninehub/features/trip_join/presentation/cubits/starting_location/starting_location_cubit.dart';
import 'package:fourtyninehub/features/trip_join/presentation/views/widgets/destination_text_field_and_find_button.dart';
import 'package:fourtyninehub/features/trip_join/presentation/views/widgets/start_text_field_and_find_button.dart';
import 'package:fourtyninehub/features/trip_join/presentation/views/widgets/trip_and_car_information.dart';
import 'package:fourtyninehub/features/trip_join/presentation/views/widgets/trip_join_google_map.dart';
import 'package:fourtyninehub/features/trip_join/presentation/views/widgets/welcome_text.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class TripJoinBody extends StatefulWidget {
  const TripJoinBody({
    super.key,
  });

  @override
  State<TripJoinBody> createState() => _TripJoinBodyState();
}

class _TripJoinBodyState extends State<TripJoinBody> {
  late final StartingLocationCubit startingCubit;
  late final DestinationLocationCubit destinationCubit;
  @override
  void initState() {
    startingCubit = context.read<StartingLocationCubit>();
    destinationCubit = context.read<DestinationLocationCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...welcomeText(),
              const Sizer(),
              const Divider(),
              const Sizer(),
              const TripJoinGoogleMap(),
              const Sizer(height: 20),
              Text('Starting Point', style: Styles.headerText(color: AppColors.SECONDARY_COLOR)),
              const StartTextFieldAndFindButon(),
              const Sizer(height: 20),
              Text('Destination Point', style: Styles.headerText(color: AppColors.SECONDARY_COLOR)),
              const DestinationTextFieldAndFindButon(),
              const Sizer(),
              const Divider(),
              const Sizer(),
              Builder(builder: (context) {
                context.watch<StartingLocationCubit>();
                context.watch<DestinationLocationCubit>();
                return Visibility(
                  visible: startingCubit.startingLocation != null && destinationCubit.destinationLocation != null,
                  // visible: true,
                  child: const TripAndCarInformation(),
                );
              })
            ],
          ),
        ),
      ),
    );
  }
}
