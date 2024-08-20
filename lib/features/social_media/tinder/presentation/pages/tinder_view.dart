import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/badged_label.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/chat_cubit/chat_room_cubit.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/presentation/chat_cubit/chat_cubit.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/pages/reel_view.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/models/tinder_person_model.dart';
import 'package:fourtyninehub/features/social_media/tinder/presentation/cubit/tinder_cubit.dart';
import 'package:fourtyninehub/features/social_media/tinder/presentation/widgets/tinder_card_stack.dart';
import 'package:fourtyninehub/features/social_media/tinder/presentation/widgets/tinder_sub_category_card.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:intl/intl.dart';

const kToolbarHeightFactor = 0.80;
const kDefaultPadding = 8.0;

class TinderView extends StatelessWidget {
  const TinderView({super.key});

  @override
  Widget build(BuildContext context) {
    log('TinderView built');
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => serviceLocator<TinderViewCubit>()),
        BlocProvider(create: (context) => serviceLocator<ChatRoomCubit>()),
        BlocProvider(create: (context) => serviceLocator<UserCubit>()),
        BlocProvider(create: (context) => serviceLocator<ChatsCubit>()),
        // BlocProvider(create: (context) => serviceLocator<LoginCubit>()),
      ],
      child: const TinderScreen(),
    );
  }

// UserCubit _createUserCubit() {
//   return UserCubit(serviceLocator(), serviceLocator(), serviceLocator(),
//       serviceLocator(), serviceLocator(), serviceLocator());
// }
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
    context.read<TinderViewCubit>()
      ..fetchUserData(gender: 'female')
      ..fetchSubCategoryData()
      ..fetchFavorites();
  }

  @override
  Widget build(BuildContext context) {
    log('TinderScreen built');
    return SharedScaffold(
      body: Builder(builder: (context) {
        //---------------------------------------------
        log("${serviceLocator<UserCubit>().token}============================================================================");
        if (context.read<TinderViewCubit>().state.userData.isEmpty) {
          showSnackBarAfterBuild(context, message: 'Check the login page.');
          return const Center(
            child: CupertinoActivityIndicator(radius: 25),
          );
        }

        if (serviceLocator<UserCubit>().token == null ||
            serviceLocator<UserCubit>().token!.isEmpty) {
          showSnackBarAfterBuild(context, message: 'Check the login page.');

          return const Center(
            child: CupertinoActivityIndicator(radius: 25),
          );
        }
        return _buildLoggedInContent(context);
      }),
      mainCategoryId: 2,
    );
  }

  Widget _buildLoggedInContent(BuildContext context) {
    final tinderCubit = context.watch<TinderViewCubit>();
    final userCubit = context.watch<UserCubit>();

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            _buildHeader(),
            TinderCardStack(userCubit: userCubit),
            const Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 2),
              child: Divider(color: Colors.grey, height: 1),
            ),
            _buildSubCategoryList(context, tinderCubit, userCubit),
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

  Widget _buildSubCategoryList(
      BuildContext context, TinderViewCubit tinderCubit, UserCubit userCubit) {
    return SizedBox(
      height: 225,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 4),
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
    final token = widget.userCubit.state.token?.accessToken;
    if (token != null) {
      tinderCubit
        ..fetchLastSeen(
          userId: widget.cardUser.id ?? '',
        )
        ..checkUserNearby(
          cardUserId: widget.cardUser.id ?? '',
        );
      log('Fetched user data in PersonInfoWidget');
    }
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
                _buildStatusBadge(
                    tinderCubit.state.lastSeenModel?.data?.status),
                const SizedBox(width: 10),
                _buildNearbyBadge(
                    tinderCubit.state.isUserNearby?.data?.isNearBy),
              ],
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                capitalizeAndSplit(
                    '${cardUser.firstName ?? ''} ${cardUser.lastName ?? ''}'),
                style: Styles.headerText(
                    color: AppColors.PRIMARY_COLOR,
                    fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                _getLastSeenText(
                    tinderCubit.state.lastSeenModel?.data?.lastSeen),
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
    return lastSeen != null
        ? "Last seen ${getTimeAgo(lastSeen)}"
        : "Last seen N/A";
  }
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

/*import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/functions/helper/auth_helper.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/badged_label.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/chat_cubit/chat_room_cubit.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/presentation/chat_cubit/chat_cubit.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/models/tinder_person_model.dart';
import 'package:fourtyninehub/features/social_media/tinder/presentation/cubit/tinder_cubit.dart';
import 'package:fourtyninehub/features/social_media/tinder/presentation/widgets/tinder_card_stack.dart';
import 'package:fourtyninehub/features/social_media/tinder/presentation/widgets/tinder_sub_category_card.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

const kToolbarHeightFactor = 0.80;
const kDefaultPadding = 8.0;
final GetIt serviceLocator = GetIt.instance;

void setupServiceLocator() {
  // Register your Cubits or other services
  serviceLocator.registerLazySingleton<UserCubit>(() => UserCubit(
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
      serviceLocator()));
  serviceLocator
      .registerLazySingleton<TinderViewCubit>(() => TinderViewCubit());
  serviceLocator.registerLazySingleton<ChatsCubit>(() => ChatsCubit(
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
      serviceLocator()));
}

class TinderView extends StatefulWidget {
  const TinderView({super.key});

  @override
  State<TinderView> createState() => _TinderViewState();
}

class _TinderViewState extends State<TinderView> {
  @override
  void initState() {
    // TODO: implement initState
    setupServiceLocator();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final TinderViewCubit tinderCubit = serviceLocator<TinderViewCubit>();
    final UserCubit userCubit = serviceLocator<UserCubit>();
    final ChatsCubit chatsCubit = serviceLocator<ChatsCubit>();
    final ChatRoomCubit chatRoomCubit = serviceLocator<ChatRoomCubit>();

    log('TinderView built');
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: tinderCubit),
        BlocProvider.value(value: userCubit),
        BlocProvider.value(value: chatsCubit),
        BlocProvider.value(value: chatRoomCubit),
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
      if (token.isNotEmpty) {
        tinderCubit
          ..fetchUserData(accessToken: token, gender: 'female')
          ..fetchSubCategoryData(accessToken: token)
          ..fetchFavorites(token);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    log('TinderScreen built');
    return SharedScaffold(
      body: AuthHelper().isLoggedIn()
          ? _buildLoggedInContent(context)
          : const Center(child: Text('No user yet')),
      mainCategoryId: 2,
    );
  }

  Widget _buildLoggedInContent(BuildContext context) {
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
            const Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 2),
              child: Divider(color: Colors.grey, height: 1),
            ),
            _buildSubCategoryList(context, tinderCubit, userCubit),
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

  Widget _buildSubCategoryList(
      BuildContext context, TinderViewCubit tinderCubit, UserCubit userCubit) {
    return SizedBox(
      height: 225,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 4),
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
    final token = widget.userCubit.state.token?.accessToken;
    if (token != null) {
      tinderCubit
        ..fetchLastSeen(userId: widget.cardUser.id ?? '', accessToken: token)
        ..checkUserNearby(
            cardUserId: widget.cardUser.id ?? '', accessToken: token);
      log('Fetched user data in PersonInfoWidget');
    }
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
                _buildStatusBadge(
                    tinderCubit.state.lastSeenModel?.data?.status),
                const SizedBox(width: 10),
                _buildNearbyBadge(
                    tinderCubit.state.isUserNearby?.data?.isNearBy),
              ],
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                capitalizeAndSplit(
                    '${cardUser.firstName ?? ''} ${cardUser.lastName ?? ''}'),
                style: Styles.headerText(
                    color: AppColors.PRIMARY_COLOR,
                    fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                _getLastSeenText(
                    tinderCubit.state.lastSeenModel?.data?.lastSeen),
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
    return lastSeen != null
        ? "Last seen ${getTimeAgo(lastSeen)}"
        : "Last seen N/A";
  }
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
*/
//20/8