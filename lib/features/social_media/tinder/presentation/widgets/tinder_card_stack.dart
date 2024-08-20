import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/badged_label.dart';
import 'package:fourtyninehub/core/enums/wallet_types_enums.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/controllers/chat_cubit/chat_room_cubit.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/pages/Chat_room.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/presentation/chat_cubit/chat_cubit.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/models/tinder_person_model.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/shared/shared.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/shared/tinder_shared_utils.dart';
import 'package:fourtyninehub/features/social_media/tinder/presentation/cubit/gift_cubit.dart';
import 'package:fourtyninehub/features/social_media/tinder/presentation/cubit/tinder_cubit.dart';
import 'package:fourtyninehub/features/social_media/tinder/presentation/cubit/tinder_state.dart';
import 'package:fourtyninehub/features/social_media/tinder/presentation/pages/tinder_view.dart';
import 'package:fourtyninehub/features/social_media/tinder/presentation/pages/user_profile.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/widgets/report_view.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';

import '../../../../subscripe/presentation/controllers/subscription_controller.dart';

class TinderCardStack extends StatelessWidget {
  final UserCubit userCubit;

  const TinderCardStack({
    super.key,
    required this.userCubit,
  });
  @override
  Widget build(BuildContext context) {
    final TinderViewCubit tinderCubit = context.watch<TinderViewCubit>();
    // final UserCubit innerUserCubit = context.watch<UserCubit>();
    // ..giveMeTokenForTinder();
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
                if (currentIndex != null) {
                  // Fetch updated data on every swipe
                  final userId =
                      tinderCubit.state.userData[currentIndex].id ?? '';
                  if (userId.isNotEmpty) {
                    tinderCubit
                      ..fetchLastSeen(
                        accessToken: userCubit.state.token?.accessToken ?? '',
                        userId: userId,
                      )
                      ..checkUserNearby(
                        cardUserId: userId,
                        accessToken: userCubit.state.token?.accessToken ?? '',
                      );
                  }
                }
                return true;
              },
              cardBuilder: (context, index, horizontalOffsetPercentage,
                  verticalOffsetPercentage) {
                return _cardWidget(context, tinderCubit.state.userData[index],
                    tinderCubit: tinderCubit, innerUserCubit: userCubit);
              },
              onEnd: () {
                // Handle end of the card stack
              },
              padding: const EdgeInsets.all(4.0),
              scale: 0.88,
              duration: const Duration(milliseconds: 150),
            ),
    );
  }

  Widget _cardWidget(BuildContext context, UserData cardUser,
      {required TinderViewCubit tinderCubit,
      required UserCubit innerUserCubit}) {
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
            _buildActions(context, cardUser,
                tinderCubit: tinderCubit, innerUserCubit: innerUserCubit),
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
                      label: (state.isUserNearby?.data?.isNearBy ?? false)
                          ? 'Nearby'
                          : 'Not Nearby',
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
                        : "Last seen N/A",
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
    final imageUrl = (user.pictures.isNotEmpty
        ? user.pictures.reversed
            .toList()[tinderCubit.state.currentStoryIndex]
            .mediaKey
        : user.profilePicture.toString());

    return Hero(
      tag: UniqueKey(),
      child: Image.network(
        // Check if imageUrl is valid, otherwise use the placeholder
        imageUrl.isNotEmpty && Uri.tryParse(imageUrl)?.hasAbsolutePath == true
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
                color: dotIndex == (tinderCubit.state.currentStoryIndex)
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

  Widget _buildActions(BuildContext context, UserData cardUser,
      {required TinderViewCubit tinderCubit,
      required UserCubit innerUserCubit}) {
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
              () => _showChatTypeAdvancedDialog(context,
                  cardUser: cardUser, tinderCubit: tinderCubit),
              color: AppColors.PRIMARY_COLOR,
              heroTag: 'chatButton',
            ),
            _buildFloatingActionButton(
              context,
              Icons.add_photo_alternate_outlined,
              () => _navigateToUserProfile(context, cardUser),
              color: Colors.red,
              heroTag: 'photoButton',
            ),
            _buildFloatingActionButton(
              context,
              Icons.card_giftcard,
              () => _showGiftBottomSheet22(context, cardUser: cardUser),
              color: AppColors.ACCENT_COLOR,
              heroTag: 'giftButton',
            ),
            _buildFloatingActionButton(
              context,
              Icons.report,
              () => _showReportBottomSheet(context, cardUser, userCubit),
              color: Colors.red,
              heroTag: 'reportButton',
            ),
          ],
        ),
      ),
    );
  }

  void _showReportBottomSheet(
      BuildContext context, UserData user, UserCubit innerUserCubit) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SizedBox(
        // height: MediaQuery.of(context).size.height ,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ReportView(
            id: context.read<UserCubit>().state.data!.id,
            categoryId: '66af974f8bf69f9469944746',
          ),
        ),
      ),
    );
  }

  void _showGiftBottomSheet22(BuildContext context,
      {required UserData cardUser}) {
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
                        accessToken: userCubit.state.token?.accessToken ?? '',
                        cardUser: cardUser),
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
        builder: (context) => BlocProvider.value(
          value: TinderViewCubit(),
          child: UserProfilePage(
            userCubit: userCubit,
          ),
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
      accessToken: userCubit.state.token?.accessToken ?? '',
    );
  }

  void _showChatTypeAdvancedDialog(BuildContext context,
      {required UserData cardUser, required TinderViewCubit tinderCubit}) {
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
        final titleFontSize = screenHeight * 0.025; // 2.5% of screen height

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
                  _buildChatOptionCard(context,
                      icon: Icons.visibility_off,
                      label: "Anonymous",
                      cardUser: cardUser,
                      tinderCubit: tinderCubit),
                  SizedBox(height: screenHeight * 0.02),
                  _buildChatOptionCard(context,
                      icon: Icons.visibility,
                      label: "Regular",
                      cardUser: cardUser,
                      tinderCubit: tinderCubit),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void showMessageDialog(BuildContext context, chatID) {
    final TextEditingController messageController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Send Message',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20.0),
                TextField(
                  controller: messageController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Your Message',
                  ),
                  maxLines: 5,
                ),
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Add your send message logic here
                        String message = messageController.text;
                        Navigator.of(context).pop();

                        context.read<ChatRoomCubit>().sendMessageFromTinder(
                            message: message, chatID: chatID);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      child: const Text('Send'),
                    ),
                  ],
                ),
              ],
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
    required UserData cardUser,
    required TinderViewCubit tinderCubit,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final iconSize = screenWidth * 0.1; // 10% of the screen width
    final fontSize = screenHeight * 0.023; // 2.3% of the screen height
    final padding = screenHeight * 0.01; // 1% of the screen height

    return BlocProvider(
      create: (context) => serviceLocator<ChatRoomCubit>(),
      child: GestureDetector(
        onTap: () {
          if (label == "Anonymous") {
            tinderCubit
                .startAnonymousChat(
              receiverId: cardUser.id ?? '',
              accessToken: userCubit.state.token?.accessToken ?? '',
            )
                .then((value) {
              final chatId =
                  tinderCubit.state.anonymousChatResponse?.data.chat.id ?? '';
              if (chatId.isNotEmpty) {
                context.read<ChatsCubit>().initSocketConnection();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlocProvider<ChatRoomCubit>(
                        create: (_) => serviceLocator(),
                        child: ChatRoom(
                          chatId: chatId,
                        ),
                      ),
                    ));
              }
            });
          } else {
            tinderCubit
                .startNormalChat(
              receiverId: cardUser.id ?? '',
              subCategoryId: '62c8be6f8e28a58a3edf5f4f',
              accessToken: userCubit.state.token?.accessToken ?? '',
            )
                .then((value) {
              final chatId =
                  tinderCubit.state.normalChatResponse?.data.chat.id ?? '';
              if (chatId.isNotEmpty) {
                context.read<ChatsCubit>().initSocketConnection();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlocProvider<ChatRoomCubit>(
                        create: (_) => serviceLocator(),
                        child: ChatRoom(
                          chatId: chatId,
                        ),
                      ),
                    ));
              }
            });
          }
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
      ),
    );
  }
}
//.......
