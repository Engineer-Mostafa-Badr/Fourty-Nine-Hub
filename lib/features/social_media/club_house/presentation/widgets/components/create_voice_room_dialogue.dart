import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/social_media/club_house/presentation/pages/audio_stream_screen.dart';
import 'package:fourtyninehub/routes/pages.dart';
import 'package:go_router/go_router.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';

import '../../../../../../routes/routes.dart';

void showVoiceLiveDialogue(BuildContext context) {
  TextEditingController roomSubjectController = TextEditingController();
  final String liveId = Random().nextInt(100000).toString();
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(
          'Room Subject',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(
              height: 10,
            ),
            const Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Please enter simple description',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.normal),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: TextField(
                controller: roomSubjectController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'Room Subject',
                  hintText: 'Enter room subject',
                  prefixIcon: const Icon(Icons.headset_mic_rounded),
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
              String roomSub = roomSubjectController.text.trim();
              // Implement the logic to join the meeting using the provided meeting ID.
              // For now, just display the meeting ID.
              if (roomSub.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Room subject cannot be empty'),
                  ),
                );
                return;
              } else {
                context.pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) => AudioStreamScreen(
                        liveId: liveId, roomSubject: roomSub, isHost: true),
                  ),
                );
              }
            },
            child: const Text('Create Room'),
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
class RoomArgs {
  final String liveId;
  final String subject;
  final bool isHost;
  RoomArgs(this.liveId, this.subject, this.isHost);
}
