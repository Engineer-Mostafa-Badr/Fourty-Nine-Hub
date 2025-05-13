import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/loading/custom_loading.dart';
import 'package:fourtyninehub/core/widget/custom_failure_widget.dart';
import 'package:fourtyninehub/core/widget/custom_scaffold.dart';
import 'package:fourtyninehub/features/social_media/instagram/data/models/comment_instagram_model.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/entities/instagram_post_entity.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/entities/single_post_instagram_entity.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/cubit/single_post_instagram_cubit/single_post_instagram_cubit.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/post_instagram_widget.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:go_router/go_router.dart';

class SinglePostInstagramView extends StatelessWidget {
  const SinglePostInstagramView({super.key, required this.postId});

  final String postId;

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: AppBar(
        title: BlocBuilder<SinglePostInstagramCubit, SinglePostInstagramState>(
          builder: (context, state) {
            return Label(
              text: state.postData?.owner.username ?? '',
              style: Styles.mediumText(
                fontSize: 32,
                height: 1.22,
              ),
            );
          },
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.close_rounded,
            color: Colors.black,
          ),
          onPressed: () {
            context.pop();
          },
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<SinglePostInstagramCubit, SinglePostInstagramState>(
        builder: (context, state) {
          if (state.status.isLoading || state.status.isInitial) {
            return const CustomLoading();
          }
          if (state.status.isFailure) {
            return CustomFailureWidget(
              title: getFailureMessage(
                state.failure ?? UnknownFailure(''),
                context,
              ),
              onPressed: () {
                context.read<SinglePostInstagramCubit>().getPost(postId);
              },
            );
          }
          return SinglePostInstagramViewBody(
            post: state.postData!,
          );
        },
      ),
    );
  }
}

class SinglePostInstagramViewBody extends StatelessWidget {
  const SinglePostInstagramViewBody({
    super.key,
    required this.post,
  });

  final SinglePostInstagramEntity post;

  @override
  Widget build(BuildContext context) {
    return PostInstagramWidget(
      posts: [],
      currentIndex: 0,
      instagramPostEntity: InstagramPostEntity(
        id: post.id,
        commentsCounter: post.commentsCounter,
        shareCounter: post.shearsCounter,
        createdAt: DateTime.now().toString(),
        // post.createdAt,
        content: post.content,
        countOfStory: post.owner.hasStory,
        favoritesCounter: post.favoritesCounter,
        firstName: post.owner.firstName,
        lastName: post.owner.lastName,
        username: post.owner.username,
        verifiedBadge: post.owner.verifiedBadge,
        hashtags: post.hashtags,
        isFriend: false,
        // post.isFriend,
        likesCounter: post.likesCounter,
        locationName: null,
        // post.locationName,
        medias: post.mediaUrls,
        profilePictureUrl: post.owner.profilePictureUrl,
        userId: post.owner.id,
        userTags: List<InstagramPostUserTagEntity>.from(
            post.taggedUsers.map((t) => InstagramPostUserTagEntity(
                  firstName: t.firstName,
                  lastName: t.lastName,
                  profilePictureUrl: t.profilePictureUrl,
                  username: t.username,
                ))),
        comments: List<CommentInstagramModel>.from(
          post.comments.map(
            (c) => CommentInstagramModel(
              id: c.id,
              content: c.content,
              username: c.owner.username,
              userId: c.owner.id,
              createdAt: c.createdAt,
              likesCounter: 0,
              // c.likesCounter,
              repliesCount: 0,
              // c.repliesCount,
              replies: List<CommentInstagramModel>.from(
                c.replies.map(
                  (r) => CommentInstagramModel(
                    id: r.id,
                    content: r.content,
                    username: r.owner.username,
                    userId: r.owner.id,
                    createdAt: r.createdAt,
                    likesCounter: 0,
                    // r.likesCounter,
                    repliesCount: 0,
                    // r.repliesCount,
                    replies: [],
                  ),
                ),
              ),
            ),
          ),
        ),
        isFollow: post.owner.isFollow,
        isLiked: post.isLiked,
        lastLikeEntity: post.lastLikeEntity,
      ),
    );
  }
}
