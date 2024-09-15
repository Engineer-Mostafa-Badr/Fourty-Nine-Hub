import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/twitter/data/models/twitter_comment_reply_model.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/entities/twitter_comment_reply_entity.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/entities/twitter_user_entity.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/comment_reply_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/post_comment_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/twitter_report_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/bloc/twitter_bloc.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/widgets/twitter_reply_card.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../../common/widgets/stateless/buttons/iconAppButton.dart';
import '../../../../../../common/widgets/stateless/images/profile_image.dart';
import '../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../res/style/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class TwitterCommentReplies extends StatefulWidget {
  final List<TwitterCommentReplyEntity> replies;
  final String commentId;
  final String postId;
  final Function(String) onReplyReact;
  final Function(TwitterCommentReplyParams) onAddReply;
  final Function(TwitterReportParams) onReport;
  final Function(TwitterPostCommentParams) onEditReply;
  final Function(String) onDeleteReply;
  const TwitterCommentReplies({
    super.key,
    required this.replies,
    required this.onReplyReact,
    required this.onAddReply,
    required this.commentId,
    required this.postId,
    required this.onReport,
    required this.onEditReply,
    required this.onDeleteReply,
  });

  @override
  State<TwitterCommentReplies> createState() => _TwitterCommentRepliesState();
}

class _TwitterCommentRepliesState extends State<TwitterCommentReplies> {
  final replyTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TwitterCubit, TwitterState>(builder: (context, state) {
      final controller = context.read<TwitterCubit>();
      final user = context.read<UserCubit>().state.data;
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
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
              child: PagedListView<int, TwitterCommentReplyEntity>(
                padding:
                    EdgeInsets.symmetric(vertical: 8.h, horizontal: 5),
                pagingController: controller.repliesPagingController,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                builderDelegate: PagedChildBuilderDelegate<
                        TwitterCommentReplyEntity>(
                    noItemsFoundIndicatorBuilder: (context) {
                      print(
                          controller.repliesPagingController.itemList?.length);
                      return  Padding(
                          padding: EdgeInsets.only(top: 200),
                          child: Center(
                            child: Text(
                              LocaleKeys.noReplied.localize,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
                          ));
                    },
                    itemBuilder: (context, item, index) {
                      return _buildCommentCard(
                          reply: controller
                              .repliesPagingController.itemList![index],
                          onDeleteReply: (String id) async {
                            var result = await widget.onDeleteReply(id);
                            if (result == true) {
                              controller.repliesPagingController.itemList
                                  ?.removeWhere((e) => e.id == id);
                              setState(() {});
                            }
                          });
                    },
                    noMoreItemsIndicatorBuilder: (context) => Container(),
                    firstPageProgressIndicatorBuilder: (context) => Container(
                        margin: EdgeInsets.only(top: 150),
                        child: const CupertinoActivityIndicator()),
                    newPageProgressIndicatorBuilder: (context) =>
                        const CupertinoActivityIndicator()),
              ),
            ),
            Container(
                height: kToolbarHeight,
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    const ProfileImage(
                      accountId: 0,
                      userId: '',
                    ),
                    Sizer(),
                    Expanded(
                        child: TextFormField(
                      maxLines: null,
                      controller: replyTextController,
                      onChanged: (v) {
                        setState(() {});
                      },
                      style: Styles.headerText(fontSize: 26),
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.all(5),
                        hintText: '${LocaleKeys.typeYourReply.localize} ....',
                        hintStyle: Styles.mediumText(),
                      ),
                    )),
                    Sizer(),
                    if (replyTextController.text.isNotEmpty)
                      IconAppButton(
                        icon: Icons.send,
                        isCircle: true,
                        size: 20,
                        onPressed: () async {
                          TwitterCommentReplyEntity data =
                              await widget.onAddReply(
                            TwitterCommentReplyParams(
                                postId: widget.postId,
                                reply: widget.commentId,
                                content: replyTextController.text),
                          );
                          print("state.newReply?.id${state.newReply?.id}");
                          print("state.data?.id${data.id}");
                          controller.repliesPagingController.itemList?.insert(
                              0,
                              TwitterCommentReplyModel(
                                  id: data.id,
                                  content: replyTextController.text,
                                  post: widget.postId,
                                  createdAt: data.createdAt,
                                  user: TwitterUserEntity(
                                      id: user?.id ?? '',
                                      firstName: user?.firstName ?? '',
                                      lastName: user?.lastName ?? '',
                                      createdAt: DateTime.now(),
                                      image: user?.profilePicture ?? '',
                                      email: user?.email ?? '',
                                      isDocumented: false),
                                  love: data.love,
                                  isReact: data.isReact,
                                  image: data.image));
                          replyTextController.clear();
                          print(widget.replies.length);
                          setState(() {});
                        },
                      )
                  ],
                )),
          ],
        ),
      );
    });
  }

  Widget _buildCommentCard(
      {required TwitterCommentReplyEntity reply,
      required Function(String) onDeleteReply}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TwitterReplyCard(
          reply: reply,
          onReplyReact: (String id) {
            widget.onReplyReact(id);
            reply.isReact = !reply.isReact!;
          },
          onReport: (TwitterReportParams params) {
            widget.onReport(params);
          },
          onEditReply: (TwitterPostCommentParams params) =>
              widget.onEditReply(params),
          onDeleteReply: (id) => onDeleteReply(id),
        ),
      ],
    );
  }
}
