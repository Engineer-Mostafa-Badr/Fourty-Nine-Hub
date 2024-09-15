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

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fourtyninehub/common/widgets/stateless/appbar/nested_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/enums/chat_categories.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/states/basic_state.dart';
import 'package:fourtyninehub/features/authentication/domain/entities/user_entity.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/chat/broadcasts/presentation/widgets/my_broadcast_card.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/presentation/chat_cubit/chats_cubit.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/presentation/widgets/chat_stories.dart';
import 'package:fourtyninehub/features/social_media/chat/broadcasts/presentation/widgets/follow_broadcast_card.dart';
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

class _ChatViewState extends State<ChatView> with TickerProviderStateMixin {
  late ChatsCubit chatCubit;
  late TabController tabController;

  @override
  void initState() {
    chatCubit = context.read<ChatsCubit>()..init();
    tabController =
        TabController(length: ChatCategories.values.length, vsync: this)
          ..addListener(() {
            if (tabController.previousIndex != tabController.index) {
              chatCubit.getChatsByCategory(
                  ChatCategories.values[tabController.index]);
            }
          });
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: ChatCategories.values.length,
      initialIndex: widget.initialTabIndex,
      child: SharedScaffold(
        floatingActionButton: context.read<UserCubit>().isLoggedIn
            ? FloatingActionButton(
                onPressed: () {
                  context.push(Routes.CONTACTSVIEW);
                },
                tooltip: LocaleKeys.contacts.tr(),
                backgroundColor: AppColors.PRIMARY_COLOR,
                child: const Icon(
                  Icons.contacts,
                  color: Colors.white,
                ),
              )
            : null,
        mainCategoryId: 2,
        body: NestedAppbar(
          scrollController: ScrollController(),
          appBars: [
            SliverAppBar(
              automaticallyImplyLeading: false,
              floating: true,
              flexibleSpace: BlocProvider.value(
                value: serviceLocator<StoryCubit>()..fetchStories(),
                child: BlocBuilder<ChatsCubit, ChatsState>(
                  builder: (context, state) {
                    return context.read<UserCubit>().isLoggedIn
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                child: Text(
                                  context
                                          .read<ChatsCubit>()
                                          .selectedChats
                                          .isNotEmpty
                                      ? "${context.read<ChatsCubit>().selectedChats.length} ${LocaleKeys.selected.tr()}"
                                      : "",
                                  style: Styles.mediumText(
                                      color: AppColors.PRIMARY_COLOR),
                                ),
                              ),
                              const Spacer(),
                              context.read<ChatsCubit>().selectedChats.isEmpty
                                  ? const SizedBox.shrink()
                                  : Row(
                                      children: [
                                        IconButton(
                                          onPressed: () {},
                                          icon: const Icon(Icons.push_pin),
                                          color: AppColors.PRIMARY_COLOR,
                                        ),
                                        IconButton(
                                          onPressed: () {},
                                          icon: const Icon(
                                            Icons.delete_forever,
                                            color: AppColors.PRIMARY_COLOR,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {},
                                          icon: const Icon(
                                            Icons.notifications_off,
                                            color: AppColors.PRIMARY_COLOR,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {},
                                          icon: const Icon(
                                            Icons.archive,
                                            color: AppColors.PRIMARY_COLOR,
                                          ),
                                        ),
                                      ],
                                    ),
                              context.read<ChatsCubit>().selectedChats.isEmpty
                                  ? PopupMenuButton(
                                      icon: const Icon(
                                        Icons.more_vert,
                                        color: AppColors.PRIMARY_COLOR,
                                      ),
                                      color: AppColors.BACKGROUND_COLOR,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(16.0)),
                                      ),
                                      offset: const Offset(0, 50),
                                      onSelected: (int value) async {
                                        if (value == 4) {
                                          context.push(Routes.CHATPROFILEVIEW);
                                        }
                                      },
                                      itemBuilder: (context) {
                                        return _mainMenuBuilder();
                                      },
                                    )
                                  : PopupMenuButton(
                                      icon: const Icon(
                                        Icons.more_vert,
                                        color: AppColors.PRIMARY_COLOR,
                                      ),
                                      color: AppColors.BACKGROUND_COLOR,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(16.0)),
                                      ),
                                      offset: const Offset(0, 50),
                                      onSelected: (int value) async {},
                                      itemBuilder: (context) {
                                        return [
                                          PopupMenuItem<int>(
                                            value: 0,
                                            child: Text(
                                              LocaleKeys.addShortcut.tr(),
                                              style: Styles.mediumText(
                                                  color:
                                                      AppColors.PRIMARY_COLOR),
                                            ),
                                          ),
                                          PopupMenuItem<int>(
                                            value: 0,
                                            child: Text(
                                              LocaleKeys.markAsUnread.tr(),
                                              style: Styles.mediumText(
                                                  color:
                                                      AppColors.PRIMARY_COLOR),
                                            ),
                                          ),
                                          PopupMenuItem<int>(
                                            value: 0,
                                            child: Text(
                                              LocaleKeys.selectAll.tr(),
                                              style: Styles.mediumText(
                                                  color:
                                                      AppColors.PRIMARY_COLOR),
                                            ),
                                          ),
                                          PopupMenuItem<int>(
                                            value: 0,
                                            child: Text(
                                              LocaleKeys.lockChat.tr(),
                                              style: Styles.mediumText(
                                                  color:
                                                      AppColors.PRIMARY_COLOR),
                                            ),
                                          ),
                                        ];
                                      },
                                    ),
                            ],
                          )
                        : const SizedBox.shrink();
                  },
                ),
              ),
            ),
            SliverAppBar(
              expandedHeight: MediaQuery.of(context).size.height *
                  0.15, // Responsive height
              automaticallyImplyLeading: false,
              floating: true,
              flexibleSpace: BlocProvider(
                create: (context) =>
                    serviceLocator<StoryCubit>()..fetchStories(),
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
                      child: SingleChildScrollView(
                        child: GestureDetector(
                          onTap: () => context.push(Routes.LOGIN),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            width: 300,
                            height: 300,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Theme.of(context).primaryColor,
                                width: 4,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                LocaleKeys.pleaseLoginRegisterToEnjoyTheApp
                                    .tr(),
                                style: Styles.headerText(
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
              // Center(
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         GestureDetector(
              //           onTap: () => context.push(Routes.LOGIN),
              //           child: Label(
              //             text: 'Login',
              //             style: Styles.headerText(
              //                 color: AppColors.PRIMARY_COLOR_DARK),
              //           ),
              //         ),
              //         Label(
              //             text: ', To continue in using chat services',
              //             style: Styles.headerText()),
              //       ],
              //     ),
              //   );
            },
          ),
        ),
      ),
    );
  }

  List<PopupMenuEntry<int>> _mainMenuBuilder() {
    return [
      PopupMenuItem<int>(
        value: 0,
        child: Text(
          LocaleKeys.newGroup.tr(),
          style: Styles.mediumText(color: AppColors.PRIMARY_COLOR),
        ),
      ),
      PopupMenuItem<int>(
        value: 1,
        child: Text(
          LocaleKeys.newBroadcast.tr(),
          style: Styles.mediumText(color: AppColors.PRIMARY_COLOR),
        ),
      ),
      PopupMenuItem<int>(
        value: 2,
        child: Text(
          LocaleKeys.linkedDevice.tr(),
          style: Styles.mediumText(color: AppColors.PRIMARY_COLOR),
        ),
      ),
      PopupMenuItem<int>(
        value: 3,
        child: Text(
          LocaleKeys.starredMessages.tr(),
          style: Styles.mediumText(color: AppColors.PRIMARY_COLOR),
        ),
      ),
      PopupMenuItem<int>(
        value: 4,
        child: Text(
          LocaleKeys.profile.tr(),
          style: Styles.mediumText(color: AppColors.PRIMARY_COLOR),
        ),
      ),
    ];
  }

  Widget _buildCategoriesLabels() {
    return TabBar(
        controller: tabController,
        labelColor: AppColors.PRIMARY_COLOR,
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
      case ChatCategories.service:
      case ChatCategories.groups:
      case ChatCategories.greet:
      case ChatCategories.unread:
      case ChatCategories.archived:
      case ChatCategories.anonymous:
        return _buildCategoryChats();
      case ChatCategories.socialCalls:
      case ChatCategories.serviceCalls:
        return _buildCallingHistory(isVideo: false);
      case ChatCategories.locked:
        return _buildCategoryChats(isSecret: true);
      case ChatCategories.broadcast:
        return buildBroadcast();
    }
  }

  Widget _buildCategoryChats({bool isSecret = false}) {
    return BlocBuilder<ChatsCubit, ChatsState>(builder: (context, state) {
      return state.chats == null || state.isLoading
          ? const Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : state.chats!.isEmpty
              ? Center(
                  child: Label(
                      text: LocaleKeys.noChatsUntilNow.tr(),
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
                            // bottomSheet(
                            //     backColor:
                            //         Theme.of(context).scaffoldBackgroundColor,
                            //     context: context,
                            //     isScrollControlled: true,
                            //     widget: MoreIconBottomSheet(
                            //       ChatCategoryEntity: state.chats![index],
                            //       chatsCubit: chatCubit,
                            //     ));
                          },
                          backgroundColor:
                              const Color.fromARGB(255, 191, 191, 191),
                          foregroundColor: Colors.white,
                          icon: Icons.more_horiz,
                          label: LocaleKeys.more.tr(),
                          padding: EdgeInsets.zero,
                        ),
                        SlidableAction(
                          onPressed: (value) async {},
                          backgroundColor: AppColors.PRIMARY_COLOR,
                          foregroundColor: Colors.white,
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
                  "Broadcasts",
                  style: Styles.mediumText(fontWeight: FontWeight.w600),
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  context.push(Routes.SEEALLBROADCASTS);
                },
                child: Text(
                  "See all",
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
              "My Broadcasts",
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
