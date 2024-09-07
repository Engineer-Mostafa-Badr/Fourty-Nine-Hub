import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/user_profile_entity.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/accept_reject_friend_request_use_case.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/cubit/social_posts_cubit.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/pages/api_error_page.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/pages/saved_reels_view.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/account/user_posts.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/account/user_reels.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/account/user_tweets.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/widgets/report_view.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../res/style/const.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../routes/routes.dart';
import 'package:go_router/go_router.dart';
import '../../../../../res/style/app_colors.dart';

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
              :state.status== StateStatus.error? ApiErrorPage(message:  getFailureMessage(
            state.failure ??  UnknownFailure(''),
            context,
          ),):CustomScrollView(
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
                                  if(context.read<UserCubit>().isLoggedIn&&loginUser?.id!=widget.userId)PopupMenuButton(
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
                                              child: const Text("Report"),
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
                                              child: Text(
                                                  state.profileData?.isBlock ==
                                                          true
                                                      ? 'UnBlock'
                                                      : 'Block'),
                                              onTap: () async {
                                                // context.pop();
                                                var result =
                                                    await controller.blockUser(
                                                        context: context,
                                                        userId: widget.userId);
                                                print("result:$result");
                                                if (result == true) {
                                                  print("object");
                                                  if (state.profileData
                                                          ?.isBlock ==
                                                      false) {
                                                    state.profileData?.isBlock =
                                                        true;
                                                    showSuccessMessage(context,
                                                        'Blocked user successfully.');
                                                  } else {
                                                    state.profileData?.isBlock =
                                                        false;
                                                    showSuccessMessage(context,
                                                        'Unblocked user successfully.');
                                                  }
                                                }
                                              },
                                            ),
                                          if (loginUser?.id ==
                                              state.profileData?.id)
                                            PopupMenuItem<int>(
                                              value: 5,
                                              child: const Text('Edit Profile'),
                                              onTap: () async {
                                                await context
                                                    .push(Routes.EDITPROFILE);
                                                controller.getUserProfile(
                                                    id: widget.userId);
                                              },
                                            )
                                        ];
                                      }),

                                  if(context.read<UserCubit>().isLoggedIn&&loginUser?.id==widget.userId)IconButton(
                                      onPressed: () {},
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
                                if(context.read<UserCubit>().isLoggedIn){
                                  if (state.profileData?.isFollowed == true) {
                                    var result =
                                        await controller.unFollowRequest(
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
                                }else{
                                  context.push(Routes.LOGIN);
                                }
                              },
                              onAddFriend: () async {
                                // print("object");
                                if(context.read<UserCubit>().isLoggedIn){
                                  if (state.profileData?.areFriends == true) {
                                  } else {
                                    if (state.profileData?.sentFriendRequest ==
                                        true) {
                                      var result =
                                          await controller.removeFriendRequest(
                                              context: context,
                                              userId: state.profileData!.id);
                                      if (result == true) {
                                        state.profileData?.sentFriendRequest =
                                            false;
                                        setState(() {});
                                      }
                                    } else {
                                      var result =
                                          await controller.friendRequest(
                                              context: context,
                                              userId: state.profileData!.id);
                                      if (result == true) {
                                        state.profileData?.sentFriendRequest =
                                            true;
                                        setState(() {});
                                      }
                                    }
                                  }
                                }else{
                                  context.push(Routes.LOGIN);
                                }
                              },
                              onAcceptFriend: () async {
                                bool result =
                                    await controller.acceptRejectFriend(
                                        params: AcceptRejectFriendRequestParams(
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
                                        params: AcceptRejectFriendRequestParams(
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
                              }, editProfile: ()async{
                            await context
                                .push(Routes.EDITPROFILE);
                            controller.getUserProfile(
                                id: widget.userId);
                          }, selectImageGallary: (){
                            showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return Wrap(
                                  children: <Widget>[
                                    ListTile(
                                      leading: const Icon(Icons.photo_library),
                                      title: const Text('Gallery'),
                                      onTap: () async {
                                        Navigator.pop(context);
                                        await controller.uploadPhoto(isGallery: true);
                                        // Reload user data if needed
                                      },
                                    ),
                                    ListTile(
                                      leading: const Icon(Icons.camera_alt),
                                      title: const Text('Camera'),
                                      onTap: () async {
                                        Navigator.pop(context);
                                        await controller.uploadPhoto(isGallery: false);
                                        // Reload user data if needed
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          }, selectCoverImage: (){
                            showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return Wrap(
                                  children: <Widget>[
                                    ListTile(
                                      leading: const Icon(Icons.photo_library),
                                      title: const Text('Gallery'),
                                      onTap: () async {
                                        Navigator.pop(context);
                                        await controller.uploadCoverPhoto(isGallery: true);
                                        // Reload user data if needed
                                      },
                                    ),
                                    ListTile(
                                      leading: const Icon(Icons.camera_alt),
                                      title: const Text('Camera'),
                                      onTap: () async {
                                        Navigator.pop(context);
                                        await controller.uploadCoverPhoto(isGallery: false);
                                        // Reload user data if needed
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          }),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 6),
                            child: AppButton(label: 'Edit Profile', onPressed: ()async{
                              await context
                                  .push(Routes.EDITPROFILE);
                              controller.getUserProfile(
                                  id: widget.userId);
                            },color: Colors.white,backColor: AppColors.PRIMARY_COLOR,),
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
                                      const Tab(
                                        text: 'Posts',
                                      ),
                                      const Tab(
                                        text: 'Tweets',
                                      ),
                                      const Tab(
                                        text: 'Reels',
                                      ),
                                      if (context
                                              .read<UserCubit>()
                                              .state
                                              .data
                                              ?.id ==
                                          widget.userId)
                                        const Tab(
                                          text: 'Saved Reels',
                                        ),
                                    ]),
                                // _buildAccountPages(state.profileData!),
                              ],
                            )
                          : const Center(
                              child: Padding(
                                padding: EdgeInsets.only(top: 25.0),
                                child: Label(
                                  text: 'You have blocked this user.',
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
    return BlocBuilder<SocialPostsCubit,SocialPostsState>(
      builder: (context,state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 250,
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
                            state.newCover!=null?Image.file(
                              File(state.newCover!.file.path),
                              fit: BoxFit.fill,
                              width: double.infinity,
                            ):Image.network(
                              user.profileCover!.isNotEmpty
                                  ? user.profileCover!
                                  : UIConst.socialImagePlaceHolder,
                              fit: BoxFit.fill,
                              width: double.infinity,
                            ),
                            if(loginUser?.id==user.id)InkWell(
                              onTap: (){
                                selectCoverImage();
                              },
                              child: Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.PRIMARY_COLOR
                                  ),
                                  child: const Icon(Icons.camera_alt_outlined,color: Colors.white,)),
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
                                  AppButton(
                                      height: 120,
                                      width: kToolbarHeight * 1.5,
                                      backColor: user.isFollowed == true
                                          ? AppColors.PRIMARY_COLOR
                                          : null,
                                      label: user.isFollowed == true
                                          ? 'unFollow'
                                          : 'Follow',
                                      style: Styles.mediumText(color: Colors.white),
                                      onPressed: () {
                                        onFollow();
                                      }),
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
                                                  child: const Text("Accept"),
                                                  onTap: () => onAcceptFriend(),
                                                ),
                                                PopupMenuItem<int>(
                                                  value: 1,
                                                  child: const Text("Reject"),
                                                  onTap: () => onRejectFriend(),
                                                ),
                                              ],
                                              if (user.areFriends == true)
                                                PopupMenuItem<int>(
                                                  value: 0,
                                                  child:
                                                      const Text("Delete Friend"),
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
                                                  color: AppColors.PRIMARY_COLOR),
                                              child: Text(
                                                user.isSenTRequest == true
                                                    ? 'Accept Request'
                                                    : user.areFriends == true
                                                        ? 'Friends'
                                                        : '',
                                                style: Styles.mediumText(
                                                    color: Colors.white),
                                              )))
                                      : AppButton(
                                          height: 110,
                                          padding: 5,
                                          backColor: user.sentFriendRequest == true
                                              ? AppColors.PRIMARY_COLOR
                                              : null,
                                          style: Styles.mediumText(
                                              color: Colors.white),
                                          label: user.isSenTRequest == true
                                              ? 'Accept Request'
                                              : user.areFriends == true
                                                  ? 'Friends'
                                                  : user.sentFriendRequest == true
                                                      ? 'Remove Request'
                                                      : 'Add Friend',
                                          onPressed: () {
                                            onAddFriend();
                                          })
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
                          state.newImage !=null ? CircleAvatar(
                            radius: 60,
                            child: CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.white,
                              backgroundImage: FileImage(File(state.newImage!.file.path)),
                            ),
                          ):CircleAvatar(
                            radius: 60,
                            child: CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.white,
                              backgroundImage: CachedNetworkImageProvider(
                                  user.profilePicture ?? UIConst.profilePlaceHolder),
                            ),
                          ),
                          if(loginUser?.id==user.id)InkWell(
                            onTap: (){
                              selectImageGallary();
                            },
                            child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.PRIMARY_COLOR
                                ),
                                child: const Icon(Icons.camera_alt_outlined,color: Colors.white,)),
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Label(
                              text: "${user.firstName} ${user.lastName}",
                              style:
                                  Styles.headerText(fontWeight: FontWeight.w600)),
                          const Sizer(
                            width: 5,
                          ),
                          const Icon(
                            Icons.verified,
                            size: 20,
                            color: AppColors.SECONDARY_COLOR,
                          )
                        ],
                      ),
                      if (loginUser?.id != widget.userId)
                        PopupMenuButton(
                            child: Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: AppColors.SECONDARY_COLOR),
                                child: Text(
                                  'Message',
                                  style: Styles.mediumText(color: Colors.white),
                                )),
                            itemBuilder: (context) {
                              return const [
                                PopupMenuItem<int>(
                                  value: 0,
                                  child: Text("Normal"),
                                ),
                                PopupMenuItem<int>(
                                  value: 1,
                                  child: Text("Anonymous"),
                                ),
                              ];
                            },
                            onSelected: (value) {
                              !context.read<UserCubit>().isLoggedIn?context.push(Routes.LOGIN):context.push(Routes.CHAT);
                            }),
                    ],
                  ),
                  const Sizer(
                    height: 4,
                  ),
                  Label(
                      text: '@${user.email.split('@')[0]}',
                      style: Styles.mediumText(color: Colors.grey)),
                  const Sizer(
                    height: 4,
                  ),
                  Row(
                    children: [
                      _buildCounter(
                        value: '${user.friendsCount} ',
                        label: 'Friends',
                      ),
                      const Sizer(),
                      _buildCounter(
                        value: '${user.followersCount} ',
                        label: 'Follower',
                      ),
                      const Sizer(),
                      _buildCounter(
                        value: '${user.followingCount} ',
                        label: 'Following',
                      ),
                    ],
                  ),
                  const Sizer(
                    height: 5,
                  ),
                  Label(
                      text: user.bio,
                      style: Styles.mediumText(color: Colors.black)),
                  const Sizer(
                    height: 5,
                  ),
                  if (user.city.isNotEmpty ||
                      user.job.isNotEmpty ||
                      user.country.isNotEmpty ||
                      user.phone.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (user.city.isNotEmpty || user.country.isNotEmpty) ...[
                          Row(
                            children: [
                              Label(
                                  text: 'From',
                                  style: Styles.headerText(
                                      color: Colors.grey, fontSize: 30)),
                              const Sizer(
                                height: 5,
                              ),
                              Expanded(
                                child: Label(
                                  text:
                                      '${user.country}${user.city.isNotEmpty ? ',' : ''} ${user.city}',
                                  style: Styles.headerText(
                                      color: Colors.black, fontSize: 30),
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                          const Sizer(
                            height: 5,
                          ),
                        ],
                        if (user.phone.isNotEmpty) ...[
                          Row(
                            children: [
                              Label(
                                  text: 'Phone',
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
                          const Sizer(
                            height: 5,
                          ),
                        ],
                        if (user.job.isNotEmpty)
                          Row(
                            children: [
                              Label(
                                  text: 'Work',
                                  style: Styles.headerText(
                                      color: Colors.grey, fontSize: 30)),
                              const Sizer(),
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
                      ],
                    ),
                ],
              ),
            ),
          ],
        );
      }
    );
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
