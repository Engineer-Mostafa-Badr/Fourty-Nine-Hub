import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/zoom/presentation/bloc/zoom_cubit.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:go_router/go_router.dart';

import '../../../../routes/routes.dart';
import '../../../../service_locator/service_locator.dart';
import '../bloc/zoom_state.dart';

void showMeetingDialogue(BuildContext context) {
  TextEditingController meetingIdController = TextEditingController();
  //random num will be 6 digits
  String liveId = genRandNo;
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return BlocProvider.value(
        value: serviceLocator<MeetingCubit>(),
        child: AlertDialog(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: const Text(
            'Meeting Options: ',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
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
            BlocBuilder<MeetingCubit, MeetingState>(
              builder: (context, state) {
                final cubit = context.read<MeetingCubit>();
                return TextButton(
                  onPressed: () async {
                    String meetingId = meetingIdController.text.trim();
                    // Implement the logic to join the meeting using the provided meeting ID.
                    // For now, just display the meeting ID.
                    if (meetingId.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Meeting ID cannot be empty'),
                        ),
                      );
                      return;
                    } else {
                      await joinRoom(cubit, liveId);
                      if (context.mounted) {
                        context.push(
                          Routes.MEETINGROOM,
                          extra: ZegoArgs(liveId, false),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text('Joining meeting with ID: $meetingId'),
                          ),
                        );
                        context.pop();
                      }
                    }
                  },
                  child: const Text('Join Meeting'),
                );
              },
            ),
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

String get genRandNo {
  int min = 100000;
  int max = 999999;
  final String liveId = '${min + Random().nextInt(max - min)}';
  return liveId;
}

Future<void> joinRoom(MeetingCubit cubit, String liveId) async {
  return cubit.joinRoom(liveId);
}

//for passing args
class ZegoArgs {
  final String liveId;
  final bool isHost;

  ZegoArgs(this.liveId, this.isHost);
}
