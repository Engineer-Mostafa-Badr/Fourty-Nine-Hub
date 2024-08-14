import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/functions/helper/auth_helper.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/core/enums/wallet_types_enums.dart';
import 'package:fourtyninehub/features/authentication/domain/entities/user_entity.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/presentation/pages/Chat_view.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/models/get_fav_sub_category_model.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/models/gift_model.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/shared/shared.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/shared/tinder_shared_utils.dart';
import 'package:fourtyninehub/features/social_media/tinder/presentation/cubit/gift_cubit.dart';
import 'package:fourtyninehub/features/social_media/tinder/presentation/cubit/tinder_cubit.dart';
import 'package:fourtyninehub/features/social_media/tinder/presentation/widgets/tinder_card_stack.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/widgets/report_view.dart';
import 'package:fourtyninehub/features/subscripe/presentation/controllers/subscription_controller.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:intl/intl.dart';

// Imports and package declarations
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/badged_label.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/models/tinder_person_model.dart';
import 'package:fourtyninehub/features/social_media/tinder/presentation/pages/user_profile.dart';
import 'package:fourtyninehub/features/social_media/tinder/presentation/widgets/tinder_sub_category_card.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:go_router/go_router.dart';
import 'package:fourtyninehub/routes/routes.dart';

class TinderView extends StatelessWidget {
  const TinderView({super.key});

  @override
  Widget build(BuildContext context) {
    log('from TinderView class-------------------------------------------------------');
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TinderViewCubit(),
        ),
        BlocProvider(
          create: (context) => UserCubit(serviceLocator(), serviceLocator(),
              serviceLocator(), serviceLocator(), serviceLocator()),
        ),
        // BlocProvider(
        //   create: (context) => GiftsCubit(),
        // ),
      ],
      child: const TinderScreen(),
    );
  }
}

class TinderScreen extends StatefulWidget {
  const TinderScreen({super.key});

  @override
  State<TinderScreen> createState() => _TinderScreenState();
}

class _TinderScreenState extends State<TinderScreen> {
  // late TinderViewCubit _tinderViewCubit;
  // late String currentAccessToken;

  @override
  void initState() {
    // if (AuthHelper().isLoggedIn()) {
    //   context.read<UserCubit>().giveMeTokenForTinder;
    // } else {
    //   TinderSharedUtils.initializeToken('');

    final currentUserCubit = context.read<UserCubit>();
    currentUserCubit.giveMeTokenForTinder().then((_) {
      final tinderCubit = context.read<TinderViewCubit>();
      tinderCubit
        ..fetchUserData(
          accessToken: currentUserCubit.state.token?.accessToken ?? '',
          gender: 'female',
        )
        ..fetchSubCategoryData(
            accessToken: currentUserCubit.state.token?.accessToken ?? '')
        ..fetchFavorites(currentUserCubit.state.token?.accessToken ?? '');
    });
    // }
    super.initState();
    // _tinderViewCubit = context.read<TinderViewCubit>()..resetStoryIndex();
  }

  // Future<UserTokensEntity?> _loadAsyncData() async {
  //   return await context.read<UserCubit>().giveMeTokenForTinder();
  // }

  @override
  Widget build(BuildContext context) {
    final tinderCubit = context.watch<TinderViewCubit>();
    final currentUserCubit = context.watch<UserCubit>();
    // currentUserCubit.giveMeTokenForTinder();

    // tinderCubit.fetchUserData(
    //     accessToken: currentUserCubit.state.token?.accessToken ?? '',
    //     gender: 'female');
    // _loadAsyncData().then((value) {
    //   currentAccessToken = value!.accessToken;
    //   _tinderViewCubit
    //     ..fetchUserData(accessToken: currentAccessToken, gender: 'female')
    //     ..fetchSubCategoryData(accessToken: currentAccessToken)
    //     ..fetchFavorites(currentAccessToken)
    //     ..fetchGifts(accessToken: currentAccessToken);
    //   // ..fetchFavorites(TinderSharedUtils.token);
    // });
    // _loadAsyncData().then((value) {
    //   currentAccessToken = value!.accessToken;
    //   _tinderViewCubit
    //     ..fetchUserData(accessToken: currentAccessToken, gender: 'female')
    //     ..fetchSubCategoryData(accessToken: currentAccessToken)
    //     ..fetchFavorites(currentAccessToken)
    //     ..fetchGifts(accessToken: currentAccessToken);
    //   // ..fetchFavorites(TinderSharedUtils.token);
    // });

    // _tinderViewCubit
    //   ..fetchUserData(accessToken: currentAccessToken, gender: 'female')
    //   ..fetchSubCategoryData(accessToken: currentAccessToken)
    //   ..fetchFavorites(currentAccessToken)
    //   ..fetchGifts(accessToken: currentAccessToken);
    // ..fetchFavorites(TinderSharedUtils.token);

    log('from _TinderScreenState class-------------------------------------------------------');
    // TinderSharedUtils.initializeToken(currentAccessToken);

    // _fetchData();

    return SharedScaffold(
      body:
          // Container(
          //   child: Center(
          //     child: Text(currentUserCubit.state.token?.accessToken ?? ''),
          //   ),
          // ),
          AuthHelper().isLoggedIn()
              ? Container(
                  color: Colors.white,
                  child: _buildContent(context, tinderCubit, currentUserCubit),
                )
              : const Center(
                  child: Text('no user yet '),
                ),
      mainCategoryId: 2,
    );
  }

  // void _fetchData() {
  //   _tinderViewCubit
  //     ..fetchUserData(accessToken: currentAccessToken, gender: 'female')
  //     ..fetchSubCategoryData(accessToken: currentAccessToken)
  //     ..fetchFavorites(currentAccessToken)
  //     ..fetchGifts(accessToken: currentAccessToken);
  //   // ..fetchFavorites(TinderSharedUtils.token);
  // }

  Widget _buildContent(BuildContext context, TinderViewCubit tinderCubit,
      UserCubit currentUserCubit) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          _buildHeader(),
          TinderCardStack(
            // tinderCubit: tinderCubit,
            userCubit: currentUserCubit,
          ),
          // _buildCardStack(context,
          //     tinderCubit: tinderCubit, userCubit: currentUserCubit),
          // CardStackWidget(tinderCubit: tinderCubit, userCubit: currentUserCubit),
          _buildSeparator(),
          _buildSubCategoryList(context,
              tinderCubit: tinderCubit, userCubit: currentUserCubit),
          const SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Align(
        alignment: Alignment.topLeft,
        child: Label(
          text: 'Find',
          style: Styles.headerText(fontSize: 18),
        ),
      ),
    );
  }

  Widget _buildCardStack(BuildContext context,
      {required TinderViewCubit tinderCubit, required UserCubit userCubit}) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 2.5 / 4,
      child: Stack(
        children: List.generate(
          tinderCubit.state.userData.length,
          (index) {
            final cardUser = tinderCubit.state.userData[index];
            return _buildCard(
                context: context,
                cardUser: cardUser,
                index: index,
                tinderCubit: tinderCubit,
                userCubit: userCubit);
          },
        ),
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
      onPanStart: (details) => context
          .read<TinderViewCubit>()
          .updatePanStart(details.globalPosition),
      onPanUpdate: (details) {
        final position =
            details.globalPosition - tinderCubit.state.startDragOffset;
        final rotation = position.dx /
            (position.dy > tinderCubit.state.startDragOffset.dy - 180
                ? 500
                : -500);
        context.read<TinderViewCubit>().updatePanUpdate(position, rotation);
      },
      onPanEnd: (details) {
        final shouldSwipeAway = tinderCubit.state.position.dx > 250 ||
            tinderCubit.state.position.dx < -250 ||
            tinderCubit.state.position.dy > 250 ||
            tinderCubit.state.position.dy < -250;
        if (shouldSwipeAway) {
          // context.read<TinderViewCubit>().swipeAway();
          tinderCubit.swipeAway();
        } else {
          // context.read<TinderViewCubit>().resetPan();
          tinderCubit.resetPan();
        }
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
            // _buildPersonInfo(context, cardUser,
            //     tinderCubit: tinderCubit, userCubit: userCubit),
            PersonInfoWidget(
              cardUser: cardUser,
              // tinderCubit: tinderCubit,
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
              // onPressed: () {
              //   final gender = state.userData.first.user!.gender.toString();
              //   context.read<TinderViewCubit>().fetchUserData(
              //       gender: gender == 'female' ? 'female' : 'male',
              //       accessToken: currentAccessToken);
              //   // setState(() {
              //   //
              //   // });
              // },
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
    // List<Pictures>? reversedImages = user.pictures!.reversed.toList();
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

  // Widget _buildPersonInfo(BuildContext context, UserData cardUser,
  //     {required TinderViewCubit tinderCubit, required UserCubit userCubit}) {
  //   // final state = context.read<TinderViewCubit>().state;
  //
  //   // log("${user.id!}from _buildPersonInfo checkUserNearby=========");
  //
  //   // context.read<TinderViewCubit>()
  //   //   ..fetchLastSeen(userId: user.id!, accessToken: currentAccessToken)
  //   //   ..checkUserNearby(cardUserId: user.id!, accessToken: currentAccessToken);
  //
  //   tinderCubit
  //     .fetchLastSeen(
  //         userId: cardUser.id!, accessToken: userCubit.state.token!.accessToken);
  //     // ..checkUserNearby(
  //     //     cardUserId: cardUser.id!,
  //     //     accessToken: userCubit.state.token!.accessToken);
  //
  //   return Positioned(
  //     bottom: kToolbarHeight,
  //     right: 8,
  //     left: 8,
  //     child: Padding(
  //       padding: const EdgeInsets.all(4.0),
  //       child: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Row(
  //             children: [
  //               BadgedLabel(
  //                 color: AppColors.WHATS_APP_COLOR,
  //                 label: tinderCubit.state.lastSeenModel != null &&
  //                         tinderCubit.state.lastSeenModel!.data != null
  //                     ? tinderCubit.state.lastSeenModel!.data!.status ?? 'N/A'
  //                     : 'N/A',
  //               ),
  //               const SizedBox(width: 10),
  //               BadgedLabel(
  //                 color: AppColors.SECONDARY_COLOR,
  //                 label: tinderCubit.state.isUserNearbyState ==
  //                         DataState.failure
  //                     ? 'N/A'
  //                     : tinderCubit.state.isUserNearbyState == DataState.failure
  //                         ? 'Nearby'
  //                         : 'is not Nearby',
  //               ),
  //             ],
  //           ),
  //           ListTile(
  //             contentPadding: EdgeInsets.zero,
  //             title: OutlineText(
  //               text: capitalizeAndSplit("${cardUser.firstName} ${cardUser.lastName}"),
  //               textStyle: Styles.headerText(
  //                   color: Colors.white,
  //                   fontSize: 38,
  //                   fontWeight: FontWeight.bold),
  //             ),
  //             subtitle: OutlineText(
  //               text: tinderCubit.state.lastSeenModel != null &&
  //                       tinderCubit.state.lastSeenModel!.data != null
  //                   // ? "Last seen ${state.lastSeenModel!.data!.lastSeen}"
  //                   ? "Last seen ${getTimeAgo(tinderCubit.state.lastSeenModel!.data!.lastSeen ?? '')}"
  //                   : "Last seen ",
  //               textStyle: Styles.mediumText(
  //                   color: Colors.white,
  //                   fontWeight: FontWeight.bold,
  //                   fontSize: 16),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

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
                    // cardUser: user,
                    tinderCubit: tinderCubit,
                    userCubit: userCubit);

                // tinderCubit
                //     .fetchGifts(accessToken: userCubit.state.token!.accessToken)
                //     .then((value) => _showGiftBottomSheet22(context,
                //         cardUser: user,
                //         tinderCubit: tinderCubit,
                //         userCubit: userCubit));
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

//------------------------------------------
  bool containsSpecificId(List<FavoriteItem> favorites, String specificId) {
    return favorites.any((favorite) => favorite.id == specificId);
    // .any((favorite) => favorite.id == '66b83154240d94d7787125c3');
    // for (var element in favorites) {
    //   return element.category!.id == specificId;
    // }
    // return null;
  }

  Widget _buildSubCategoryList(context,
      {required TinderViewCubit tinderCubit, required UserCubit userCubit}) {
    // tinderCubit.fetchFavorites(TinderSharedUtils.token);
    // if (tinderCubit.state.subCategoryData.isEmpty) {
    //   return const SizedBox.shrink();
    // }
    // if (tinderCubit.state.)
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 0.0),
      child: SizedBox(
        height: 200,
        child: ListView.separated(
          separatorBuilder: (context, index) => const Sizer(width: 0),
          padding: EdgeInsets.zero,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.all(2.0),
            child: TinderSubCategoryCard(
              // containsSpecificId(
              //     state.getFavCategoryModel!.data!.favorites!,
              //     state.subCategoryData[index].sId.toString()),
              subCategoryCardData: tinderCubit.state.subCategoryData[index],
              // tinderCubit: tinderCubit,
              userCubit: userCubit,
              // activeFav: true,
              index: index,
              // tinderCubit: tinderCubit,
              // isFavCard: false,
            ),
          ),
          itemCount: tinderCubit.state.subCategoryData.length,
        ),
      ),
    );
  }

  Widget _buildSeparator() {
    return Container(
      color: Colors.grey.shade500,
      height: 1,
      width: double.infinity,
    );
  }

  void _switchDisplayGender(
    UserData user,
    BuildContext context, {
    required TinderViewCubit tinderCubit,
    required UserCubit userCubit,
  }) {
    // final gender = state.userData.first.gender.toString();
    // context.read<TinderViewCubit>().fetchUserData(
    //     gender: user.gender == 'female' ? 'female' : 'male',
    //     accessToken: currentAccessToken);

    tinderCubit.fetchUserData(
        gender: user.gender == 'female' ? 'female' : 'male',
        accessToken: userCubit.state.token!.accessToken);

    // setState(() {});
  }

  void _navigateToUserProfile(BuildContext context, UserData cardUser,
      {required TinderViewCubit tinderCubit, required UserCubit userCubit}) {
    // final currentUserState = context.read<UserCubit>().state.data;
    // log(currentUserState!.id + '000000000000000000000000000');
    // BlocListener<UserCubit, BasicState<UserEntity>>(
    //   listener: (BuildContext context, BasicState<UserEntity> state) {
    //     log(state.data!.id + '000000000000000000000000000');
    //
    //   },
    // );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserProfilePage(
          // tinderCubit: tinderCubit,
          userCubit: userCubit,
        ),
      ),
    );
    // context
    //     .read<TinderViewCubit>()
    //     .fetchUserProfile(
    //     userId: state.data!.id, token: TinderSharedUtils.token)
    // // '66af974f8bf69f9469944746')
    //     .then((value) {
    //   log("${value!.data.userId.email}pppppppppppppppppppppppppppppppp");
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //         builder: (context) => UserProfilePage(
    //           userId: state.data!.id,
    //         )),
    //   );
    // });
  }
}

class PersonInfoWidget extends StatefulWidget {
  final UserData cardUser;

  // final TinderViewCubit tinderCubit;
  final UserCubit userCubit;

  const PersonInfoWidget({
    super.key,
    required this.cardUser,
    // required this.tinderCubit,
    required this.userCubit,
  });

  @override
  State<PersonInfoWidget> createState() => _PersonInfoWidgetState();
}

class _PersonInfoWidgetState extends State<PersonInfoWidget> {
  @override
  void initState() {
    final tinderCubit = context.read<TinderViewCubit>();

    tinderCubit
      ..fetchLastSeen(
        userId: widget.cardUser.id!,
        accessToken: widget.userCubit.state.token!.accessToken,
      )
      ..checkUserNearby(
        cardUserId: widget.cardUser.id!,
        accessToken: widget.userCubit.state.token!.accessToken,
      );
    log('fetchLastSeen from init ');
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final innerTinderCubit = context.watch<TinderViewCubit>();
    // if (innerTinderCubit.state.lastSeenModel == null ||
    //     innerTinderCubit.state.lastSeenModel!.status == false) {
    //   innerTinderCubit.fetchLastSeen(
    //     userId: widget.cardUser.id!,
    //     accessToken: widget.userCubit.state.token!.accessToken,
    //   );
    // }
    // if (innerTinderCubit.state.isUserNearby == null ||
    //     innerTinderCubit.state.isUserNearby!.status == false) {
    //   innerTinderCubit.checkUserNearby(
    //     cardUserId: widget.cardUser.id!,
    //     accessToken: widget.userCubit.state.token!.accessToken,
    //   );
    // }

    return _buildPersonInfo(context, widget.cardUser,
        // tinderCubit: widget.tinderCubit,
        tinderCubit: innerTinderCubit,
        userCubit: widget.userCubit);
  }

  Widget _buildPersonInfo(BuildContext context, UserData cardUser,
      {required TinderViewCubit tinderCubit, required UserCubit userCubit}) {
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
                  label: tinderCubit.state.lastSeenModel?.data?.status ?? 'N/A',
                ),
                const SizedBox(width: 10),
                BadgedLabel(
                  color: AppColors.SECONDARY_COLOR,
                  label: (tinderCubit.state.isUserNearby != null &&
                          tinderCubit.state.isUserNearby!.data != null)
                      ? ((tinderCubit.state.isUserNearby!.data!.isNearBy ==
                              true)
                          ? 'Nearby'
                          : 'is not Nearby')
                      : "N/A",
                ),
              ],
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                capitalizeAndSplit(
                    "${cardUser.firstName} ${cardUser.lastName}"),
                textScaler: const TextScaler.linear(2),
                style: Styles.headerText(
                    color: AppColors.PRIMARY_COLOR,
                    // fontSize: 38,
                    fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                tinderCubit.state.lastSeenModel?.data?.lastSeen != null
                    ? "Last seen ${getTimeAgo(tinderCubit.state.lastSeenModel!.data!.lastSeen ?? '')}"
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
  }
}

void _showGiftBottomSheet22(BuildContext context,
    {required TinderViewCubit tinderCubit,
    required UserCubit userCubit}) async {
  closeAllBottomSheets(context);

  // final currentLoggedUser = context.read<UserCubit>().state.data;
  // final giftData = await context
  //     .read<TinderViewCubit>()
  //     .fetchGifts(accessToken: currentAccessToken);
  // log(giftData.toString() + 'gift data ===========================');

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.black.withOpacity(0.8),
    builder: (context) => MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GiftsCubit(),
        ),
        BlocProvider(
          create: (context) => TinderViewCubit(),
        ),
        BlocProvider(
          create: (context) => UserCubit(
            serviceLocator(),
            serviceLocator(),
            serviceLocator(),
            serviceLocator(),
            serviceLocator(),
          ),
        ),
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
                    // accessToken: userCubit.state.token!.accessToken,
                    // cardUser: cardUser,
                    // tinderCubit: tinderCubit,
                    userCubit: userCubit,
                    accessToken: userCubit.state.token!.accessToken,

                    // currentLoggedUser: currentLoggedUser,
                    // subCategoryId: null,
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
      onPanStart: (details) => context
          .read<TinderViewCubit>()
          .updatePanStart(details.globalPosition),
      onPanUpdate: (details) {
        final position =
            details.globalPosition - tinderCubit.state.startDragOffset;
        final rotation = position.dx /
            (position.dy > tinderCubit.state.startDragOffset.dy - 180
                ? 500
                : -500);
        context.read<TinderViewCubit>().updatePanUpdate(position, rotation);
      },
      onPanEnd: (details) {
        final shouldSwipeAway = tinderCubit.state.position.dx > 250 ||
            tinderCubit.state.position.dx < -250 ||
            tinderCubit.state.position.dy > 250 ||
            tinderCubit.state.position.dy < -250;
        if (shouldSwipeAway) {
          // context.read<TinderViewCubit>().swipeAway();
          tinderCubit.swipeAway();
        } else {
          // context.read<TinderViewCubit>().resetPan();
          tinderCubit.resetPan();
        }
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
            // _buildPersonInfo(context, cardUser,
            //     tinderCubit: tinderCubit, userCubit: userCubit),
            PersonInfoWidget(
              cardUser: cardUser,
              // tinderCubit: tinderCubit,
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
              // onPressed: () {
              //   final gender = state.userData.first.user!.gender.toString();
              //   context.read<TinderViewCubit>().fetchUserData(
              //       gender: gender == 'female' ? 'female' : 'male',
              //       accessToken: currentAccessToken);
              //   // setState(() {
              //   //
              //   // });
              // },
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
    // List<Pictures>? reversedImages = user.pictures!.reversed.toList();
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
                    // cardUser: user,
                    tinderCubit: tinderCubit,
                    userCubit: userCubit);

                // tinderCubit
                //     .fetchGifts(accessToken: userCubit.state.token!.accessToken)
                //     .then((value) => _showGiftBottomSheet22(context,
                //         cardUser: user,
                //         tinderCubit: tinderCubit,
                //         userCubit: userCubit));
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
    // final gender = state.userData.first.gender.toString();
    // context.read<TinderViewCubit>().fetchUserData(
    //     gender: user.gender == 'female' ? 'female' : 'male',
    //     accessToken: currentAccessToken);

    tinderCubit.fetchUserData(
        gender: user.gender == 'female' ? 'female' : 'male',
        accessToken: userCubit.state.token!.accessToken);

    // setState(() {});
  }

  void _navigateToUserProfile(BuildContext context, UserData cardUser,
      {required TinderViewCubit tinderCubit, required UserCubit userCubit}) {
    // final currentUserState = context.read<UserCubit>().state.data;
    // log(currentUserState!.id + '000000000000000000000000000');
    // BlocListener<UserCubit, BasicState<UserEntity>>(
    //   listener: (BuildContext context, BasicState<UserEntity> state) {
    //     log(state.data!.id + '000000000000000000000000000');
    //
    //   },
    // );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserProfilePage(
          // tinderCubit: tinderCubit,
          userCubit: userCubit,
        ),
      ),
    );
    // context
    //     .read<TinderViewCubit>()
    //     .fetchUserProfile(
    //     userId: state.data!.id, token: TinderSharedUtils.token)
    // // '66af974f8bf69f9469944746')
    //     .then((value) {
    //   log("${value!.data.userId.email}pppppppppppppppppppppppppppppppp");
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //         builder: (context) => UserProfilePage(
    //           userId: state.data!.id,
    //         )),
    //   );
    // });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
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

// void _showCatTypeAdvancedDialog(BuildContext context) {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: const Text("Select Chat Type"),
//         content: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             _buildChatOptionCard(context,
//                 icon: Icons.person_outline,
//                 label: "Anonymous Chat",
//                 route: Routes.CHATROOM),
//             _buildChatOptionCard(context,
//                 icon: Icons.person, label: "Normal Chat", route: Routes.CHAT),
//           ],
//         ),
//       );
//     },
//   );
// }
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
              // const Expanded(
              //   flex: 1,
              //   child: Text("Pick a Chat Type:",
              //       style: TextStyle(fontSize: 16)),
              // ),
              // const SizedBox(height: 10),
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
      // Navigator.of(context).pushNamed(route);
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
      // context.push(Routes.CHAT);
    },
    child: Column(
      children: [
        Expanded(
            child: Icon(icon,
                size: 40,
                color: label == "Incognito Chat"
                    ? AppColors.SECONDARY_COLOR
                    : AppColors.PRIMARY_COLOR)),
        const SizedBox(height: 8),
        Expanded(
          child: Text(label,
              style:
                  Styles.headerText(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 4),
        Expanded(
          child: Text(description,
              style: Styles.mediumText(fontSize: 16),
              textAlign: TextAlign.center),
        ),
      ],
    ),
  );
}

// Widget _buildChatOptionCard(BuildContext context,
//     {required IconData icon, required String label, required String route}) {
//   return Expanded(
//     child: Card(
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             IconButton(
//               icon: Icon(icon, size: 30),
//               onPressed: () {
//                 Navigator.pop(context);
//                 context.push(route);
//               },
//             ),
//             Text(label),
//           ],
//         ),
//       ),
//     ),
//   );
// }

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

//-----------------------------------------------the upper code enhanced
// class GiftBottomSheet extends StatelessWidget {
//   final List<GiftData>? gifts;
//
//   final UserData cardUser;
//
//   final UserEntity? currentLoggedUser;
//
//   const GiftBottomSheet({
//     super.key,
//     required this.gifts,
//     required this.cardUser,
//     required this.currentLoggedUser,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       // child: Column(
//       //   mainAxisSize: MainAxisSize.min,
//       //   children: [
//       //     const Padding(
//       //       padding: EdgeInsets.all(16.0),
//       //       child: Text(
//       //         'الهدايا',
//       //         style: TextStyle(
//       //             fontSize: 28, fontWeight: FontWeight.bold, color: Colors.red),
//       //       ),
//       //     ),
//       //     _buildGiftItem(
//       //       context,
//       //       'assets/images/lion.png',
//       //       'اسد',
//       //       '500 جنيه مصري',
//       //     ),
//       //     _buildGiftItem(
//       //       context,
//       //       'assets/images/salary.png',
//       //       'اموال',
//       //       '400 جنيه مصري',
//       //     ),
//       //     _buildGiftItem(
//       //       context,
//       //       'assets/images/gift-box.png',
//       //       'صندوق هدايا',
//       //       '300 جنيه مصري',
//       //     ),
//       //     _buildGiftItem(
//       //       context,
//       //       'assets/images/rose.png',
//       //       'باقة ورود',
//       //       '200 جنيه مصري',
//       //     ),
//       //     _buildGiftItem(
//       //       context,
//       //       'assets/images/butterfly.png',
//       //       'فراشة',
//       //       '100 جنيه مصري',
//       //     ),
//       //     _buildGiftItem(
//       //       context,
//       //       'assets/images/star.png',
//       //       'نجمة',
//       //       '50 جنيه مصري',
//       //       iconColor: Colors.yellow,
//       //     ),
//       //   ],
//       // ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Padding(
//             padding: EdgeInsets.all(16.0),
//             child: Text(
//               'Send a gift',
//               style: TextStyle(
//                   fontSize: 28, fontWeight: FontWeight.bold, color: Colors.red),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(4.0),
//             child: ListView.builder(
//               shrinkWrap: true,
//               padding: const EdgeInsets.all(2),
//               itemCount: gifts!.length,
//               physics: const BouncingScrollPhysics(),
//               itemBuilder: (context, index) {
//                 final gift = gifts![index];
//                 // return ListTile(
//                 //   title: Text(gift.nameEn ?? 'No Name'),
//                 //   subtitle: Text('Value: ${gift.value ?? 'N/A'}'),
//                 //   leading: gift.picture != null
//                 //       ? Image.network(
//                 //           'https://49dev.com/${gift.picture!.mediaKey}',
//                 //           width: 50,
//                 //           height: 50,
//                 //           fit: BoxFit.cover,
//                 //         )
//                 //       : const Icon(Icons.card_giftcard),
//                 // );
//                 log('${gift.picture} ==================');
//                 return _buildGiftItem(
//                   currentLoggedUser: currentLoggedUser!,
//                   giftId: gift.sId,
//                   subCategoryId: '66af974f8bf69f9469944746',
//                   receiverId: cardUser.user!.sId,
//                   gift: gift,
//                   context: context,
//                 );
//               },
//             ),
//           ),
//           const SizedBox(
//             height: 10,
//           )
//         ],
//       ),
//     );
//   }
// }
// Widget _buildGiftItem({
//   required BuildContext context,
//   required GiftData gift,
//   required receiverId,
//   required giftId,
//   required subCategoryId,
//   required UserEntity currentLoggedUser,
// }) {
//   return BlocProvider(
//     create: (context) => TinderViewCubit()..fetchGifts(accessToken: ''),
//     child: BlocBuilder<TinderViewCubit, TinderViewState>(
//       builder: (context, state) {
//         return InkWell(
//           // onTap: () {
//           //   // Assuming this is where you get the snapshot data
//           //   log("Snapshot data: ${snapshot.data.toString()} /***************");
//           //
//           //   // Check if snapshot.data is not null or empty
//           //   if (snapshot.data == null || snapshot.data!.isEmpty) {
//           //     log("Error: No data received");
//           //     showInsufficientFundsPopup(context, "No data received.");
//           //     return;
//           //   }
//           //
//           //   // Attempt to decode the JSON data
//           //   // try {
//           //   // Map<String, dynamic> successData =
//           //   //     json.decode(snapshot.data ?? '');
//           //   //
//           //   // // log("${successData['success']}**********************");
//           //   // log("${successData}--------------------------------------");
//           //   //
//           //   // if (successData['success'] == false) {
//           //   //   showInsufficientFundsPopup(
//           //   //       context, state.sendGiftErrorData!.message);
//           //   // } else {
//           //   //   showGiftSentPopup(context, '10');
//           //   // }
//           //   // } catch (e) {
//           //   // Handle JSON decoding errors
//           //   // log("Error decoding JSON: ");
//           //   // showInsufficientFundsPopup(context, "Invalid response format.");
//           //   // }
//           // },
//           onTap: () async {
//             final data = await context.read<TinderViewCubit>().sendGift(
//               receiverId: receiverId,
//               giftId: giftId,
//               subCategoryId: subCategoryId,
//               currentUserToken: 'currentUserToken',
//               accessToken: '',
//             );
//             // handleResponse(snapshot.data ?? '', context);
//             // Use switch case to handle different response types
//             log("${data}oppppppppppppppppppppppppp");
//             switch (data) {
//               case """{"success":false,"error":{"name":"Bad Request","httpCode":400,"message":"You does not have enough money in the wallet","data":{},"isOperational":true,"stack":"","domain":"49dev.com"}}""":
//                 showInsufficientFundsPopup(
//                     context, 'You do not have enough money in your wallet.');
//
//                 break;
//
//               case """{"status":true,"message":"sent Gift Successfully"}""":
//                 showGiftSentPopup(context, '10');
//                 break;
//
//               default:
//                 showInsufficientFundsPopup(
//                     context, 'Unexpected response format.');
//                 break;
//             }
//           },
//           // onTap: () {
//           //   // context.read<TinderViewCubit>().sendGift(
//           //   //       currentUserToken: currentLoggedUser.id,
//           //   //       receiverId: receiverId,
//           //   //       giftId: giftId,
//           //   //       subCategoryId: subCategoryId,
//           //   //     );
//           //   // if (state.sendGiftErrorData!.message.toString() ==
//           //   //     'You does not have enough money in the wallet') {
//           //   //   showInsufficientFundsPopup(
//           //   //       context, state.sendGiftErrorData!.message);
//           //   // }
//           //   // if (state.sendGiftErrorData!.message!.trim() ==
//           //   //     'You does not have enough money in the wallet') {
//           //   //   showInsufficientFundsPopup(
//           //   //       context, state.sendGiftErrorData!.message);
//           //   // }
//           //   log(snapshot.data);
//           //   // List<dynamic> successData = json.decode('[${snapshot.data}]');
//           //   Map<String, dynamic> successData =
//           //       json.decode(snapshot.data ?? '');
//           //
//           //   log("${successData['success']}**********************");
//           //   log("${successData['status']}**********************");
//           //   // bool containsMessage = successData
//           //   //     .any((item) => item['message'] == 'sent Gift Successfully');
//           //   if (successData['success'] == false) {
//           //     showInsufficientFundsPopup(
//           //         context, state.sendGiftErrorData!.message);
//           //   } else {
//           //     showGiftSentPopup(context, '10');
//           //   }
//           //   //   showInsufficientFundsPopup(
//           //   //       context, state.sendGiftErrorData!.message);
//           // },
//           child: Column(
//             children: [
//               ListTile(
//                 leading: Image.network(
//                   gift.picture!,
//                   width: 50,
//                   height: 50,
//                   errorBuilder: (BuildContext context, Object exception,
//                       StackTrace? stackTrace) {
//                     return const Icon(Icons.error, color: Colors.red, size: 50);
//                   },
//                 ),
//                 title: Text(gift.nameEn!, style: const TextStyle(fontSize: 22)),
//                 trailing: Text(gift.value.toString(),
//                     style: const TextStyle(fontSize: 22)),
//               ),
//               const Divider(),
//             ],
//           ),
//         );
//       },
//     ),
//   );
// }
// void showInsufficientFundsPopup(BuildContext context, String? message) {
//   Navigator.pop(context);
//
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(16.0),
//         ),
//         title: const Row(
//           children: [
//             Icon(Icons.money_off, color: Colors.red, size: 30), // Related icon
//             SizedBox(width: 10), // Spacing between icon and title
//             Text('Insufficient Funds'),
//           ],
//         ),
//         content: message == 'Unexpected response format.'
//             ? SizedBox(
//           height: 50, // Adjust height as needed
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const LinearProgressIndicator(), // Show progress indicator
//               const SizedBox(height: 10), // Spacing
//               Text(
//                 message!,
//                 style: const TextStyle(fontSize: 16),
//                 textAlign: TextAlign.center,
//               ),
//             ],
//           ),
//         )
//             : Text(
//           message ?? 'You do not have enough money in your wallet.',
//           style: const TextStyle(fontSize: 16),
//         ),
//         actionsAlignment: MainAxisAlignment.spaceBetween,
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop(); // Close the dialog
//             },
//             style: TextButton.styleFrom(
//               foregroundColor: Colors.white,
//               backgroundColor: Colors.red, // Button color
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8.0),
//               ),
//             ),
//             child: const Text('OK'),
//           ),
//           TextButton(
//             onPressed: () {
//               // Add your logic to charge the wallet here
//               Navigator.of(context).pop(); // Optionally close the dialog
//               // Navigate to the charge wallet screen or perform the charge action
//               // Navigator.push(context, MaterialPageRoute(builder: (context) => ChargeWalletScreen()));
//             },
//             style: TextButton.styleFrom(
//               foregroundColor: Colors.white,
//               backgroundColor: Colors.indigo,
//               // Different color for the charge button
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8.0),
//               ),
//             ),
//             child: const Text('Charge Wallet'),
//           ),
//         ],
//       );
//     },
//   );
// }
// void showGiftSentPopup(BuildContext context, String? amount) {
//   Navigator.pop(context);
//
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(16.0),
//         ),
//         title: const Row(
//           children: [
//             Icon(Icons.card_giftcard, color: Colors.green, size: 30),
//             // Gift icon
//             SizedBox(width: 10),
//             // Spacing between icon and title
//             Text(
//               'Gift Sent',
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.green,
//               ),
//             ),
//           ],
//         ),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           mainAxisAlignment: MainAxisAlignment.center,
//           // Use minimum size for the dialog
//           children: [
//             const SizedBox(height: 10),
//             // Spacing
//             Text(
//               amount != null
//                   ? 'The gift has been sent successfully!\nAmount deducted: ¥$amount' // Using ¥ as a generic currency symbol
//                   : 'The gift has been sent successfully!',
//
//               style: const TextStyle(
//                 fontSize: 16,
//                 color: Colors.black87,
//               ),
//               textAlign: TextAlign.left, // Center the text
//             ),
//             const SizedBox(height: 20),
//             // More spacing
//             // Optional: Add a decorative element
//             const Icon(Icons.check_circle, color: Colors.green, size: 50),
//             // Success icon
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop(); // Close the dialog
//             },
//             style: TextButton.styleFrom(
//               foregroundColor: Colors.white,
//               backgroundColor: Colors.indigo, // Button color
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8.0),
//               ),
//             ),
//             child: const Text(
//               'OK',
//               style: TextStyle(fontSize: 16),
//             ),
//           ),
//         ],
//       );
//     },
//   );
// }
//==========================down code is refactord
class GiftBottomSheet extends StatelessWidget {
  final List<GiftData>? gifts;
  final UserData cardUser;
  final UserEntity? currentLoggedUser;

  const GiftBottomSheet({
    super.key,
    required this.gifts,
    required this.cardUser,
    required this.currentLoggedUser,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Send a gift',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.all(2),
              itemCount: gifts!.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final gift = gifts![index];
                return GiftItem(
                  currentLoggedUser: currentLoggedUser!,
                  gift: gift,
                  cardUser: cardUser,
                );
              },
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class GiftItem extends StatelessWidget {
  final GiftData gift;
  final UserData cardUser;
  final UserEntity currentLoggedUser;

  const GiftItem({
    super.key,
    required this.gift,
    required this.cardUser,
    required this.currentLoggedUser,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        context
            .read<TinderViewCubit>()
            .sendGift(
              receiverId: cardUser.id!,
              giftId: gift.sId!,
              subCategoryId: '66af974f8bf69f9469944746',
              // currentUserToken: currentLoggedUser.id,
              accessToken: TinderSharedUtils.token,
            )
            .then((value) {
          log("$value`````````````````````````````````");
          TinderSharedUtils.handleGiftResponse(
              context: context, response: value!, gift: gift);
        });
      },
      child: Column(
        children: [
          ListTile(
            leading: Image.network(
              gift.picture!,
              width: 50,
              height: 50,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.error, color: Colors.red, size: 50);
              },
            ),
            title: Text(gift.nameEn!, style: const TextStyle(fontSize: 22)),
            trailing: Text(gift.value.toString(),
                style: const TextStyle(fontSize: 22)),
          ),
          const Divider(),
        ],
      ),
    );
  }
}
