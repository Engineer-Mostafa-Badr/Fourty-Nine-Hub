import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../common/widgets/stateless/buttons/iconAppButton.dart';
import '../../../../../core/extensions/string_extension.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';
import '../../domain/entities/twitter_comment_reply_entity.dart';
import '../../domain/usecases/post_comment_usecase.dart';
import '../../domain/usecases/twitter_report_usecase.dart';
import 'report_view.dart';
import '../../../../../res/style/app_colors.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../common/widgets/dialogs/show_bottom_sheet.dart';
import '../../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../../common/widgets/stateless/images/profile_image.dart';
import '../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../res/style/styles.dart';
import '../../../../../helpers/manage_vibration.dart';

class TwitterReplyCard extends StatefulWidget {
  final Color textColor;
  final TwitterCommentReplyEntity reply;
  final Function(String) onReplyReact;
  final Function(TwitterReportParams) onReport;
  final Function(TwitterPostCommentParams) onEditReply;
  final Function(String) onDeleteReply;

  const TwitterReplyCard({
    super.key,
    this.textColor = Colors.black,
    required this.reply,
    required this.onReplyReact,
    required this.onReport,
    required this.onEditReply,
    required this.onDeleteReply,
  });

  @override
  State<TwitterReplyCard> createState() => _TwitterReplyCardState();
}

class _TwitterReplyCardState extends State<TwitterReplyCard> {
  final editTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = context.read<UserCubit>().state.data;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.reply.user.image == ''
                ? const ProfileImage(
                    accountId: 0,
                    withBorder: false,
                    userId: '',
                  )
                : ProfileImage(
                    accountId: 0,
                    imageURL: widget.reply.user.image,
                    userId: '',
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
                  widget.reply.content ?? '',
                  textAlign: TextAlign.start,
                  style: Styles.mediumText(fontSize: 60.sp),
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
                size: 50.sp,
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
                    isCircle: true,
                    onPressed: () async {
      ManageVibration.vibrate();
                      var result = await widget.onEditReply(
                          TwitterPostCommentParams(
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
        Sizer(
          height: 10.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
      ManageVibration.vibrate();
                if (widget.reply.isReact == true) {
                  widget.onReplyReact(widget.reply.id);
                  widget.reply.loveCount = (widget.reply.loveCount! - 1);
                  setState(() {});
                } else {
                  widget.onReplyReact(widget.reply.id);
                  widget.reply.loveCount = (widget.reply.loveCount! + 1);
                  setState(() {});
                }
              },
              child: Icon(
                widget.reply.isReact == false
                    ? Icons.favorite_border
                    : Icons.favorite,
                color: widget.reply.isReact == false ? Colors.grey : Colors.red,
              ),
            ),
            Sizer(
              width: 10.h,
            ),
            Label(
              text: "${widget.reply.loveCount}",
              style: Styles.mediumText(),
            ),
          ],
        ),
        Sizer(
          height: 5.h,
        ),
      ],
    );
  }

  Widget _buildPostOptions(
      {required bool isMyComment, required TwitterCommentReplyEntity post}) {
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
                  editTextController.text = widget.reply.content ?? '';
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