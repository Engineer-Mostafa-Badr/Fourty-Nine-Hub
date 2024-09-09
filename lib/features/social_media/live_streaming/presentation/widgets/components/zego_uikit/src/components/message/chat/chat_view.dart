// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/components/zego_uikit/zego_uikit.dart';

import 'chat_view_item.dart';


class ZegoInRoomChatView extends StatefulWidget {
  final ZegoAvatarBuilder? avatarBuilder;
  final ZegoInRoomMessageItemBuilder? itemBuilder;
  final ScrollController? scrollController;

  const ZegoInRoomChatView({
    super.key,
    this.avatarBuilder,
    this.itemBuilder,
    this.scrollController,
  });

  @override
  State<ZegoInRoomChatView> createState() => _ZegoInRoomChatViewState();
}

class _ZegoInRoomChatViewState extends State<ZegoInRoomChatView> {
  @override
  Widget build(BuildContext context) {
    return ZegoInRoomMessageView(
      historyMessages: ZegoUIKit().getInRoomMessages(),
      stream: ZegoUIKit().getInRoomMessageListStream(),
      scrollController: widget.scrollController,
      itemBuilder: widget.itemBuilder ??
          (BuildContext context, ZegoInRoomMessage message, _) {
            return Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: 0.0.zR, vertical: 20.0.zR),
              child: ZegoInRoomChatViewItem(
                avatarBuilder: widget.avatarBuilder,
                message: message,
              ),
            );
          },
    );
  }
}
