import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/presentation/cubits/trip_join_view/trip_join_view_cubit.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/presentation/views/widgets/custom_row_v2.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

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
  late final TripJoinViewCubit tripJoinViewCubit;
  @override
  void initState() {
    tripJoinViewCubit = context.read<TripJoinViewCubit>();
    super.initState();
  }

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
            tripJoinViewCubit.changeNumberOfSeats(value ?? 1);
            setState(() {});
          },
          icon: Icon(Icons.keyboard_arrow_down, size: widget.size),
        ),
        Text('$seatsNumber ${seatsNumber == 1 ? "Seat" : "Seats"}',
            style: Styles.headerText()),
        Checkbox(
          value: repeated,
          onChanged: (value) {
            repeated = value ?? false;
            tripJoinViewCubit.controlDateVisibilty(value ?? false);
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
