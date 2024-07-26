import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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
import 'package:skeletons/skeletons.dart';
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
      return state.chats == null
          ? const SizedBox()
          : state.chats?.length == 0
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
                  itemBuilder: (context, index) => Slidable(
                    key:  ValueKey(index),
                    // All actions are defined in the children parameter.

                    closeOnScroll: false,
                    endActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      dismissible: DismissiblePane(onDismissed: () {}),
                      children: [
                        SlidableAction(
                          onPressed: (value) {},
                          backgroundColor:
                              const Color.fromARGB(255, 191, 191, 191),
                          foregroundColor: Colors.white,
                          icon: state.chats![index].muted!
                              ? Icons.volume_down
                              : Icons.volume_off,
                          label: state.chats![index].muted! ? 'unMute' : 'mute',
                          padding: EdgeInsets.zero,
                        ),
                        SlidableAction(
                          onPressed: (value) async {
                            bool confirmDeleted = false;
                            confirmDeleted = await showDialogConfirmDeleted();
                            print("confirmDeleted ${confirmDeleted}");
                          },
                          backgroundColor: const Color(0xFFFE4A49),
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Delete',
                          padding: EdgeInsets.zero,
                        ),
                      ],
                    ),

                    // onDismissed: ,
                    child: ChatCard(
                        isSecret: isSecret, chatItemModel: state.chats?[index]),
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

  Future<bool> showDialogConfirmDeleted() async {
    return await showDialog(
      context: context,
      builder: ((context) => AlertDialog(
            title: const Text('Are you sure?'),
            content: const Text('Do you want to remove this chat'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: const Text('No')),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: const Text('Yes'))
            ],
          )),
    );
  }

  Widget skeletonWidget() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: SkeletonTheme(
        shimmerGradient: const LinearGradient(
          colors: [
            Color(0xFF153971),
            Color(0xFF3A548B),
            Color(0xFF153971),
          ],
          stops: [
            0.3,
            0.5,
            0.7,
          ],
          begin: Alignment(-2.4, -0.0),
          end: Alignment(2.4, 0.0),
          tileMode: TileMode.clamp,
        ),
        darkShimmerGradient: const LinearGradient(
          colors: [
            Color(0xFF153971),
            Color(0xFF3A548B),
            Color(0xFF153971),
          ],
          stops: [
            0.3,
            0.5,
            0.7,
          ],
          begin: Alignment(-2.4, -0.0),
          end: Alignment(2.4, 0.0),
          tileMode: TileMode.clamp,
        ),
        child: SkeletonLine(
          style: SkeletonLineStyle(
            height: kToolbarHeight * .7,
            width: kToolbarHeight * .7,
            borderRadius: BorderRadius.circular(5!),
          ),
        ),
      ),
    );
  }
}
