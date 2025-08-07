// Flutter imports:
import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/components/zego_uikit/src/components/screen_util/core/size_extension.dart';

import '../../components/defines.dart';
import '../seat/seat_manager.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

/// @nodoc
class ZegoLiveAudioRoomHostLockSeatButton extends StatefulWidget {
  final Size? iconSize;
  final Size? buttonSize;
  final ZegoLiveAudioRoomSeatManager seatManager;

  const ZegoLiveAudioRoomHostLockSeatButton({
    super.key,
    required this.seatManager,
    this.iconSize,
    this.buttonSize,
  });

  @override
  State<ZegoLiveAudioRoomHostLockSeatButton> createState() =>
      _ZegoLiveAudioRoomHostLockSeatButtonState();
}

/// @nodoc
class _ZegoLiveAudioRoomHostLockSeatButtonState
    extends State<ZegoLiveAudioRoomHostLockSeatButton> {
  var voiceChangerSelectedIDNotifier = ValueNotifier<String>('');
  var reverbSelectedIDNotifier = ValueNotifier<String>('');

  @override
  Widget build(BuildContext context) {
    final containerSize = widget.buttonSize ?? Size(96.zR, 96.zR);
    final sizeBoxSize = widget.iconSize ?? Size(56.zR, 56.zR);
    return GestureDetector(
      onTap: () async {
      ManageVibration.vibrate();
        widget.seatManager.lockSeat(
          !widget.seatManager.isRoomSeatLockedNotifier.value,
        );
      },
      child: Container(
        width: containerSize.width,
        height: containerSize.height,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: SizedBox.fromSize(
          size: sizeBoxSize,
          child: ValueListenableBuilder<bool>(
              valueListenable: widget.seatManager.isRoomSeatLockedNotifier,
              builder: (context, isRoomSeatLocked, _) {
                return ZegoLiveAudioRoomImage.asset(
                  isRoomSeatLocked
                      ? ZegoLiveAudioRoomIconUrls.toolbarHostUnLockSeat
                      : ZegoLiveAudioRoomIconUrls.toolbarHostLockSeat,
                );
              }),
        ),
      ),
    );
  }
}