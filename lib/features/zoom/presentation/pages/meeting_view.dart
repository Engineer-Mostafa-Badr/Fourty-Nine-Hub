import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/zego_uikit_prebuilt_live_streaming.dart';
import 'package:fourtyninehub/features/zoom/domain/entities/scheduled_meeting.dart';
import 'package:fourtyninehub/features/zoom/presentation/bloc/zoom_cubit.dart';
import 'package:fourtyninehub/features/zoom/presentation/bloc/zoom_state.dart';
import 'package:fourtyninehub/features/zoom/presentation/widgets/meeting_dialogue.dart';
import 'package:fourtyninehub/features/zoom/presentation/widgets/schedule_meeting_bottom_sheet.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';
import '../../../../common/widgets/dynamic/sizer.dart';
import '../../../../common/widgets/stateless/labels/label.dart';

import '../../../../common/widgets/dynamic/drawer.dart';
import '../../../../common/widgets/stateless/appbar/home_appbar.dart';
import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';
import '../../../../routes/routes.dart';

class MeetingView extends StatelessWidget {
  const MeetingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: const HomeAppbar(
        isWithBackArrow: true,
      ),
      drawer: const DrawerWidget(),
      body: SingleChildScrollView(
        child: BlocBuilder<MeetingCubit, MeetingState>(
          builder: (_, state) {
            var cubit = context.read<MeetingCubit>();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.zH),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildMeetingItem(
                      color: AppColors.ACCENT_COLOR,
                      label: 'new_meeting'.tr(),
                      icon: Icons.video_call,
                      onTap: () async {
                        await newMeeting(cubit);
                        if (context.mounted) {
                          context.push(
                            Routes.MEETINGROOM,
                            extra:
                                ZegoArgs(genRandNo, true, shareScreen: false),
                          );
                        }
                      },
                    ),
                    _buildMeetingItem(
                        color: Colors.blueAccent[700]!,
                        label: 'join'.tr(),
                        icon: Icons.add_box_rounded,
                        onTap: () {
                          // join meeting
                          showMeetingDialogue(context);
                        }),
                    _buildMeetingItem(
                      color: Colors.blueAccent[700]!,
                      label: 'Schedule'.tr(),
                      icon: Icons.calendar_today_outlined,
                      onTap: () async {
                        _showScheduleMeetingBottomSheet(context);
                      },
                    ),
                    _buildMeetingItem(
                      color: Colors.blueAccent[700]!,
                      label: 'ShareScreen'.tr(),
                      icon: Icons.screen_share,
                      onTap: () {
                        showMeetingDialogue(context, shareScreen: true);
                      },
                    ),
                  ],
                ),
                const Divider(),
                SizedBox(
                  height: 40.zH,
                ),
                Align(
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: () {
                      _showScheduleMeetingBottomSheet(context);
                    },
                    child: const Text(
                      'Add a calender',
                      style: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.zH,
                ),
                _scheduledMeetings(cubit)
              ],
            );
          },
        ),
      ),
    );
  }

  Container _scheduledMeetings(MeetingCubit cubit) {
    return Container(
      constraints:
          const BoxConstraints(maxHeight: double.infinity, minHeight: 400),
      child: ListView.builder(
          itemCount: cubit.scheduledMeetingList.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            ScheduledMeeting scheduledMeeting =
                cubit.scheduledMeetingList[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: Colors.grey[400],
                  width: double.maxFinite,
                  padding: EdgeInsets.only(
                    left: 30.zW,
                    top: 5.zH,
                    bottom: 5.zH,
                  ),
                  child: Label(
                    text: formatDateString(scheduledMeeting.startDate),
                    style: Styles.headerText(fontSize: 25),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Label(
                            text: getHour(scheduledMeeting.startDate),
                            style: Styles.headerText(
                                fontSize: 25, color: Colors.grey[600]),
                          ),
                          Label(
                            text: getPeriod(scheduledMeeting.startDate),
                            style: Styles.headerText(
                                fontSize: 18, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          SizedBox(height: 5.zH),
                          Label(
                            text: scheduledMeeting.title,
                            style: Styles.headerText(fontSize: 25),
                          ),
                          SizedBox(height: 5.zH),
                          Label(
                            text: 'Meeting ID: ${scheduledMeeting.roomId}',
                            style: Styles.headerText(
                                fontSize: 20, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                      SizedBox(width: 15.zW),
                      InkWell(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'Start Now',
                            style: Styles.smallText(color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            );
          }),
    );
  }

  String get genRandNo {
    int min = 10000000;
    int max = 99999999;
    final String liveId = '${min + Random().nextInt(max - min)}';
    return liveId;
  }

  String formatDateString(String dateString) {
    // Parse the input date string
    DateTime dateTime = DateTime.parse(dateString).toLocal();

    // Get the current date
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime tomorrow = today.add(const Duration(days: 1));

    // Compare the date and return the appropriate string
    if (dateTime.isAfter(today.subtract(const Duration(seconds: 1))) &&
        dateTime.isBefore(tomorrow)) {
      return 'Today';
    } else if (dateTime
            .isAfter(tomorrow.subtract(const Duration(seconds: 1))) &&
        dateTime.isBefore(tomorrow.add(const Duration(days: 1)))) {
      return 'Tomorrow';
    } else {
      // Format the date as dd/MM
      return DateFormat('d/M').format(dateTime);
    }
  }

  String getHour(String dateString) {
    DateTime dateTime = DateTime.parse(dateString).toLocal();
    String hour = DateFormat('h:mm').format(dateTime);

    return hour;
  }

  String getPeriod(String dateString) {
    DateTime dateTime = DateTime.parse(dateString).toLocal();
    String period = dateTime.hour < 12 ? 'AM' : 'PM';
    return period;
  }

  Future<void> newMeeting(MeetingCubit cubit) async {
    cubit.addRoom(genRandNo);
  }

  void _showScheduleMeetingBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => BlocProvider.value(
        value: serviceLocator<MeetingCubit>(),
        child: ScheduleMeetingBottomSheet(
          genRandNo,
        ),
      ),
    );
  }

  Widget _buildMeetingItem(
      {required Color color,
      required String label,
      required IconData icon,
      required Function onTap}) {
    return InkWell(
      onTap: () => onTap(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            // height: 80,
            // width: 80,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: color),
            child: Icon(
              icon,
              color: Colors.white,
              size: 20,
            ),
          ),
          const Sizer(),
          Label(text: label, style: Styles.headerText(fontSize: 25))
        ],
      ),
    );
  }
}
