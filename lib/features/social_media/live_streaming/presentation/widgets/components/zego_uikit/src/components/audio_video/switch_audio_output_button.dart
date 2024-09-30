// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/components/zego_uikit/zego_uikit.dart';

/// button used to switch audio output route between speaker or system device
class ZegoSwitchAudioOutputButton extends StatefulWidget {
  const ZegoSwitchAudioOutputButton({
    super.key,
    this.speakerIcon,
    this.headphoneIcon,
    this.bluetoothIcon,
    this.onPressed,
    this.defaultUseSpeaker = false,
    this.iconSize,
    this.buttonSize,
  });

  final ButtonIcon? speakerIcon;
  final ButtonIcon? headphoneIcon;
  final ButtonIcon? bluetoothIcon;

  ///  You can do what you want after pressed.
  final void Function(bool isON)? onPressed;

  /// whether to open speaker by default
  final bool defaultUseSpeaker;

  /// the size of button's icon
  final Size? iconSize;

  /// the size of button
  final Size? buttonSize;

  @override
  State<ZegoSwitchAudioOutputButton> createState() =>
      _ZegoSwitchAudioOutputButtonState();
}

class _ZegoSwitchAudioOutputButtonState
    extends State<ZegoSwitchAudioOutputButton> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ZegoUIKitAudioRoute>(
      /// listen local audio output route changes
      valueListenable: ZegoUIKit()
          .getAudioOutputDeviceNotifier(ZegoUIKit().getLocalUser().id),
      builder: (context, audioRoute, _) {
        /// update icon/background if route changed
        return getAudioRouteButtonByRoute(audioRoute);
      },
    );
  }

  Widget getAudioRouteButtonByRoute(ZegoUIKitAudioRoute audioRoute) {
    Widget icon = UIKitImage.asset(StyleIconUrls.iconS1ControlBarSpeakerOff,
        width: 35, height: 35);
    var backgroundColor = controlBarButtonBackgroundColor;

    /// get the new icon and background color
    if (ZegoUIKitAudioRoute.bluetooth == audioRoute) {
      /// always open
      icon = widget.bluetoothIcon?.icon ??
          UIKitImage.asset(StyleIconUrls.iconS1ControlBarSpeakerBluetooth,
              width: 35, height: 35);
      backgroundColor = widget.bluetoothIcon?.backgroundColor ??
          controlBarButtonBackgroundColor;
    } else if (ZegoUIKitAudioRoute.headphone == audioRoute) {
      /// always display speaker closed
      icon = widget.headphoneIcon?.icon ??
          UIKitImage.asset(StyleIconUrls.iconS1ControlBarSpeakerOff,
              width: 35, height: 35);
      backgroundColor = widget.headphoneIcon?.backgroundColor ??
          controlBarButtonBackgroundColor;
    } else if (ZegoUIKitAudioRoute.speaker == audioRoute) {
      icon = widget.speakerIcon?.icon ??
          UIKitImage.asset(StyleIconUrls.iconS1ControlBarSpeakerNormal,
              width: 35, height: 35);
      backgroundColor = widget.speakerIcon?.backgroundColor ??
          controlBarButtonCheckedBackgroundColor;
    } else {
      icon = widget.headphoneIcon?.icon ??
          UIKitImage.asset(StyleIconUrls.iconS1ControlBarSpeakerOff,
              width: 35, height: 35);
      backgroundColor = widget.headphoneIcon?.backgroundColor ??
          controlBarButtonBackgroundColor;
    }

    final containerSize = widget.buttonSize ?? Size(96.zR, 96.zR);
    final sizeBoxSize = widget.iconSize ?? Size(56.zR, 56.zR);

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        // width: containerSize.width,
        // height: containerSize.height,
        decoration: const BoxDecoration(
          // color: backgroundColor,
          shape: BoxShape.circle,
        ),
        child: SizedBox.fromSize(
          size: sizeBoxSize,
          child: icon,
        ),
      ),
    );
  }

  void onPressed() {
    final audioRoute = ZegoUIKit()
        .getAudioOutputDeviceNotifier(ZegoUIKit().getLocalUser().id)
        .value;
    if (ZegoUIKitAudioRoute.headphone == audioRoute ||
        ZegoUIKitAudioRoute.bluetooth == audioRoute) {
      ///  not support close
      return;
    }

    final targetState = audioRoute != ZegoUIKitAudioRoute.speaker;

    ZegoUIKit().setAudioOutputToSpeaker(targetState);

    if (widget.onPressed != null) {
      widget.onPressed!(targetState);
    }
  }
}
