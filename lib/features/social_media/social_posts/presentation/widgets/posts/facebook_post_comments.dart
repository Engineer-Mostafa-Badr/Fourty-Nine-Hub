import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/widget/olx_pagination/banner.dart';
import 'package:fourtyninehub/core/widget/olx_pagination/olx_pagination_widget.dart';
import '../../../../../../core/extensions/string_extension.dart';
import '../../../../../../core/localization/locale_keys.g.dart';
import '../../../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';
import '../../../data/models/comment_model.dart';
import '../../../domain/usecases/add_reply_usecase.dart';
import '../../cubit/social_posts_cubit.dart';
import '../../../../twitter/domain/entities/twitter_user_entity.dart';
import 'package:go_router/go_router.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

import '../../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../../common/widgets/stateless/buttons/iconAppButton.dart';
import '../../../../../../common/widgets/stateless/buttons/text_button.dart';
import '../../../../../../common/widgets/stateless/images/profile_image.dart';
import '../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../core/widget/custom_scaffold.dart';
import '../../../../../../res/style/styles.dart';
import '../../../domain/entities/comment_entity.dart';
import '../../../domain/usecases/post_comment_usecase.dart';
import 'comment_card.dart';
import '../../../../../../helpers/manage_vibration.dart';

class FacebookPostComments extends StatefulWidget {
  // final List<CommentEntity> comments;
  final String postId;
  final String from;
  final Function(PostCommentParams) onAddComment;
  final Function(ReplyOnCommentParams) onCommentReply;
  final Function(PostCommentParams) onEditComment;
  final Function(String) onDeleteComment;
  final Function(String) onDeleteReply;
  const FacebookPostComments(
      {super.key,
      required this.postId,
      // required this.comments,
      required this.onAddComment,
      required this.onCommentReply,
      required this.onDeleteComment,
      required this.onDeleteReply,
      required this.from,
      required this.onEditComment});

  @override
  State<FacebookPostComments> createState() => _FacebookPostCommentsState();
}

class _FacebookPostCommentsState extends State<FacebookPostComments> {
  final commentTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SocialPostsCubit, SocialPostsState>(
        builder: (context, state) {
      final controller = context.read<SocialPostsCubit>();
      final user = context.read<UserCubit>().state.data;
      return CustomScaffold(
        appBar: AppBar(
          toolbarHeight: 120.h,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.grey),
          surfaceTintColor: Colors.transparent,
          title: Label(
              text:
                  '${controller.postComments.length} ${LocaleKeys.comments.localize}',
              style: Styles.mediumText()),
          leading: IconButton(
              onPressed: () => context.pop(), icon: const Icon(Icons.clear)),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(child: OlxPaginationWidget(
              scrollController: ScrollController(),
              itemsPerPage: 2,
              loadPage: (page) async {
                {
                  controller.getPostComments(context: context,postId: widget.postId);
                }
              },
              banners: bannersList,
              items: List.generate(
                controller.postComments.length,
                    (index) {
                  return BlocConsumer<SocialPostsCubit, SocialPostsState>(
                    listener: (context, state) {},
                    builder: (context, state) {
                      return _buildCommentCard(
                        comment: controller.postComments[index],
                        onDeleteComment: (String id) async {
                          var result = await widget.onDeleteComment(id);
                          if (result == true) {
                            controller.postComments.removeWhere((e) => e.id == id);
                            setState(() {});
                          }
                        },
                        onDeleteReply: (String id) => widget.onDeleteReply(id),
                      );
                    },
                  );
                },
              ),
            )),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              margin: const EdgeInsets.only(top: 12),
              decoration: BoxDecoration(
                color: context.isDarkMode?AppColors.QUANTITY_COLOR:Colors.grey.shade200, // Light background like Facebook
                borderRadius: BorderRadius.circular(25), // Fully rounded
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
                        hintText: 'Write a comment...',
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
                        fillColor: context.isDarkMode?AppColors.QUANTITY_COLOR:Colors.grey.shade200,
                        border: InputBorder.none, // Removes border
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 8,horizontal:8),
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
                        FocusScope.of(context).unfocus();
                        setState(() {});
                      },
                      child: Icon(Icons.send, size: 25, color: context.isDarkMode?AppColors.SECONDARY_COLOR:AppColors.PRIMARY_COLOR),
                    ),
                ],
              ),
            )
          ],
        ),
      );
    });
  }

  Widget _buildCommentCard(
      {required CommentEntity comment,
      required Function(String) onDeleteComment,
      required Function(String) onDeleteReply}) {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommentCard(
            comment: comment,
            onAddReply: (ReplyOnCommentParams params) =>
                widget.onCommentReply(params),
            onDeleteComment: (String id) => onDeleteComment(id),
            onDeleteReply: (String id) => onDeleteReply(id),
            from: widget.from,
            onEditComment: (PostCommentParams params) =>
                widget.onEditComment(params),
          ),
          if (comment.repliesCount != 0)
            Container(
                margin: const EdgeInsets.only(left: 30),
                child: TextAppButton(
                    label:
                        '${LocaleKeys.show.localize} ${comment.repliesCount} ${LocaleKeys.replies.localize}',
                    onPressed: () {

        ManageVibration.vibrate();
                    }))
        ],
      ),
    );
  }
}