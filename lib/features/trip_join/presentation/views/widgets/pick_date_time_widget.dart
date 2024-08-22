import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/features/trip_join/presentation/cubits/trip_join_view/trip_join_view_cubit.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class PickDateAndTimeWidget extends StatefulWidget {
  const PickDateAndTimeWidget({
    super.key,
  });

  @override
  State<PickDateAndTimeWidget> createState() => _PickDateAndTimeWidgetState();
}

class _PickDateAndTimeWidgetState extends State<PickDateAndTimeWidget> {
  DateTime? date;
  TimeOfDay? time;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BlocBuilder<TripJoinViewCubit, TripJoinViewState>(
          buildWhen: (previous, current) =>
              current is TripJoinViewShowDateState,
          builder: (context, state) {
            return Visibility(
              visible: !context.read<TripJoinViewCubit>().showDate,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Journey Date',
                    style: Styles.headerText(color: AppColors.SECONDARY_COLOR),
                  ),
                  InkWell(
                    onTap: () async {
                      date = await showDatePicker(
                        context: context,
                        firstDate: DateTime.now().subtract(
                          const Duration(days: 1),
                        ),
                        lastDate: DateTime.now().add(
                          const Duration(days: 30),
                        ),
                      );
                      setState(() {});
                    },
                    child: Container(
                      width: double.infinity,
                      height: 45,
                      padding: const EdgeInsets.symmetric(horizontal: 7),
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        _getDate(),
                        style: Styles.headerText(fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                  const Sizer(),
                ],
              ),
            );
          },
        ),
        Text(
          'Journey Time',
          style: Styles.headerText(color: AppColors.SECONDARY_COLOR),
        ),
        InkWell(
          onTap: () async {
            time = await showTimePicker(
              context: context,
              initialTime: const TimeOfDay(hour: 0, minute: 0),
            );
            setState(() {});
          },
          child: Container(
            width: double.infinity,
            height: 45,
            padding: const EdgeInsets.symmetric(horizontal: 7),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              _getTime(),
              style: Styles.headerText(fontWeight: FontWeight.w400),
            ),
          ),
        ),
        const Sizer(),
      ],
    );
  }

  String _getDate() {
    String result = '';
    if (date == null) {
      result = 'Example ';
      result += DateTime.now().toString().split(' ').first;
      return result;
    }
    return date!.toString().split(' ').first;
  }

  String _getTime() {
    String result = '';
    if (time == null) {
      result = 'Example ';
      result += TimeOfDay.now().format(context);
      return result;
    }
    return time!.format(context);
  }
}
