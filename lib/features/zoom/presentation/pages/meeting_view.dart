import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/zego_uikit_prebuilt_live_streaming.dart';
import 'package:fourtyninehub/features/zoom/presentation/bloc/zoom_cubit.dart';
import 'package:fourtyninehub/features/zoom/presentation/bloc/zoom_state.dart';
import 'package:fourtyninehub/features/zoom/presentation/widgets/meeting_dialogue.dart';
import 'package:fourtyninehub/features/zoom/presentation/widgets/schedule_meeting_bottom_sheet.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/widgets/dynamic/drawer.dart';
import '../../../../common/widgets/dynamic/sizer.dart';
import '../../../../common/widgets/stateless/appbar/home_appbar.dart';
import '../../../../common/widgets/stateless/labels/label.dart';
import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';
import '../../../../routes/routes.dart';

class MeetingView extends StatelessWidget {
  const MeetingView({super.key});

  @override
  Widget build(BuildContext context) {
    // init signalling service

    return Scaffold(
      appBar: const HomeAppbar(
        isWithBackArrow: true,
      ),
      drawer: const DrawerWidget(),
      body: BlocBuilder<MeetingCubit, MeetingState>(
        builder: (context, state) {
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
                          extra: ZegoArgs(genRandNo, true, shareScreen: false),
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
              const Align(
                alignment: Alignment.center,
                child: Text(
                  'Add a calender',
                  style: TextStyle(color: Colors.blueAccent, fontSize: 16, fontWeight: FontWeight.w600),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  String get genRandNo {
    int min = 10000000;
    int max = 99999999;
    final String liveId = '${min + Random().nextInt(max - min)}';
    return liveId;
  }

  Future<void> newMeeting(MeetingCubit cubit) async {
    cubit.addRoom(genRandNo);
  }

  void _showScheduleMeetingBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => ScheduleMeetingBottomSheet(),
    );
  }

  Widget _buildMeetingItem(
      {required Color color, required String label, required IconData icon, required Function onTap}) {
    return InkWell(
      onTap: () => onTap(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            // height: 80,
            // width: 80,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: color),
            child: Icon(
              icon,
              color: Colors.white,
              size: 20,
            ),
          ),
          const Sizer(),
          Label(text: label, style: Styles.headerText(fontSize: 13))
        ],
      ),
    );
  }
}
