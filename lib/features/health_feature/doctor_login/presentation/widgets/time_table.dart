import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/functions/helper/time_of_day_helper.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/health_feature/doctor_login/domain/entities/doctor_time_entity.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class TimeTable extends StatefulWidget {
  final List<DoctorDayAvailabilityEntity> times;
  const TimeTable({super.key, required this.times});

  @override
  State<TimeTable> createState() => _TimeTableState();
}

class _TimeTableState extends State<TimeTable> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.times.map<Widget>((e) {
        return Column(
          children: [
            _item(e),
            const Sizer(),
          ],
        );
      }).toList(),
    );
  }

  Widget _item(DoctorDayAvailabilityEntity time) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      decoration: BoxDecoration(
        border: Border.all(width: .5),
        borderRadius: BorderRadius.circular(UIConst.radius),
      ),
      child: Row(
        children: [
          Checkbox.adaptive(
            value: time.isAvailable,
            onChanged: (value) {
              setState(() {
                time.isAvailable = value!;
              });
            },
          ),
          Text(
            time.day,
            style: Styles.mediumText(),
          ),
          const Spacer(flex: 1),
          InkWell(
            onTap: () {
              showTimePicker(
                context: context,
                initialTime: const TimeOfDay(hour: 10, minute: 0),
              ).then((value) {
                setState(() {
                  if (value!.isBefore(time.to)) {
                    time.from = value;
                  } else {
                    showErrorMessage(
                        context, "Start Time Cannot be after than End Time");
                  }
                });
              });
            },
            child: Text(
              "from   ${time.from.display}",
              style: Styles.mediumText(),
            ),
          ),
          const Spacer(flex: 2),
          InkWell(
            onTap: () {
              showTimePicker(
                context: context,
                initialTime: const TimeOfDay(hour: 10, minute: 0),
              ).then((value) {
                if (value!.isAfter(time.from)) {
                  setState(() {
                    time.to = value;
                  });
                } else {
                  showErrorMessage(
                      context, "End Time Cannot be before than Start Time");
                }
              });
            },
            child: Text(
              "to   ${time.to.display}",
              style: Styles.mediumText(),
            ),
          ),
        ],
      ),
    );
  }
}
