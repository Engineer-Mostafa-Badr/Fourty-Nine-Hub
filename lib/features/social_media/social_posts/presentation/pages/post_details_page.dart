// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/read_more_label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/olx_pagination/banner.dart';
import 'package:fourtyninehub/core/widget/olx_pagination/olx_pagination_widget.dart';
import 'package:fourtyninehub/features/ads_feature/ad_details/presentation/pages/image_gallary_viewer.dart';
import 'package:fourtyninehub/features/social_media/create_post/presentation/widgets/show_all_images.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/build_facebook_header.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/build_reactions_buttons.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import '../../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';
import '../../domain/entities/post_entity.dart';
import '../../domain/usecases/add_reply_usecase.dart';
import '../cubit/social_posts_cubit.dart';
import '../../../twitter/domain/entities/twitter_user_entity.dart';
import '../../../../../common/widgets/stateless/images/profile_image.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/widget/custom_scaffold.dart';
import '../../../../../res/style/styles.dart';
import '../../data/models/comment_model.dart';
import '../../domain/entities/comment_entity.dart';
import '../../domain/usecases/post_comment_usecase.dart';
import '../../domain/usecases/post_react_usecase.dart';
import '../widgets/posts/comment_card.dart';
import '../../../../../core/widget/custom_circular_progress_indicator.dart';
import '../../../../../helpers/manage_vibration.dart';

class PostDetailsPage extends StatefulWidget {
  // final PostEntity post;
  final List<CommentEntity> comments;
  final String postId;
  final Function(PostCommentParams) onAddComment;
  final Function(PostReactParams) onReact;
  final Function(String) showPostComments;
  final Function(PostEntity) showPostDetails;
  final Function(PostCommentParams) onEditComment;
  final Function(String) deletePost;
  final Function(String) hidePost;
  final Function(ReplyOnCommentParams) onCommentReply;
  final Function(String) onDeleteComment;
  final Function(String) onDeleteReply;
  const PostDetailsPage({
    super.key,
    required this.postId,
    required this.onAddComment,
    required this.onReact,
    required this.showPostComments,
    required this.showPostDetails,
    required this.comments,
    required this.deletePost,
    required this.hidePost,
    required this.onCommentReply,
    required this.onDeleteComment,
    required this.onDeleteReply,
    required this.onEditComment,
  });

  @override
  State<PostDetailsPage> createState() => _PostDetailsPageState();
}

class _PostDetailsPageState extends State<PostDetailsPage> {
  final commentTextController = TextEditingController();
  var scrollController = ScrollController();

  void handlePostReact(PostEntity post, String newReaction) {
    String? currentReaction;
    if (post.isLikes == true) {
      currentReaction = 'like';
    } else if (post.isWow == true)
      currentReaction = 'wow';
    else if (post.isHaha == true)
      currentReaction = 'haha';
    else if (post.isLove == true)
      currentReaction = 'love';
    else if (post.isSad == true)
      currentReaction = 'sad';
    else if (post.isAngry == true) currentReaction = 'angry';
    if (currentReaction == newReaction) {
      _decrementReactionCount(post, newReaction);
      return;
    }
    if (currentReaction != null) {
      _decrementReactionCount(post, currentReaction);
    }
    _incrementReactionCount(post, newReaction);
  }

  void _incrementReactionCount(PostEntity post, String reaction) {
    switch (reaction) {
      case 'like':
      case 'likes':
        post.likesCount = (post.likesCount ?? 0) + 1;
        break;
      case 'wow':
        post.wowCount = (post.wowCount ?? 0) + 1;
        break;
      case 'haha':
        post.hahaCount = (post.hahaCount ?? 0) + 1;
        break;
      case 'love':
        post.loveCount = (post.loveCount ?? 0) + 1;
        break;
      case 'sad':
        post.sadCount = (post.sadCount ?? 0) + 1;
        break;
      case 'angry':
        post.angryCount = (post.angryCount ?? 0) + 1;
        break;
    }
  }

  void _decrementReactionCount(PostEntity post, String reaction) {
    switch (reaction) {
      case 'like':
      case 'likes':
        post.likesCount = (post.likesCount ?? 0) - 1;
        break;
      case 'wow':
        post.wowCount = (post.wowCount ?? 0) - 1;
        break;
      case 'haha':
        post.hahaCount = (post.hahaCount ?? 0) - 1;
        break;
      case 'love':
        post.loveCount = (post.loveCount ?? 0) - 1;
        break;
      case 'sad':
        post.sadCount = (post.sadCount ?? 0) - 1;
        break;
      case 'angry':
        post.angryCount = (post.angryCount ?? 0) - 1;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<UserCubit>().state.data;
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        // Send postDetails before actually popping
        Navigator.of(context).pop(
          context.read<SocialPostsCubit>().state.postDetails,
        );
        return false; // Prevent default pop, since we already handled it
      },
      child: CustomScaffold(
        appBar: AppBar(
          elevation: 0,
          toolbarHeight: 50.h,
          iconTheme: const IconThemeData(color: Colors.grey),
          title: Label(text: 'Post', style: Styles.mediumText()),
          leading: IconButton(
              onPressed: () => Navigator.of(context)
                  .pop(context.read<SocialPostsCubit>().state.postDetails),
              icon: const Icon(Icons.clear)),
          centerTitle: true,
        ),
        body: BlocConsumer<SocialPostsCubit, SocialPostsState>(
            listener: (context, state) {},
            builder: (context, state) {
              final controller = context.read<SocialPostsCubit>();

              if (controller.onLoadingPostDetails) {
                return const Center(
                  child: CustomCircularProgressIndicator(),
                );
              } else {
                num totalReactions = (state.postDetails?.likesCount ?? 0) +
                    (state.postDetails?.hahaCount ?? 0) +
                    (state.postDetails?.loveCount ?? 0) +
                    (state.postDetails?.wowCount ?? 0) +
                    (state.postDetails?.sadCount ?? 0) +
                    (state.postDetails?.angryCount ?? 0);
                return Column(
                  children: [
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async {},
                        child: Column(
                          children: [
                            Column(
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
                                        child: _buildImageGrid(
                                            context, state.postDetails!.images),
                                      ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      bottom: 8, right: 8, left: 8),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            if ((state.postDetails
                                                        ?.angryCount ??
                                                    0) >
                                                0)
                                              Image.asset(
                                                Assets.angry,
                                                width: 20,
                                                height: 20,
                                              ),
                                            if ((state.postDetails?.sadCount ??
                                                    0) >
                                                0)
                                              Image.asset(
                                                Assets.sad,
                                                width: 20,
                                                height: 20,
                                              ),
                                            if ((state.postDetails?.wowCount ??
                                                    0) >
                                                0)
                                              Image.asset(
                                                Assets.wow,
                                                width: 20,
                                                height: 20,
                                              ),
                                            if ((state.postDetails?.loveCount ??
                                                    0) >
                                                0)
                                              Image.asset(
                                                Assets.heart,
                                                width: 20,
                                                height: 20,
                                              ),
                                            if ((state.postDetails?.hahaCount ??
                                                    0) >
                                                0)
                                              Image.asset(
                                                Assets.haha,
                                                width: 20,
                                                height: 20,
                                              ),
                                            if ((state.postDetails
                                                        ?.likesCount ??
                                                    0) >
                                                0)
                                              Image.asset(
                                                Assets.like,
                                                width: 20,
                                                height: 20,
                                              ),
                                            if (totalReactions > 0)
                                              Text(
                                                '$totalReactions',
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                  color: context.isDarkMode
                                                      ? Colors.white60
                                                      : const Color(0xFF65676B),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    // Align the items to the start
                                    children: [
                                      // Like button
                                      // Row(
                                      //   children: [
                                      //     SvgPicture.asset(Assets.likeIcon), // Like Icon
                                      //     SizedBox(width: 4.w), // Space between icon and text
                                      //     Label(
                                      //       text: LocaleKeys.like.localize,
                                      //       style: const TextStyle(
                                      //           color: AppColors.black,
                                      //           fontSize: 14,
                                      //           fontWeight: FontWeight.w400),
                                      //     ), // Like Text
                                      //   ],
                                      // ),
                                      SizedBox(
                                        child: BuildReactionsButtons(
                                            post: state.postDetails!,
                                            from: "posts",
                                            handleReaction: (String reaction) {
                                              handlePostReact(
                                                  state.postDetails!, reaction);
                                            }),
                                      ),
                                      const SizedBox(
                                          width: 16), // Space between buttons

                                      // Send button
                                      Row(
                                        children: [
                                          SvgPicture.asset(
                                            Assets.sendIcon,
                                            // ignore: deprecated_member_use
                                            color: context.isDarkMode
                                                ? Colors.white
                                                : null,
                                          ),
                                          // Send Icon
                                          SizedBox(width: 8.w),
                                          // Space between icon and text
                                          Label(
                                            text: LocaleKeys.send.localize,
                                            style: TextStyle(
                                                color: AppColors.getTextColor(
                                                    context),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400),
                                          ),
                                          // Send Text
                                        ],
                                      ),
                                      const SizedBox(
                                          width: 16), // Space between buttons

                                      // Share button
                                      Row(
                                        children: [
                                          SvgPicture.asset(Assets.shareIcon,
                                              // ignore: deprecated_member_use
                                              color: context.isDarkMode
                                                  ? Colors.white
                                                  : null),
                                          // Share Icon
                                          SizedBox(width: 8.w),
                                          // Space between icon and text
                                          Label(
                                            text: LocaleKeys.share.localize,
                                            style: TextStyle(
                                                color: AppColors.getTextColor(
                                                    context),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400),
                                          ),
                                          // Share Text
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const Divider(),
                              ],
                            ),
                            Expanded(
                              child: OlxPaginationWidget(
                                  items: List.generate(
                                      controller.postComments.length,
                                      (i) => CommentCard(
                                          comment: controller.postComments[i],
                                          onAddReply: (data) =>
                                              controller.replyOnComment(
                                                  params: data,
                                                  from: 'comments'),
                                          onDeleteComment: (data) =>
                                              controller.deleteComment(
                                                  context: context,
                                                  commentId: data,
                                                  postId: state.postDetails!.id,
                                                  from: 'details'),
                                          onDeleteReply: (s) =>
                                              controller.deleteComment(
                                                  context: context,
                                                  commentId: s,
                                                  postId: state.postDetails!.id,
                                                  from: 'details'),
                                          from: 'details',
                                          onEditComment: (data) => controller
                                              .editComment(params: data))),
                                  itemsPerPage: 2,
                                  loadPage: (page) async {
                                    {
                                      controller.getPostComments(
                                          context: context,
                                          postId: widget.postId);
                                    }
                                  },
                                  banners: bannersList,
                                  scrollController: scrollController),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      margin: const EdgeInsets.only(top: 12, bottom: 12),
                      decoration: BoxDecoration(
                        color: context.isDarkMode
                            ? AppColors.QUANTITY_COLOR
                            : Colors.grey
                                .shade200, // Light background like Facebook
                        borderRadius:
                            BorderRadius.circular(25), // Fully rounded
                      ),
                      child: Row(
                        children: [
                          ProfileImage(
                            accountId: 0,
                            fromProfile: true,
                            imageURL: user?.profilePicture,
                            userId: '',
                            size: 35, // Small, like FB
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              controller: commentTextController,
                              maxLines: null,
                              style: const TextStyle(fontSize: 15),
                              decoration: InputDecoration(
                                hintText: context.isArabic
                                    ? 'اكتب تعليق...'
                                    : 'Write a comment...',
                                hintStyle:
                                    TextStyle(color: Colors.grey, fontSize: 15),
                                fillColor: context.isDarkMode
                                    ? AppColors.QUANTITY_COLOR
                                    : Colors.grey.shade200,
                                border: InputBorder.none, // Removes border
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                focusedErrorBorder: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 8),
                              ),
                              onChanged: (_) => setState(() {}),
                            ),
                          ),
                          if (commentTextController.text.isNotEmpty)
                            GestureDetector(
                              onTap: () async {
                                ManageVibration.vibrate();
                                CommentEntity data = await widget.onAddComment(
                                  PostCommentParams(
                                    postId: widget.postId,
                                    content: commentTextController.text,
                                  ),
                                );
                                controller.postComments.insert(
                                  0,
                                  CommentModel(
                                    id: data.id,
                                    content: commentTextController.text,
                                    post: widget.postId,
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
                                commentTextController.clear();
                                // ignore: use_build_context_synchronously
                                FocusScope.of(context).unfocus();
                                setState(() {});
                              },
                              child: Icon(Icons.send,
                                  size: 25,
                                  color: context.isDarkMode
                                      ? AppColors.SECONDARY_COLOR
                                      : AppColors.PRIMARY_COLOR),
                            ),
                        ],
                      ),
                    )
                  ],
                );
              }
            }),
      ),
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
}
