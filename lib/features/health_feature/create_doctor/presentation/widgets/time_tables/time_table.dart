import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/functions/helper/time_of_day_helper.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/doctor_day_entity.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Timetable extends StatelessWidget {
  final String title;
  final Widget child;
  final List<DoctorDayEntity> timetale;
  const Timetable(
      {super.key,
      required this.title,
      required this.child,
      required this.timetale});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(width: .5),
        borderRadius: BorderRadius.circular(UIConst.radius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Styles.headerText(color: AppColors.BARRIER_COLOR)),
          Sizer(),
          _WeekWidget(
            timetale: timetale,
          ),
          Sizer(),
          child,
        ],
      ),
    );
  }
}

class _WeekWidget extends StatefulWidget {
  final List<DoctorDayEntity> timetale;

  const _WeekWidget({
    required this.timetale,
  });

  @override
  State<_WeekWidget> createState() => _WeekWidgetState();
}

class _WeekWidgetState extends State<_WeekWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.timetale.map<Widget>((e) {
        return _buildDayWidget(e);
      }).toList(),
    );
  }

  Widget _buildDayWidget(DoctorDayEntity time) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5.h),
      child: Row(
        children: [
          Checkbox(
              value: time.isAvailable,
              onChanged: (v) {
                setState(() {
                  time.isAvailable = v!;
                });
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
                initialTime: const TimeOfDay(hour: 11, minute: 0),
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
}
