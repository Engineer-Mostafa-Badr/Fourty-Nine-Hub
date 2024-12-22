import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/profile_image.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/constants/constants.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/usecases/get_chats_usecase.dart';
import 'package:fourtyninehub/features/social_media/create_post/presentation/widgets/image_details.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/view_followers_and_following.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/user_profile_entity.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/cubit/social_posts_cubit.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/pages/media_view.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/pages/message_button.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/pages/saved_reels_view.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/account/instagram_suggest_people.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/account/user_reels.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/widgets/report_view.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

class InstagramProfile extends StatefulWidget {
  const InstagramProfile({super.key, required this.userId});
  final String userId;

  @override
  State<InstagramProfile> createState() => _InstagramProfileState();
}

class _InstagramProfileState extends State<InstagramProfile> {
  bool showSuggestPeople = false;

  void showHideSuggestPeople() {
    setState(() {
      showSuggestPeople = !showSuggestPeople;
    });
  }

  @override
  Widget build(BuildContext context) {
    final loginUser = context.read<UserCubit>().state.data;

    return DefaultTabController(
      length: loginUser?.id == widget.userId ? 3 : 2,
      child: Scaffold(
        body: BlocBuilder<SocialPostsCubit, SocialPostsState>(
            builder: (context, state) {
          final controller = context.read<SocialPostsCubit>();
          return state.status == StateStatus.loading
              ? const Center(
                  child: CupertinoActivityIndicator(),
                )
              : CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                        child: Container(
                            width: double.infinity,
                            padding:  EdgeInsetsDirectional.only(
                                top: 70.h, end: 20.w, start: 20.w),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      IconButton(
                                          onPressed: () => context.pop(),
                                          icon: Icon(
                                            Icons.arrow_back,
                                            color: context.isDarkMode
                                                ? AppColors.LIGHT_COLOR
                                                : AppColors.DARK_BLUE_COLOR,
                                            size: 55.w,
                                          )),
                                      if ( state.profileData!.email.isNotEmpty &&  state.profileData!.email !='Hidden')
                                      Label(
                                          text:
                                              '${state.profileData?.email.split('@')[0]}',
                                          style: Styles.headerText(
                                            color: context.isDarkMode
                                                ? AppColors.LIGHT_COLOR
                                                : AppColors.DARK_GRAY_COLOR,
                                          )),
                                      if (state.profileData?.isDocument ==
                                          true) ...[
                                        Sizer(
                                          width: 8.w,
                                        ),
                                        Icon(
                                          Icons.verified,
                                          size: 35.w,
                                          color: AppColors.PRIMARY_COLOR_DARK,
                                        )
                                      ]
                                    ],
                                  ),
                                  if (loginUser?.id != widget.userId)
                                    PopupMenuButton(
                                        icon: Icon(
                                          Icons.more_vert,
                                          color: context.isDarkMode
                                              ? AppColors.LIGHT_COLOR
                                              : AppColors.DARK_BLUE_COLOR,
                                          size: 45.w,
                                        ),
                                        itemBuilder: (context) {
                                          return [
                                            PopupMenuItem<int>(
                                              value: 4,
                                              child: Text(
                                                  LocaleKeys.report.localize),
                                              onTap: () {
                                                bottomSheet(
                                                    context: context,
                                                    widget: ReportView(
                                                      id: widget.userId,
                                                      categoryId: Constants
                                                          .facebookSubCategory,
                                                    ));
                                              },
                                            ),
                                            if (loginUser?.id !=
                                                state.profileData?.id)
                                              PopupMenuItem<int>(
                                                value: 5,
                                                child: Text(state.profileData
                                                            ?.isBlock ==
                                                        true
                                                    ? LocaleKeys
                                                        .unBlock.localize
                                                    : LocaleKeys
                                                        .block.localize),
                                                onTap: () async {
                                                  // context.pop();
                                                  var result = await controller
                                                      .blockUser(
                                                          context: context,
                                                          userId:
                                                              widget.userId);
                                                  print("result:$result");
                                                  if (result == true) {
                                                    print("object");
                                                    if (state.profileData
                                                            ?.isBlock ==
                                                        false) {
                                                      state.profileData
                                                          ?.isBlock = true;
                                                      showSuccessMessage(
                                                          context,
                                                          LocaleKeys
                                                              .blockedSuccessfully
                                                              .localize);
                                                    } else {
                                                      state.profileData
                                                          ?.isBlock = false;
                                                      showSuccessMessage(
                                                          context,
                                                          LocaleKeys
                                                              .unBlockedSuccessfully
                                                              .localize);
                                                    }
                                                  }
                                                },
                                              ),
                                          ];
                                        })
                                ]))),
                    SliverToBoxAdapter(
                      child: _buildAccountCounter(
                          context: context,
                          user: state.profileData!,
                          onFollow: () async {
                            if (state.profileData?.isFollowed == true) {
                              var result = await controller.unFollowRequest(
                                  context: context,
                                  userId: state.profileData!.id);
                              if (result == true) {
                                state.profileData?.isFollowed = false;
                                setState(() {});
                              }
                            } else {
                              var result = await controller.followRequest(
                                  context: context,
                                  userId: state.profileData!.id);
                              if (result == true) {
                                state.profileData?.isFollowed = true;
                                setState(() {});
                              }
                            }
                          },
                          getUserProfile: () async {
                            await context.push(Routes.EDITPROFILE);
                            controller.getUserProfile(id: widget.userId);
                          },
                          showHideSuggestPeople: () {
                            showHideSuggestPeople();
                            print(showSuggestPeople);
                          },
                          showSuggestPeople: showSuggestPeople),
                    ),
                    SliverToBoxAdapter(
                      child: state.profileData?.isBlock == false
                          ? Column(
                              children: [
                                const Sizer(),
                                TabBar(
                                    labelStyle: Styles.mediumText(),
                                    isScrollable: true,
                                    tabAlignment: TabAlignment.center,
                                    // labelPadding: EdgeInsetsDirectional.only(end: 100),
                                    indicatorSize: TabBarIndicatorSize.tab,
                                    indicatorColor: AppColors.SECONDARY_COLOR,
                                    labelPadding:
                                        EdgeInsetsDirectional.symmetric(
                                            horizontal: 90.w),
                                    onTap: (i) {
                                      controller.changeUserPage(i);
                                    },
                                    tabs: [
                                      Tab(
                                        icon: Image.asset(
                                          Assets.userMedia,
                                          width: 55.w,
                                          color: context.isDarkMode
                                              ? AppColors.LIGHT_COLOR
                                              : AppColors.DARK_BLUE_COLOR,
                                        ),
                                      ),
                                      Tab(
                                        icon: Image.asset(
                                          Assets.userReels,
                                          width: 55.w,
                                          color: context.isDarkMode
                                              ? AppColors.LIGHT_COLOR
                                              : AppColors.DARK_BLUE_COLOR,
                                        ),
                                      ),
                                      if (context
                                              .read<UserCubit>()
                                              .state
                                              .data
                                              ?.id ==
                                          widget.userId)
                                        Tab(
                                          icon: Image.asset(
                                            Assets.savedReels,
                                            width: 55.w,
                                            color: context.isDarkMode
                                                ? AppColors.LIGHT_COLOR
                                                : AppColors.DARK_BLUE_COLOR,
                                          ),
                                        ),
                                    ]),
                                // _buildAccountPages(state.profileData!),
                              ],
                            )
                          : Center(
                              child: Padding(
                                padding: EdgeInsets.only(top: 50.0.h),
                                child: Label(
                                  text: LocaleKeys
                                      .youHaveBlockedThisUser.localize,
                                ),
                              ),
                            ),
                    ),
                    state.profilePage == 0 &&
                            state.profileData?.isBlock == false
                        ? MediaView(
                            userId: widget.userId,
                          )
                        : state.profilePage == 1 &&
                                state.profileData?.isBlock == false
                            ? UserReels(
                                userData: state.profileData!,
                              )
                            : state.profilePage == 2 &&
                                    state.profileData?.isBlock == false
                                ? SavedReelsView(userData: state.profileData!)
                                : const SliverToBoxAdapter(
                                    child: SizedBox.shrink(),
                                  ),
                  ],
                );
        }),
      ),
    );
  }

  Widget _buildAccountCounter(
      {required BuildContext context,
      required UserProfileEntity user,
      required Function onFollow,
      required GestureTapCallback? getUserProfile,
      required GestureTapCallback? showHideSuggestPeople,
      required bool showSuggestPeople}) {
    final loginUser = context.read<UserCubit>().state.data;
    print('followers${user.followers}');
    return BlocBuilder<SocialPostsCubit, SocialPostsState>(
        builder: (context, state) {
      final controller = context.read<SocialPostsCubit>();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Stack(
                  alignment: AlignmentDirectional.bottomEnd,
                  children: [
                    state.newImage != null
                        ? InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => ImageDetailsScreen(
                                  image: state.newImage!.file.path,
                                  fromPost: true,
                                  isFile: true,
                                  onRemoveImage: () {
                                    context.pop();
                                  },
                                ),
                              );
                            },
                            child: CircleAvatar(
                              radius: 40.r,
                              child: CircleAvatar(
                                radius: 40.r,
                                backgroundColor: Colors.white,
                                backgroundImage:
                                    FileImage(File(state.newImage!.file.path)),
                              ),
                            ),
                          )
                        : InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => ImageDetailsScreen(
                                  image: user.profilePicture!,
                                  fromPost: true,
                                  isFile: false,
                                  onRemoveImage: () {
                                    context.pop();
                                  },
                                ),
                              );
                            },
                            child: ImageFromInternet(
                              image: user.profilePicture ??
                                  UIConst.profilePlaceHolder,
                              height: 100.h,
                              width: 100.w,
                              isCircle: true,
                            ),
                          ),
                    if (loginUser?.id == user.id)
                      InkWell(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return Wrap(
                                children: <Widget>[
                                  ListTile(
                                    leading: const Icon(Icons.photo_library),
                                    title: Text(LocaleKeys.gallery.localize),
                                    onTap: () async {
                                      Navigator.pop(context);
                                      await controller.uploadPhoto(
                                          isGallery: true);
                                      // Reload user data if needed
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.camera_alt),
                                    title: Text(LocaleKeys.camera.localize),
                                    onTap: () async {
                                      Navigator.pop(context);
                                      await controller.uploadPhoto(
                                          isGallery: false);
                                      // Reload user data if needed
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Container(
                            padding: EdgeInsets.all(8.w),
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.PRIMARY_COLOR),
                            child: Icon(
                              Icons.camera_alt_outlined,
                              color: Colors.white,
                              size: 32.w,
                            )),
                      )
                  ],
                ),
                const Sizer(
                  width: 20,
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildCounter(
                        value: '${user.instagramPosts ?? 0} ',
                        label: LocaleKeys.Posts.localize,
                      ),
                      const Sizer(),
                      InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>const ViewFollowersAndFollowing()));
                        },
                        child: _buildCounter(
                          value: '${user.followersCount} ',
                          label: LocaleKeys.Followers.localize,
                        ),
                      ),
                      const Sizer(),
                      InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>const ViewFollowersAndFollowing()));
                        },
                        child: _buildCounter(
                          value: '${user.followingCount} ',
                          label: LocaleKeys.Following.localize,
                        ),
                      ),
                      Sizer(
                        width: 8.w,
                      ),
                      _buildCounter(
                        value: '${user.totalView} ',
                        label: LocaleKeys.view.localize,
                      ),
                      Sizer(
                        width: 8.w,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Sizer(),
                RichText(
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(children: [
                      TextSpan(
                          text: "${user.firstName} ${user.lastName}",
                          style: Styles.headerText(
                            fontWeight: FontWeight.w600,
                          )),
                      // if (user.job.isNotEmpty&& user.job !='Hidden')
                      //   TextSpan(
                      //       text: '\t(${user.job})',
                      //       style: Styles.headerText(
                      //           color: context.isDarkMode
                      //               ? AppColors.LIGHT_COLOR
                      //               : AppColors.DARK_BLUE_COLOR,
                      //           fontSize: 26)),
                    ])),
                Sizer(
                  height: 4.h,
                ),
                if (user.email.isNotEmpty && user.email !='Hidden')
                Label(
                    text: '@ ${user.email.split('@')[0]}',
                    style: Styles.mediumText(
                      color: context.isDarkMode
                          ? AppColors.LIGHT_GRAY_COLOR
                          : AppColors.DARK_BLUE_COLOR,
                    )),
                Sizer(
                  height: 4.h,
                ),
                if (user.bio.isNotEmpty && user.bio !='Hidden')
                  Label(
                      text: user.bio,
                      style: Styles.mediumText(
                        color: context.isDarkMode
                            ? AppColors.LIGHT_GRAY_COLOR
                            : AppColors.DARK_BLUE_COLOR,
                      )),
                Sizer(
                  height: 5.h,
                ),
                if (user.city.isNotEmpty ||
                    user.job.isNotEmpty ||
                    user.country.isNotEmpty ||
                    user.phone.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (user.city.isNotEmpty || user.country.isNotEmpty && user.country !='Hidden' && user.city !='Hidden') ...[
                        Row(
                          children: [
                            Expanded(
                              child: Label(
                                text:
                                    '${user.country}${user.city.isNotEmpty ? ',' : ''} ${user.city}',
                                style: Styles.headerText(
                                    color: context.isDarkMode
                                        ? AppColors.LIGHT_GRAY_COLOR
                                        : AppColors.DARK_BLUE_COLOR,
                                    fontSize: 26),
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                        Sizer(
                          height: 5.h,
                        ),
                      ],
                      if (user.phone.isNotEmpty && user.phone !='Hidden') ...[
                        Row(
                          children: [
                            Expanded(
                              child: Label(
                                text: user.phone,
                                style: Styles.headerText(
                                    color: context.isDarkMode
                                        ? AppColors.LIGHT_GRAY_COLOR
                                        : AppColors.DARK_BLUE_COLOR,
                                    fontSize: 26),
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                        Sizer(
                          height: 5.h,
                        ),
                      ],
                      if (user.job.isNotEmpty && user.job !='Hidden')
                        Row(
                          children: [
                            Expanded(
                              child: Label(
                                text: user.job,
                                style: Styles.headerText(
                                    color: context.isDarkMode
                                        ? AppColors.LIGHT_GRAY_COLOR
                                        : AppColors.DARK_BLUE_COLOR,
                                    fontSize: 26),
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
              ],
            ),
          ),
          if (user.followers != null && user.followers!.isNotEmpty && user.followers !='Hidden')
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.h),
              child: Row(
                children: [
                  SizedBox(
                    width: user.followers!.length == 1
                        ? 25
                        : user.followers!.length == 2
                            ? 40
                            : 60,
                    height: 32.h,
                    child: Stack(
                      children: List.generate(
                        user.followers!.length < 3 ? user.followers!.length : 3,
                        (index) => Positioned(
                            top: 0,
                            left: index == 0
                                ? 0
                                : index == 1
                                    ? 16
                                    : 32,
                            child: const ProfileImage(
                              userId: '',
                              accountId: 0,
                              imageURL: UIConst.profilePlaceHolder,
                              withBorder: false,
                            )),
                      ),
                    ),
                  ),
                  const Sizer(),
                  Expanded(
                      child: Row(
                    children: [
                      Expanded(
                        child: RichText(
                            text: TextSpan(children: [
                          TextSpan(
                              text:
                                  '${user.followers!.isNotEmpty ? '${user.followers![0].firstName} ${user.followers![0].lastName}' : ''} ${user.followers!.length > 1 ? '${user.followers![1].firstName} ${user.followers![1].lastName}' : ''}',
                              style: Styles.mediumText(
                                color: context.isDarkMode
                                    ? AppColors.LIGHT_GRAY_COLOR
                                    : AppColors.DARK_BLUE_COLOR,
                              )),
                          if (user.followers!.length > 2)
                            TextSpan(
                                text:
                                    '\tand ${user.followers!.length - 2} others',
                                style: Styles.mediumText(
                                  color: context.isDarkMode
                                      ? AppColors.GREY_LIGHT_COLOR
                                      : AppColors.DARK_GRAY_COLOR,
                                )),
                        ])),
                      ),
                    ],
                  ))
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                if (loginUser?.id != widget.userId) ...[
                  const Sizer(),
                  Row(
                    children: [
                      Expanded(
                        child: AppButton(
                            height: 62.h,
                            backColor: user.isFollowed == true
                                ? AppColors.PRIMARY_COLOR
                                : null,
                            label: user.isFollowed == true
                                ? LocaleKeys.Unfollow.localize
                                : LocaleKeys.follow.localize,
                            style: Styles.mediumText(color: Colors.white),
                            onPressed: () {
                              onFollow();
                            }),
                      ),
                      const Sizer(),
                      Expanded(
                          child: MessageButton(
                              user: state.profileData!,
                              normalPress: () async {
                                if (context.read<UserCubit>().isLoggedIn) {
                                  if (state.profileData?.areFriends == true) {
                                    var result = await context
                                        .read<SocialPostsCubit>()
                                        .createNormalChat(widget.userId,
                                            ChatCategoriesIds.social);
                                    if (result == true) {
                                      context.push(Routes.CHAT);
                                    }
                                  } else {
                                    var result = await context
                                        .read<SocialPostsCubit>()
                                        .createNormalChat(widget.userId,
                                            ChatCategoriesIds.greet);
                                    if (result == true) {
                                      context.pop();
                                      context.push(Routes.CHAT);
                                    } else {
                                      showErrorMessage(
                                          context,
                                          getFailureMessage(
                                              state.failure!, context));
                                      context.pop();
                                    }
                                  }
                                } else {
                                  context.push(Routes.LOGIN);
                                }
                              },
                              anonymousPress: () async {
                                if (context.read<UserCubit>().isLoggedIn) {
                                  var result = await context
                                      .read<SocialPostsCubit>()
                                      .createAnonymousChat(widget.userId);
                                  if (result == true) {
                                    context.pop();
                                    context.push(Routes.CHAT);
                                  } else {
                                    showErrorMessage(
                                        context,
                                        getFailureMessage(
                                            state.failure!, context));
                                    context.pop();
                                  }
                                } else {
                                  context.push(Routes.LOGIN);
                                }
                              })),
                      const Sizer(),
                      InkWell(
                        onTap: showHideSuggestPeople,
                        child: Container(
                          height: kToolbarHeight * 1.h,
                          width: 80.w,
                          margin: const EdgeInsets.all(0),
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.r),
                            color: AppColors.PRIMARY_COLOR,
                          ),
                          child: Center(
                            child: Icon(
                              showSuggestPeople == false
                                  ? Icons.person_add
                                  : Icons.person,
                              color: Colors.white,
                              size: 40.w,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                if (loginUser?.id == widget.userId) ...[
                  const Sizer(),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: getUserProfile,
                          child: Container(
                            height: kToolbarHeight * 1.h,
                            margin: const EdgeInsets.all(0),
                            padding: EdgeInsets.symmetric(horizontal: 10.w),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.r),
                              color: AppColors.PRIMARY_COLOR,
                            ),
                            child: Center(
                              child: Label(
                                text: LocaleKeys.editProfile.localize,
                                style: Styles.mediumText(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Sizer(),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            onFollow();
                          },
                          child: Container(
                            height: kToolbarHeight * 1.h,
                            margin: const EdgeInsets.all(0),
                            padding: EdgeInsets.symmetric(horizontal: 10.w),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.r),
                              color: AppColors.PRIMARY_COLOR,
                            ),
                            child: Center(
                              child: Label(
                                text: LocaleKeys.shareProfile.localize,
                                style: Styles.mediumText(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Sizer(),
                      InkWell(
                        onTap: showHideSuggestPeople,
                        child: Container(
                          height: kToolbarHeight * 1.h,
                          width: 80.w,
                          margin: const EdgeInsets.all(0),
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.r),
                            color: AppColors.PRIMARY_COLOR,
                          ),
                          child: Center(
                            child: Icon(
                              showSuggestPeople == false
                                  ? Icons.person_add
                                  : Icons.person,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                if (showSuggestPeople == true)
                  const InstagramProfileSuggestPeople()
              ],
            ),
          ),
        ],
      );
    });
  }

  Widget _buildCounter({required String value, required String label}) {
    return Column(
      children: [
        Text(
          value,
          style: Styles.headerText(),
        ),
        Sizer(
          height: 2.h,
        ),
        Text(
          label,
          style: Styles.mediumText(
            color: context.isDarkMode
                ? AppColors.LIGHT_GRAY_COLOR2
                : AppColors.DARK_BLUE_COLOR,
          ),
        ),
      ],
    );
  }
}
