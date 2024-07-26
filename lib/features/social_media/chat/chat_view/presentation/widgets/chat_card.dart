import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/data/models/chat_item_model.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

class ChatCard extends StatelessWidget {
  final bool isSecret;
  final ChatItemModel? chatItemModel;

  const ChatCard({super.key, this.isSecret = false, this.chatItemModel});

  @override
  Widget build(BuildContext context) {
    // ChatsCubit chatCubit = context.read<ChatsCubit>();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () => context.push(Routes.CHATROOM, extra: chatItemModel?.sId),
        child: Row(
          children: [
            SizedBox(
              height: kToolbarHeight * .7,
              width: kToolbarHeight * .7,
              child: isSecret
                  ? const CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(
                        FontAwesomeIcons.ghost,
                        color: Colors.grey,
                      ))
                  : const Stack(
                      children: [
                        Positioned.fill(
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            backgroundImage:
                                NetworkImage(UIConst.profilePlaceHolder),
                          ),
                        ),
                        Positioned(
                            bottom: 0,
                            right: 0,
                            child: CircleAvatar(
                              radius: 5,
                              backgroundColor: Colors.green,
                            ))
                      ],
                    ),
            ),
            const Sizer(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Label(
                      text: isSecret
                          ? 'Mxxx xxxl'
                          : '${chatItemModel?.user?.name}',
                      style: Styles.mediumText(fontWeight: FontWeight.bold)),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Row(
                      children: [
                        chatItemModel!.seen!
                            ? const Icon(
                                FontAwesomeIcons.checkDouble,
                                color: Colors.blue,
                                size: 10,
                              )
                            : const SizedBox(),
                        Expanded(
                          child: Label(
                              text: chatItemModel?.lastMessageText == null ?
                                  "No messages until now":
                              '${chatItemModel?.lastMessageText}',
                              style: Styles.mediumText(
                                  color: chatItemModel!.seen!
                                      ? Colors.grey
                                      : Colors.black)),
                        ),
                        chatItemModel!.muted!
                            ? const Icon(
                                Icons.volume_off,
                                color: Colors.grey,
                                size: 14,
                              )
                            : const SizedBox(),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Column(
              children: [
                Label(
                    text: '5:57 PM',
                    style: Styles.mediumText(color: Colors.grey)),
                Row(
                  children: [
                    Label(
                        text: '${chatItemModel?.lastSeenCount}',
                        style: Styles.smallText(color: Colors.grey)),
                    const Sizer(),
                    const Icon(
                      FontAwesomeIcons.eye,
                      color: Colors.grey,
                      size: 10,
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
