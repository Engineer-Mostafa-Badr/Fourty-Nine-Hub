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
// import 'package:fourtyninehub/features/social_media/chat/chat_view/presentation/chat_cubit/chat_cubit.dart';
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
//           body: BlocBuilder<UserCubit, BasicState<UserEntity>>(
//             builder: (context, state) {
//               return context.read<UserCubit>().isLoggedIn
//                   ? _buildCategoriesViews()
//                   : Center(
//                       child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         GestureDetector(
//                             onTap: () => context.push(Routes.LOGIN),
//                             child: Label(
//                                 text: 'Login',
//                                 style: Styles.headerText(color: Colors.blue))),
//                         Label(
//                             text: ', To continue in using chat services',
//                             style: Styles.headerText()),
//                       ],
//                     ));
//             },
//           ),
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
//                                   chatItemModel: state.chats![index],
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
//                       chatItemModel: state.chats?[index],
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
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fourtyninehub/common/functions/global/loading_custom.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/form_text_field.dart';
import 'package:fourtyninehub/common/widgets/stateless/appbar/nested_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/states/basic_state.dart';
import 'package:fourtyninehub/features/authentication/domain/entities/user_entity.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/presentation/chat_cubit/chat_cubit.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/presentation/widgets/chat_stories.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/presentation/widgets/more_icon_bottom_sheet_body.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../service_locator/service_locator.dart';
import '../../../../stories/presentation/cubit/stories_cubit.dart';
import '../widgets/calling_card.dart';
import '../widgets/chat_card.dart';

class ChatView extends StatefulWidget {
  final int initialTabIndex;

  const ChatView({super.key, this.initialTabIndex = 0});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  late ChatsCubit chatCubit;

  @override
  void initState() {
    super.initState();
    initSocketConnection();
  }

  initSocketConnection() {
    chatCubit = context.read<ChatsCubit>()..initSocketConnection();
    chatCubit.initChat();
  }

  final List<String> groups = [
    'Social',
    'Services',
    'Call & Video(Social)',
    'Call & Video(Services)',
    'Greet',
    'Groups',
    'Anonymous',
    'Archive',
    'Lock Chat',
    'Unread',
    'Broadcast',
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: groups.length,
      initialIndex: widget.initialTabIndex,
      child: SharedScaffold(
        mainCategoryId: 2,
        body: NestedAppbar(
          scrollController: ScrollController(),
          appBars: [
            SliverAppBar(
              expandedHeight: kToolbarHeight * 1.5,
              automaticallyImplyLeading: false,
              floating: true,
              flexibleSpace: BlocProvider.value(
                value: serviceLocator<StoryCubit>()..fetchStories(),
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
                                text: 'Login', style: Styles.headerText())),
                        Label(
                            text: ', To continue in using chat services',
                            style: Styles.headerText()),
                      ],
                    ));
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCategoriesLabels() {
    return TabBar(
        labelColor: AppColors.PRIMARY_COLOR,
        indicatorColor: Colors.red,
        onTap: (index) {
          if (context.read<UserCubit>().isLoggedIn) {
            context.read<ChatsCubit>().getChats(index: index);

            // if this locked chat we request password
            if (index == 8) {
              showDialogToConfirmChatLockPassword(context);
            }
          }
        },
        tabAlignment: TabAlignment.start,
        isScrollable: true,
        tabs: groups.map((e) {
          return Tab(
            // text: 'there was error here look at code and solve it',
            // text: chatCubit.selectedTabIndex == groups.indexOf(e)
            //     ? unReadMessages == 0
            //         ? e
            //         : "$e($unReadMessages)"
            //     : error,
            text:e
          );
        }).toList());
  }

  Widget _buildCategoriesViews() {
    return TabBarView(children: [
      _buildCategoryChats(),
      _buildCategoryChats(),
      _buildCallingHistory(isVideo: false),
      _buildCallingHistory(isVideo: true),
      _buildCallingHistory(isVideo: false),
      _buildCallingHistory(isVideo: true),
      _buildCategoryChats(isSecret: true),
      _buildCategoryChats(),
      _buildCategoryChats(),
      _buildCategoryChats(),
      _buildCategoryChats(),
    ]);
  }

  Widget _buildCategoryChats({bool isSecret = false}) {
    return BlocBuilder<ChatsCubit, ChatsState>(builder: (context, state) {
      return state.chats == null || state.isLoading
          ? LoadingCustom.customThreeBounce(context)
          : state.chats?.length == 0
              ? Center(
                  child: Label(
                      text: 'No Chats until now',
                      style: Styles.mediumText(
                          fontWeight: FontWeight.bold, fontSize: 18)),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) => Slidable(
                    key: ValueKey(index),
                    closeOnScroll: false,
                    endActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      dismissible: DismissiblePane(onDismissed: () {}),
                      children: [
                        SlidableAction(
                          onPressed: (value) {
                            bottomSheet(
                                backColor:
                                    Theme.of(context).scaffoldBackgroundColor,
                                context: context,
                                isScrollControlled: true,
                                widget: MoreIconBottomSheet(
                                  chatItemModel: state.chats![index],
                                  chatsCubit: chatCubit,
                                ));
                          },
                          backgroundColor:
                              const Color.fromARGB(255, 191, 191, 191),
                          foregroundColor: Colors.white,
                          icon: Icons.more_horiz,
                          label: 'More',
                          padding: EdgeInsets.zero,
                        ),
                        SlidableAction(
                          onPressed: (value) async {
                            chatCubit.changeChatToArchiveOrNormalUseCase(
                                state.chats![index].sId!);
                          },
                          backgroundColor: AppColors.PRIMARY_COLOR,
                          foregroundColor: Colors.white,
                          icon: Icons.delete_outlined,
                          label: state.chats![index].archived!
                              ? 'Unarchive'
                              : 'Archive',
                          padding: EdgeInsets.zero,
                        ),
                      ],
                    ),
                    child: ChatCard(
                      isSecret: isSecret,
                      chatItemModel: state.chats?[index],
                      chatsCubit: chatCubit,
                    ),
                  ),
                  separatorBuilder: (context, index) => const SizedBox(),
                  itemCount: state.chats?.length ?? 0,
                );
    });
  }

  Widget _buildCallingHistory({required bool isVideo}) {
    return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) => CallingCard(
              isVideo: isVideo,
            ),
        separatorBuilder: (context, index) => const SizedBox(),
        itemCount: 8);
  }

  Future<bool?> showDialogToConfirmChatLockPassword(
      BuildContext context) async {
    TextEditingController passwordController = TextEditingController(text: '');
    return await showDialog(
      context: context,
      builder: ((context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            title: Label(
                text: 'Lock chats password please',
                style: Styles.headerText(
                    fontWeight: FontWeight.bold, color: Colors.black)),
            content: Material(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 100.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FormTextField(
                        controller: passwordController,
                        hint: 'password',
                        type: TextInputType.number,
                        style: const TextStyle(
                            fontSize: 20,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold),
                        action: (v) => () {}),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () async {
                    chatCubit.getChats(
                        index: 8, password: passwordController.text.trim());
                    Navigator.of(context).pop(false);
                  },
                  child: const Text('Confirm password')),
            ],
          )),
    );
  }
}
