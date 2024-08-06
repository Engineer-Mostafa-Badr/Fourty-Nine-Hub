import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:fourtyninehub/common/functions/global/upload_file.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/ReadMoreLabel.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/badged_label.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/social_media/create_post/presentation/widgets/image_details.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/post_entity.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/cubit/social_posts_cubit.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/pages/show_post_images.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/build_reactions_buttons.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/posts/facebook_advirtesement_card.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
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
      required this.from});

  @override
  State<FacebookPostCard> createState() => _FacebookPostCardState();
}

class _FacebookPostCardState extends State<FacebookPostCard> {
  final pageController = PageController();
  bool isLiked = false;
  bool hide = false;
  Reaction<String>? _selectedReaction;
  @override
  void initState() {
    pageController.addListener(() {
      setState(() {});
    });
    _selectedReaction = Reaction<String>(
      value: 'like',
      icon: _buildReactionWidget(item: Reactions.like),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (hide) {
      return Container(
        padding: const EdgeInsets.all(8.0),
        decoration: const BoxDecoration(color: AppColors.LIGHT_GRAY_COLOR),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(Icons.visibility_off),
                const Sizer(),
                const Label(text: 'Post is hidden'),
                const Spacer(),
                ElevatedButton(
                    onPressed: () {
                      hide = false;
                      setState(() {});
                    },
                    child: const Label(text: 'Show'))
              ],
            ),
            const Divider(),
            InkWell(
              onTap: () {},
              child: Row(
                children: [
                  const Icon(
                    Icons.report,
                    color: Colors.grey,
                  ),
                  const Sizer(),
                  Label(
                    text: 'Report the post',
                    style: Styles.mediumText(color: Colors.grey),
                  ),
                ],
              ),
            ),
            const Sizer(),
            InkWell(
              onTap: () {},
              child: Row(
                children: [
                  const Icon(
                    Icons.block,
                    color: Colors.grey,
                  ),
                  const Sizer(),
                  Label(
                    text: 'Block the publisher',
                    style: Styles.mediumText(color: Colors.grey),
                  ),
                ],
              ),
            )
          ],
        ),
      );
    } else {
      return BlocProvider<SocialPostsCubit>(
        create: (_)=>serviceLocator(),
        child: BlocConsumer<SocialPostsCubit,SocialPostsState>(
          listener: (context,state){
            if (state.status == StateStatus.error) {
              showErrorMessage(
                context,
                getFailureMessage(
                  state.failure ?? const UnknownFailure(),
                  context,
                ),
              );
            }
          },
          builder: (context,state) {
            final controller = context.read<SocialPostsCubit>();
            return widget.post.type=='advertisement'?FacebookAdvertisementCard(post: widget.post,):InkWell(
              onTap: widget.from == 'posts'
                  ? () => widget.showPostDetails(widget.post)
                  : null,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if(widget.post.type!='advertisement')_buildAccountHeader(context: context, post: widget.post),
                  _buildContentWidget(post: widget.post),
                  Row(
                    children: [
                      if (widget.post.likesCount != 0)
                        _buildCounterWidget(
                            value: widget.post.likesCount!, image: Assets.like),
                      if (widget.post.loveCount != 0)
                        _buildCounterWidget(
                            value: widget.post.loveCount!, image: Assets.heart),
                      if (widget.post.wowCount != 0)
                        _buildCounterWidget(
                            value: widget.post.wowCount!, image: Assets.wow),
                      if (widget.post.sadCount != 0)
                        _buildCounterWidget(
                            value: widget.post.sadCount!, image: Assets.sad),
                      if (widget.post.angryCount != 0)
                        _buildCounterWidget(
                            value: widget.post.angryCount!, image: Assets.angry),
                      const Spacer(),
                      InkWell(
                        onTap: () => widget.showPostComments(widget.post.id),
                        child: Row(
                          children: [
                            Label(
                              text: widget.post.commentsCount.toString(),
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
                          post: widget.post,
                          from: 'posts',
                        )),
                        if (widget.from == 'posts')
                          Expanded(
                            child: _buildReactionPlaceHolder(
                                icon: Icons.chat_bubble_outline_rounded,
                                label: 'Comment',
                                onTap: () => widget.showPostComments(widget.post.id)),
                          ),
                        Expanded(
                          child: _buildReactionPlaceHolder(
                              icon: Icons.chat_rounded,
                              label: 'Share',
                              onTap: () {
                                controller.onShare(postId: widget.post.id);
                              }),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        ),
      );
    }
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

  Widget _buildPostOptions({required bool fromDetails}) {
    return SizedBox(
      height: 180,
      child: Column(
        children: [
          if (widget.isMyPost)
            listTile(
                icon: Icons.delete,
                title: 'Delete Post',
                subTitle:
                    'Your post will be deleted, and you cannot get it again',
                onTap: () {
                  widget.deletePost(widget.post.id);
                  if(fromDetails==true){
                    context.pop();
                  }
                }),
          if (widget.isMyPost)
            listTile(
                icon: Icons.visibility_off,
                title: 'Hide Post',
                subTitle: 'Your post will be hidden, you can get it again',
                onTap: () {
                  widget.hidePost(widget.post.id);
                  if(fromDetails==true){
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
        if(post.type=='twitter_posr')Text("twitter_posr"),
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
            _buildActivityFeelingWidget(),
          ],
        )),
        // if (widget.showOptions)
        //   IconButton(
        //       onPressed: () {
        //         bottomSheet(context: context, widget: _buildPostOptions());
        //       },
        //       icon: const Icon(Icons.more_horiz)),
        if (showOptions)
          IconAppButton(
              icon: Icons.clear,
              onPressed: () {
                bottomSheet(context: context, widget: _buildPostOptions(fromDetails: widget.from=='details'));
              })
      ],
    );
  }

  Widget _buildContentWidget({required PostEntity post}) {
    return (widget.post.backgroundColor != null &&
                widget.post.backgroundColor != '#FFFFFFFF') &&
            widget.post.images!.isEmpty
        ? Container(
            width: double.infinity,
            height: 400,
            alignment: Alignment.center,
            margin: const EdgeInsets.symmetric(vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
            color: widget.post.backgroundColor != null &&
                    widget.post.images!.isEmpty
                ? Color(int.parse(widget.post.backgroundColor!.substring(1),
                    radix: 16))
                : Colors.white,
      child: ReadMoreLabel(text: post.content??'',style: Styles.headerText(
        color: Colors.black,
        fontSize: 24
      ),),
          )
        : Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
            child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ReadMoreLabel(text: post.content??''),
                      const SizedBox(
                        height: 10,
                      ),
                      // if(widget.post.photo.isNotEmpty)Container(
                      //   height: 200,
                      //   width: double.infinity,
                      //   decoration: BoxDecoration(
                      //       boxShadow: [
                      //         BoxShadow(
                      //           color: Colors.black.withOpacity(0.05),
                      //           spreadRadius: 12,
                      //           blurRadius: 8,
                      //         ),
                      //       ],
                      //       borderRadius: BorderRadius.circular(25),
                      //       image: DecorationImage(
                      //           image: NetworkImage(post.photo), fit: BoxFit.fill)),
                      // ),
                      if ((post.images?.isNotEmpty ?? false))
                        SizedBox(
                          // height: kToolbarHeight * 4,
                          // child: PageView.builder(
                          //     controller: pageController,
                          //     scrollDirection: Axis.horizontal,
                          //     itemCount: post.images?.length ?? 0,
                          //     itemBuilder: (context, index) {
                          //       return SocialImageViewer(
                          //         image: post.images![index],
                          //         index: index + 1,
                          //         length: post.images!.length,
                          //         onDoubleTap: () {
                          //           isLiked = !isLiked;
                          //           setState(() {});
                          //         },
                          //       );
                          //     }),
                          child: GridView.builder(
                              padding: const EdgeInsets.all(10),
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: post.images!.length == 1 ? 1 : 2),
                              itemCount:
                              post.images!.length < 4 ? post.images!.length : 4,
                              itemBuilder: (context, index) => InkWell(
                                onTap: () {
                                  if (index != 3 ||
                                      (index == 3 && post.images!.length == 4)) {
                                    showDialog(
                                        context: context,
                                        builder: (context) => ImageDetailsScreen(
                                          image: post.images![index],
                                          fromPost: true,
                                          onRemoveImage: () {
                                            // controller
                                            //     .removePhoto(post.images![index]);
                                            context.pop();
                                          },
                                        ));
                                  } else {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return ShowPostsImages(
                                          images: post.images??[],
                                          onRemoveImage: (UploadFileEntity image) {
                                            // controller.removePhoto(image);
                                          },
                                        );
                                        }
                                    );
                                  }
                                },
                                child: Stack(
                                  children: [
                                    Stack(
                                      children: [
                                        Container(
                                          margin: const EdgeInsetsDirectional.only(
                                              end: 10, bottom: 10),
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(15),
                                            image: DecorationImage(
                                              fit: BoxFit.fill,
                                              image: NetworkImage(
                                                post.images?[index]??'',
                                              ),
                                            ),
                                          ),
                                        ),
                                        if (index == 3 && post.images!.length > 4)
                                          Container(
                                            margin: const EdgeInsetsDirectional.only(
                                                end: 10, bottom: 10),
                                            // padding: const EdgeInsets.all(10),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(15),
                                              color: Colors.black.withOpacity(0.5),
                                            ),
                                            child: Center(
                                              child: Label(
                                                text: "+${post.images!.length - 4}",
                                                style: Styles.headerText(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                    if (index == 0 && post.images!.length == 1)
                                      PositionedDirectional(
                                        end: 15,
                                        top: 5,
                                        child: InkWell(
                                          onTap: () {
                                            // controller.removePhoto(post.images?[index]);
                                          },
                                          child: Container(
                                              height: 30,
                                              width: 30,
                                              alignment: Alignment.center,
                                              padding: const EdgeInsets.all(5),
                                              decoration: const BoxDecoration(
                                                  color: Colors.white, shape: BoxShape.circle),
                                              child: const Icon(
                                                Icons.close,
                                                color: Colors.red,
                                              )),
                                        ),
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

  Widget _buildReactionWidget({
    required Reactions item,
  }) {
    return Row(
      children: [
        Image.asset(
          item.image(),
          height: 20,
        ),
        const Sizer(width: 5),
        Label(text: item.label()),
      ],
    );
  }

  Widget _buildActivityFeelingWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        children: [
          if (widget.post.feeling != null) ...[
            BadgedLabel(label: widget.post.feeling?.name ?? ''),
            const SizedBox(
              width: 10,
            ),
          ],
          if (widget.post.activity != null)
            BadgedLabel(label: widget.post.activity?.name ?? ''),
        ],
      ),
    );
  }
}
