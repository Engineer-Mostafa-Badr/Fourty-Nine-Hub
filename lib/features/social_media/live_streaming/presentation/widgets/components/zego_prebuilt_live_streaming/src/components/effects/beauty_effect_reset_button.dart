// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/components/zego_uikit/zego_uikit.dart';

import '../../internal/defines.dart';

// Project imports:

/// @nodoc
class ZegoLiveStreamingBeautyEffectResetButton extends StatefulWidget {
  final ButtonIcon? icon;
  final Size? iconSize;
  final Size? buttonSize;
  final VoidCallback? onPressed;

  // ignore: use_super_parameters
  const ZegoLiveStreamingBeautyEffectResetButton({
    Key? key,
    this.icon,
    this.iconSize,
    this.buttonSize,
    this.onPressed,
  }) : super(key: key);

  @override
  State<ZegoLiveStreamingBeautyEffectResetButton> createState() =>
      _ZegoLiveStreamingBeautyEffectResetButtonState();
}

/// @nodoc
class _ZegoLiveStreamingBeautyEffectResetButtonState
    extends State<ZegoLiveStreamingBeautyEffectResetButton> {
  @override
  Widget build(BuildContext context) {
    return ZegoTextIconButton(
      onPressed: () {
        ZegoUIKit().resetBeautyEffect();

        widget.onPressed?.call();
      },
      icon: ButtonIcon(
        icon: widget.icon?.icon ??
            ZegoLiveStreamingImage.asset(
              ZegoLiveStreamingIconUrls.effectReset,
            ),
        backgroundColor: widget.icon?.backgroundColor,
      ),
      iconSize: widget.iconSize ?? Size(38.zR, 38.zR),
      buttonSize: widget.buttonSize ?? Size(40.zR, 40.zR),
    );
  }
}
