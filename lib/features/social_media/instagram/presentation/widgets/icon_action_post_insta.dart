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

class IconsActionPostInsta extends StatelessWidget {
  const IconsActionPostInsta({
    super.key,
    required this.instagramPostEntity,
  });

  final InstagramPostEntity instagramPostEntity;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          IconAndValueWidget(
            icon: const Icon(
              Icons.favorite,
              color: Color(0xffFE0135),
            ),
            value: FormatNumbers()
                .formatNumber(instagramPostEntity.likesCounter, useArabicNumerals: context.isArabic),
            onPressed: () {},
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
            value: FormatNumbers()
                .formatNumber(instagramPostEntity.commentsCounter, useArabicNumerals: context.isArabic),
            onPressed: () {
              bottomSheet(
                context: context,
                isScrollControlled: true,
                padding: 0,
                widget: BlocProvider(
                  create: (context) => serviceLocator<CommentsInstagramCubit>()
                    ..getComments(instagramPostEntity.id),
                  child: CommentInstagramView(
                    postId: instagramPostEntity.id,
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
            value: FormatNumbers()
                .formatNumber(instagramPostEntity.shearsCounter, useArabicNumerals: context.isArabic),
            onPressed: () {},
          ),
          const Spacer(),
          const Icon(
            Icons.bookmark_border_outlined,
            size: 22,
          )
        ],
      ),
    );
  }
}
