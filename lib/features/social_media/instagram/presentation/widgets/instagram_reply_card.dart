import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/iconAppButton.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/cubit/instagram_cubit.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/comment_entity.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/post_comment_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/post_react_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/twitter_report_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/widgets/report_view.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../common/widgets/dialogs/show_bottom_sheet.dart';
import '../../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../../common/widgets/stateless/images/profile_image.dart';
import '../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../res/style/styles.dart';

class InstagramReplyCard extends StatefulWidget {
  final Color textColor;
  final CommentEntity reply;
  final Function(String) onReplyReact;
  final Function(String) onDeleteReply;
  final Function(PostCommentParams) onEditComment;
  final Function(TwitterReportParams) onReport;
  const InstagramReplyCard({
    super.key,
    this.textColor = Colors.black,
    required this.reply,
    required this.onReplyReact,
    required this.onReport,
    required this.onDeleteReply,
    required this.onEditComment,
  });

  @override
  State<InstagramReplyCard> createState() => _InstagramReplyCardState();
}

class _InstagramReplyCardState extends State<InstagramReplyCard> {
  final editTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<InstagramCubit>(
      create: (_) => serviceLocator(),
      child: BlocBuilder<InstagramCubit, InstagramState>(
          builder: (context, state) {
        final controller = context.read<InstagramCubit>();
        final user = context.read<UserCubit>().state.data;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 32,
            ),
            Row(
              children: [
                ProfileImage(
                  accountId: 0,
                  withBorder: false,
                  userId: '',
                  imageURL: widget.reply.user.image.isNotEmpty
                      ? widget.reply.user.image
                      : null,
                ),
                const Sizer(),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Label(
                        text: widget.reply.user.firstName,
                        style: Styles.mediumText(
                            fontWeight: FontWeight.bold,
                            color: context.isDarkMode
                                ? AppColors.SECONDARY_COLOR
                                : Colors.black)),
                    Label(
                        text: widget.reply.sinceTime,
                        style: Styles.smallText(
                            color: context.isDarkMode
                                ? AppColors.LIGHT_COLOR
                                : Colors.black)),
                  ],
                )),
                GestureDetector(
                  onTap: () {
                    bottomSheet(
                      context: context,
                      widget: _buildPostOptions(
                        isMyComment: widget.reply.user.id == user?.id,
                        post: widget.reply,
                      ),
                    );
                  },
                  child: Icon(
                    Icons.more_horiz_outlined,
                    color: context.isDarkMode
                        ? AppColors.LIGHT_COLOR
                        : Colors.black,
                    size: 20,
                  ),
                ),
              ],
            ),
            const Sizer(),
            Row(
              children: [
                const SizedBox(
                  width: 32,
                ),
                Label(
                  textAlign: TextAlign.start,
                  text: widget.reply.content,
                  style: Styles.mediumText(
                    color: context.isDarkMode
                        ? AppColors.LIGHT_COLOR
                        : Colors.black,
                  ),
                ),
              ],
            ),
            if (widget.reply.edit == true)
              Row(
                children: [
                  Expanded(
                      child: TextFormField(
                    maxLines: null,
                    controller: editTextController,
                    onChanged: (v) {
                      setState(() {});
                    },
                    style: Styles.headerText(fontSize: 26),
                    decoration: InputDecoration(
                      fillColor: context.isDarkMode
                          ? Colors.transparent
                          : Colors.white,
                      contentPadding: const EdgeInsets.all(5),
                      hintText: '${LocaleKeys.typeYourReply.localize} ....',
                      hintStyle: Styles.mediumText(),
                    ),
                  )),
                  const Sizer(),
                  if (editTextController.text.isNotEmpty)
                    IconAppButton(
                        icon: Icons.send,
                        size: 20,
                        isCircle: true,
                        onPressed: () async {
                          var result = await widget.onEditComment(
                              PostCommentParams(
                                  postId: widget.reply.id,
                                  content: editTextController.text));
                          if (result == true) {
                            widget.reply.content = editTextController.text;
                            widget.reply.edit = false;
                          }
                          setState(() {});
                        })
                ],
              ),
            const Sizer(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 32,
                ),
                InkWell(
                  onTap: () async {
                    if (widget.reply.isLove == true) {
                      var result = await controller.onCommentReact(
                          params: PostReactParams(
                              postId: widget.reply.id, react: 'love'));
                      if (result == true) {
                        widget.reply.isLove = false;
                        widget.reply.loveCount = (widget.reply.loveCount! - 1);
                        setState(() {});
                      } else {
                        showErrorMessage(
                          context,
                          getFailureMessage(
                            state.failure!,
                            context,
                          ),
                        );
                      }
                    } else {
                      var result = await controller.onCommentReact(
                          params: PostReactParams(
                              postId: widget.reply.id, react: 'love'));
                      if (result == true) {
                        widget.reply.isLove = true;
                        widget.reply.loveCount = (widget.reply.loveCount! + 1);
                        setState(() {});
                      } else {
                        showErrorMessage(
                          context,
                          getFailureMessage(
                            state.failure!,
                            context,
                          ),
                        );
                      }
                    }
                  },
                  child: Icon(
                    widget.reply.isLove == false
                        ? Icons.favorite_border
                        : Icons.favorite,
                    color:
                        widget.reply.isLove == false ? Colors.grey : Colors.red,
                  ),
                ),
                const SizedBox(
                  width: 4,
                ),
                Label(text: '${widget.reply.loveCount}'),
              ],
            ),
            const Sizer(),
          ],
        );
      }),
    );
  }

  Widget _buildPostOptions(
      {required bool isMyComment, required CommentEntity post}) {
    return SizedBox(
      height: isMyComment ? 150 : 80,
      child: Column(
        children: [
          if (!isMyComment)
            listTile(
                icon: Icons.report,
                iconColor: Colors.red,
                title: LocaleKeys.reportReply.localize,
                subTitle: LocaleKeys.youWillReportReply.localize,
                onTap: () async {
                  Future.delayed(const Duration(milliseconds: 200), () {
                    bottomSheet(
                        context: context,
                        widget: ReportView(
                          id: post.id,
                          categoryId: '66a3583454e6e337915514db',
                        ));
                  });
                }),
          if (isMyComment)
            listTile(
                icon: Icons.delete,
                iconColor:
                    context.isDarkMode ? AppColors.LIGHT_COLOR : Colors.black,
                title: LocaleKeys.deleteReply.localize,
                subTitle: LocaleKeys.youWillDeleteReply.localize,
                onTap: () {
                  widget.onDeleteReply(widget.reply.id);
                }),
          if (isMyComment)
            listTile(
                icon: Icons.edit,
                iconColor:
                    context.isDarkMode ? AppColors.LIGHT_COLOR : Colors.black,
                title: LocaleKeys.editReply.localize,
                subTitle: LocaleKeys.youWillEditReply.localize,
                onTap: () {
                  widget.reply.edit = !widget.reply.edit!;
                  editTextController.text = widget.reply.content;
                  setState(() {});
                }),
        ],
      ),
    );
  }

  Widget listTile(
      {required IconData icon,
      Color? iconColor,
      required String title,
      required String subTitle,
      required Function onTap}) {
    return ListTile(
      title: Label(text: title),
      onTap: () {
        onTap();
        context.pop();
      },
      leading: Icon(
        icon,
        color: iconColor ?? Colors.black,
      ),
      subtitle: Label(
        text: subTitle,
        style: Styles.mediumText(color: Colors.grey),
      ),
    );
  }
}
