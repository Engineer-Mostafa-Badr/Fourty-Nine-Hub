// import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/animations/create_custom_transition.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
// import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/zoom/domain/entities/scheduled_meeting.dart';
import 'package:fourtyninehub/features/zoom/presentation/controller/stream_cubit.dart';
import 'package:fourtyninehub/features/zoom/presentation/controller/stream_state.dart';
import 'package:fourtyninehub/features/zoom/presentation/pages/meeting_room.dart';
import 'package:fourtyninehub/features/zoom/presentation/widgets/join_meeting_screen.dart';
import 'package:fourtyninehub/features/zoom/presentation/widgets/schedule_meeting_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_launcher/utils/cli_logger.dart';
import '../../../../common/widgets/dynamic/sizer.dart';
import '../../../../common/widgets/stateless/labels/label.dart';
import '../../../../core/localization/locale_keys.g.dart';
import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';
import '../../../../routes/routes.dart';

class MeetingView extends StatelessWidget {
  const MeetingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(),
        // drawer: const DrawerWidget(),
        body: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.h),
            BlocBuilder<StreamCubit, StreamState>(
              builder: (context, state) {
                var cubit = context.read<StreamCubit>();
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildMeetingItem(
                      color: AppColors.SECONDARY_COLOR,
                      label: context.isArabic
                          ? '${LocaleKeys.meeting.localize} \n ${LocaleKeys.nnew.localize}'
                          : '${LocaleKeys.nnew.localize} \n ${LocaleKeys.meeting.localize}',
                      icon: Icons.video_call,
                      twoLines: true,
                      onTap: () async {
                        await newMeeting(cubit);
                        if (context.mounted) {
                          CliLogger.info('meeting id is ${cubit.meetingId}');
                          Navigator.of(context)
                              .push(createCustomTransitionRoute(
                            MeetingRoom(
                              payload: MeetingRoomArguments(
                                userName: context
                                    .read<UserCubit>()
                                    .state
                                    .data!
                                    .fullName,
                                isHost: true,
                                liveID: cubit.meetingId,
                                shareScreen: false
                              ),
                            ),
                            TransitionType.rightToLeft,
                          ));
                        }
                      },
                    ),
                    _buildMeetingItem(
                        color: AppColors.PRIMARY_COLOR,
                        label: LocaleKeys.join.localize,
                        icon: Icons.add_box_rounded,
                        onTap: () {
                          // join meeting
                          Navigator.of(context).push(
                              createCustomTransitionRoute(
                                  const JoinMeetingScreen(shareScreen: false),
                                  TransitionType.bottomToTop));
                        }),
                    _buildMeetingItem(
                      color: AppColors.PRIMARY_COLOR,
                      label: LocaleKeys.schedule.localize,
                      icon: Icons.calendar_today_outlined,
                      onTap: () async {
                        _scheduleAMeeting(context);
                      },
                    ),
                    _buildMeetingItem(
                        color: AppColors.PRIMARY_COLOR,
                        label:
                            '${LocaleKeys.share.localize} \n ${LocaleKeys.screen.localize}',
                        icon: Icons.screen_share,
                        twoLines: true,
                        onTap: () {
                          //share screen
                          Navigator.of(context).push(
                              createCustomTransitionRoute(
                                  const JoinMeetingScreen(shareScreen: true),
                                  TransitionType.bottomToTop));
                        }),
                  ],
                );
              },
            ),
            const Divider(),
            SizedBox(
              height: 40.h,
            ),
            Align(
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: () {
                  _scheduleAMeeting(context);
                },
                child: Text(
                  LocaleKeys.addAcalender.localize,
                  style: TextStyle(
                      color: context.isDarkMode
                          ? Colors.white
                          : AppColors.PRIMARY_COLOR,
                      fontSize: 32.sp,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            _scheduledMeetings()
          ],
        )));
  }

  Container _scheduledMeetings() {
    return Container(
      constraints:
          const BoxConstraints(maxHeight: double.infinity, minHeight: 400),
      child: BlocListener<StreamCubit, StreamState>(
        listener: (context, state) {
          if (state.isFailure) {
            showErrorMessage(
                context,
                getFailureMessage(
                  state.failure!,
                  context,
                ));
          }
          if (state.isGotScheduledMeeting) {}
        },
        child: BlocBuilder<StreamCubit, StreamState>(
          builder: (context, state) {
            print('schedule state is  ${state.toString()}');
            CliLogger.warning('WARNING state is updated${state.status}');
            if (state.isLoading) {
              // print('data is loading');
              return Container();
            }
            if (state.scheduledMeeting == null) {
              // print('data is null');
              return Container();
            } else if (state.isSuccess) {
              return ListView.builder(
                  itemCount: state.scheduledMeeting!.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    ScheduledMeeting scheduledMeeting =
                        state.scheduledMeeting![index];
                    print(
                        'scheduled meeting success ${state.scheduledMeeting!.first.toString()}');
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          color: context.isDarkMode
                              ? Colors.black87
                              : Colors.grey[400],
                          width: double.maxFinite,
                          padding: EdgeInsetsDirectional.only(
                            start: 30.w,
                            top: 5.h,
                            bottom: 5.h,
                          ),
                          child: Label(
                            text: formatDateString(scheduledMeeting.startDate),
                            style: Styles.headerText(
                                fontSize: 25,
                                color: context.isDarkMode
                                    ? Colors.white
                                    : Colors.grey),
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
                                        fontSize: 25,
                                        color: context.isDarkMode
                                            ? Colors.white
                                            : Colors.grey[600]),
                                  ),
                                  Label(
                                    text: getPeriod(scheduledMeeting.startDate),
                                    style: Styles.headerText(
                                        fontSize: 18,
                                        color: context.isDarkMode
                                            ? Colors.white
                                            : Colors.grey[600]),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  SizedBox(height: 5.h),
                                  Label(
                                    text: scheduledMeeting.title,
                                    style: Styles.headerText(
                                        fontSize: 25,
                                        color: context.isDarkMode
                                            ? Colors.white
                                            : Colors.grey[600]),
                                  ),
                                  SizedBox(height: 5.h),
                                  Label(
                                    text:
                                        '${LocaleKeys.meetingId.localize} ${scheduledMeeting.roomId}',
                                    style: Styles.headerText(
                                        fontSize: 20,
                                        color: context.isDarkMode
                                            ? Colors.white
                                            : Colors.grey[600]),
                                  ),
                                ],
                              ),
                              SizedBox(width: 15.h),
                              InkWell(
                                onTap: () {
                                  //to unschedule
                                  joinRoom(context.read<StreamCubit>(),
                                      scheduledMeeting.roomId);
                                  if (context.mounted) {
                                    context.go(Routes.MEETINGROOM,
                                        extra: MeetingRoomArguments(
                                            liveID:scheduledMeeting.roomId,
                                            isHost:true,
                                            userName:context
                                                .read<UserCubit>()
                                                .state
                                                .data!
                                                .fullName));
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppColors.PRIMARY_COLOR,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    LocaleKeys.startNow.localize,
                                    style:
                                        Styles.smallText(color: Colors.white),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    );
                  });
            }
            return Container();
          },
        ),
      ),
    );
  }

  Future<bool> joinRoom(StreamCubit cubit, String liveId) async {
    return cubit.joinNewMeeting(liveId);
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
      return LocaleKeys.tommorow.localize;
    } else if (dateTime
            .isAfter(tomorrow.subtract(const Duration(seconds: 1))) &&
        dateTime.isBefore(tomorrow.add(const Duration(days: 1)))) {
      return LocaleKeys.today.localize;
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

  Future<void> newMeeting(StreamCubit cubit) async {
    cubit.createNewMeeting();
  }

  void _scheduleAMeeting(BuildContext context) {
    Navigator.of(context).push(createCustomTransitionRoute(
        const ScheduleMeetingScreen(),
        TransitionType.bottomToTop));
  }

  Widget _buildMeetingItem({
    required Color color,
    required String label,
    required IconData icon,
    required Function onTap,
    bool twoLines = false,
  }) {
    return InkWell(
      onTap: () => onTap(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            // height: 80.h,
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
          Sizer(
            height: twoLines ? 10.h : 30.h,
          ),
          Label(
              text: label,
              textAlign: TextAlign.center,
              style: Styles.headerText(fontSize: 25))
        ],
      ),
    );
  }
}
