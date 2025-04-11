import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:fourtyninehub/core/utils/format_numbers.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/cubit/comment_instagram_cubit/comments_instagram_cubit.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/pages/comment_instagram_view.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/icon_and_value_widget.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/cubit/social_posts_cubit.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';

class IconsActionPostInsta extends StatelessWidget {
  const IconsActionPostInsta({
    super.key,
    required this.likes,
    required this.comments,
    required this.shares,
    required this.postId,
  });

  final num likes;
  final num comments;
  final num shares;
  final String postId;

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
            value: FormatNumbers().formatNumber(likes),
            onPressed: () {},
          ),
          const SizedBox(
            width: 9,
          ),
          IconAndValueWidget(
            icon: Image.asset(
              Assets.instagramCommentIcon,
              width: 30,
            ),
            value: FormatNumbers().formatNumber(comments),
            onPressed: () {
              // context.pushNamed(
              //   Routes.INSTAGRAMCOMMENT,
              //   extra: postId,
              // );
              bottomSheet(
                context: context,
                isScrollControlled: true,
                padding: 0,
                widget: BlocProvider(
                  create: (context) => serviceLocator<CommentsInstagramCubit>()
                    ..getComments(postId),
                  child: CommentInstagramView(
                    postId: postId,
                  ),
                ),
              );
              // showBottomSheet(
              //   backgroundColor: Colors.transparent,
              //   context: context,
              //   builder: (context) {
              //     return Padding(
              //       padding: EdgeInsets.only(
              //         bottom: MediaQuery.of(context).viewInsets.bottom,
              //       ),
              //       child: DraggableScrollableSheet(
              //         maxChildSize: 0.5,
              //         initialChildSize: 0.5,
              //         minChildSize: 0.2,
              //         builder: (context, scrollController) {
              //           return const CommentInstagramView();
              //         },
              //       ),
              //     );
              //   },
              // );
            },
          ),
          // Image.asset(
          //   Assets.instagramCommentIcon,
          //   width: 30,
          // ),
          // const Sizer(
          //   width: 6,
          // ),
          // const Text(
          //   "34.6",
          //   style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900),
          // ),
          const SizedBox(
            width: 9,
          ),
          IconAndValueWidget(
            icon: Image.asset(
              Assets.instagramSharePostIcon,
              width: 30,
            ),
            value: FormatNumbers().formatNumber(shares),
            onPressed: () {},
          ),
          // Image.asset(
          //   Assets.instagramSharePostIcon,
          //   width: 30,
          // ),
          // const Sizer(
          //   width: 6,
          // ),
          // const Text(
          //   "34.6",
          //   style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900),
          // ),
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
