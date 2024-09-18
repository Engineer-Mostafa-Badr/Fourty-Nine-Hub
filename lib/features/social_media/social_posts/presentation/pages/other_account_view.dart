import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/create_post/presentation/widgets/image_details.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/user_profile_entity.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/accept_reject_friend_request_use_case.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/cubit/social_posts_cubit.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/pages/api_error_page.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/pages/saved_reels_view.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/pages/search_app_users.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/account/user_posts.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/account/user_reels.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/account/user_tweets.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/widgets/report_view.dart';
import 'package:go_router/go_router.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/const.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../routes/routes.dart';

class OtherAccountView extends StatefulWidget {
  const OtherAccountView({super.key, required this.userId});
  final String userId;

  @override
  State<OtherAccountView> createState() => _OtherAccountViewState();
}

class _OtherAccountViewState extends State<OtherAccountView> {
  @override
  Widget build(BuildContext context) {
    final loginUser = context.read<UserCubit>().state.data;

    return DefaultTabController(
      length: loginUser?.id == widget.userId ? 4 : 3,
      child: Scaffold(
        body: BlocBuilder<SocialPostsCubit, SocialPostsState>(
            builder: (context, state) {
          final controller = context.read<SocialPostsCubit>();
          return state.status == StateStatus.loading
              ? const Center(
                  child: CupertinoActivityIndicator(),
                )
              : state.status == StateStatus.error
                  ? ApiErrorPage(
                      message: getFailureMessage(
                        state.failure ?? UnknownFailure(''),
                        context,
                      ),
                    )
                  : CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(
                            child: Container(
                                width: double.infinity,
                                padding: const EdgeInsetsDirectional.only(
                                    top: 35, end: 10, start: 10),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconButton(
                                          onPressed: () => context.pop(),
                                          icon: const Icon(
                                            Icons.arrow_back,
                                            color: Colors.black,
                                          )),
                                      if (context
                                              .read<UserCubit>()
                                              .isLoggedIn &&
                                          loginUser?.id != widget.userId)
                                        PopupMenuButton(
                                            icon: const Icon(
                                              Icons.more_vert,
                                              color: Colors.black,
                                            ),
                                            itemBuilder: (context) {
                                              return [
                                                if (loginUser?.id !=
                                                    state.profileData?.id)
                                                  PopupMenuItem<int>(
                                                    value: 4,
                                                    child: Text(LocaleKeys
                                                        .report.localize),
                                                    onTap: () {
                                                      bottomSheet(
                                                          context: context,
                                                          widget: ReportView(
                                                            id: widget.userId,
                                                            categoryId:
                                                                '66b77e77bb35968b535dc944',
                                                          ));
                                                    },
                                                  ),
                                                if (loginUser?.id !=
                                                    state.profileData?.id)
                                                  PopupMenuItem<int>(
                                                    value: 5,
                                                    child: Text(state
                                                                .profileData
                                                                ?.isBlock ==
                                                            true
                                                        ? LocaleKeys
                                                            .unBlock.localize
                                                        : LocaleKeys
                                                            .block.localize),
                                                    onTap: () async {
                                                      // context.pop();
                                                      var result =
                                                          await controller
                                                              .blockUser(
                                                                  context:
                                                                      context,
                                                                  userId: widget
                                                                      .userId);
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
                                                if (loginUser?.id ==
                                                    state.profileData?.id)
                                                  PopupMenuItem<int>(
                                                    value: 5,
                                                    child: Text(LocaleKeys
                                                        .editProfile.localize),
                                                    onTap: () async {
                                                      await context.push(
                                                          Routes.EDITPROFILE);
                                                      controller.getUserProfile(
                                                          id: widget.userId);
                                                    },
                                                  )
                                              ];
                                            }),
                                      if (context
                                              .read<UserCubit>()
                                              .isLoggedIn &&
                                          loginUser?.id == widget.userId)
                                        IconButton(
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (_) =>
                                                      const SearchAppUsers());
                                            },
                                            icon: const Icon(
                                              Icons.search,
                                              color: Colors.black,
                                            )),
                                    ]))),
                        SliverToBoxAdapter(
                          child: Column(
                            children: [
                              _buildAccountCounter(
                                  context: context,
                                  user: state.profileData!,
                                  onFollow: () async {
                                    if (context.read<UserCubit>().isLoggedIn) {
                                      if (state.profileData?.isFollowed ==
                                          true) {
                                        var result =
                                            await controller.unFollowRequest(
                                                context: context,
                                                userId: state.profileData!.id);
                                        if (result == true) {
                                          state.profileData?.isFollowed = false;
                                          setState(() {});
                                        }
                                      } else {
                                        var result =
                                            await controller.followRequest(
                                                context: context,
                                                userId: state.profileData!.id);
                                        if (result == true) {
                                          state.profileData?.isFollowed = true;
                                          setState(() {});
                                        }
                                      }
                                    } else {
                                      context.push(Routes.LOGIN);
                                    }
                                  },
                                  onAddFriend: () async {
                                    // print("object");
                                    if (context.read<UserCubit>().isLoggedIn) {
                                      if (state.profileData?.areFriends ==
                                          true) {
                                      } else {
                                        if (state.profileData
                                                ?.sentFriendRequest ==
                                            true) {
                                          var result = await controller
                                              .removeFriendRequest(
                                                  context: context,
                                                  userId:
                                                      state.profileData!.id);
                                          if (result == true) {
                                            state.profileData
                                                ?.sentFriendRequest = false;
                                            setState(() {});
                                          }
                                        } else {
                                          var result =
                                              await controller.friendRequest(
                                                  context: context,
                                                  userId:
                                                      state.profileData!.id);
                                          if (result == true) {
                                            state.profileData
                                                ?.sentFriendRequest = true;
                                            setState(() {});
                                          }
                                        }
                                      }
                                    } else {
                                      context.push(Routes.LOGIN);
                                    }
                                  },
                                  onAcceptFriend: () async {
                                    bool result =
                                        await controller.acceptRejectFriend(
                                            params:
                                                AcceptRejectFriendRequestParams(
                                                    userId: widget.userId,
                                                    status: true));
                                    state.profileData?.isSenTRequest = false;
                                    state.profileData?.areFriends = true;
                                    state.profileData!.friendsCount =
                                        state.profileData!.friendsCount! + 1;
                                    print(state.profileData?.friendsCount);
                                    setState(() {});
                                    return result;
                                  },
                                  onRejectFriend: () async {
                                    bool result =
                                        await controller.acceptRejectFriend(
                                            params:
                                                AcceptRejectFriendRequestParams(
                                                    userId: widget.userId,
                                                    status: false));
                                    state.profileData?.isSenTRequest = false;
                                    setState(() {});
                                    return result;
                                  },
                                  onDeleteFriend: () async {
                                    bool result = await controller.deleteFriend(
                                        userId: widget.userId);
                                    state.profileData?.areFriends = false;
                                    state.profileData!.friendsCount =
                                        state.profileData!.friendsCount! - 1;
                                    print(state.profileData?.friendsCount);
                                    setState(() {});
                                    return result;
                                  },
                                  editProfile: () async {
                                    await context.push(Routes.EDITPROFILE);
                                    controller.getUserProfile(
                                        id: widget.userId);
                                  },
                                  selectImageGallary: () {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Wrap(
                                          children: <Widget>[
                                            ListTile(
                                              leading: const Icon(
                                                  Icons.photo_library),
                                              title: Text(
                                                  LocaleKeys.gallery.localize),
                                              onTap: () async {
                                                Navigator.pop(context);
                                                await controller.uploadPhoto(
                                                    isGallery: true);
                                                // Reload user data if needed
                                              },
                                            ),
                                            ListTile(
                                              leading:
                                                  const Icon(Icons.camera_alt),
                                              title: Text(
                                                  LocaleKeys.camera.localize),
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
                                  selectCoverImage: () {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Wrap(
                                          children: <Widget>[
                                            ListTile(
                                              leading: const Icon(
                                                  Icons.photo_library),
                                              title: Text(
                                                  LocaleKeys.gallery.localize),
                                              onTap: () async {
                                                Navigator.pop(context);
                                                await controller
                                                    .uploadCoverPhoto(
                                                        isGallery: true);
                                                // Reload user data if needed
                                              },
                                            ),
                                            ListTile(
                                              leading:
                                                  const Icon(Icons.camera_alt),
                                              title: Text(
                                                  LocaleKeys.camera.localize),
                                              onTap: () async {
                                                Navigator.pop(context);
                                                await controller
                                                    .uploadCoverPhoto(
                                                        isGallery: false);
                                                // Reload user data if needed
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }),
                              if (loginUser?.id == widget.userId)
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 6.h),
                                  child: AppButton(
                                    label: LocaleKeys.editProfile.localize,
                                    onPressed: () async {
                                      await context.push(Routes.EDITPROFILE);
                                      controller.getUserProfile(
                                          id: widget.userId);
                                    },
                                    color: Colors.white,
                                    backColor: AppColors.PRIMARY_COLOR,
                                  ),
                                )
                            ],
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: state.profileData?.isBlock == false
                              ? Column(
                                  children: [
                                    TabBar(
                                        labelStyle: Styles.mediumText(),
                                        isScrollable: true,
                                        tabAlignment: TabAlignment.center,
                                        onTap: (i) {
                                          controller.changeUserPage(i);
                                        },
                                        tabs: [
                                          Tab(
                                            text: LocaleKeys.posts.localize,
                                          ),
                                          Tab(
                                            text: LocaleKeys.Tweets.localize,
                                          ),
                                          Tab(
                                            text: LocaleKeys.reels.localize,
                                          ),
                                          if (context
                                                  .read<UserCubit>()
                                                  .state
                                                  .data
                                                  ?.id ==
                                              widget.userId)
                                            Tab(
                                              text: LocaleKeys
                                                  .savedReels.localize,
                                            ),
                                        ]),
                                    // _buildAccountPages(state.profileData!),
                                  ],
                                )
                              : Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 25.0),
                                    child: Label(
                                      text: LocaleKeys
                                          .youHaveBlockedThisUser.localize,
                                    ),
                                  ),
                                ),
                        ),
                        state.profilePage == 0 &&
                                state.profileData?.isBlock == false
                            ? UserPosts(
                                userData: state.profileData!,
                              )
                            : state.profilePage == 1 &&
                                    state.profileData?.isBlock == false
                                ? UserTweets(
                                    userData: state.profileData!,
                                  )
                                : state.profilePage == 2 &&
                                        state.profileData?.isBlock == false
                                    ? UserReels(
                                        userData: state.profileData!,
                                      )
                                    : state.profilePage == 2 &&
                                            state.profileData?.isBlock == false
                                        ? SavedReelsView(
                                            userData: state.profileData!)
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
      required Function onAcceptFriend,
      required Function onRejectFriend,
      required Function selectImageGallary,
      required Function selectCoverImage,
      required Function onDeleteFriend,
      required Function editProfile,
      required Function onAddFriend}) {
    final loginUser = context.read<UserCubit>().state.data;
    return BlocBuilder<SocialPostsCubit, SocialPostsState>(
        builder: (context, state) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 350.h,
            child: Stack(
              children: [
                Positioned.fill(
                    child: Column(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Stack(
                        alignment: AlignmentDirectional.bottomEnd,
                        children: [
                          state.newCover != null
                              ? InkWell(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) =>
                                            ImageDetailsScreen(
                                              image:
                                                  state.newCover?.file.path ??
                                                      '',
                                              fromPost: false,
                                              onRemoveImage: () {
                                                // controller
                                                //     .removePhoto(images![index]);
                                                context.pop();
                                              },
                                            ));
                                  },
                                  child: Image.file(
                                    File(state.newCover!.file.path),
                                    fit: BoxFit.fill,
                                    width: double.infinity,
                                  ),
                                )
                              : InkWell(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) =>
                                            ImageDetailsScreen(
                                              image: user.profileCover ?? '',
                                              fromPost: true,
                                              onRemoveImage: () {
                                                // controller
                                                //     .removePhoto(images![index]);
                                                context.pop();
                                              },
                                            ));
                                  },
                                  child: Image.network(
                                    user.profileCover!.isNotEmpty
                                        ? user.profileCover!
                                        : UIConst.socialImagePlaceHolder,
                                    fit: BoxFit.fill,
                                    width: double.infinity,
                                  ),
                                ),
                          if (loginUser?.id == user.id)
                            InkWell(
                              onTap: () {
                                selectCoverImage();
                              },
                              child: Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.PRIMARY_COLOR),
                                  child: const Icon(
                                    Icons.camera_alt_outlined,
                                    color: Colors.white,
                                  )),
                            )
                        ],
                      ),
                    ),
                    Expanded(
                        child: Padding(
                      padding:
                          const EdgeInsetsDirectional.only(top: 3.0, end: 10),
                      child: loginUser?.id == user.id
                          ? Container()
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 110,
                                  child: AppButton(
                                      // height: 120.h,
                                      width: kToolbarHeight * 1.5,
                                      backColor: user.isFollowed == true
                                          ? AppColors.PRIMARY_COLOR
                                          : null,
                                      label: user.isFollowed == true
                                          ? LocaleKeys.unFollow.localize
                                          : LocaleKeys.follow.localize,
                                      style: Styles.mediumText(
                                          color: Colors.white, fontSize: 24),
                                      onPressed: () {
                                        onFollow();
                                      }),
                                ),
                                const Sizer(),
                                (user.areFriends == true ||
                                        user.isSenTRequest == true)
                                    ? PopupMenuButton(
                                        // iconSize: 150,
                                        itemBuilder: (context) {
                                          return [
                                            if (user.isSenTRequest == true) ...[
                                              PopupMenuItem<int>(
                                                value: 0,
                                                child: Text(
                                                    LocaleKeys.Accept.localize),
                                                onTap: () => onAcceptFriend(),
                                              ),
                                              PopupMenuItem<int>(
                                                value: 1,
                                                child: Text(
                                                    LocaleKeys.reject.localize),
                                                onTap: () => onRejectFriend(),
                                              ),
                                            ],
                                            if (user.areFriends == true)
                                              PopupMenuItem<int>(
                                                value: 0,
                                                child: Text(LocaleKeys
                                                    .deleteFriend.localize),
                                                onTap: () => onDeleteFriend(),
                                              ),
                                          ];
                                        },
                                        child: Container(
                                            alignment: Alignment.center,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: AppColors.PRIMARY_COLOR,
                                            ),
                                            child: Text(
                                              user.isSenTRequest == true
                                                  ? LocaleKeys
                                                      .acceptRequest.localize
                                                  : user.areFriends == true
                                                      ? LocaleKeys
                                                          .friends.localize
                                                      : '',
                                              style: Styles.mediumText(
                                                  color: Colors.white),
                                            )))
                                    : SizedBox(
                                        width: 110,
                                        child: AppButton(
                                            // height: 80.h,
                                            padding: 5,
                                            backColor:
                                                user.sentFriendRequest == true
                                                    ? AppColors.PRIMARY_COLOR
                                                    : null,
                                            style: Styles.mediumText(
                                                color: Colors.white,
                                                fontSize: 24),
                                            label: user.isSenTRequest == true
                                                ? LocaleKeys
                                                    .acceptRequest.localize
                                                : user.areFriends == true
                                                    ? LocaleKeys
                                                        .friends.localize
                                                    : user.sentFriendRequest ==
                                                            true
                                                        ? LocaleKeys
                                                            .removeRequest
                                                            .localize
                                                        : LocaleKeys
                                                            .addFriend.localize,
                                            onPressed: () {
                                              onAddFriend();
                                            }),
                                      )
                              ],
                            ),
                    )),
                  ],
                )),
                PositionedDirectional(
                    bottom: 0,
                    start: 10,
                    child: Stack(
                      alignment: AlignmentDirectional.bottomEnd,
                      children: [
                        state.newImage != null
                            ? InkWell(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) => ImageDetailsScreen(
                                            image:
                                                state.newImage?.file.path ?? '',
                                            fromPost: false,
                                            onRemoveImage: () {
                                              // controller
                                              //     .removePhoto(images![index]);
                                              context.pop();
                                            },
                                          ));
                                },
                                child: CircleAvatar(
                                  radius: 60,
                                  child: CircleAvatar(
                                    radius: 60,
                                    backgroundColor: Colors.white,
                                    backgroundImage: FileImage(
                                        File(state.newImage!.file.path)),
                                  ),
                                ),
                              )
                            : InkWell(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) => ImageDetailsScreen(
                                            image: user.profilePicture ?? '',
                                            fromPost: true,
                                            onRemoveImage: () {
                                              // controller
                                              //     .removePhoto(images![index]);
                                              context.pop();
                                            },
                                          ));
                                },
                                child: ImageFromInternet(
                                  image: user.profilePicture ??
                                      UIConst.profilePlaceHolder,
                                  height: 140.h,
                                  width: 140,
                                  isCircle: true,
                                ),
                              ),
                        if (loginUser?.id == user.id)
                          InkWell(
                            onTap: () {
                              selectImageGallary();
                            },
                            child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.PRIMARY_COLOR),
                                child: const Icon(
                                  Icons.camera_alt_outlined,
                                  color: Colors.white,
                                )),
                          )
                      ],
                    ))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Sizer(),
                Row(
                  children: [
                    Expanded(
                      child: user.isDocument == true
                          ? Row(
                              children: [
                                Label(
                                    text: "${user.firstName} ${user.lastName}",
                                    style: Styles.headerText(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black)),
                                const Sizer(
                                  width: 5,
                                ),
                                const Icon(
                                  Icons.verified,
                                  color: AppColors.SECONDARY_COLOR,
                                  size: 20,
                                )
                              ],
                            )
                          : RichText(
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(children: [
                                TextSpan(
                                    text: "${user.firstName} ${user.lastName}",
                                    style: Styles.headerText(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black)),
                                if (user.job.isNotEmpty)
                                  TextSpan(
                                      text: '\t(${user.job})',
                                      style: Styles.headerText(
                                          color: Colors.black, fontSize: 26)),
                              ])),
                    ),
                    if (loginUser?.id != widget.userId)
                      PopupMenuButton(
                          child: Container(
                              width: 110,
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5.h),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: AppColors.SECONDARY_COLOR),
                              child: Text(
                                LocaleKeys.message.localize,
                                style: Styles.mediumText(color: Colors.white),
                              )),
                          itemBuilder: (context) {
                            return [
                              PopupMenuItem<int>(
                                value: 0,
                                child: Text(LocaleKeys.normal.localize),
                              ),
                              PopupMenuItem<int>(
                                value: 1,
                                child: Text(LocaleKeys.anonymous.localize),
                              ),
                            ];
                          },
                          onSelected: (value) {
                            !context.read<UserCubit>().isLoggedIn
                                ? context.push(Routes.LOGIN)
                                : context.push(Routes.CHAT);
                          }),
                  ],
                ),
                Sizer(
                  height: 4.h,
                ),
                Label(
                    text: '@${user.email.split('@')[0]}',
                    style: Styles.mediumText(color: Colors.grey)),
                Sizer(
                  height: 4.h,
                ),
                Row(
                  children: [
                    _buildCounter(
                      value: '${user.friendsCount} ',
                      label: LocaleKeys.friends.localize,
                    ),
                    const Sizer(),
                    _buildCounter(
                      value: '${user.followersCount} ',
                      label: LocaleKeys.follower.localize,
                    ),
                    const Sizer(),
                    _buildCounter(
                      value: '${user.followingCount} ',
                      label: LocaleKeys.following.localize,
                    ),
                  ],
                ),
                Sizer(height: 5.h),
                Label(
                    text: user.bio,
                    style: Styles.mediumText(color: Colors.black)),
                Sizer(height: 5.h),
                if (user.city.isNotEmpty ||
                    user.job.isNotEmpty ||
                    user.country.isNotEmpty ||
                    user.phone.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (user.city.isNotEmpty) ...[
                        Row(
                          children: [
                            const Icon(
                              Icons.home_rounded,
                              size: 24,
                            ),
                            const Sizer(
                              width: 5,
                            ),
                            Label(
                                text: LocaleKeys.livesIn.localize,
                                style: Styles.headerText(
                                    color: Colors.grey, fontSize: 30)),
                            Sizer(
                              height: 5.h,
                            ),
                            Expanded(
                              child: Label(
                                text: user.city,
                                style: Styles.headerText(
                                    color: Colors.black, fontSize: 30),
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                        Sizer(
                          height: 5.h,
                        ),
                      ],
                      if (user.country.isNotEmpty) ...[
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              size: 24,
                            ),
                            const Sizer(
                              width: 5,
                            ),
                            Label(
                                text: LocaleKeys.from.localize,
                                style: Styles.headerText(
                                    color: Colors.grey, fontSize: 30)),
                            Sizer(
                              height: 5.h,
                            ),
                            Expanded(
                              child: Label(
                                text: user.country,
                                style: Styles.headerText(
                                    color: Colors.black, fontSize: 30),
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                        Sizer(
                          height: 5.h,
                        ),
                      ],
                      if (user.job.isNotEmpty && user.isDocument == true) ...[
                        Row(
                          children: [
                            const Icon(
                              Icons.home_repair_service,
                              size: 24,
                            ),
                            const Sizer(
                              width: 5,
                            ),
                            Label(
                                text: LocaleKeys.work.localize,
                                style: Styles.headerText(
                                    color: Colors.grey, fontSize: 30)),
                            Sizer(
                              height: 5.h,
                            ),
                            Expanded(
                              child: Label(
                                text: user.job,
                                style: Styles.headerText(
                                    color: Colors.black, fontSize: 30),
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                        Sizer(
                          height: 5.h,
                        ),
                      ],
                      if (user.phone.isNotEmpty) ...[
                        Row(
                          children: [
                            const Icon(
                              Icons.phone_android,
                              size: 24,
                            ),
                            const Sizer(
                              width: 5,
                            ),
                            Label(
                                text: LocaleKeys.phone.localize,
                                style: Styles.headerText(
                                    color: Colors.grey, fontSize: 30)),
                            const Sizer(),
                            Expanded(
                              child: Label(
                                text: user.phone,
                                style: Styles.headerText(
                                    color: Colors.black, fontSize: 30),
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                        Sizer(
                          height: 5.h,
                        ),
                      ],
                      if (user.maritalStatus.isNotEmpty) ...[
                        Row(
                          children: [
                            const Icon(
                              Icons.favorite,
                              size: 24,
                            ),
                            const Sizer(
                              width: 5,
                            ),
                            Expanded(
                              child: Label(
                                text: user.maritalStatus,
                                style: Styles.headerText(
                                    color: Colors.black, fontSize: 30),
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                        Sizer(
                          height: 5.h,
                        ),
                      ],
                    ],
                  ),
              ],
            ),
          ),
        ],
      );
    });
  }

  Widget _buildCounter({required String value, required String label}) {
    return RichText(
        text: TextSpan(children: [
      TextSpan(
          text: value,
          style: Styles.mediumText(
              color: Colors.black, fontWeight: FontWeight.w500)),
      TextSpan(
          text: label,
          style: Styles.mediumText(
            color: Colors.grey,
          )),
    ]));
  }
}
