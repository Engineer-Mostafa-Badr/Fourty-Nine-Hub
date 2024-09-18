// Flutter imports:
import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';

// Package imports:

// Project imports:
import '../../../../../../../../../../core/localization/locale_keys.g.dart';
import '../../inner_text.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/components/zego_uikit/zego_uikit.dart';

/// @nodoc
class ZegoLiveStreamingInRoomMessageInputBoard extends ModalRoute<String> {
  ZegoLiveStreamingInRoomMessageInputBoard({
    required this.translationText,
    required this.rootNavigator,
    this.payloadAttributes,
  }) : super();

  final ZegoUIKitPrebuiltLiveStreamingInnerText translationText;
  final bool rootNavigator;
  final Map<String, String>? payloadAttributes;

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
            payloadAttributes: payloadAttributes,
            // to change text field text color
            textColor: Colors.black,
            textHintColor: Colors.grey,
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
