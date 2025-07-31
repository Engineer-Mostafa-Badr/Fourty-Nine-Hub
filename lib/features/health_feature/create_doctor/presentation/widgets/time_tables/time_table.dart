import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/functions/helper/time_of_day_helper.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/enums/week_days.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/doctor_day_entity.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

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
      // padding: const EdgeInsets.all(10),
      // decoration: BoxDecoration(
      //   border: Border.all(width: .5),
      //   borderRadius: BorderRadius.circular(UIConst.radius),
      // ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Styles.headerText(height: 1.60),
          ),
          const SizedBox(
            height: 8,
          ),
          _WeekWidget(
            timetale: timetale,
          ),
          const Sizer(),
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
      padding: const EdgeInsetsDirectional.only(start: 8, bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                SizedBox(
                  height: 24,
                  width: 24,
                  child: Checkbox(
                      value: time.isAvailable,
                      activeColor: Colors.grey,
                      checkColor: Colors.white,
                      onChanged: (v) {
                        setState(() {
                          time.isAvailable = v!;
                          print(v);
                          print(time.isAvailable);
                        });
                      }),
                ),
                const SizedBox(
                  width: 4,
                ),
                Expanded(
                  child: Text(
                    time.day.toLocalizedString(context),
                    style:
                        Styles.mediumText(color: AppColors.PRIMARY_COLOR_DARK),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              showTimePicker(
                context: context,
                initialTime: const TimeOfDay(hour: 10, minute: 0),
              ).then((value) {
                if (value != null) {
                  int totalMinutes = 645; // Example: 645 minutes

                  // Calculate hours and minutes
                  int hours = totalMinutes ~/ 60; // Integer division
                  int minutes = totalMinutes % 60; // Remainder

                  // Print the time in HH:MM format
                  print(
                      "Time: ${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}");

                  if (value.period == DayPeriod.am) {
                    print("The value is AM.");
                  } else if (value.period == DayPeriod.pm) {
                    print("The time is PM.");
                  }
                  print("value.formattedIn12Hour${value.formattedIn12Hour}");
                  if (value.isBefore(time.to)) {
                    setState(() {
                      time.from = value;
                    });
                  } else {
                    showErrorMessage(
                        context,
                        context.isArabic
                            ? 'بداية الوقت يجب الا تكون بعد الانتهاء'
                            : 'Start Time Cannot be after the End Time');
                  }
                }
              });
            },
            child: RichText(
              text: TextSpan(
                text: '${LocaleKeys.from.localize} ',
                style: Styles.mediumText(
                  color: context.isDarkMode
                      ? Colors.white
                      : AppColors.PRIMARY_COLOR,
                ),
                children: [
                  TextSpan(
                    text: formatTimeOfDayLocalized(time.from, context),
                    style: Styles.mediumText(
                        color: context.isDarkMode
                            ? Colors.white
                            : AppColors.DARK_GRAY_COLOR),
                  ),
                ],
              ),
            ),
            // context.isArabic
            //     ? RichText(
            //         text: TextSpan(
            //           text: 'من   ',
            //           style: Styles.mediumText(
            //             color: context.isDarkMode
            //                 ? Colors.white
            //                 : AppColors.PRIMARY_COLOR,
            //           ),
            //           children: [
            //             TextSpan(
            //               text: formatTimeOfDayLocalized(time.from, context),
            //               style: Styles.mediumText(
            //                   color: context.isDarkMode
            //                       ? Colors.white
            //                       : AppColors.DARK_GRAY_COLOR),
            //             ),
            //           ],
            //         ),
            //       )
            //     : RichText(
            //         text: TextSpan(
            //           text: "from   ",
            //           style: Styles.mediumText(
            //             color: context.isDarkMode
            //                 ? Colors.white
            //                 : AppColors.PRIMARY_COLOR,
            //           ),
            //           children: [
            //             TextSpan(
            //               text: formatTimeOfDayLocalized(time.from, context),
            //               style: Styles.mediumText(
            //                   color: context.isDarkMode
            //                       ? Colors.white
            //                       : AppColors.DARK_GRAY_COLOR),
            //             ),
            //           ],
            //         ),
            //       ),
          ),
          const Sizer(
            width: 20,
          ),
          InkWell(
            onTap: () {
              showTimePicker(
                context: context,
                initialTime: const TimeOfDay(hour: 11, minute: 0),
              ).then((value) {
                if (value != null) {
                  print(value);
                  if (value.isAfter(time.from)) {
                    setState(() {
                      time.to = value;
                      print(time.to);
                    });
                  } else {
                    showErrorMessage(
                        context,
                        context.isArabic
                            ? 'انتهاء الوقت يجب ان لا يكون قبل البدايه'
                            : 'End Time Cannot be before the Start Time');
                  }
                }
              });
            },
            child: RichText(
              text: TextSpan(
                text: '${LocaleKeys.to.localize} ',
                style: Styles.mediumText(
                  color: context.isDarkMode
                      ? Colors.white
                      : AppColors.PRIMARY_COLOR,
                ),
                children: [
                  TextSpan(
                    text: formatTimeOfDayLocalized(time.to, context),
                    style: Styles.mediumText(
                        color: context.isDarkMode
                            ? Colors.white
                            : AppColors.DARK_GRAY_COLOR),
                  ),
                ],
              ),
            ),
            // context.isArabic
            //     ? RichText(
            //         text: TextSpan(
            //           text: 'إلي   ',
            //           style: Styles.mediumText(
            //             color: context.isDarkMode
            //                 ? Colors.white
            //                 : AppColors.PRIMARY_COLOR,
            //           ),
            //           children: [
            //             TextSpan(
            //               text: formatTimeOfDayLocalized(time.to, context),
            //               style: Styles.mediumText(
            //                   color: context.isDarkMode
            //                       ? Colors.white
            //                       : AppColors.DARK_GRAY_COLOR),
            //             ),
            //           ],
            //         ),
            //       )
            //     : RichText(
            //         text: TextSpan(
            //           text: "to   ",
            //           style: Styles.mediumText(
            //             color: context.isDarkMode
            //                 ? Colors.white
            //                 : AppColors.PRIMARY_COLOR,
            //           ),
            //           children: [
            //             TextSpan(
            //               text: formatTimeOfDayLocalized(time.to, context),
            //               style: Styles.mediumText(
            //                   color: context.isDarkMode
            //                       ? Colors.white
            //                       : AppColors.DARK_GRAY_COLOR),
            //             ),
            //           ],
            //         ),

            //       ),
          ),
        ],
      ),
    );
  }

  String formatTimeOfDayLocalized(TimeOfDay time, BuildContext context) {
    // Get the current locale (language code)
    String languageCode = context.isArabic ? 'ar' : 'en';

    // Format the time in 12-hour format
    String period = time.period == DayPeriod.am ? 'AM' : 'PM';
    String hourFormatted = time.hourOfPeriod.toString().padLeft(2, '0');
    String minuteFormatted = time.minute.toString().padLeft(2, '0');

    // Return the localized time format based on language
    if (languageCode == 'ar') {
      print("objectHii");
      // For Arabic locale, append "صباحا" for AM and "مساءا" for PM
      return '$hourFormatted:$minuteFormatted ${period == 'AM' ? 'صباحا' : 'مساءا'}';
    } else {
      // For English locale, append "AM" or "PM"
      return '$hourFormatted:$minuteFormatted $period';
    }
  }
}
