import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/features/trip_join/presentation/cubits/destination_location/destination_location_cubit.dart';
import 'package:fourtyninehub/features/trip_join/presentation/cubits/fetch_price_distance/fetch_price_distance_cubit.dart';
import 'package:fourtyninehub/features/trip_join/presentation/cubits/starting_location/starting_location_cubit.dart';
import 'package:fourtyninehub/features/trip_join/presentation/cubits/trip_join_view/trip_join_view_cubit.dart';
import 'package:fourtyninehub/features/trip_join/presentation/views/widgets/destination_text_field_and_find_button.dart';
import 'package:fourtyninehub/features/trip_join/presentation/views/widgets/start_text_field_and_find_button.dart';
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
              // const Sizer(),
              const Sizer(),
              const TripJoinGoogleMap(),
              const Sizer(height: 20),
              // Text('Starting Point', style: Styles.headerText(color: AppColors.SECONDARY_COLOR)),
              const StartTextFieldAndFindButon(),
              const Sizer(height: 20),
              // Text('Destination Point', style: Styles.headerText(color: AppColors.SECONDARY_COLOR)),
              const DestinationTextFieldAndFindButon(),
              const Sizer(height: 20),
              Builder(builder: (context) {
                context.watch<StartingLocationCubit>();
                context.watch<DestinationLocationCubit>();
                return const Visibility(
                  // visible: startingCubit.startingLocation != null && destinationCubit.destinationLocation != null,
                  visible: true,
                  child: Column(
                    children: [
                      TripAndCarInformationV2(),
                      // TripAndCarInformation(),
                    ],
                  ),
                );
              })
            ],
          ),
        ),
      ),
    );
  }
}

class TripAndCarInformationV2 extends StatelessWidget {
  const TripAndCarInformationV2({super.key});

  @override
  Widget build(BuildContext context) {
    double size = 30;
    return Column(
      children: [
        DistanceAndPricePerPersonV2(size: size),
        DateAndTimePickerV2(size: size),
        SelectSeatAndRepeatV2(size: size),
        TotalPriceV2(size: size),
      ],
    );
  }
}

class TotalPriceV2 extends StatelessWidget {
  const TotalPriceV2({
    super.key,
    required this.size,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Icon(Icons.money, size: size),
        ),
        Expanded(
          flex: 2,
          child: Text('Total Price', style: Styles.headerText()),
        ),
        Expanded(
          flex: 3,
          child: Container(
            padding: const EdgeInsets.only(left: 15),
            child: Text('18.0', style: Styles.headerText()),
          ),
        ),
      ],
    );
  }
}

class SelectSeatAndRepeatV2 extends StatefulWidget {
  const SelectSeatAndRepeatV2({
    super.key,
    required this.size,
  });

  final double size;

  @override
  State<SelectSeatAndRepeatV2> createState() => _SelectSeatAndRepeatV2State();
}

class _SelectSeatAndRepeatV2State extends State<SelectSeatAndRepeatV2> {
  bool repeated = false;
  int seatsNumber = 1;
  @override
  Widget build(BuildContext context) {
    return CustomRow(
      children: [
        DropdownButton(
          items: [1, 2, 3, 4, 5, 6]
              .map((e) => DropdownMenuItem(
                  value: e,
                  child: Text(
                    e.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  )))
              .toList(),
          onChanged: (int? value) {
            seatsNumber = value ?? 1;
            setState(() {});
          },
          icon: Icon(Icons.keyboard_arrow_down, size: widget.size),
        ),
        Text('$seatsNumber ${seatsNumber == 1 ? "Seat" : "Seats"}', style: Styles.headerText()),
        Checkbox(
          value: repeated,
          onChanged: (value) {
            repeated = value ?? false;
            context.read<TripJoinViewCubit>().controlDateVisibilty(value!);
            setState(() {});
          },
          checkColor: Colors.white,
          activeColor: AppColors.PRIMARY_COLOR,
        ),
        Text('Repeate', style: Styles.headerText()),
      ],
    );
  }
}

class DropDownMenuItem {}

class DateAndTimePickerV2 extends StatelessWidget {
  const DateAndTimePickerV2({
    super.key,
    required this.size,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    return CustomRow(
      children: [
        Icon(Icons.calendar_month, size: size),
        Text('2027/10/10', style: Styles.headerText()),
        Icon(Icons.access_time, size: size),
        Text('10:30 PM', style: Styles.headerText()),
      ],
    );
  }
}

class DistanceAndPricePerPersonV2 extends StatelessWidget {
  const DistanceAndPricePerPersonV2({
    super.key,
    required this.size,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FetchPriceDistanceCubit, FetchPriceDistanceState>(
      builder: (context, state) {
        if (state is FetchPriceDistanceSuccess) {
          return CustomRow(
            children: [
              Icon(Icons.directions_car, size: size),
              Text('${(state.tripInfoEntity.distance! / 1000).toStringAsFixed(1)} KM', style: Styles.headerText()),
              Icon(Icons.person, size: size),
              Text((state.tripInfoEntity.price)!.toStringAsFixed(1), style: Styles.headerText()),
            ],
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}

class CustomRow extends StatelessWidget {
  const CustomRow({super.key, required this.children});
  final List<Widget> children;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: children[0],
        ),
        Expanded(
          flex: 2,
          child: children[1],
        ),
        Expanded(
          flex: 1,
          child: children[2],
        ),
        Expanded(
          flex: 2,
          child: children[3],
        ),
      ],
    );
  }
}
