import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/functions/helper/time_of_day_helper.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/enums/week_days.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/work_day_entity.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class TimeTable extends StatelessWidget {
  final String title;
  final Widget child;
  final void Function(List<DoctorDayEntity>)? onChanged;
  const TimeTable(
      {super.key, required this.title, required this.child, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(width: .5),
        borderRadius: BorderRadius.circular(UIConst.radius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Styles.headerText(color: AppColors.BARRIER_COLOR)),
          const Sizer(),
          _WeekWidget(
            onChanged: onChanged,
          ),
          const Sizer(),
          child,
        ],
      ),
    );
  }
}

class _WeekWidget extends StatefulWidget {
  final void Function(List<DoctorDayEntity>)? onChanged;

  const _WeekWidget({
    required this.onChanged,
  });

  @override
  State<_WeekWidget> createState() => _WeekWidgetState();
}

class _WeekWidgetState extends State<_WeekWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: _week.map<Widget>((e) {
        return _buildDayWidget(e);
      }).toList(),
    );
  }

  Widget _buildDayWidget(DoctorDayEntity time) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        children: [
          Checkbox(
              value: time.isAvailable,
              onChanged: (v) {
                setState(() {
                  time.isAvailable = v!;
                });
                widget.onChanged?.call(_week);
              }),
          Text(
            time.day.name,
            style: Styles.mediumText(color: AppColors.PRIMARY_COLOR_DARK),
          ),
          const Spacer(flex: 1),
          InkWell(
            onTap: () {
              showTimePicker(
                context: context,
                initialTime: const TimeOfDay(hour: 10, minute: 0),
              ).then((value) {
                if (value != null) {
                  if (value.isBefore(time.to)) {
                    setState(() {
                      time.from = value;
                    });
                  } else {
                    showErrorMessage(
                        context, "Start Time Cannot be after the End Time");
                  }
                }
              });
            },
            child: RichText(
              text: TextSpan(
                text: "from   ",
                style: Styles.mediumText(),
                children: [
                  TextSpan(
                    text: time.from.display,
                    style: Styles.mediumText(color: AppColors.DARK_GRAY_COLOR),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(flex: 2),
          InkWell(
            onTap: () {
              showTimePicker(
                context: context,
                initialTime: const TimeOfDay(hour: 10, minute: 0),
              ).then((value) {
                if (value != null) {
                  if (value.isAfter(time.from)) {
                    setState(() {
                      time.to = value;
                    });
                  } else {
                    showErrorMessage(
                        context, "End Time Cannot be before the Start Time");
                  }
                }
              });
            },
            child: RichText(
              text: TextSpan(
                text: "to   ",
                style: Styles.mediumText(),
                children: [
                  TextSpan(
                    text: time.to.display,
                    style: Styles.mediumText(color: AppColors.DARK_GRAY_COLOR),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  final List<DoctorDayEntity> _week = [
    DoctorDayEntity(day: WeekDays.saturday),
    DoctorDayEntity(day: WeekDays.sunday),
    DoctorDayEntity(day: WeekDays.monday),
    DoctorDayEntity(day: WeekDays.tuesday),
    DoctorDayEntity(day: WeekDays.wednesday),
    DoctorDayEntity(day: WeekDays.thursday),
    DoctorDayEntity(day: WeekDays.friday),
  ];
}
