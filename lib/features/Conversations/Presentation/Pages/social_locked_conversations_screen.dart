import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/Conversations/Presentation/Controllers/cubits/conversations_cubit.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../common/widgets/stateless/labels/label.dart';
import '../../../../core/widget/custom_scaffold.dart';
import '../../../../helpers/manage_vibration.dart';
import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';
import '../../../social_media/chat/chat_view/presentation/widgets/end_to_end_Encrypted_widget.dart';
import '../Controllers/cubits/conversation_states.dart';
import 'Widgets/chat_card.dart';

class SocialLockedConversationsScreen extends StatefulWidget {
  const SocialLockedConversationsScreen({super.key});

  @override
  State<SocialLockedConversationsScreen> createState() => _SocialLockedConversationsScreenState();
}

class _SocialLockedConversationsScreenState extends State<SocialLockedConversationsScreen> {
  late ScrollController scrollController;
  @override
  void initState() {
    serviceLocator<ConversationsCubit>().initSocialLockedSockets();
    serviceLocator<ConversationsCubit>().loadInitialSocialLockedConversations();
    scrollController = ScrollController()
      ..addListener(() {
        if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200) {
          serviceLocator<ConversationsCubit>().getSocialLockedConversations();
        }
      });
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: serviceLocator<ConversationsCubit>(),
      child: Builder(builder: (context) {
        return CustomScaffold(
          appBar: AppBar(
            elevation: 0,
            leadingWidth: 26,
            leading: IconButton(
              onPressed: () {
                ManageVibration.vibrate();
                context.pop(true);
              },
              icon: Icon(
                Icons.arrow_back,
                color: context.isDarkMode ? Colors.white : AppColors.grey,
              ),
            ),
            title: Text(
              context.isArabic
                  ? "المحادثات المغلقة"
                  : "Locked",
              style: Styles.headerText(
                color: context.isDarkMode ? Colors.white : Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          body: _body(),
        );
      }),
    );
  }

  Widget _body() {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scrollbar(
        // isAlwaysShown: true,  // Ensures the scrollbar is always visible
        interactive: true,
        thumbVisibility: true,
        thickness: 3,
        child: BlocBuilder<ConversationsCubit, ConversationsState>(
            builder: (context, state) {
              if (state.status == ConversationsStates.loading &&
                  context.read<ConversationsCubit>().socialLockedConversations.isEmpty) {
                return GlowingOverscrollIndicator(
                  axisDirection: AxisDirection.down,
                  color: AppColors.SECONDARY_COLOR,
                  child: ListView.separated(
                      itemCount: 15,
                      separatorBuilder: (context, index) => const SizedBox(),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 16.h, left: 16.w, right: 16.w),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Shimmer.fromColors(
                                  baseColor: context.isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
                                  highlightColor: context.isDarkMode ? Colors.grey[700]! : Colors.grey[100]!,
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
                  context.read<ConversationsCubit>().socialLockedConversations.isEmpty) {
                return Center(child: Label(text: context.isArabic ? "لا يوجد دردشات" : "No conversations", style: Styles.headerText(color: AppColors.PRIMARY_COLOR, fontWeight: FontWeight.w500, fontSize: 34),));
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
                          if(index == context.read<ConversationsCubit>().socialLockedConversations.length){
                            return Column(
                              children: [
                                SizedBox(height: 16.h,),
                                Divider(
                                  thickness: 1,
                                  color: Colors.grey.withValues(alpha: 0.2),
                                ),
                                const MessagesAreEndToEndEncrypted(),
                              ],
                            );
                          }
                          if(index >= context.read<ConversationsCubit>().socialLockedConversations.length + 1){
                            return Padding(
                              padding: EdgeInsets.only(bottom: 16.h, left: 16.w, right: 16.w),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Shimmer.fromColors(
                                      baseColor: context.isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
                                      highlightColor: context.isDarkMode ? Colors.grey[700]! : Colors.grey[100]!,
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

                            child: ChatCard(
                              chat: context.read<ConversationsCubit>().socialLockedConversations[index],
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const SizedBox();
                        },
                        itemCount: (context.read<ConversationsCubit>().socialLockedConversations.length + 1) +
                            ((context.read<ConversationsCubit>().isLoadingMoreSocialLockedConversation &&
                                context.read<ConversationsCubit>().socialLockedConversations.isNotEmpty)
                                ? 10
                                : 0),
                      ),
                    ),
                    // const MessagesAreEndToEndEncrypted(),
                  ],
                ),
              );
            }
        ),
      ),
    );
  }
}