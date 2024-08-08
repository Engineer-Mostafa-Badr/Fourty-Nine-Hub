import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/authentication/domain/entities/user_entity.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/entities/twitter_post_entity.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/post_react_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/twitter_report_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/bloc/twitter_bloc.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/widgets/twitter_post_card.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class TwitterGlobalPosts extends StatefulWidget {
  const TwitterGlobalPosts({super.key, required this.userData});
  final UserEntity userData;
  @override
  State<TwitterGlobalPosts> createState() => _TwitterGlobalPostsState();
}

class _TwitterGlobalPostsState extends State<TwitterGlobalPosts> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TwitterCubit, TwitterState>(listener: (context, state) {
      if (state.status == StateStatus.error) {
        showErrorMessage(
          context,
          getFailureMessage(
            state.failure ?? const UnknownFailure(),
            context,
          ),
        );
      }
    }, builder: (context, state) {
      final controller = context.read<TwitterCubit>();
      return RefreshIndicator(
        onRefresh: () async => controller.loadData(),
        child: PagedListView<int, TwitterPostEntity>(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
          pagingController: controller.postsPagingController,
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          builderDelegate: PagedChildBuilderDelegate<TwitterPostEntity>(
              noItemsFoundIndicatorBuilder: (context) {
                print(controller.postsPagingController.itemList?.length);
                return const Padding(
                    padding: EdgeInsets.only(top: 200),
                    child: Center(
                      child: Text(
                        "لا يوجد بوستات",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                    ));
              },
              itemBuilder: (context, item, index) {
                return TwitterPostCard(
                  post: controller.postsPagingController.itemList![index],
                  onReact: () {
                    controller.onReact(
                        params: TwitterPostReactParams(
                            postId: controller
                                .postsPagingController.itemList![index].id,
                            react: 'love'));
                    controller.postsPagingController.itemList?[index].isReact =
                    !controller
                        .postsPagingController.itemList![index].isReact!;
                  },
                  shareSuccess: state.shareSuccess,
                  onShare: () {
                    controller.onShare(
                      postId:
                      controller.postsPagingController.itemList![index].id,
                    );
                    setState(() {});
                  },
                  showPostComments: (String v) {
                    print(
                        "mainId ${controller.postsPagingController.itemList![index].id}");
                    controller.showPostComments(
                      context: context,
                      postId:
                      controller.postsPagingController.itemList![index].id,
                      newCommentId: state.newCommentId ?? '',
                      user:
                      controller.postsPagingController.itemList![index].user, userData: widget.userData,
                    );
                  },
                  getPost: () {
                    print("objectH");
                    // bottomSheet(
                    //     context: context,
                    //     isScrollControlled: true,
                    //     widget: TwitterPostDetails(
                    //       postId: controller.postsPagingController.itemList![index].mainPost.id,
                    //       showPostComments: (id) {
                    //
                    //       },
                    //       onReport: (TwitterReportParams params) {
                    //       },
                    //     ));
                    // controller.getTwitterPost(
                    //     context,
                    //     '66b248964a2a579a9e878dc0',
                    //     state.newCommentId ?? '',widget.userData);
                  },
                  onReport: (TwitterReportParams params) {
                    controller.onReport(params);
                  },
                );
              },
              noMoreItemsIndicatorBuilder: (context) => Container(),
              firstPageProgressIndicatorBuilder: (context) => Container(
                  margin: const EdgeInsets.only(top: 150),
                  child: const CupertinoActivityIndicator()),
              newPageProgressIndicatorBuilder: (context) =>
              const CupertinoActivityIndicator()),
        ),
      );
    });
  }
}
