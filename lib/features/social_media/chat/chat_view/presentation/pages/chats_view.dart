// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';
// import 'package:fourtyninehub/common/functions/global/loading_custom.dart';
// import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
// import 'package:fourtyninehub/common/widgets/form/text_fields/form_text_field.dart';
// import 'package:fourtyninehub/common/widgets/stateless/appbar/nested_appbar.dart';
// import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
// import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
// import 'package:fourtyninehub/core/states/basic_state.dart';
// import 'package:fourtyninehub/features/authentication/domain/entities/user_entity.dart';
// import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
// import 'package:fourtyninehub/features/social_media/chat/chat_view/presentation/chat_cubit/chats_cubit.dart';
// import 'package:fourtyninehub/features/social_media/chat/chat_view/presentation/widgets/chat_stories.dart';
// import 'package:fourtyninehub/features/social_media/chat/chat_view/presentation/widgets/more_icon_bottom_sheet_body.dart';
// import 'package:fourtyninehub/res/style/app_colors.dart';
// import 'package:fourtyninehub/res/style/styles.dart';
// import 'package:fourtyninehub/routes/routes.dart';
// import 'package:fourtyninehub/service_locator/service_locator.dart';
// import 'package:go_router/go_router.dart';
// import '../widgets/calling_card.dart';
// import '../widgets/chat_card.dart';
//
// class ChatView extends StatefulWidget {
//   const ChatView({super.key});
//
//   @override
//   State<ChatView> createState() => _ChatViewState();
// }
//
// class _ChatViewState extends State<ChatView> {
//   late ChatsCubit chatCubit;
//
//   @override
//   void initState() {
//     super.initState();
//     initSocketConnection();
//   }
//
//   initSocketConnection() {
//     chatCubit = context.read<ChatsCubit>()..initSocketConnection();
//     chatCubit.getChats(index: 0);
//   }
//
//   final List<String> groups = [
//     'Social',
//     'Services',
//     'Call & Video(Social)',
//     'Call & Video(Services)',
//     'Greet',
//     'Groups',
//     'Anonymous',
//     'Archive',
//     'Lock Chat',
//     'Unread',
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: groups.length,
//       initialIndex: 0,
//       child: SharedScaffold(
//         mainCategoryId: 2,
//         body: NestedAppbar(
//           appBars: [
//             const SliverAppBar(
//               expandedHeight: kToolbarHeight * 1.5,
//               automaticallyImplyLeading: false,
//               floating: true,
//               flexibleSpace: ChatStories(),
//             ),
//             SliverAppBar(
//               automaticallyImplyLeading: false,
//               floating: true,
//               pinned: true,
//               titleSpacing: 0,
//               title: _buildCategoriesLabels(),
//             )
//           ],
// body: BlocBuilder<UserCubit, BasicState<UserEntity>>(
//   builder: (context, state) {
//     return context.read<UserCubit>().isLoggedIn
//         ? _buildCategoriesViews()
//         : Center(
//             child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               GestureDetector(
//                   onTap: () => context.push(Routes.LOGIN),
//                   child: Label(
//                       text: 'Login',
//                       style: Styles.headerText(color: Colors.blue))),
//               Label(
//                   text: ', To continue in using chat services',
//                   style: Styles.headerText()),
//             ],
//           ));
//   },
// ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildCategoriesLabels() {
//     return TabBar(
//         onTap: (index) {
//           context.read<ChatsCubit>().getChats(index: index);
//
//           // if this locked chat we request password
//           if (index == 8) {
//             showDialogToConfirmChatLockPassword(context);
//           }
//         },
//         tabAlignment: TabAlignment.start,
//         isScrollable: true,
//         tabs: groups.map((e) {
//           return Tab(
//             text: e,
//           );
//         }).toList());
//   }
//
//   Widget _buildCategoriesViews() {
//     return TabBarView(children: [
//       _buildCategoryChats(),
//       _buildCategoryChats(),
//       _buildCallingHistory(isVideo: false),
//       _buildCallingHistory(isVideo: true),
//       _buildCallingHistory(isVideo: false),
//       _buildCallingHistory(isVideo: true),
//       _buildCategoryChats(isSecret: true),
//       _buildCategoryChats(),
//       _buildCategoryChats(),
//       _buildCategoryChats(),
//       // _buildCategoryChats(),
//       // _buildCategoryChats(),
//     ]);
//   }
//
//   Widget _buildCategoryChats({bool isSecret = false}) {
//     return BlocBuilder<ChatsCubit, ChatsState>(builder: (context, state) {
//       return state.chats == null || state.isLoading
//           ? LoadingCustom.customThreeBounce(context)
//           : state.chats?.length == 0
//               ? Center(
//                   child: Label(
//                       text: 'No Chats until now',
//                       style: Styles.mediumText(
//                           color: const Color.fromARGB(255, 87, 87, 87),
//                           fontWeight: FontWeight.bold,
//                           fontSize: 18)),
//                 )
//               : ListView.separated(
//                   shrinkWrap: true,
//                   physics: const NeverScrollableScrollPhysics(),
//                   itemBuilder: (context, index) => Slidable(
//                     key: ValueKey(index),
//                     // All actions are defined in the children parameter.
//
//                     closeOnScroll: false,
//                     endActionPane: ActionPane(
//                       motion: const ScrollMotion(),
//                       dismissible: DismissiblePane(onDismissed: () {}),
//                       children: [
//                         SlidableAction(
//                           onPressed: (value) {
//                             bottomSheet(
//                                 context: context,
//                                 isScrollControlled: true,
//                                 widget: MoreIconBottomSheet(
//                                   ChatCategoryEntity: state.chats![index],
//                                   chatsCubit: chatCubit,
//                                 ));
//                           },
//                           backgroundColor:
//                               const Color.fromARGB(255, 191, 191, 191),
//                           foregroundColor: Colors.white,
//                           icon: Icons.more_horiz,
//                           label: 'More',
//                           padding: EdgeInsets.zero,
//                         ),
//                         SlidableAction(
//                           onPressed: (value) async {
//                             chatCubit.changeChatToArchiveOrNormalUseCase(
//                                 state.chats![index].sId!);
//                           },
//                           backgroundColor: AppColors.PRIMARY_COLOR,
//                           foregroundColor: Colors.white,
//                           icon: Icons.delete_outlined,
//                           label: state.chats![index].archived!
//                               ? 'Unarchive'
//                               : 'Archive',
//                           padding: EdgeInsets.zero,
//                         ),
//                       ],
//                     ),
//
//                     // onDismissed: ,
//                     child: ChatCard(
//                       isSecret: isSecret,
//                       ChatCategoryEntity: state.chats?[index],
//                       chatsCubit: chatCubit,
//                     ),
//                   ),
//                   separatorBuilder: (context, index) => const SizedBox(),
//                   itemCount: state.chats?.length ?? 0,
//                 );
//     });
//   }
//
//   Widget _buildCallingHistory({required bool isVideo}) {
//     return ListView.separated(
//         shrinkWrap: true,
//         physics: const NeverScrollableScrollPhysics(),
//         itemBuilder: (context, index) => CallingCard(
//               isVideo: isVideo,
//             ),
//         separatorBuilder: (context, index) => const SizedBox(),
//         itemCount: 8);
//   }
//
//   Future<bool?> showDialogToConfirmChatLockPassword(
//       BuildContext context) async {
//     TextEditingController passwordController = TextEditingController(text: '');
//     return await showDialog(
//       context: context,
//       builder: ((context) => AlertDialog(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(5.0),
//             ),
//             title: Label(
//                 text: 'Lock chats password please',
//                 style: Styles.headerText(
//                     fontWeight: FontWeight.bold, color: Colors.black)),
//             content: Material(
//               child: ConstrainedBox(
//                 constraints: const BoxConstraints(maxHeight: 100.0),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     FormTextField(
//                         controller: passwordController,
//                         hint: 'password',
//                         type: TextInputType.number,
//                         // initialValue: '',
//                         style: const TextStyle(
//                             fontSize: 20,
//                             color: Colors.grey,
//                             fontWeight: FontWeight.bold),
//                         action: (v) => () {}),
//                   ],
//                 ),
//               ),
//             ),
//             actions: [
//               TextButton(
//                   onPressed: () async {
//                     chatCubit.getChats(
//                         index: 8, password: passwordController.text.trim());
//                     Navigator.of(context).pop(false);
//                   },
//                   child: const Text('Confirm password')),
//             ],
//           )),
//     );
//   }
// }
//after add index to navigate

// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fourtyninehub/common/widgets/stateless/appbar/nested_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/enums/chat_categories.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/states/basic_state.dart';
import 'package:fourtyninehub/features/authentication/domain/entities/user_entity.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/chat/broadcasts/presentation/widgets/my_broadcast_card.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/entities/chat_entity.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/usecases/get_chats_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/presentation/chat_cubit/chats_cubit.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/presentation/pages/archived_chats_view.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/presentation/widgets/chat_stories.dart';
import 'package:fourtyninehub/features/social_media/chat/broadcasts/presentation/widgets/follow_broadcast_card.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';


import '../../../../../../service_locator/service_locator.dart';
import '../../../../stories/presentation/cubit/stories_cubit.dart';
import '../widgets/calling_card.dart';
import '../widgets/chat_card.dart';

class ChatsViewParams {
  final int initialTabIndex;
  bool isFromStartChat = false;
  ChatEntity? selectedChat;
  ChatsViewParams(
      {this.initialTabIndex = 0,
      this.isFromStartChat = false,
      this.selectedChat});
}

// ignore: must_be_immutable
class ChatView extends StatefulWidget {
  final ChatsViewParams chatsViewParams;
  const ChatView({super.key, required this.chatsViewParams});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> with TickerProviderStateMixin {
  late ChatsCubit chatsCubit;
  late TabController tabController;
  bool expandedOptions = false;
  late ScrollController scrollController;
  double lastOffset = 0.0;

  @override
  void initState() {
    if (widget.chatsViewParams.isFromStartChat) {
      chatsCubit = context.read<ChatsCubit>()..init();
      chatsCubit.selectChat = widget.chatsViewParams.selectedChat!;

      Future.microtask(() async {
        await context
            .read<ChatsCubit>()
            .getOnlineOfflineStatus(chat: widget.chatsViewParams.selectedChat!);
        context.push(Routes.CHATROOM, extra: chatsCubit);
      });
    } else {
      chatsCubit = context.read<ChatsCubit>()..init();
    }
    tabController =
        TabController(length: ChatCategories.values.length, vsync: this)
          ..addListener(() {
            if (tabController.previousIndex != tabController.index) {
              chatsCubit.getChatsByCategory(
                  ChatCategories.values[tabController.index]);
            }
          });

    scrollController = ScrollController()
      ..addListener(() {
        if (lastOffset > scrollController.offset) {
          // Scrolled down
          if (!expandedOptions) {
            setState(() {
              expandedOptions = true;
            });
          }
        } else if (lastOffset < scrollController.offset) {
          // Scrolled up
          if (expandedOptions) {
            setState(() {
              expandedOptions = false;
            });
          }
        }
        lastOffset = scrollController.offset;
      });

    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: ChatCategories.values.length,
      initialIndex: widget.chatsViewParams.initialTabIndex,
      child: BlocBuilder<ChatsCubit, ChatsState>(
        builder: (context, state) {
          return SharedScaffold(
            mainCategoryId: 2,
            body: NestedAppbar(
              scrollController:
                  scrollController, // Attach the ScrollController here
              appBars: [
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  floating: true,
                  flexibleSpace: BlocProvider.value(
                    value: serviceLocator<StoryCubit>()..fetchStories(),
                    child: BlocBuilder<ChatsCubit, ChatsState>(
                      // buildWhen: (previous, current) {
                      //   return previous.status != ChatsStates.typing ||
                      //       previous.status != ChatsStates.recording;
                      // },
                      builder: (context, state) {
                        return context.read<UserCubit>().isLoggedIn
                            ? SizedBox(
                                // height: 20,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16.w),
                                      child: Text(
                                        context
                                                .read<ChatsCubit>()
                                                .selectedChats
                                                .isNotEmpty
                                            ? "${context.read<ChatsCubit>().selectedChats.length} ${LocaleKeys.selected.tr()}"
                                            : "49 Hub",
                                        style: context
                                                .read<ChatsCubit>()
                                                .selectedChats
                                                .isNotEmpty
                                            ? Styles.mediumText(
                                                color: context.isDarkMode
                                                    ? Colors.white
                                                    : AppColors.PRIMARY_COLOR)
                                            : Styles.headerText(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 48,
                                                color: context.isDarkMode
                                                    ? Colors.white
                                                    : AppColors.PRIMARY_COLOR),
                                      ),
                                    ),
                                    const Spacer(),
                                    context
                                            .read<ChatsCubit>()
                                            .selectedChats
                                            .isEmpty
                                        ? const SizedBox.shrink()
                                        : Row(
                                            children: [
                                              IconButton(
                                                onPressed: () async {
                                                  await context
                                                      .read<ChatsCubit>()
                                                      .pinAndUnpinChat();
                                                },
                                                icon:
                                                    const Icon(Icons.push_pin),
                                                color: context.isDarkMode
                                                    ? Colors.white
                                                    : AppColors.PRIMARY_COLOR,
                                              ),
                                              IconButton(
                                                onPressed: () async {
                                                  await context
                                                      .read<ChatsCubit>()
                                                      .deleteChat();
                                                },
                                                icon: Icon(
                                                  Icons.delete_forever,
                                                  color: context.isDarkMode
                                                      ? Colors.white
                                                      : AppColors.PRIMARY_COLOR,
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: () async {
                                                  await context
                                                      .read<ChatsCubit>()
                                                      .changeMuteChat();
                                                },
                                                icon: Icon(
                                                  Icons.notifications_off,
                                                  color: context.isDarkMode
                                                      ? Colors.white
                                                      : AppColors.PRIMARY_COLOR,
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: () async {
                                                  await context
                                                      .read<ChatsCubit>()
                                                      .changeArchiveChat(
                                                          isArchivedTab: false);
                                                },
                                                icon: Icon(
                                                  Icons.archive,
                                                  color: context.isDarkMode
                                                      ? Colors.white
                                                      : AppColors.PRIMARY_COLOR,
                                                ),
                                              ),
                                            ],
                                          ),
                                    context
                                            .read<ChatsCubit>()
                                            .selectedChats
                                            .isEmpty
                                        ? PopupMenuButton(
                                            icon: Icon(
                                              Icons.more_vert,
                                              color: context.isDarkMode
                                                  ? Colors.white
                                                  : AppColors.PRIMARY_COLOR,
                                            ),
                                            color: context.isDarkMode
                                                ? AppColors.PRIMARY_COLOR
                                                : AppColors.BACKGROUND_COLOR,
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(16.0)),
                                            ),
                                            offset: const Offset(0, 50),
                                            onSelected: (int value) async {
                                              if (value == 0) {
                                                context.push(
                                                    Routes.CHATPROFILEVIEW);
                                              }
                                              if (value == 1) {
                                                await context
                                                    .read<ChatsCubit>()
                                                    .recoverDeletedChats();
                                              }
                                            },
                                            itemBuilder: (context) {
                                              return _mainMenuBuilder();
                                            },
                                          )
                                        : PopupMenuButton(
                                            icon: Icon(
                                              Icons.more_vert,
                                              color: context.isDarkMode
                                                  ? Colors.white
                                                  : AppColors.PRIMARY_COLOR,
                                            ),
                                            color: context.isDarkMode
                                                ? AppColors.PRIMARY_COLOR
                                                : AppColors.BACKGROUND_COLOR,
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(16.0)),
                                            ),
                                            offset: const Offset(0, 50),
                                            onSelected: (int value) async {
                                              if (value == 3) {
                                                await context
                                                    .read<ChatsCubit>()
                                                    .lockChats(isLockedTap: false);
                                              }
                                              
                                            },
                                            itemBuilder: (context) {
                                              return [
                                                PopupMenuItem<int>(
                                                  value: 0,
                                                  child: Text(
                                                    LocaleKeys.addShortcut.tr(),
                                                    style: Styles.mediumText(
                                                        color: context
                                                                .isDarkMode
                                                            ? Colors.white
                                                            : AppColors
                                                                .PRIMARY_COLOR),
                                                  ),
                                                ),
                                                PopupMenuItem<int>(
                                                  value: 1,
                                                  child: Text(
                                                    LocaleKeys.markAsUnread
                                                        .tr(),
                                                    style: Styles.mediumText(
                                                        color: context
                                                                .isDarkMode
                                                            ? Colors.white
                                                            : AppColors
                                                                .PRIMARY_COLOR),
                                                  ),
                                                ),
                                                PopupMenuItem<int>(
                                                  value: 2,
                                                  child: Text(
                                                    LocaleKeys.selectAll.tr(),
                                                    style: Styles.mediumText(
                                                        color: context
                                                                .isDarkMode
                                                            ? Colors.white
                                                            : AppColors
                                                                .PRIMARY_COLOR),
                                                  ),
                                                ),
                                                PopupMenuItem<int>(
                                                  value: 3,
                                                  child: Text(
                                                    LocaleKeys.lockChat.tr(),
                                                    style: Styles.mediumText(
                                                        color: context
                                                                .isDarkMode
                                                            ? Colors.white
                                                            : AppColors
                                                                .PRIMARY_COLOR),
                                                  ),
                                                ),
                                              ];
                                            },
                                          ),
                                  ],
                                ),
                              )
                            : const SizedBox.shrink();
                      },
                    ),
                  ),
                ),
                // if (context.read<UserCubit>().isLoggedIn)
                SliverAppBar(
                  expandedHeight: MediaQuery.of(context).size.height *
                      0.08, // Responsive height
                  automaticallyImplyLeading: false,
                  floating: true,
                  flexibleSpace: BlocProvider(
                    create: (context) => serviceLocator<StoryCubit>()
                      ..fetchStories()
                      ..getMutedStories(),
                    child: const ChatStories(),
                  ),
                ),
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  floating: true,
                  pinned: true,
                  titleSpacing: 0,
                  title: _buildCategoriesLabels(),
                )
              ],
              // body: BlocBuilder<UserCubit, BasicState<UserEntity>>(
              //   builder: (context, state) {
              //     return _buildCategoriesViews();
              //   },
              // ),
              body: BlocBuilder<UserCubit, BasicState<UserEntity>>(
                builder: (context, state) {
                  return context.read<UserCubit>().isLoggedIn
                      ? _buildCategoriesViews()
                      : Center(
                          child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                                onTap: () => context.push(Routes.LOGIN),
                                child: Label(
                                  text: LocaleKeys.login.tr(),
                                  style: const TextStyle(
                                    color: AppColors.PRIMARY_COLOR_DARK,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    decoration: TextDecoration.underline,
                                    decorationColor:
                                        AppColors.PRIMARY_COLOR_DARK,
                                  ),
                                )),
                            Label(
                              text: LocaleKeys.continueUsingChatServices.tr(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ));
                },
              ),
            ),
          );
        },
      ),
    );
  }

  List<PopupMenuEntry<int>> _mainMenuBuilder() {
    return [
      // PopupMenuItem<int>(
      //   value: 0,
      //   child: Text(
      //     LocaleKeys.newGroup.tr(),
      //     style: Styles.mediumText(
      //         color:
      //             context.isDarkMode ? Colors.white : AppColors.PRIMARY_COLOR),
      //   ),
      // ),
      // PopupMenuItem<int>(
      //   value: 1,
      //   child: Text(
      //     LocaleKeys.newBroadcast.tr(),
      //     style: Styles.mediumText(
      //         color:
      //             context.isDarkMode ? Colors.white : AppColors.PRIMARY_COLOR),
      //   ),
      // ),
      // PopupMenuItem<int>(
      //   value: 2,
      //   child: Text(
      //     LocaleKeys.linkedDevice.tr(),
      //     style: Styles.mediumText(
      //         color:
      //             context.isDarkMode ? Colors.white : AppColors.PRIMARY_COLOR),
      //   ),
      // ),
      PopupMenuItem<int>(
        value: 0,
        child: Text(
          LocaleKeys.recoverDeletedChats.tr(),
          style: Styles.mediumText(
              color:
                  context.isDarkMode ? Colors.white : AppColors.PRIMARY_COLOR),
        ),
      ),
      PopupMenuItem<int>(
        value: 1,
        child: Text(
          LocaleKeys.profile.tr(),
          style: Styles.mediumText(
              color:
                  context.isDarkMode ? Colors.white : AppColors.PRIMARY_COLOR),
        ),
      ),
    ];
  }

  Widget _buildCategoriesLabels() {
    return TabBar(
        controller: tabController,
        labelColor: context.isDarkMode ? Colors.white : AppColors.PRIMARY_COLOR,
        unselectedLabelColor: AppColors.LIGHT_GRAY_COLOR2,
        indicatorColor: Colors.red,
        tabAlignment: TabAlignment.start,
        isScrollable: true,
        tabs: ChatCategories.values.map((e) {
          return Tab(text: e.name.tr());
        }).toList());
  }

  Widget _buildCategoriesViews() {
    return TabBarView(
        controller: tabController,
        children: ChatCategories.values
            .map((e) => _chatCategoryWidgetMapper(e))
            .toList());
  }

  Widget _chatCategoryWidgetMapper(ChatCategories category) {
    switch (category) {
      case ChatCategories.social:
        return Column(
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  expandedOptions = !expandedOptions;
                });
              },
              child: SizedBox(
                width: double.infinity,
                child: Icon(
                  expandedOptions
                      ? Icons.keyboard_double_arrow_up_outlined
                      : Icons.keyboard_double_arrow_down_outlined,
                ),
              ),
            ),
            ChatOptions(
              icon: Icons.archive,
              text: LocaleKeys.archive.tr(),
              onTap: () async {
                final result = await context.push(Routes.ARCHIVEDCHATS,
                    extra: OptionsChatsViewParams(
                      category: 'Archive',
                      chatsCubit: chatsCubit,
                      isSecret: false,
                    ));

                // Check if the result is true, refresh the home page
                if (result == true) {
                  log("pop");
                  await chatsCubit.getChatsByCategory(ChatCategories.social);
                  setState(() {});
                }
              },
            ),
            // const Divider(),
            AnimatedSwitcher(
              duration:
                  const Duration(milliseconds: 500), // Duration of animation
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
              child: expandedOptions
                  ? ChatOptions(
                      key: const ValueKey(1),
                      icon: Icons.mail_lock,
                      text: LocaleKeys.lockChat.tr(),
                      // onTap: () async {
                      //   final result = await context.push(Routes.ARCHIVEDCHATS,
                      //       extra: OptionsChatsViewParams(
                      //         category: 'LockedChats',
                      //         chatsCubit: chatsCubit,
                      //         isSecret: true,
                      //       ));

                      //   // Check if the result is true, refresh the home page
                      //   if (result == true) {
                      //     log("pop");
                      //     await chatsCubit
                      //         .getChatsByCategory(ChatCategories.social);
                      //     setState(() {});
                      //   }
                      // },
                      onTap: () async {
                        await lockedChatsOnTap();
                      },
                    )
                  : const SizedBox.shrink(),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
              child: expandedOptions
                  ? ChatOptions(
                      key: const ValueKey(2),
                      icon: Icons.person_off,
                      text: LocaleKeys.anonymous.tr(),
                      onTap: () async {
                        final result = await context.push(Routes.ARCHIVEDCHATS,
                            extra: OptionsChatsViewParams(
                              category: ChatCategoriesIds.anonymous,
                              chatsCubit: chatsCubit,
                              isSecret: false,
                            ));

                        // Check if the result is true, refresh the home page
                        if (result == true) {
                          log("pop");
                          await chatsCubit
                              .getChatsByCategory(ChatCategories.social);
                          setState(() {});
                        }
                      },
                    )
                  : const SizedBox.shrink(),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
              child: expandedOptions
                  ? ChatOptions(
                      key: const ValueKey(3),
                      icon: Icons.emoji_people,
                      text: LocaleKeys.greet.tr(),
                      onTap: () async {
                        final result = await context.push(Routes.ARCHIVEDCHATS,
                            extra: OptionsChatsViewParams(
                              category: ChatCategoriesIds.greet,
                              chatsCubit: chatsCubit,
                              isSecret: false,
                            ));

                        // Check if the result is true, refresh the home page
                        if (result == true) {
                          log("pop");
                          await chatsCubit
                              .getChatsByCategory(ChatCategories.social);
                          setState(() {});
                        }
                      },
                    )
                  : const SizedBox.shrink(),
            ),
            const Divider(),
            _buildCategoryChats(),
            const MessagesAreEndToEndEncrypted(),
          ],
        );
      case ChatCategories.service:
        return Column(
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  expandedOptions = !expandedOptions;
                });
              },
              child: SizedBox(
                width: double.infinity,
                child: Icon(
                  expandedOptions
                      ? Icons.keyboard_double_arrow_up_outlined
                      : Icons.keyboard_double_arrow_down_outlined,
                ),
              ),
            ),
            ChatOptions(
              icon: Icons.archive,
              text: LocaleKeys.archive.tr(),
              onTap: () async {
                final result = await context.push(Routes.ARCHIVEDCHATS,
                    extra: OptionsChatsViewParams(
                      category: 'Archive',
                      chatsCubit: chatsCubit,
                      isSecret: false,
                    ));

                // Check if the result is true, refresh the home page
                if (result == true) {
                  log("pop");
                  await chatsCubit.getChatsByCategory(ChatCategories.service);
                  setState(() {});
                }
              },
            ),
            // const Divider(),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
              child: expandedOptions
                  ? ChatOptions(
                      key: const ValueKey(4),
                      icon: Icons.mail_lock,
                      text: LocaleKeys.lockChat.tr(),
                      // onTap: () async {
                      //   final result = await context.push(Routes.ARCHIVEDCHATS,
                      //       extra: OptionsChatsViewParams(
                      //         category: 'LockedChats',
                      //         chatsCubit: chatsCubit,
                      //         isSecret: true,
                      //       ));

                      //   // Check if the result is true, refresh the home page
                      //   if (result == true) {
                      //     log("pop");
                      //     await chatsCubit
                      //         .getChatsByCategory(ChatCategories.service);
                      //     setState(() {});
                      //   }
                      // },
                      onTap: () async {
                        await lockedChatsOnTap();
                      },
                    )
                  : const SizedBox.shrink(),
            ),
            const Divider(),
            _buildCategoryChats(),
            const MessagesAreEndToEndEncrypted(),
          ],
        );
      // case ChatCategories.groups:
      case ChatCategories.unread:
        return Column(
          children: [
            _buildCategoryChats(),
            const MessagesAreEndToEndEncrypted(),
          ],
        );
      case ChatCategories.calls:
        return _buildCallingHistory(isVideo: false);
      // case ChatCategories.broadcast:
      //   return buildBroadcast();
      //   case ChatCategories.archived:
      // case ChatCategories.anonymous:
      // case ChatCategories.greet:
      //   return _buildCategoryChats();
      // case ChatCategories.socialCalls:
      // case ChatCategories.serviceCalls:
      // return _buildCallingHistory(isVideo: false);
      // case ChatCategories.locked:
      // return _buildCategoryChats(isSecret: true);
    }
  }

  Future<void> lockedChatsOnTap() async {
    final LocalAuthentication auth = LocalAuthentication();

    // Check if local authentication is available
    bool isAvailable =
        await auth.canCheckBiometrics || await auth.isDeviceSupported();

    if (isAvailable) {
      try {
        // Attempt to authenticate the user
        bool didAuthenticate = await auth.authenticate(
          localizedReason: context.isArabic
              ? 'تحقق من البصمة للوصول إلى المحادثات المغلقة'
              : 'Please authenticate to access locked chats',
          // options: const AuthenticationOptions(
          //   biometricOnly: true,
          //   stickyAuth: true,
          // ),
        );

        if (didAuthenticate) {
          // User authenticated successfully
          final result = await context.push(
            Routes.ARCHIVEDCHATS,
            extra: OptionsChatsViewParams(
              category: 'LockedChats',
              chatsCubit: chatsCubit,
              isSecret: true,
            ),
          );

          // Check if the result is true, refresh the home page
          if (result == true) {
            log("pop");
            await chatsCubit.getChatsByCategory(ChatCategories.social);
            setState(() {});
          }
        } else {
          log("Authentication failed");
        }
      } catch (e) {
        log("Error during authentication: $e");
      }
    } else {
      log("Local authentication not available on this device.");
    }
  }

  Widget _buildCategoryChats({bool isSecret = false}) {
    return BlocBuilder<ChatsCubit, ChatsState>(builder: (context, state) {
      return state.chats == null || state.isLoading
          ?
          // const Center(
          //     child: CircularProgressIndicator.adaptive(),
          //   )
          const SizedBox()
          : state.chats!.isEmpty
              ? Center(
                  child: Label(
                      text: LocaleKeys.noChatsUntilNow.tr(),
                      style: Styles.mediumText(
                          fontWeight: FontWeight.bold, fontSize: 26)),
                )
              : Scrollbar(
                  // isAlwaysShown: true,  // Ensures the scrollbar is always visible
                  interactive: true,
                  thumbVisibility: true,
                  thickness: 3,

                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const AlwaysScrollableScrollPhysics(),
                    // Enable scrolling
                    itemBuilder: (context, index) => (state
                            .chats![index].archived)
                        ? const SizedBox()
                        : Slidable(
                            key: ValueKey(index),
                            closeOnScroll: false,
                            endActionPane: ActionPane(
                              motion: const ScrollMotion(),
                              dismissible: DismissiblePane(onDismissed: () {}),
                              children: [
                                SlidableAction(
                                  onPressed: (value) {
                                    // bottomSheet logic
                                  },
                                  backgroundColor: context.isDarkMode
                                      ? AppColors.DARK_BLUE_COLOR
                                      : const Color.fromARGB(
                                          255, 191, 191, 191),
                                  foregroundColor: context.isDarkMode
                                      ? AppColors.DARK_BLUE_COLOR
                                      : Colors.white,
                                  icon: Icons.more_horiz,
                                  label: LocaleKeys.more.tr(),
                                  padding: EdgeInsets.zero,
                                ),
                                SlidableAction(
                                  onPressed: (value) async {
                                    // Archive or unarchive logic
                                  },
                                  backgroundColor: context.isDarkMode
                                      ? Colors.white
                                      : AppColors.PRIMARY_COLOR,
                                  foregroundColor: context.isDarkMode
                                      ? AppColors.DARK_BLUE_COLOR
                                      : Colors.white,
                                  icon: Icons.delete_outlined,
                                  label: state.chats![index].archived
                                      ? LocaleKeys.unarchive.tr()
                                      : LocaleKeys.archive.tr(),
                                  padding: EdgeInsets.zero,
                                ),
                              ],
                            ),
                            child: ChatCard(
                              isSecret: isSecret,
                              chat: state.chats?[index],
                              chatsCubit: chatsCubit,
                            ),
                          ),
                    separatorBuilder: (context, index) => const SizedBox(),
                    itemCount: state.chats?.length ?? 0,
                  ),
                );
    });
  }

  Widget _buildCallingHistory({required bool isVideo}) {
    return DefaultTabController(
      length: 2, // Two tabs: Social and Services

      child: Column(
        children: [
          // Tab Bar for Social and Services
          TabBar(
            labelColor:
                context.isDarkMode ? Colors.white : AppColors.PRIMARY_COLOR,
            unselectedLabelColor: AppColors.LIGHT_GRAY_COLOR2,
            indicator: const BoxDecoration(
                // color: AppColors.PRIMARY_COLOR_DARK,
                border: Border(
              bottom: BorderSide(
                color: AppColors.PRIMARY_COLOR_DARK,
                width: 3.0,
              ),
            )),
            tabs: [
              Tab(text: LocaleKeys.social.tr()),
              Tab(text: LocaleKeys.services.tr()),
            ],
            indicatorColor: Colors.blue,
          ),
          Expanded(
            // TabBarView to display content for each tab
            child: TabBarView(
              children: [
                // Social tab: Show video calls
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) =>
                      const CallingCard(isVideo: true),
                  separatorBuilder: (context, index) => const SizedBox(),
                  itemCount: 8,
                ),
                // Services tab: Show voice calls
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) =>
                      const CallingCard(isVideo: false),
                  separatorBuilder: (context, index) => const SizedBox(),
                  itemCount: 8,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBroadcast() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Follow Section
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  LocaleKeys.broadcasts.tr(),
                  style: Styles.mediumText(fontWeight: FontWeight.w600),
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  context.push(Routes.SEEALLBROADCASTS);
                },
                child: Text(
                  LocaleKeys.seeAll.tr(),
                  style: Styles.smallText(
                    color: AppColors.PRIMARY_COLOR_DARK,
                    fontSize: 24,
                  ),
                ),
              ),
              const SizedBox(
                width: 16,
              )
            ],
          ),
          SizedBox(
            height: 160, // Set the height for the horizontal list view
            child: ListView(
              scrollDirection:
                  Axis.horizontal, // Makes the list scroll horizontally
              children: const [
                FollowBroadcastCard(
                  'FC Barcelona',
                  'https://www.hyperakt.com/assets/images/fc-barcelona/Barcelona.jpg',
                ),
                FollowBroadcastCard(
                  'BBC News',
                  'https://seeklogo.com/images/B/bbc-news-logo-8648ABD044-seeklogo.com.png',
                ),
                FollowBroadcastCard(
                  'Real Madrid FC',
                  'https://images.alphacoders.com/116/thumb-1920-1163534.jpg',
                ),
                FollowBroadcastCard(
                  'FC Barcelona',
                  'https://www.hyperakt.com/assets/images/fc-barcelona/Barcelona.jpg',
                ),
                FollowBroadcastCard(
                  'BBC News',
                  'https://seeklogo.com/images/B/bbc-news-logo-8648ABD044-seeklogo.com.png',
                ),
                FollowBroadcastCard(
                  'Real Madrid FC',
                  'https://images.alphacoders.com/116/thumb-1920-1163534.jpg',
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 24, right: 16),
            child: Text(
              LocaleKeys.myBroadcasts.tr(),
              style: Styles.mediumText(fontWeight: FontWeight.w600),
            ),
          ),
          ListView.separated(
            itemCount: 10,
            separatorBuilder: (context, index) {
              return const Divider(
                color: Colors.grey,
              );
            },
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return const MyBroadcastsCard();
            },
            physics: const NeverScrollableScrollPhysics(),
          ),
        ],
      ),
    );
  }
}

class MessagesAreEndToEndEncrypted extends StatelessWidget {
  const MessagesAreEndToEndEncrypted({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 16,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.lock,
              size: 18,
            ),
            const SizedBox(
              width: 8,
            ),
            Label(
                text: "${LocaleKeys.yourPersonalMessages.localize} ",
                style: Styles.mediumText(
                    fontWeight: FontWeight.bold, fontSize: 28)),
          ],
        ),
        Label(
          text: "     ${LocaleKeys.endToEndEncryption.localize}",
          style: Styles.mediumText(
              fontWeight: FontWeight.bold,
              fontSize: 28,
              color: AppColors.PRIMARY_COLOR_DARK),
        ),
      ],
    );
  }
}

class ChatOptions extends StatelessWidget {
  const ChatOptions({
    super.key,
    required this.icon,
    required this.text,
    this.onTap,
  });

  final IconData icon;
  final String text;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Icon(
              icon,
              color:
                  context.isDarkMode ? Colors.white : AppColors.PRIMARY_COLOR,
            ),
            const SizedBox(width: 8),
            Label(
              text: text,
              style: Styles.mediumText(
                fontWeight: FontWeight.bold,
                fontSize: 32,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FriendRequest {
  final String name;
  final int mutualFriends;
  final String profileImageUrl;

  FriendRequest({
    required this.name,
    required this.mutualFriends,
    required this.profileImageUrl,
  });
}

class FriendRequestItem extends StatefulWidget {
  final FriendRequest request;

  const FriendRequestItem({super.key, required this.request});

  @override
  _FriendRequestItemState createState() => _FriendRequestItemState();
}

class _FriendRequestItemState extends State<FriendRequestItem> {
  String buttonText = 'Add Friend';
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        children: [
          // Profile Image
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(
              serviceLocator<UserCubit>().state.data != null
                  ? serviceLocator<UserCubit>().state.data!.profilePicture!
                  : UIConst.profilePlaceHolder,
            ),
          ),
          const SizedBox(width: 8),

          // Name and Mutual Friends
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.request.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  '${widget.request.mutualFriends} mutual friends',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // Confirm Button (Add Friend/Follow/Greet)
          ElevatedButton(
            onPressed:
                isLoading ? null : handleButtonPress, // Disable if loading
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.PRIMARY_COLOR,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: isLoading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    buttonText,
                    style: const TextStyle(color: Colors.white, fontSize: 11),
                  ),
          ),
          const SizedBox(width: 8),

          // Delete Button
          ElevatedButton(
            onPressed: () {
              // Add delete logic here
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.PRIMARY_COLOR_DARK,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.white, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }

  void handleButtonPress() async {
    // Start showing loading indicator
    setState(() {
      isLoading = true;
    });

    // Simulate 1 second delay (replace with your logic)
    await Future.delayed(const Duration(seconds: 1));

    // Update the button text based on the current state
    setState(() {
      if (buttonText == 'Add Friend') {
        buttonText = 'Follow';
      } else if (buttonText == 'Follow') {
        buttonText = 'Greet';
      }
      isLoading = false;
    });
  }
}
