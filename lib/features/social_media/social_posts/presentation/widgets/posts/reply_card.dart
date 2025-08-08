import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../common/widgets/stateless/buttons/iconAppButton.dart';
import '../../../../../../core/extensions/string_extension.dart';
import '../../../../../../core/localization/locale_keys.g.dart';
import '../../../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';
import '../../../domain/entities/comment_entity.dart';
import '../../../domain/usecases/post_comment_usecase.dart';
import '../facebook_widgets/build_reactions_buttons.dart';
import '../facebook_widgets/user_image.dart';
import '../../../../twitter/domain/usecases/twitter_report_usecase.dart';
import '../../../../twitter/presentation/widgets/report_view.dart';
import '../../../../../../res/style/app_colors.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../common/widgets/dialogs/show_bottom_sheet.dart';
import '../../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../res/style/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../helpers/manage_vibration.dart';

class ReplyCard extends StatefulWidget {
  final Color textColor;
  final CommentEntity reply;
  final Function(String) onReplyReact;
  final Function(String) onDeleteReply;
  final Function(PostCommentParams) onEditComment;
  final Function(TwitterReportParams) onReport;

  const ReplyCard({
    super.key,
    this.textColor = Colors.black,
    required this.reply,
    required this.onReplyReact,
    required this.onReport,
    required this.onDeleteReply,
    required this.onEditComment,
  });

  @override
  State<ReplyCard> createState() => _ReplyCardState();
}

class _ReplyCardState extends State<ReplyCard> {
  final editTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = context.read<UserCubit>().state.data;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            UserProfileImage(
              accountId: 0,
              withBorder: false,
              imageURL: widget.reply.user.image.isNotEmpty
                  ? widget.reply.user.image
                  : null,
              userId: widget.reply.user.id,
            ),
            const Sizer(),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Label(
                        text: widget.reply.user.firstName,
                        style: Styles.mediumText(fontWeight: FontWeight.bold)),
                    const Sizer(),
                    Label(
                        text: widget.reply.sinceTime,
                        style: Styles.mediumText(
                            color: AppColors.GREY_NORMAL_COLOR)),
                  ],
                ),
                Text(
                  widget.reply.content,
                  textAlign: TextAlign.start,
                  style: Styles.mediumText(fontSize: 65.sp),
                ),
              ],
            )),
            GestureDetector(
                onTap: () {
      ManageVibration.vibrate();
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
                  size: 40.sp,
                )),
          ],
        ),
        if (widget.reply.edit == true)
          SizedBox(
            height: kToolbarHeight,
            child: Row(
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
                    fillColor: Colors.white,
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
      ManageVibration.vibrate();
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
          ),
        Sizer(
          height: 5.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            BuildReactionsButtons(
              post: widget.reply,
              from: 'comments',
            ),
          ],
        ),
        const Sizer(),
      ],
    );
  }

  Widget _buildPostOptions(
      {required bool isMyComment, required CommentEntity post}) {
    return SizedBox(
      height: isMyComment ? 160 : 80,
      child: Column(
        children: [
          if (!isMyComment)
            listTile(
                icon: Icons.report,
                iconColor: Colors.red,
                title: LocaleKeys.reportReply.localize,
                subTitle: LocaleKeys.youWillReportReply.localize,
                onTap: () async {
      ManageVibration.vibrate();
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
                title: LocaleKeys.deleteReply.localize,
                subTitle: LocaleKeys.youWillDeleteReply.localize,
                onTap: () {
      ManageVibration.vibrate();
                  widget.onDeleteReply(widget.reply.id);
                }),
          if (isMyComment)
            listTile(
                icon: Icons.visibility_off,
                title: LocaleKeys.editReply.localize,
                subTitle: LocaleKeys.youWillEditReply.localize,
                onTap: () {
      ManageVibration.vibrate();
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
      ManageVibration.vibrate();
        onTap();
        context.pop();
      },
      leading: Icon(
        icon,
      ),
      subtitle: Label(
        text: subTitle,
        style: Styles.mediumText(color: Colors.grey),
      ),
    );
  }
}