// ignore_for_file: public_member_api_docs, sort_constructors_first
// Flutter imports:
import 'package:flutter/material.dart';

import '../../../../components/defines.dart';
import '../../../../components/widgets/text_icon_button.dart';
import '../../../../services/uikit_service.dart';


// Project imports:

/// @nodoc
class ZegoAcceptInvitationButton extends StatefulWidget {
  const ZegoAcceptInvitationButton({
    super.key,
    this.isAdvancedMode = false,
    required this.inviterID,
    this.targetInvitationID,
    this.customData = '',
    this.text,
    this.textStyle,
    required this.icon,
    this.iconSize,
    this.buttonSize,
    this.iconTextSpacing,
    this.verticalLayout = true,
    this.clickableTextColor = Colors.black,
    this.unclickableTextColor = Colors.black,
    this.clickableBackgroundColor = Colors.transparent,
    this.unclickableBackgroundColor = Colors.transparent,
    this.onPressed,
  });
  final bool isAdvancedMode;

  final String inviterID;
  final String? targetInvitationID;
  final String customData;

  final String? text;
  final TextStyle? textStyle;
  final ButtonIcon icon;

  final Size? iconSize;
  final Size? buttonSize;
  final double? iconTextSpacing;
  final bool verticalLayout;

  final Color? clickableTextColor;
  final Color? unclickableTextColor;
  final Color? clickableBackgroundColor;
  final Color? unclickableBackgroundColor;

  ///  You can do what you want after pressed.
  final void Function(String code, String message)? onPressed;

  @override
  State<ZegoAcceptInvitationButton> createState() =>
      _ZegoAcceptInvitationButtonState();
}

/// @nodoc
class _ZegoAcceptInvitationButtonState
    extends State<ZegoAcceptInvitationButton> {
  @override
  Widget build(BuildContext context) {
    return ZegoTextIconButton(
      onPressed: onPressed,
      text: widget.text,
      textStyle: widget.textStyle,
      icon: widget.icon,
      iconTextSpacing: widget.iconTextSpacing,
      iconSize: widget.iconSize,
      buttonSize: widget.buttonSize,
      verticalLayout: widget.verticalLayout,
      clickableTextColor: widget.clickableTextColor ?? Colors.white,
      unclickableTextColor: widget.unclickableTextColor,
      clickableBackgroundColor: widget.clickableBackgroundColor,
      unclickableBackgroundColor: widget.unclickableBackgroundColor,
    );
  }

  Future<void> onPressed() async {
    final result = widget.isAdvancedMode
        ? await ZegoUIKit().getSignalingPlugin().acceptAdvanceInvitation(
              inviterID: widget.inviterID,
              data: widget.customData,
              invitationID: widget.targetInvitationID,
            )
        : await ZegoUIKit().getSignalingPlugin().acceptInvitation(
              inviterID: widget.inviterID,
              data: widget.customData,
              targetInvitationID: widget.targetInvitationID,
            );

    widget.onPressed?.call(
      result.error?.code ?? '',
      result.error?.message ?? '',
    );
  }
}
