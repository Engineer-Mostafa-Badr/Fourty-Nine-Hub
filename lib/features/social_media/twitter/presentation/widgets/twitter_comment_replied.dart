import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/twitter/data/models/twitter_comment_reply_model.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/entities/twitter_comment_reply_entity.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/entities/twitter_user_entity.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/comment_reply_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/twitter_report_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/bloc/twitter_bloc.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/widgets/twitter_reply_card.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../../common/widgets/form/text_fields/form_text_field.dart';
import '../../../../../../common/widgets/stateless/buttons/iconAppButton.dart';
import '../../../../../../common/widgets/stateless/images/profile_image.dart';
import '../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../res/style/styles.dart';

class TwitterCommentReplies extends StatefulWidget {
  final List<TwitterCommentReplyEntity> replies;
  final String commentId;
  final String postId;
  final Function(String) onReplyReact;
  final Function(TwitterCommentReplyParams) onAddReply;
  final Function(TwitterReportParams) onReport;
  const TwitterCommentReplies(
      {super.key, required this.replies, required this.onReplyReact, required this.onAddReply, required this.commentId, required this.postId, required this.onReport,
      });

  @override
  State<TwitterCommentReplies> createState() => _TwitterCommentRepliesState();
}

class _TwitterCommentRepliesState extends State<TwitterCommentReplies> {
  final replyTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TwitterCubit>(
      create: (_)=>serviceLocator()..loadReplies(context,widget.commentId),
      child: BlocBuilder<TwitterCubit,TwitterState>(
          builder: (context,state) {
            final controller = context.read<TwitterCubit>();
            final user = context.read<UserCubit>().state.data;
            return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.grey),
              title: Label(
                  text: '${controller.repliesPagingController.itemList?.length} Replies',
                  style: Styles.mediumText()),
              leading: IconButton(
                  onPressed: () => context.pop(), icon: const Icon(Icons.clear)),
              centerTitle: true,
            ),
            body: Column(
              children: [
                Expanded(
                  child: PagedListView<int, TwitterCommentReplyEntity>(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                    pagingController: controller.repliesPagingController,
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    builderDelegate: PagedChildBuilderDelegate<TwitterCommentReplyEntity>(
                        noItemsFoundIndicatorBuilder: (context) {
                          print(controller.repliesPagingController.itemList?.length);
                          return const Padding(
                              padding: EdgeInsets.only(top: 200),
                              child: Center(
                                child: Text(
                                  "No Replies",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                  ),
                                ),
                              ));
                        },
                        itemBuilder: (context, item, index) {

                          return _buildCommentCard(reply: controller.repliesPagingController.itemList![index]);
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
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Row(
                      children: [
                        const ProfileImage(accountId: 0),
                        const Sizer(),
                        Expanded(
                            child: FormTextField(
                                hint: 'Type your reply ....',
                                height: kToolbarHeight * .7,
                                action: (v) {
                                  setState(() {});
                                },
                                controller: replyTextController)),
                        const Sizer(),
                        if (replyTextController.text.isNotEmpty)
                          IconAppButton(
                              icon: Icons.send,
                              isCircle: true,
                              onPressed: () async{
                                TwitterCommentReplyEntity data = await controller.onCommentReply(
                                  params:TwitterCommentReplyParams(postId: widget.postId,reply: widget.commentId,content: replyTextController.text),
                                );
                                print("state.newReply?.id${state.newReply?.id}");
                                controller.repliesPagingController.itemList?.insert(
                                    0,
                                    TwitterCommentReplyModel(
                                        id: data.id,
                                        content: replyTextController.text,
                                        post: widget.postId,
                                        createdAt: data.createdAt,
                                        user: TwitterUserEntity(id: user?.id??'', firstName: user?.firstName??'', lastName: user?.lastName??'', createdAt: DateTime.now(), image: user?.profilePicture??'', email: user?.email??'', isDocumented: false),
                                        love: data.love, isReact: data.isReact, image: data.image));
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
        }
      ),
    );
  }


  Widget _buildCommentCard(
      {required TwitterCommentReplyEntity reply}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TwitterReplyCard(reply: reply, onReplyReact: (String id) {
          widget.onReplyReact(id);
          reply.isReact=!reply.isReact!;
        }, onReport: (TwitterReportParams params) {
          widget.onReport(params);
        },),
       ],
    );
  }
}
