import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/functions/global/upload_file.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/badged_label.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/social_media/create_post/presentation/widgets/image_details.dart';
import 'package:fourtyninehub/features/social_media/social_posts/data/models/main_post_model.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/main_post_entity.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/post_entity.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/cubit/social_posts_cubit.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/pages/show_post_images.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/build_reactions_buttons.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/posts/facebook_advirtesement_card.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/posts/facebook_tweet_card.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/read_more_label.dart';
import 'package:fourtyninehub/features/social_media/twitter/data/models/twitter_main_post_model.dart';
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
      required this.deletePost,
      required this.hidePost,
      required this.showPostDetails,
      required this.showPostComments,
      required this.onShare,
      required this.from, required this.index});

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
              state.failure ?? const UnknownFailure(),
              context,
            ),
          );
        }
      }, builder: (context, state) {
        final controller = context.read<SocialPostsCubit>();
        if(widget.from == 'posts'){
          if (controller.feedPagingController.itemList?[widget.index].type == 'advertisement') {
            return FacebookAdvertisementCard(
              post: controller.feedPagingController.itemList![widget.index],
            );
          } else if (controller.feedPagingController.itemList![widget.index].type == 'twitter_post') {
            return FacebookTweetCard(
              post: controller.feedPagingController.itemList![widget.index],
            );
          }else {
            var myPost =widget.from == 'details'?widget.post:controller.feedPagingController.itemList![widget.index];
            return InkWell(
              onTap: widget.from == 'posts'
                  ? () => widget.showPostDetails(controller.feedPagingController.itemList![widget.index])
                  : null,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (myPost.isShared==true)_buildAccountHeader(context: context, post: myPost),
                  Label(text: myPost.mainPost?.content??''),

                  Container(
                    margin: EdgeInsets.all(myPost.isShared==true?10:0),
                    padding: EdgeInsets.all(myPost.isShared==true?10:0),
                    decoration: BoxDecoration(
                      border: myPost.isShared==true?Border.all():null
                    ),
                    child: Column(
                      children: [
                        if (myPost.type != 'advertisement'&&myPost.isShared==true)
                          _buildMainAccountHeader(context: context, post: myPost.mainPost!),
                        if (myPost.type != 'advertisement'&&myPost.isShared==false)
                          _buildAccountHeader(context: context, post: myPost),
                        _buildContentWidget(content: myPost.mainPost?.content??'',backgroundColor: null,images: myPost.mainPost?.images??[]),


                      ],
                    ),
                  ),
                  Row(
                    children: [
                      if (myPost.likesCount != 0)
                        _buildCounterWidget(
                            value: myPost.likesCount!, image: Assets.like),
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
                            value: myPost.angryCount!,
                            image: Assets.angry),
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
                  const Divider(
                    color: AppColors.LIGHT_GRAY_COLOR,
                  ),
                  SizedBox(
                    height: kToolbarHeight * .6,
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
                                icon: Icons.chat_bubble_outline_rounded,
                                label: 'Comment',
                                onTap: () =>
                                    widget.showPostComments(myPost.id)),
                          ),
                        Expanded(
                          child: _buildReactionPlaceHolder(
                              icon: Icons.chat_rounded,
                              label: 'Share',
                              onTap: () {
                                controller.onShare(postId: myPost.id);
                              }),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        }
         else {
          var myPost =widget.from == 'details'?widget.post:controller.feedPagingController.itemList![widget.index];
          return InkWell(
            onTap: widget.from == 'posts'
                ? () => widget.showPostDetails(controller.feedPagingController.itemList![widget.index])
                : null,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (myPost.type != 'advertisement')
                  _buildAccountHeader(context: context, post: myPost),
                _buildContentWidget(content: myPost.content??'',backgroundColor: myPost.backgroundColor,images: myPost.images),
                Row(
                  children: [
                    if (myPost.likesCount != 0)
                      _buildCounterWidget(
                          value: myPost.likesCount!, image: Assets.like),
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
                          value: myPost.angryCount!,
                          image: Assets.angry),
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
                const Divider(
                  color: AppColors.LIGHT_GRAY_COLOR,
                ),
                SizedBox(
                  height: kToolbarHeight * .6,
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
                              icon: Icons.chat_bubble_outline_rounded,
                              label: 'Comment',
                              onTap: () =>
                                  widget.showPostComments(myPost.id)),
                        ),
                      Expanded(
                        child: _buildReactionPlaceHolder(
                            icon: Icons.chat_rounded,
                            label: 'Share',
                            onTap: () {
                              controller.onShare(postId: myPost.id);
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

  Widget _buildPostOptions({required bool fromDetails,required PostEntity post}) {
    return SizedBox(
      height: widget.isMyPost ? 150 : 80,
      child: Column(
        children: [
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
      {required IconData icon,
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
    bool showOptions = true,
    required PostEntity post,
  }) {
    return Row(
      children: [
        InkWell(
          onTap: () => context.push(Routes.OTHERSACCOUNT),
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
              onTap: () => context.push(Routes.OTHERSACCOUNT),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextAppButton(
                      label: post.user.firstName,
                      onPressed: () =>
                          () => context.push(Routes.OTHERSACCOUNT)),
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
            _buildActivityFeelingWidget(post),
          ],
        )),
        if (showOptions)
          IconAppButton(
            icon: Icons.clear,
            onPressed: () {
              bottomSheet(
                  context: context,
                  widget:
                      _buildPostOptions(fromDetails: widget.from == 'details', post: post));
            },
          ),
      ],
    );
  }

  Widget _buildMainAccountHeader({
    required BuildContext context,
    bool showOptions = true,
    required MainPostEntity post,
  }) {
    return Row(
      children: [
        InkWell(
          onTap: () => context.push(Routes.OTHERSACCOUNT),
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
              onTap: () => context.push(Routes.OTHERSACCOUNT),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextAppButton(
                      label: post.user.firstName,
                      onPressed: () =>
                          () => context.push(Routes.OTHERSACCOUNT)),
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

  Widget _buildContentWidget({String? backgroundColor,required String content,List<String>? images}) {
    return (backgroundColor != null &&
                backgroundColor != '#FFFFFFFF') &&
            images!.isEmpty
        ? Container(
            width: double.infinity,
            height: 400,
            alignment: Alignment.center,
            margin: const EdgeInsets.symmetric(vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
            color: backgroundColor != null &&
                    images.isEmpty
                ? Color(int.parse(backgroundColor.substring(1),
                    radix: 16))
                : Colors.white,
            child: ReadMoreLabel(
              text: content ?? '',
              style: Styles.headerText(color: Colors.black, fontSize: 24,fontWeight: FontWeight.bold),
            ),
          )
        : Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ReadMoreLabel(text: content ?? ''),
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
                        itemCount:
                            images!.length < 4 ? images!.length : 4,
                        itemBuilder: (context, index) => InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                              onTap: () {
                                if (index != 3 ||
                                    (index == 3 && images!.length == 4)) {
                                  showDialog(
                                      context: context,
                                      builder: (context) => ImageDetailsScreen(
                                            image: images![index],
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
                                          images: images ?? [],
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
                                      Container(
                                        margin:
                                            const EdgeInsetsDirectional.only(
                                                end: 10, bottom: 10),
                                        padding: const EdgeInsets.all(10),
                                        child: ImageFromInternet(image: images?[index]??'',),
                                      ),
                                      if (index == 3 && images!.length > 4)
                                        Container(
                                          margin:
                                              const EdgeInsetsDirectional.only(
                                                  end: 10, bottom: 10),
                                          // padding: const EdgeInsets.all(10),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            color:
                                                Colors.black.withOpacity(0.5),
                                          ),
                                          child: Center(
                                            child: Label(
                                              text:
                                                  "+${images!.length - 4}",
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
          Icon(
            icon,
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
            Icon(
              icon,
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
      child: Row(
        children: [
          if (post.feeling != null) ...[
            BadgedLabel(label: post.feeling?.name ?? ''),
            const SizedBox(
              width: 10,
            ),
          ],
          if (post.activity != null)
            BadgedLabel(label: post.activity?.name ?? ''),
        ],
      ),
    );
  }
}
