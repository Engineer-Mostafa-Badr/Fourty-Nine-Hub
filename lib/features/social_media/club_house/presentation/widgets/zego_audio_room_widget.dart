import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/zego_uikit_prebuilt_live_audio_room.dart';

class ZegoAudioRoomWidget extends StatefulWidget {
  final bool isHost;
  const ZegoAudioRoomWidget({
    super.key,
    required this.isHost,
  });

  @override
  State<ZegoAudioRoomWidget> createState() => _ZegoAudioRoomWidgetState();
}

class _ZegoAudioRoomWidgetState extends State<ZegoAudioRoomWidget> {
  final userId = Random().nextInt(1000).toString();
  final isSeatClosedNotifier = ValueNotifier<bool>(false);
  final isRequestingNotifier = ValueNotifier<bool>(false);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ZegoUIKitPrebuiltLiveAudioRoom(
        appID: UIConst
            .appId, // Fill in the appID that you get from ZEGOCLOUD Admin Console.
        appSign: UIConst
            .appSign, // Fill in the appSign that you get from ZEGOCLOUD Admin Console.
        userID: userId,
        userName: 'user $userId',
        roomID: '123',
        events: ZegoUIKitPrebuiltLiveAudioRoomEvents(
          seat: ZegoLiveAudioRoomSeatEvents(
            onClosed: () {
              isSeatClosedNotifier.value = true;
            },
            onOpened: () {
              isSeatClosedNotifier.value = false;
            },
            onChanged: (
              Map<int, ZegoUIKitUser> takenSeats,
              List<int> untakenSeats,
            ) {
              if (isRequestingNotifier.value) {
                if (takenSeats.values
                    .map((e) => e.id)
                    .toList()
                    .contains(userId)) {
                  /// on the seat now
                  isRequestingNotifier.value = false;
                }
              }
            },
            host: ZegoLiveAudioRoomSeatHostEvents(),
            audience: ZegoLiveAudioRoomSeatAudienceEvents(
              onTakingRequestFailed: () {
                isRequestingNotifier.value = false;
              },
              onTakingRequestRejected: () {
                isRequestingNotifier.value = false;
              },
            ),
          ),
        ),

        config: widget.isHost
            ? (ZegoUIKitPrebuiltLiveAudioRoomConfig.host()
              ..seat.takeIndexWhenJoining = 0)
            : ZegoUIKitPrebuiltLiveAudioRoomConfig.audience()
          ..userAvatarUrl =
              'https://www.allprodad.com/wp-content/uploads/2021/03/05-12-21-happy-people.jpg'
          ..seat.hostIndexes = [0]
          ..seat.layout.rowConfigs = [
            ZegoLiveAudioRoomLayoutRowConfig(
                count: 1, alignment: ZegoLiveAudioRoomLayoutAlignment.center),
            ZegoLiveAudioRoomLayoutRowConfig(
                count: 4,
                alignment: ZegoLiveAudioRoomLayoutAlignment.spaceAround),
            ZegoLiveAudioRoomLayoutRowConfig(
                count: 4,
                alignment: ZegoLiveAudioRoomLayoutAlignment.spaceAround),
          ]
          ..bottomMenuBar.audienceExtendButtons = [
            connectButton(),
          ],
      ),
    );
  }

  Widget connectButton() {
    return ValueListenableBuilder<bool>(
      valueListenable: isSeatClosedNotifier,
      builder: (context, isSeatClosed, _) {
        return isSeatClosed
            ? ValueListenableBuilder<bool>(
                valueListenable: isRequestingNotifier,
                builder: (context, isRequesting, _) {
                  return isRequesting
                      ? ElevatedButton(
                          onPressed: () {
                            ZegoUIKitPrebuiltLiveAudioRoomController()
                                .seat
                                .audience
                                .cancelTakingRequest()
                                .then((result) {
                              isRequestingNotifier.value = false;
                            });
                          },
                          child: const Text('Cancel'),
                        )
                      : ElevatedButton(
                          onPressed: () {
                            ZegoUIKitPrebuiltLiveAudioRoomController()
                                .seat
                                .audience
                                .applyToTake()
                                .then((result) {
                              isRequestingNotifier.value = result;
                            });
                          },
                          child: const Text('Request'),
                        );
                },
              )
            : Container();
      },
    );
  }
}
