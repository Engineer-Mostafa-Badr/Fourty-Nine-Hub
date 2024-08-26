import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/features/trip_join/presentation/cubits/trip_join_view/trip_join_view_cubit.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class SeatsNumberWidget extends StatefulWidget {
  const SeatsNumberWidget({
    super.key,
  });

  @override
  State<SeatsNumberWidget> createState() => _SeatsNumberWidgetState();
}

class _SeatsNumberWidgetState extends State<SeatsNumberWidget> {
  int seatsNumber = 1;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: AppColors.PRIMARY_COLOR.withOpacity(0.8),
            borderRadius: BorderRadius.circular(10),
          ),
          child: DropdownButton<int>(
              value: seatsNumber,
              alignment: Alignment.center,
              dropdownColor: AppColors.PRIMARY_COLOR.withOpacity(0.8),
              focusColor: Colors.white,
              iconEnabledColor: Colors.white,
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              style: const TextStyle(color: Colors.white),
              underline: Container(
                height: 2,
                color: Colors.white,
              ),
              onChanged: (int? value) {
                seatsNumber = value ?? 1;
                context
                    .read<TripJoinViewCubit>()
                    .changeNumberOfSeats(value ?? 1);
                setState(() {});
              },
              items: [1, 2, 3, 4, 5, 6]
                  .map((value) => DropdownMenuItem<int>(
                        value: value,
                        child: Text(value.toString()),
                      ))
                  .toList()),
        ),
        const Sizer(),
        Text('Number of seats available',
            style: Styles.headerText(color: AppColors.SECONDARY_COLOR))
      ],
    );
  }
}
