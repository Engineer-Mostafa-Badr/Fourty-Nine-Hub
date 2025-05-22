import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/tinder/domain/domain/user_data_tinder_entity.dart';
import 'package:fourtyninehub/features/social_media/tinder/presentation/cubit/tinder_cubit.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:fourtyninehub/common/widgets/dialogs/please_login_dialog.dart';

import '../../../chat/chat_view/domain/entities/chat_entity.dart';
import '../../../chat/chat_view/domain/usecases/get_chats_usecase.dart';
import '../../../chat/chat_view/presentation/pages/chats_view.dart';

class TinderCardStack extends StatefulWidget {
  const TinderCardStack({super.key});

  @override
  State<TinderCardStack> createState() => _TinderCardStackState();
}

class _TinderCardStackState extends State<TinderCardStack> {
  CardSwiperDirection? _swipeDirection;
  int _currentIndex = 0;
  int _dragProgress = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 0.90.sh,
      child: Stack(
        children: [
          _buildCardSwiper(
            context,
          ),
        ],
      ),
    );
  }

  Widget _buildCardSwiper(
    BuildContext context,
  ) {
    return CardSwiper(
      backCardOffset: const Offset(0, 0),
      initialIndex: _currentIndex,
      cardsCount: 5,
      threshold: 30,
      allowedSwipeDirection: AllowedSwipeDirection.only(left: true,right: true),
      numberOfCardsDisplayed: 3,
      isLoop: true,
      padding: const EdgeInsets.only(bottom: 24),
      maxAngle: 50,
      onSwipe: (previousIndex, currentIndex, direction) {
        setState(() {

          _currentIndex = currentIndex??0;
          _dragProgress = 0;
          // Update the UI based on new card index
          // _buildCardWidget(
          //   context,
          //   _swipeDirection
          // );
        });
        return true;
      },
      onSwipeDirectionChange:  (horizontal, vertical){
        setState(() {
          _swipeDirection=horizontal;
        });
      },
      cardBuilder: (context, index, horizontalOffsetPercentage,
          verticalOffsetPercentage) {
        // احسب نسبة السحب الحالية
        final int drag = horizontalOffsetPercentage.abs() + verticalOffsetPercentage.abs();

        // لو الكارد هو اللي فوق، خزّن نسبة السحب
        if (index == _currentIndex && drag != _dragProgress) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              _dragProgress = drag;
            });
          });
        }
        String? swipeLabel;
        Color? labelColor;
        // نحدد الاتجاه من قيمة السحب
        if ( _swipeDirection != null&&index == _currentIndex ) {
          if (_swipeDirection == CardSwiperDirection.right) {
            swipeLabel = context.isArabic?"مش مناسب":'NOPE';
            labelColor=Color(0xffEB545D);
          } else if (_swipeDirection == CardSwiperDirection.left) {
            swipeLabel = context.isArabic?"أعجبني":'Like';
            labelColor=Colors.green;
          }
        }
        return Stack(
          children: [
            _buildCardWidget(
              context,
            ),
            _buildActions(
              context,
            ),
            if (swipeLabel != null)
              Positioned(
                top: 60,
                    left: _swipeDirection==CardSwiperDirection.left ? null : 30,
                    right:_swipeDirection==CardSwiperDirection.left? 30 : null,
                child: Transform.rotate(
                  angle: _swipeDirection == CardSwiperDirection.right
                      ? -0.6 // ميل لليمين
                      : 0.6, // ميل لليسار
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 4.h),
                    decoration: BoxDecoration(
                      border: Border.all(color:labelColor??Colors.white,width: 5 )
                    ),
                    child: Text(
                      swipeLabel,
                      style: TextStyle(
                        color:labelColor,
                        fontSize: 90.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
      duration: const Duration(milliseconds: 100),
    );
  }

  Widget _buildCardWidget(
    BuildContext context,) {
    return SizedBox(
      child: Container(
        padding: EdgeInsets.only(bottom: 20.0.h),
        child:  Card(
          clipBehavior: Clip.antiAlias,
          shape:const  RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20), topLeft: Radius.circular(20))),
          elevation: 0,
          margin: EdgeInsets.only(bottom: 40.h,right: 16.w,left: 16.w),
          child: Stack(
            children: [
              const SwipeCardDemo2(),
              // if (direction != null)
              //   Positioned(
              //     top: 40,
              //     left: direction == CardSwiperDirection.left ? null : 20,
              //     right: direction == CardSwiperDirection.left ? 20 : null,

            ],
          ),
        ),
      ),
    );
  }

  // Widget _buildGenderSwitch(BuildContext context, UserDataTinderEntity user) {
  //   return Positioned(
  //     right: 8,
  //     top: 25,
  //     child: Container(
  //       width: 80.w,
  //       height: 80.h,
  //       decoration: BoxDecoration(
  //         color: Colors.grey.withOpacity(0.5),
  //         shape: BoxShape.circle,
  //       ),
  //       child: FittedBox(
  //         fit: BoxFit.scaleDown,
  //         child: IconButton(
  //           onPressed: () => _switchDisplayGender(context, user),
  //           icon: Icon(
  //               context.read<TinderViewCubit>().state.userData0?[0].gender ==
  //                       'female'
  //                   ? Icons.female
  //                   : Icons.male,
  //               size: 35,
  //               color: Colors.black),
  //         ),
  //       ),
  //     ),
  //   );
  // }
  //
  // Widget _buildMapSwitch(BuildContext context, UserDataTinderEntity user) {
  //   return Positioned(
  //     left: 8,
  //     top: 25,
  //     child: Container(
  //       width: 40,
  //       height: 40.h,
  //       decoration: BoxDecoration(
  //         color: Colors.grey.withOpacity(0.5),
  //         shape: BoxShape.circle,
  //       ),
  //       child: IconButton(
  //         onPressed: () {
  //           // Define the location you want to pass
  //           // LatLng location = LatLng(37.7749, -122.4194); // Example coordinates (San Francisco)
  //
  //           LatLng location = LatLng(
  //               user.location!.coordinates[0],
  //               user.location!
  //                   .coordinates[1]); // Example coordinates (San Francisco)
  //           log("${user.location!.coordinates[0]} ${user.location!.coordinates[1]} /////////////////////////////////////////////////////////");
  //           // Navigate to the MapScreen and pass the location
  //           Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //               builder: (context) => MapScreen(location: location),
  //             ),
  //           );
  //         },
  //         icon: const Icon(FontAwesomeIcons.locationDot, color: Colors.black),
  //       ),
  //     ),
  //   );
  // }

  // Future<void> _switchDisplayGender(
  //     BuildContext context, UserDataTinderEntity user) async {
  //   final currentGender = context.read<TinderViewCubit>().state.gender;
  //   final newGender = currentGender == 'female' ? 'male' : 'female';
  //   // await context.read<TinderViewCubit>().fetchUserData(gender: ! ? 'female' : 'male', isLoggedIn: context.isUserLoggedIn, userId: context.isUserLoggedIn ? context.read<UserCubit>().state.data!.id : "");
  //   setState(() {
  //     print('sssssssssssssssssssssssssssss');
  //   });
  // }

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
    if (nearByModel != null && nearByModel.data != null) {
      if (nearByModel.data!.isNearBy!) {
        return context.isArabic ? 'قريبٌ منك' : 'Nearby';
      } else {
        return context.isArabic ? 'بعيدٌ عنك' : 'Not Nearby';
      }
    }
    return '';
  }

  Widget _buildActions(
    BuildContext context,
  ) {
    return Positioned(
      bottom: 0,
      right: 8,
      left: 8,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.0.h, vertical: 8.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildActionButton(
              context,
              Image.asset(Assets.unavailable), (){},
              // !context.read<UserCubit>().isLoggedIn
              //     ? () => context.push(Routes.LOGIN)
              //     : () => context.push(Routes.OTHERSACCOUNT, extra: cardUser.id),
              color: AppColors.PRIMARY_COLOR, isMini: true,
            ),
            _buildActionButton(
              context, Image.asset(Assets.tinder_gift), () {},
              // !context.read<UserCubit>().isLoggedIn
              //     ? () => context.push(Routes.LOGIN)
              //     :  () => showChatBottomSheet(context, cardUser),
              color: Colors.white,
            ),
            _buildActionButton(
              context,
              Image.asset(Assets.green_heart), () {},
              // !context.read<UserCubit>().isLoggedIn
              //     ? () => context.push(Routes.LOGIN)
              //     :  () => _navigateToUserProfile(context, cardUser),
              color: Colors.red, isMini: true,
            ),
            _buildActionButton(
              context,
              Image.asset(Assets.tinder_comments), () {},
              // !context.read<UserCubit>().isLoggedIn
              //     ? () => context.push(Routes.LOGIN)
              //     :  () => showGiftBottomSheet(context, receiverId: cardUser.id),
              color: AppColors.ACCENT_COLOR,
            ),
            _buildActionButton(
                context, Image.asset(Assets.tinder_account),()=> context.push(Routes.UserProfilePage),
                // !context.read<UserCubit>().isLoggedIn
                //     ? () => context.push(Routes.LOGIN)
                //     : () {
                //         bottomSheet(
                //             context: context,
                //             widget: ReportView(
                //               id: cardUser.id!,
                //               categoryId: '66af974f8bf69f9469944746',
                //             ));
                //       },
                // () => _showReportBottomSheet(context, cardUser),
                color: Colors.red,
                isMini: true),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
      BuildContext context, Widget child, VoidCallback onPressed,
      {Color? color, bool? isMini}) {
    return FloatingActionButton(
      heroTag: UniqueKey(),elevation: .9,
      onPressed: onPressed,
      mini: isMini ?? false,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      child: Padding(
        padding: EdgeInsets.all(isMini == null ? 16.0.h : 8.h),
        child: child,
      ),
    );
  }

// _navigateToUserProfile(BuildContext context, UserDataTinderEntity cardUser) {
//   if (!context.read<UserCubit>().isLoggedIn) {
//     return const CustomNotLogged();
//   }
//   if (serviceLocator<UserCubit>().state.data != null) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => MultiBlocProvider(
//           providers: [
//             BlocProvider.value(
//               value: serviceLocator<TinderViewCubit>()
//                 ..fetchUserProfile(
//                     userId: serviceLocator<UserCubit>().state.data!.id),
//             ),
//           ],
//           child: const UserProfilePage(),
//         ),
//       ),
//     );
//   }
// }
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
                          return pleaseLoginDialog(context);

                          // context.push(Routes.LOGIN);
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
                          return pleaseLoginDialog(context);

                          // context.push(Routes.LOGIN);
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

// void _navigateToChatRoom(BuildContext context, String chatId,
//     ChatRoomCubit chatRoomCubit, ChatsCubit chatsCubit) {
//   Navigator.push(
//     context,
//     MaterialPageRoute(
//       builder: (_) => MultiBlocProvider(
//         providers: [
//           BlocProvider.value(value: chatRoomCubit),
//           BlocProvider.value(value: chatsCubit),
//         ],
//         child: ChatRoomView(chatsCubit: chatsCubit),
//       ),
//     ),
//   );
// }
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
                              log("Are Friends : ${cardUser.areFriends}");
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
                              return pleaseLoginDialog(context);

                              // context.push(Routes.LOGIN);
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
                              log("Are Friends : ${cardUser.areFriends}");
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
                              return pleaseLoginDialog(context);

                              // context.push(Routes.LOGIN);
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

class SwipeCardDemo2 extends StatefulWidget {
  //final UserDataTinderEntity cardUser;

  const SwipeCardDemo2({
    super.key,
    // required this.cardUser
  });

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

  void _nextStory() {
    setState(() {
      final pictures = [
        Assets.spotlight_profile,
        Assets.personalImage,
        Assets.spotlight_profile,
        Assets.personalImage,
      ];
      if (_currentStoryIndex < pictures.length - 1) {
        _currentStoryIndex = _currentStoryIndex + 1;
      } else {
        _currentStoryIndex =
            pictures.length - 1; // Reset to the first story after the last
      }
      // if (_currentStoryIndex < widget.cardUser.pictures.length - 1) {
      //   _currentStoryIndex = _currentStoryIndex + 1;
      // } else {
      //   _currentStoryIndex = widget.cardUser.pictures.length -
      //       1; // Reset to the first story after the last
      // }
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: (details) => _handleTap(details.localPosition),
      child: _buildCard(context, _currentStoryIndex),
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

  Widget _buildPersonInfo(BuildContext context, int index) {
    return Positioned(
      bottom: kToolbarHeight - 20,
      right: 8,
      left: 8,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                'Mohamed Magdy',
                //"${capitalizeAndSplit(cardUser.firstName ?? '')} ${capitalizeAndSplit(cardUser.lastName ?? '')}",
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
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Sizer(height: 10,),personInfoSubtitle(index)],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget personInfoSubtitle(int index) {
    switch (index) {
      case 1:
        return _customListTile(
            Assets.location,
          context.isArabic ? 'يبعُد 10 ميل ' : '10 Miles Away',
        );
      case 2:
        return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _customListTile(
                Assets.tinder_home,
                context.isArabic ? 'حلوان' : 'Helwan',
              ),
              const Sizer(height: 10,),
              _customListTile(
                Assets.location,
                context.isArabic
                    ? 'يبعُد 10 ميل'
                    : '10 Miles Away',
              ),
            ]);
      case 3:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _customListTile(
                Assets.interest,
                context.isArabic ? 'اهتمامات' : 'Interests'),
            const Sizer(height: 8,),
            Wrap(
              children: [
                _buildInterestsBobble(
                    title: context.isArabic ? 'الكتابة' : 'Writing'),
                const Sizer(),
                _buildInterestsBobble(
                    title: context.isArabic ? 'كرة القدم' : 'Football'),
                const Sizer(),
                _buildInterestsBobble(title: context.isArabic ? 'جيم' : 'GYM'),
              ],
            )
          ],
        );
      default:
        return Label(
          text: context.isArabic ? 'أنت تعرفني 😎' : 'You Know Me 😎',
          style: Styles.headerText(color: Colors.white),
        );
    }
  }

  Widget _buildInterestsBobble({
    required String title,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 8.h),
      decoration: BoxDecoration(
        color: const Color(0xFF404040),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Label(
        text: title,
        style: Styles.headerText(color: Colors.white, fontSize: 32),
      ),
    );
  }

  Widget _customListTile(String icon, String title) {
    return Row(
      children: [
        Image.asset(
          icon,
          height: 35.h,
          color: Colors.white,
        ),
        const Sizer(),
        Label(
          text: title,
          style: Styles.headerText(color: Colors.white),
        ),
      ]
    );
  }

  Widget _buildCard(BuildContext context, int index) {
    // final pictures = widget.cardUser.pictures;
    // final profilePicture = widget.cardUser.profilePicture;

    final pictures = [
      Assets.spotlight_profile,
      Assets.personalImage,
      Assets.spotlight_profile,
      Assets.personalImage,
    ];
    const profilePicture =
        'https://plus.unsplash.com/premium_photo-1664474619075-644dd191935f?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8aW1hZ2V8ZW58MHx8MHx8fDA%3D';

    String? imageUrl;
    // if (pictures.isNotEmpty) {
    //   imageUrl = pictures.reversed.toList()[_currentStoryIndex].mediaKey;
    // }

    return Stack(
      children: [
        Hero(
          tag: UniqueKey(),
          child: Image.network(
            imageUrl ?? profilePicture
            //?? UIConst.profilePlaceHolder,
            ,
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
                  decoration: BoxDecoration(
                      color: (dotIndex != _currentStoryIndex)
                          ? const Color(0xFF808080)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(30)),
                ),
              ),
            ),
          ),
        ),

        _buildPersonInfo(context, index),
      ],
    );
  }
}
