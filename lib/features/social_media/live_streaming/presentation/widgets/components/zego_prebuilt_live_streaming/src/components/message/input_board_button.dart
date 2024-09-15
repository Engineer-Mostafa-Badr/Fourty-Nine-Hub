// Dart imports:

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Package imports:

// Project imports:
import '../../core/host_manager.dart';
import '../../inner_text.dart';
import '../../internal/defines.dart';
import 'enable_property.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/components/zego_uikit/zego_uikit.dart';
import 'input_board.dart';

/// @nodoc
class ZegoLiveStreamingInRoomMessageInputBoardButton extends StatefulWidget {
  final ZegoLiveStreamingHostManager hostManager;
  final ButtonIcon? enabledIcon;
  final ButtonIcon? disabledIcon;
  final Size? iconSize;
  final Size? buttonSize;
  final Function(int)? onSheetPopUp;
  final Function(int)? onSheetPop;
  final ZegoUIKitPrebuiltLiveStreamingInnerText translationText;

  const ZegoLiveStreamingInRoomMessageInputBoardButton({
    super.key,
    required this.hostManager,
    required this.translationText,
    this.enabledIcon,
    this.disabledIcon,
    this.iconSize,
    this.buttonSize,
    this.onSheetPopUp,
    this.onSheetPop,
  });

  @override
  State<ZegoLiveStreamingInRoomMessageInputBoardButton> createState() =>
      _ZegoLiveStreamingInRoomMessageInputBoardButtonState();
}

/// @nodoc
class _ZegoLiveStreamingInRoomMessageInputBoardButtonState
    extends State<ZegoLiveStreamingInRoomMessageInputBoardButton> {
  var isMessageInputting = false;
  final _enableProperty = ZegoLiveStreamingInRoomMessageEnableProperty();

  @override
  void initState() {
    super.initState();

    _enableProperty.notifier.addListener(onEnablePropertyUpdated);
  }

  @override
  void dispose() {
    super.dispose();

    _enableProperty.notifier.removeListener(onEnablePropertyUpdated);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _enableProperty.notifier,
      builder: (context, isChatEnabled, _) {
        var chatLocalEnabled = true;
        if (!widget.hostManager.isLocalHost) {
          chatLocalEnabled = isChatEnabled;
        }

        final buttonIcon =
            chatLocalEnabled ? widget.enabledIcon : widget.disabledIcon;
        buttonIcon?.icon ??= chatLocalEnabled
            ? ZegoLiveStreamingImage.asset(
                ZegoLiveStreamingIconUrls.im,
              )
            : ZegoLiveStreamingImage.asset(
                ZegoLiveStreamingIconUrls.imDisabled,
              );

        return ZegoTextIconButton(
          textStyle: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.w200, fontSize: 12),
          text: 'Chat',
          onPressed: chatLocalEnabled
              ? () {
                  final key = DateTime.now().millisecondsSinceEpoch;
                  widget.onSheetPopUp?.call(key);

                  isMessageInputting = true;
                  Navigator.of(
                    context,
                    rootNavigator: widget.hostManager.config.rootNavigator,
                  )
                      .push(
                    ZegoLiveStreamingInRoomMessageInputBoard(
                      translationText: widget.translationText,
                      payloadAttributes: widget
                          .hostManager.config.inRoomMessage.attributes
                          ?.call(),
                      rootNavigator: widget.hostManager.config.rootNavigator,
                    ),
                  )
                      .then(
                    (value) {
                      isMessageInputting = false;
                      widget.onSheetPop?.call(key);
                    },
                  );
                }
              : null,
          icon: buttonIcon,
          iconSize: widget.iconSize ?? Size(72.w, 72.h),
          buttonSize: widget.buttonSize ?? Size(96.w, 96.h),
        );
      },
    );
  }

  void onEnablePropertyUpdated() {
    if (!_enableProperty.value && isMessageInputting) {
      ZegoLoggerService.logInfo(
        'message inputting, close it',
        tag: 'live-streaming',
        subTag: 'message button',
      );
      Navigator.of(
        context,
        rootNavigator: widget.hostManager.config.rootNavigator,
      ).pop();
    }
  }
}
