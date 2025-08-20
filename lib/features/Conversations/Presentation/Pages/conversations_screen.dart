import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/features/Conversations/Presentation/Pages/Widgets/chat_card.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/widgets/dialogs/please_login_dialog.dart';
import '../../../../common/widgets/stateless/appbar/home_appbar.dart';
import '../../../../common/widgets/stateless/appbar/nested_appbar.dart';
import '../../../../common/widgets/stateless/labels/label.dart';
import '../../../../core/localization/locale_keys.g.dart';
import '../../../../core/widget/custom_scaffold.dart';
import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';
import '../../../../routes/routes.dart';
import '../../../../service_locator/service_locator.dart';
import '../../../social_media/chat/chat_view/presentation/widgets/calling_card.dart';
import '../../../social_media/chat/chat_view/presentation/widgets/chat_stories.dart';
import '../../../social_media/chat/chat_view/presentation/widgets/end_to_end_Encrypted_widget.dart';
import '../../../social_media/chat/chat_view/presentation/widgets/new_chat_card.dart';
import '../../../social_media/stories/presentation/cubit/stories_cubit.dart';

class ConversationsScreen extends StatefulWidget {
  const ConversationsScreen({super.key});

  @override
  State<ConversationsScreen> createState() => _ConversationsScreenState();
}

class _ConversationsScreenState extends State<ConversationsScreen> with TickerProviderStateMixin {
  late TabController tabController;
  bool expandedOptions = false;
  late ScrollController scrollController;
  double lastOffset = 0.0;

  @override
  void initState() {

    tabController =
    TabController(length: 4, vsync: this)
      ..addListener(() {
        if (tabController.previousIndex != tabController.index) {
          // chatsCubit.getChatsByCategory(
          //     ChatCategories.values[tabController.index]);
          setState(() {

          });
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
    return CustomScaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          // context.read<ChatsCubit>().selectedChats.isEmpty ? 40 : 0,
            40
        ),
        child: Builder(
          builder: (context) {
            // if (context.read<ChatsCubit>().selectedChats.isEmpty) {
              return HomeAppbar(
                isHaveLeading: false,
                isWithBackArrow: true,
                inChat: PopupMenuButton(
                  icon: Icon(
                    Icons.more_vert,
                    color: context.isDarkMode
                        ? Colors.white
                        : AppColors.PRIMARY_COLOR,
                  ),
                  color: context.isDarkMode
                      ? AppColors.QUANTITY_COLOR
                      : AppColors.BACKGROUND_COLOR,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  offset: const Offset(0, 50),
                  onSelected: (int value) async {
                    if (value == 2) {
                      // context.push(Routes.CHATPROFILEVIEW);
                    }
                    if (value == 1) {
                      // await context
                      //     .read<ChatsCubit>()
                      //     .recoverDeletedChats();
                    }
                  },
                  itemBuilder: (context) {
                    return _mainMenuBuilder();
                  },
                ),
              );
            // } else {
            //   return Container();
            // }
          },
        ),
      ),
      body: SafeArea(
        child: DefaultTabController(
          length: 4,
          initialIndex: 0,
          child: NestedAppbar(
            scrollController:
            scrollController, // Attach the ScrollController here
            appBars: [
              // if (context.read<ChatsCubit>().selectedChats.isNotEmpty)
              //   _selectedChatAppBar(chatsCubit),
              SliverAppBar(
                expandedHeight: MediaQuery.of(context).size.height *
                    0.1, // Responsive height
                automaticallyImplyLeading: false,
                floating: true,
                flexibleSpace: BlocProvider(
                  create: (context) => serviceLocator<StoryCubit>()
                    ..fetchStories()
                    ..getMutedStories(),
                  child: const Directionality(
                    textDirection: TextDirection.ltr,
                    child: ChatStories(),
                  ),
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
            body: context.isUserLoggedIn
              ? _buildCategoriesViews()
              : Center(
        child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
                onTap: () {
                  return pleaseLoginDialog(context);
                  // context.push(Routes.LOGIN);
                },
                child: Label(
                  text: LocaleKeys.login.localize,
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
              text: LocaleKeys
                  .continueUsingChatServices.localize,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: context.isDarkMode
                    ? Colors.white
                    : Colors.black,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
          ),
        ),
      ),
    );
  }

  List<PopupMenuEntry<int>> _mainMenuBuilder() {
    return [
      // PopupMenuItem<int>(
      //   value: 0,
      //   child: Text(
      //     LocaleKeys.newGroup.localize,
      //     style: Styles.mediumText(
      //         color:
      //             context.isDarkMode ? Colors.white : AppColors.PRIMARY_COLOR),
      //   ),
      // ),
      // PopupMenuItem<int>(
      //   value: 1,
      //   child: Text(
      //     LocaleKeys.newBroadcast.localize,
      //     style: Styles.mediumText(
      //         color:
      //             context.isDarkMode ? Colors.white : AppColors.PRIMARY_COLOR),
      //   ),
      // ),
      PopupMenuItem<int>(
        value: 0,
        child: Label(
          text: context.isArabic ? "الرسائل المميزة" : "Starred Messages",
          style: Styles.mediumText(
            fontSize: 32,
            color: context.isDarkMode ? Colors.white : AppColors.PRIMARY_COLOR,
          ),
        ),
      ),
      PopupMenuItem<int>(
        value: 1,
        child: Label(
          text: LocaleKeys.recoverDeletedChats.localize,
          style: Styles.mediumText(
            fontSize: 32,
            color: context.isDarkMode ? Colors.white : AppColors.PRIMARY_COLOR,
          ),
        ),
      ),
      PopupMenuItem<int>(
        value: 2,
        child: Label(
          text: LocaleKeys.profile.localize,
          style: Styles.mediumText(
            fontSize: 32,
            color: context.isDarkMode ? Colors.white : AppColors.PRIMARY_COLOR,
          ),
        ),
      ),
    ];
  }

  // Widget _buildCategoriesLabels() {
  //   return TabBar(
  //       controller: tabController,
  //       labelColor: context.isDarkMode ? Colors.white : AppColors.PRIMARY_COLOR,
  //       unselectedLabelColor: AppColors.LIGHT_GRAY_COLOR2,
  //       indicatorColor: Colors.red,
  //       tabAlignment: TabAlignment.start,
  //       isScrollable: true,
  //       tabs: ChatCategories.values.map((e) {
  //         return Tab(text: e.name.localize);
  //       }).toList());
  // }

  Widget _buildCategoriesLabels() {
    return SizedBox(
      height: 33,
      child: TabBar(
        controller: tabController,
        // labelColor: AppColors.PRIMARY_COLOR,
        dividerColor: Colors.transparent,
        // unselectedLabelColor: AppColors.LIGHT_GRAY_COLOR2,
        indicator: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.1), // Light red background
          borderRadius: BorderRadius.circular(8), // Rounded corners
        ),
        tabAlignment: TabAlignment.start,
        isScrollable: true,
        tabs:
        [
          Tab(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Text(
                context.isArabic ? "اجتماعي" : "Social",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: tabController.index == 0
                      ? Colors.red
                      : AppColors.LIGHT_GRAY_COLOR2,
                ),
              ),
            ),
          ),
          Tab(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Text(
                context.isArabic ? "خدمات" : "Services",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: tabController.index == 1
                      ? Colors.red
                      : AppColors.LIGHT_GRAY_COLOR2,
                ),
              ),
            ),
          ),
          Tab(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Text(
                context.isArabic? "غير مقروءة" : "Unread",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: tabController.index == 2
                      ? Colors.red
                      : AppColors.LIGHT_GRAY_COLOR2,
                ),
              ),
            ),
          ),
          Tab(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Text(
                context.isArabic? "الاتصالات" : "Calls",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: tabController.index == 3
                      ? Colors.red
                      : AppColors.LIGHT_GRAY_COLOR2,
                ),
              ),
            ),
          )
        ],
        // ChatCategories.values.map((e) {
        //   return Tab(
        //     child: Padding(
        //       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        //       child: Text(
        //         e.name.localize,
        //         style: TextStyle(
        //           fontWeight: FontWeight.bold,
        //           color: e == ChatCategories.values[tabController.index]
        //               ? Colors.red
        //               : AppColors.LIGHT_GRAY_COLOR2,
        //         ),
        //       ),
        //     ),
        //   );
        // }).toList(),
      ),
    );
  }

  Widget _buildCategoriesViews() {
    // return TabBarView(
    //     controller: tabController,
    //     children: ChatCategories.values
    //         .map((e) => _chatCategoryWidgetMapper(e))
    //         .toList());
    return TabBarView(
      controller: tabController,
      children: [
        _chatCategoryWidgetMapper("social"),
        _chatCategoryWidgetMapper("services"),
        _chatCategoryWidgetMapper("unread"),
        _chatCategoryWidgetMapper("calls"),
      ],
    );
  }

  Widget _chatCategoryWidgetMapper(String chatType) {
    switch (chatType) {
      case "social":
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
                      ? FontAwesomeIcons.anglesUp
                      : FontAwesomeIcons.anglesDown,
                  color: context.isDarkMode ? Colors.white38 : Colors.black38,
                  size: 18,
                ),
              ),
            ),
            ChatOptions(
              icon: Icons.archive_outlined,
              text: context.isArabic ? "المؤرشفة" : "Archived",
              onTap: () async {
                // final result = await context.push(Routes.ARCHIVEDCHATS,
                //     extra: OptionsChatsViewParams(
                //       category: 'Archive',
                //       chatsCubit: chatsCubit,
                //       isSecret: false,
                //     ));
                //
                // // Check if the result is true, refresh the home page
                // if (result == true) {
                //   log("pop");
                //   await chatsCubit.getChatsByCategory(ChatCategories.social);
                //   setState(() {});
                // }
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
                icon: Icons.mail_lock_outlined,
                text: context.isArabic
                    ? "الدردشات المغلقة"
                    : "Locked chats",
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
                  // await lockedChatsOnTap();
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
                icon: Icons.person_off_outlined,
                text: LocaleKeys.anonymous.localize,
                onTap: () async {
                  // final result = await context.push(Routes.ARCHIVEDCHATS,
                  //     extra: OptionsChatsViewParams(
                  //       category: ChatCategoriesIds.anonymous,
                  //       chatsCubit: chatsCubit,
                  //       isSecret: false,
                  //     ));
                  //
                  // // Check if the result is true, refresh the home page
                  // if (result == true) {
                  //   log("pop");
                  //   await chatsCubit
                  //       .getChatsByCategory(ChatCategories.social);
                  //   setState(() {});
                  // }
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
                text: LocaleKeys.greet.localize,
                onTap: () async {
                  // final result = await context.push(Routes.ARCHIVEDCHATS,
                  //     extra: OptionsChatsViewParams(
                  //       category: ChatCategoriesIds.greet,
                  //       chatsCubit: chatsCubit,
                  //       isSecret: false,
                  //     ));
                  //
                  // // Check if the result is true, refresh the home page
                  // if (result == true) {
                  //   log("pop");
                  //   await chatsCubit
                  //       .getChatsByCategory(ChatCategories.social);
                  //   setState(() {});
                  // }
                },
              )
                  : const SizedBox.shrink(),
            ),
            // const Divider(),
            _buildCategoryChats(),

            const MessagesAreEndToEndEncrypted(),
          ],
        );
      case "services":
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
                      ? FontAwesomeIcons.anglesUp
                      : FontAwesomeIcons.anglesDown,
                  color: context.isDarkMode ? Colors.white38 : Colors.black38,
                  size: 18,
                ),
              ),
            ),
            ChatOptions(
              icon: Icons.archive_outlined,
              text: context.isArabic ? "المؤرشفة" : "Archived",
              onTap: () async {
                // final result = await context.push(Routes.ARCHIVEDCHATS,
                //     extra: OptionsChatsViewParams(
                //       category: 'Archive',
                //       chatsCubit: chatsCubit,
                //       isSecret: false,
                //     ));
                //
                // // Check if the result is true, refresh the home page
                // if (result == true) {
                //   log("pop");
                //   await chatsCubit.getChatsByCategory(ChatCategories.service);
                //   setState(() {});
                // }
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
                icon: Icons.mail_lock_outlined,
                text: context.isArabic
                    ? "الدردشات المغلقة"
                    : "Locked chats",
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
                  // await lockedChatsOnTap();
                },
              )
                  : const SizedBox.shrink(),
            ),
            // const Divider(),
            _buildCategoryChats(),
            const MessagesAreEndToEndEncrypted(),
          ],
        );
    // case ChatCategories.groups:
      case "unread":
        return Column(
          children: [
            _buildCategoryChats(),
            const MessagesAreEndToEndEncrypted(),
          ],
        );
      case "calls":
        return _buildCallingHistory(isVideo: false);
      default:
        return SizedBox();
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

  // Future<void> lockedChatsOnTap() async {
  //   final LocalAuthentication auth = LocalAuthentication();
  //
  //   // Check if local authentication is available
  //   bool isAvailable =
  //       await auth.canCheckBiometrics || await auth.isDeviceSupported();
  //
  //   if (isAvailable) {
  //     try {
  //       // Attempt to authenticate the user
  //       bool didAuthenticate = await auth.authenticate(
  //         localizedReason: context.isArabic
  //             ? 'تحقق من البصمة للوصول إلى المحادثات المغلقة'
  //             : 'Please authenticate to access locked chats',
  //         // options: const AuthenticationOptions(
  //         //   biometricOnly: true,
  //         //   stickyAuth: true,
  //         // ),
  //       );
  //
  //       if (didAuthenticate) {
  //         // User authenticated successfully
  //         final result = await context.push(
  //           Routes.ARCHIVEDCHATS,
  //           extra: OptionsChatsViewParams(
  //             category: 'LockedChats',
  //             chatsCubit: chatsCubit,
  //             isSecret: true,
  //           ),
  //         );
  //
  //         // Check if the result is true, refresh the home page
  //         if (result == true) {
  //           log("pop");
  //           await chatsCubit.getChatsByCategory(ChatCategories.social);
  //           setState(() {});
  //         }
  //       } else {
  //         log("Authentication failed");
  //       }
  //     } catch (e) {
  //       log("Error during authentication: $e");
  //     }
  //   } else {
  //     log("Local authentication not available on this device.");
  //   }
  // }

  Widget _buildCategoryChats({bool isSecret = false}) {
    return Expanded(
      child: Scrollbar(
        // isAlwaysShown: true,  // Ensures the scrollbar is always visible
        interactive: true,
        thumbVisibility: true,
        thickness: 3,
        child: ListView.separated(
          shrinkWrap: false,
          physics: const AlwaysScrollableScrollPhysics(),
          // Enable scrolling
          itemBuilder: (context, index) =>  Slidable(
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
                  label: LocaleKeys.more.localize,
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
                  label: LocaleKeys.archive.localize,
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
            child: ChatCard(
              isSecret: isSecret,
            ),
          ),
          separatorBuilder: (context, index) {
            return const SizedBox();
            // return Padding(
            //   padding:
            //   const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4),
            //   child: Divider(
            //     thickness: 1,
            //     color:context.isDarkMode ? Colors.white12 : Colors.black12,
            //     height: 5,
            //   ),
            // );
          },
          itemCount: 20,
        ),
      ),
    );
  }

  Widget _buildCallingHistory({required bool isVideo}) {
    return DefaultTabController(
      length: 2, // Two tabs: Social and Services
      child: Column(
        mainAxisSize: MainAxisSize.min,
        // Keeps the height minimal for alignment
        children: [
          // Centered Tab Bar for Social and Services
          SizedBox(
            height: 33,
            child: Align(
              alignment: Alignment.center,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                // Adjust padding as needed
                // constraints: const BoxConstraints(maxWidth: 300), // Controls width for centering
                child: TabBar(
                  dividerColor: Colors.transparent,
                  labelPadding: const EdgeInsets.symmetric(horizontal: 32),
                  indicator: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    // Light red background for selected tab
                    borderRadius: BorderRadius.circular(12), // Rounded corners
                  ),
                  labelColor: Colors.red,
                  unselectedLabelColor: AppColors.LIGHT_GRAY_COLOR2,
                  isScrollable: false,
                  tabs: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                      ),
                      child: Tab(text: LocaleKeys.social.localize),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                      ),
                      child: Tab(text: LocaleKeys.services.localize),
                    ),
                  ],
                ),
              ),
            ),
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
                      CallingCard(isVideo: index.isEven),
                  separatorBuilder: (context, index) => const SizedBox(),
                  itemCount: 8,
                ),
                // Services tab: Show voice calls
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) =>
                      CallingCard(isVideo: index.isEven),
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

  // Widget buildBroadcast() {
  //   return SingleChildScrollView(
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         // Follow Section
  //         Row(
  //           children: [
  //             Padding(
  //               padding: const EdgeInsets.all(16),
  //               child: Text(
  //                 LocaleKeys.broadcasts.localize,
  //                 style: Styles.mediumText(fontWeight: FontWeight.w600),
  //               ),
  //             ),
  //             const Spacer(),
  //             TextButton(
  //               onPressed: () {
  //                 context.push(Routes.SEEALLBROADCASTS);
  //               },
  //               child: Text(
  //                 LocaleKeys.seeAll.localize,
  //                 style: Styles.smallText(
  //                   color: AppColors.PRIMARY_COLOR_DARK,
  //                   fontSize: 24,
  //                 ),
  //               ),
  //             ),
  //             const SizedBox(
  //               width: 16,
  //             )
  //           ],
  //         ),
  //         SizedBox(
  //           height: 160, // Set the height for the horizontal list view
  //           child: ListView(
  //             scrollDirection:
  //             Axis.horizontal, // Makes the list scroll horizontally
  //             children: const [
  //               FollowBroadcastCard(
  //                 'FC Barcelona',
  //                 'https://www.hyperakt.com/assets/images/fc-barcelona/Barcelona.jpg',
  //               ),
  //               FollowBroadcastCard(
  //                 'BBC News',
  //                 'https://seeklogo.com/images/B/bbc-news-logo-8648ABD044-seeklogo.com.png',
  //               ),
  //               FollowBroadcastCard(
  //                 'Real Madrid FC',
  //                 'https://images.alphacoders.com/116/thumb-1920-1163534.jpg',
  //               ),
  //               FollowBroadcastCard(
  //                 'FC Barcelona',
  //                 'https://www.hyperakt.com/assets/images/fc-barcelona/Barcelona.jpg',
  //               ),
  //               FollowBroadcastCard(
  //                 'BBC News',
  //                 'https://seeklogo.com/images/B/bbc-news-logo-8648ABD044-seeklogo.com.png',
  //               ),
  //               FollowBroadcastCard(
  //                 'Real Madrid FC',
  //                 'https://images.alphacoders.com/116/thumb-1920-1163534.jpg',
  //               ),
  //             ],
  //           ),
  //         ),
  //         Padding(
  //           padding: const EdgeInsets.only(left: 16, top: 24, right: 16),
  //           child: Text(
  //             LocaleKeys.myBroadcasts.localize,
  //             style: Styles.mediumText(fontWeight: FontWeight.w600),
  //           ),
  //         ),
  //         ListView.separated(
  //           itemCount: 10,
  //           separatorBuilder: (context, index) {
  //             return const Divider(
  //               color: Colors.grey,
  //             );
  //           },
  //           shrinkWrap: true,
  //           itemBuilder: (context, index) {
  //             return const MyBroadcastsCard();
  //           },
  //           physics: const NeverScrollableScrollPhysics(),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}

// _selectedChatAppBar(ChatsCubit chatsCubit) {
//   return SliverAppBar(
//     automaticallyImplyLeading: false,
//     floating: true,
//     flexibleSpace: BlocBuilder<ChatsCubit, ChatsState>(
//       builder: (context, state) {
//         return context.read<UserCubit>().isLoggedIn
//             ? SizedBox(
//           // height: 20,
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               context.read<ChatsCubit>().selectedChats.isNotEmpty
//                   ? IconButton(
//                   onPressed: () {
//                     context.read<ChatsCubit>().clearSelectedChats();
//                   },
//                   icon: const Icon(Icons.arrow_back))
//                   : const SizedBox(),
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 16.w),
//                 child: Text(
//                   "${context.read<ChatsCubit>().selectedChats.length}",
//                   style: Styles.mediumText(
//                       color: context.isDarkMode
//                           ? Colors.white
//                           : AppColors.PRIMARY_COLOR),
//                 ),
//               ),
//               const Spacer(),
//               Row(
//                 children: [
//                   IconButton(
//                     onPressed: () async {
//                       await context.read<ChatsCubit>().pinAndUnpinChat();
//                     },
//                     icon: const Icon(Icons.push_pin_outlined),
//                     color: context.isDarkMode
//                         ? Colors.white
//                         : AppColors.PRIMARY_COLOR,
//                   ),
//                   IconButton(
//                     onPressed: () async {
//                       await context.read<ChatsCubit>().deleteChat();
//                     },
//                     icon: Icon(
//                       Icons.delete_forever_outlined,
//                       color: context.isDarkMode
//                           ? Colors.white
//                           : AppColors.PRIMARY_COLOR,
//                     ),
//                   ),
//                   IconButton(
//                     onPressed: () async {
//                       await context.read<ChatsCubit>().changeMuteChat();
//                     },
//                     icon: Icon(
//                       Icons.notifications_off_outlined,
//                       color: context.isDarkMode
//                           ? Colors.white
//                           : AppColors.PRIMARY_COLOR,
//                     ),
//                   ),
//                   IconButton(
//                     onPressed: () async {
//                       await context
//                           .read<ChatsCubit>()
//                           .changeArchiveChat(isArchivedTab: false);
//                       final archivedChatsCount =
//                           chatsCubit.selectedChats.length;
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(
//                           backgroundColor: const Color(0xff1A1A1A),
//                           // Set background color to blue
//                           content: BlocProvider.value(
//                             value: context.read<ChatsCubit>(),
//                             child: Builder(
//                               builder: (context) {
//                                 return Text.rich(
//                                   TextSpan(
//                                     children: [
//                                       TextSpan(
//                                         text: context.isArabic
//                                             ? "تم أرشفة "
//                                             : "Archived ",
//                                         style: const TextStyle(
//                                           color: Colors.white,
//                                           fontSize: 16,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                       TextSpan(
//                                         text: "$archivedChatsCount ",
//                                         // العدد
//                                         style: const TextStyle(
//                                           color: Colors.white,
//                                           fontWeight: FontWeight.bold,
//                                           fontSize: 16,
//                                         ),
//                                       ),
//                                       TextSpan(
//                                         text: context.isArabic
//                                             ? "محادثة"
//                                             : "chats",
//                                         style: const TextStyle(
//                                           color: Colors.white,
//                                           fontSize: 16,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 );
//                               },
//                             ),
//                           ),
//                           action: SnackBarAction(
//                             label: context.isArabic ? "تراجع" : "UNDO",
//                             textColor: AppColors.PRIMARY_COLOR_DARK,
//                             // Set "Undo" text color to gray
//                             onPressed: () async {
//                               await context
//                                   .read<ChatsCubit>()
//                                   .changeArchiveChat(
//                                   isArchivedTab: false);
//                             },
//                           ),
//                           duration: const Duration(seconds: 3),
//                         ),
//                       );
//
//                       Future.delayed(const Duration(seconds: 3), () {
//                         context.read<ChatsCubit>().clearSelectedChats();
//                       });
//                     },
//                     icon: Icon(
//                       Icons.archive_outlined,
//                       color: context.isDarkMode
//                           ? Colors.white
//                           : AppColors.PRIMARY_COLOR,
//                     ),
//                   ),
//                 ],
//               ),
//               PopupMenuButton(
//                 icon: Icon(
//                   Icons.more_vert,
//                   color: context.isDarkMode
//                       ? Colors.white
//                       : AppColors.PRIMARY_COLOR,
//                 ),
//                 color: context.isDarkMode
//                     ? AppColors.PRIMARY_COLOR
//                     : AppColors.BACKGROUND_COLOR,
//                 shape: const RoundedRectangleBorder(
//                   borderRadius: BorderRadius.all(Radius.circular(16.0)),
//                 ),
//                 offset: const Offset(0, 50),
//                 onSelected: (int value) async {
//                   if (value == 3) {
//                     // await context
//                     //     .read<ChatsCubit>()
//                     //     .lockChats(
//                     //         isLockedTap: false);
//                     await context
//                         .read<ChatsCubit>()
//                         .lockChats(isLockedTap: false);
//                     final unlockedChatsCount =
//                         chatsCubit.selectedChats.length;
//
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(
//                         backgroundColor: const Color(0xff1A1A1A),
//                         // Set background color
//                         content: BlocProvider.value(
//                           value: context.read<ChatsCubit>(),
//                           child: Builder(
//                             builder: (context) {
//                               return Text.rich(
//                                 TextSpan(
//                                   children: [
//                                     TextSpan(
//                                       text: context.isArabic
//                                           ? "تم قفل "
//                                           : "Locked ",
//                                       style: const TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                     TextSpan(
//                                       text: "$unlockedChatsCount ",
//                                       // Count
//                                       style: const TextStyle(
//                                         color: Colors.white,
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 16,
//                                       ),
//                                     ),
//                                     TextSpan(
//                                       text: context.isArabic
//                                           ? "محادثة"
//                                           : "chats",
//                                       style: const TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                         action: SnackBarAction(
//                           label: context.isArabic ? "تراجع" : "UNDO",
//                           textColor: AppColors.PRIMARY_COLOR_DARK,
//                           // Set "Undo" text color to gray
//                           onPressed: () async {
//                             await context
//                                 .read<ChatsCubit>()
//                                 .lockChats(isLockedTap: false);
//                           },
//                         ),
//                         duration: const Duration(seconds: 3),
//                       ),
//                     );
//
//                     Future.delayed(const Duration(seconds: 3), () {
//                       context.read<ChatsCubit>().clearSelectedChats();
//                     });
//                   }
//                 },
//                 itemBuilder: (context) {
//                   return [
//                     // PopupMenuItem<int>(
//                     //   value: 0,
//                     //   child: Text(
//                     //     LocaleKeys.addShortcut
//                     //         .localize,
//                     //     style: Styles.mediumText(
//                     //         color: context
//                     //                 .isDarkMode
//                     //             ? Colors.white
//                     //             : AppColors
//                     //                 .PRIMARY_COLOR),
//                     //   ),
//                     // ),
//                     // PopupMenuItem<int>(
//                     //   value: 1,
//                     //   child: Text(
//                     //     LocaleKeys.markAsUnread
//                     //         .localize,
//                     //     style: Styles.mediumText(
//                     //         color: context
//                     //                 .isDarkMode
//                     //             ? Colors.white
//                     //             : AppColors
//                     //                 .PRIMARY_COLOR),
//                     //   ),
//                     // ),
//                     // PopupMenuItem<int>(
//                     //   value: 2,
//                     //   child: Text(
//                     //     LocaleKeys.selectAll.localize,
//                     //     style: Styles.mediumText(
//                     //         color: context
//                     //                 .isDarkMode
//                     //             ? Colors.white
//                     //             : AppColors
//                     //                 .PRIMARY_COLOR),
//                     //   ),
//                     // ),
//                     PopupMenuItem<int>(
//                       value: 3,
//                       child: Text(
//                         context.isArabic
//                             ? "قفل المحادثات": "Lock Chats",
//                         style: Styles.mediumText(
//                             color: context.isDarkMode
//                                 ? Colors.white
//                                 : AppColors.PRIMARY_COLOR),
//                       ),
//                     ),
//                   ];
//                 },
//               ),
//             ],
//           ),
//         )
//             : const SizedBox.shrink();
//       },
//     ),
//   );
// }

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
                fontWeight: FontWeight.w400,
                fontSize: 32,
                color:
                context.isDarkMode ? Colors.white : AppColors.PRIMARY_COLOR,
              ),
            ),
          ],
        ),
      ),
    );
  }
}