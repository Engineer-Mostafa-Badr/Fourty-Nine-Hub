import 'dart:developer';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fourtyninehub/common/functions/global/upload_file.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/tinder/presentation/cubit/tinder_cubit.dart';
import 'package:fourtyninehub/features/social_media/tinder/presentation/widgets/edit_profile_tinder.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:fourtyninehub/res/style/styles.dart';

import '../../../../../core/widget/custom_scaffold.dart';
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
    return
        // context.watch<TinderViewCubit>().state.profileUserData == null
        //   ? _buildLoadingScaffold()
        // :
        _buildProfileScaffold(context);
  }

  CustomScaffold _buildLoadingScaffold() {
    return CustomScaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(30),
        child: BackAppBar(
          label: LocaleKeys.profile.localize,
        ),
      ),
      body: const Center(child: CupertinoActivityIndicator()),
    );
  }

  CustomScaffold _buildProfileScaffold(BuildContext context) {
    // final userCubit = context.read<UserCubit>();
    return CustomScaffold(
      backgroundColor: Colors.black,
      floatingActionButton: _buildFloatingActionButton(context),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(30),
        child: BackAppBar(
          label: 'Mohamed Magdy',
        ),
      ),
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            setState(() {});
          },
          //async {
          //   await context
          //       .read<TinderViewCubit>()
          //       .fetchUserProfile(userId: userCubit.state.data!.id);
          // },
          child: SingleChildScrollView(
            // physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildSwipeCard(context),
                  _buildUserInfo(context),
                  // _buildStats(context),
                  const Sizer(
                    height: kToolbarHeight * 1.5,
                  ),
                ],
              ),
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
      onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const EditProfileTinder()));
        // _handleImageUpload(context);
      },
      backgroundColor: AppColors.SECONDARY_COLOR,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      child: const Icon(Icons.edit, color: Colors.white),
    );
  }

  // Future<void> _handleImageUpload(BuildContext context) async {
  //   try {
  //     final uploadResult = await UploadFile().uploadImage(
  //       subCategoryId: '66af974f8bf69f9469944746',
  //       onUploaded: (uploadedFile) async {
  //         final userCubit = context.read<UserCubit>();
  //         final tinderCubit = context.read<TinderViewCubit>();
  //
  //         // await tinderCubit.uploadPictures(pictures: [uploadedFile.mediaId]);
  //         // await tinderCubit
  //         //     .fetchUserProfile(userId: userCubit.state.data!.id)
  //         //     .then((value) => tinderCubit.resetStoryIndex());
  //       }, context: context,
  //     );
  //
  //     if (uploadResult == null) {
  //       log("Image upload failed: No file selecjhgjgted.");
  //     }
  //   } catch (e) {
  //      log("Image upload failed: $e");
  //
  //   }
  // }

  Widget _buildUserInfo(BuildContext context) {
    // final profileData = context.watch<TinderViewCubit>().state.profileUserData;
    // final userId = profileData?.userId;

    return Column(
      children: [
        _buildInfoContainer(
            prefixIcon: Icons.search,
            title: 'Looking For',
            child: Label(
              text: 'New Friends',
              style: Styles.headerText(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 48),
            )),
        const Sizer(),
        _buildInfoContainer(
            prefixIcon: Icons.keyboard_double_arrow_right,
            suffixIcon: Icons.more_horiz,
            title: 'About Me',
            child: Label(
              text: 'Fighter',
              style: Styles.headerText(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 48),
            )),
        const Sizer(),
        _buildInfoContainer(
          prefixIcon: Icons.person_pin_rounded,
          suffixIcon: Icons.more_horiz,
          title: 'Essentials',
          child: Column(
            children: [
              _buildInfoContent(
                title: '10 Miles Away',
                icon: Icons.location_on_outlined,
              ),
              const Sizer(),
              _buildInfoContent(
                title: '188cm',
                icon: Icons.straighten_outlined,
              ),
              const Sizer(),
              _buildInfoContent(
                title: 'cairo university',
                icon: Icons.location_on_outlined,
              ),
            ],
          ),
        ),
        const Sizer(),
        _buildInfoContainer(
          prefixIcon:Icons.label ,
          title: 'Life Style',
          child: Column(
            children: [
              _buildInfoContent(
                headerText: 'Drinking',
                title: 'on special occasions',
                icon:FontAwesomeIcons.glassWater,
              ),
              const Sizer(),
              _buildInfoContent(
                headerText: 'Smoking',
                title: 'Smoker',
                icon: FontAwesomeIcons.smoking,
              ),
              const Sizer(),
              _buildInfoContent(
                headerText: 'Workout',
                title: 'sometimes',
                icon: FontAwesomeIcons.dumbbell,
              ),const Sizer(),
              _buildInfoContent(
                headerText: 'Pets',
                title: 'Cat',
                icon: FontAwesomeIcons.cat,
              ),
            ],
          )
        ),
        const Sizer(),
        _buildInfoContainer(
          prefixIcon:Icons.label ,
          title: 'Basics',
          child: Column(
            children: [
              _buildInfoContent(
                headerText: 'communication style',
                title: 'big time texter',
                icon:FontAwesomeIcons.glassWater,
              ),
              const Sizer(),
              _buildInfoContent(
                headerText: 'love style',
                title: 'thoughtful gestures',
                icon: FontAwesomeIcons.smoking,
              ),
              const Sizer(),
              _buildInfoContent(
                headerText: 'education',
                title: 'bechelors',
                icon: FontAwesomeIcons.dumbbell,
              ),const Sizer(),
              _buildInfoContent(
                headerText: 'zodiac',
                title: 'cancer',
                icon: FontAwesomeIcons.cat,
              ),
            ],
          )
        ),
        const Sizer(),
      ],
    );
  }

  Widget _buildInfoContent({required IconData icon, required String title, String? headerText}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(headerText!=null)
          Label(
            text: headerText,
            style: Styles.headerText(
              fontSize: 32,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        Container(
          decoration: const BoxDecoration(
            border: BorderDirectional(
                bottom: BorderSide(color: Color(0XFF808080), width: 1)),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            shape: const BorderDirectional(
                bottom: BorderSide(color: Color(0XFF808080), width: 1)),
            visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
            leading: Icon(
              icon,
              color: const Color(0xFF808080),
            ),
            title: Label(
              text: title,
              style: Styles.headerText(
                fontSize: 32,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoContainer({
    required IconData prefixIcon,
    required String title,
    IconData? suffixIcon,
    required Widget child,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.h),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color:const Color(0xFF262626),
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(
              prefixIcon,
              color: Colors.white,
            ),
            Sizer(),
            Expanded(
                child: Label(
              text: title,
              style: Styles.headerText(
                  fontSize: 32,
                  color: Colors.white,
                  fontWeight: FontWeight.w500),
            )),
            if (suffixIcon != null)
              Icon(
                suffixIcon,
                color: Colors.white,
              ),
          ]),
          Sizer(),
          child
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
      leading: Icon(
        icon,
        color: iconColor,
        size: 60.sp,
      ),
      title: Text(
        title,
        textScaler: TextScaler.noScaling,
        style: Styles.headerText(),
      ),
      subtitle: Text(
        subtitle,
        textScaler: TextScaler.noScaling,
        style: Styles.mediumText(fontSize: 65.sp),
      ),
    );
  }

  Widget _buildStats(BuildContext context) {
    //   final profileData = context.watch<TinderViewCubit>().state.profileUserData;

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
          _buildStatItem(LocaleKeys.user_info_followers.localize, '2000'
              //profileData?.followersCount.toString() ?? '0'
              ),
          _buildStatItem(LocaleKeys.user_info_following.localize, '2000'
              //  profileData?.followingCount.toString() ?? '0'
              ),
          _buildStatItem(LocaleKeys.user_info_friends.localize, '3003'
              //profileData?.friendsCount.toString() ?? '0'
              ),
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
      final pictures = [
        Assets.spotlight_profile,
        Assets.spotlight_profile,
        Assets.spotlight_profile,
        Assets.spotlight_profile,
      ];

      // final pictures =
      //     context.read<TinderViewCubit>().state.profileUserData?.pictures ?? [];
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
    final pictures = [
      Assets.spotlight_profile,
      Assets.spotlight_profile,
      Assets.spotlight_profile,
      Assets.spotlight_profile,
    ];
    // context.watch<TinderViewCubit>().state.profileUserData?.pictures ?? [];
    final imageUrl = pictures[_currentStoryIndex];
    // pictures.isNotEmpty
    //     ? pictures.reversed.toList()[_currentStoryIndex].mediaKey
    //     : UIConst.profilePlaceHolder;

    return Card(margin: EdgeInsets.zero,
      clipBehavior: Clip.hardEdge,
      elevation: 4,
      child: Stack(
        children: [
          Hero(
              tag: UniqueKey(),
              child: Image.asset(
                imageUrl,
                fit: BoxFit.fitHeight,
                height: double.infinity,
              )
              // Image.network(
              //   imageUrl,
              //   width: double.infinity,
              //   errorBuilder: (context, error, stackTrace) =>
              //       Image.network(
              //     UIConst.profilePlaceHolder,
              //     fit: BoxFit.fitHeight,
              //     height: double.infinity,
              //   ),
              //   fit: BoxFit.cover,
              //   height: double.infinity,
              // ),
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
