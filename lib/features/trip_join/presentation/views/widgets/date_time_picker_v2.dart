import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/trip_join/presentation/cubits/trip_join_view/trip_join_view_cubit.dart';
import 'package:fourtyninehub/features/trip_join/presentation/views/widgets/custom_row_v2.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class DateAndTimePickerV2 extends StatefulWidget {
  const DateAndTimePickerV2({
    super.key,
    required this.size,
  });

  final double size;

  @override
  State<DateAndTimePickerV2> createState() => _DateAndTimePickerV2State();
}

class _DateAndTimePickerV2State extends State<DateAndTimePickerV2> {
  DateTime? date;
  TimeOfDay? time;
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
        IconButton(
          onPressed: () async {
            date = await showDatePicker(
              context: context,
              firstDate: DateTime.now().subtract(
                const Duration(days: 1),
              ),
              lastDate: DateTime.now().add(
                const Duration(days: 30),
              ),
            );
            tripJoinViewCubit.tripJoinDate = date ?? DateTime.now();
            setState(() {});
          },
          icon: Icon(Icons.calendar_month, size: widget.size),
        ),
        Text(_getDate(), style: Styles.headerText()),
        IconButton(
          onPressed: () async {
            time = await showTimePicker(
              context: context,
              initialTime: const TimeOfDay(hour: 0, minute: 0),
            );
            tripJoinViewCubit.tripJoinTimeOfDay = time ?? TimeOfDay.now();
            setState(() {});
          },
          icon: Icon(Icons.access_time, size: widget.size),
        ),
        Text(_getTime(), style: Styles.headerText()),
      ],
    );
  }

  String _getDate() {
    String result = '';
    if (date == null) {
      // result = 'Example ';
      result = DateTime.now().toString().split(' ').first;
      return result;
    }
    return date!.toString().split(' ').first;
  }

  String _getTime() {
    String result = '';
    if (time == null) {
      // result = 'Example ';
      result = TimeOfDay.now().format(context);
      return result;
    }
    return time!.format(context);
  }
}
