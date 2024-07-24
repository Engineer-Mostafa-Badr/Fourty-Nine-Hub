import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/appbar/nested_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/states/basic_state.dart';
import 'package:fourtyninehub/features/authentication/domain/entities/user_entity.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/presentation/chat_cubit/chat_cubit.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/presentation/widgets/chat_stories.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';
import '../widgets/calling_card.dart';
import '../widgets/chat_card.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key});

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
    chatCubit.getChats();
  }

  final List<String> groups = [
    'Social',
    'Services',
    'Call & Video (Social)',
    'Call & Video(Services)',
    'Chat',
    'Groups',
    'Anonymous',
    'Archive',
    'Lock Chat',
    'Unread',
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: groups.length,
      initialIndex: 0,
      child: SharedScaffold(
        mainCategoryId: 2,
        body: NestedAppbar(
          appBars: [
            const SliverAppBar(
              expandedHeight: kToolbarHeight * 1.5,
              automaticallyImplyLeading: false,
              floating: true,
              flexibleSpace: ChatStories(),
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
                                text: 'Login',
                                style: Styles.headerText(color: Colors.blue))),
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
        tabAlignment: TabAlignment.start,
        isScrollable: true,
        tabs: groups.map((e) {
          return Tab(
            text: e,
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
      // _buildCategoryChats(),
      // _buildCategoryChats(),
    ]);
  }

  Widget _buildCategoryChats({bool isSecret = false}) {
    return BlocBuilder<ChatsCubit, ChatsState>(builder: (context, state) {
      return state.chats!.isEmpty
          ? Center(
              child: Label(
                  text: 'No Chats until now',
                  style: Styles.mediumText(
                      color: const Color.fromARGB(255, 87, 87, 87),
                      fontWeight: FontWeight.bold,
                      fontSize: 18)),
            )
          : ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) => ChatCard(
                  isSecret: isSecret, chatItemModel: state.chats?[index]),
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
}
