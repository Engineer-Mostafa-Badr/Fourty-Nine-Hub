// ignore_for_file: deprecated_member_use

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/usecases/get_chats_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/presentation/chat_cubit/chats_cubit.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/presentation/widgets/chat_card.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../core/widget/custom_scaffold.dart';

class OptionsChatsViewParams {
  final ChatsCubit chatsCubit;
  final String category;
  final bool isSecret;
  OptionsChatsViewParams(
      {required this.chatsCubit,
      required this.category,
      required this.isSecret});
}

class OptionsChatsView extends StatefulWidget {
  const OptionsChatsView({super.key, required this.params});
  final OptionsChatsViewParams params;

  @override
  State<OptionsChatsView> createState() => _OptionsChatsViewState();
}

class _OptionsChatsViewState extends State<OptionsChatsView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Perform any action before popping (like setting a value to refresh the home page)
        context.pop(true); // Pop and pass true to refresh the home page
        return false; // Return false to prevent default popping (handled by pop() above)
      },
      child: BlocProvider.value(
        value: widget.params.chatsCubit,
        child: Builder(builder: (context) {
          return CustomScaffold(
            appBar: AppBar(
              backgroundColor: AppColors.PRIMARY_COLOR,
              elevation: 0,
              leadingWidth: 26,
              leading: IconButton(
                onPressed: () {
                  context.pop(true);
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
              actions: [
                BlocBuilder<ChatsCubit, ChatsState>(
                  builder: (context, state) {
                    if (context.read<ChatsCubit>().selectedChats.isEmpty) {
                      return const SizedBox();
                    } else {
                      return Row(
                        children: [
                          IconButton(
                            onPressed: () async {
                              await context
                                  .read<ChatsCubit>()
                                  .pinAndUnpinChat();
                            },
                            icon: const Icon(Icons.push_pin),
                            color: AppColors.BACKGROUND_COLOR,
                          ),
                          IconButton(
                            onPressed: () async {
                              await context.read<ChatsCubit>().deleteChat();
                            },
                            icon: const Icon(
                              Icons.delete_forever,
                              color: AppColors.BACKGROUND_COLOR,
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              await context.read<ChatsCubit>().changeMuteChat();
                            },
                            icon: const Icon(
                              Icons.notifications_off,
                              color: AppColors.BACKGROUND_COLOR,
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              await context.read<ChatsCubit>().changeArchiveChat(isArchivedTab: true);
                              final unarchivedChatsCount = context.read<ChatsCubit>().selectedChats.length;

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: AppColors.PRIMARY_COLOR, // Set background color to blue
                                  content: BlocProvider.value(
                                    value: context.read<ChatsCubit>(),
                                    child: Builder(
                                      builder: (context) {
                                        return Text.rich(
                                          TextSpan(
                                            children: [
                                              TextSpan(
                                                text: context.isArabic ? "تم إلغاء أرشفة " : "Unarchived ",
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              TextSpan(
                                                text: "$unarchivedChatsCount ", // Count
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              TextSpan(
                                                text: context.isArabic ? "محادثة" : "chats",
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  action: SnackBarAction(
                                    label: context.isArabic ? "تراجع" : "Undo",
                                    textColor: Colors.grey, // Set "Undo" text color to gray
                                    onPressed: () async {
                                      await context.read<ChatsCubit>().changeArchiveChat(isArchivedTab: true);
                                    },
                                  ),
                                  duration: const Duration(seconds: 3),
                                ),
                              );

// Clear selected chats after 3 seconds
                              Future.delayed(const Duration(seconds: 3), () {
                                context.read<ChatsCubit>().clearSelectedChats();
                              });

                            },
                            icon: const Icon(
                              Icons.unarchive,
                              color: AppColors.BACKGROUND_COLOR,
                            ),
                          ),
                          widget.params.category == "LockedChats"
                              ? PopupMenuButton(
                                  icon: Icon(
                                    Icons.more_vert,
                                    color: !context.isDarkMode
                                        ? Colors.white
                                        : AppColors.PRIMARY_COLOR,
                                  ),
                                  color: context.isDarkMode
                                      ? AppColors.PRIMARY_COLOR
                                      : AppColors.BACKGROUND_COLOR,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(16.0)),
                                  ),
                                  offset: const Offset(0, 50),
                                  onSelected: (int value) async {
                                    if (value == 0) {
                                      // await context
                                      //     .read<ChatsCubit>()
                                      //     .lockChats(isLockedTap: true);

                                      await context.read<ChatsCubit>().lockChats(isLockedTap: true);
                                      final unlockedChatsCount = context.read<ChatsCubit>().selectedChats.length;

                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          backgroundColor: AppColors.PRIMARY_COLOR, // Set background color
                                          content: BlocProvider.value(
                                            value: context.read<ChatsCubit>(),
                                            child: Builder(
                                              builder: (context) {
                                                return Text.rich(
                                                  TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text: context.isArabic ? "تم إلغاء قفل " : "Unlocked ",
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: "$unlockedChatsCount ", // Count
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: context.isArabic ? "محادثة" : "chats",
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          action: SnackBarAction(
                                            label: context.isArabic ? "تراجع" : "Undo",
                                            textColor: Colors.grey, // Set "Undo" text color to gray
                                            onPressed: () async {
                                              await context.read<ChatsCubit>().lockChats(isLockedTap: true);
                                            },
                                          ),
                                          duration: const Duration(seconds: 3),
                                        ),
                                      );

// Clear selected chats after 3 seconds
                                      Future.delayed(const Duration(seconds: 3), () {
                                        context.read<ChatsCubit>().clearSelectedChats();
                                      });

                                    }
                                  },
                                  itemBuilder: (context) {
                                    return [
                                      PopupMenuItem<int>(
                                        value: 0,
                                        child: Text(
                                          context.isArabic
                                              ? "الغاء قفل الدردشات"
                                              : "Unlock chats",
                                          style: Styles.mediumText(
                                              color: context.isDarkMode
                                                  ? Colors.white
                                                  : AppColors.PRIMARY_COLOR),
                                        ),
                                      ),
                                    ];
                                  },
                                )
                              : const SizedBox(),
                        ],
                      );
                    }
                  },
                )
              ],
              title: Text(
                widget.params.category == ChatCategoriesIds.greet
                    ? LocaleKeys.greet.tr()
                    : widget.params.category == ChatCategoriesIds.anonymous
                        ? LocaleKeys.anonymous.tr()
                        : widget.params.category == "LockedChats"
                            ? LocaleKeys.lockChat.tr()
                            : LocaleKeys.archive.tr(),
                style: Styles.headerText(color: Colors.white),
              ),
            ),
            body: _body(),
          );
        }),
      ),
    );
  }

  Widget _body() {
    return FutureBuilder(
        future: widget.params.category == ChatCategoriesIds.greet
            ? widget.params.chatsCubit.getGreetChats()
            : widget.params.category == ChatCategoriesIds.anonymous
                ? widget.params.chatsCubit.getAnonymousChats()
                : widget.params.category == "LockedChats"
                    ? widget.params.chatsCubit.getLockedChats()
                    : widget.params.chatsCubit.getArchivedChats(),
        builder: (context, snapshot) {
          return BlocBuilder<ChatsCubit, ChatsState>(
            builder: (context, state) {
              return state.chats == null || state.isLoading
                  ? const Center(
                      child: CircularProgressIndicator.adaptive(),
                    )
                  : state.chats!.isEmpty
                      ? Center(
                          child: Label(
                              text: LocaleKeys.noChatsUntilNow.tr(),
                              style: Styles.mediumText(
                                  fontWeight: FontWeight.bold, fontSize: 34)),
                        )
                      : ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) => (!state
                                      .chats![index].archived) &&
                                  widget.params.category == "Archive"
                              ? const SizedBox()
                              : Slidable(
                                  key: ValueKey(index),
                                  closeOnScroll: false,
                                  endActionPane: ActionPane(
                                    motion: const ScrollMotion(),
                                    dismissible:
                                        DismissiblePane(onDismissed: () {}),
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
                                        backgroundColor: const Color.fromARGB(
                                            255, 191, 191, 191),
                                        foregroundColor: Colors.white,
                                        icon: Icons.more_horiz,
                                        label: LocaleKeys.more.tr(),
                                        padding: EdgeInsets.zero,
                                      ),
                                      SlidableAction(
                                        onPressed: (value) async {},
                                        backgroundColor:
                                            AppColors.PRIMARY_COLOR,
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
                                    isSecret: false,
                                    chat: state.chats?[index],
                                    chatsCubit: widget.params.chatsCubit,
                                  ),
                                ),
                          separatorBuilder: (context, index) =>
                              const SizedBox(),
                          itemCount: state.chats?.length ?? 0,
                        );
            },
          );
        });
  }
}
