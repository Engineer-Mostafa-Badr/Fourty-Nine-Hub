import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/data/models/seen_history_model.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/controllers/chat_room_cubit/chat_room_cubit.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/data/models/chat_model.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/entities/chat_entity.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/presentation/chat_cubit/chats_cubit.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

class ChatCard extends StatefulWidget {
  final bool isSecret;
  final ChatEntity? chat;
  final ChatsCubit? chatsCubit;

  const ChatCard(
      {super.key, this.isSecret = false, this.chat, this.chatsCubit});

  @override
  State<ChatCard> createState() => _ChatCardState();
}

class _ChatCardState extends State<ChatCard> {
  List<SeenHistoryModel> seenHistoryList = [];

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.read<ChatsCubit>().selectChat = widget.chat!;
        context.push(Routes.CHATROOM, extra: widget.chatsCubit);
      },
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
                  child: widget.isSecret
                      ? const CircleAvatar(
                          backgroundColor: Colors.red,
                          child: Icon(
                            FontAwesomeIcons.ghost,
                            color: Colors.grey,
                          ))
                      : Stack(
                          children: [
                            // Positioned.fill(
                            //   child: CircleAvatar(
                            //     backgroundColor: Colors.black,
                            //     backgroundImage:
                            //         NetworkImage(UIConst.profilePlaceHolder),
                            //   ),
                            // ),

                            Image.asset(
                              Assets.profileIcon,
                              color: Theme.of(context).primaryColor,
                            ),

                            Positioned(
                                bottom: 0,
                                right: 0,
                                child: CircleAvatar(
                                  radius: 5,
                                  backgroundColor: widget.chat!.online
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
                          text: widget.isSecret
                              ? 'Mxxx xxxl'
                              : '${widget.chat?.name}',
                          style: Styles.mediumText(fontWeight: FontWeight.bold),
                          maxLines: 1,
                        ),
                      ),
                      Row(
                        children: [
                          const SizedBox(
                            width: 10,
                          ),

                          widget.chat!.typing
                              ? const SizedBox()
                              : widget.chat!.seen
                                  ? const Icon(
                                      FontAwesomeIcons.checkDouble,
                                      color: AppColors.GREY_DARK_COLOR,
                                      size: 14,
                                    )
                                  : const SizedBox(),

                          if (widget.chat!.seen)
                            const SizedBox(
                              width: 10,
                            ),

                          // last message or typing
                          Expanded(
                            child: Label(
                                text: widget.chat!.typing
                                    ? "Typing now..."
                                    : widget.chat?.lastMessageText == null
                                        ? "No messages until now"
                                        : '${widget.chat?.lastMessageText}',
                                style: Styles.mediumText(
                                  fontSize: 14,
                                  color: widget.chat!.typing
                                      ? AppColors.SPLASH_BLACK_COLOR
                                      : AppColors.DARK_GRAY_COLOR,
                                )),
                          ),

                          const SizedBox(
                            height: 10,
                          ),
                          widget.chat!.muted
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
                widget.chat?.unreadCount == 0
                    ? const SizedBox()
                    : CircleAvatar(
                        maxRadius: 15,
                        backgroundColor: AppColors.PRIMARY_COLOR,
                        child: Label(
                            text: '${widget.chat?.unreadCount}',
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
                        text: '${widget.chat?.formattedUpdatedAt}',
                        style: Styles.mediumText(color: Colors.grey)),
                    widget.chat?.lastSeenCount == null
                        ? const SizedBox()
                        : GestureDetector(
                            onTap: () {},
                            child: Row(
                              children: [
                                Label(
                                    text: '${widget.chat?.lastSeenCount}',
                                    style:
                                        Styles.mediumText(color: Colors.grey)),
                                const SizedBox(
                                  width: 10,
                                ),
                                const Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 2.0),
                                  child: Icon(
                                    FontAwesomeIcons.eye,
                                    color: Colors.grey,
                                    size: 14,
                                  ),
                                ),
                              ],
                            ),
                          )
                  ],
                ),
              ],
            ),
          ),
          Container(
            height: 0.4,
            width: MediaQuery.of(context).size.width,
            color: AppColors.GREY_DARK_COLOR,
          ),
        ],
      ),
    );
  }
}
