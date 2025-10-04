import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/utils/format_numbers.dart';
import '../../../../../helpers/date_time_helper.dart';
import '../../../../../helpers/manage_vibration.dart';
import '../../../../../res/assets/assets.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../service_locator/service_locator.dart';
import '../../../../social_media/chat/chat_view/presentation/widgets/chat_stories.dart';
import '../../../../social_media/social_posts/presentation/widgets/facebook_widgets/build_gradient_border.dart';
import '../../../../social_media/tinder/data/shared/shared.dart';
import '../../../Domain/Entities/conversation_entity.dart';
import '../../Controllers/cubits/conversation_states.dart';
import '../../Controllers/cubits/conversations_cubit.dart';

class DeletedChatCard extends StatefulWidget {
  final ConversationEntity? chat;

  const DeletedChatCard({
    super.key,
    required this.chat,
  });

  @override
  State<DeletedChatCard> createState() => _DeletedChatCardState();
}

class _DeletedChatCardState extends State<DeletedChatCard> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConversationsCubit, ConversationsState>(
        builder: (context, state) {
          return InkWell(
            splashColor: context.isDarkMode
                ? Colors.white
                : AppColors.PRIMARY_COLOR.withValues(alpha: 0.05),
            // Ripple effect color
            highlightColor: context.isDarkMode
                ? AppColors.QUANTITY_COLOR
                : AppColors.LIGHT_GRAY_COLOR.withValues(alpha: 0.2),
            onTap: () {
              ManageVibration.vibrate();
              if (serviceLocator<ConversationsCubit>().selectedSocialConversation.isEmpty) {
                // context.read<ChatsCubit>().selectChat = widget.chat!;
                // context.push(Routes.CHATROOM, extra: widget.chatsCubit);
              } else {
                setState(() {
                  if (!widget.chat!.isSelected) {
                    serviceLocator<ConversationsCubit>()
                        .addConversationToSelectedSocialConversations(conversation: widget.chat!);
                  } else {
                    serviceLocator<ConversationsCubit>()
                        .removeConversationFromSelectedSocialConversations(conversation: widget.chat!);
                  }
                });
              }
            },
            onLongPress: () {
              ManageVibration.vibrate();
              setState(() {
                if (!widget.chat!.isSelected) {
                  serviceLocator<ConversationsCubit>()
                      .addConversationToSelectedSocialConversations(conversation: widget.chat!);
                } else {
                  serviceLocator<ConversationsCubit>()
                      .removeConversationFromSelectedSocialConversations(conversation: widget.chat!);
                }
              });
            },
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color:
                  (widget.chat?.isSelected ?? false)
                      ? const Color(0xffFFD5CC)
                      :
                  context.isDarkMode
                      ? AppColors.QUANTITY_COLOR
                      : AppColors.BACKGROUND_COLOR,
                  // borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _userImage(),
                          const Sizer(width: 24),
                          _nameAndLastMessage(),
                          // _lastMessageTime(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
    );
  }

  _userImage() {

    return Center(
      child: GestureDetector(
        onTap: () {
          ManageVibration.vibrate();
        },
        child: Stack(
          children: [
            GradientProfileBorder(
                imageUrl: widget.chat?.profile?.profilePictureUrl ?? "",
                imageWidth: 46,
                fullWidth: 54,
                isViewed: (serviceLocator<ConversationsCubit>()
                    .socialConversations
                    .indexWhere((e) =>
                e.conversationId ==
                    widget.chat?.conversationId)) %
                    2 !=
                    0,
                segments: serviceLocator<ConversationsCubit>()
                    .socialConversations
                    .indexWhere((e) =>
                e.conversationId == widget.chat?.conversationId) +
                    1,
                firstChar: widget.chat?.profile?.firstName?[0].toUpperCase() ?? 'A'),

            if ((widget.chat?.isSelected ?? false))
              const Positioned(
                bottom: 0,
                right: 0,
                child: CircleAvatar(
                  backgroundColor: Color(0xffFFD5CC),
                  radius: 10,
                  child: CircleAvatar(
                    radius: 8,
                    backgroundColor: AppColors.PRIMARY_COLOR_DARK,
                    child: Icon(
                      Icons.check,
                      color: AppColors.BACKGROUND_COLOR,
                      size: 14,
                      weight: 20,
                    ),
                  ),
                ),
              ),
            if (widget.chat?.isOnline == true && (!(widget.chat?.isSelected ?? true) == true))
              const Positioned(
                bottom: 2,
                right: 2,
                child: CircleAvatar(
                  radius: 7,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 5,
                    backgroundColor: Colors.green,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  _nameAndLastMessage() {
    return Flexible(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Flexible(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 140),
                            child: Label(
                              text: ("${widget.chat?.profile?.firstName?.trim() ?? ""} ${(widget.chat?.profile?.lastName?.trim()) ?? ""}") ?? "Ahmed Nasr",
                              // text: "Ahmed Nasr Mohamed Fahmey",
                              overflow: TextOverflow.ellipsis,
                              style: Styles.mediumText(
                                fontWeight: FontWeight.bold,
                                color: context.isDarkMode ? Colors.white : Colors.black,
                              ),
                              maxLines: 1,
                            ),
                          ),
                          const SizedBox(width: 2),
                          if (widget.chat?.profile?.isAccountVerified ?? false)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 9.0),
                              child: Icon(
                                Icons.verified,
                                color: Colors.blue,
                                size: 12,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
