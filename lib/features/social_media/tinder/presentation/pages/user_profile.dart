import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/functions/global/upload_file.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/widgets/comments.dart';
import 'package:fourtyninehub/features/social_media/tinder/presentation/cubit/tinder_cubit.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/const.dart';

import '../../data/shared/shared.dart';

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

  Scaffold _buildLoadingScaffold() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          context.isArabic ? 'الصفحة الشخصية' : 'Profile',
          textScaler: TextScaler.noScaling,
        ),
      ),
      body: const Center(child: CupertinoActivityIndicator()),
    );
  }

  Scaffold _buildProfileScaffold(BuildContext context) {
    return Scaffold(
      floatingActionButton: _buildFloatingActionButton(context),
      appBar: AppBar(
        toolbarHeight: kToolbarHeight / 2,
      ),
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildSwipeCard(context),
                _buildUserInfo(context),
                _buildStats(context),
                const Sizer(
                  height: kToolbarHeight * 1.5,
                ),
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
      backgroundColor: AppColors.SECONDARY_COLOR,
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
        log("Image upload failed: No file selecjhgjgted.");
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
        color: isDarkTheme(context) ? Colors.black26 : Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: Column(
        children: [
          Text(
            capitalizeAndSplit(
                "${userId?.firstName ?? ''} ${userId?.lastName ?? ''}"),
            textScaler: TextScaler.noScaling,
            style: TextStyle(
              color:
                  isDarkTheme(context) ? Colors.white : AppColors.PRIMARY_COLOR,
              fontSize: 55.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            userId?.email ?? '',
            textScaler: TextScaler.noScaling,
            style: TextStyle(
              color: isDarkTheme(context)
                  ? Colors.white.withOpacity(0.8)
                  : AppColors.PRIMARY_COLOR.withOpacity(0.8),
              fontSize: 40.sp,
              fontWeight: FontWeight.w300,
            ),
          ),
          const Divider(),
          _buildListTile(
            icon: Icons.cake,
            iconColor: Colors.redAccent,
            title: LocaleKeys.user_info_date_of_birth.localize,
            subtitle: userId?.birthday ?? '',
          ),
          _buildListTile(
            icon: Icons.person,
            iconColor: Colors.redAccent,
            title: LocaleKeys.user_info_gender.localize,
            subtitle: getGender(context, userId?.gender ?? ''),
          ),
        ],
      ),
    );
  }

  getGender(BuildContext context, String comingGender) {
    if (comingGender.isNotEmpty) {
      if (comingGender == 'male') {
        return context.isArabic ? 'ذكر' : comingGender;
      }
      if (comingGender == 'female') {
        return context.isArabic ? 'أُنثى' : comingGender;
      }
    }
  }

  ListTile _buildListTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(
        title,
        textScaler: TextScaler.noScaling,
        style: TextStyle(fontSize: 45.sp),
      ),
      subtitle: Text(
        subtitle,
        textScaler: TextScaler.noScaling,
        style: TextStyle(fontSize: 40.sp),
      ),
    );
  }

  Widget _buildStats(BuildContext context) {
    final profileData = context.watch<TinderViewCubit>().state.profileUserData;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.h),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.PRIMARY_COLOR,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(LocaleKeys.user_info_followers.localize,
              profileData?.followersCount.toString() ?? '0'),
          _buildStatItem(LocaleKeys.user_info_following.localize,
              profileData?.followingCount.toString() ?? '0'),
          _buildStatItem(LocaleKeys.user_info_friends.localize,
              profileData?.friendsCount.toString() ?? '0'),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String count) {
    return Column(
      children: [
        Text(
          count,
          textScaler: TextScaler.noScaling,
          style: TextStyle(
            fontSize: 45.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          textScaler: TextScaler.noScaling,
          style: TextStyle(fontSize: 40.sp, color: Colors.white70),
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
      context.isArabic ? _nextStory() : _previousStory();
    } else {
      context.isArabic ? _previousStory() : _nextStory();
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
          Positioned.directional(
            top: 10,
            start: 10,
            end: 10,
            textDirection: TextDirection.ltr,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                pictures.length,
                (dotIndex) => Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2.0),
                    height: 4.h,
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
