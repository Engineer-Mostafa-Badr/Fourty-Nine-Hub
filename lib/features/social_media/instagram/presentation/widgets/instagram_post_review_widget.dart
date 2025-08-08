import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/extensions/context_extension.dart';
import '../../../../../core/utils/format_numbers.dart';
import '../../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';
import '../../domain/entities/instagram_post_entity.dart';
import 'description_post.dart';
import 'icon_action_post_insta.dart';
import 'liked_by_widget.dart';
import '../../../../../res/style/styles.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';

class InstagramPostReviewWidget extends StatelessWidget {
  const InstagramPostReviewWidget({
    super.key,
    required this.posts,
    required this.currentPost,
  });

  final List<InstagramPostEntity> posts;
  final int currentPost;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconsActionPostInsta(
          posts: posts,
          currentPost: currentPost,
          // instagramPostEntity: posts[currentPost],
        ),
        const SizedBox(
          height: 10,
        ),
        if (posts[currentPost].lastLikeEntity != null)
          LikedByWidget(
            imageUrl: posts[currentPost].lastLikeEntity!.profilePic,
            name: posts[currentPost].lastLikeEntity!.userId ==
                    context.read<UserCubit>().state.data!.id
                ? 'You'
                : posts[currentPost].lastLikeEntity!.username,
            others: posts[currentPost].likesCounter - 1,
          ),
        if (posts[currentPost].likesCounter != 0)
          const SizedBox(
            height: 10,
          ),
        DescriptionPost(
          instagramPostEntity: posts[currentPost],
        ),
        const Sizer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Label(
            text: FormatDate().fromatDateLikeMonthDay(
                // context, '2025-04-05T22:39:39.466Z'),
                context,
                posts[currentPost].createdAt!),
            style: Styles.mediumText(
              color: context.isDarkMode
                  ? const Color(0x66FFFFFF)
                  : const Color(0x66000000),
            ),
          ),
        ),
      ],
    );
  }
}
