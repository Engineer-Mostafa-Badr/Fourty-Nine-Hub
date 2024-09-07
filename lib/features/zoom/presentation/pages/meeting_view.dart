// import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/animations/create_custom_transition.dart';
import 'package:fourtyninehub/core/error/failure.dart';
// import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/zego_uikit_prebuilt_live_streaming.dart';
import 'package:fourtyninehub/features/zoom/domain/entities/scheduled_meeting.dart';
import 'package:fourtyninehub/features/zoom/presentation/bloc/meeting_cubit.dart';
import 'package:fourtyninehub/features/zoom/presentation/bloc/meeting_state.dart';
import 'package:fourtyninehub/features/zoom/presentation/pages/meeting_room.dart';
import 'package:fourtyninehub/features/zoom/presentation/widgets/join_meeting_screen.dart';
import 'package:fourtyninehub/features/zoom/presentation/widgets/schedule_meeting_screen.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_launcher/utils/cli_logger.dart';

import '../../../../common/widgets/dynamic/sizer.dart';
import '../../../../common/widgets/stateless/labels/label.dart';
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
            SizedBox(height: 16.zH),
            BlocBuilder<MeetingCubit, MeetingState>(
              builder: (context, state) {
                var cubit = context.read<MeetingCubit>();
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildMeetingItem(
                      color: AppColors.SECONDARY_COLOR,
                      label: 'New \n Meeting'.tr(),
                      icon: Icons.video_call,
                      twoLines: true,
                      onTap: () async {
                        await newMeeting(cubit);
                        if (context.mounted) {
                          CliLogger.info('meeting id is ${cubit.meetingId}');
                          Navigator.of(context)
                              .push(createCustomTransitionRoute(
                            MeetingRoom(
                              shareScreen: false,
                              isHost: true,
                              liveID: cubit.meetingId,
                              userName: context
                                  .read<UserCubit>()
                                  .state
                                  .data!
                                  .fullName,
                            ),
                            TransitionType.rightToLeft,
                          ));
                        }
                      },
                    ),
                    _buildMeetingItem(
                        color: AppColors.PRIMARY_COLOR,
                        label: 'join'.tr(),
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
                      label: 'Schedule'.tr(),
                      icon: Icons.calendar_today_outlined,
                      onTap: () async {
                        _scheduleAMeeting(context);
                      },
                    ),
                    _buildMeetingItem(
                        color: AppColors.PRIMARY_COLOR,
                        label: 'Share\nScreen'.tr(),
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
              height: 40.zH,
            ),
            Align(
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: () {
                  _scheduleAMeeting(context);
                },
                child: const Text(
                  'Add a calender',
                  style: TextStyle(
                      color: AppColors.PRIMARY_COLOR,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
            SizedBox(
              height: 10.zH,
            ),
            _scheduledMeetings()
          ],
        )));
  }

  Container _scheduledMeetings() {
    return Container(
      constraints:
          const BoxConstraints(maxHeight: double.infinity, minHeight: 400),
      child: BlocListener<MeetingCubit, MeetingState>(
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
        child: BlocBuilder<MeetingCubit, MeetingState>(
          builder: (context, state) {
            print('schedule state is  ${state.toString()}');
            CliLogger.warning('WARNING state is updated${state.status}');
            if (state.isLoading) {
              // print('data is loading');
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }
            if (state.scheduledMeeting == null) {
              // print('data is null');
              return Container();
            } else if (state.isGotScheduledMeeting || state.isSuccess) {
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
                                    text:
                                        'Meeting ID: ${scheduledMeeting.roomId}',
                                    style: Styles.headerText(
                                        fontSize: 20, color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                              SizedBox(width: 15.zW),
                              InkWell(
                                onTap: ()  {
                                  //to unschedule
                                   joinRoom(context.read<MeetingCubit>(),
                                      scheduledMeeting.roomId);
                                  if (context.mounted) {
                                    context.go(Routes.MEETINGROOM,
                                        extra: ZegoArgs(
                                            scheduledMeeting.roomId,
                                            true,
                                            context
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
                                    'Start Now',
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

  Future<bool> joinRoom(MeetingCubit cubit, String liveId) async {
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
    cubit.createNewMeeting();
  }

  void _scheduleAMeeting(BuildContext context) {
    Navigator.of(context).push(createCustomTransitionRoute(
        BlocProvider.value(
          value: serviceLocator<MeetingCubit>(),
          child: const ScheduleMeetingScreen(),
        ),
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
          Sizer(
            height: twoLines ? 10.zH : 30.zH,
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
