import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/iconAppButton.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/text_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/profile_image.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/social_image_viewer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/cubit/instagram_cubit.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/insta_reel_card.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/instagram_post_comments.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/instagram_suggest_people.dart';
import 'package:fourtyninehub/features/social_media/social_posts/data/models/comment_model.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/comment_entity.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/post_entity.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/add_reply_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/post_comment_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/post_react_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/posts/facebook_advirtesement_card.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/entities/twitter_user_entity.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:snapping_bottom_sheet/snapping_bottom_sheet.dart';

class InstagramPosts extends StatefulWidget {
  const InstagramPosts({
    super.key,
    required this.scrollController,
  });
  final ScrollController scrollController;
  @override
  State<InstagramPosts> createState() => _InstagramPostsState();
}

class _InstagramPostsState extends State<InstagramPosts> {

  final commentTextController = TextEditingController();
  final SheetController sheetController = SheetController();

  void showAsBottomSheet({required Widget child,required Widget footer}) async {
    final result = await showSnappingBottomSheet(
        context,
        builder: (context) {
          return SnappingBottomSheetDialog(
            controller: sheetController,
            minHeight: MediaQuery.of(context).size.height * 0.7,
            elevation: 8,
            cornerRadius: 10,
            snapSpec: const SnapSpec(
              snap: true,
              snappings: [1.0, 0.7, 1.0],
              positioning: SnapPositioning.relativeToAvailableSpace,
            ),
            // footerBuilder: (context,snap)=>footer,
            extendBody: true,

            builder: (context, state) {
              return child;
            },
          );
        }
    );

    print(result); // This is the result.
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InstagramCubit, InstagramState>(
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
      final controller = context.read<InstagramCubit>();
      print(controller.feedPagingController
              .itemList![5].comments);
      return RefreshIndicator(
        onRefresh: () async => controller.onRefresh(),
        child: CustomScrollView(
          controller: widget.scrollController,
          slivers: [
            SliverToBoxAdapter(
              child: BlocProvider<InstagramCubit>(
                  create: (_)=>serviceLocator()..loadInstaSuggestedPeople(),
                  child: const InstagramSuggestPeople(),
              ),
            ),
            PagedSliverList<int, PostEntity>(
              pagingController: controller.feedPagingController,
              builderDelegate: PagedChildBuilderDelegate<PostEntity>(
                noItemsFoundIndicatorBuilder: (context) {
                  return const Center(
                    child: Text(
                      "No Posts",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                  );
                },
                itemBuilder: (context, item, index) {
                  final user = context.read<UserCubit>().state.data;
                  final pageController = PageController();
                  if (controller.feedPagingController.itemList?[index].type ==
                      'advertisement') {
                    return FacebookAdvertisementCard(
                      post: controller.feedPagingController.itemList![index],
                    );
                  } else if (controller
                      .feedPagingController.itemList?[index].type ==
                      'facebook_post') {
                    return Padding(
                      padding: const EdgeInsetsDirectional.only(
                        start: 10.0,
                        end: 10,
                        top: 0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Sizer(),
                          _buildMainAccountHeader(post:controller.feedPagingController
                              .itemList![index], context: context),
                          const Sizer(),
                          SizedBox(
                            height: kToolbarHeight * 5,
                            child: PageView.builder(
                                controller: pageController,
                                scrollDirection: Axis.horizontal,
                                itemCount: controller.feedPagingController
                                    .itemList![index].images!.length,
                                onPageChanged: (i) {
                                  controller.changeIndex(i);
                                },
                                itemBuilder: (context, i) {
                                  return SocialImageViewer(
                                    image: controller.feedPagingController
                                        .itemList![index].images![i],
                                    index: i + 1,
                                    length: controller.feedPagingController
                                        .itemList![index].images!.length,
                                    onDoubleTap: () {
                                      controller.feedPagingController
                                          .itemList?[index].isLove =
                                      !controller.feedPagingController
                                          .itemList![index].isLove!;
                                      setState(() {});
                                    },
                                  );
                                }),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          if (controller.feedPagingController
                              .itemList![index].images!.length >
                              1)
                            Center(
                              child: SizedBox(
                                height: 8,
                                child: ListView.separated(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: controller
                                        .feedPagingController
                                        .itemList![index]
                                        .images!
                                        .length,
                                    separatorBuilder:
                                        (context, index) => const Sizer(
                                      width: 3,
                                    ),
                                    itemBuilder: (context, index) {
                                      return CircleAvatar(
                                        radius: 4,
                                        backgroundColor: state
                                            .pageIndex ==
                                            index
                                            ? AppColors.SECONDARY_COLOR
                                            : AppColors.PRIMARY_COLOR,
                                      );
                                    }),
                              ),
                            ),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      IconAppButton(
                                        icon: controller.feedPagingController
                                            .itemList?[index].isLove ==
                                            true
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        onPressed: () async {
                                          var reacted =
                                          await controller.onReact(
                                            params: PostReactParams(
                                              postId: controller
                                                  .feedPagingController
                                                  .itemList![index]
                                                  .id,
                                              react: 'love',
                                            ),
                                          );
                                          if (reacted == true) {
                                            controller.feedPagingController
                                                .itemList?[index].isLove =
                                            !controller.feedPagingController
                                                .itemList![index].isLove!;
                                            if (controller.feedPagingController
                                                .itemList?[index].isLove ==
                                                false) {
                                              controller
                                                  .feedPagingController
                                                  .itemList?[index]
                                                  .loveCount = (controller
                                                  .feedPagingController
                                                  .itemList![index]
                                                  .loveCount! -
                                                  1);
                                            } else {
                                              controller
                                                  .feedPagingController
                                                  .itemList?[index]
                                                  .loveCount = (controller
                                                  .feedPagingController
                                                  .itemList![index]
                                                  .loveCount! +
                                                  1);
                                            }
                                          }
                                          setState(() {});
                                        },
                                        color: controller.feedPagingController
                                            .itemList?[index].isLove ==
                                            true
                                            ? Colors.red
                                            : Colors.grey,
                                        size: 25,
                                      ),
                                      const Sizer(
                                        width: 5,
                                      ),
                                      Label(
                                        text: controller.feedPagingController
                                            .itemList?[index].loveCount
                                            .toString() ??
                                            '',
                                        style: Styles.mediumText(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const Sizer(),
                                      IconAppButton(
                                        icon: Icons.chat_bubble_outline_rounded,
                                        onPressed: () {
                                          bottomSheet(
                                              context: context,
                                              isScrollControlled: true,
                                              widget: BlocProvider.value(
                                                value: serviceLocator<
                                                    InstagramCubit>()
                                                  ..loadComments(
                                                      context,
                                                      controller
                                                          .feedPagingController
                                                          .itemList![index]
                                                          .id),
                                                child: InstagramPostComments(
                                                  postId: controller
                                                      .feedPagingController
                                                      .itemList![index]
                                                      .id,
                                                  onCommentReply:
                                                      (ReplyOnCommentParams
                                                  params) async {
                                                    var result =
                                                    await controller
                                                        .replyOnComment(
                                                      params:
                                                      ReplyOnCommentParams(
                                                          postId:
                                                          params.postId,
                                                          content: params
                                                              .content,
                                                          commentId: params
                                                              .commentId),
                                                    );
                                                    var currentPost = controller
                                                        .feedPagingController
                                                        .itemList
                                                        ?.firstWhere(
                                                            (element) =>
                                                        element.id ==
                                                            params.postId);
                                                    currentPost?.commentsCount =
                                                    (currentPost
                                                        .commentsCount! +
                                                        1);
                                                    return result;
                                                  },
                                                  onAddComment:
                                                      (PostCommentParams
                                                  params) async {
                                                    var result =
                                                    await controller
                                                        .onPostComment(
                                                        params: params);
                                                    return result;
                                                  },
                                                  onDeleteComment:
                                                      (String id) async {
                                                    return await controller
                                                        .deleteComment(
                                                        context: context,
                                                        commentId: id,
                                                        postId: controller
                                                            .feedPagingController
                                                            .itemList![
                                                        index]
                                                            .id,
                                                        from: 'feed');
                                                    // print(result);
                                                  },
                                                  onDeleteReply:
                                                      (String id) async {
                                                    return await controller
                                                        .deleteComment(
                                                        context: context,
                                                        commentId: id,
                                                        postId: controller
                                                            .feedPagingController
                                                            .itemList![
                                                        index]
                                                            .id,
                                                        from: 'feed');
                                                  },
                                                  onEditComment:
                                                      (PostCommentParams
                                                  params) async {
                                                    var result =
                                                    await controller
                                                        .editComment(
                                                        params: params);
                                                    return result;
                                                  },
                                                ),
                                              ));
                                        },
                                        color: Colors.grey,
                                        size: 25,
                                      ),
                                      const Sizer(
                                        width: 5,
                                      ),
                                      Label(
                                        text: controller.feedPagingController
                                            .itemList?[index].commentsCount
                                            .toString() ??
                                            '',
                                        style: Styles.mediumText(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),

                                const Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Sizer(
                            height: 5,
                          ),
                          if(controller.feedPagingController
                              .itemList![index].content!.isNotEmpty)Label(
                              text: controller.feedPagingController
                                  .itemList?[index].content ??
                                  ''),
                          if(controller.feedPagingController
                              .itemList![index].content!.isNotEmpty)...[
                                InkWell(
                                    onTap:()=>showAsBottomSheet(
                                      child:BlocProvider.value(
                                        value: serviceLocator<
                                            InstagramCubit>()
                                          ..loadComments(
                                              context,
                                              controller
                                                  .feedPagingController
                                                  .itemList![index]
                                                  .id),
                                        child: SizedBox(
                                          height: MediaQuery.of(context).size.height * 0.95,
                                          child: InstagramPostComments(
                                            postId: controller
                                                .feedPagingController
                                                .itemList![index]
                                                .id,
                                            onCommentReply:
                                                (ReplyOnCommentParams
                                            params) async {
                                              var result =
                                              await controller
                                                  .replyOnComment(
                                                params:
                                                ReplyOnCommentParams(
                                                    postId:
                                                    params.postId,
                                                    content: params
                                                        .content,
                                                    commentId: params
                                                        .commentId),
                                              );
                                              var currentPost = controller
                                                  .feedPagingController
                                                  .itemList
                                                  ?.firstWhere(
                                                      (element) =>
                                                  element.id ==
                                                      params.postId);
                                              currentPost?.commentsCount =
                                              (currentPost
                                                  .commentsCount! +
                                                  1);
                                              return result;
                                            },
                                            onAddComment:
                                                (PostCommentParams
                                            params) async {
                                              var result =
                                              await controller
                                                  .onPostComment(
                                                  params: params);
                                              return result;
                                            },
                                            onDeleteComment:
                                                (String id) async {
                                              return await controller
                                                  .deleteComment(
                                                  context: context,
                                                  commentId: id,
                                                  postId: controller
                                                      .feedPagingController
                                                      .itemList![
                                                  index]
                                                      .id,
                                                  from: 'feed');
                                              // print(result);
                                            },
                                            onDeleteReply:
                                                (String id) async {
                                              return await controller
                                                  .deleteComment(
                                                  context: context,
                                                  commentId: id,
                                                  postId: controller
                                                      .feedPagingController
                                                      .itemList![
                                                  index]
                                                      .id,
                                                  from: 'feed');
                                            },
                                            onEditComment:
                                                (PostCommentParams
                                            params) async {
                                              var result =
                                              await controller
                                                  .editComment(
                                                  params: params);
                                              return result;
                                            },
                                          ),
                                        ),
                                      ),
                                      footer: Material(
                                        child: Container(
                                            height: kToolbarHeight,
                                            decoration: const BoxDecoration(
                                              color: Colors.white,
                                            ),
                                            child: Row(
                                              children: [
                                                const ProfileImage(accountId: 0,userId: '',),
                                                const Sizer(),
                                                Expanded(
                                                    child:
                                                    TextFormField(
                                                      maxLines: null,
                                                      controller: commentTextController,
                                                      onChanged: (v) {
                                                        setState(() {});
                                                      },
                                                      style: Styles.headerText(fontSize: 26),
                                                      decoration: InputDecoration(
                                                        fillColor: Colors.white,
                                                        contentPadding: const EdgeInsets.all(5),
                                                        hintText: 'Type your comment ....',
                                                        hintStyle: Styles.mediumText(),
                                                      ),
                                                    )),
                                                const Sizer(),
                                                  IconAppButton(
                                                      icon: Icons.send,
                                                      size: 20,
                                                      isCircle: true,
                                                      onPressed: () async {
                                                        // CommentEntity data = await widget.onAddComment(
                                                        //   PostCommentParams(
                                                        //       postId: widget.postId,
                                                        //       content: commentTextController.text),
                                                        // );
                                                        CommentEntity data  =
                                                        await controller
                                                            .onPostComment(
                                                            params: PostCommentParams(content: commentTextController.text,postId:controller
                                                                .feedPagingController
                                                                .itemList![index]
                                                                .id ));
                                        
                                                        controller.commentsPagingController.itemList
                                                            ?.insert(
                                                          0,
                                                          CommentModel(
                                                            id: data.id,
                                                            content: commentTextController.text,
                                                            post: controller
                                                                .feedPagingController
                                                                .itemList![index]
                                                                .id,
                                                            createdAt: DateTime.now(),
                                                            loveCount: data.loveCount,
                                                            angryCount: data.angryCount,
                                                            likesCount: data.likesCount,
                                                            repliesCount: data.repliesCount,
                                                            sadCount: data.sadCount,
                                                            wowCount: data.wowCount,
                                                            isAngry: false,
                                                            isLikes: false,
                                                            isLove: false,
                                                            isSad: false,
                                                            isWow: false,
                                                            user: TwitterUserEntity(
                                                              id: user!.id,
                                                              firstName: user.firstName,
                                                              lastName: user.lastName,
                                                              createdAt: DateTime.now(),
                                                              image: user.profilePicture ?? '',
                                                              email: user.email ?? '',
                                                              isDocumented: false,
                                                            ),
                                                          ),
                                                        );
                                                        commentTextController.clear();
                                                        FocusScope.of(context).unfocus();
                                                        setState(() {});
                                                      })
                                              ],
                                            )),
                                      ),
                                    ),
                                    child: const Label(text: 'Show Comments'))
                          ],
                          if(controller.feedPagingController
                              .itemList![index].content!.isEmpty&&(controller.feedPagingController
                              .itemList![index].comments!=null))RichText(
                              text: TextSpan(
                                  children: [
                                TextSpan(
                                    text: '${controller.feedPagingController
                                    .itemList?[index].comments?[0].firstName}\t\t',
                                    recognizer: TapGestureRecognizer()..onTap = () => context.push(Routes.INSTAGRAMPROFILE,extra: controller.feedPagingController
                                        .itemList?[index].user.id),
                                    style: Styles.mediumText(color: Colors.black)),
                                TextSpan(
                                    text:controller.feedPagingController
                                        .itemList![index].comments!=null?'':controller.feedPagingController
                                        .itemList?[index].comments?[0].content,
                                    style: Styles.mediumText(color: Colors.grey)),
                              ])),
                          RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                    text: controller.feedPagingController
                                        .itemList?[index].sinceTime,
                                    style: Styles.mediumText(color: Colors.grey)),
                              ]))

                        ],
                      ),
                    );
                  } else {
                    return Column(
                      children: [
                        Container(
                          height: 5,
                          width: double.infinity,
                          color: AppColors.DIVIDER_GRAY_COLOR2,
                        ),
                        Container(
                          color: Colors.black,
                          height: 300,
                          width: double.infinity,
                          child: InstagramReelCard(
                            item: controller
                                .feedPagingController.itemList![index],
                          ),
                        ),
                        Container(
                          height: 5,
                          width: double.infinity,
                          color: AppColors.DIVIDER_GRAY_COLOR2,
                        ),
                      ],
                    );
                  }
                },
                noMoreItemsIndicatorBuilder: (context) => Container(),
                firstPageProgressIndicatorBuilder: (context) =>
                const CupertinoActivityIndicator(),
                newPageProgressIndicatorBuilder: (context) =>
                const CupertinoActivityIndicator(),
              ),
            ),
          ],
        ),
      );
    });
  }


  Widget _buildMainAccountHeader({
    required BuildContext context,
    required PostEntity post,
  }) {
    return Row(
      children: [
        InkWell(
          onTap: () {
                context.push(Routes.INSTAGRAMPROFILE, extra: post.user.id);
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                          context.push(Routes.INSTAGRAMPROFILE, extra: post.user.id);
                                           },
                      child: TextAppButton(
                          style: TextStyle(color: Theme.of(context).primaryColor),
                          label: post.user.firstName,
                          onPressed: () {
                            context.push(Routes.INSTAGRAMPROFILE, extra: post.user.id);                          }),
                    ),
                  ],
                ),
                // _buildActivityFeelingWidget(post),
              ],
            )),
      ],
    );
  }
}
