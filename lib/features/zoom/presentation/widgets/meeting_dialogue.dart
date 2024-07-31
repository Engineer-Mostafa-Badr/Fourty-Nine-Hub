import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';

import '../../../../routes/routes.dart';

void showMeetingDialogue(BuildContext context) {
  TextEditingController meetingIdController = TextEditingController();
  final String liveId = Random().nextInt(100000).toString();
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
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
                child: ElevatedButton(
                  onPressed: () {
                    if (ZegoUIKitPrebuiltLiveStreamingController()
                        .minimize
                        .isMinimizing) {
                      /// when the application is minimized (in a minimized state),
                      /// disable button clicks to prevent multiple PrebuiltLiveStreaming components from being created.
                      return;
                    }
                    context.pop();
                    context.push(
                      Routes.MEETINGROOM,
                      extra: DetailArgs(liveId, true),
                    );
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
          TextButton(
            onPressed: () {
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
                context.push(
                  Routes.MEETINGROOM,
                  extra: DetailArgs(liveId, false),
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Joining meeting with ID: $meetingId'),
                  ),
                );
              }
              context.pop();
            },
            child: const Text('Join Meeting'),
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
      );
    },
  );
}

//for passing args
class DetailArgs {
  final String liveId;
  final bool isHost;

  DetailArgs(this.liveId, this.isHost);
}
