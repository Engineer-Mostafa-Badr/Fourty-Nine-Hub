// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
// Project imports:
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/components/zego_uikit/zego_uikit.dart';

import '../../../../../../../../../../res/style/app_colors.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

class ZegoInRoomMessageInput extends StatefulWidget {
  const ZegoInRoomMessageInput({
    super.key,
    this.placeHolder = 'Say something...',
    this.payloadAttributes,
    this.backgroundColor,
    this.inputBackgroundColor,
    this.textColor,
    this.textHintColor,
    this.cursorColor,
    this.buttonColor,
    this.borderRadius,
    this.enabled = true,
    this.autofocus = true,
    this.onSubmit,
    this.valueNotifier,
    this.focusNotifier,
  });

  final String placeHolder;
  final Map<String, String>? payloadAttributes;
  final Color? backgroundColor;
  final Color? inputBackgroundColor;
  final Color? textColor;
  final Color? textHintColor;
  final Color? cursorColor;
  final Color? buttonColor;
  final double? borderRadius;
  final bool enabled;
  final bool autofocus;
  final VoidCallback? onSubmit;
  final ValueNotifier<String>? valueNotifier;
  final ValueNotifier<bool>? focusNotifier;

  @override
  State<ZegoInRoomMessageInput> createState() => _ZegoInRoomMessageInputState();
}

class _ZegoInRoomMessageInputState extends State<ZegoInRoomMessageInput> {
  final TextEditingController textController = TextEditingController();
  ValueNotifier<bool> isEmptyNotifier = ValueNotifier(true);
  var focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    focusNode.addListener(onFocusChange);

    if (widget.valueNotifier != null) {
      textController.text = widget.valueNotifier!.value;

      isEmptyNotifier.value = textController.text.isEmpty;
    }
  }

  @override
  void dispose() {
    super.dispose();

    focusNode
      ..removeListener(onFocusChange)
      ..dispose();
  }

  void onFocusChange() {
    widget.focusNotifier?.value = focusNode.hasFocus;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: context.isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.zR, vertical: 15.zR),
        color:
            widget.backgroundColor ?? const Color(0xff222222).withOpacity(0.1),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: 90.zR,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 10.zR),
              messageInput(),
              SizedBox(width: 10.zR),
              sendButton(),
              SizedBox(width: 10.zR),
            ],
          ),
        ),
      ),
    );
  }

  Widget messageInput() {
    final messageSendBgColor = widget.buttonColor ?? Colors.white;
    final messageSendCursorColor =
        widget.cursorColor ?? AppColors.SECONDARY_COLOR;
    final messageSendHintStyle = TextStyle(
      color: widget.textHintColor ?? const Color(0xffa4a4a4),
      fontSize: 28.zR,
      fontWeight: FontWeight.w400,
    );
    final messageSendInputStyle = TextStyle(
      color: widget.textColor ?? Colors.black,
      fontSize: 28.zR,
      decoration: TextDecoration.none,
      decorationThickness: 0,
      fontWeight: FontWeight.w400,
    );

    return Expanded(
      child: Container(
        height: 78.zR,
        decoration: BoxDecoration(
          color: widget.inputBackgroundColor ?? messageSendBgColor,
          borderRadius: BorderRadius.circular(16.zR),
        ),
        child: TextField(
          enabled: widget.enabled,
          keyboardType: TextInputType.multiline,
          minLines: 1,
          maxLines: null,
          textAlign: TextAlign.center,
          autofocus: widget.autofocus,
          focusNode: focusNode,
          inputFormatters: <TextInputFormatter>[
            LengthLimitingTextInputFormatter(400)
          ],
          controller: textController,
          onChanged: (String inputMessage) {
            widget.valueNotifier?.value = inputMessage;

            final valueIsEmpty = inputMessage.isEmpty;
            if (valueIsEmpty != isEmptyNotifier.value) {
              isEmptyNotifier.value = valueIsEmpty;
            }
          },
          textInputAction: TextInputAction.send,
          onSubmitted: (message) => send(),
          cursorColor: messageSendCursorColor,
          cursorHeight: 30.zR,
          cursorWidth: 3.zR,
          style: messageSendInputStyle,
          decoration: InputDecoration(
            filled: false,
            fillColor: Colors.purple,
            hintText: widget.placeHolder,
            hintStyle: messageSendHintStyle,
            contentPadding: EdgeInsets.only(
              left: 20.zR,
              top: -5.zR,
              right: 20.zR,
              bottom: 15.zR,
            ),
            // isDense: true,
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget sendButton() {
    return ValueListenableBuilder<bool>(
      valueListenable: isEmptyNotifier,
      builder: (context, bool isEmpty, Widget? child) {
        return ZegoTextIconButton(
          unclickableBackgroundColor: Colors.white,
          onPressed: () {
      ManageVibration.vibrate();
            if (!isEmpty) send();
          },
          icon: ButtonIcon(
            icon: isEmpty
                ? UIKitImage.asset(StyleIconUrls.iconSendDisable)
                : UIKitImage.asset(StyleIconUrls.iconSend),
            backgroundColor: widget.buttonColor,
          ),
          iconSize: Size(68.zR, 68.zR),
          buttonSize: Size(72.zR, 72.zR),
        );
      },
    );
  }

  void send() {
    if (textController.text.isEmpty) {
      ZegoLoggerService.logInfo(
        'message is empty',
        tag: 'uikit-component',
        subTag: 'in room message input',
      );
      return;
    }

    if (widget.payloadAttributes?.isEmpty ?? true) {
      ZegoUIKit().sendInRoomMessage(textController.text);
    } else {
      ZegoUIKit().sendInRoomMessage(
        ZegoInRoomMessage.jsonBody(
          message: textController.text,
          attributes: widget.payloadAttributes!,
        ),
      );
    }
    textController.clear();

    widget.valueNotifier?.value = '';

    widget.onSubmit?.call();
  }
}