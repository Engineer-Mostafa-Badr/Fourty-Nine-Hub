import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/data/models/chat_item_model.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/presentation/chat_cubit/chat_cubit.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

class ChatCard extends StatelessWidget {
  final bool isSecret;
  final ChatModel? chatItemModel;
  final ChatsCubit? chatsCubit;

  const ChatCard(
      {super.key, this.isSecret = false, this.chatItemModel, this.chatsCubit});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push(Routes.CHATROOM, extra: chatItemModel?.sId),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
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
                      : Stack(
                          children: [
                            Positioned.fill(
                              child: CircleAvatar(
                                minRadius: 50,
                                backgroundColor: Colors.black,
                                backgroundImage:
                                    NetworkImage(chatItemModel?.avatar ?? ''),
                              ),
                            ),

                            // Image.asset(
                            //   Assets.profileIcon,
                            // ),

                            Positioned(
                                bottom: 0,
                                right: 0,
                                child: CircleAvatar(
                                  radius: 5,
                                  backgroundColor: chatItemModel!.online!
                                      ? Colors.green
                                      : Colors.transparent,
                                ))
                          ],
                        ),
                ),
                const Sizer(),
                Flexible(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Label(
                          text:
                              isSecret ? 'Mxxx xxxl' : '${chatItemModel?.name}',
                          style: Styles.mediumText(fontWeight: FontWeight.bold),
                          maxLines: 1,
                        ),
                      ),
                      Row(
                        children: [
                          const SizedBox(
                            width: 10,
                          ),

                          chatItemModel!.typing!
                              ? const SizedBox()
                              : chatItemModel!.seen!
                                  ? const Icon(
                                      FontAwesomeIcons.checkDouble,
                                      color: AppColors.PRIMARY_COLOR,
                                      size: 14,
                                    )
                                  : const SizedBox(),

                          if (chatItemModel!.seen!)
                            const SizedBox(
                              width: 10,
                            ),

                          // last message or typing
                          Expanded(
                            child: Label(
                                text: chatItemModel!.typing!
                                    ? "Typing now..."
                                    : chatItemModel?.lastMessageText == null
                                        ? "No messages until now"
                                        : '${chatItemModel?.lastMessageText}',
                                style: Styles.mediumText(
                                  fontSize: 14,
                                  color: chatItemModel!.typing!
                                      ? AppColors.SPLASH_BLACK_COLOR
                                      : chatItemModel!.seen!
                                          ? AppColors.GREY_DARK_COLOR
                                          : AppColors.SPLASH_BLACK_COLOR,
                                )),
                          ),

                          const SizedBox(
                            height: 10,
                          ),
                          chatItemModel!.muted!
                              ? const Icon(
                                  Icons.volume_off,
                                  color: Colors.grey,
                                  size: 17,
                                )
                              : const SizedBox(),
                        ],
                      ),
                    ],
                  ),
                ),

                // number of reads
                chatItemModel?.unreadCount == 0
                    ? const SizedBox()
                    : CircleAvatar(
                        maxRadius: 15,
                        backgroundColor: AppColors.PRIMARY_COLOR,
                        child: Label(
                            text: '${chatItemModel?.unreadCount}',
                            style: Styles.mediumText(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
                      ),

                const SizedBox(
                  width: 8,
                ),
                Column(
                  children: [
                    Label(
                        text: '${chatItemModel?.formattedUpdatedAt}',
                        style: Styles.mediumText(color: Colors.grey)),
                    Row(
                      children: [
                        Label(
                            text: '${chatItemModel?.lastSeenCount}',
                            style: Styles.mediumText(color: Colors.grey)),
                        const SizedBox(
                          width: 10,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 2.0),
                          child: Icon(
                            FontAwesomeIcons.eye,
                            color: Colors.grey,
                            size: 14,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
