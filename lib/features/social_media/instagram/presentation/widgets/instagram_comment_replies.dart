import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/cubit/instagram_cubit.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/instagram_reply_card.dart';
import 'package:fourtyninehub/features/social_media/social_posts/data/models/comment_model.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/comment_entity.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/add_reply_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/post_comment_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/entities/twitter_user_entity.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/twitter_report_usecase.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../../common/widgets/stateless/buttons/iconAppButton.dart';
import '../../../../../../common/widgets/stateless/images/profile_image.dart';
import '../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../res/style/styles.dart';
import '../../../../../core/widget/custom_scaffold.dart';

class InstagramCommentReplies extends StatefulWidget {
  // final List<CommentEntity> replies;
  final String commentId;
  final String postId;
  final Function(ReplyOnCommentParams) onAddReply;
  final Function(PostCommentParams) onEditComment;
  final Function(String) onDeleteReply;

  const InstagramCommentReplies({
    super.key,
    required this.onAddReply,
    required this.commentId,
    required this.postId,
    required this.onEditComment,
    required this.onDeleteReply,
  });

  @override
  State<InstagramCommentReplies> createState() =>
      _InstagramCommentRepliesState();
}

class _InstagramCommentRepliesState extends State<InstagramCommentReplies> {
  final replyTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<InstagramCubit>(
      create: (_) => serviceLocator()..loadReplies(context, widget.commentId),
      child: BlocBuilder<InstagramCubit, InstagramState>(
          builder: (context, state) {
        final controller = context.read<InstagramCubit>();
        return CustomScaffold(
          appBar: AppBar(
            backgroundColor: context.isDarkMode
                ? AppColors.DARK_BLUE_COLOR.withOpacity(0.07)
                : AppColors.LIGHT_COLOR,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.grey),
            title: Label(
                text:
                    '${controller.repliesPagingController.itemList?.length ?? 0} ${LocaleKeys.replies.localize}',
                style: Styles.mediumText()),
            leading: IconButton(
                onPressed: () => context.pop(), icon: const Icon(Icons.clear)),
            centerTitle: true,
          ),
          body: Column(
            children: [
              Expanded(
                child: PagedListView<int, CommentEntity>(
                  padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 5),
                  pagingController: controller.repliesPagingController,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  builderDelegate: PagedChildBuilderDelegate<CommentEntity>(
                      noItemsFoundIndicatorBuilder: (context) {
                        print(controller
                            .repliesPagingController.itemList?.length);
                        return Padding(
                            padding: const EdgeInsets.only(top: 200),
                            child: Center(
                              child: Text(
                                LocaleKeys.noReplied.localize,
                                style: TextStyle(
                                  color: context.isDarkMode
                                      ? AppColors.LIGHT_GRAY_COLOR
                                      : Colors.black,
                                  fontSize: 18,
                                ),
                              ),
                            ));
                      },
                      itemBuilder: (context, item, index) {
                        return _buildCommentCard(
                            reply: controller
                                .repliesPagingController.itemList![index],
                            onDeleteComment: (String id) async {
                              var result = await widget.onDeleteReply(id);
                              if (result == true) {
                                controller.commentsPagingController.itemList
                                    ?.removeWhere((e) => e.id == id);
                                setState(() {});
                              }
                            },
                            onDeleteReply: (String id) async {
                              var result = await widget.onDeleteReply(id);
                              if (result == true) {
                                controller.repliesPagingController.itemList
                                    ?.removeWhere((e) => e.id == id);
                                setState(() {});
                              }
                            },
                            function: () {
                              controller.replyOnComment(
                                params: ReplyOnCommentParams(
                                  postId: controller.repliesPagingController
                                      .itemList![index].post,
                                  commentId: controller.repliesPagingController
                                      .itemList![index].id,
                                  content: replyTextController.text,
                                ),
                              );
                            });
                      },
                      noMoreItemsIndicatorBuilder: (context) => Container(),
                      firstPageProgressIndicatorBuilder: (context) => Container(
                          margin: const EdgeInsets.only(top: 150),
                          child: const CupertinoActivityIndicator()),
                      newPageProgressIndicatorBuilder: (context) =>
                          const CupertinoActivityIndicator()),
                ),
              ),
              Container(
                  height: kToolbarHeight,
                  decoration: BoxDecoration(
                    color: context.isDarkMode
                        ? Colors.transparent
                        : AppColors.LIGHT_COLOR,
                  ),
                  child: Row(
                    children: [
                      const ProfileImage(
                        accountId: 0,
                        userId: '',
                      ),
                      const Sizer(),
                      Expanded(
                          child: TextFormField(
                        maxLines: null,
                        controller: replyTextController,
                        onChanged: (v) {
                          setState(() {});
                        },
                        style: Styles.headerText(fontSize: 26),
                        decoration: InputDecoration(
                          fillColor: context.isDarkMode
                              ? AppColors.DARK_BLUE_COLOR.withOpacity(0.07)
                              : AppColors.LIGHT_COLOR,
                          contentPadding: const EdgeInsets.all(5),
                          hintText: '${LocaleKeys.typeYourReply.localize} ....',
                          hintStyle: Styles.mediumText(),
                        ),
                      )),
                      const Sizer(),
                      if (replyTextController.text.isNotEmpty)
                        IconAppButton(
                          icon: Icons.send,
                          isCircle: true,
                          size: 20,
                          onPressed: () async {
                            CommentEntity data = await widget.onAddReply(
                              ReplyOnCommentParams(
                                  postId: widget.postId,
                                  content: replyTextController.text,
                                  commentId: widget.commentId),
                            );
                            final user = context.read<UserCubit>().state.data;
                            print("add");
                            controller.repliesPagingController.itemList?.insert(
                              0,
                              CommentModel(
                                id: data.id,
                                content: replyTextController.text,
                                post: widget.postId,
                                createdAt: DateTime.now(),
                                loveCount: data.loveCount,
                                angryCount: data.angryCount,
                                likesCount: data.likesCount,
                                repliesCount: data.repliesCount,
                                sadCount: data.sadCount,
                                wowCount: data.wowCount,
                                totalCount: data.totalCount,
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
                            print("add");
                            replyTextController.clear();
                            FocusScope.of(context).unfocus();
                            setState(() {});
                          },
                        )
                    ],
                  )),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildCommentCard({
    required CommentEntity reply,
    required Function(String) onDeleteComment,
    required Function(String) onDeleteReply,
    required Function() function,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InstagramReplyCard(
          reply: reply,
          onDeleteReply: (String id) => onDeleteReply(id),
          onReplyReact: (String id) {},
          onReport: (TwitterReportParams params) {},
          onEditComment: (PostCommentParams params) =>
              widget.onEditComment(params),
          function: function,
        ),
      ],
    );
  }
}
