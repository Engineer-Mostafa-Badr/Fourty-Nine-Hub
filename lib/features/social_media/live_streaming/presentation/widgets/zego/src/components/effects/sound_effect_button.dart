// Flutter imports:
import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/src/components/effects/sound_effect_sheet.dart';

// Package imports:
import 'package:zego_uikit/zego_uikit.dart';

import '../../config.dart';
import '../../inner_text.dart';
import '../../internal/defines.dart';

// Project imports:

/// @nodoc
class ZegoLiveStreamingSoundEffectButton extends StatefulWidget {
  final List<VoiceChangerType> voiceChangeEffect;
  final List<ReverbType> reverbEffect;

  final Size? iconSize;
  final Size? buttonSize;
  final ButtonIcon? icon;
  final ZegoUIKitPrebuiltLiveStreamingInnerText translationText;
  final bool rootNavigator;

  final ZegoLiveStreamingEffectConfig effectConfig;

  const ZegoLiveStreamingSoundEffectButton({
    super.key,
    required this.translationText,
    required this.rootNavigator,
    required this.voiceChangeEffect,
    required this.reverbEffect,
    required this.effectConfig,
    this.iconSize,
    this.buttonSize,
    this.icon,
  });

  @override
  State<ZegoLiveStreamingSoundEffectButton> createState() =>
      _ZegoLiveStreamingSoundEffectButtonState();
}

/// @nodoc
class _ZegoLiveStreamingSoundEffectButtonState
    extends State<ZegoLiveStreamingSoundEffectButton> {
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
          translationText: widget.translationText,
          rootNavigator: widget.rootNavigator,
          voiceChangeEffect: widget.voiceChangeEffect,
          voiceChangerSelectedIDNotifier: voiceChangerSelectedIDNotifier,
          reverbEffect: widget.reverbEffect,
          reverbSelectedIDNotifier: reverbSelectedIDNotifier,
          config: widget.effectConfig,
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
              ZegoLiveStreamingImage.asset(
                ZegoLiveStreamingIconUrls.toolbarSoundEffect,
              ),
        ),
      ),
    );
  }
}
