import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/profile_image.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/zego_uikit_prebuilt_live_streaming.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/user_profile_entity.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/cubit/social_posts_cubit.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/pages/media_view.dart';
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
                            padding: const EdgeInsetsDirectional.only(
                                top: 35, end: 10, start: 10),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      IconButton(
                                          onPressed: () => context.pop(),
                                          icon: const Icon(
                                            Icons.arrow_back,
                                            color: Colors.black,
                                          )),
                                      Label(
                                          text:
                                              '${state.profileData?.email.split('@')[0]}',
                                          style: Styles.mediumText(
                                              color: Colors.grey)),
                                      const Sizer(
                                        width: 4,
                                      ),
                                      const Icon(
                                        Icons.verified,
                                        size: 20,
                                        color: AppColors.PRIMARY_COLOR_DARK,
                                      )
                                    ],
                                  ),
                                  if (loginUser?.id != widget.userId)
                                    PopupMenuButton(
                                        icon: const Icon(
                                          Icons.more_vert,
                                          color: Colors.black,
                                        ),
                                        itemBuilder: (context) {
                                          return [
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
                                                child: Text(state.profileData
                                                            ?.isBlock ==
                                                        true
                                                    ? 'UnBlock'
                                                    : 'Block'),
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
                                                          'Blocked user successfully.');
                                                    } else {
                                                      state.profileData
                                                          ?.isBlock = false;
                                                      showSuccessMessage(
                                                          context,
                                                          'Unblocked user successfully.');
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
                                    labelPadding:
                                        const EdgeInsetsDirectional.symmetric(
                                            horizontal: 50),
                                    onTap: (i) {
                                      controller.changeUserPage(i);
                                    },
                                    tabs: [
                                      Tab(
                                        icon: Image.asset(Assets.userMedia,width: 30,),
                                      ),
                                      Tab(
                                        icon: Image.asset(Assets.userReels,width: 30,),
                                      ),
                                      if (context
                                              .read<UserCubit>()
                                              .state
                                              .data
                                              ?.id ==
                                          widget.userId)
                                        Tab(
                                          icon: Image.asset(Assets.savedReels,width: 30,),
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
    return BlocBuilder<SocialPostsCubit,SocialPostsState>(
      builder: (context,state) {
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
                      state.newImage !=null ? CircleAvatar(
                        radius: 40,
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.white,
                          backgroundImage: FileImage(File(state.newImage!.file.path)),
                        ),
                      ):ImageFromInternet(
                        image: user.profilePicture ?? UIConst.profilePlaceHolder,
                        height: 80,
                        width: 80,
                        isCircle: true,
                      ),
                      if(loginUser?.id==user.id)InkWell(
                        onTap: (){
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
                  const Sizer(
                    width: 20,
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildCounter(
                          value: '${user.instagramPosts ?? 0} ',
                          label: 'Post',
                        ),
                        const Sizer(),
                        _buildCounter(
                          value: '${user.friendsCount} ',
                          label: 'Friend',
                        ),
                        const Sizer(),
                        _buildCounter(
                          value: '${user.followersCount} ',
                          label: 'Follower',
                        ),
                        const Sizer(
                          width: 5,
                        ),
                        _buildCounter(
                          value: '${user.totalView} ',
                          label: 'View',
                        ),
                        const Sizer(
                          width: 5,
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
                            text:
                            "${user.firstName} ${user.lastName}",
                            style: Styles.headerText(fontWeight: FontWeight.w600,color: Colors.black)),
                        if(user.job.isNotEmpty)TextSpan(
                            text: '\t(${user.job})',
                            style: Styles.headerText(
                                color: Colors.black, fontSize: 26)),
                      ])),
                  const Sizer(
                    height: 4,
                  ),
                  Label(
                      text: '@ ${user.email.split('@')[0]}',
                      style: Styles.mediumText(color: Colors.grey)),
                  const Sizer(
                    height: 4,
                  ),
                  if (user.bio.isNotEmpty)
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
                              Expanded(
                                child: Label(
                                  text:
                                      '${user.country}${user.city.isNotEmpty ? ',' : ''} ${user.city}',
                                  style: Styles.headerText(
                                      color: Colors.black, fontSize: 26),
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
                              Expanded(
                                child: Label(
                                  text: user.phone,
                                  style: Styles.headerText(
                                      color: Colors.black, fontSize: 26),
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
                              Expanded(
                                child: Label(
                                  text: user.job,
                                  style: Styles.headerText(
                                      color: Colors.black, fontSize: 26),
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
            if (user.followers != null && user.followers!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 4
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: user.followers!.length == 1
                          ? 25
                          : user.followers!.length == 2
                              ? 40
                              : 60,
                      height: 32,
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
                                style: Styles.mediumText(color: Colors.black)),
                            if(user.followers!.length>2)TextSpan(
                                text: '\tand ${user.followers!.length-2} others',
                                style: Styles.mediumText(color: Colors.grey)),
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
                              height: 42,
                              backColor: user.isFollowed == true
                                  ? AppColors.PRIMARY_COLOR
                                  : null,
                              label:
                                  user.isFollowed == true ? 'unFollow' : 'Follow',
                              style: Styles.mediumText(color: Colors.white),
                              onPressed: () {
                                onFollow();
                              }),
                        ),
                        const Sizer(),
                        Expanded(
                          child: PopupMenuButton(
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
                                context.push(Routes.CHAT);
                              }),
                        ),
                        const Sizer(),
                        InkWell(
                          onTap: showHideSuggestPeople,
                          child: Container(
                            height: 42,
                            width: 42,
                            margin: const EdgeInsets.all(0),
                            padding: const EdgeInsets.symmetric(horizontal: 0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.zR),
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
                  if (loginUser?.id == widget.userId) ...[
                    const Sizer(),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: getUserProfile,
                            child: Container(
                              height: 42,
                              margin: const EdgeInsets.all(0),
                              padding: const EdgeInsets.symmetric(horizontal: 0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.zR),
                                color: AppColors.PRIMARY_COLOR,
                              ),
                              child: Center(
                                child: Label(
                                  text: 'Edit Profile',
                                  style: Styles.mediumText(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Sizer(),
                        Expanded(
                          child: AppButton(
                              height: 42,
                              backColor: AppColors.PRIMARY_COLOR,
                              label: 'Share Profile',
                              style: Styles.mediumText(color: Colors.white),
                              onPressed: () {
                                onFollow();
                              }),
                        ),
                        const Sizer(),
                        InkWell(
                          onTap: showHideSuggestPeople,
                          child: Container(
                            height: 42,
                            width: 42,
                            margin: const EdgeInsets.all(0),
                            padding: const EdgeInsets.symmetric(horizontal: 0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.zR),
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
      }
    );
  }

  Widget _buildCounter({required String value, required String label}) {
    return Column(
      children: [
        Text(
          value,
          style: Styles.headerText(),
        ),
        const Sizer(
          height: 2,
        ),
        Text(
          label,
          style: Styles.mediumText(color: Colors.grey),
        ),
      ],
    );
  }
}
