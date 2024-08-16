import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/functions/global/upload_file.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/models/profile_user_model.dart';
import 'package:fourtyninehub/features/social_media/tinder/presentation/cubit/tinder_cubit.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class UserProfilePage extends StatefulWidget {
  final UserCubit userCubit;

  const UserProfilePage({super.key, required this.userCubit});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  @override
  void initState() {
    super.initState();
    final tinderCubit = context.read<TinderViewCubit>()..resetStoryIndex();
    final userCubit = widget.userCubit;

    if (userCubit.state.data?.id != null && userCubit.state.token?.accessToken != null) {
      tinderCubit.fetchUserProfile(
        userId: userCubit.state.data!.id,
        token: userCubit.state.token!.accessToken,
      );
    } else {
      log('User ID or access token is null.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final tinderCubit = context.watch<TinderViewCubit>();

    if (tinderCubit.state.profileUserData == null) {
      return _buildLoadingScaffold();
    }

    return _buildProfileScaffold(tinderCubit);
  }

  SharedScaffold _buildLoadingScaffold() {
    return SharedScaffold(
      mainCategoryId: 6,
      body: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text('My Profile'),
        ),
        body: const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  SharedScaffold _buildProfileScaffold(TinderViewCubit tinderCubit) {
    return SharedScaffold(
      mainCategoryId: 6,
      body: Scaffold(
        floatingActionButton: _buildFloatingActionButton(context, tinderCubit),
        body: Stack(
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  _buildSwipeCard(tinderCubit),
                  _buildUserInfo(context, tinderCubit.state.profileUserData!),
                  _buildStats(tinderCubit.state.profileUserData!),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwipeCard(TinderViewCubit tinderCubit) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 16,
      height: MediaQuery.of(context).size.height * 0.60,
      child: SwipeCardDemo(userImages: tinderCubit.state.profileUserData!.pictures),
    );
  }

  FloatingActionButton _buildFloatingActionButton(BuildContext context, TinderViewCubit tinderCubit) {
    return FloatingActionButton(
      heroTag: 'upload_image',
      onPressed: () async => _handleImageUpload(tinderCubit),
      backgroundColor: Colors.red,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      child: const Icon(Icons.add_photo_alternate_outlined, color: Colors.white),
    );
  }

  Future<void> _handleImageUpload(TinderViewCubit tinderCubit) async {
    try {
      final userCubit = widget.userCubit;
      final uploadResult = await UploadFile().uploadImage(
        subCategoryId: '66af974f8bf69f9469944746',
        onUploaded: (uploadedFile) {
          tinderCubit.uploadPictures(
            pictures: [uploadedFile.mediaId],
            accessToken: userCubit.state.token!.accessToken,
          ).then((_) {
            tinderCubit.fetchUserProfile(
              userId: userCubit.state.data!.id,
              token: userCubit.state.token!.accessToken,
            );
          });
        },
      );

      if (uploadResult == null) {
        log("Image upload failed: No file selected.");
      }
    } catch (e) {
      log("Image upload failed: $e");
    }
  }

  Widget _buildUserInfo(BuildContext context, ProfileUserData userData) {
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
          _buildPersonInfo(userData),
          const Divider(),
          _buildListTile(
            icon: Icons.cake,
            iconColor: Colors.redAccent,
            title: 'Date of Birth',
            subtitle: userData.userId.birthday ?? 'N/A',
          ),
          _buildListTile(
            icon: Icons.person,
            iconColor: Colors.redAccent,
            title: 'Gender',
            subtitle: userData.userId.gender,
          ),
        ],
      ),
    );
  }

  Widget _buildPersonInfo(ProfileUserData user) {
    return Column(
      children: [
        Text(
          capitalizeAndSplit("${user.userId.firstName} ${user.userId.lastName}"),
          style: Styles.headerText(
            color: AppColors.PRIMARY_COLOR,
            fontSize: 38,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          user.userId.email,
          style: Styles.headerText(
            fontWeight: FontWeight.w400,
            color: AppColors.PRIMARY_COLOR,
          ),
        ),
      ],
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

  Widget _buildStats(ProfileUserData userData) {
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
          _buildStatItem('Followers', userData.followersCount.toString()),
          _buildStatItem('Following', userData.followingCount.toString()),
          _buildStatItem('Friends', userData.friendsCount.toString()),
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
  final List<ProfilePictureModel?> userImages;

  const SwipeCardDemo({super.key, required this.userImages});

  @override
  SwipeCardDemoState createState() => SwipeCardDemoState();
}

class SwipeCardDemoState extends State<SwipeCardDemo> {
  int _currentStoryIndex = 0;

  void _nextStory() {
    setState(() {
      _currentStoryIndex = (_currentStoryIndex < widget.userImages.length - 1)
          ? _currentStoryIndex + 1
          : widget.userImages.length - 1;
    });
  }

  void _previousStory() {
    setState(() {
      _currentStoryIndex = (_currentStoryIndex > 0) ? _currentStoryIndex - 1 : 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: (details) => _handleTap(details.localPosition),
      child: _buildCard(),
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

  Widget _buildCard() {
    final imageUrl = widget.userImages.isNotEmpty
        ? widget.userImages.reversed.toList()[_currentStoryIndex]?.mediaKey ??
        UIConst.profilePlaceHolder
        : UIConst.profilePlaceHolder;

    return Card(
      clipBehavior: Clip.hardEdge,
      elevation: 4,
      child: Stack(
        children: [
          Hero(
            tag: 'userHero-${widget.userImages.reversed.toList()[_currentStoryIndex]?.id}',
            child: Image.network(
              imageUrl,
              errorBuilder: (context, error, stackTrace) => Image.network(
                UIConst.profilePlaceHolder,
                fit: BoxFit.fitHeight,
                height: double.infinity,
              ),
              fit: BoxFit.fitWidth,
              height: double.infinity,
            ),
          ),
          _buildImageIndicators(),
        ],
      ),
    );
  }

  Widget _buildImageIndicators() {
    return Positioned(
      top: 10,
      left: 10,
      right: 10,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(widget.userImages.length, (dotIndex) {
          return Expanded(
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
          );
        }),
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
