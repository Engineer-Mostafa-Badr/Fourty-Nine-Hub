// ignore_for_file: use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/custom_text_no_login.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/controllers/chat_room_cubit/chat_room_cubit.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/pages/chat_room_view.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/presentation/chat_cubit/chats_cubit.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/user_profile_entity.dart';
import 'package:fourtyninehub/features/social_media/tinder/domain/domain/user_data_tinder_entity.dart';
import 'package:fourtyninehub/features/social_media/tinder/presentation/cubit/tinder_cubit.dart';
import 'package:fourtyninehub/features/social_media/tinder/presentation/cubit/tinder_state.dart';
import 'package:fourtyninehub/features/social_media/tinder/presentation/pages/user_profile.dart';
import 'package:fourtyninehub/features/social_media/tinder/presentation/widgets/show_user_in_map.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/widgets/report_view.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../chat/chat_view/domain/entities/chat_entity.dart';
import '../../../chat/chat_view/domain/usecases/get_chats_usecase.dart';
import '../../../chat/chat_view/presentation/pages/chats_view.dart';
import '../../../social_posts/presentation/pages/message_button.dart';
import '../../data/shared/shared.dart';

class TinderCardStack extends StatefulWidget {
  const TinderCardStack({super.key});

  @override
  State<TinderCardStack> createState() => _TinderCardStackState();
}

class _TinderCardStackState extends State<TinderCardStack> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 0.88.sh,
      child: BlocBuilder<TinderViewCubit, TinderViewState>(
        builder: (context, state) {
          // if (state.userData!.isEmpty) {
          //   return const Center(
          //     child: CupertinoActivityIndicator(radius: 25),
          //   );
          // }
          return _buildCardSwiper(context, state);
        },
      ),
    );
  }

  Widget _buildCardSwiper(BuildContext context, TinderViewState state) {
    return CardSwiper(
      cardsCount: state.userData0!.length,
      numberOfCardsDisplayed:
          state.userData0!.length < 3 ? state.userData0!.length : 2,
      scale: 0.9,
      isLoop: true,
      padding: const EdgeInsets.only(right: 4.0, left: 4.0, bottom: 24),
      onSwipe: (previousIndex, currentIndex, direction) {
        // Disable swapping if there's only one card
        if (state.userData0!.length == 1) {
          return false; // Prevent swipe
        }
        setState(() {
          // Update the UI based on new card index
          _buildCardWidget(context, state.userData0![currentIndex!]);
        });
        if (currentIndex != null) {
          _fetchUserDataOnSwipe(context, state.userData0![currentIndex].id);

          // if (currentIndex >= state.userData0!.length - 3) {
          //   context.read<TinderViewCubit>().fetchUserData(state.gender!);
          // }
        }
        return true;
      },
      cardBuilder: (context, index, horizontalOffsetPercentage,
          verticalOffsetPercentage) {
        // if (index >= state.userData0!.length) {
        //   setState(() {});
        // }
        return _buildCardWidget(context, state.userData0![index]);
      },
      duration: const Duration(milliseconds: 100),
    );
  }

  void _fetchUserDataOnSwipe(BuildContext context, String? userId) {
    if (userId != null && userId.isNotEmpty) {
      context.read<TinderViewCubit>().fetchLastSeen(userId: userId);
      // ..checkUserNearby(cardUserId: userId);
    }
  }

  Widget _buildCardWidget(BuildContext context, UserDataTinderEntity cardUser) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: SizedBox(
        child: Card(
          clipBehavior: Clip.hardEdge,
          elevation: 2,
          child: Stack(
            children: [
              SwipeCardDemo2(cardUser: cardUser),
              // _buildGenderSwitch(context, cardUser),
              // _buildMapSwitch(context, cardUser),
              //_buildStoryBar(context, cardUser),
              _buildPersonInfo(context, cardUser),
              _buildActions(context, cardUser),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGenderSwitch(BuildContext context, UserDataTinderEntity user) {
    return Positioned(
      right: 8,
      top: 25,
      child: Container(
        width: 80.w,
        height: 80.h,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.5),
          shape: BoxShape.circle,
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: IconButton(
            onPressed: () => _switchDisplayGender(context, user),
            icon: Icon(
                context.read<TinderViewCubit>().state.userData0?[0].gender ==
                        'female'
                    ? Icons.female
                    : Icons.male,
                size: 35,
                color: Colors.black),
          ),
        ),
      ),
    );
  }

  Widget _buildMapSwitch(BuildContext context, UserDataTinderEntity user) {
    return Positioned(
      left: 8,
      top: 25,
      child: Container(
        width: 40,
        height: 40.h,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.5),
          shape: BoxShape.circle,
        ),
        child: IconButton(
          onPressed: () {
            // Define the location you want to pass
            // LatLng location = LatLng(37.7749, -122.4194); // Example coordinates (San Francisco)

            LatLng location = LatLng(
                user.location!.coordinates[0],
                user.location!
                    .coordinates[1]); // Example coordinates (San Francisco)
            log("${user.location!.coordinates[0]} ${user.location!.coordinates[1]} /////////////////////////////////////////////////////////");
            // Navigate to the MapScreen and pass the location
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MapScreen(location: location),
              ),
            );
          },
          icon: const Icon(FontAwesomeIcons.locationDot, color: Colors.black),
        ),
      ),
    );
  }

  Future<void> _switchDisplayGender(
      BuildContext context, UserDataTinderEntity user) async {
    final currentGender = context.read<TinderViewCubit>().state.gender;
    final newGender = currentGender == 'female' ? 'male' : 'female';
    await context.read<TinderViewCubit>().fetchUserData(newGender);
    setState(() {
      print('sssssssssssssssssssssssssssss');
    });
  }

  // Widget _buildStoryBar(BuildContext context, UserDataTinderEntity user) {
  //   return Positioned(
  //     top: 10,
  //     left: 10,
  //     right: 10,
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: List.generate(
  //         user.pictures.length,
  //         (dotIndex) => Expanded(
  //           child: Container(
  //             margin: const EdgeInsets.symmetric(horizontal: 2.0),
  //             height: 4,
  //             decoration: BoxDecoration(
  //               color: dotIndex ==
  //                       context.read<TinderViewCubit>().state.currentStoryIndex
  //                   ? Colors.red
  //                   : Colors.grey.withOpacity(0.5),
  //               borderRadius: BorderRadius.circular(2),
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildPersonInfo(BuildContext context, UserDataTinderEntity cardUser) {
    return Positioned(
      bottom: kToolbarHeight,
      right: 8,
      left: 8,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPersonStatus(context),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                "${capitalizeAndSplit(cardUser.firstName ?? '')} ${capitalizeAndSplit(cardUser.lastName ?? '')}",
                textAlign: TextAlign.start,
                maxLines: 1,
                softWrap: true,
                overflow: TextOverflow.fade,
                textScaler: TextScaler.noScaling,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 60.sp,
                  shadows: const [
                    Shadow(
                      offset: Offset(1.0, 1.0),
                      blurRadius: 4.0,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
              subtitle: _buildLastSeen(context),
            ),
          ],
        ),
      ),
    );
  }

  getStatus(BuildContext context) {
    final lastSeenModel = context.read<TinderViewCubit>().state.lastSeenModel;

    if (lastSeenModel?.status == 'offline') {
      return context.isArabic ? 'غير متصل' : 'Offline';
    }
    if (lastSeenModel?.status == 'online') {
      if (lastSeenModel?.lastSeen != null || lastSeenModel?.lastSeen != '') {
        return '';
      }

      return context.isArabic ? 'متصل' : 'Online';
    }
    return '';
  }

  getNearByStatus(BuildContext context) {
    final nearByModel = context.read<TinderViewCubit>().state.isUserNearby;
    // context
    //     .read<TinderViewCubit>()
    //     .state
    //     .isUserNearby
    //     ?.data
    //     ?.isNearBy ==
    //     true
    //     ? 'Nearby'
    //     : 'Not Nearby',
    if (nearByModel != null && nearByModel.data != null) {
      if (nearByModel.data!.isNearBy!) {
        return context.isArabic ? 'قريبٌ منك' : 'Nearby';
      } else {
        return context.isArabic ? 'بعيدٌ عنك' : 'Not Nearby';
      }
    }
    return '';
  }

  Widget _buildPersonStatus(BuildContext context) {
    return BlocBuilder<TinderViewCubit, TinderViewState>(
      builder: (context, state) {
        if (state.lastSeenModelState == TinderStates.failure ||
            state.lastSeenModelState == TinderStates.initial) {
          return const Sizer();
        }
        return Row(
          children: [
            getStatus(context).toString().isNotEmpty
                ? Container(
                    padding: const EdgeInsets.all(4),
                    //padding: EdgeInsetsDirectional.only(end: 8,top: 5),
                    decoration: BoxDecoration(
                        color: AppColors.WHATS_APP_COLOR,
                        borderRadius: BorderRadius.circular(8)),
                    child: Text(
                      getStatus(context),
                      textScaler: TextScaler.noScaling,
                      style: TextStyle(fontSize: 40.sp, color: Colors.white),
                    ))
                : const SizedBox.shrink(),
            const SizedBox(width: 10),
            getNearByStatus(context).toString().isNotEmpty
                ? Container(
                    padding: const EdgeInsets.all(4),
                    //padding: EdgeInsetsDirectional.only(end: 8,top: 5),
                    decoration: BoxDecoration(
                        color: AppColors.SECONDARY_COLOR,
                        borderRadius: BorderRadius.circular(8)),
                    child: Text(
                      getNearByStatus(context),
                      textScaler: TextScaler.noScaling,
                      style: TextStyle(fontSize: 40.sp, color: Colors.white),
                    ))
                : const SizedBox.shrink(),
          ],
        );
      },
    );
  }

  Widget _buildLastSeen(BuildContext context) {
    // final lastSeen =
    //     context.read<TinderViewCubit>().state.lastSeenModel?.data?.lastSeen;
    return BlocBuilder<TinderViewCubit, TinderViewState>(
      builder: (context, state) {
        if (state.lastSeenModelState == TinderStates.failure ||
            state.lastSeenModelState == TinderStates.initial) {
          return const Text('');
        } else {
          if (state.lastSeenModel?.lastSeen != null) {
            return Text(
              "${context.isArabic ? " آخر ظهور منذ" : 'Last seen'} ${getTimeAgo(context, state.lastSeenModel?.lastSeen ?? '')}",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textScaler: TextScaler.noScaling,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 35.sp,
                shadows: const [
                  Shadow(
                    offset: Offset(1.0, 1.0),
                    blurRadius: 4.0,
                    color: Colors.black87,
                  ),
                ],
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        }
      },
    );
  }

  Widget _buildActions(BuildContext context, UserDataTinderEntity cardUser) {
    return Positioned(
      bottom: 8,
      right: 8,
      left: 8,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildActionButton(
              context,
              Icons.person,
              () => context.push(Routes.OTHERSACCOUNT, extra: cardUser.id),
              color: AppColors.PRIMARY_COLOR,
            ),
            _buildActionButton(context, Icons.chat,
                () => showChatBottomSheet(context, cardUser),
                color: Colors.white, iconColor: AppColors.PRIMARY_COLOR),
            _buildActionButton(
              context,
              Icons.add_photo_alternate_outlined,
              () => _navigateToUserProfile(context, cardUser),
              color: Colors.red,
            ),
            _buildActionButton(
              context,
              Icons.card_giftcard,
              () => showGiftBottomSheet(context, receiverId: cardUser.id),
              color: AppColors.ACCENT_COLOR,
            ),
            _buildActionButton(
              context,
              Icons.report,
              !context.read<UserCubit>().isLoggedIn
                  ? () => context.push(Routes.LOGIN)
                  : () {
                      bottomSheet(
                          context: context,
                          widget: ReportView(
                            id: cardUser.id!,
                            categoryId: '66af974f8bf69f9469944746',
                          ));
                    },
              // () => _showReportBottomSheet(context, cardUser),
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    IconData icon,
    VoidCallback onPressed, {
    Color? color,
    Color? iconColor,
  }) {
    return FloatingActionButton.small(
      heroTag: UniqueKey(),
      onPressed: onPressed,
      backgroundColor: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      child: Icon(icon, color: iconColor ?? Colors.white),
    );
  }

  _navigateToUserProfile(BuildContext context, UserDataTinderEntity cardUser) {
    if (!context.read<UserCubit>().isLoggedIn) {
      return const CustomTextNoLogin();
    }
    if (serviceLocator<UserCubit>().state.data != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: serviceLocator<TinderViewCubit>()
                  ..fetchUserProfile(
                      userId: serviceLocator<UserCubit>().state.data!.id),
              ),
            ],
            child: const UserProfilePage(),
          ),
        ),
      );
    }
  }
}

// class ChatAlertDialogue extends StatelessWidget {
//   final UserData cardUser;
//
//   const ChatAlertDialogue({super.key, required this.cardUser});
//
//   @override
//   Widget build(BuildContext context) {
//     final screenHeight = MediaQuery.of(context).size.height;
//     final dialogWidth = MediaQuery.of(context).size.width * 0.75;
//     final dialogHeight = screenHeight / 4;
//     final titleFontSize = screenHeight * 0.05;
//
//     return AlertDialog(
//       title: Padding(
//         padding: EdgeInsets.all(screenHeight * 0.02),
//         child: Text(
//           LocaleKeys.chat_alert_dialog_pick_chat_type.tr(),
//           style: Styles.headerText(
//             fontSize: titleFontSize,
//             fontWeight: FontWeight.bold,
//           ),
//           textAlign: TextAlign.start,
//         ),
//       ),
//       content: SizedBox(
//         width: dialogWidth,
//         height: dialogHeight,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             _buildChatOptionCard(
//               context,
//               icon: Icons.visibility_off,
//               label: LocaleKeys.chat_alert_dialog_anonymous.tr(),
//               cardUser: cardUser,
//             ),
//             SizedBox(height: screenHeight * 0.02),
//             _buildChatOptionCard(
//               context,
//               icon: Icons.visibility,
//               label: LocaleKeys.chat_alert_dialog_regular.tr(),
//               cardUser: cardUser,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildChatOptionCard(BuildContext context,
//       {required IconData icon,
//       required String label,
//       required UserData cardUser}) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;
//     final iconSize = screenWidth * 0.1;
//     final fontSize = screenHeight * 0.04;
//     final padding = screenHeight * 0.01;
//
//     return GestureDetector(
//       onTap: () => _startChat(context, label, cardUser),
//       child: Padding(
//         padding: EdgeInsets.all(padding),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               icon,
//               size: iconSize,
//               color: label == "Anonymous"
//                   ? AppColors.SECONDARY_COLOR
//                   : AppColors.PRIMARY_COLOR,
//             ),
//             SizedBox(height: padding),
//             Text(
//               label,
//               style: Styles.headerText(
//                 fontSize: fontSize,
//                 fontWeight: FontWeight.bold,
//               ),
//               textAlign: TextAlign.center,
//             ),
//             SizedBox(height: padding / 2),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void _startChat(BuildContext context, String label, UserData cardUser) {
//     final tinderCubit = context.read<TinderViewCubit>();
//     final chatRoomCubit = serviceLocator<ChatRoomCubit>();
//     final chatsCubit = serviceLocator<ChatsCubit>();
//
//     if (label == "Anonymous") {
//       tinderCubit.startAnonymousChat(receiverId: cardUser.id ?? '').then((_) {
//         final chatId =
//             tinderCubit.state.anonymousChatResponse?.data.chat.id ?? '';
//         if (chatId.isNotEmpty) {
//           chatsCubit.init();
//           _navigateToChatRoom(context, chatId, chatRoomCubit, chatsCubit);
//         } else {
//           log("Chat ID is empty.");
//         }
//       }).catchError((error) {
//         log("Error starting anonymous chat: $error");
//       });
//     } else {
//       tinderCubit
//           .startNormalChat(
//         receiverId: cardUser.id ?? '',
//         subCategoryId: '62c8be6f8e28a58a3edf5f4f',
//       )
//           .then((_) {
//         final chatId = tinderCubit.state.normalChatResponse?.data.chat.id ?? '';
//         if (chatId.isNotEmpty) {
//           chatsCubit.init();
//           _navigateToChatRoom(context, chatId, chatRoomCubit, chatsCubit);
//         } else {
//           log("Chat ID is empty.");
//         }
//       }).catchError((error) {
//         log("Error starting normal chat: $error");
//       });
//     }
//   }
//
//   void _navigateToChatRoom(BuildContext context, String chatId,
//       ChatRoomCubit chatRoomCubit, ChatsCubit chatsCubit) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => MultiBlocProvider(
//           providers: [
//             BlocProvider.value(value: chatRoomCubit),
//             BlocProvider.value(value: chatsCubit),
//           ],
//           child: ChatRoomView(chatsCubit: chatsCubit),
//         ),
//       ),
//     );
//   }
// }

class ChatBottomSheet extends StatelessWidget {
  final UserDataTinderEntity cardUser;

  const ChatBottomSheet({super.key, required this.cardUser});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    // final screenWidth = MediaQuery.of(context).size.width;
    // final bottomSheetHeight = screenHeight / 2;
    // final titleFontSize = screenHeight * 0.05;

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: context.isDarkMode
              ? Colors.black.withOpacity(0.5)
              : Colors.white.withOpacity(0.5),
        ),
        // decoration: BoxDecoration(
        //   color: Colors.white.withOpacity(0.5),
        //   borderRadius: const BorderRadius.only(
        //     topLeft: Radius.circular(20),
        //     topRight: Radius.circular(20),
        //   ),
        // ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              color: context.isDarkMode ? Colors.white10 : Colors.black12,
              child: Padding(
                padding: EdgeInsets.all(screenHeight * 0.02),
                child: Text(
                  LocaleKeys.chat_alert_dialog_pick_chat_type.tr(),
                  textScaler: TextScaler.noScaling,
                  style: TextStyle(
                    fontSize: 40.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        if (context.read<UserCubit>().isLoggedIn) {
                          ChatEntity? chat = await context
                              .read<UserCubit>()
                              .createAnonymousChat(
                                otherId: cardUser.id!,
                              );
                          context.pop();
                          context.push(
                            Routes.CHAT,
                            extra: ChatsViewParams(
                              isFromStartChat: true,
                              initialTabIndex: 0,
                              selectedChat: chat,
                            ),
                          );
                        } else {
                          context.push(Routes.LOGIN);
                        }
                      },
                      child: _buildChatOptionCard(
                        context,
                        icon: Icons.visibility_off,
                        label: LocaleKeys.chat_alert_dialog_anonymous.tr(),
                        cardUser: cardUser,
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        if (context.read<UserCubit>().isLoggedIn) {
                          log("are friends : ${cardUser.areFriends}");
                          if (cardUser.areFriends == true) {
                            ChatEntity? chat = await context
                                .read<UserCubit>()
                                .createNormalChat(
                                  otherId: cardUser.id!,
                                  categoryId: ChatCategoriesIds.social,
                                );
                            context.pop();
                            context.push(
                              Routes.CHAT,
                              extra: ChatsViewParams(
                                isFromStartChat: true,
                                initialTabIndex: 0,
                                selectedChat: chat,
                              ),
                            );
                          } else {
                            ChatEntity? chat = await context
                                .read<UserCubit>()
                                .createNormalChat(
                                  otherId: cardUser.id!,
                                  categoryId: ChatCategoriesIds.greet,
                                );
                            context.pop();
                            context.push(
                              Routes.CHAT,
                              extra: ChatsViewParams(
                                isFromStartChat: true,
                                initialTabIndex: 0,
                                selectedChat: chat,
                              ),
                            );
                          }
                        } else {
                          context.push(Routes.LOGIN);
                        }
                      },
                      child: _buildChatOptionCard(
                        context,
                        icon: Icons.visibility,
                        label: LocaleKeys.chat_alert_dialog_regular.tr(),
                        cardUser: cardUser,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatOptionCard(BuildContext context,
      {required IconData icon,
      required String label,
      required UserDataTinderEntity cardUser}) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final iconSize = screenWidth * 0.1;
    //final fontSize = screenHeight * 0.04;
    final padding = screenHeight * 0.01;

    return IconButton(
      onPressed: () => _startChat(context, label, cardUser),
      icon: Card(
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: FittedBox(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: iconSize,
                  color: label == "Anonymous" || label == "مجهول"
                      ? AppColors.SECONDARY_COLOR
                      : (context.isDarkMode
                          ? Colors.white
                          : AppColors.PRIMARY_COLOR),
                ),
                SizedBox(height: padding),
                Text(
                  label,
                  textScaler: TextScaler.noScaling,
                  style: TextStyle(
                    fontSize: 40.sp,
                    fontWeight: FontWeight.normal,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: padding / 2),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _startChat(
      BuildContext context, String label, UserDataTinderEntity cardUser) {
    // final tinderCubit = context.read<TinderViewCubit>();
    // final chatRoomCubit = serviceLocator<ChatRoomCubit>();
    // final chatsCubit = serviceLocator<ChatsCubit>();

    if (label == "Anonymous") {
      // tinderCubit.startAnonymousChat(receiverId: cardUser.id ?? '').then((_) {
      //   final chatId =
      //       tinderCubit.state.anonymousChatResponse?.data.chat.id ?? '';
      //   if (chatId.isNotEmpty) {
      //     chatsCubit.init();
      //     _navigateToChatRoom(context, chatId, chatRoomCubit, chatsCubit);
      //   } else {
      //     log("Chat ID is empty.");
      //   }
      // }).catchError((error) {
      //   log("Error starting anonymous chat: $error");
      // });
    } else {
      // tinderCubit
      //     .startNormalChat(
      //   receiverId: cardUser.id ?? '',
      //   subCategoryId: '62c8be6f8e28a58a3edf5f4f',
      // )
      //     .then((_) {
      //   final chatId = tinderCubit.state.normalChatResponse?.data.chat.id ?? '';
      //   if (chatId.isNotEmpty) {
      //     chatsCubit.init();
      //     _navigateToChatRoom(context, chatId, chatRoomCubit, chatsCubit);
      //   } else {
      //     log("Chat ID is empty.");
      //   }
      // }).catchError((error) {
      //   log("Error starting normal chat: $error");
      // });
    }
  }

  void _navigateToChatRoom(BuildContext context, String chatId,
      ChatRoomCubit chatRoomCubit, ChatsCubit chatsCubit) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider.value(value: chatRoomCubit),
            BlocProvider.value(value: chatsCubit),
          ],
          child: ChatRoomView(chatsCubit: chatsCubit),
        ),
      ),
    );
  }
}

Widget _buildChatOptionCard(
  BuildContext context, {
  required IconData icon,
  required String label,
  required Function() onPressed,
}) {
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;
  final iconSize = screenWidth * 0.1;
  final fontSize = screenHeight * 0.04;
  final padding = screenHeight * 0.01;

  return SizedBox(
    height: 150.h,
    child: ElevatedButton(
        onPressed: () {
          onPressed();
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: iconSize,
              color: label == "Anonymous"
                  ? AppColors.SECONDARY_COLOR
                  : AppColors.PRIMARY_COLOR,
            ),
            SizedBox(height: padding),
            Text(
              label,
              style: Styles.headerText(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: padding / 2),
          ],
        )),
  );
}

void showChatBottomSheet(BuildContext context, UserDataTinderEntity cardUser) {
  showModalBottomSheet(
      context: context,
      builder: (_) => Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50.r),
            ),
            height: MediaQuery.of(context).size.height * 0.3,
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.height * 0.02),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50.r),
                        topRight: Radius.circular(50.r)),
                    color: AppColors.GREY_NORMAL_COLOR,
                  ),
                  child: Text(
                    LocaleKeys.chat_alert_dialog_pick_chat_type.tr(),
                    style: Styles.headerText(
                      fontSize: 60.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(
                        MediaQuery.of(context).size.height * 0.02),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildChatOptionCard(
                          context,
                          icon: Icons.visibility_off,
                          label: LocaleKeys.chat_alert_dialog_anonymous.tr(),
                          onPressed: () async {
                            if (context.read<UserCubit>().isLoggedIn) {
                              ChatEntity? chat = await context
                                  .read<UserCubit>()
                                  .createAnonymousChat(
                                    otherId: cardUser.id!,
                                  );
                              context.pop();
                              context.push(
                                Routes.CHAT,
                                extra: ChatsViewParams(
                                  isFromStartChat: true,
                                  initialTabIndex: 0,
                                  selectedChat: chat,
                                ),
                              );
                            } else {
                              context.push(Routes.LOGIN);
                            }
                          },
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),
                        _buildChatOptionCard(
                          context,
                          icon: Icons.visibility,
                          label: LocaleKeys.chat_alert_dialog_regular.tr(),
                          onPressed: () async {
                            if (context.read<UserCubit>().isLoggedIn) {
                              if (cardUser.areFriends == true) {
                                ChatEntity? chat = await context
                                    .read<UserCubit>()
                                    .createNormalChat(
                                      otherId: cardUser.id!,
                                      categoryId: ChatCategoriesIds.social,
                                    );
                                context.pop();
                                context.push(
                                  Routes.CHAT,
                                  extra: ChatsViewParams(
                                    isFromStartChat: true,
                                    initialTabIndex: 0,
                                    selectedChat: chat,
                                  ),
                                );
                              } else {
                                ChatEntity? chat = await context
                                    .read<UserCubit>()
                                    .createNormalChat(
                                      otherId: cardUser.id!,
                                      categoryId: ChatCategoriesIds.greet,
                                    );
                                context.pop();
                                context.push(
                                  Routes.CHAT,
                                  extra: ChatsViewParams(
                                    isFromStartChat: true,
                                    initialTabIndex: 0,
                                    selectedChat: chat,
                                  ),
                                );
                              }
                            } else {
                              context.push(Routes.LOGIN);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ));
}

Widget swipeCardDemo2(BuildContext context, UserDataTinderEntity cardUser) {
  int currentStoryIndex = 0;

  void nextStory() {
    final pictures = cardUser.pictures;
    currentStoryIndex = (currentStoryIndex < pictures.length - 1)
        ? currentStoryIndex + 1
        : pictures.length - 1;
  }

  void previousStory() {
    currentStoryIndex = (currentStoryIndex > 0) ? currentStoryIndex - 1 : 0;
  }

  void handleTap(Offset localPosition) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool tappedLeftSide = localPosition.dx < screenWidth / 2;

    if (tappedLeftSide) {
      context.isArabic ? nextStory() : previousStory();
    } else {
      context.isArabic ? previousStory() : nextStory();
    }
  }

  Widget buildCard(BuildContext context) {
    final pictures = cardUser.pictures;
    final profilePicture = cardUser.profilePicture;

    String? imageUrl;
    if (pictures.isNotEmpty) {
      imageUrl = pictures.reversed.toList()[currentStoryIndex].mediaKey;
    }

    return Stack(
      children: [
        Hero(
          tag: UniqueKey(),
          child: Image.network(
            imageUrl ?? profilePicture ?? UIConst.profilePlaceHolder,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.fitHeight,
            errorBuilder: (_, __, ___) => Image.network(
              UIConst.profilePlaceHolder,
              fit: BoxFit.fitHeight,
              height: double.infinity,
            ),
          ),
        ),
        Positioned(
          top: 10,
          left: 10,
          right: 10,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              pictures.length,
              (dotIndex) => Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2.0),
                  height: 4,
                  decoration: BoxDecoration(
                    color: (dotIndex == currentStoryIndex)
                        ? Colors.red
                        : Colors.white54,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  return StatefulBuilder(
    builder: (context, setState) {
      return GestureDetector(
        onTapUp: (details) => handleTap(details.localPosition),
        child: buildCard(context),
      );
    },
  );
}

//last ya ali

class SwipeCardDemo2 extends StatefulWidget {
  final UserDataTinderEntity cardUser;

  const SwipeCardDemo2({super.key, required this.cardUser});

  @override
  SwipeCardDemo2State createState() => SwipeCardDemo2State();
}

class SwipeCardDemo2State extends State<SwipeCardDemo2> {
  int _currentStoryIndex = 0;

  @override
  void initState() {
    _currentStoryIndex = 0; // Starts from the first story (dot 0)
    super.initState();
  }

  // void _nextStory() {
  //   setState(() {
  //     if (_currentStoryIndex == widget.cardUser.pictures.length - 1) {
  //       _currentStoryIndex = 0;
  //     }
  //     _currentStoryIndex =
  //         (_currentStoryIndex < widget.cardUser.pictures.length)
  //             ? _currentStoryIndex + 1
  //             : widget.cardUser.pictures.length - 1;
  //   });
  // }

  void _nextStory() {
    setState(() {
      if (_currentStoryIndex < widget.cardUser.pictures.length - 1) {
        _currentStoryIndex = _currentStoryIndex + 1;
      } else {
        _currentStoryIndex = widget.cardUser.pictures.length -
            1; // Reset to the first story after the last
      }
    });
  }

  void _previousStory() {
    setState(() {
      if (_currentStoryIndex > 0) {
        _currentStoryIndex = _currentStoryIndex - 1;
      } else {
        _currentStoryIndex = 0; // Go to the last story
      }
    });
  }

  // void _previousStory() {
  //   setState(() {
  //     if (_currentStoryIndex == 0) {
  //       _currentStoryIndex = widget.cardUser.pictures.length;
  //     }
  //     _currentStoryIndex =
  //         (_currentStoryIndex > 0) ? _currentStoryIndex - 1 : 0;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: (details) => _handleTap(details.localPosition),
      child: _buildCard(context),
    );
  }

  void _handleTap(Offset localPosition) {
    print('Current Story Index: $_currentStoryIndex');

    final double screenWidth = MediaQuery.of(context).size.width;
    final bool tappedLeftSide = localPosition.dx < screenWidth / 2;
    print('Current Story Index: $_currentStoryIndex');

    setState(() {
      if (tappedLeftSide) {
        context.isArabic ? _nextStory() : _previousStory();
      } else {
        context.isArabic ? _previousStory() : _nextStory();
      }
    });
  }

  Widget _buildCard(BuildContext context) {
    final pictures = widget.cardUser.pictures;
    final profilePicture = widget.cardUser.profilePicture;

    String? imageUrl;
    if (pictures.isNotEmpty) {
      imageUrl = pictures.reversed.toList()[_currentStoryIndex].mediaKey;
    }

    return Stack(
      children: [
        Hero(
          tag: UniqueKey(),
          child: Image.network(
            imageUrl ?? profilePicture ?? UIConst.profilePlaceHolder,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.fitHeight,
            errorBuilder: (_, __, ___) => Image.network(
              UIConst.profilePlaceHolder,
              fit: BoxFit.fitHeight,
              height: double.infinity,
            ),
          ),
        ),
        // Shadow overlay
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent, // Gradual fade to transparent
                  Colors.transparent, // Gradual fade to transparent
                  Colors.black.withOpacity(0.7), // Shadow effect at the top
                ],
              ),
            ),
          ),
        ),
        // Progress indicators
        Positioned(
          top: 10,
          left: 10,
          right: 10,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              pictures.length,
              (dotIndex) => Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2.0),
                  height: 4,
                  color: (dotIndex != _currentStoryIndex)
                      ? Colors.white54
                      : Colors.red,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
