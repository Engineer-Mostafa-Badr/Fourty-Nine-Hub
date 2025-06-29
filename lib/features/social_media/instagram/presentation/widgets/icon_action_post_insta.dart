import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/utils/format_numbers.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/cubit/comment_instagram_cubit/comments_instagram_cubit.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/pages/comment_instagram_view.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/icon_and_value_widget.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';

import '../../domain/entities/instagram_post_entity.dart';
import '../cubit/like_post_instagram/like_post_instagram_cubit.dart';
import '../cubit/save_post_instagram/save_post_instagram_cubit.dart';

class IconsActionPostInsta extends StatelessWidget {
  const IconsActionPostInsta({
    super.key,
    // required this.instagramPostEntity,
    required this.posts,
    required this.currentPost,
  });

  // final InstagramPostEntity instagramPostEntity;
  final List<InstagramPostEntity> posts;
  final int currentPost;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          BlocProvider(
            create: (context) => serviceLocator<LikePostInstagramCubit>()..fetchLikePostInstagram(posts, currentPost),
            child: BlocBuilder<LikePostInstagramCubit, LikePostInstagramState>(
              builder: (context, state) {
                final cubit = context.read<LikePostInstagramCubit>();
                return IconAndValueWidget(
                  icon: state.posts![currentPost].isLiked
                      ? const Icon(
                          Icons.favorite,
                          color: Colors.red,
                        )
                      : const Icon(
                          Icons.favorite_border_rounded,
                          color: Colors.black,
                        ),
                  value: FormatNumbers().formatNumber(
                      state.posts![currentPost].likesCounter,
                      useArabicNumerals: context.isArabic),
                  onPressed: () {
                    cubit.likePostInstagram(
                      state.posts![currentPost].id,
                      state.posts![currentPost].likesCounter,
                      state.posts![currentPost].isLiked,
                      currentPost,
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(
            width: 9,
          ),
          IconAndValueWidget(
            icon: Image.asset(
              context.isDarkMode
                  ? Assets.instagramCommentIconDark
                  : Assets.instagramCommentIcon,
              width: 30,
            ),
            value: FormatNumbers().formatNumber(
                posts[currentPost].commentsCounter,
                useArabicNumerals: context.isArabic),
            onPressed: () {
              bottomSheet(
                context: context,
                isScrollControlled: true,
                padding: 0,
                widget: BlocProvider(
                  create: (context) => serviceLocator<CommentsInstagramCubit>()
                    ..getComments(posts[currentPost].id),
                  child: CommentInstagramView(
                    postId: posts[currentPost].id,
                  ),
                ),
              );
            },
          ),
          const SizedBox(
            width: 9,
          ),
          IconAndValueWidget(
            icon: Image.asset(
              context.isDarkMode
                  ? Assets.instagramSharePostIconDark
                  : Assets.instagramSharePostIcon,
              width: 30,
            ),
            value: FormatNumbers().formatNumber(
                posts[currentPost].shareCounter,
                useArabicNumerals: context.isArabic),
            onPressed: () {},
          ),
          const Spacer(),
          BlocProvider(
            create: (context) => serviceLocator<SavePostInstagramCubit>(),
            child: BlocBuilder<SavePostInstagramCubit, SavePostInstagramState>(
              builder: (context, state) {
                final cubit = context.read<SavePostInstagramCubit>();
                return GestureDetector(
                  onTap: () {
                    cubit.savePostInstagram(posts[currentPost].id);
                  },
                  child: Icon(
                    Icons.bookmark_border_outlined,
                    size: 22,
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
