import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../common/functions/global/upload_file.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../../../core/enums/base_status_enum.dart';
import '../../../../../../core/error/failure.dart';
import '../../../../../../core/extensions/string_extension.dart';
import '../../../../../../core/localization/locale_keys.g.dart';
import '../../../../../../core/messages/messages.dart';
import '../../../../../../core/widget/clickable_widget.dart';
import '../../../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';
import '../../../../create_post/presentation/widgets/image_details.dart';
import '../../../domain/entities/main_post_entity.dart';
import '../../../domain/entities/post_entity.dart';
import '../../cubit/social_posts_cubit.dart';
import '../../pages/show_post_images.dart';
import '../facebook_widgets/facebook_google_maps.dart';
import '../facebook_widgets/image_from_internet.dart';
import 'build_with_users.dart';
import '../../../../../../common/widgets/stateless/labels/read_more_label.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../../common/widgets/stateless/buttons/text_button.dart';
import '../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../core/widget/custom_scaffold.dart';
import '../../../../../../res/style/app_colors.dart';
import '../../../../../../res/style/const.dart';
import '../../../../../../res/style/styles.dart';
import '../../../../../../routes/routes.dart';
import '../../../domain/usecases/post_react_usecase.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../common/widgets/dialogs/please_login_dialog.dart';
import '../../../../../../helpers/manage_vibration.dart';

class FacebookGlobalPostCard extends StatefulWidget {
  final PostEntity post;
  final int index;
  final String from;
  final bool? fromProfile;
  final Function(PostReactParams) onReact;
  final Function(String id) onShare;
  final Function(String) showPostComments;
  final Function(PostEntity) showPostDetails;
  final Function(String) deletePost;
  final Function(String) hidePost;
  final bool showOptions;
  final bool isMyPost;

  const FacebookGlobalPostCard(
      {super.key,
      required this.post,
      required this.onReact,
      this.showOptions = true,
      this.isMyPost = false,
      this.fromProfile = false,
      required this.deletePost,
      required this.hidePost,
      required this.showPostDetails,
      required this.showPostComments,
      required this.onShare,
      required this.from,
      required this.index});

  @override
  State<FacebookGlobalPostCard> createState() => _FacebookGlobalPostCardState();
}

class _FacebookGlobalPostCardState extends State<FacebookGlobalPostCard> {
  final pageController = PageController();
  bool isLiked = false;
  bool hide = false;

  @override
  void initState() {
    pageController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialPostsCubit, SocialPostsState>(
        listener: (context, state) {
      if (state.status == StateStatus.error) {
        showErrorMessage(
          context,
          getFailureMessage(
            state.failure ?? UnknownFailure(''),
            context,
          ),
        );
      }
    }, builder: (context, state) {
      final controller = context.read<SocialPostsCubit>();
     return Container();
      // if (widget.from == 'posts') {
      //   if (controller
      //           .globalFeedPagingController.itemList?[widget.index].type ==
      //       'advertisement') {
      //     return FacebookAdvertisementCard(
      //       post: controller.globalFeedPagingController.itemList![widget.index],
      //     );
      //   } else if (controller
      //           .globalFeedPagingController.itemList![widget.index].type ==
      //       'twitter_post') {
      //     return FacebookTweetCard(
      //       post: controller.globalFeedPagingController.itemList![widget.index],
      //     );
      //   } else {
      //     var myPost = widget.from == 'details'
      //         ? widget.post
      //         : controller.globalFeedPagingController.itemList![widget.index];
      //     return ClickableWidget(
      //       onTap: (widget.from == 'posts' && widget.post.isShared == true)
      //           ? () => widget.showPostDetails(controller
      //               .globalFeedPagingController.itemList![widget.index])
      //           : null,
      //       child: Column(
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         children: [
      //           _buildAccountHeader(context: context, post: myPost),
      //           if (myPost.content!.isNotEmpty)
      //             _buildContentWidget(
      //                 content: myPost.content ?? '',
      //                 backgroundColor: myPost.backgroundColor,
      //                 images: myPost.images ?? []),
      //           Container(
      //             margin: EdgeInsets.all(myPost.isShared == true ? 10 : 0),
      //             padding: EdgeInsets.all(
      //                 (myPost.isShared == true && myPost.mainPost != null)
      //                     ? 10
      //                     : 0),
      //             decoration: BoxDecoration(
      //                 border: myPost.isShared == true ? Border.all() : null),
      //             child: Column(
      //               children: [
      //                 if (myPost.type != 'advertisement' &&
      //                     myPost.isShared == true &&
      //                     myPost.mainPost != null) ...[
      //                   if (myPost.type != 'advertisement' &&
      //                       myPost.isShared == true)
      //                     _buildMainAccountHeader(
      //                         context: context, post: myPost.mainPost!),
      //                   if (myPost.isShared == true)
      //                     _buildContentWidget(
      //                         content: myPost.mainPost?.content ?? '',
      //                         backgroundColor: null,
      //                         images: myPost.mainPost?.images ?? []),
      //                 ],
      //                 if (myPost.type != 'advertisement' &&
      //                     myPost.isShared == true &&
      //                     myPost.mainPost == null)
      //                   SizedBox(
      //                     width: double.infinity,
      //                     height: 100.h,
      //                     child: Center(
      //                       child: Row(
      //                         children: [
      //                           const Sizer(),
      //                           const Icon(
      //                             Icons.lock,
      //                             color: Colors.black,
      //                           ),
      //                           const Sizer(),
      //                           Label(
      //                             text: LocaleKeys
      //                                 .thisContentIsNotAvailableNow.localize,
      //                             style: Styles.headerText(
      //                               color: Colors.black,
      //                             ),
      //                           ),
      //                         ],
      //                       ),
      //                     ),
      //                   )
      //               ],
      //             ),
      //           ),
      //           Row(
      //             children: [
      //               if (myPost.likesCount != 0)
      //                 _buildCounterWidget(
      //                     value: myPost.likesCount, image: Assets.like),
      //               if (myPost.hahaCount != 0)
      //                 _buildCounterWidget(
      //                     value: myPost.hahaCount, image: Assets.haha),
      //               if (myPost.loveCount != 0)
      //                 _buildCounterWidget(
      //                     value: myPost.loveCount, image: Assets.heart),
      //               if (myPost.wowCount != 0)
      //                 _buildCounterWidget(
      //                     value: myPost.wowCount, image: Assets.wow),
      //               if (myPost.sadCount != 0)
      //                 _buildCounterWidget(
      //                     value: myPost.sadCount, image: Assets.sad),
      //               if (myPost.angryCount != 0)
      //                 _buildCounterWidget(
      //                     value: myPost.angryCount, image: Assets.angry),
      //               const Spacer(),
      //               ClickableWidget(
      //                 onTap: () {
      ManageVibration.vibrate();
      //                   context.push(Routes.LOGIN);
      //                 },
      //                 child: Row(
      //                   children: [
      //                     Label(
      //                       text: myPost.commentsCount.toString(),
      //                       style: Styles.mediumText(),
      //                     ),
      //                     const Sizer(
      //                       width: 5,
      //                     ),
      //                     Label(
      //                       text: LocaleKeys.comments.localize,
      //                       style: Styles.mediumText(),
      //                     )
      //                   ],
      //                 ),
      //               ),
      //             ],
      //           ),
      //           const Divider(
      //             color: AppColors.LIGHT_GRAY_COLOR,
      //           ),
      //           SizedBox(
      //             height: kToolbarHeight * .95,
      //             child: Row(
      //               children: [
      //                 Expanded(
      //                   child: ClickableWidget(
      //                     onTap: () {
      ManageVibration.vibrate();
      //                       context.push(Routes.LOGIN);
      //                     },
      //                     child: Column(
      //                       mainAxisAlignment: MainAxisAlignment.center,
      //                       children: [
      //                         const FaIcon(
      //                           Icons.thumb_up_alt_outlined,
      //                           color: Colors.grey,
      //                           size: 18,
      //                         ),
      //                         if (widget.from == 'posts') ...[
      //                           Label(
      //                               text: LocaleKeys.like.localize,
      //                               style:
      //                                   Styles.mediumText(color: Colors.grey)),
      //                         ],
      //                       ],
      //                     ),
      //                   ),
      //                 ),
      //                 Expanded(
      //                   child: _buildReactionPlaceHolder(
      //                       icon: FontAwesomeIcons.message,
      //                       label: LocaleKeys.comment.localize,
      //                       onTap: () {
      ManageVibration.vibrate();
      //                         context.push(Routes.LOGIN);
      //                       }),
      //                 ),
      //                 Expanded(
      //                   child: _buildReactionPlaceHolder(
      //                       icon: FontAwesomeIcons.share,
      //                       label: LocaleKeys.share.localize,
      //                       onTap: () async {
      ManageVibration.vibrate();
      //                         context.push(Routes.LOGIN);
      //                       }),
      //                 ),
      //               ],
      //             ),
      //           ),
      //         ],
      //       ),
      //     );
      //   }
      // } else
      // {
      //   var myPost = widget.from == 'details'
      //       ? widget.post
      //       : controller.globalFeedPagingController.itemList![widget.index];
      //   return ClickableWidget(
      //     onTap: (widget.from == 'posts' && widget.post.isShared == true)
      //         ? () => widget.showPostDetails(
      //             controller.globalFeedPagingController.itemList![widget.index])
      //         : null,
      //     child: Column(
      //       crossAxisAlignment: CrossAxisAlignment.start,
      //       children: [
      //         if (myPost.type != 'advertisement')
      //           _buildAccountHeader(context: context, post: myPost),
      //         _buildContentWidget(
      //             content: myPost.content ?? '',
      //             backgroundColor: myPost.backgroundColor,
      //             images: myPost.images),
      //         Row(
      //           children: [
      //             if (myPost.likesCount != 0)
      //               _buildCounterWidget(
      //                   value: myPost.likesCount, image: Assets.like),
      //             if (myPost.hahaCount != 0)
      //               _buildCounterWidget(
      //                   value: myPost.hahaCount, image: Assets.haha),
      //             if (myPost.loveCount != 0)
      //               _buildCounterWidget(
      //                   value: myPost.loveCount, image: Assets.heart),
      //             if (myPost.wowCount != 0)
      //               _buildCounterWidget(
      //                   value: myPost.wowCount, image: Assets.wow),
      //             if (myPost.sadCount != 0)
      //               _buildCounterWidget(
      //                   value: myPost.sadCount, image: Assets.sad),
      //             if (myPost.angryCount != 0)
      //               _buildCounterWidget(
      //                   value: myPost.angryCount, image: Assets.angry),
      //             const Spacer(),
      //             ClickableWidget(
      //               onTap: () {
      ManageVibration.vibrate();
      //                 context.push(Routes.LOGIN);
      //               },
      //               child: Row(
      //                 children: [
      //                   Label(
      //                     text: myPost.commentsCount.toString(),
      //                     style: Styles.mediumText(),
      //                   ),
      //                   const Sizer(
      //                     width: 5,
      //                   ),
      //                   Label(
      //                     text: LocaleKeys.comments.localize,
      //                     style: Styles.mediumText(),
      //                   )
      //                 ],
      //               ),
      //             ),
      //           ],
      //         ),
      //         const Divider(
      //           color: AppColors.LIGHT_GRAY_COLOR,
      //         ),
      //         SizedBox(
      //           height: kToolbarHeight * .95,
      //           child: Row(
      //             children: [
      //               Expanded(
      //                   child: BuildReactionsButtons(
      //                 post: myPost,
      //                 from: 'posts',
      //               )),
      //               if (widget.from == 'posts')
      //                 Expanded(
      //                   child: _buildReactionPlaceHolder(
      //                       icon: FontAwesomeIcons.message,
      //                       label: LocaleKeys.comment.localize,
      //                       onTap: () {
      ManageVibration.vibrate();
      //                         context.push(Routes.LOGIN);
      //                       }),
      //                 ),
      //               Expanded(
      //                 child: _buildReactionPlaceHolder(
      //                     icon: FontAwesomeIcons.share,
      //                     label: LocaleKeys.share.localize,
      //                     onTap: () async {
      ManageVibration.vibrate();
      //                       context.push(Routes.LOGIN);
      //                     }),
      //               ),
      //             ],
      //           ),
      //         ),
      //       ],
      //     ),
      //   );
      // }
    });
  }

  Widget _buildCounterWidget({
    required num value,
    required String image,
  }) {
    return Row(
      children: [
        Image.asset(
          image,
          height: 20.h,
        ),
        const Sizer(
          width: 5,
        ),
        Label(
          text: value.toString(),
          style: Styles.mediumText(),
        )
      ],
    );
  }

  Widget listTile(
      {required IconData icon,
      required String title,
      required String subTitle,
      required Function onTap}) {
    return ListTile(
      title: Label(text: title),
      onTap: () {
      ManageVibration.vibrate();
        onTap();
        context.pop();
      },
      leading: Icon(
        icon,
        color: Colors.black,
      ),
      subtitle: Label(
        text: subTitle,
        style: Styles.mediumText(color: Colors.grey),
      ),
    );
  }

  Widget _buildAccountHeader({
    required BuildContext context,
    required PostEntity post,
  }) {
    print("post.user${post.user}");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClickableWidget(
                onTap: () {
      ManageVibration.vibrate();
                  if (widget.fromProfile == false &&
                      context.read<UserCubit>().isLoggedIn) {
                    context.push(Routes.OTHERSACCOUNT, extra: post.user.id);
                  } else {
                    return pleaseLoginDialog(context);

                    // context.push(Routes.LOGIN);
                  }
                },
                child: ImageFromInternet(
                  image: (post.user.image != null) ? post.user.image??'' : '',
                  height: 45,
                  width: 45,
                  isCircle: true,
                )

                // CircleAvatar(
                //   backgroundColor: Colors.white,
                //   backgroundImage: NetworkImage((post.user.image!=null)
                //       ? post.user.image??''
                //       : UIConst.profilePlaceHolder),
                // ),
                ),
            const Sizer(),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClickableWidget(
                    onTap: () {
      ManageVibration.vibrate();
                      if (widget.fromProfile == false &&
                          context.read<UserCubit>().isLoggedIn) {
                        context.push(Routes.OTHERSACCOUNT, extra: post.user.id);
                      } else {
                        return pleaseLoginDialog(context);

                        // context.push(Routes.LOGIN);
                      }
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextAppButton(
                            label: post.user.userName??'',
                            onPressed: () {
      ManageVibration.vibrate();
                              if (widget.fromProfile == false &&
                                  context.read<UserCubit>().isLoggedIn) {
                                context.push(Routes.OTHERSACCOUNT,
                                    extra: post.user.id);
                              } else {
                                return pleaseLoginDialog(context);

                                // context.push(Routes.LOGIN);
                              }
                            }),
                        RichText(
                            text: TextSpan(children: [
                          // TextSpan(
                          //     text: post.sinceTime,
                          //     style: Styles.mediumText(color: Colors.grey)),
                          const WidgetSpan(
                              child: Icon(
                            Icons.group,
                            size: 14,
                            color: Colors.grey,
                          ))
                        ])),
                      ],
                    ),
                  ),
                  Expanded(child: _buildActivityFeelingWidget(post)),
                ],
              ),
            ),
          ],
        ),
        if (post.location != null)
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 40.0),
            child: ClickableWidget(
              onTap: () {
      ManageVibration.vibrate();
                showDialog(
                    context: context,
                    builder: (_) => CustomScaffold(
                          body: FacebookUserOnMap(
                            location: post.location!,
                          ),
                        ));
              },
              child: Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    size: 20,
                  ),
                  Expanded(
                      child: Label(
                    text: post.location?.place ?? '',
                    style: Styles.mediumText(fontSize: 14),
                  ))
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildMainAccountHeader({
    required BuildContext context,
    required MainPostEntity post,
  }) {
    return Row(
      children: [
        ClickableWidget(
          onTap: () {
      ManageVibration.vibrate();
            if (widget.fromProfile == false) {
              context.push(Routes.OTHERSACCOUNT, extra: post.user.id);
            }
          },
          child: CircleAvatar(
            backgroundColor: Colors.white,
            backgroundImage: NetworkImage((post.user.image.isNotEmpty)
                ? post.user.image
                : UIConst.profilePlaceHolder),
          ),
        ),
        const Sizer(),
        Expanded(
            child: Row(
          children: [
            ClickableWidget(
              onTap: () {
      ManageVibration.vibrate();
                if (widget.fromProfile == false) {
                  context.push(Routes.OTHERSACCOUNT, extra: post.user.id);
                }
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextAppButton(
                      style: TextStyle(color: Theme.of(context).primaryColor),
                      label: post.user.firstName,
                      onPressed: () {
      ManageVibration.vibrate();
                        if (widget.fromProfile == false) {
                          context.push(Routes.OTHERSACCOUNT,
                              extra: post.user.id);
                        }
                      }),
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: post.sinceTime,
                        style: Styles.mediumText(color: Colors.grey)),
                    const WidgetSpan(
                        child: Icon(
                      Icons.group,
                      size: 14,
                      color: Colors.grey,
                    ))
                  ]))
                ],
              ),
            ),
            // _buildActivityFeelingWidget(post),
          ],
        )),
      ],
    );
  }

  Widget _buildContentWidget(
      {String? backgroundColor,
      required String content,
      List<String>? images}) {
    return (backgroundColor != null && backgroundColor != '#FFFFFFFF') &&
            images!.isEmpty
        ? Container(
            width: double.infinity,
            height: 220.h,
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(vertical: 10.h),
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.h),
            color: images.isEmpty
                ? Color(int.parse(backgroundColor.substring(1), radix: 16))
                : Colors.white,
            child: ReadMoreLabel(
              text: content,
              style: Styles.headerText(
                  color: Theme.of(context).primaryColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
          )
        : Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(vertical: 10.h),
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ReadMoreLabel(
                  text: content,
                  style:
                      Styles.headerText(color: Theme.of(context).primaryColor),
                ),
                SizedBox(
                  height: 10.h,
                ),
                if ((images?.isNotEmpty ?? false))
                  SizedBox(
                    child: GridView.builder(
                        padding: const EdgeInsets.all(10),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: images!.length == 1 ? 1 : 2),
                        itemCount: images.length < 4 ? images.length : 4,
                        itemBuilder: (context, index) => ClickableWidget(
                              onTap: () {
      ManageVibration.vibrate();
                                if (index != 3 ||
                                    (index == 3 && images.length == 4)) {
                                  showDialog(
                                      context: context,
                                      builder: (context) => ImageDetailsScreen(
                                            image: images[index],
                                            fromPost: true,
                                            onRemoveImage: () {
                                              // controller
                                              //     .removePhoto(images![index]);
                                              context.pop();
                                            },
                                          ));
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return ShowPostsImages(
                                          images: images,
                                          onRemoveImage:
                                              (UploadFileEntity image) {
                                            // controller.removePhoto(image);
                                          },
                                        );
                                      });
                                }
                              },
                              child: Stack(
                                children: [
                                  Stack(
                                    children: [
                                      ImageFromInternet(
                                        image: images[index],
                                        defaultLogo: true,
                                      ),
                                      if (index == 3 && images.length > 4)
                                        Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.black.withOpacity(0.5),
                                          ),
                                          child: Center(
                                            child: Label(
                                              text: "+${images.length - 4}",
                                              style: Styles.headerText(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            )),
                  ),
              ],
            ),
          );
  }

  Widget _buildReactionPlaceHolder({
    required IconData icon,
    required String label,
    Function? onTap,
  }) {
    if (onTap == null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FaIcon(
            icon,
            color: AppColors.GREY_DARK_COLOR,
            size: 20,
          ),
          Label(text: label, style: Styles.mediumText(color: Colors.grey))
        ],
      );
    } else {
      return ClickableWidget(
        onTap: () => onTap(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(
              icon,
              color: AppColors.GREY_DARK_COLOR,
              size: 20,
            ),
            // Sizer(),
            Label(text: label, style: Styles.mediumText(color: Colors.grey))
          ],
        ),
      );
    }
  }

  Widget _buildActivityFeelingWidget(PostEntity post) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (post.feeling != null || post.activity != null) ...[
            Text(
              '${LocaleKeys.feeling.localize} ${post.feeling != null ? post.feeling?.name ?? '' : ''}${post.activity != null ? ', ${post.activity?.name}' : ''}',
              style: Styles.mediumText(),
            ),
            const SizedBox(
              width: 10,
            ),
          ],
          if (post.users.isNotEmpty)
            Row(
              children: [
                Label(
                  text: '${LocaleKeys.withKey.localize}: ',
                  style: Styles.mediumText(),
                ),
                GestureDetector(
                  onTap: () {
      ManageVibration.vibrate();
                    context.push(Routes.OTHERSACCOUNT,
                        extra: post.users[0].id);
                  },
                  child: Label(
                    text:
                        "${post.users[0].firstName} ${post.users[0].lastName} ",
                    style:
                        Styles.mediumText(decoration: TextDecoration.underline),
                  ),
                ),
                if (post.users.length > 1)
                  GestureDetector(
                      onTap: () {
      ManageVibration.vibrate();
                        showDialog(
                            context: context,
                            builder: (_) => BuildWithUsers(
                                  users: post.users,
                                ));
                      },
                      child: Label(
                        text: '+${post.users.length - 1}',
                        style: Styles.headerText(),
                      ))
              ],
            ),
        ],
      ),
    );
  }
}