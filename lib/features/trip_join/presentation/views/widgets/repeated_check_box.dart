import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/trip_join/presentation/cubits/trip_join_view/trip_join_view_cubit.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class RepeatedCheckBox extends StatefulWidget {
  const RepeatedCheckBox({
    super.key,
  });
  static Stream<bool>? repeatedStream;
  @override
  State<RepeatedCheckBox> createState() => _RepeatedCheckBoxState();
}

class _RepeatedCheckBoxState extends State<RepeatedCheckBox> {
  bool repeated = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
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
        Text('Repeated', style: Styles.headerText()),
      ],
    );
  }
}
