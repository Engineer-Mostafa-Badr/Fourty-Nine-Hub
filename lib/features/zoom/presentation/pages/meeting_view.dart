import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/zoom/presentation/bloc/zoom_cubit.dart';
import 'package:fourtyninehub/features/zoom/presentation/bloc/zoom_state.dart';
import 'package:fourtyninehub/features/zoom/presentation/widgets/meeting_dialogue.dart';
import 'package:go_router/go_router.dart';
import '../../../../common/widgets/dynamic/sizer.dart';
import '../../../../common/widgets/stateless/labels/label.dart';

import '../../../../common/widgets/dynamic/bottom_navigator.dart';
import '../../../../common/widgets/dynamic/drawer.dart';
import '../../../../common/widgets/dynamic/floating_button.dart';
import '../../../../common/widgets/stateless/appbar/home_appbar.dart';
import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';
import '../../../../routes/routes.dart';

class MeetingView extends StatelessWidget {
  const MeetingView({super.key});

  @override
  Widget build(BuildContext context) {
    // init signalling service

    return Scaffold(
      backgroundColor: AppColors.GRAY_LIGHT_COLOR3,
      appBar: const HomeAppbar(),
      drawer: const DrawerWidget(),
      // bottomNavigationBar: const BottomNavigator(
      //   mainCategory: 3,
      //   index: 2,
      // ),
      // floatingActionButton: const FloatingButton(
      //   changeView: 2,
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: BlocBuilder<MeetingCubit, MeetingState>(
        builder: (context, state) {
          var cubit = context.read<MeetingCubit>();
          return GridView(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 1,
              crossAxisCount: 2,
            ),
            children: [
              _buildMeetingItem(
                color: AppColors.ACCENT_COLOR,
                label: 'New Meeting',
                icon: Icons.video_call,
                onTap: () async {
                  await newMeeting(cubit);
                  if (context.mounted) {
                    context.push(
                      Routes.MEETINGROOM,
                      extra: ZegoArgs(genRandNo, true),
                    );
                  }
                },
              ),
              _buildMeetingItem(
                  color: AppColors.PRIMARY_COLOR,
                  label: 'Join',
                  icon: Icons.add_box_rounded,
                  onTap: () {
                    // join meeting
                    showMeetingDialogue(context);
                  }),
            ],
          );
        },
      ),
    );
  }

  Future<void> newMeeting(MeetingCubit cubit) async {
    cubit.addRoom(genRandNo);
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
            height: 80,
            width: 80,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: color),
            child: Icon(
              icon,
              color: Colors.white,
              size: 35,
            ),
          ),
          const Sizer(),
          Label(text: label, style: Styles.headerText(fontSize: 13))
        ],
      ),
    );
  }
}

//for passing args

