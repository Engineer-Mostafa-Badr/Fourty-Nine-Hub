import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/zoom/domain/usecases/add_room_use_case.dart';
import 'package:fourtyninehub/features/zoom/presentation/bloc/zoom_cubit.dart';
import 'package:go_router/go_router.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';

import '../../../../routes/routes.dart';
import '../../../../service_locator/service_locator.dart';
import '../bloc/zoom_state.dart';

void showMeetingDialogue(BuildContext context) {
  TextEditingController meetingIdController = TextEditingController();
  //random num will be 6 digits
  int min = 100000;
  int max = 999999;
  final String liveId = '${min + Random().nextInt(max - min)}';
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return BlocProvider.value(
        value: serviceLocator<MeetingCubit>(),
        child: AlertDialog(
          title: const Text(
            'Meeting Options: ',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                width: double.infinity / 2,
                child: Align(
                  alignment: Alignment.center,
                  child: BlocBuilder<MeetingCubit, MeetingState>(
                    builder: (context, state) {
                      final cubit = context.read<MeetingCubit>();
                      return ElevatedButton(
                        onPressed: () async {
                          if (ZegoUIKitPrebuiltLiveStreamingController()
                              .minimize
                              .isMinimizing) {
                            /// when the application is minimized (in a minimized state),
                            /// disable button clicks to prevent multiple PrebuiltLiveStreaming components from being created.
                            return;
                          }
                          await addRoom(cubit, liveId);
                          if (context.mounted) {
                            context.push(
                              Routes.MEETINGROOM,
                              extra: ZegoArgs(liveId, true),
                            );
                            context.pop();
                          }
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Text(
                            'Start Meeting',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Or join an existing meeting.',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.normal),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: TextField(
                  controller: meetingIdController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Meeting ID',
                    hintText: 'Enter meeting ID',
                    prefixIcon: const Icon(Icons.meeting_room),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
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

Future<void> addRoom(MeetingCubit cubit, String liveId) async {
  return cubit.addRoom(liveId);
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
