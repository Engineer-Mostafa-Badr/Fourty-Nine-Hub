import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/functions/helper/auth_helper.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/badged_label.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/enums/wallet_types_enums.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/presentation/pages/Chat_view.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/models/tinder_person_model.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/shared/shared.dart';
import 'package:fourtyninehub/features/social_media/tinder/presentation/cubit/gift_cubit.dart';
import 'package:fourtyninehub/features/social_media/tinder/presentation/cubit/tinder_cubit.dart';
import 'package:fourtyninehub/features/social_media/tinder/presentation/pages/user_profile.dart';
import 'package:fourtyninehub/features/social_media/tinder/presentation/widgets/tinder_card_stack.dart';
import 'package:fourtyninehub/features/social_media/tinder/presentation/widgets/tinder_sub_category_card.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/widgets/report_view.dart';
import 'package:fourtyninehub/features/subscripe/presentation/controllers/subscription_controller.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

// Extracted constants for repeated values
const kToolbarHeightFactor = 0.80;
const kDefaultPadding = 8.0;

class TinderView extends StatelessWidget {
  const TinderView({super.key});

  @override
  Widget build(BuildContext context) {
    log('TinderView built');
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => TinderViewCubit()),
        BlocProvider(create: (context) => _createUserCubit()),
      ],
      child: const TinderScreen(),
    );
  }

  UserCubit _createUserCubit() {
    return UserCubit(
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
    );
  }
}

class TinderScreen extends StatefulWidget {
  const TinderScreen({super.key});

  @override
  State<TinderScreen> createState() => _TinderScreenState();
}

class _TinderScreenState extends State<TinderScreen> {
  @override
  void initState() {
    super.initState();
    _initializeTinderData();
  }

  void _initializeTinderData() {
    final userCubit = context.read<UserCubit>();
    userCubit.giveMeTokenForTinder().then((_) {
      final tinderCubit = context.read<TinderViewCubit>();
      final token = userCubit.state.token?.accessToken ?? '';
      tinderCubit
        ..fetchUserData(accessToken: token, gender: 'female')
        ..fetchSubCategoryData(accessToken: token)
        ..fetchFavorites(token);
    });
  }

  @override
  Widget build(BuildContext context) {
    log('TinderScreen built');
    return SharedScaffold(
      body: AuthHelper().isLoggedIn()
          ? _buildLoggedInContent()
          : const Center(child: Text('No user yet')),
      mainCategoryId: 2,
    );
  }

  Widget _buildLoggedInContent() {
    final tinderCubit = context.watch<TinderViewCubit>();
    final userCubit = context.watch<UserCubit>();

    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            _buildHeader(),
            TinderCardStack(userCubit: userCubit),
            const Divider(color: Colors.grey, height: 1),
            _buildSubCategoryList(tinderCubit, userCubit),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: Align(
        alignment: Alignment.topLeft,
        child: Label(
          text: 'Find',
          style: Styles.headerText(fontSize: 18),
        ),
      ),
    );
  }

  Widget _buildSubCategoryList(TinderViewCubit tinderCubit, UserCubit userCubit) {
    return SizedBox(
      height: 200,
      child: ListView.separated(
        padding: EdgeInsets.zero,
        scrollDirection: Axis.horizontal,
        itemCount: tinderCubit.state.subCategoryData.length,
        separatorBuilder: (context, index) => const SizedBox(width: 0),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(2.0),
            child: TinderSubCategoryCard(
              subCategoryCardData: tinderCubit.state.subCategoryData[index],
              userCubit: userCubit,
              index: index,
            ),
          );
        },
      ),
    );
  }
}

class PersonInfoWidget extends StatefulWidget {
  final UserData cardUser;
  final UserCubit userCubit;

  const PersonInfoWidget({
    super.key,
    required this.cardUser,
    required this.userCubit,
  });

  @override
  State<PersonInfoWidget> createState() => _PersonInfoWidgetState();
}

class _PersonInfoWidgetState extends State<PersonInfoWidget> {
  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  void _fetchUserData() {
    final tinderCubit = context.read<TinderViewCubit>();
    final token = widget.userCubit.state.token!.accessToken;
    tinderCubit
      ..fetchLastSeen(userId: widget.cardUser.id!, accessToken: token)
      ..checkUserNearby(cardUserId: widget.cardUser.id!, accessToken: token);
    log('Fetched user data in PersonInfoWidget');
  }

  @override
  Widget build(BuildContext context) {
    final tinderCubit = context.watch<TinderViewCubit>();

    return _buildPersonInfo(
      context,
      widget.cardUser,
      tinderCubit: tinderCubit,
      userCubit: widget.userCubit,
    );
  }

  Widget _buildPersonInfo(BuildContext context, UserData cardUser,
      {required TinderViewCubit tinderCubit, required UserCubit userCubit}) {
    return Positioned(
      bottom: kToolbarHeight,
      left: kDefaultPadding,
      right: kDefaultPadding,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildStatusBadge(tinderCubit.state.lastSeenModel?.data?.status),
                const SizedBox(width: 10),
                _buildNearbyBadge(tinderCubit.state.isUserNearby?.data?.isNearBy),
              ],
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                capitalizeAndSplit('${cardUser.firstName} ${cardUser.lastName}'),
                style: Styles.headerText(
                    color: AppColors.PRIMARY_COLOR, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                _getLastSeenText(tinderCubit.state.lastSeenModel?.data?.lastSeen),
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
  }

  Widget _buildStatusBadge(String? status) {
    return BadgedLabel(
      color: AppColors.WHATS_APP_COLOR,
      label: status ?? 'N/A',
    );
  }

  Widget _buildNearbyBadge(bool? isNearby) {
    return BadgedLabel(
      color: AppColors.SECONDARY_COLOR,
      label: isNearby == true ? 'Nearby' : 'Not Nearby',
    );
  }

  String _getLastSeenText(String? lastSeen) {
    return lastSeen != null ? "Last seen ${getTimeAgo(lastSeen)}" : "Last seen N/A";
  }
}

class CardStackWidget extends StatefulWidget {
  final TinderViewCubit tinderCubit;
  final UserCubit userCubit;

  const CardStackWidget({
    super.key,
    required this.tinderCubit,
    required this.userCubit,
  });

  @override
  CardStackWidgetState createState() => CardStackWidgetState();
}

class CardStackWidgetState extends State<CardStackWidget> {
  late ScrollController _scrollController;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent &&
        !_isLoadingMore) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    setState(() {
      _isLoadingMore = true;
    });

    await widget.tinderCubit.fetchUserData2(
      gender: 'female',
      accessToken: widget.userCubit.state.token!.accessToken,
      page: widget.tinderCubit.state.currentPage! + 1,
    );

    setState(() {
      _isLoadingMore = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final tinderCubit = widget.tinderCubit;

    return SizedBox(
      height: MediaQuery.of(context).size.height * 2.5 / 4,
      child: Stack(
        children: [
          ListView.builder(
            controller: _scrollController,
            itemCount: tinderCubit.state.userData.length,
            itemBuilder: (context, index) {
              final cardUser = tinderCubit.state.userData[index];
              return _buildCard(
                context: context,
                cardUser: cardUser,
                index: index,
                tinderCubit: tinderCubit,
                userCubit: widget.userCubit,
              );
            },
          ),
          if (_isLoadingMore)
            const Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  Widget _buildCard({
    required BuildContext context,
    required int index,
    required UserData cardUser,
    required TinderViewCubit tinderCubit,
    required UserCubit userCubit,
  }) {
    final isFrontCard = index == tinderCubit.state.currentIndex;

    if (!isFrontCard) return const Offstage();

    return GestureDetector(
      onPanStart: (details) => tinderCubit.updatePanStart(details.globalPosition),
      onPanUpdate: (details) {
        final position = details.globalPosition - tinderCubit.state.startDragOffset;
        final rotation = position.dx /
            (position.dy > tinderCubit.state.startDragOffset.dy - 180 ? 500 : -500);
        tinderCubit.updatePanUpdate(position, rotation);
      },
      onPanEnd: (details) {
        tinderCubit.swipeAway();
      },
      onTapUp: (details) {
        final tapPosition = details.localPosition.dx;
        final screenWidth = MediaQuery.of(context).size.width;
        tapPosition < screenWidth / 2
            ? tinderCubit.previousStory()
            : tinderCubit.nextStory();
      },
      child: Transform.translate(
        offset: tinderCubit.state.position,
        child: Transform.rotate(
          angle: tinderCubit.state.rotation,
          child: _cardWidget(context, cardUser,
              tinderCubit: tinderCubit, userCubit: userCubit),
        ),
      ),
    );
  }

  Widget _cardWidget(BuildContext context, UserData cardUser,
      {required TinderViewCubit tinderCubit, required UserCubit userCubit}) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Card(
        clipBehavior: Clip.hardEdge,
        elevation: 2,
        child: Stack(
          children: [
            _buildImage(cardUser, tinderCubit: tinderCubit),
            _buildGenderSwitch(
                context: context,
                user: cardUser,
                tinderCubit: tinderCubit,
                userCubit: userCubit),
            _buildStoryBar(cardUser, tinderCubit: tinderCubit),
            PersonInfoWidget(
              cardUser: cardUser,
              userCubit: userCubit,
            ),
            _buildActions(context, cardUser,
                tinderCubit: tinderCubit, userCubit: userCubit),
          ],
        ),
      ),
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
        errorBuilder: (context, error, stackTrace) => Image.network(
            UIConst.profilePlaceHolder,
            fit: BoxFit.fitHeight,
            height: double.infinity),
        fit: BoxFit.fitHeight,
        height: double.infinity,
      ),
    );
  }

  Widget _buildGenderSwitch(
      {required BuildContext context,
        required UserData user,
        required TinderViewCubit tinderCubit,
        required UserCubit userCubit}) {
    return Padding(
      padding: const EdgeInsets.only(right: 8, top: 25),
      child: Align(
        alignment: Alignment.topRight,
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
              onPressed: () => _switchDisplayGender(user, context,
                  tinderCubit: tinderCubit, userCubit: userCubit),
              iconSize: 50,
              icon: Icon(user.gender == 'male' ? Icons.female : Icons.male,
                  color: Colors.black),
            ),
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
      {required TinderViewCubit tinderCubit, required UserCubit userCubit}) {
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
                  () => _navigateToUserProfile(context, user,
                  tinderCubit: tinderCubit, userCubit: userCubit),
              color: Colors.red,
              heroTag: 'photoButton',
            ),
            _buildFloatingActionButton(
              context,
              Icons.card_giftcard,
                  () {
                _showGiftBottomSheet22(context,
                    tinderCubit: tinderCubit,
                    userCubit: userCubit);
              },
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

  Widget _buildFloatingActionButton(
      BuildContext context, IconData icon, VoidCallback? onPressed,
      {Color? color, required String heroTag}) {
    return FloatingActionButton.small(
      heroTag: heroTag,
      onPressed: onPressed,
      backgroundColor: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      child: Icon(icon, color: color != null ? Colors.white : null),
    );
  }

  void _switchDisplayGender(
      UserData user,
      BuildContext context, {
        required TinderViewCubit tinderCubit,
        required UserCubit userCubit,
      }) {
    tinderCubit.fetchUserData(
        gender: user.gender == 'female' ? 'female' : 'male',
        accessToken: userCubit.state.token!.accessToken);
  }

  void _navigateToUserProfile(BuildContext context, UserData cardUser,
      {required TinderViewCubit tinderCubit, required UserCubit userCubit}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserProfilePage(
          userCubit: userCubit,
        ),
      ),
    );
  }
}

void _showGiftBottomSheet22(BuildContext context,
    {required TinderViewCubit tinderCubit,
      required UserCubit userCubit}) {
  closeAllBottomSheets(context);

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.black.withOpacity(0.8),
    builder: (context) => MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => GiftsCubit()),
        BlocProvider(create: (context) => TinderViewCubit()),
        BlocProvider(create: (context) => UserCubit(serviceLocator(), serviceLocator(),
            serviceLocator(), serviceLocator(), serviceLocator())),
      ],
      child: SizedBox(
        height: MediaQuery.of(context).size.height / 2,
        child: Column(
          children: [
            _buildGiftSheetHeader(),
            Expanded(
              child: Stack(
                children: [
                  BottomSheetContent(
                    userCubit: userCubit,
                    accessToken: userCubit.state.token!.accessToken,
                  ),
                  _buildRechargeButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildGiftSheetHeader() {
  return Container(
    width: double.infinity,
    height: kToolbarHeight * kToolbarHeightFactor,
    decoration: BoxDecoration(
      color: Colors.black.withOpacity(0.4),
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
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
  );
}

Widget _buildRechargeButton() {
  return Positioned(
    bottom: 5,
    right: 5,
    child: Padding(
      padding: const EdgeInsets.all(4.0),
      child: OutlinedButton(
        style: ButtonStyle(
          side: const MaterialStatePropertyAll(BorderSide(width: 0)),
          iconColor: const MaterialStatePropertyAll(Colors.white),
          backgroundColor:
          MaterialStatePropertyAll(Colors.black.withOpacity(0.8)),
        ),
        onPressed: () {
          serviceLocator<SubscriptionController>()
              .showActiveSubscriptionAmounts(walletType: WalletTypes.balance);
        },
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '💳 Recharge',
              style: TextStyle(
                fontWeight: FontWeight.normal,
                color: Colors.white,
              ),
              textScaler: TextScaler.linear(1.2),
            ),
            Icon(Icons.arrow_right),
          ],
        ),
      ),
    ),
  );
}

void _showReportBottomSheet(BuildContext context, UserData user) {
  final userState = context.read<UserCubit>().state.data;
  if (userState != null) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height / 1.5,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ReportView(
              id: userState.id, categoryId: '66af974f8bf69f9469944746'),
        ),
      ),
    );
  }
}

void _showChatTypeAdvancedDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          "Pick a Chat Type:   \u{1F4AC}",
          style: Styles.headerText(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.75,
          height: MediaQuery.of(context).size.width * 0.5,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                flex: 3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                      child: _buildChatOptionCard(context,
                          icon: Icons.visibility_off,
                          label: "Incognito Chat",
                          route: Routes.CHATROOM,
                          description: "Hidden Identity Chat"),
                    ),
                    Flexible(
                      child: _buildChatOptionCard(context,
                          icon: Icons.visibility,
                          label: "Regular Chat",
                          route: Routes.CHAT,
                          description: "Identified Chat"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Widget _buildChatOptionCard(BuildContext context,
    {required IconData icon,
      required String label,
      required String route,
      required String description}) {
  return InkWell(
    onTap: () {
      Navigator.pop(context);
      label == "Incognito Chat"
          ? Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ChatView(initialTabIndex: 6),
        ),
      )
          : Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ChatView(initialTabIndex: 0),
        ),
      );
    },
    child: Column(
      children: [
        Expanded(
          child: Icon(
            icon,
            size: 40,
            color: label == "Incognito Chat"
                ? AppColors.SECONDARY_COLOR
                : AppColors.PRIMARY_COLOR,
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: Text(
            label,
            style: Styles.headerText(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Expanded(
          child: Text(
            description,
            style: Styles.mediumText(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    ),
  );
}

String getTimeAgo(String lastSeen) {
  DateTime lastSeenTime = DateTime.parse(lastSeen);
  DateTime now = DateTime.now().toUtc();

  Duration difference = now.difference(lastSeenTime);

  if (difference.inDays > 7) {
    DateFormat dateFormat = DateFormat('EEEE, MMMM d, yyyy');
    DateFormat timeFormat = DateFormat('h:mm a');
    String formattedDate = dateFormat.format(lastSeenTime);
    String formattedTime = timeFormat.format(lastSeenTime);
    return 'Date: $formattedDate\nTime: $formattedTime';
  } else if (difference.inMinutes < 1) {
    return "Just now";
  } else if (difference.inMinutes == 1) {
    return "1 minute ago";
  } else if (difference.inMinutes < 60) {
    return "${difference.inMinutes} minutes ago";
  } else if (difference.inHours == 1) {
    return "1 hour ago";
  } else {
    return "${difference.inHours} hours ago";
  }
}

String capitalizeAndSplit(String text) {
  return text.split(' ').map((word) => word.capitalize()).join(' ');
}

void closeAllBottomSheets(BuildContext context) {
  Navigator.of(context).popUntil((route) {
    return route is! ModalBottomSheetRoute;
  });
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
