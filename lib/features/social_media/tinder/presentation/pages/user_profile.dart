import 'dart:developer';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/functions/global/upload_file.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/tinder/presentation/cubit/tinder_cubit.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  UserProfilePageState createState() => UserProfilePageState();
}

class UserProfilePageState extends State<UserProfilePage> {
  @override
  void initState() {
    super.initState();
    // final userId = context.read<UserCubit>().state.data?.id;
    // if (userId != null) {
    //   final tinderCubit = context.read<TinderViewCubit>();
    //   tinderCubit
    //     ..resetStoryIndex()
    //     ..fetchUserProfile(userId: userId);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return context.watch<TinderViewCubit>().state.profileUserData == null
        ? _buildLoadingScaffold()
        : _buildProfileScaffold(context);
  }

  SharedScaffold _buildLoadingScaffold() {
    return SharedScaffold(
      mainCategoryId: 6,
      body: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text('My Profile'),
        ),
        body: const Center(child: CupertinoActivityIndicator()),
      ),
    );
  }

  SharedScaffold _buildProfileScaffold(BuildContext context) {
    return SharedScaffold(
      mainCategoryId: 6,
      body: Scaffold(
        floatingActionButton: _buildFloatingActionButton(context),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildSwipeCard(context),
                _buildUserInfo(context),
                _buildStats(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSwipeCard(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 16,
      height: MediaQuery.of(context).size.height * 0.60,
      child: const SwipeCardDemo(),
    );
  }

  FloatingActionButton _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      heroTag: 'upload_image',
      onPressed: () => _handleImageUpload(context),
      backgroundColor: Colors.red,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      child:
          const Icon(Icons.add_photo_alternate_outlined, color: Colors.white),
    );
  }

  Future<void> _handleImageUpload(BuildContext context) async {
    try {
      final uploadResult = await UploadFile().uploadImage(
        subCategoryId: '66af974f8bf69f9469944746',
        onUploaded: (uploadedFile) async {
          final userCubit = context.read<UserCubit>();
          final tinderCubit = context.read<TinderViewCubit>();

          await tinderCubit.uploadPictures(pictures: [uploadedFile.mediaId]);
          await tinderCubit
              .fetchUserProfile(userId: userCubit.state.data!.id)
              .then((value) => tinderCubit.resetStoryIndex());
        },
      );

      if (uploadResult == null) {
        log("Image upload failed: No file selected.");
      }
    } catch (e) {
      log("Image upload failed: $e");
    }
  }

  Widget _buildUserInfo(BuildContext context) {
    final profileData = context.watch<TinderViewCubit>().state.profileUserData;
    final userId = profileData?.userId;

    return Container(
      margin: const EdgeInsets.only(top: 10.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: Column(
        children: [
          Text(
            capitalizeAndSplit(
                "${userId?.firstName ?? ''} ${userId?.lastName ?? ''}"),
            style: Styles.headerText(
              color: AppColors.PRIMARY_COLOR,
              fontSize: 38,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            userId?.email ?? '',
            style: Styles.headerText(
              fontWeight: FontWeight.w400,
              color: AppColors.PRIMARY_COLOR,
            ),
          ),
          const Divider(),
          _buildListTile(
            icon: Icons.cake,
            iconColor: Colors.redAccent,
            title: 'Date of Birth',
            subtitle: userId?.birthday ?? '',
          ),
          _buildListTile(
            icon: Icons.person,
            iconColor: Colors.redAccent,
            title: 'Gender',
            subtitle: userId?.gender ?? '',
          ),
        ],
      ),
    );
  }

  ListTile _buildListTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(title),
      subtitle: Text(subtitle),
    );
  }

  Widget _buildStats(BuildContext context) {
    final profileData = context.watch<TinderViewCubit>().state.profileUserData;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.PRIMARY_COLOR,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
              'Followers', profileData?.followersCount.toString() ?? '0'),
          _buildStatItem(
              'Following', profileData?.followingCount.toString() ?? '0'),
          _buildStatItem(
              'Friends', profileData?.friendsCount.toString() ?? '0'),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String count) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(fontSize: 16, color: Colors.white70),
        ),
      ],
    );
  }
}

class SwipeCardDemo extends StatefulWidget {
  const SwipeCardDemo({super.key});

  @override
  SwipeCardDemoState createState() => SwipeCardDemoState();
}

class SwipeCardDemoState extends State<SwipeCardDemo> {
  int _currentStoryIndex = 0;

  void _nextStory() {
    setState(() {
      final pictures =
          context.read<TinderViewCubit>().state.profileUserData?.pictures ?? [];
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
    final pictures =
        context.watch<TinderViewCubit>().state.profileUserData?.pictures ?? [];
    final imageUrl = pictures.isNotEmpty
        ? pictures.reversed.toList()[_currentStoryIndex].mediaKey
        : UIConst.profilePlaceHolder;

    return Card(
      clipBehavior: Clip.hardEdge,
      elevation: 4,
      child: Stack(
        children: [
          Hero(
            tag: UniqueKey(),
            child: Image.network(
              imageUrl,
              width: double.infinity,
              errorBuilder: (context, error, stackTrace) => Image.network(
                UIConst.profilePlaceHolder,
                fit: BoxFit.fitHeight,
                height: double.infinity,
              ),
              fit: BoxFit.cover,
              height: double.infinity,
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
      ),
    );
  }
}

String capitalize(String name) {
  if (name.isEmpty) return name;
  return name[0].toUpperCase() + name.substring(1).toLowerCase();
}

String capitalizeAndSplit(String name) {
  if (name.isEmpty) return name;
  List<String> parts = name.split(' ').take(2).toList();
  return parts.map(capitalize).join(' ');
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
