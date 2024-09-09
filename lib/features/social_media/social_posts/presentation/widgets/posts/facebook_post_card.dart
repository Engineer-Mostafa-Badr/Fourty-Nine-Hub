import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/functions/global/upload_file.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/social_media/create_post/presentation/widgets/image_details.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/main_post_entity.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/post_entity.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/cubit/social_posts_cubit.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/pages/show_post_images.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/build_reactions_buttons.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/facebook_google_maps.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/posts/build_with_users.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/posts/facebook_advirtesement_card.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/posts/facebook_tweet_card.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/read_more_label.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/widgets/report_view.dart';
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

class FacebookPostCard extends StatefulWidget {
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

  const FacebookPostCard(
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
  State<FacebookPostCard> createState() => _FacebookPostCardState();
}

class _FacebookPostCardState extends State<FacebookPostCard> {
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
            state.failure ??  UnknownFailure(''),
            context,
          ),
        );
      }
    }, builder: (context, state) {
      final controller = context.read<SocialPostsCubit>();
      if (widget.from == 'posts') {
        if (controller.feedPagingController.itemList?[widget.index].type ==
            'advertisement') {
          return FacebookAdvertisementCard(
            post: controller.feedPagingController.itemList![widget.index],
          );
        } else if (controller
                .feedPagingController.itemList![widget.index].type ==
            'twitter_post') {
          return FacebookTweetCard(
            post: controller.feedPagingController.itemList![widget.index],
          );
        } else {
          var myPost = widget.from == 'details'
              ? widget.post
              : controller.feedPagingController.itemList![widget.index];
          return InkWell(
            onTap: (widget.from == 'posts' && widget.post.isShared == true)
                ? () => widget.showPostDetails(
                    controller.feedPagingController.itemList![widget.index])
                : null,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAccountHeader(context: context, post: myPost),
                if (myPost.content!.isNotEmpty)
                  _buildContentWidget(
                      content: myPost.content ?? '',
                      backgroundColor: myPost.backgroundColor,
                      images: myPost.images ?? []),
                Container(
                  margin: EdgeInsets.all(myPost.isShared == true ? 10 : 0),
                  padding: EdgeInsets.all(
                      (myPost.isShared == true && myPost.mainPost != null)
                          ? 10
                          : 0),
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
                              images: myPost.mainPost?.images ?? []),
                      ],
                      if (myPost.type != 'advertisement' &&
                          myPost.isShared == true &&
                          myPost.mainPost == null)
                        SizedBox(
                          width: double.infinity,
                          height: 100,
                          child: Center(
                            child: Row(
                              children: [
                                const Sizer(),
                                const Icon(
                                  Icons.lock,
                                  color: Colors.black,
                                ),
                                const Sizer(),
                                Label(
                                  text: "This content is not available now.",
                                  style: Styles.headerText(
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8,right: 8),
                  child: Row(
                    children: [
                      if (myPost.likesCount != 0)
                        _buildCounterWidget(
                            value: myPost.likesCount!, image: Assets.like),
                      if (myPost.hahaCount != 0)
                        _buildCounterWidget(
                            value: myPost.hahaCount!, image: Assets.haha),
                      if (myPost.loveCount != 0)
                        _buildCounterWidget(
                            value: myPost.loveCount!, image: Assets.heart),
                      if (myPost.wowCount != 0)
                        _buildCounterWidget(
                            value: myPost.wowCount!, image: Assets.wow),
                      if (myPost.sadCount != 0)
                        _buildCounterWidget(
                            value: myPost.sadCount!, image: Assets.sad),
                      if (myPost.angryCount != 0)
                        _buildCounterWidget(
                            value: myPost.angryCount!, image: Assets.angry),
                      const Spacer(),
                      InkWell(
                        onTap: () => widget.showPostComments(myPost.id),
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
                              text: 'Comments',
                              style: Styles.mediumText(),
                            )
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
                  height: kToolbarHeight * .95,
                  child: Row(
                    children: [
                      Expanded(
                          child: BuildReactionsButtons(
                        post: myPost,
                        from: widget.from,
                      )),
                      if (widget.from == 'posts')
                        Expanded(
                          child: _buildReactionPlaceHolder(
                              icon: FontAwesomeIcons.message,
                              label: 'Comment',
                              image: Assets.comment,
                              onTap: () => widget.showPostComments(myPost.id)),
                        ),
                      Expanded(
                        child: _buildReactionPlaceHolder(
                            label: 'Share',
                            isImage: true,
                            image: Assets.facebookShare,
                            onTap: () async {
                              var result = await controller.onShare(
                                  postId: myPost.isShared == true
                                      ? myPost.mainPost!.id
                                      : myPost.id);
                              if (result == true) {
                                showSuccessMessage(
                                    context, "Post shared successfully");
                              }
                            }),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      } else {
        var myPost = widget.from == 'details'
            ? widget.post
            : controller.feedPagingController.itemList![widget.index];
        return InkWell(
          onTap: (widget.from == 'posts' && widget.post.isShared == true)
              ? () => widget.showPostDetails(
                  controller.feedPagingController.itemList![widget.index])
              : null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (myPost.type != 'advertisement')
                _buildAccountHeader(context: context, post: myPost),
              _buildContentWidget(
                  content: myPost.content ?? '',
                  backgroundColor: myPost.backgroundColor,
                  images: myPost.images),
              Padding(
                padding: const EdgeInsets.only(left: 8,right: 8),
                child: Row(
                  children: [
                    if (myPost.likesCount != 0)
                      _buildCounterWidget(
                          value: myPost.likesCount!, image: Assets.like),
                    if (myPost.hahaCount != 0)
                      _buildCounterWidget(
                          value: myPost.hahaCount!, image: Assets.haha),
                    if (myPost.loveCount != 0)
                      _buildCounterWidget(
                          value: myPost.loveCount!, image: Assets.heart),
                    if (myPost.wowCount != 0)
                      _buildCounterWidget(
                          value: myPost.wowCount!, image: Assets.wow),
                    if (myPost.sadCount != 0)
                      _buildCounterWidget(
                          value: myPost.sadCount!, image: Assets.sad),
                    if (myPost.angryCount != 0)
                      _buildCounterWidget(
                          value: myPost.angryCount!, image: Assets.angry),
                    const Spacer(),
                    InkWell(
                      onTap: () => widget.showPostComments(myPost.id),
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
                            text: 'Comments',
                            style: Styles.mediumText(),
                          )
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
                height: kToolbarHeight * .95,
                child: Row(
                  children: [
                    Expanded(
                        child: BuildReactionsButtons(
                      post: myPost,
                      from: 'posts',
                    )),
                    if (widget.from == 'posts')
                      Expanded(
                        child: _buildReactionPlaceHolder(
                            icon: FontAwesomeIcons.message,
                            image: Assets.comment,
                            label: 'Comment',
                            onTap: () => widget.showPostComments(myPost.id)),
                      ),
                    Expanded(
                      child: _buildReactionPlaceHolder(
                          icon: FontAwesomeIcons.share,
                          label: 'Share',
                          isImage: true,
                          image: Assets.facebookShare,
                          onTap: () async {
                            var result = await controller.onShare(
                                postId: myPost.isShared == true
                                    ? myPost.mainPost!.id
                                    : myPost.id);
                            if (result == true) {
                              showSuccessMessage(
                                  context, "Post shared successfully");
                            }
                          }),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }
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
          height: 20,
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
      height: widget.isMyPost ? 150 : 150,
      child: Column(
        children: [
          if (!widget.isMyPost)listTile(
              icon: Icons.report,
              iconColor: Colors.red,
              title: 'Report post',
              subTitle: 'Your well reports this post.',
              onTap: () async{
                Future.delayed(const Duration(milliseconds: 200), () {
                  bottomSheet(
                    context: context,
                    widget: ReportView(id: widget.post.id,
                      categoryId: '66a3583454e6e337915514db',)
                  );
                });

              }),
          if (widget.isMyPost)
            listTile(
                icon: Icons.delete,
                title: 'Delete Post',
                subTitle:
                    'Your post will be deleted, and you cannot get it again',
                onTap: () {
                  widget.deletePost(post.id);
                  if (fromDetails == true) {
                    context.pop();
                  }
                }),
          listTile(
              icon: Icons.visibility_off,
              title: 'Hide Post',
              subTitle: 'Your post will be hidden, you can get it again',
              onTap: () {
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
      {required IconData icon, Color? iconColor,
      required String title,
      required String subTitle,
      required Function onTap}) {
    return ListTile(
      title: Label(text: title),
      onTap: () {
        onTap();
        context.pop();
      },
      leading: Icon(
        icon,
        color: iconColor??Colors.black,
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

    return Padding(
      padding: const EdgeInsets.only(left: 8,right: 8,top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        if (widget.fromProfile == false) {
                          context.push(Routes.OTHERSACCOUNT, extra: post.user.id);
                        }
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextAppButton(
                              label: post.user.firstName,
                              onPressed: () {
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
                          ])),
                        ],
                      ),
                    ),
                    Expanded(child: _buildActivityFeelingWidget(post)),
                  ],
                ),
              ),
              const Sizer(),
                IconAppButton(
                  icon: Icons.more_horiz_outlined,
                  onPressed: () {
                    bottomSheet(
                        context: context,
                        widget: _buildPostOptions(
                            fromDetails: widget.from == 'details',
                            post: post,
                        ),
                    );
                  },
                ),
            ],
          ),
          if (post.location != null)
            Padding(
              padding: const EdgeInsetsDirectional.only(start: 40.0),
              child: InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (_) => Scaffold(
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
      ),
    );
  }

  Widget _buildMainAccountHeader({
    required BuildContext context,
    required MainPostEntity post,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          InkWell(
            onTap: () {
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
              InkWell(
                onTap: () {
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
      ),
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
            height: 220,
            alignment: Alignment.center,
            margin: const EdgeInsets.symmetric(vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
            color: images.isEmpty
                ? Color(int.parse(backgroundColor.substring(1), radix: 16))
                : Colors.white,
            child: ReadMoreLabel(
              text: content,
              style: Styles.headerText(
                  color: Colors.black,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
          )
        : Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ReadMoreLabel(text: content),
                const SizedBox(
                  height: 10,
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
    IconData? icon,
    required String label,
    String? image,
    bool? isImage=false,
    Function? onTap,
  }) {
    if (onTap == null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if(image!=null)Image.asset(image,width: 24,height: 24,),
          if(isImage==false)FaIcon(
            icon,
            color: AppColors.GREY_DARK_COLOR,
            size: 20,
          ),
          Label(text: label, style: Styles.mediumText(color: Colors.grey))
        ],
      );
    } else {
      return InkWell(
        onTap: () => onTap(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if(image!=null)Image.asset(image??'',width: 22,height: 22,),
            if(image==null)FaIcon(
              icon,
              color: AppColors.GREY_DARK_COLOR,
              size: 20,
            ),
            // const Sizer(),
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
              'feeling ${post.feeling!=null?post.feeling?.name??'':''}${post.activity!=null?', ${post.activity?.name}':''}',
              style: Styles.mediumText(),
            ),
            const SizedBox(
              width: 10,
            ),
          ],
          if (post.users != null && post.users!.isNotEmpty)
            Row(
              children: [
                Label(
                  text: 'with: ',
                  style: Styles.mediumText(),
                ),
                GestureDetector(
                  onTap: () {
                    context.push(Routes.OTHERSACCOUNT,
                        extra: post.users![0].id);
                  },
                  child: Label(
                    text:
                        "${post.users![0].firstName} ${post.users![0].lastName} ",
                    style:
                        Styles.mediumText(decoration: TextDecoration.underline),
                  ),
                ),
                if (post.users!.length > 1)
                  GestureDetector(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (_) => BuildWithUsers(
                                  users: post.users!,
                                ));
                      },
                      child: Label(
                        text: '+${post.users!.length - 1}',
                        style: Styles.headerText(),
                      ))
              ],
            ),
        ],
      ),
    );
  }
}
