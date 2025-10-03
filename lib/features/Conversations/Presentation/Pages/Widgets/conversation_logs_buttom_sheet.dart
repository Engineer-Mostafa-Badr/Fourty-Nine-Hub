import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/Conversations/Domain/Entities/conversation_entity.dart';
import 'package:fourtyninehub/features/Conversations/Presentation/Controllers/cubits/conversations_cubit.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../service_locator/service_locator.dart';
import '../../../../social_media/social_posts/presentation/widgets/facebook_widgets/build_gradient_border.dart';
import '../../Controllers/cubits/conversation_states.dart';
import 'chat_card.dart';

Future<void> showConversationLogsBottomSheet(
    BuildContext context, ConversationEntity conversation) async {
  showModalBottomSheet(
    context: context,
    isScrollControlled: false,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (_) {
      return BlocProvider.value(
        value: serviceLocator<ConversationsCubit>()
          ..loadInitialConversationLogs(
              conversationId: conversation.conversationId),
        child: Builder(
          builder: (context) {
            return _ConversationLogsBottomSheetBody(conversation: conversation);
          }
        ),
      );
    },
  );
}

class _ConversationLogsBottomSheetBody extends StatefulWidget {
  const _ConversationLogsBottomSheetBody({required this.conversation});
  final ConversationEntity conversation;

  @override
  State<_ConversationLogsBottomSheetBody> createState() =>
      _ConversationLogsBottomSheetBodyState();
}

class _ConversationLogsBottomSheetBodyState
    extends State<_ConversationLogsBottomSheetBody> {
  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController()
      ..addListener(() {
        if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200) {
          context.read<ConversationsCubit>().getConversationLogs(
              conversationId: widget.conversation.conversationId);
        }
      });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConversationsCubit, ConversationsState>(
      builder: (context, state) {
        if (state.status == ConversationsStates.loading &&
            context.read<ConversationsCubit>().conversationLogs.isEmpty) {
          return GlowingOverscrollIndicator(
            axisDirection: AxisDirection.down,
            color: AppColors.SECONDARY_COLOR,
            child: ListView.separated(
                itemCount: 15,
                separatorBuilder: (context, index) => const SizedBox(),
                itemBuilder: (context, index) {
                  return Padding(
                    padding:
                        EdgeInsets.only(bottom: 16.h, left: 16.w, right: 16.w),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Shimmer.fromColors(
                            baseColor: context.isDarkMode
                                ? Colors.grey[800]!
                                : Colors.grey[300]!,
                            highlightColor: context.isDarkMode
                                ? Colors.grey[700]!
                                : Colors.grey[100]!,
                            child: ChatCard(
                              chat: null,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
          );
        }
        if (state.status != ConversationsStates.loading &&
            context.read<ConversationsCubit>().conversationLogs.isEmpty) {
          return Center(
              child: Label(
            text: context.isArabic ? "لا يوجد مشاهدات" : "No views",
            style: Styles.headerText(
                color: AppColors.PRIMARY_COLOR,
                fontWeight: FontWeight.w500,
                fontSize: 34),
          ));
        }

        return GlowingOverscrollIndicator(
          axisDirection: AxisDirection.down,
          color: AppColors.SECONDARY_COLOR,
          child: Column(
            children: [
              Expanded(
                child: ListView.separated(
                  shrinkWrap: false,
                  controller: scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  // Enable scrolling
                  itemBuilder: (context, index) {
                    if (index ==
                        context
                            .read<ConversationsCubit>()
                            .conversationLogs
                            .length) {
                      return SizedBox(
                        height: 16.h,
                      );
                    }
                    if (index >=
                        context
                                .read<ConversationsCubit>()
                                .conversationLogs
                                .length +
                            1) {
                      return Padding(
                        padding: EdgeInsets.only(
                            bottom: 16.h, left: 16.w, right: 16.w),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Shimmer.fromColors(
                                baseColor: context.isDarkMode
                                    ? Colors.grey[800]!
                                    : Colors.grey[300]!,
                                highlightColor: context.isDarkMode
                                    ? Colors.grey[700]!
                                    : Colors.grey[100]!,
                                child: ChatCard(
                                  chat: null,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    return Slidable(
                      key: ValueKey(index),
                      closeOnScroll: false,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 16),
                          Text(
                            context.isArabic
                                ? "سجل مشاهدات الدردشة"
                                : 'Chat Views History',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: context.isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Flexible(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: context
                                  .read<ConversationsCubit>()
                                  .conversationLogs
                                  .length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                                  child: Card(
                                    elevation: 3,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: ListTile(
                                      leading: ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: CircleAvatar(
                                          radius: 25,
                                          child: GradientProfileBorder(
                                              imageUrl: widget
                                                      .conversation
                                                      .profile
                                                      ?.profilePictureUrl ??
                                                  "",
                                              imageWidth: 46,
                                              fullWidth: 54,
                                              isViewed: index % 2 != 0,
                                              segments: index + 1,
                                              firstChar: widget.conversation
                                                      .profile?.firstName?[0]
                                                      .toUpperCase() ??
                                                  'A'),
                                        ),
                                      ),
                                      title: Row(
                                        children: [
                                          Text(
                                            ("${widget.conversation.profile?.firstName?.trim() ?? ""} ${(widget.conversation.profile?.lastName?.trim()) ?? ""}") ??
                                                "Ahmed Nasr",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: context.isDarkMode
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                      subtitle: Label(
                                        text: DateFormat(
                                          'd MMMM yyyy, h:mm a',
                                          context.isArabic ? 'ar' : 'en',
                                        ).format(context
                                            .read<ConversationsCubit>()
                                            .conversationLogs[index]),
                                        style: Styles.mediumText(),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox();
                  },
                  itemCount: (context
                              .read<ConversationsCubit>()
                              .conversationLogs
                              .length +
                          1) +
                      ((context
                                  .read<ConversationsCubit>()
                                  .isLoadingMoreConversationLogs &&
                              context
                                  .read<ConversationsCubit>()
                                  .conversationLogs
                                  .isNotEmpty)
                          ? 10
                          : 0),
                ),
              ),
              // const MessagesAreEndToEndEncrypted(),
            ],
          ),
        );
      },
    );
  }
}
