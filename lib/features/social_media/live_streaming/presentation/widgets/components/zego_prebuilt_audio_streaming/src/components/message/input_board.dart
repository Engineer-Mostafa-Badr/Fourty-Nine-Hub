// Flutter imports:
import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';

// Package imports:

// Project imports:
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/components/zego_prebuilt_audio_streaming/zego_uikit_prebuilt_live_audio_room.dart';

import '../../../../../../../../../../core/localization/locale_keys.g.dart';

/// @nodoc
class ZegoLiveAudioRoomInRoomMessageInputBoard extends ModalRoute<String> {
  ZegoLiveAudioRoomInRoomMessageInputBoard({
    required this.innerText,
    this.rootNavigator = false,
  }) : super();

  final ZegoUIKitPrebuiltLiveAudioRoomInnerText innerText;
  final bool rootNavigator;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 200);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => true;

  @override
  Color get barrierColor => ZegoUIKitDefaultTheme.viewBarrierColor;

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            child: GestureDetector(
              onTap: () => Navigator.of(
                context,
                rootNavigator: rootNavigator,
              ).pop(),
              child: Container(color: Colors.transparent),
            ),
          ),
          ZegoInRoomMessageInput(
            placeHolder: LocaleKeys.saySomthing.localize,
            backgroundColor: Colors.white,
            // inputBackgroundColor: const Color(0xffF7F7F8),
            // textColor: Colors.white,
            // textHintColor: const Color(0xff1B1B1B).withOpacity(0.5),
            // buttonColor: Colors.white,
            onSubmit: () {
              Navigator.of(
                context,
                rootNavigator: rootNavigator,
              ).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: animation,
        curve: Curves.easeOut,
      ),
      child: child,
    );
  }
}
