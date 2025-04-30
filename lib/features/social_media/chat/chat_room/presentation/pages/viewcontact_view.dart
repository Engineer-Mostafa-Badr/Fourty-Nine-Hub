import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/custom_switch_button.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/widgets/label_colors_map.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/widgets/widgets_contacts/view_contact_custom_divider.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/widgets/widgets_contacts/view_contact_incription_cart.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/widgets/widgets_contacts/view_contact_status_cart.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/presentation/chat_cubit/chats_cubit.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:fourtyninehub/res/style/styles.dart';

import '../../../../../../core/widget/custom_scaffold.dart';

class ViewContactView extends StatefulWidget {
  const ViewContactView({super.key, required this.chatsCubit});

  final ChatsCubit chatsCubit;

  @override
  State<ViewContactView> createState() => _ViewContactViewState();
}

class _ViewContactViewState extends State<ViewContactView> {
  @override
  void initState() {
    super.initState();
    widget.chatsCubit.getUser();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.chatsCubit,
      child: BlocBuilder<ChatsCubit, ChatsState>(
        builder: (context, state) {
          if (context.isUserLoggedIn) {
            context.read<UserCubit>().updateProfileView(
                  isProfile: true,
                  userId: widget.chatsCubit.selectedChat.userId,
                );
          }
          return CustomScaffold(
            appBar: const BackAppBar(),
            body: widget.chatsCubit.user == null
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : SingleChildScrollView(
                  child: Column(
                      children: [
                        const Sizer(
                          height: 24,
                        ),
                        InkWell(
                          onTap: () {
                            if (widget.chatsCubit.selectedChat.hasStory) {
                              // navigate to stories
                            }
                          },
                          child: Container(
                            decoration: widget.chatsCubit.selectedChat.hasStory
                                ? BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    border: Border.all(
                                      color: AppColors.PRIMARY_COLOR_DARK,
                                      width: 4,
                                    ))
                                : null,
                            child: CircleAvatar(
                              // backgroundColor: Colors.transparent,
                              radius: 80,
                              backgroundImage: CachedNetworkImageProvider(
                                widget.chatsCubit.selectedChat.avatar == ''
                                    ? UIConst.profilePlaceHolder
                                    : widget.chatsCubit.selectedChat.avatar,
                              ),
                            ),
                          ),
                        ),
                        const Sizer(
                          height: 24,
                        ),
                        Label(
                          text: widget.chatsCubit.user!.fullName,
                          style: Styles.headerText(
                            fontWeight: FontWeight.bold,
                            color: context.isDarkMode
                                ? AppColors.BACKGROUND_COLOR
                                : AppColors.PRIMARY_COLOR,
                          ),
                        ),
                        const Sizer(height: 4),
                        Label(
                          text: widget.chatsCubit.user!.phone ?? '',
                          style: Styles.mediumText(
                            // fontWeight: FontWeight.bold,
                            color: context.isDarkMode
                                ? AppColors.BACKGROUND_COLOR
                                : Colors.black45,
                          ),
                        ),
                        if (widget.chatsCubit.selectedChat.lables.isNotEmpty)
                          SizedBox(
                            height: 30, // Adjust height as needed
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount:
                                  widget.chatsCubit.selectedChat.lables.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(left: 16),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        widget.chatsCubit.selectedChat
                                            .lables[index].name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 4,
                                      ),
                                      Icon(
                                        Icons.label,
                                        size: 24,
                                        color: LabelColorsMap.getColor(
                                          widget.chatsCubit.selectedChat
                                              .lables[index].color,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        const Sizer(height: 8,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: context.isDarkMode ? Colors.white70 : Colors.black87,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              height: 140.h,
                              width: 200.w,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                spacing: 8,
                                children: [
                                  const Icon(
                                    Icons.call,
                                    color: AppColors.SECONDARY_COLOR,
                                  ),
                                  Label(
                                    text: context.isArabic ? 'صوت' : 'Audio',
                                    style: Styles.mediumText(
                                        fontWeight: FontWeight.normal,
                                      color: context.isDarkMode ? Colors.white70 : Colors.black87,

                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // if(widget.chatsCubit.selectedChat)
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: context.isDarkMode ? Colors.white70 : Colors.black87,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              height: 140.h,
                              width: 200.w,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                spacing: 8,
                                children: [
                                  const Icon(
                                    Icons.camera,
                                    color: AppColors.SECONDARY_COLOR,
                                  ),
                                  Label(
                                    text: context.isArabic ? 'فيديو' : 'Video',
                                    style: Styles.mediumText(
                                        fontWeight: FontWeight.normal,
                                      color: context.isDarkMode ? Colors.white70 : Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: context.isDarkMode ? Colors.white70 : Colors.black87,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              height: 140.h,
                              width: 200.w,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                spacing: 8,
                                children: [
                                  const Icon(
                                    Icons.search,
                                    color: AppColors.SECONDARY_COLOR,
                                  ),
                                  Label(
                                    text: context.isArabic ? 'بحث' : 'Search',
                                    style: Styles.mediumText(
                                      fontWeight: FontWeight.normal,
                                      color: context.isDarkMode ? Colors.white70 : Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Sizer(height: 8,),
                        const ViewContactCustomDivider(),
                        ViewContactStatusCart(
                          bio: widget.chatsCubit.user!.bio ?? '',
                        ),
                        const Sizer(
                          height: 4,
                        ),
                        if (widget.chatsCubit.selectedChat.lastSeen != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            children: [
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.9,
                                ),
                                child: Label(
                                  text: widget.chatsCubit.selectedChat.lastSeen ??
                                      '',
                                  style: Styles.mediumText(
                                    color: context.isDarkMode
                                        ? AppColors.BACKGROUND_COLOR
                                        : Colors.black45,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const ViewContactCustomDivider(),
                        const ViewContactEncryptionCart(),
                        const SizedBox(
                          height: 16,
                        ),
                        // const ViewContactChatLockCart(),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.mail_lock,
                                color: AppColors.GREY_DARK_COLOR,
                                size: 24,
                              ),
                              const SizedBox(
                                width: 32.0,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.chatsCubit.selectedChat.locked
                                          ? context.isArabic
                                              ? "الغاء قفل المحادثة"
                                              : "Unlock Chat"
                                          : context.isArabic
                                              ? "قفل المحادثة"
                                              : "Lock Chat",
                                      style: Styles.mediumText(
                                        fontWeight: FontWeight.w600,
                                        color: context.isDarkMode
                                            ? AppColors.BACKGROUND_COLOR
                                            : AppColors.PRIMARY_COLOR,
                                      ),
                                    ),
                                    ConstrainedBox(
                                      constraints: BoxConstraints(
                                        maxWidth:
                                            MediaQuery.of(context).size.width *
                                                0.75,
                                      ),
                                      child: Text(
                                        LocaleKeys.chatLockMessage.tr(),
                                        style: Styles.mediumText(
                                          fontWeight: FontWeight.w400,
                                          color: AppColors.DARK_GRAY_COLOR,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              CustomSwitchButton(
                                value: widget.chatsCubit.selectedChat.locked,
                                trackColor: const WidgetStatePropertyAll(
                                  AppColors.SECONDARY_COLOR,
                                ),
                                trackOutlineColor: const WidgetStatePropertyAll(
                                  AppColors.SECONDARY_COLOR,
                                ),
                                activeTrackColor: AppColors.SECONDARY_COLOR,
                                thumbColor: widget.chatsCubit.selectedChat.locked
                                    ? const WidgetStatePropertyAll(Colors.white)
                                    : const WidgetStatePropertyAll(
                                        AppColors.SECONDARY_COLOR),
                                onChanged: (t) async {
                                  await widget.chatsCubit.updateLockChat(
                                      chat: widget.chatsCubit.selectedChat);
                                },
                              ),
                              // IconButton(
                              //   icon: Icon(
                              //     widget.chatsCubit.selectedChat.locked
                              //         ? Icons.toggle_on
                              //         : Icons.toggle_off,
                              //     color: widget.chatsCubit.selectedChat.locked
                              //         ? context.isDarkMode
                              //             ? AppColors.BACKGROUND_COLOR
                              //             : AppColors.PRIMARY_COLOR
                              //         : context.isDarkMode
                              //             ? AppColors.BACKGROUND_COLOR
                              //                 .withOpacity(0.2)
                              //             : AppColors.PRIMARY_COLOR
                              //                 .withOpacity(0.5),
                              //     size: 44,
                              //   ),
                              //   onPressed: () async {
                              //     await widget.chatsCubit.updateLockChat(
                              //         chat: widget.chatsCubit.selectedChat);
                              //   },
                              // ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.speaker_notes_off,
                                color: AppColors.GREY_DARK_COLOR,
                                size: 24,
                              ),
                              const SizedBox(
                                width: 32.0,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      LocaleKeys.disappearingMessages.tr(),
                                      style: Styles.mediumText(
                                        fontWeight: FontWeight.w600,
                                        color: context.isDarkMode
                                            ? AppColors.BACKGROUND_COLOR
                                            : AppColors.PRIMARY_COLOR,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              CustomSwitchButton(
                                value:
                                    widget.chatsCubit.selectedChat.isTimerActive,
                                trackColor: const WidgetStatePropertyAll(
                                  AppColors.SECONDARY_COLOR,
                                ),
                                trackOutlineColor: const WidgetStatePropertyAll(
                                  AppColors.SECONDARY_COLOR,
                                ),
                                activeTrackColor: AppColors.SECONDARY_COLOR,
                                thumbColor: widget
                                        .chatsCubit.selectedChat.isTimerActive
                                    ? const WidgetStatePropertyAll(Colors.white)
                                    : const WidgetStatePropertyAll(
                                        AppColors.SECONDARY_COLOR),
                                onChanged: (t) async {
                                  await widget.chatsCubit.updateChat(
                                      chat: widget.chatsCubit.selectedChat);
                                },
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.perm_identity_rounded,
                                color: AppColors.GREY_DARK_COLOR,
                                size: 24,
                              ),
                              const SizedBox(
                                width: 32.0,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      context.isArabic
                                          ? 'تعيين كجهة اتصال'
                                          : 'Assign as contact',
                                      style: Styles.mediumText(
                                        fontWeight: FontWeight.w600,
                                        color: context.isDarkMode
                                            ? AppColors.BACKGROUND_COLOR
                                            : AppColors.PRIMARY_COLOR,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              CustomSwitchButton(
                                value:
                                    widget.chatsCubit.selectedChat.isTimerActive,
                                trackColor: const WidgetStatePropertyAll(
                                  AppColors.SECONDARY_COLOR,
                                ),
                                trackOutlineColor: const WidgetStatePropertyAll(
                                  AppColors.SECONDARY_COLOR,
                                ),
                                activeTrackColor: AppColors.SECONDARY_COLOR,
                                thumbColor: widget
                                        .chatsCubit.selectedChat.isTimerActive
                                    ? const WidgetStatePropertyAll(Colors.white)
                                    : const WidgetStatePropertyAll(
                                        AppColors.SECONDARY_COLOR,
                                      ),
                                onChanged: (t) async {
                                  await widget.chatsCubit.updateChat(
                                      chat: widget.chatsCubit.selectedChat);
                                },
                              ),
                            ],
                          ),
                        ),
                        const ViewContactCustomDivider(),
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        //   child: Row(
                        //     children: [
                        //       Text(
                        //         '1 ${LocaleKeys.createGroup.tr()}',
                        //         style: Styles.mediumText(
                        //           fontWeight: FontWeight.w400,
                        //           color: AppColors.DARK_GRAY_COLOR,
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        // const SizedBox(
                        //   height: 16,
                        // ),
                        // const CreateGroupWithContactCart(),
                        // const SizedBox(
                        //   height: 16,
                        // ),
                        // const CommonGroupCart(),
                      ],
                    ),
                ),
          );
        },
      ),
    );
  }
}
