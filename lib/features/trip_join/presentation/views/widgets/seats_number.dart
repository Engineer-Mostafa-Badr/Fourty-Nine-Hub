import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/features/trip_join/presentation/cubits/destination_location/destination_location_cubit.dart';
import 'package:fourtyninehub/features/trip_join/presentation/cubits/starting_location/starting_location_cubit.dart';
import 'package:fourtyninehub/features/trip_join/presentation/views/widgets/card.dart';
import 'package:fourtyninehub/features/trip_join/presentation/views/widgets/destination_text_field_and_find_button.dart';
import 'package:fourtyninehub/features/trip_join/presentation/views/widgets/start_text_field_and_find_button.dart';
import 'package:fourtyninehub/features/trip_join/presentation/views/widgets/trip_join_google_map.dart';
import 'package:fourtyninehub/features/trip_join/presentation/views/widgets/welcome_text.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class SeatsNumberWidget extends StatelessWidget {
  const SeatsNumberWidget({
    super.key,
  });

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
              value: 2,
              alignment: Alignment.centerRight,
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
              onChanged: (int? value) {},
              items: [1, 2, 3, 4, 5, 6]
                  .map((value) => DropdownMenuItem<int>(
                        value: value,
                        child: Text(value.toString()),
                      ))
                  .toList()),
        ),
        const Sizer(),
        Text('Number of seats available', style: Styles.headerText())
      ],
    );
  }
}
