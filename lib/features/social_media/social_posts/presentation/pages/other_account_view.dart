import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/user_profile_entity.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/cubit/social_posts_cubit.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/account/user_posts.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/account/user_reels.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/account/user_tweets.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/widgets/report_view.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/appbar/nested_appbar.dart';
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
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: BlocBuilder<SocialPostsCubit, SocialPostsState>(
            builder: (context, state) {
          final controller = context.read<SocialPostsCubit>();
          final loginUser = context.read<UserCubit>().state.data;
          return state.status == StateStatus.loading
              ? const Center(
                  child: CupertinoActivityIndicator(),
                )
              : NestedAppbar(
            scrollController: ScrollController(),
                  appBars: [
                    SliverAppBar(
                      floating: true,
                      expandedHeight: kToolbarHeight * 5,
                      automaticallyImplyLeading: false,
                      backgroundColor: Colors.white,
                      flexibleSpace: _buildAccountCounter(
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
                          onAddFriend: () async {
                            // print("object");
                            if (state.profileData?.areFriends == true) {
                            } else {
                              if (state.profileData?.sentFriendRequest ==
                                  true) {
                                var result =
                                    await controller.removeFriendRequest(
                                        context: context,
                                        userId: state.profileData!.id);
                                if (result == true) {
                                  state.profileData?.sentFriendRequest = false;
                                  setState(() {});
                                }
                              } else {
                                var result = await controller.friendRequest(
                                    context: context,
                                    userId: state.profileData!.id);
                                if (result == true) {
                                  state.profileData?.sentFriendRequest = true;
                                  setState(() {});
                                }
                              }
                            }
                          }),
                      iconTheme: const IconThemeData(color: Colors.white),
                      leading: IconButton(
                          onPressed: () => context.pop(),
                          icon: const Icon(Icons.arrow_back)),
                      actions: [
                        // IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
                        PopupMenuButton(
                          icon: const Icon(
                            Icons.more_vert,
                            color: Colors.white,
                          ),
                          itemBuilder: (context) {
                            return [
                              if (loginUser?.id != state.profileData?.id)
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
                              if (loginUser?.id != state.profileData?.id)
                                PopupMenuItem<int>(
                                  value: 5,
                                  child: Text(state.profileData?.isBlock == true
                                      ? 'UnBlock'
                                      : 'Block'),
                                  onTap: () async {
                                    // context.pop();
                                    var result = await controller.blockUser(
                                        context: context,
                                        userId: widget.userId);
                                    print("result:${result}");
                                    if (result == true) {
                                      print("object");
                                      if (state.profileData?.isBlock == false) {
                                        state.profileData?.isBlock = true;
                                        showSuccessMessage(context,
                                            'Blocked user successfully.');
                                      } else {
                                        state.profileData?.isBlock = false;
                                        showSuccessMessage(context,
                                            'Unblocked user successfully.');
                                      }
                                    }
                                  },
                                ),
                              if (loginUser?.id == state.profileData?.id)
                                PopupMenuItem<int>(
                                  value: 5,
                                  child: const Text('Edit Profile'),
                                  onTap: () async {
                                    context.push(Routes.EDITPROFILE);
                                  },
                                )
                            ];
                          },
                        ),
                      ],
                    ),
                    if (state.profileData?.isBlock == false)
                      SliverAppBar(
                        automaticallyImplyLeading: false,
                        floating: false,
                        backgroundColor: Colors.white,
                        pinned: true,
                        title: TabBar(
                            labelStyle: Styles.mediumText(),
                            isScrollable: true,
                            tabAlignment: TabAlignment.center,
                            tabs: const [
                              Tab(
                                text: 'Posts',
                              ),
                              Tab(
                                text: 'Tweets',
                              ),
                              Tab(
                                text: 'Reels',
                              ),
                              // Tab(
                              //   text: 'Media',
                              // ),
                            ]),
                      ),
                  ],
                  body: state.profileData?.isBlock == false
                      ? _buildAccountPages(state.profileData!)
                      : const Center(
                          child: Label(
                            text: 'You have blocked this user.',
                          ),
                        ),
                );
        }),
      ),
    );
  }

  Widget _buildAccountCounter(
      {required BuildContext context,
      required UserProfileEntity user,
      required Function onFollow,
      required Function onAddFriend}) {
    final loginUser = context.read<UserCubit>().state.data;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            child: Stack(
          children: [
            Positioned.fill(
                child: Column(
              children: [
                Expanded(
                    flex: 4,
                    child: Image.network(
                      user.profileCover!.isNotEmpty
                          ? user.profileCover!
                          : UIConst.socialImagePlaceHolder,
                      fit: BoxFit.fill,
                      width: double.infinity,
                    )),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsetsDirectional.only(top: 3.0,end: 10),
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
                                    },

                                  child:  Container(
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                      decoration:  BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                          color: AppColors.SECONDARY_COLOR),
                                      child: Text(
                                        user.areFriends == true
                                            ? 'Friends'
                                            : user.isSenTRequest == false
                                            ? 'Accept Request'
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
                                    style:
                                        Styles.mediumText(color: Colors.white),
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
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: AppColors.SECONDARY_COLOR,
                  child: CircleAvatar(
                    radius: 58,
                    backgroundColor: Colors.white,
                    backgroundImage: NetworkImage(user.profilePicture ?? ''),
                  ),
                ))
          ],
        )),
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
                  PopupMenuButton(
                      child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(10),
                          decoration:  BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                              color: AppColors.SECONDARY_COLOR),
                          child: Text('Message',style: Styles.mediumText(
                              color: Colors.white),)),
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
                ],
              ),
              Label(
                  text: '@${user.email.split('@')[0]}',
                  style: Styles.mediumText(color: Colors.grey)),
              const Sizer(),
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
            ],
          ),
        )
      ],
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

  Widget _buildAccountPages(UserProfileEntity userData) {
    return TabBarView(children: [
      UserPosts(
        userData: userData,
      ),
      UserTweets(userData: userData),

      // const HighLightsSection(),

      UserReels(userData: userData),
      // const MediaSection(),
    ]);
  }
}
