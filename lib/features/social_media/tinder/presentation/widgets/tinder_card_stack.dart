
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/badged_label.dart';
import 'package:fourtyninehub/core/enums/wallet_types_enums.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/presentation/pages/Chat_view.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/models/tinder_person_model.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/shared/shared.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/shared/tinder_shared_utils.dart';
import 'package:fourtyninehub/features/social_media/tinder/presentation/cubit/gift_cubit.dart';
import 'package:fourtyninehub/features/social_media/tinder/presentation/cubit/tinder_cubit.dart';
import 'package:fourtyninehub/features/social_media/tinder/presentation/cubit/tinder_state.dart';
import 'package:fourtyninehub/features/social_media/tinder/presentation/pages/tinder_view.dart';
import 'package:fourtyninehub/features/social_media/tinder/presentation/pages/user_profile.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/widgets/report_view.dart';
import 'package:fourtyninehub/features/subscripe/presentation/controllers/subscription_controller.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';

//---------------------------------------------
// class TinderCardStack extends StatelessWidget {
//   final TinderViewCubit tinderCubit;
//   final UserCubit userCubit;
//
//   const TinderCardStack({
//     super.key,
//     required this.tinderCubit,
//     required this.userCubit,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final screenHeight = MediaQuery.of(context).size.height;
//
//     return SizedBox(
//       height: screenHeight * 2.5 / 4,
//       child: Stack(
//         children: List.generate(
//           tinderCubit.state.userData.length,
//           (index) => _buildCard(context, index),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildCard(BuildContext context, int index) {
//     final cardUser = tinderCubit.state.userData[index];
//     final isFrontCard = index == tinderCubit.state.currentIndex;
//
//     if (!isFrontCard) return const Offstage();
//
//     return GestureDetector(
//       onPanStart: (details) =>
//           tinderCubit.updatePanStart(details.globalPosition),
//       onPanUpdate: (details) {
//         final position =
//             details.globalPosition - tinderCubit.state.startDragOffset;
//         final rotation = position.dx /
//             (position.dy > tinderCubit.state.startDragOffset.dy - 180
//                 ? 500
//                 : -500);
//         tinderCubit.updatePanUpdate(position, rotation);
//       },
//       onPanEnd: (_) => _handlePanEnd(),
//       onTapUp: (details) {
//         final screenWidth = MediaQuery.of(context).size.width;
//         final tapPosition = details.localPosition.dx;
//
//         tapPosition < screenWidth / 2
//             ? tinderCubit.previousStory()
//             : tinderCubit.nextStory();
//       },
//       child: Transform.translate(
//         offset: tinderCubit.state.position,
//         child: Transform.rotate(
//           angle: tinderCubit.state.rotation,
//           child: _cardWidget(context, cardUser),
//         ),
//       ),
//     );
//   }
//
//   void _handlePanEnd() {
//     final shouldSwipeAway = tinderCubit.state.position.dx.abs() > 150 ||
//         tinderCubit.state.position.dy.abs() > 150;
//
//     shouldSwipeAway ? tinderCubit.swipeAway() : tinderCubit.resetPan();
//   }
//
//   Widget _cardWidget(BuildContext context, UserData cardUser) {
//     return Padding(
//       padding: const EdgeInsets.all(2.0),
//       child: Card(
//         clipBehavior: Clip.hardEdge,
//         elevation: 2,
//         child: Stack(
//           children: [
//             _buildImage(cardUser),
//             _buildGenderSwitch(context, cardUser),
//             _buildStoryBar(cardUser),
//             PersonInfoWidget(
//               cardUser: cardUser,
//               // tinderCubit: tinderCubit,
//               userCubit: userCubit,
//             ),
//             _buildActions(context, cardUser),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildImage(UserData user) {
//     final imageUrl = user.pictures.isNotEmpty
//         ? user.pictures.reversed
//             .toList()[tinderCubit.state.currentStoryIndex]
//             .mediaKey
//         : UIConst.profilePlaceHolder;
//
//     return Hero(
//       tag: 'userHero-${user.id}',
//       child: Image.network(
//         imageUrl,
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
//           child: IconButton(
//             onPressed: () => _switchDisplayGender(user),
//             iconSize: 50,
//             icon: Icon(user.gender == 'male' ? Icons.female : Icons.male,
//                 color: Colors.black),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildStoryBar(UserData user) {
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
//                 color: dotIndex == tinderCubit.state.currentStoryIndex
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
//   Widget _buildActions(BuildContext context, UserData user) {
//     return Positioned(
//       bottom: 4,
//       right: 8,
//       left: 8,
//       child: Padding(
//         padding: const EdgeInsets.all(4.0),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             _buildFloatingActionButton(
//               context,
//               Icons.person,
//               () => context.push(Routes.OTHERSACCOUNT),
//               heroTag: 'personButton',
//             ),
//             _buildFloatingActionButton(
//               context,
//               Icons.chat,
//               () => _showChatTypeAdvancedDialog(context),
//               color: AppColors.PRIMARY_COLOR,
//               heroTag: 'chatButton',
//             ),
//             _buildFloatingActionButton(
//               context,
//               Icons.add_photo_alternate_outlined,
//               () => _navigateToUserProfile(context, user),
//               color: Colors.red,
//               heroTag: 'photoButton',
//             ),
//             _buildFloatingActionButton(
//               context,
//               Icons.card_giftcard,
//               () => _showGiftBottomSheet22(context),
//               color: AppColors.ACCENT_COLOR,
//               heroTag: 'giftButton',
//             ),
//             _buildFloatingActionButton(
//               context,
//               Icons.report,
//               () => _showReportBottomSheet(context, user),
//               color: Colors.red,
//               heroTag: 'reportButton',
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void _showReportBottomSheet(BuildContext context, UserData user) {
//     final userState = userCubit.state.data;
//     if (userState != null) {
//       showModalBottomSheet(
//         context: context,
//         builder: (context) => SizedBox(
//           height: MediaQuery.of(context).size.height / 1.5,
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: ReportView(
//               id: userState.id,
//               categoryId: '66af974f8bf69f9469944746',
//             ),
//           ),
//         ),
//       );
//     }
//   }
//
//   void _showGiftBottomSheet22(BuildContext context) {
//     closeAllBottomSheets(context);
//
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.black.withOpacity(0.8),
//       builder: (context) => MultiBlocProvider(
//         providers: [
//           BlocProvider(create: (_) => GiftsCubit()),
//           BlocProvider(create: (_) => TinderViewCubit()),
//           BlocProvider(create: (_) => userCubit),
//         ],
//         child: SizedBox(
//           height: MediaQuery.of(context).size.height / 2,
//           child: Column(
//             children: [
//               Container(
//                 width: double.infinity,
//                 height: kToolbarHeight * 0.80,
//                 decoration: BoxDecoration(
//                   color: Colors.black.withOpacity(0.4),
//                   borderRadius:
//                       const BorderRadius.vertical(top: Radius.circular(20)),
//                 ),
//                 child: const FittedBox(
//                   fit: BoxFit.scaleDown,
//                   child: Text(
//                     'Send a gift 🎁',
//                     style: TextStyle(
//                       color: AppColors.ACCENT_COLOR,
//                       fontWeight: FontWeight.w300,
//                     ),
//                     textAlign: TextAlign.center,
//                     textScaler: TextScaler.linear(1.6),
//                   ),
//                 ),
//               ),
//               Expanded(
//                 child: Stack(
//                   children: [
//                     BottomSheetContent(
//                       userCubit: userCubit,
//                       accessToken: userCubit.state.token!.accessToken,
//                     ),
//                     Positioned(
//                       bottom: 5,
//                       right: 5,
//                       child: Padding(
//                         padding: const EdgeInsets.all(4.0),
//                         child: OutlinedButton(
//                           style: ButtonStyle(
//                             side: const MaterialStatePropertyAll(
//                                 BorderSide(width: 0)),
//                             iconColor:
//                                 const MaterialStatePropertyAll(Colors.white),
//                             backgroundColor: MaterialStatePropertyAll(
//                                 Colors.black.withOpacity(0.8)),
//                           ),
//                           onPressed: () {
//                             serviceLocator<SubscriptionController>()
//                                 .showActiveSubscriptionAmounts(
//                                     walletType: WalletTypes.balance);
//                           },
//                           child: const Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Text(
//                                 '💳 Recharge',
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.normal,
//                                     color: Colors.white),
//                                 textScaler: TextScaler.linear(1.2),
//                               ),
//                               Icon(Icons.arrow_right),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _navigateToUserProfile(BuildContext context, UserData cardUser) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => UserProfilePage(
//           userCubit: userCubit,
//         ),
//       ),
//     );
//   }
//
//   Widget _buildFloatingActionButton(
//       BuildContext context, IconData icon, VoidCallback? onPressed,
//       {Color? color, required String heroTag}) {
//     return FloatingActionButton.small(
//       heroTag: heroTag,
//       onPressed: onPressed,
//       backgroundColor: color,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
//       child: Icon(icon, color: color != null ? Colors.white : null),
//     );
//   }
//
//   void _switchDisplayGender(UserData user) {
//     final gender = user.gender;
//     tinderCubit.fetchUserData(
//       gender: gender == 'female' ? 'female' : 'male',
//       accessToken: userCubit.state.token!.accessToken,
//     );
//   }
//
//   void _showChatTypeAdvancedDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         // Get screen dimensions
//         final screenWidth = MediaQuery.of(context).size.width;
//         final screenHeight = MediaQuery.of(context).size.height;
//
//         // Calculate dynamic sizes based on screen dimensions
//         final dialogWidth = screenWidth * 0.75;
//         final dialogHeight =
//             screenWidth * 0.5; // Adjusted for better responsiveness
//         final titleFontSize = screenHeight * 0.025; // 3% of screen height
//
//         return AlertDialog(
//           title: Padding(
//             padding: EdgeInsets.all(screenHeight * 0.02), // 2% of screen height
//             child: Text(
//               "Pick a Chat Type:",
//               style: Styles.headerText(
//                   fontSize: titleFontSize, fontWeight: FontWeight.bold),
//               textAlign: TextAlign.start,
//             ),
//           ),
//           content: SizedBox(
//             width: dialogWidth,
//             height: dialogHeight,
//             child: FittedBox(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   _buildChatOptionCard(
//                     context,
//                     icon: Icons.visibility_off,
//                     label: "Anonymous",
//                   ),
//                   SizedBox(height: screenHeight * 0.02),
//                   // 2% of screen height for spacing
//                   _buildChatOptionCard(
//                     context,
//                     icon: Icons.visibility,
//                     label: "Regular",
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildChatOptionCard(
//     BuildContext context, {
//     required IconData icon,
//     required String label,
//   }) {
//     // Get screen dimensions
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;
//
//     // Calculate dynamic sizes based on screen dimensions
//     final iconSize = screenWidth * 0.1; // 10% of the screen width
//     final fontSize = screenHeight * 0.023; // 2% of the screen height
//     final padding = screenHeight * 0.01; // 1% of the screen height
//
//     return GestureDetector(
//       onTap: () {
//         Navigator.pop(context);
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => ChatView(
//               initialTabIndex: label == "Anonymous" ? 6 : 0,
//             ),
//           ),
//         );
//       },
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
// }
//-----------------------------------
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

// class TinderCardStack extends StatelessWidget {
//   final UserCubit userCubit;
//
//   const TinderCardStack({
//     super.key,
//     // required this.tinderCubit,
//     required this.userCubit,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final TinderViewCubit tinderCubit = context.watch<TinderViewCubit>();
//     log("TinderCardStack TinderCardStack TinderCardStack===========");
//
//     final screenHeight = MediaQuery.of(context).size.height;
//
//     return SizedBox(
//       height: screenHeight * 2.5 / 4,
//       child: tinderCubit.state.userData.isEmpty
//           ? const Center(child: CircularProgressIndicator())
//           : CardSwiper(
//               cardsCount: tinderCubit.state.userData.length,
//               onSwipe: (previousIndex, currentIndex, direction) {
//                 log("onSwipeonSwipeonSwipeonSwipeonSwipeonSwipe");
//                 tinderCubit
//                   ..fetchLastSeen(
//                     userId: userCubit.state.data!.id,
//                     accessToken: userCubit.state.token!.accessToken,
//                   )
//                   ..checkUserNearby(
//                     cardUserId: userCubit.state.data!.id,
//                     accessToken: userCubit.state.token!.accessToken,
//                   );
//
//                 // log('fetchLastSeen from init ');
//                 // Handle the swipe logic here
//                 // if (direction == CardSwiperDirection.left) {
//                 //   tinderCubit.previousStory();
//                 // } else if (direction == CardSwiperDirection.right) {
//                 //   tinderCubit.nextStory();
//                 // }
//                 return true;
//               },
//               cardBuilder: (context, index, horizontalOffsetPercentage,
//                   verticalOffsetPercentage) {
//                 // final cardUser = tinderCubit.state.userData[index];
//                 // final cardUser = tinderCubit.state.userData[index];
//                 log("cardBuildercardBuildercardBuildercardBuilder");
//
//                 return _cardWidget(context, tinderCubit.state.userData[index],
//                     tinderCubit: tinderCubit);
//               },
//               onEnd: () {
//                 //
//                 // tinderCubit
//                 //   ..fetchLastSeen(
//                 //     userId: userCubit.state.data!.id,
//                 //     accessToken: userCubit.state.token!.accessToken,
//                 //   )
//                 //   ..checkUserNearby(
//                 //     cardUserId: userCubit.state.data!.id,
//                 //     accessToken: userCubit.state.token!.accessToken,
//                 //   );
//                 log("endddddddddddddddddddddddddddddd");
//                 // Handle what happens when there are no more cards
//               },
//               padding: const EdgeInsets.all(16.0),
//               scale: 0.9,
//               duration: const Duration(milliseconds: 200),
//             ),
//     );
//   }
//
//   Widget _cardWidget(BuildContext context, UserData cardUser,
//       {required TinderViewCubit tinderCubit}) {
//     return Padding(
//       padding: const EdgeInsets.all(2.0),
//       child: Card(
//         clipBehavior: Clip.hardEdge,
//         elevation: 2,
//         child: Stack(
//           children: [
//             _buildImage(cardUser, tinderCubit: tinderCubit),
//             _buildGenderSwitch(context, cardUser, tinderCubit: tinderCubit),
//             _buildStoryBar(cardUser, tinderCubit: tinderCubit),
//             // PersonInfoWidget(
//             //   cardUser: cardUser,
//             //   userCubit: userCubit,
//             // ),
//             _buildPersonInfo(context, cardUser,
//                 tinderCubit: tinderCubit, userCubit: userCubit),
//             _buildActions(context, cardUser, tinderCubit: tinderCubit),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildPersonInfo(BuildContext context, UserData cardUser,
//       {required TinderViewCubit tinderCubit, required UserCubit userCubit}) {
//     return Positioned(
//       bottom: kToolbarHeight,
//       right: 8,
//       left: 8,
//       child: Padding(
//         padding: const EdgeInsets.all(4.0),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 BadgedLabel(
//                   color: AppColors.WHATS_APP_COLOR,
//                   label: context
//                           .watch<TinderViewCubit>()
//                           .state
//                           .lastSeenModel
//                           ?.data
//                           ?.status ??
//                       'N/A',
//                 ),
//                 const SizedBox(width: 10),
//                 BadgedLabel(
//                   color: AppColors.SECONDARY_COLOR,
//                   label: (context.watch<TinderViewCubit>().state.isUserNearby !=
//                               null &&
//                           context
//                                   .watch<TinderViewCubit>()
//                                   .state
//                                   .isUserNearby!
//                                   .data !=
//                               null)
//                       ? ((context
//                                   .watch<TinderViewCubit>()
//                                   .state
//                                   .isUserNearby!
//                                   .data!
//                                   .isNearBy ==
//                               true)
//                           ? 'Nearby'
//                           : 'is not Nearby')
//                       : "N/A",
//                 ),
//               ],
//             ),
//             ListTile(
//               contentPadding: EdgeInsets.zero,
//               title: Text(
//                 TinderSharedUtils.capitalizeEachWord(
//                     "${cardUser.firstName} ${cardUser.lastName}"),
//                 textScaler: const TextScaler.linear(2),
//                 style: Styles.headerText(
//                     color: AppColors.PRIMARY_COLOR,
//                     // fontSize: 38,
//                     fontWeight: FontWeight.bold),
//               ),
//               subtitle: Text(
//                 context
//                             .watch<TinderViewCubit>()
//                             .state
//                             .lastSeenModel
//                             ?.data
//                             ?.lastSeen !=
//                         null
//                     ? "Last seen ${getTimeAgo(context.watch<TinderViewCubit>().state.lastSeenModel!.data!.lastSeen ?? '')}"
//                     : "Last seen ",
//                 style: Styles.mediumText(
//                     color: AppColors.PRIMARY_COLOR,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 16),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildImage(UserData user, {required TinderViewCubit tinderCubit}) {
//     final imageUrl = user.pictures.isNotEmpty
//         ? user.pictures.reversed
//             .toList()[tinderCubit.state.currentStoryIndex]
//             .mediaKey
//         : UIConst.profilePlaceHolder;
//
//     return Hero(
//       tag: 'userHero-${user.id}',
//       child: Image.network(
//         imageUrl,
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
//   Widget _buildGenderSwitch(BuildContext context, UserData user,
//       {required TinderViewCubit tinderCubit}) {
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
//           child: IconButton(
//             onPressed: () =>
//                 _switchDisplayGender(user, tinderCubit: tinderCubit),
//             iconSize: 50,
//             icon: Icon(user.gender == 'male' ? Icons.female : Icons.male,
//                 color: Colors.black),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildStoryBar(UserData user, {required TinderViewCubit tinderCubit}) {
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
//                 color: dotIndex == tinderCubit.state.currentStoryIndex
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
//   Widget _buildActions(BuildContext context, UserData user,
//       {required TinderViewCubit tinderCubit}) {
//     return Positioned(
//       bottom: 4,
//       right: 8,
//       left: 8,
//       child: Padding(
//         padding: const EdgeInsets.all(4.0),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             _buildFloatingActionButton(
//               context,
//               Icons.person,
//               () => context.push(Routes.OTHERSACCOUNT),
//               heroTag: 'personButton',
//             ),
//             _buildFloatingActionButton(
//               context,
//               Icons.chat,
//               () => _showChatTypeAdvancedDialog(context),
//               color: AppColors.PRIMARY_COLOR,
//               heroTag: 'chatButton',
//             ),
//             _buildFloatingActionButton(
//               context,
//               Icons.add_photo_alternate_outlined,
//               () => _navigateToUserProfile(context, user),
//               color: Colors.red,
//               heroTag: 'photoButton',
//             ),
//             _buildFloatingActionButton(
//               context,
//               Icons.card_giftcard,
//               () => _showGiftBottomSheet22(context),
//               color: AppColors.ACCENT_COLOR,
//               heroTag: 'giftButton',
//             ),
//             _buildFloatingActionButton(
//               context,
//               Icons.report,
//               () => _showReportBottomSheet(context, user),
//               color: Colors.red,
//               heroTag: 'reportButton',
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void _showReportBottomSheet(BuildContext context, UserData user) {
//     final userState = userCubit.state.data;
//     if (userState != null) {
//       showModalBottomSheet(
//         context: context,
//         builder: (context) => SizedBox(
//           height: MediaQuery.of(context).size.height / 1.5,
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: ReportView(
//               id: userState.id,
//               categoryId: '66af974f8bf69f9469944746',
//             ),
//           ),
//         ),
//       );
//     }
//   }
//
//   void _showGiftBottomSheet22(BuildContext context) {
//     closeAllBottomSheets(context);
//
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.black.withOpacity(0.8),
//       builder: (context) => MultiBlocProvider(
//         providers: [
//           BlocProvider(create: (_) => GiftsCubit()),
//           BlocProvider(create: (_) => TinderViewCubit()),
//           BlocProvider(create: (_) => userCubit),
//         ],
//         child: SizedBox(
//           height: MediaQuery.of(context).size.height / 2,
//           child: Column(
//             children: [
//               Container(
//                 width: double.infinity,
//                 height: kToolbarHeight * 0.80,
//                 decoration: BoxDecoration(
//                   color: Colors.black.withOpacity(0.4),
//                   borderRadius:
//                       const BorderRadius.vertical(top: Radius.circular(20)),
//                 ),
//                 child: const FittedBox(
//                   fit: BoxFit.scaleDown,
//                   child: Text(
//                     'Send a gift 🎁',
//                     style: TextStyle(
//                       color: AppColors.ACCENT_COLOR,
//                       fontWeight: FontWeight.w300,
//                     ),
//                     textAlign: TextAlign.center,
//                     textScaler: TextScaler.linear(1.6),
//                   ),
//                 ),
//               ),
//               Expanded(
//                 child: Stack(
//                   children: [
//                     BottomSheetContent(
//                       userCubit: userCubit,
//                       accessToken: userCubit.state.token!.accessToken,
//                     ),
//                     Positioned(
//                       bottom: 5,
//                       right: 5,
//                       child: Padding(
//                         padding: const EdgeInsets.all(4.0),
//                         child: OutlinedButton(
//                           style: ButtonStyle(
//                             side: const MaterialStatePropertyAll(
//                                 BorderSide(width: 0)),
//                             iconColor:
//                                 const MaterialStatePropertyAll(Colors.white),
//                             backgroundColor: MaterialStatePropertyAll(
//                                 Colors.black.withOpacity(0.8)),
//                           ),
//                           onPressed: () {
//                             serviceLocator<SubscriptionController>()
//                                 .showActiveSubscriptionAmounts(
//                                     walletType: WalletTypes.balance);
//                           },
//                           child: const Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Text(
//                                 '💳 Recharge',
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.normal,
//                                     color: Colors.white),
//                                 textScaler: TextScaler.linear(1.2),
//                               ),
//                               Icon(Icons.arrow_right),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _navigateToUserProfile(BuildContext context, UserData cardUser) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => UserProfilePage(
//           userCubit: userCubit,
//         ),
//       ),
//     );
//   }
//
//   Widget _buildFloatingActionButton(
//       BuildContext context, IconData icon, VoidCallback? onPressed,
//       {Color? color, required String heroTag}) {
//     return FloatingActionButton.small(
//       heroTag: heroTag,
//       onPressed: onPressed,
//       backgroundColor: color,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
//       child: Icon(icon, color: color != null ? Colors.white : null),
//     );
//   }
//
//   void _switchDisplayGender(UserData user,
//       {required TinderViewCubit tinderCubit}) {
//     final gender = user.gender;
//     tinderCubit.fetchUserData(
//       gender: gender == 'female' ? 'female' : 'male',
//       accessToken: userCubit.state.token!.accessToken,
//     );
//   }
//
//   void _showChatTypeAdvancedDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         // Get screen dimensions
//         final screenWidth = MediaQuery.of(context).size.width;
//         final screenHeight = MediaQuery.of(context).size.height;
//
//         // Calculate dynamic sizes based on screen dimensions
//         final dialogWidth = screenWidth * 0.75;
//         final dialogHeight =
//             screenWidth * 0.5; // Adjusted for better responsiveness
//         final titleFontSize = screenHeight * 0.025; // 3% of screen height
//
//         return AlertDialog(
//           title: Padding(
//             padding: EdgeInsets.all(screenHeight * 0.02), // 2% of screen height
//             child: Text(
//               "Pick a Chat Type:",
//               style: Styles.headerText(
//                   fontSize: titleFontSize, fontWeight: FontWeight.bold),
//               textAlign: TextAlign.start,
//             ),
//           ),
//           content: SizedBox(
//             width: dialogWidth,
//             height: dialogHeight,
//             child: FittedBox(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   _buildChatOptionCard(
//                     context,
//                     icon: Icons.visibility_off,
//                     label: "Anonymous",
//                   ),
//                   SizedBox(height: screenHeight * 0.02),
//                   // 2% of screen height for spacing
//                   _buildChatOptionCard(
//                     context,
//                     icon: Icons.visibility,
//                     label: "Regular",
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildChatOptionCard(
//     BuildContext context, {
//     required IconData icon,
//     required String label,
//   }) {
//     // Get screen dimensions
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;
//
//     // Calculate dynamic sizes based on screen dimensions
//     final iconSize = screenWidth * 0.1; // 10% of the screen width
//     final fontSize = screenHeight * 0.023; // 2% of the screen height
//     final padding = screenHeight * 0.01; // 1% of the screen height
//
//     return GestureDetector(
//       onTap: () {
//         Navigator.pop(context);
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => ChatView(
//               initialTabIndex: label == "Anonymous" ? 6 : 0,
//             ),
//           ),
//         );
//       },
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
// }

class TinderCardStack extends StatelessWidget {
  final UserCubit userCubit;

  const TinderCardStack({
    super.key,
    required this.userCubit,
  });

  @override
  Widget build(BuildContext context) {
    final TinderViewCubit tinderCubit = context.watch<TinderViewCubit>();
    final screenHeight = MediaQuery.of(context).size.height;

    // Check if there are any users to display
    final hasCards = tinderCubit.state.userData.isNotEmpty;
    return SizedBox(
      height: screenHeight * 2.5 / 4,
      child: !hasCards
          ? const Center(child: CircularProgressIndicator())
          : CardSwiper(
        cardsCount: tinderCubit.state.userData.length,
        onSwipe: (previousIndex, currentIndex, direction) {
          // Fetch updated data on every swipe
          tinderCubit
            ..fetchLastSeen(
              accessToken: userCubit.state.token!.accessToken,
              userId: tinderCubit.state.userData[currentIndex!].id!,
            )
            ..checkUserNearby(
              cardUserId: tinderCubit.state.userData[currentIndex].id!,
              accessToken: userCubit.state.token!.accessToken,
            );
          return true;
        },
        cardBuilder: (context, index, horizontalOffsetPercentage,
            verticalOffsetPercentage) {
          return _cardWidget(
            context,
            tinderCubit.state.userData[index],
            tinderCubit: tinderCubit,
          );
        },
        onEnd: () {
          // Handle end of the card stack
        },
        padding: const EdgeInsets.all(16.0),
        scale: 0.9,
        duration: const Duration(milliseconds: 200),
      ),
    );
  }

  void _handleSwipe(BuildContext context, CardSwiperDirection direction,
      TinderViewCubit tinderCubit) {
    final UserCubit userCubit = context.read<UserCubit>();

    // Fetch data based on the swipe
    tinderCubit
      ..fetchLastSeen(
        userId: userCubit.state.data!.id,
        accessToken: userCubit.state.token!.accessToken,
      )
      ..checkUserNearby(
        cardUserId: userCubit.state.data!.id,
        accessToken: userCubit.state.token!.accessToken,
      );

    if (direction == CardSwiperDirection.left) {
      tinderCubit.previousStory();
    } else if (direction == CardSwiperDirection.right) {
      tinderCubit.nextStory();
    }
  }

  Widget _cardWidget(BuildContext context, UserData cardUser,
      {required TinderViewCubit tinderCubit}) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Card(
        clipBehavior: Clip.hardEdge,
        elevation: 2,
        child: Stack(
          children: [
            _buildImage(cardUser, tinderCubit: tinderCubit),
            _buildGenderSwitch(context, cardUser, tinderCubit: tinderCubit),
            _buildStoryBar(cardUser, tinderCubit: tinderCubit),
            _buildPersonInfo(context, cardUser,
                tinderCubit: tinderCubit, userCubit: userCubit),
            _buildActions(context, cardUser, tinderCubit: tinderCubit),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonInfo(BuildContext context, UserData cardUser,
      {required TinderViewCubit tinderCubit, required UserCubit userCubit}) {
    return BlocBuilder<TinderViewCubit, TinderViewState>(
      builder: (context, state) {
        return Positioned(
          bottom: kToolbarHeight,
          right: 8,
          left: 8,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    BadgedLabel(
                      color: AppColors.WHATS_APP_COLOR,
                      label: state.lastSeenModel?.data?.status ?? 'N/A',
                    ),
                    const SizedBox(width: 10),
                    BadgedLabel(
                      color: AppColors.SECONDARY_COLOR,
                      label: (state.isUserNearby != null &&
                          state.isUserNearby!.data != null)
                          ? ((state.isUserNearby!.data!.isNearBy == true)
                          ? 'Nearby'
                          : 'is not Nearby')
                          : "N/A",
                    ),
                  ],
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    TinderSharedUtils.capitalizeEachWord(
                        "${cardUser.firstName} ${cardUser.lastName}"),
                    textScaler: const TextScaler.linear(2),
                    style: Styles.headerText(
                        color: AppColors.PRIMARY_COLOR,
                        fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    state.lastSeenModel?.data?.lastSeen != null
                        ? "Last seen ${getTimeAgo(state.lastSeenModel!.data!.lastSeen ?? '')}"
                        : "Last seen ",
                    style: Styles.mediumText(
                        color: AppColors.PRIMARY_COLOR,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildImage(UserData user, {required TinderViewCubit tinderCubit}) {
    final imageUrl = user.pictures.isNotEmpty
        ? user.pictures.reversed
        .toList()[tinderCubit.state.currentStoryIndex]
        .mediaKey
        : UIConst.profilePlaceHolder;

    return Hero(
      tag: 'userHero-${user.id}',
      child: Image.network(
        imageUrl,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.fitHeight,
        errorBuilder: (_, __, ___) => Image.network(
          UIConst.profilePlaceHolder,
          fit: BoxFit.fitHeight,
          height: double.infinity,
        ),
      ),
    );
  }

  Widget _buildGenderSwitch(BuildContext context, UserData user,
      {required TinderViewCubit tinderCubit}) {
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
            onPressed: () =>
                _switchDisplayGender(user, tinderCubit: tinderCubit),
            iconSize: 50,
            icon: Icon(user.gender == 'male' ? Icons.female : Icons.male,
                color: Colors.black),
          ),
        ),
      ),
    );
  }

  Widget _buildStoryBar(UserData user, {required TinderViewCubit tinderCubit}) {
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
                color: dotIndex == tinderCubit.state.currentStoryIndex
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

  Widget _buildActions(BuildContext context, UserData user,
      {required TinderViewCubit tinderCubit}) {
    return Positioned(
      bottom: 4,
      right: 8,
      left: 8,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildFloatingActionButton(
              context,
              Icons.person,
                  () => context.push(Routes.OTHERSACCOUNT),
              heroTag: 'personButton',
            ),
            _buildFloatingActionButton(
              context,
              Icons.chat,
                  () => _showChatTypeAdvancedDialog(context),
              color: AppColors.PRIMARY_COLOR,
              heroTag: 'chatButton',
            ),
            _buildFloatingActionButton(
              context,
              Icons.add_photo_alternate_outlined,
                  () => _navigateToUserProfile(context, user),
              color: Colors.red,
              heroTag: 'photoButton',
            ),
            _buildFloatingActionButton(
              context,
              Icons.card_giftcard,
                  () => _showGiftBottomSheet22(context),
              color: AppColors.ACCENT_COLOR,
              heroTag: 'giftButton',
            ),
            _buildFloatingActionButton(
              context,
              Icons.report,
                  () => _showReportBottomSheet(context, user),
              color: Colors.red,
              heroTag: 'reportButton',
            ),
          ],
        ),
      ),
    );
  }

  void _showReportBottomSheet(BuildContext context, UserData user) {
    final userState = userCubit.state.data;
    if (userState != null) {
      showModalBottomSheet(
        context: context,
        builder: (context) => SizedBox(
          height: MediaQuery.of(context).size.height / 1.5,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ReportView(
              id: userState.id,
              categoryId: '66af974f8bf69f9469944746',
            ),
          ),
        ),
      );
    }
  }

  void _showGiftBottomSheet22(BuildContext context) {
    closeAllBottomSheets(context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black.withOpacity(0.8),
      builder: (context) => MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => GiftsCubit()),
          BlocProvider(create: (_) => TinderViewCubit()),
          BlocProvider(create: (_) => userCubit),
        ],
        child: SizedBox(
          height: MediaQuery.of(context).size.height / 2,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: kToolbarHeight * 0.80,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: const FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Send a gift 🎁',
                    style: TextStyle(
                      color: AppColors.ACCENT_COLOR,
                      fontWeight: FontWeight.w300,
                    ),
                    textAlign: TextAlign.center,
                    textScaler: TextScaler.linear(1.6),
                  ),
                ),
              ),
              Expanded(
                child: Stack(
                  children: [
                    BottomSheetContent(
                      userCubit: userCubit,
                      accessToken: userCubit.state.token!.accessToken,
                    ),
                    Positioned(
                      bottom: 5,
                      right: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: OutlinedButton(
                          style: ButtonStyle(
                            side: const MaterialStatePropertyAll(
                                BorderSide(width: 0)),
                            iconColor:
                            const MaterialStatePropertyAll(Colors.white),
                            backgroundColor: MaterialStatePropertyAll(
                                Colors.black.withOpacity(0.8)),
                          ),
                          onPressed: () {
                            serviceLocator<SubscriptionController>()
                                .showActiveSubscriptionAmounts(
                                walletType: WalletTypes.balance);
                          },
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '💳 Recharge',
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white),
                                textScaler: TextScaler.linear(1.2),
                              ),
                              Icon(Icons.arrow_right),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToUserProfile(BuildContext context, UserData cardUser) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserProfilePage(
          userCubit: userCubit,
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton(
      BuildContext context, IconData icon, VoidCallback? onPressed,
      {Color? color, required String heroTag}) {
    return FloatingActionButton.small(
      heroTag: UniqueKey(),
      onPressed: onPressed,
      backgroundColor: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      child: Icon(icon, color: color != null ? Colors.white : null),
    );
  }

  void _switchDisplayGender(UserData user,
      {required TinderViewCubit tinderCubit}) {
    final gender = user.gender;
    tinderCubit.fetchUserData(
      gender: gender == 'female' ? 'female' : 'male',
      accessToken: userCubit.state.token!.accessToken,
    );
  }

  void _showChatTypeAdvancedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Get screen dimensions
        final screenWidth = MediaQuery.of(context).size.width;
        final screenHeight = MediaQuery.of(context).size.height;

        // Calculate dynamic sizes based on screen dimensions
        final dialogWidth = screenWidth * 0.75;
        final dialogHeight =
            screenWidth * 0.5; // Adjusted for better responsiveness
        final titleFontSize = screenHeight * 0.025; // 3% of screen height

        return AlertDialog(
          title: Padding(
            padding: EdgeInsets.all(screenHeight * 0.02), // 2% of screen height
            child: Text(
              "Pick a Chat Type:",
              style: Styles.headerText(
                  fontSize: titleFontSize, fontWeight: FontWeight.bold),
              textAlign: TextAlign.start,
            ),
          ),
          content: SizedBox(
            width: dialogWidth,
            height: dialogHeight,
            child: FittedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildChatOptionCard(
                    context,
                    icon: Icons.visibility_off,
                    label: "Anonymous",
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  _buildChatOptionCard(
                    context,
                    icon: Icons.visibility,
                    label: "Regular",
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildChatOptionCard(
      BuildContext context, {
        required IconData icon,
        required String label,
      }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final iconSize = screenWidth * 0.1; // 10% of the screen width
    final fontSize = screenHeight * 0.023; // 2% of the screen height
    final padding = screenHeight * 0.01; // 1% of the screen height

    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatView(
              initialTabIndex: label == "Anonymous" ? 6 : 0,
            ),
          ),
        );
      },
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
}

//--------------------------------
// import 'package:card_swiper/card_swiper.dart';
//
// class TinderCardStack extends StatelessWidget {
//   final TinderViewCubit tinderCubit;
//   final UserCubit userCubit;
//
//   const TinderCardStack({
//     super.key,
//     required this.tinderCubit,
//     required this.userCubit,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final screenHeight = MediaQuery.of(context).size.height;
//
//     return Swiper(
//
//       itemCount: tinderCubit.state.userData.length,
//       itemBuilder: (BuildContext context, int index) {
//         return _cardWidget(context, tinderCubit.state.userData[index]);
//       },
//       onIndexChanged: (index) {
//         // tinderCubit.updateCurrentIndex(index);
//       },
//       loop: false,
//       itemWidth: MediaQuery.of(context).size.width,
//       itemHeight: screenHeight * 2.5 / 4,
//       layout: SwiperLayout.TINDER,
//       onTap: (index) {
//         final screenWidth = MediaQuery.of(context).size.width;
//         final tapPosition = screenWidth / 2;
//
//         tapPosition < screenWidth / 2
//             ? tinderCubit.previousStory()
//             : tinderCubit.nextStory();
//       },
//     );
//   }
//
//   Widget _cardWidget(BuildContext context, UserData cardUser) {
//     return Padding(
//       padding: const EdgeInsets.all(2.0),
//       child: Card(
//         clipBehavior: Clip.hardEdge,
//         elevation: 2,
//         child: Stack(
//           children: [
//             _buildImage(cardUser),
//             _buildGenderSwitch(context, cardUser),
//             _buildStoryBar(cardUser),
//             PersonInfoWidget(
//               cardUser: cardUser,
//               userCubit: userCubit,
//             ),
//             _buildActions(context, cardUser),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildImage(UserData user) {
//     final imageUrl = user.pictures.isNotEmpty
//         ? user.pictures.reversed
//             .toList()[tinderCubit.state.currentStoryIndex]
//             .mediaKey
//         : UIConst.profilePlaceHolder;
//
//     return Hero(
//       tag: 'userHero-${user.id}',
//       child: Image.network(
//         imageUrl,
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
//           child: IconButton(
//             onPressed: () => _switchDisplayGender(user),
//             iconSize: 50,
//             icon: Icon(user.gender == 'male' ? Icons.female : Icons.male,
//                 color: Colors.black),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildStoryBar(UserData user) {
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
//                 color: dotIndex == tinderCubit.state.currentStoryIndex
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
//   Widget _buildActions(BuildContext context, UserData user) {
//     return Positioned(
//       bottom: 4,
//       right: 8,
//       left: 8,
//       child: Padding(
//         padding: const EdgeInsets.all(4.0),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             _buildFloatingActionButton(
//               context,
//               Icons.person,
//               () => context.push(Routes.OTHERSACCOUNT),
//               heroTag: 'personButton',
//             ),
//             _buildFloatingActionButton(
//               context,
//               Icons.chat,
//               () => _showChatTypeAdvancedDialog(context),
//               color: AppColors.PRIMARY_COLOR,
//               heroTag: 'chatButton',
//             ),
//             _buildFloatingActionButton(
//               context,
//               Icons.add_photo_alternate_outlined,
//               () => _navigateToUserProfile(context, user),
//               color: Colors.red,
//               heroTag: 'photoButton',
//             ),
//             _buildFloatingActionButton(
//               context,
//               Icons.card_giftcard,
//               () => _showGiftBottomSheet22(context),
//               color: AppColors.ACCENT_COLOR,
//               heroTag: 'giftButton',
//             ),
//             _buildFloatingActionButton(
//               context,
//               Icons.report,
//               () => _showReportBottomSheet(context, user),
//               color: Colors.red,
//               heroTag: 'reportButton',
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void _switchDisplayGender(UserData user) {
//     final gender = user.gender;
//     tinderCubit.fetchUserData(
//       gender: gender == 'female' ? 'female' : 'male',
//       accessToken: userCubit.state.token!.accessToken,
//     );
//   }
//
//   void _showChatTypeAdvancedDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         final screenWidth = MediaQuery.of(context).size.width;
//         final screenHeight = MediaQuery.of(context).size.height;
//         final dialogWidth = screenWidth * 0.75;
//         final dialogHeight = screenWidth * 0.5;
//         final titleFontSize = screenHeight * 0.025;
//
//         return AlertDialog(
//           title: Padding(
//             padding: EdgeInsets.all(screenHeight * 0.02),
//             child: Text(
//               "Pick a Chat Type:",
//               style: Styles.headerText(
//                   fontSize: titleFontSize, fontWeight: FontWeight.bold),
//               textAlign: TextAlign.start,
//             ),
//           ),
//           content: SizedBox(
//             width: dialogWidth,
//             height: dialogHeight,
//             child: FittedBox(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   _buildChatOptionCard(
//                     context,
//                     icon: Icons.visibility_off,
//                     label: "Anonymous",
//                   ),
//                   SizedBox(height: screenHeight * 0.02),
//                   _buildChatOptionCard(
//                     context,
//                     icon: Icons.visibility,
//                     label: "Regular",
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   void _showReportBottomSheet(BuildContext context, UserData user) {
//     final userState = userCubit.state.data;
//     if (userState != null) {
//       showModalBottomSheet(
//         context: context,
//         builder: (context) => SizedBox(
//           height: MediaQuery.of(context).size.height / 1.5,
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: ReportView(
//               id: userState.id,
//               categoryId: '66af974f8bf69f9469944746',
//             ),
//           ),
//         ),
//       );
//     }
//   }
//
//   void _showGiftBottomSheet22(BuildContext context) {
//     closeAllBottomSheets(context);
//
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.black.withOpacity(0.8),
//       builder: (context) => MultiBlocProvider(
//         providers: [
//           BlocProvider(create: (_) => GiftsCubit()),
//           BlocProvider(create: (_) => TinderViewCubit()),
//           BlocProvider(create: (_) => userCubit),
//         ],
//         child: SizedBox(
//           height: MediaQuery.of(context).size.height / 2,
//           child: Column(
//             children: [
//               Container(
//                 width: double.infinity,
//                 height: kToolbarHeight * 0.80,
//                 decoration: BoxDecoration(
//                   color: Colors.black.withOpacity(0.4),
//                   borderRadius:
//                       const BorderRadius.vertical(top: Radius.circular(20)),
//                 ),
//                 child: const FittedBox(
//                   fit: BoxFit.scaleDown,
//                   child: Text(
//                     'Send a gift 🎁',
//                     style: TextStyle(
//                       color: AppColors.ACCENT_COLOR,
//                       fontWeight: FontWeight.w300,
//                     ),
//                     textAlign: TextAlign.center,
//                     textScaler: TextScaler.linear(1.6),
//                   ),
//                 ),
//               ),
//               Expanded(
//                 child: Stack(
//                   children: [
//                     BottomSheetContent(
//                       userCubit: userCubit,
//                       accessToken: userCubit.state.token!.accessToken,
//                     ),
//                     Positioned(
//                       bottom: 5,
//                       right: 5,
//                       child: Padding(
//                         padding: const EdgeInsets.all(4.0),
//                         child: OutlinedButton(
//                           style: ButtonStyle(
//                             side: const MaterialStatePropertyAll(
//                                 BorderSide(width: 0)),
//                             iconColor:
//                                 const MaterialStatePropertyAll(Colors.white),
//                             backgroundColor: MaterialStatePropertyAll(
//                                 Colors.black.withOpacity(0.8)),
//                           ),
//                           onPressed: () {
//                             serviceLocator<SubscriptionController>()
//                                 .showActiveSubscriptionAmounts(
//                                     walletType: WalletTypes.balance);
//                           },
//                           child: const Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Text(
//                                 '💳 Recharge',
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.normal,
//                                     color: Colors.white),
//                                 textScaler: TextScaler.linear(1.2),
//                               ),
//                               Icon(Icons.arrow_right),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _navigateToUserProfile(BuildContext context, UserData cardUser) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => UserProfilePage(
//           userCubit: userCubit,
//         ),
//       ),
//     );
//   }
//
//   Widget _buildFloatingActionButton(
//       BuildContext context, IconData icon, VoidCallback? onPressed,
//       {Color? color, required String heroTag}) {
//     return FloatingActionButton.small(
//       heroTag: heroTag,
//       onPressed: onPressed,
//       backgroundColor: color,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
//       child: Icon(icon, color: color != null ? Colors.white : null),
//     );
//   }
//
//   Widget _buildChatOptionCard(
//     BuildContext context, {
//     required IconData icon,
//     required String label,
//   }) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;
//     final iconSize = screenWidth * 0.1;
//     final fontSize = screenHeight * 0.023;
//     final padding = screenHeight * 0.01;
//
//     return GestureDetector(
//       onTap: () {
//         Navigator.pop(context);
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => ChatView(
//               initialTabIndex: label == "Anonymous" ? 6 : 0,
//             ),
//           ),
//         );
//       },
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
// }
