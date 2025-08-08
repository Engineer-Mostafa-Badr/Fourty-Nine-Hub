import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/extensions/string_extension.dart';
import '../../../../../core/loading/custom_loading.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../core/messages/messages.dart';
import '../../../../../core/widget/custom_failure_widget.dart';
import '../../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';
import '../cubit/comment_instagram_cubit/comments_instagram_cubit.dart';
import '../widgets/comment_instagram_list_view_item.dart';
import '../../../social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import '../../../../../res/assets/assets.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../core/widget/custom_circular_progress_indicator.dart';
import '../../../../../helpers/manage_vibration.dart';

class CommentInstagramView extends StatefulWidget {
  const CommentInstagramView({
    super.key,
    // required this.commentInstagramEntity,
    // required this.scrollController,
    // required this.scrollableSheetController,
    required this.postId,
    // required this.userImageProfile,
  });
  // final CommentInstagramEntity commentInstagramEntity;
  final String postId;
  // final String userImageProfile;

  @override
  State<CommentInstagramView> createState() => _CommentInstagramViewState();
}

class _CommentInstagramViewState extends State<CommentInstagramView> {
  late TextEditingController textEditingController;

  @override
  void initState() {
    textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   appBar: AppBar(
    //     centerTitle: true,
    //     title: Label(
    //       text: LocaleKeys.comments.localize,
    //       style: Styles.headerText(fontSize: 40),
    //     ),
    //     leading: IconButton(
    //       onPressed: () {},
      ManageVibration.vibrate();
    //       icon: const Icon(
    //         Icons.close,
    //       ),
    //     ),
    //   ),
    //   body: SingleChildScrollView(
    //     child: Column(
    //       children: [
    //         Expanded(
    //           child: ListView.builder(
    //             itemCount: 5,
    //             itemBuilder: (context, index) {},
    //           ),
    //         ),
    //         SizedBox(
    //           height: 50,
    //           child: Row(
    //             children: [
    //               ImageFromInternet(
    //                 image: UserCubit.to.state.data!.profilePicture ?? '',
    //                 height: 46,
    //                 width: 46,
    //                 isCircle: true,
    //               ),
    //               const TextField(
    //                 decoration: InputDecoration(
    //                   border: InputBorder.none,
    //                 ),
    //               ),
    //             ],
    //           ),
    //         )
    //       ],
    //     ),
    //   ),
    // );

    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.8,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        child: BlocConsumer<CommentsInstagramCubit, CommentsInstagramState>(
          listener: (context, state) {
            if (state.addStatus.isSuccess) {
              // showSuccessMessage(context, LocaleKeys.commentAdded.localize);
              textEditingController.clear();
              context.read<CommentsInstagramCubit>().getComments(widget.postId);
            }
            if (state.addStatus.isFailure) {
              showErrorMessage(
                context,
                getFailureMessage(
                  state.addFailure!,
                  context,
                ),
              );
            }
            if (state.deleteStatus.isSuccess) {
              context.read<CommentsInstagramCubit>().getComments(widget.postId);
            }
            if (state.deleteStatus.isFailure) {
              showErrorMessage(
                context,
                getFailureMessage(
                  state.deleteFailure!,
                  context,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state.status.isLoading || state.status.isInitial) {
              return const CustomLoading();
            } else if (state.status.isFailure) {
              return CustomFailureWidget(
                title: getFailureMessage(state.failure!, context),
                onPressed: () {
      ManageVibration.vibrate();
                  context.read<CommentsInstagramCubit>().getComments(
                        widget.postId,
                      );
                },
              );
            }
            return Column(
              children: [
                Container(
                  width: 57,
                  height: 4,
                  decoration: const BoxDecoration(color: Color(0xFF6F787D)),
                  margin: const EdgeInsets.only(
                    top: 16,
                    bottom: 15,
                  ),
                ),
                Label(
                  text: LocaleKeys.comments.localize,
                  style: Styles.headerText(fontSize: 40),
                ),
                Divider(
                  height: 0,
                  color: Colors.black.withValues(alpha: 102),
                  thickness: 0.5,
                ),
                // SliverToBoxAdapter(
                //   child: Column(
                //     children: [

                //     ],
                //   ),
                // ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 17),
                    itemCount: state.comments?.length ?? 0,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onLongPress: state.comments![index].userId ==
                                UserCubit.to.state.data!.id
                            ? () {
                                // عرض قائمة منبثقة مع خيارات
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) => Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ListTile(
                                        leading: const Icon(Icons.delete),
                                        title: Text(
                                            LocaleKeys.deleteComment.localize),
                                        onTap: () {
      ManageVibration.vibrate();
                                          Navigator.pop(
                                              context); // إغلاق النافذة المنبثقة
                                          // تأكيد حذف التعليق
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: Text(LocaleKeys
                                                  .areYouSure.localize),
                                              content: Text(LocaleKeys
                                                  .areYouSureYouWantToDeleteThisComment
                                                  .localize),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  child: Text(LocaleKeys
                                                      .cancel.localize),
                                                ),
                                                TextButton(
                                                  onPressed: () {
      ManageVibration.vibrate();
                                                    Navigator.pop(context);
                                                    context
                                                        .read<
                                                            CommentsInstagramCubit>()
                                                        .deleteComment(
                                                          postId: widget.postId,
                                                          commentId: state
                                                              .comments![index]
                                                              .id,
                                                        );
                                                  },
                                                  child: Text(LocaleKeys
                                                      .delete.localize),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                      // يمكنك إضافة خيارات أخرى هنا مثل تعديل، إبلاغ، إلخ
                                    ],
                                  ),
                                );
                              }
                            : null,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: CommentInstagramListViewItem(
                            commentInstagram: state.comments![index],
                          ),
                        ),
                      );
                    },
                    // separatorBuilder: (context, index) {
                    //   return const SizedBox(
                    //     height: 10,
                    //   );
                    // },
                  ),
                ),
                Divider(
                  height: 0,
                  color: Colors.black.withValues(alpha: 102),
                  thickness: 0.5,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 17,
                    vertical: 21,
                  ),
                  child: Row(
                    children: [
                      ImageFromInternet(
                        image: UserCubit.to.state.data!.profilePicture ?? '',
                        height: 46,
                        width: 46,
                        isCircle: true,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextField(
                          controller: textEditingController,
                          onChanged: (value) {
                            setState(() {});
                          },
                          decoration: InputDecoration(
                            fillColor: Colors.transparent,
                            filled: true,
                            hintText:
                                '${LocaleKeys.addACommentsFor.localize} Ahmed',
                            hintStyle: Styles.headerText(
                              fontSize: 32,
                              color: Colors.black.withValues(alpha: 102),
                            ),
                            border: InputBorder.none,
                            errorBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            focusedErrorBorder: InputBorder.none,
                          ),
                        ),
                      ),
                      if (state.addStatus.isLoading)
                        const CustomCircularProgressIndicator(
                          color: AppColors.c161F68,
                        )
                      else
                        InkWell(
                          onTap: () {
      ManageVibration.vibrate();
                            if (textEditingController.text.isNotEmpty) {
                              context.read<CommentsInstagramCubit>().addComment(
                                    contentComment: textEditingController.text,
                                    postId: widget.postId,
                                  );
                              textEditingController.clear();
                            }
                          },
                          child: textEditingController.text.isEmpty
                              ? Image.asset(
                                  Assets.commentIconsPng,
                                  width: 25,
                                  height: 24,
                                )
                              : const Icon(
                                  Icons.send,
                                  color: AppColors.c161F68,
                                ),
                        ),
                    ],
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}