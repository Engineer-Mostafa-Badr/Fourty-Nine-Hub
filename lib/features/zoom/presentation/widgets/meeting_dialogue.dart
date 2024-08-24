import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/zego_uikit_prebuilt_live_streaming.dart';
import 'package:fourtyninehub/features/zoom/presentation/bloc/zoom_cubit.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:go_router/go_router.dart';

import '../../../../routes/routes.dart';
import '../../../../service_locator/service_locator.dart';
import '../bloc/zoom_state.dart';

void showMeetingDialogue(BuildContext context, {bool shareScreen = false}) {
  TextEditingController meetingIdController = TextEditingController();
  //random num will be 6 digits

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return BlocProvider.value(
        value: serviceLocator<MeetingCubit>(),
        child: AlertDialog(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text(
            shareScreen ? 'Join with Share Screen' : 'Join a Meeting',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 30.zSP, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'join an existing meeting.',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.normal),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: TextField(
                  controller: meetingIdController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Meeting ID',
                    hintText: 'Meeting ID',
                    labelStyle: TextStyle(color: AppColors.QUANTITY_COLOR),
                    hintStyle: TextStyle(color: AppColors.QUANTITY_COLOR),
                    prefixIcon: Icon(
                      Icons.meeting_room,
                      color: AppColors.QUANTITY_COLOR,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    filled: true,
                    fillColor: AppColors.AUTH_CONTAINER_COLOR,
                  ),
                ),
              ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: <Widget>[
            BlocConsumer<MeetingCubit, MeetingState>(
                listener: (context, state) {
                  
                  String meetingId = meetingIdController.text.trim();
                  if (state.isLoading) {
                    showLoadingDialog(context);
                  } else if (state.isSuccess) {
                    context.pop(); // Close loading dialog
                    context.push(
                      Routes.MEETINGROOM,
                      extra: ZegoArgs(meetingId, false,
                          shareScreen: shareScreen ? true : false),
                    );
                    showSuccessMessage(
                      context,
                      'Joining meeting with ID: $meetingId',
                    );
                  } else if (state.isFailure) {
                    context.pop(); // Close loading dialog
                    context.pop();
                  }
                },
                builder: (context, state) => TextButton(
                      onPressed: () async {
                        String meetingId = meetingIdController.text.trim();

                        if (meetingId.isEmpty) {
                          showErrorMessage(
                              context, 'Meeting ID cannot be empty');
                          return;
                        } else {
                          var cubit = context.read<MeetingCubit>();
                          await joinRoom(cubit, meetingId);
                        }
                      },
                      child: const Text('Join Meeting'),
                    )),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      );
    },
  );
}

Future<void> joinRoom(MeetingCubit cubit, String liveId) async {
  return cubit.joinRoom(liveId);
}

//for passing args
class ZegoArgs {
  final String liveId;
  final bool isHost;
  final bool shareScreen;

  ZegoArgs(this.liveId, this.isHost, {this.shareScreen = false});
}
