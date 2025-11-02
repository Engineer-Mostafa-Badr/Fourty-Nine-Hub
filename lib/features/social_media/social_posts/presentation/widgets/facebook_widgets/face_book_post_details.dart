import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/read_more_label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/ads_feature/ad_details/presentation/pages/image_gallary_viewer.dart';
import 'package:fourtyninehub/features/social_media/create_post/presentation/widgets/show_all_images.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/build_facebook_header.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import '../../../../../../common/widgets/dialogs/show_bottom_sheet.dart';
import '../../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../../common/widgets/stateless/buttons/iconAppButton.dart';
import '../../../../../../common/widgets/stateless/buttons/text_button.dart';
import '../../../../../../common/widgets/stateless/images/profile_image.dart';
import '../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../core/enums/base_status_enum.dart';
import '../../../../../../core/error/failure.dart';
import '../../../../../../core/extensions/string_extension.dart';
import '../../../../../../core/localization/locale_keys.g.dart';
import '../../../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';
import '../../../data/models/comment_model.dart';
import '../../../domain/entities/comment_entity.dart';
import '../../../domain/usecases/add_reply_usecase.dart';
import '../../../domain/usecases/post_comment_usecase.dart';
import '../../cubit/social_posts_cubit.dart';
import '../posts/comment_card.dart';
import '../posts/comment_replies.dart';
import '../../../../twitter/domain/entities/twitter_user_entity.dart';
import '../../../../../../res/style/styles.dart';
import '../../../../../../service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../core/widget/custom_circular_progress_indicator.dart';

import '../../../../../../core/widget/custom_scaffold.dart';
import '../../../../../../helpers/manage_vibration.dart';

class FaceBookPostDetails extends StatefulWidget {
  String? postId;
  CommentEntity? comment;
  bool? isReply;
  FaceBookPostDetails({super.key, payload}) {
    if (payload is String) {
      postId = payload;
    } else {
      postId = payload['postId'];
      if (payload['comment'] != null) {
        comment = CommentModel.fromJson(payload['comment']);
        print("comment?.toJson${comment?.toJson()}");
      }
      if (payload['isReply'] == true) {
        isReply = true;
      } else {
        isReply = false;
      }
    }
  }

  @override
  State<FaceBookPostDetails> createState() => _FaceBookPostDetailsState();
}

class _FaceBookPostDetailsState extends State<FaceBookPostDetails> {
  final commentTextController = TextEditingController();

  bool? loading;

  @override
  void initState() {
    context
        .read<SocialPostsCubit>()
        .loadPostDetails(context, widget.postId ?? '', comment: widget.comment);
    if (widget.isReply == true) {
      print("adnaslkdasldma");
      Future.delayed(const Duration(milliseconds: 500), () => showReplies());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<UserCubit>().state.data;
    print("state.postDetails!.createdAt }");

    return CustomScaffold(
      appBar: AppBar(
        elevation: 0,
        // toolbarHeight: 200.h,
        iconTheme: const IconThemeData(color: Colors.grey),
        title:
            Label(text: LocaleKeys.post.localize, style: Styles.mediumText()),
        leading: IconButton(
            onPressed: () => context.pop(), icon: const Icon(Icons.arrow_back)),
        centerTitle: true,
      ),
      body: BlocConsumer<SocialPostsCubit, SocialPostsState>(
          listener: (context, state) {},
          builder: (context, state) {
            print(
                "state.postDetails!.createdAt ${state.postDetails?.createdAt}");
            final controller = context.read<SocialPostsCubit>();

            if (state.status == StateStatus.loading) {
              print(
                  "state.postDetails!.createdAt ${state.postDetails?.createdAt}");
              return const Center(
                child: CustomCircularProgressIndicator(),
              );
            } else if (state.status == StateStatus.error ||
                state.postDetails == null) {
              print(
                  "state.postDetails!.createdAt ${state.postDetails?.createdAt}");
              return Center(
                child: Label(
                  text: getFailureMessage(
                    state.failure!,
                    context,
                  ),
                ),
              );
            } else {
              print(
                  "state.postDetails!.createdAt ${state.postDetails?.createdAt}");
              return Column(
                children: [
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {},
                      child: CustomScrollView(
                        slivers: [
                          SliverToBoxAdapter(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 16),
                                  child: BuildFacebookHeader(
                                    user: state.postDetails!.user,
                                    sinceTime: context.isArabic
                                        ? DateFormat('d MMM, h:mm a', 'ar')
                                            .format(
                                                state.postDetails!.createdAt!)
                                        : DateFormat('MMM d, h:mm a').format(
                                            state.postDetails!.createdAt!),
                                    activity: state.postDetails!.activity,
                                    feeling: state.postDetails!.feeling,
                                    users: state.postDetails!.users,
                                    location: state.postDetails!.location,
                                  ),
                                ),
                                // const SizedBox(height: 8.0),

                                // if (postEntity.images?.isNotEmpty??false)
                                Column(
                                  children: [
                                    if (state
                                            .postDetails!.content?.isNotEmpty ??
                                        false)
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 10, left: 10, bottom: 16),
                                        child: ReadMoreLabel(
                                          text:
                                              state.postDetails!.content ?? '',
                                          // textAlign: isArabic(content) ? TextAlign.right : TextAlign.left,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.getTextColor(
                                                  context)),
                                        ),
                                      ),
                                    // if(state.postDetails!.type=="live_event_post")FacebookLifeEventWidget(state.postDetails!: state.postDetails!,),
                                    if (state.postDetails!.type == "gif_post" &&
                                        state.postDetails!.gifUrl != null &&
                                        state.postDetails!.gifUrl!.isNotEmpty)
                                      ImageFromInternet(
                                        image: state.postDetails!.gifUrl ?? '',
                                        width: double.infinity,
                                        height: 256,
                                        fit: BoxFit.cover,
                                      ),
                                    if (state.postDetails!.images.isNotEmpty &&
                                        state.postDetails!.type ==
                                            "normal_post")
                                      SizedBox(
                                        height: 256,
                                        width: double.infinity,
                                        child: _buildImageGrid(context,
                                            state.postDetails!.images ?? []),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // PagedSliverList<int, CommentEntity>(
                          //   pagingController:
                          //       controller.commentsPagingController,
                          //   builderDelegate:
                          //       PagedChildBuilderDelegate<CommentEntity>(
                          //     noItemsFoundIndicatorBuilder: (context) {
                          //       return Center(
                          //         child: Text(
                          //           LocaleKeys.noComments.localize,
                          //           style: const TextStyle(
                          //             fontSize: 18,
                          //           ),
                          //         ),
                          //       );
                          //     },
                          //     itemBuilder: (context, item, index) {
                          //       return _buildCommentCard(
                          //           comment: controller.commentsPagingController
                          //               .itemList![index],
                          //           onCommentReply:
                          //               (ReplyOnCommentParams params) {
                          //             return controller.replyOnComment(
                          //               params: ReplyOnCommentParams(
                          //                   postId: params.postId,
                          //                   content: params.content,
                          //                   commentId: params.commentId),
                          //               from: 'feed',
                          //             );
                          //           },
                          //           onDeleteComment: (String id) async {
                          //             bool result =
                          //                 await controller.deleteComment(
                          //                     context: context,
                          //                     commentId: id,
                          //                     postId:
                          //                         state.postDetails?.id ?? '',
                          //                     from: 'feed');
                          //             if (result == true) {
                          //               controller
                          //                   .commentsPagingController.itemList
                          //                   ?.removeWhere(
                          //                       (element) => element.id == id);
                          //               setState(() {});
                          //             }
                          //
                          //             // print(result);
                          //           },
                          //           onDeleteReply: (String id) async {
                          //             return await controller.deleteComment(
                          //                 context: context,
                          //                 commentId: id,
                          //                 postId: controller
                          //                     .feedPagingController
                          //                     .itemList![index]
                          //                     .id,
                          //                 from: 'feed');
                          //           },
                          //           onEditComment:
                          //               (PostCommentParams params) async {
                          //             var result = await controller.editComment(
                          //                 params: params);
                          //             return result;
                          //           });
                          //     },
                          //     noMoreItemsIndicatorBuilder: (context) =>
                          //         Container(),
                          //     firstPageProgressIndicatorBuilder: (context) =>
                          //         const CupertinoActivityIndicator(),
                          //     newPageProgressIndicatorBuilder: (context) =>
                          //         const CupertinoActivityIndicator(),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: kToolbarHeight,
                    decoration: const BoxDecoration(),
                    child: Row(children: [
                      ProfileImage(
                        size: 40.sp,
                        accountId: 0,
                        userId: state.postDetails?.user.id ?? '',
                        imageURL: user?.profilePicture,
                        fromProfile: true,
                      ),
                      const Sizer(),
                      Expanded(
                          child: TextFormField(
                        maxLines: null,
                        controller: commentTextController,
                        onChanged: (v) {
                          setState(() {});
                        },
                        style: Styles.headerText(fontSize: 26),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(5),
                          hintText: 'Type your comment ....',
                          hintStyle: Styles.mediumText(),
                        ),
                      )),
                      const Sizer(),
                      if (loading == true)
                        CustomCircularProgressIndicator(
                          strokeWidth: 8.w,
                        ),
                      if (commentTextController.text.isNotEmpty &&
                          (loading == false || loading == null))
                        IconAppButton(
                          icon: Icons.send,
                          size: 20,
                          isCircle: true,
                          onPressed: () async {
                            ManageVibration.vibrate();
                            setState(() {
                              loading = true;
                            });
                            CommentEntity data = await controller.onPostComment(
                                params: PostCommentParams(
                                    postId: state.postDetails!.id,
                                    content: commentTextController.text),
                                from: '');
                            setState(() {
                              loading = false;
                            });
                            final user = context.read<UserCubit>().state.data;
                            controller.postComments.insert(
                              0,
                              CommentModel(
                                id: data.id,
                                content: commentTextController.text,
                                post: widget.postId ?? '',
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
                                  hasStory: false,
                                ),
                              ),
                            );
                            // widget.post.commentsCount=(widget.post.commentsCount!+1);
                            // state.postDetails?.commentsCount =
                            //     (state.postDetails!.commentsCount + 1);
                            commentTextController.clear();
                            FocusScope.of(context).unfocus();
                            setState(() {});
                          },
                        )
                    ]),
                  )
                ],
              );
            }
          }),
    );
  }

  Widget _buildImageGrid(BuildContext context, List<String> media) {
    if (media.length == 1) {
      return GestureDetector(
        onTap: () {
          ManageVibration.vibrate();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ImageGalleryPage(
                images: media,
                initialIndex: 0,
              ),
            ),
          );
        },
        child: CachedNetworkImage(
          imageUrl: media[0],
          fit: BoxFit.cover,
          placeholder: (context, url) =>
              const Center(child: CustomCircularProgressIndicator()),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      );
    } else if (media.length == 2) {
      return Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                ManageVibration.vibrate();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ImageGalleryPage(
                      images: media,
                      initialIndex: 0,
                    ),
                  ),
                );
              },
              child: CachedNetworkImage(
                imageUrl: media[0],
                fit: BoxFit.cover,
                height: double.infinity,
              ),
            ),
          ),
          const SizedBox(width: 3),
          Expanded(
            child: GestureDetector(
              onTap: () {
                ManageVibration.vibrate();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ImageGalleryPage(
                      images: media,
                      initialIndex: 1,
                    ),
                  ),
                );
              },
              child: CachedNetworkImage(
                imageUrl: media[1],
                fit: BoxFit.cover,
                height: double.infinity,
              ),
            ),
          ),
        ],
      );
    } else if (media.length == 3) {
      return Row(
        children: [
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: () {
                ManageVibration.vibrate();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ImageGalleryPage(
                      images: media,
                      initialIndex: 0,
                    ),
                  ),
                );
              },
              child: CachedNetworkImage(
                imageUrl: media[0],
                fit: BoxFit.cover,
                height: 256,
              ),
            ),
          ),
          const SizedBox(width: 3.5),
          Column(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    ManageVibration.vibrate();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ImageGalleryPage(
                          images: media,
                          initialIndex: 1,
                        ),
                      ),
                    );
                  },
                  child: CachedNetworkImage(
                    imageUrl: media[1],
                    fit: BoxFit.cover,
                    width: 150,
                    height: double.infinity,
                  ),
                ),
              ),
              const SizedBox(height: 3),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    ManageVibration.vibrate();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ImageGalleryPage(
                          images: media,
                          initialIndex: 2,
                        ),
                      ),
                    );
                  },
                  child: CachedNetworkImage(
                    imageUrl: media[2],
                    fit: BoxFit.cover,
                    width: 150,
                    height: double.infinity,
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    } else {
      return Row(
        children: [
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: () {
                ManageVibration.vibrate();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ImageGalleryPage(
                      images: media,
                      initialIndex: 0,
                    ),
                  ),
                );
              },
              child: CachedNetworkImage(
                imageUrl: media[0],
                fit: BoxFit.cover,
                height: 256,
              ),
            ),
          ),
          const SizedBox(width: 3.5),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      ManageVibration.vibrate();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ImageGalleryPage(
                            images: media,
                            initialIndex: 1,
                          ),
                        ),
                      );
                    },
                    child: CachedNetworkImage(
                      imageUrl: media[1],
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                ),
                const SizedBox(height: 3),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      ManageVibration.vibrate();
                      showDialog(
                        context: context,
                        builder: (context) {
                          return ShowAllImages(
                            images: [],
                            imagesUrls: media,
                            onRemoveImage: (image) {},
                          );
                        },
                      );
                    },
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: CachedNetworkImage(
                            imageUrl: media[2],
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ),
                        if (media.length > 3)
                          Container(
                            color: Colors.black54,
                            child: Center(
                              child: Text(
                                "+${media.length - 3}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }
  }

  showReplies() {
    return bottomSheet(
        context: context,
        isScrollControlled: true,
        widget: BlocProvider.value(
          value: serviceLocator<SocialPostsCubit>()
            ..loadCommentRepliesData(
                context: context,
                commentId: widget.comment?.reply ?? '',
                comment: widget.comment),
          child: CommentReplies(
            replies: const [],
            postId: widget.postId ?? '',
            commentId: widget.comment?.reply ?? '',
            onAddReply: (ReplyOnCommentParams params) async {
              var result =
                  await context.read<SocialPostsCubit>().replyOnComment(
                        params: ReplyOnCommentParams(
                            postId: params.postId,
                            content: params.content,
                            commentId: params.commentId),
                        from: 'feed',
                      );
              setState(() {});
              return result;
            },
            onDeleteReply: (String id) async {
              return await context.read<SocialPostsCubit>().deleteComment(
                  context: context,
                  commentId: id,
                  postId: widget.postId ?? '',
                  from: 'details');
            },
            from: 'details',
            onEditComment: (PostCommentParams params) async {
              var result = await context
                  .read<SocialPostsCubit>()
                  .editComment(params: params);
              return result;
            },
          ),
        ));
  }

  Widget _buildCommentCard(
      {required CommentEntity comment,
      required Function(ReplyOnCommentParams) onCommentReply,
      required Function(PostCommentParams params) onEditComment,
      required dynamic Function(String) onDeleteComment,
      required dynamic Function(String) onDeleteReply}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CommentCard(
            // onEditComment: (p0) {},
            comment: comment,
            onAddReply: (ReplyOnCommentParams params) async {
              var result = await onCommentReply(params);
              setState(() {});
              return result;
            },
            onDeleteComment: (String id) => onDeleteComment(id),
            onDeleteReply: (String id) => onDeleteReply(id),
            from: 'feed',
            onEditComment: (PostCommentParams params) => onEditComment(params),
          ),
        ),
        if (comment.repliesCount != 0)
          Container(
              margin: const EdgeInsets.only(left: 30),
              child: TextAppButton(
                  label: 'show ${comment.repliesCount} replies',
                  onPressed: () {
                    ManageVibration.vibrate();
                  }))
      ],
    );
  }
}
