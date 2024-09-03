// import 'dart:developer';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_card_swiper/flutter_card_swiper.dart';
// import 'package:fourtyninehub/common/widgets/stateless/labels/badged_label.dart';
// import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
// import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/controllers/chat_cubit/chat_room_cubit.dart';
// import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/pages/Chat_room.dart';
// import 'package:fourtyninehub/features/social_media/chat/chat_view/presentation/chat_cubit/chat_cubit.dart';
// import 'package:fourtyninehub/features/social_media/tinder/data/models/tinder_person_model.dart';
// import 'package:fourtyninehub/features/social_media/tinder/data/shared/shared.dart';
// import 'package:fourtyninehub/features/social_media/tinder/presentation/cubit/tinder_cubit.dart';
// import 'package:fourtyninehub/features/social_media/tinder/presentation/cubit/tinder_state.dart';
// import 'package:fourtyninehub/features/social_media/tinder/presentation/pages/user_profile.dart';
// import 'package:fourtyninehub/features/social_media/twitter/presentation/widgets/report_view.dart';
// import 'package:fourtyninehub/res/style/app_colors.dart';
// import 'package:fourtyninehub/res/style/const.dart';
// import 'package:fourtyninehub/res/style/styles.dart';
// import 'package:fourtyninehub/routes/routes.dart';
// import 'package:fourtyninehub/service_locator/service_locator.dart';
// import 'package:go_router/go_router.dart';
//
// import '../../../../../common/widgets/dialogs/show_bottom_sheet.dart';
//
// class TinderCardStack extends StatelessWidget {
//   const TinderCardStack({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final screenHeight = MediaQuery.of(context).size.height;
//
//     return SizedBox(
//       height: screenHeight * 2.5 / 4,
//       child: BlocBuilder<TinderViewCubit, TinderViewState>(
//         builder: (context, state) {
//           return _buildCardSwiper(context, state);
//         },
//       ),
//     );
//   }
//
//   Widget _buildCardSwiper(BuildContext context, TinderViewState state) {
//     return CardSwiper(
//       cardsCount: state.userData.length,
//       numberOfCardsDisplayed:
//           state.userData.length < 3 ? state.userData.length : 2,
//       scale: 0.9,
//       isLoop: true,
//       padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
//       onSwipe: (previousIndex, currentIndex, direction) {
//         if (currentIndex != null) {
//           _fetchUserDataOnSwipe(context, state.userData[currentIndex].id);
//
//           if (currentIndex >= state.userData.length - 3) {
//             context
//                 .read<TinderViewCubit>()
//                 .loadMoreUserData(state.gender); // Uses state.gender
//           }
//         }
//         return true;
//       },
//       cardBuilder: (context, index, horizontalOffsetPercentage,
//           verticalOffsetPercentage) {
//         return _buildCardWidget(context, state.userData[index]);
//       },
//       duration: const Duration(milliseconds: 150),
//     );
//   }
//
//   void _fetchUserDataOnSwipe(BuildContext context, String? userId) {
//     if (userId != null && userId.isNotEmpty) {
//       final tinderCubit = context.read<TinderViewCubit>();
//       tinderCubit
//         ..fetchLastSeen(userId: userId)
//         ..checkUserNearby(cardUserId: userId);
//     }
//   }
//
//   Widget _buildCardWidget(BuildContext context, UserData cardUser) {
//     return Padding(
//       padding: const EdgeInsets.all(2.0),
//       child: Card(
//         clipBehavior: Clip.hardEdge,
//         elevation: 2,
//         child: Stack(
//           children: [
//             // _buildImage(context, cardUser),
//             SwipeCardDemo2(
//               cardUser: cardUser,
//             ),
//             _buildGenderSwitch(context, cardUser),
//             _buildStoryBar(context, cardUser),
//             _buildPersonInfo(context, cardUser),
//             _buildActions(context, cardUser),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildImage(BuildContext context, UserData user) {
//     final imageUrl = user.pictures.isNotEmpty
//         ? user.pictures.reversed
//             .toList()[context.watch<TinderViewCubit>().state.currentStoryIndex]
//             .mediaKey
//         : user.profilePicture.toString();
//
//     return Hero(
//       tag: UniqueKey(),
//       child: Image.network(
//         // color: Colors.white,
//         Uri.tryParse(imageUrl)?.hasAbsolutePath == true
//             ? imageUrl
//             : UIConst.profilePlaceHolder,
//         width: double.infinity,
//         height: double.infinity,
//         fit: BoxFit.fitHeight,
//         errorBuilder: (_, __, ___) => Image.network(
//           UIConst.profilePlaceHolder,
//           fit: BoxFit.fitHeight,
//           height: double.infinity,
//         ),
//       ),
//     );
//   }
//
//   Widget _buildGenderSwitch(BuildContext context, UserData user) {
//     return Positioned(
//       right: 8,
//       top: 25,
//       child: Container(
//         width: 40,
//         height: 40,
//         decoration: BoxDecoration(
//           color: Colors.grey.withOpacity(0.5),
//           shape: BoxShape.circle,
//         ),
//         child: FittedBox(
//           fit: BoxFit.scaleDown,
//           child: BlocBuilder<TinderViewCubit, TinderViewState>(
//             builder: (context, state) {
//               return IconButton(
//                 onPressed: () => _switchDisplayGender(context, user, state),
//                 icon: Icon(state.gender == 'male' ? Icons.female : Icons.male,
//                     size: 35, color: Colors.black),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildStoryBar(BuildContext context, UserData user) {
//     return Positioned(
//       top: 10,
//       left: 10,
//       right: 10,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: List.generate(
//           user.pictures.length,
//           (dotIndex) => Expanded(
//             child: Container(
//               margin: const EdgeInsets.symmetric(horizontal: 2.0),
//               height: 4,
//               decoration: BoxDecoration(
//                 color: dotIndex ==
//                         context.watch<TinderViewCubit>().state.currentStoryIndex
//                     ? Colors.red
//                     : Colors.grey.withOpacity(0.5),
//                 borderRadius: BorderRadius.circular(2),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildPersonInfo(BuildContext context, UserData cardUser) {
//     return Positioned(
//       bottom: kToolbarHeight,
//       right: 8,
//       left: 8,
//       child: Padding(
//         padding: const EdgeInsets.all(4.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildPersonStatus(context),
//             ListTile(
//               contentPadding: EdgeInsets.zero,
//               title: Text(
//                 capitalizeAndSplit(
//                     "${cardUser.firstName} ${cardUser.lastName}"),
//                 textAlign: TextAlign.start, // Center text for better alignment
//                 style: Styles.headerText(
//                   color: Colors.white, // White text color
//                   fontWeight: FontWeight.bold,
//                   fontSize: MediaQuery.of(context).size.width *
//                       0.06, // Dynamic font size based on screen width
//                   shadows: [
//                     const Shadow(
//                       offset: Offset(1.0, 1.0),
//                       // Adjust for different screen sizes
//                       blurRadius: 4.0,
//                       color: Colors.black,
//                     ),
//                   ],
//                 ),
//               ),
//               subtitle: _buildLastSeen(context),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildPersonStatus(BuildContext context) {
//     return BlocBuilder<TinderViewCubit, TinderViewState>(
//       builder: (context, state) {
//         return Row(
//           children: [
//             BadgedLabel(
//               color: AppColors.WHATS_APP_COLOR,
//               label: state.lastSeenModel?.data?.status ?? 'offline',
//             ),
//             const SizedBox(width: 10),
//             BadgedLabel(
//               color: AppColors.SECONDARY_COLOR,
//               label: state.isUserNearby?.data?.isNearBy == true
//                   ? 'Nearby'
//                   : 'Not Nearby',
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   Widget _buildLastSeen(BuildContext context) {
//     return BlocBuilder<TinderViewCubit, TinderViewState>(
//       builder: (context, state) {
//         final lastSeen = state.lastSeenModel?.data?.lastSeen;
//         return Text(
//           lastSeen != null ? "Last seen ${getTimeAgo(lastSeen)}" : "",
//           style: Styles.mediumText(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//             fontSize: 14,
//             shadows: [
//               const Shadow(
//                 offset: Offset(1.0, 1.0),
//                 // Adjust for different screen sizes
//                 blurRadius: 4.0,
//                 color: Colors.black,
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildActions(BuildContext context, UserData cardUser) {
//     return Positioned(
//       bottom: 4,
//       right: 8,
//       left: 8,
//       child: Padding(
//         padding: const EdgeInsets.all(4.0),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             _buildActionButton(
//                 context,
//                 iconColor: AppColors.PRIMARY_COLOR,
//                 Icons.person,
//                 () => context.push(Routes.OTHERSACCOUNT,
//                     extra: context.read<UserCubit>().state.data!.id)),
//             //----------------------------------------------------------------------
//             _buildActionButton(
//                 context,
//                 Icons.chat,
//                 iconColor: AppColors.PRIMARY_COLOR,
//                 () => _showChatTypeDialog(context, cardUser: cardUser),
//                 color: Colors.white),
//             //----------------------------------------------------------------------
//
//             _buildActionButton(context, Icons.add_photo_alternate_outlined,
//                 () => _navigateToUserProfile(context, cardUser),
//                 color: Colors.red),
//             //----------------------------------------------------------------------
//
//             _buildActionButton(context, Icons.card_giftcard,
//                 () => showGiftBottomSheet(context, receiverId: cardUser.id),
//                 color: AppColors.ACCENT_COLOR),
//             //----------------------------------------------------------------------
//
//             _buildActionButton(context, Icons.report,
//                 () => _showReportBottomSheet(context, cardUser),
//                 color: Colors.red),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildActionButton(
//     BuildContext context,
//     IconData icon,
//     VoidCallback onPressed, {
//     Color? color,
//     Color? iconColor,
//   }) {
//     return FloatingActionButton.small(
//       heroTag: UniqueKey(),
//       onPressed: onPressed,
//       backgroundColor: color,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
//       child: Icon(icon, color: iconColor ?? Colors.white),
//     );
//   }
//
//   void _switchDisplayGender(
//       BuildContext context, UserData user, TinderViewState state) {
//     final newGender = user.gender == 'female' ? 'male' : 'female';
//     context
//         .read<TinderViewCubit>()
//         .fetchUserData(gender: state.gender == 'female' ? 'male' : 'female');
//   }
//
//   void _navigateToUserProfile(BuildContext context, UserData cardUser) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => MultiBlocProvider(
//           providers: [
//             BlocProvider.value(
//                 value: serviceLocator<TinderViewCubit>()
//                   ..fetchUserProfile(
//                       userId: context.read<UserCubit>().state.data!.id)),
//           ],
//           child: const UserProfilePage(),
//         ),
//       ),
//     );
//   }
//
//   void _showReportBottomSheet(BuildContext context, UserData user) {
//     bottomSheet(
//         context: context,
//         widget: ReportView(
//           id: context.read<UserCubit>().state.data!.id,
//           categoryId: '66af974f8bf69f9469944746',
//         ));
//   }
//
//   void _showChatTypeDialog(BuildContext context, {required UserData cardUser}) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return BlocProvider.value(
//           value: serviceLocator<TinderViewCubit>(),
//           child: ChatAlertDialogue(
//             cardUser: cardUser,
//           ),
//         );
//       },
//     );
//   }
// }
//
// class ChatAlertDialogue extends StatelessWidget {
//   final UserData cardUser;
//
//   const ChatAlertDialogue({super.key, required this.cardUser});
//
//   @override
//   Widget build(BuildContext context) {
//     final screenHeight = MediaQuery.of(context).size.height;
//     final dialogWidth = MediaQuery.of(context).size.width * 0.75;
//     final dialogHeight = screenHeight * 0.35;
//     final titleFontSize = screenHeight * 0.025;
//
//     return AlertDialog(
//       title: Padding(
//         padding: EdgeInsets.all(screenHeight * 0.02),
//         child: Text(
//           "Pick a Chat Type:",
//           style: Styles.headerText(
//               fontSize: titleFontSize, fontWeight: FontWeight.bold),
//           textAlign: TextAlign.start,
//         ),
//       ),
//       content: SizedBox(
//         width: dialogWidth,
//         height: dialogHeight,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             _buildChatOptionCard(context,
//                 icon: Icons.visibility_off,
//                 label: "Anonymous",
//                 cardUser: cardUser),
//             SizedBox(height: screenHeight * 0.02),
//             _buildChatOptionCard(context,
//                 icon: Icons.visibility, label: "Regular", cardUser: cardUser),
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
//     final fontSize = screenHeight * 0.023;
//     final padding = screenHeight * 0.01;
//
//     return GestureDetector(
//       onTap: () => _startChat(context, label, cardUser),
//       child: Padding(
//         padding: EdgeInsets.all(padding),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(icon,
//                 size: iconSize,
//                 color: label == "Anonymous"
//                     ? AppColors.SECONDARY_COLOR
//                     : AppColors.PRIMARY_COLOR),
//             SizedBox(height: padding),
//             Text(label,
//                 style: Styles.headerText(
//                     fontSize: fontSize, fontWeight: FontWeight.bold),
//                 textAlign: TextAlign.center),
//             SizedBox(height: padding / 2),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void _startChat(BuildContext context, String label, UserData cardUser) {
//     // Determine the chat type and start the appropriate chat
//     final tinderCubit = context.read<TinderViewCubit>();
//     final chatRoomCubit = serviceLocator<ChatRoomCubit>();
//     final chatsCubit = serviceLocator<ChatsCubit>();
//
//     if (label == "Anonymous") {
//       // Start an anonymous chat
//       tinderCubit.startAnonymousChat(receiverId: cardUser.id ?? '').then((_) {
//         final chatId =
//             tinderCubit.state.anonymousChatResponse?.data.chat.id ?? '';
//         log("$chatId=----------------------------------------------------------------------------");
//
//         if (chatId.isNotEmpty) {
//           chatsCubit.initSocketConnection(); // Initialize socket connection
//           _navigateToChatRoom(context, chatId, chatRoomCubit, chatsCubit);
//         } else {
//           // Handle the case where chatId is empty, if necessary
//         }
//       }).catchError((error) {
//         // Handle any errors that occur during the chat startup
//         log("Error starting anonymous chat: $error");
//       });
//     } else {
//       // Start a normal chat
//       tinderCubit
//           .startNormalChat(
//         receiverId: cardUser.id ?? '',
//         subCategoryId: '62c8be6f8e28a58a3edf5f4f',
//       )
//           .then((_) {
//         final chatId = tinderCubit.state.normalChatResponse?.data.chat.id ?? '';
//
//         if (chatId.isNotEmpty) {
//           chatsCubit.initSocketConnection(); // Initialize socket connection
//           _navigateToChatRoom(context, chatId, chatRoomCubit, chatsCubit);
//         } else {
//           // Handle the case where chatId is empty, if necessary
//         }
//       }).catchError((error) {
//         // Handle any errors that occur during the chat startup
//         log("Error starting normal chat: $error");
//       });
//     }
//   }
//
// // Separate method to handle navigation to ChatRoom
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
//           child: ChatRoom(chatId: chatId),
//         ),
//       ),
//     );
//   }
// }
//
// class SwipeCardDemo2 extends StatefulWidget {
//   final UserData cardUser;
//
//   const SwipeCardDemo2({super.key, required this.cardUser});
//
//   @override
//   SwipeCardDemo2State createState() => SwipeCardDemo2State();
// }
//
// class SwipeCardDemo2State extends State<SwipeCardDemo2> {
//   int _currentStoryIndex = 0;
//
//   void _nextStory() {
//     setState(() {
//       final pictures = widget.cardUser.pictures ?? [];
//       _currentStoryIndex = (_currentStoryIndex < pictures.length - 1)
//           ? _currentStoryIndex + 1
//           : pictures.length - 1;
//     });
//   }
//
//   void _previousStory() {
//     setState(() {
//       _currentStoryIndex =
//           (_currentStoryIndex > 0) ? _currentStoryIndex - 1 : 0;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTapUp: (details) => _handleTap(details.localPosition),
//       child: _buildCard(context),
//     );
//   }
//
//   void _handleTap(Offset localPosition) {
//     final double screenWidth = MediaQuery.of(context).size.width;
//     final bool tappedLeftSide = localPosition.dx < screenWidth / 2;
//
//     if (tappedLeftSide) {
//       _previousStory();
//     } else {
//       _nextStory();
//     }
//   }
//
//   Widget _buildCard(BuildContext context) {
//     final pictures = widget.cardUser.pictures ?? [];
//     final imageUrl = pictures.isNotEmpty
//         ? pictures.reversed.toList()[_currentStoryIndex].mediaKey
//         : UIConst.profilePlaceHolder;
//
//     return Stack(
//       children: [
//         Hero(
//           tag: UniqueKey(),
//           child: Image.network(
//             // color: Colors.white,
//             Uri.tryParse(imageUrl)?.hasAbsolutePath == true
//                 ? imageUrl
//                 : UIConst.profilePlaceHolder,
//             width: double.infinity,
//             height: double.infinity,
//             fit: BoxFit.fitHeight,
//             errorBuilder: (_, __, ___) => Image.network(
//               UIConst.profilePlaceHolder,
//               fit: BoxFit.fitHeight,
//               height: double.infinity,
//             ),
//           ),
//         ),
//         Positioned(
//           top: 10,
//           left: 10,
//           right: 10,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: List.generate(
//               pictures.length,
//               (dotIndex) => Expanded(
//                 child: Container(
//                   margin: const EdgeInsets.symmetric(horizontal: 2.0),
//                   height: 4,
//                   decoration: BoxDecoration(
//                     color: (dotIndex == _currentStoryIndex)
//                         ? Colors.red
//                         : Colors.white54,
//                     borderRadius: BorderRadius.circular(2),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/badged_label.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/controllers/chat_cubit/chat_room_cubit.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/pages/Chat_room.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/presentation/chat_cubit/chat_cubit.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/models/tinder_person_model.dart';
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

import '../../../../../common/widgets/dialogs/show_bottom_sheet.dart';
import '../../data/shared/shared.dart';

class TinderCardStack extends StatelessWidget {
  const TinderCardStack({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      height: screenHeight * 2.5 / 4,
      child: BlocConsumer<TinderViewCubit, TinderViewState>(
        listener: (context, state) {
          // Handle any errors in a centralized place
          log("Error: $state");
        },
        builder: (context, state) {
          if (state.userData.isEmpty) {
            return const Center(
              child: CupertinoActivityIndicator(radius: 25),
            );
          }
          return _buildCardSwiper(context, state);
        },
      ),
    );
  }

  Widget _buildCardSwiper(BuildContext context, TinderViewState state) {
    return CardSwiper(
      cardsCount: state.userData.length,
      numberOfCardsDisplayed:
          state.userData.length < 3 ? state.userData.length : 2,
      scale: 0.9,
      isLoop: true,
      padding: const EdgeInsets.only(right: 4.0, left: 4.0, bottom: 16),
      onSwipe: (previousIndex, currentIndex, direction) {
        // Disable swapping if there's only one card
        if (state.userData.length == 1) {
          return false; // Prevent swipe
        }

        if (currentIndex != null) {
          _fetchUserDataOnSwipe(context, state.userData[currentIndex].id);

          if (currentIndex >= state.userData.length - 3) {
            context.read<TinderViewCubit>().loadMoreUserData(state.gender);
          }
        }
        return true;
      },
      cardBuilder: (context, index, horizontalOffsetPercentage,
          verticalOffsetPercentage) {
        return _buildCardWidget(context, state.userData[index]);
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

  Widget _buildCardWidget(BuildContext context, UserData cardUser) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Card(
        clipBehavior: Clip.hardEdge,
        elevation: 2,
        child: Stack(
          children: [
            SwipeCardDemo2(cardUser: cardUser),
            _buildGenderSwitch(context, cardUser),
            // _buildMapSwitch(context, cardUser),
            _buildStoryBar(context, cardUser),
            _buildPersonInfo(context, cardUser),
            _buildActions(context, cardUser),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderSwitch(BuildContext context, UserData user) {
    return Positioned(
      right: 8,
      top: 25,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.5),
          shape: BoxShape.circle,
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: IconButton(
            onPressed: () => _switchDisplayGender(context, user),
            icon: Icon(
                context.read<TinderViewCubit>().state.gender == 'male'
                    ? Icons.female
                    : Icons.male,
                size: 35,
                color: Colors.black),
          ),
        ),
      ),
    );
  }

  Widget _buildMapSwitch(BuildContext context, UserData user) {
    return Positioned(
      left: 8,
      top: 25,
      child: Container(
        width: 40,
        height: 40,
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

  void _switchDisplayGender(BuildContext context, UserData user) {
    final currentGender = context.read<TinderViewCubit>().state.gender;
    final newGender = currentGender == 'female' ? 'male' : 'female';
    context.read<TinderViewCubit>().fetchUserData(gender: newGender);
  }

  Widget _buildStoryBar(BuildContext context, UserData user) {
    return Positioned(
      top: 10,
      left: 10,
      right: 10,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          user.pictures.length,
          (dotIndex) => Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 2.0),
              height: 4,
              decoration: BoxDecoration(
                color: dotIndex ==
                        context.read<TinderViewCubit>().state.currentStoryIndex
                    ? Colors.red
                    : Colors.grey.withOpacity(0.5),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPersonInfo(BuildContext context, UserData cardUser) {
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
                style: Styles.headerText(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.of(context).size.width * 0.12,
                  shadows: [
                    const Shadow(
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

  Widget _buildPersonStatus(BuildContext context) {
    return Row(
      children: [
        BadgedLabel(
          close: false,
          color: AppColors.WHATS_APP_COLOR,
          label: context
                  .read<TinderViewCubit>()
                  .state
                  .lastSeenModel
                  ?.data
                  ?.status ??
              'offline',
        ),
        const SizedBox(width: 10),
        BadgedLabel(
          close: false,
          color: AppColors.SECONDARY_COLOR,
          label: context
                      .read<TinderViewCubit>()
                      .state
                      .isUserNearby
                      ?.data
                      ?.isNearBy ==
                  true
              ? 'Nearby'
              : 'Not Nearby',
        ),
      ],
    );
  }

  Widget _buildLastSeen(BuildContext context) {
    final lastSeen =
        context.read<TinderViewCubit>().state.lastSeenModel?.data?.lastSeen;
    return Text(
      lastSeen != null ? "Last seen ${getTimeAgo(lastSeen)}" : "",
      style: Styles.mediumText(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: MediaQuery.of(context).size.width * 0.07,
        shadows: [
          const Shadow(
            offset: Offset(1.0, 1.0),
            blurRadius: 4.0,
            color: Colors.black,
          ),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context, UserData cardUser) {
    return Positioned(
      bottom: 4,
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
              () => context.push(Routes.OTHERSACCOUNT,
                  extra: context.read<UserCubit>().state.data!.id),
              color: AppColors.PRIMARY_COLOR,
            ),
            _buildActionButton(context, Icons.chat,
                () => _showChatTypeDialog(context, cardUser: cardUser),
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
              () => _showReportBottomSheet(context, cardUser),
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

  void _navigateToUserProfile(BuildContext context, UserData cardUser) {
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

  void _showReportBottomSheet(BuildContext context, UserData user) {
    bottomSheet(
      context: context,
      widget: ReportView(
        id: context.read<UserCubit>().state.data!.id,
        categoryId: '66af974f8bf69f9469944746',
      ),
    );
  }

  void _showChatTypeDialog(BuildContext context, {required UserData cardUser}) {
    showDialog(
      context: context,
      builder: (context) {
        return BlocProvider.value(
          value: serviceLocator<TinderViewCubit>(),
          child: ChatAlertDialogue(cardUser: cardUser),
        );
      },
    );
  }
}

class ChatAlertDialogue extends StatelessWidget {
  final UserData cardUser;

  const ChatAlertDialogue({super.key, required this.cardUser});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final dialogWidth = MediaQuery.of(context).size.width * 0.75;
    final dialogHeight = screenHeight / 4;
    final titleFontSize = screenHeight * 0.05;

    return AlertDialog(
      title: Padding(
        padding: EdgeInsets.all(screenHeight * 0.02),
        child: Text(
          "Pick a Chat Type:",
          style: Styles.headerText(
            fontSize: titleFontSize,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.start,
        ),
      ),
      content: SizedBox(
        width: dialogWidth,
        height: dialogHeight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildChatOptionCard(
              context,
              icon: Icons.visibility_off,
              label: "Anonymous",
              cardUser: cardUser,
            ),
            SizedBox(height: screenHeight * 0.02),
            _buildChatOptionCard(
              context,
              icon: Icons.visibility,
              label: "Regular",
              cardUser: cardUser,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatOptionCard(BuildContext context,
      {required IconData icon,
      required String label,
      required UserData cardUser}) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final iconSize = screenWidth * 0.1;
    final fontSize = screenHeight * 0.04;
    final padding = screenHeight * 0.01;

    return GestureDetector(
      onTap: () => _startChat(context, label, cardUser),
      child: Padding(
        padding: EdgeInsets.all(padding),
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
        ),
      ),
    );
  }

  void _startChat(BuildContext context, String label, UserData cardUser) {
    final tinderCubit = context.read<TinderViewCubit>();
    final chatRoomCubit = serviceLocator<ChatRoomCubit>();
    final chatsCubit = serviceLocator<ChatsCubit>();

    if (label == "Anonymous") {
      tinderCubit.startAnonymousChat(receiverId: cardUser.id ?? '').then((_) {
        final chatId =
            tinderCubit.state.anonymousChatResponse?.data.chat.id ?? '';
        if (chatId.isNotEmpty) {
          chatsCubit.initSocketConnection();
          _navigateToChatRoom(context, chatId, chatRoomCubit, chatsCubit);
        } else {
          log("Chat ID is empty.");
        }
      }).catchError((error) {
        log("Error starting anonymous chat: $error");
      });
    } else {
      tinderCubit
          .startNormalChat(
        receiverId: cardUser.id ?? '',
        subCategoryId: '62c8be6f8e28a58a3edf5f4f',
      )
          .then((_) {
        final chatId = tinderCubit.state.normalChatResponse?.data.chat.id ?? '';
        if (chatId.isNotEmpty) {
          chatsCubit.initSocketConnection();
          _navigateToChatRoom(context, chatId, chatRoomCubit, chatsCubit);
        } else {
          log("Chat ID is empty.");
        }
      }).catchError((error) {
        log("Error starting normal chat: $error");
      });
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
          child: ChatRoom(chatId: chatId),
        ),
      ),
    );
  }
}

class SwipeCardDemo2 extends StatefulWidget {
  final UserData cardUser;

  const SwipeCardDemo2({super.key, required this.cardUser});

  @override
  SwipeCardDemo2State createState() => SwipeCardDemo2State();
}

class SwipeCardDemo2State extends State<SwipeCardDemo2> {
  int _currentStoryIndex = 0;

  void _nextStory() {
    setState(() {
      final pictures = widget.cardUser.pictures;
      _currentStoryIndex = (_currentStoryIndex < pictures.length - 1)
          ? _currentStoryIndex + 1
          : pictures.length - 1;
    });
  }

  void _previousStory() {
    setState(() {
      _currentStoryIndex =
          (_currentStoryIndex > 0) ? _currentStoryIndex - 1 : 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: (details) => _handleTap(details.localPosition),
      child: _buildCard(context),
    );
  }

  void _handleTap(Offset localPosition) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool tappedLeftSide = localPosition.dx < screenWidth / 2;

    if (tappedLeftSide) {
      _previousStory();
    } else {
      _nextStory();
    }
  }

  Widget _buildCard(BuildContext context) {
    final pictures = widget.cardUser.pictures;
    final imageUrl = pictures.isNotEmpty
        ? pictures.reversed.toList()[_currentStoryIndex].mediaKey
        : UIConst.profilePlaceHolder;

    return Stack(
      children: [
        Hero(
          tag: UniqueKey(),
          child: Image.network(
            Uri.tryParse(imageUrl)?.hasAbsolutePath == true
                ? imageUrl
                : UIConst.profilePlaceHolder,
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
                    color: (dotIndex == _currentStoryIndex)
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
}
//last ya ali
