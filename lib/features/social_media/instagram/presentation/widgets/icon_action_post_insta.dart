import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../common/widgets/dialogs/show_bottom_sheet.dart';
import '../../../../../core/extensions/context_extension.dart';
import '../../../../../core/utils/format_numbers.dart';
import '../cubit/comment_instagram_cubit/comments_instagram_cubit.dart';
import '../pages/comment_instagram_view.dart';
import 'icon_and_value_widget.dart';
import '../../../../../res/assets/assets.dart';
import '../../../../../service_locator/service_locator.dart';

import '../../domain/entities/instagram_post_entity.dart';
import '../cubit/like_post_instagram/like_post_instagram_cubit.dart';
import '../cubit/save_post_instagram/save_post_instagram_cubit.dart';
import '../../../../../helpers/manage_vibration.dart';

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
      ManageVibration.vibrate();
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
      ManageVibration.vibrate();
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
            onPressed: () {

      ManageVibration.vibrate();
            },
          ),
          const Spacer(),
          BlocProvider(
            create: (context) => serviceLocator<SavePostInstagramCubit>(),
            child: BlocBuilder<SavePostInstagramCubit, SavePostInstagramState>(
              builder: (context, state) {
                final cubit = context.read<SavePostInstagramCubit>();
                return GestureDetector(
                  onTap: () {
      ManageVibration.vibrate();
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