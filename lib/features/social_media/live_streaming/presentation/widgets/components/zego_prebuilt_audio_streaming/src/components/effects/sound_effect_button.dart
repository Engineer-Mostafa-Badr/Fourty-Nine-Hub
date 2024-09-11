// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:

// Project imports:
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/components/zego_prebuilt_audio_streaming/zego_uikit_prebuilt_live_audio_room.dart';

import '../defines.dart';
import '../pop_up_manager.dart';
import 'sound_effect_sheet.dart';


/// @nodoc
class ZegoLiveAudioRoomSoundEffectButton extends StatefulWidget {
  final ZegoUIKitPrebuiltLiveAudioRoomInnerText innerText;

  final List<VoiceChangerType> voiceChangeEffect;
  final List<ReverbType> reverbEffect;

  final Size? iconSize;
  final Size? buttonSize;
  final ButtonIcon? icon;

  final bool rootNavigator;
  final ZegoLiveAudioRoomPopUpManager popUpManager;

  const ZegoLiveAudioRoomSoundEffectButton({
    Key? key,
    required this.innerText,
    required this.voiceChangeEffect,
    required this.reverbEffect,
    required this.popUpManager,
    this.rootNavigator = false,
    this.iconSize,
    this.buttonSize,
    this.icon,
  }) : super(key: key);

  @override
  State<ZegoLiveAudioRoomSoundEffectButton> createState() =>
      _ZegoLiveAudioRoomSoundEffectButtonState();
}

/// @nodoc
class _ZegoLiveAudioRoomSoundEffectButtonState
    extends State<ZegoLiveAudioRoomSoundEffectButton> {
  var voiceChangerSelectedIDNotifier = ValueNotifier<String>('');
  var reverbSelectedIDNotifier = ValueNotifier<String>('');

  @override
  Widget build(BuildContext context) {
    final containerSize = widget.buttonSize ?? Size(96.zR, 96.zR);
    final sizeBoxSize = widget.iconSize ?? Size(56.zR, 56.zR);
    return GestureDetector(
      onTap: () async {
        showSoundEffectSheet(
          context,
          innerText: widget.innerText,
          voiceChangeEffect: widget.voiceChangeEffect,
          voiceChangerSelectedIDNotifier: voiceChangerSelectedIDNotifier,
          reverbEffect: widget.reverbEffect,
          reverbSelectedIDNotifier: reverbSelectedIDNotifier,
          rootNavigator: widget.rootNavigator,
          popUpManager: widget.popUpManager,
        );
      },
      child: Container(
        width: containerSize.width,
        height: containerSize.height,
        decoration: BoxDecoration(
          color: widget.icon?.backgroundColor ?? Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: SizedBox.fromSize(
          size: sizeBoxSize,
          child: widget.icon?.icon ??
              ZegoLiveAudioRoomImage.asset(
                  ZegoLiveAudioRoomIconUrls.toolbarSoundEffect),
        ),
      ),
    );
  }
}
