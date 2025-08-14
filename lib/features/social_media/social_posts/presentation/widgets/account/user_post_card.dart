import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../../../common/functions/global/upload_file.dart';
import '../../../../../../core/enums/base_status_enum.dart';
import '../../../../../../core/error/failure.dart';
import '../../../../../../core/extensions/context_extension.dart';
import '../../../../../../core/extensions/string_extension.dart';
import '../../../../../../core/localization/locale_keys.g.dart';
import '../../../../../../core/messages/messages.dart';
import '../../../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';
import '../../../../create_post/presentation/widgets/image_details.dart';
import '../../../domain/entities/main_post_entity.dart';
import '../../../domain/entities/post_entity.dart';
import '../../../domain/usecases/add_reply_usecase.dart';
import '../../../domain/usecases/post_comment_usecase.dart';
import '../../cubit/social_posts_cubit.dart';
import '../../pages/post_details_page.dart';
import '../../pages/show_post_images.dart';
import '../facebook_widgets/build_reactions_buttons.dart';
import '../facebook_widgets/image_from_internet.dart';
import '../../../../../../common/widgets/stateless/labels/read_more_label.dart';
import '../posts/build_with_users.dart';
import '../../../../twitter/presentation/widgets/report_view.dart';
import '../../../../../../service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../common/widgets/dialogs/show_bottom_sheet.dart';
import '../../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../../common/widgets/stateless/buttons/iconAppButton.dart';
import '../../../../../../common/widgets/stateless/buttons/text_button.dart';
import '../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../res/assets/assets.dart';
import '../../../../../../res/style/app_colors.dart';
import '../../../../../../res/style/const.dart';
import '../../../../../../res/style/styles.dart';
import '../../../../../../routes/routes.dart';
import '../../../domain/usecases/post_react_usecase.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../common/widgets/dialogs/please_login_dialog.dart';
import '../../../../../../helpers/manage_vibration.dart';

class UserPostCard extends StatefulWidget {
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
  final Function(int) onSelectReact;

  const UserPostCard(
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
      required this.index,
      required this.onSelectReact});

  @override
  State<UserPostCard> createState() => _UserPostCardState();
}

class _UserPostCardState extends State<UserPostCard> {
  final pageController = PageController();

  // bool showReacts = false;
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
      var myPost = widget.post;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAccountHeader(context: context, post: myPost),
          // Label(text: myPost.mainPost?.content??''),
          _buildContentWidget(
              content: myPost.content ?? '',
              backgroundColor: myPost.backgroundColor,
              images: myPost.images ?? []),
          GestureDetector(
            onTap: () {
      ManageVibration.vibrate();
              if (widget.post.isShared == true) {
                bottomSheet(
                    context: context,
                    isScrollControlled: true,
                    widget: BlocProvider.value(
                      value: serviceLocator<SocialPostsCubit>()
                        ..loadPostDetails(context, widget.post.mainPost!.id),
                      child: PostDetailsPage(
                        comments: const [],
                        postId: widget.post.mainPost!.id,
                        deletePost: (String postId) => controller.deletePost(
                            context: context, postId: postId),
                        hidePost: (String postId) => controller.hidePost(
                            context: context, postId: postId),
                        onAddComment: (PostCommentParams params) => controller
                            .onPostComment(params: params, from: 'details'),
                        onReact: (params) =>
                            controller.onReact(params: params, from: 'posts'),
                        showPostComments: (postId) {},
                        showPostDetails: (PostEntity post) {},
                        // post: controller.feedPagingController.itemList![index],

                        onCommentReply: (ReplyOnCommentParams params) {
                          return controller.replyOnComment(
                            params: ReplyOnCommentParams(
                                postId: params.postId,
                                content: params.content,
                                commentId: params.commentId),
                            from: 'details',
                          );
                        },
                        onDeleteComment: (String id) async {
                          return await controller.deleteComment(
                              context: context,
                              commentId: id,
                              postId: widget.post.mainPost!.id,
                              from: 'feed');
                          // print(result);
                        },
                        onDeleteReply: (String id) async {
                          return await controller.deleteComment(
                              context: context,
                              commentId: id,
                              postId: widget.post.mainPost!.id,
                              from: 'feed');
                        },
                        onEditComment: (PostCommentParams params) async {
                          var result =
                              await controller.editComment(params: params);
                          return result;
                        },
                      ),
                    ));
              }
            },
            child: Container(
              margin: EdgeInsets.all(myPost.isShared == true ? 10 : 0),
              padding: EdgeInsets.all(myPost.isShared == true ? 10 : 0),
              decoration: BoxDecoration(
                  border: myPost.isShared == true ? Border.all() : null),
              child: Column(
                children: [
                  if (myPost.type != 'advertisement' &&
                      myPost.isShared == true &&
                      myPost.mainPost != null) ...[
                    if (myPost.type != 'advertisement' &&
                        myPost.isShared == true)
                      _buildMainAccountHeader(
                          context: context, post: myPost.mainPost!),
                    if (myPost.isShared == true)
                      _buildContentWidget(
                        content: myPost.mainPost?.content ?? '',
                        backgroundColor: null,
                        images: myPost.mainPost?.images ?? [],
                      ),
                  ],
                  if (myPost.type != 'advertisement' &&
                      myPost.isShared == true &&
                      myPost.mainPost == null)
                    SizedBox(
                      width: double.infinity,
                      height: 100.h,
                      child: Center(
                        child: Row(
                          children: [
                            const Sizer(),
                            const Icon(
                              Icons.lock,
                              // color: Colors.black,
                            ),
                            const Sizer(),
                            Label(
                              text: LocaleKeys
                                  .thisContentIsNotAvailableNow.localize,
                              style: Styles.headerText(
                                  //  color: Colors.black,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    )
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              children: [
                if (myPost.likesCount != 0)
                  _buildCounterWidget(
                      value: myPost.likesCount??0, image: Assets.like),
                if (myPost.hahaCount != 0)
                  _buildCounterWidget(
                      value: myPost.hahaCount??0, image: Assets.haha),
                if (myPost.loveCount != 0)
                  _buildCounterWidget(
                      value: myPost.loveCount??0, image: Assets.heart),
                if (myPost.wowCount != 0)
                  _buildCounterWidget(
                      value: myPost.wowCount??0, image: Assets.wow),
                if (myPost.sadCount != 0)
                  _buildCounterWidget(
                      value: myPost.sadCount??0, image: Assets.sad),
                if (myPost.angryCount != 0)
                  _buildCounterWidget(
                      value: myPost.angryCount??0, image: Assets.angry),
                const Spacer(),
                InkWell(
                  onTap: () {
      ManageVibration.vibrate();
                    if (context.read<UserCubit>().isLoggedIn) {
                      widget.showPostComments(myPost.id);
                    } else {                                  return pleaseLoginDialog(context);

                    // context.push(Routes.LOGIN);
                    }
                  },
                  child: Row(
                    children: [
                      Label(
                        text: myPost.commentsCount.toString(),
                        style: Styles.mediumText(),
                      ),
                      const Sizer(
                        width: 5,
                      ),
                      Label(
                        text: LocaleKeys.comments.localize,
                        style: Styles.mediumText(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            color: AppColors.LIGHT_GRAY_COLOR,
          ),
          SizedBox(
            height: kToolbarHeight * .6,
            child: Row(
              children: [
                Expanded(
                  child: context.read<UserCubit>().isLoggedIn
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            BuildReactionsButtons(
                                post: widget.post, from: 'userPosts'),
                            Sizer(
                              width: 20.w,
                            ),
                            Label(
                                text: LocaleKeys.like.localize,
                                style: Styles.mediumText(color: Colors.grey)),
                          ],
                        )
                      : _buildReactionPlaceHolder(
                          icon: FontAwesomeIcons.thumbsUp,
                          label: LocaleKeys.like.localize,
                          onTap: () {
      ManageVibration.vibrate();
                            if (context.read<UserCubit>().isLoggedIn) {
                              return widget.showPostComments(myPost.id);
                            } else {
                              return pleaseLoginDialog(context);

                              // context.push(Routes.LOGIN);
                            }
                          }),
                ),
                if (widget.from == 'posts')
                  Expanded(
                    child: _buildReactionPlaceHolder(
                        icon: FontAwesomeIcons.message,
                        label: LocaleKeys.comment.localize,
                        onTap: () {
      ManageVibration.vibrate();
                          if (context.read<UserCubit>().isLoggedIn) {
                            return widget.showPostComments(myPost.id);
                          } else {                                  return pleaseLoginDialog(context);

                            // context.push(Routes.LOGIN);
                          }
                        }),
                  ),
                Expanded(
                  child: _buildReactionPlaceHolder(
                      icon: FontAwesomeIcons.share,
                      label: LocaleKeys.share.localize,
                      onTap: () async {
      ManageVibration.vibrate();
                        if (context.read<UserCubit>().isLoggedIn) {
                          var result = await controller.onShare(
                              postId: myPost.isShared == true
                                  ? myPost.mainPost!.id
                                  : myPost.id);
                          if (result == true) {
                            showSuccessMessage(context,
                                LocaleKeys.postSharedSuccessfully.localize);
                          }
                        } else {                                  return pleaseLoginDialog(context);

                          // context.push(Routes.LOGIN);
                        }
                      }),
                ),
              ],
            ),
          ),
        ],
      );
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
          height: 40.h,
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

  Widget _buildPostOptions(
      {required bool fromDetails, required PostEntity post}) {
    return SizedBox(
      height: 250.h,
      child: Column(
        children: [
          listTile(
              icon: Icons.delete,
              title: LocaleKeys.deletePost.localize,
              subTitle: LocaleKeys.youWillDeletePost.localize,
              onTap: () {
      ManageVibration.vibrate();
                widget.deletePost(post.id);
                if (fromDetails == true) {
                  context.pop();
                }
              }),
          listTile(
              icon: Icons.visibility_off,
              title: LocaleKeys.hidePost.localize,
              subTitle: LocaleKeys.youWillHidePost.localize,
              onTap: () {
      ManageVibration.vibrate();
                widget.hidePost(post.id);
                if (fromDetails == true) {
                  context.pop();
                }
              }),
        ],
      ),
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
    final user = context.read<UserCubit>().state.data;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
      ManageVibration.vibrate();
                  if (user?.id != post.user.id) {
                    context.push(Routes.OTHERSACCOUNT, extra: post.user.id);
                  }
                },
                child: ImageFromInternet(
                  image: post.user.image ?? UIConst.profilePlaceHolder,
                  height: 100.h,
                  width: 100.w,
                  isCircle: true,
                ),
              ),
              const Sizer(),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
      ManageVibration.vibrate();
                        if (user?.id != post.user.id) {
                          context.push(Routes.OTHERSACCOUNT,
                              extra: post.user.id);
                        }
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Sizer(
                            height: 30.h,
                          ),
                          TextAppButton(
                              label:
                                  '${post.user.firstName} ${post.user.lastName}',
                              style: Styles.mediumText(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w700),
                              onPressed: () {
      ManageVibration.vibrate();
                                if (user?.id != post.user.id) {
                                  context.push(Routes.OTHERSACCOUNT,
                                      extra: post.user.id);
                                }
                              }),
                          // RichText(
                          //     text: TextSpan(children: [
                          //   TextSpan(
                          //       text: post.sinceTime,
                          //       style: Styles.mediumText(color: Colors.grey)),
                          //   const TextSpan(text: '  '),
                          //   WidgetSpan(
                          //       child: Icon(
                          //     Icons.group,
                          //     size: 30.sp,
                          //     color: Colors.grey,
                          //   ))
                          // ])),
                        ],
                      ),
                    ),
                    Expanded(child: _buildActivityFeelingWidget(post)),
                  ],
                ),
              ),
              if (post.user.id != user?.id &&
                  context.read<UserCubit>().isLoggedIn)
                Padding(
                  padding: EdgeInsets.all(16.w),
                  child: IconAppButton(
                    onPressed: () {
      ManageVibration.vibrate();
                      bottomSheet(
                          context: context,
                          widget: ReportView(
                            id: widget.post.id,
                            categoryId: '66a3583454e6e337915514db',
                          ));
                    },
                    icon: Icons.report,
                    color: AppColors.SECONDARY_COLOR,
                  ),
                ),
              const Sizer(),
              if (post.user.id == user?.id) ...[
                Padding(
                  padding: EdgeInsets.all(16.w),
                  child: IconAppButton(
                    icon: Icons.clear,
                    onPressed: () {
      ManageVibration.vibrate();
                      bottomSheet(
                          context: context,
                          widget: _buildPostOptions(
                              fromDetails: widget.from == 'details',
                              post: post));
                    },
                  ),
                ),
              ]
            ],
          ),
          if (post.location != null)
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  size: 40.sp,
                ),
                Expanded(
                    child: Label(
                  text: post.location?.place ?? '',
                  style: Styles.mediumText(),
                ))
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildMainAccountHeader({
    required BuildContext context,
    required MainPostEntity post,
  }) {
    final user = context.read<UserCubit>().state.data;
    return Row(
      children: [
        InkWell(
          onTap: () {
      ManageVibration.vibrate();
            if (user?.id != post.user.id) {
              context.push(Routes.OTHERSACCOUNT, extra: post.user.id);
            }
          },
          child: ImageFromInternet(
            image: post.user.image ?? UIConst.profilePlaceHolder,
            height: 80.h,
            width: 80.w,
            isCircle: true,
          ),
        ),
        const Sizer(),
        Expanded(
            child: Row(
          children: [
            InkWell(
              onTap: () {
      ManageVibration.vibrate();
                if (user?.id != post.user.id) {
                  context.push(Routes.OTHERSACCOUNT, extra: post.user.id);
                }
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextAppButton(
                      label: '${post.user.firstName} ${post.user.lastName}',
                      style: Styles.mediumText(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w700),
                      onPressed: () {
      ManageVibration.vibrate();
                        if (user?.id != post.user.id) {
                          context.push(Routes.OTHERSACCOUNT,
                              extra: post.user.id);
                        }
                      }),
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: post.sinceTime,
                        style: Styles.mediumText(color: Colors.grey)),
                    const TextSpan(text: '  '),
                    WidgetSpan(
                        child: Icon(
                      Icons.group,
                      size: 30.sp,
                      color: Colors.grey,
                    ))
                  ])),
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
    print("contentadasd$content");
    return (backgroundColor != null && backgroundColor != '#FFFFFFFF') &&
            images!.isEmpty
        ? Container(
            width: double.infinity,
            height: 260.h,
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(vertical: 10.h),
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.h),
            color: images.isEmpty
                ? Color(
                    int.parse(backgroundColor.substring(1), radix: 16),
                  )
                : Colors.white,
            child: ReadMoreLabel(
              text: content,
              textAlign: _isArabic(content) ? TextAlign.right : TextAlign.left,
              style: Styles.headerText(
                  //  color: Colors.black,
                  color: context.isDarkMode ? Colors.white : Colors.black,
                  fontSize: 60.sp,
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
                if (content.isNotEmpty)
                  ReadMoreLabel(
                    text: content,
                    style: Styles.mediumText(
                      fontSize: 70.sp,
                      color: context.isDarkMode ? Colors.white : Colors.black,
                    ),
                    textAlign:
                        _isArabic(content) ? TextAlign.right : TextAlign.left,
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
                        itemBuilder: (context, index) => InkWell(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              hoverColor: Colors.transparent,
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
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FaIcon(
            icon,
            size: 20,
            color: Colors.grey,
          ),
          const Sizer(),
          Label(text: label, style: Styles.mediumText(color: Colors.grey))
        ],
      );
    } else {
      return InkWell(
        onTap: () => onTap(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(
              icon,
              size: 40.sp,
              color: Colors.grey,
            ),
            const Sizer(),
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
              '${LocaleKeys.feeling.localize} ${post.feeling?.name ?? ''}, ${post.activity?.name ?? ''}',
              style: Styles.mediumText(),
            ),
            const SizedBox(width: 10),
          ],
          if (post.users.isNotEmpty)
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8.0, // Space between children
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
                        builder: (_) => BuildWithUsers(users: post.users),
                      );
                    },
                    child: Label(
                      text: '+${post.users.length - 1}',
                      style: Styles.headerText(),
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }

  bool _isArabic(String text) {
    final RegExp arabicRegex = RegExp(r'^[\u0600-\u06FF\s]+$');
    return arabicRegex.hasMatch(text);
  }
}