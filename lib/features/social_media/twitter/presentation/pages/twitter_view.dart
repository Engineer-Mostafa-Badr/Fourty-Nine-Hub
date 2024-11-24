import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/core/states/basic_state.dart';
import 'package:fourtyninehub/features/authentication/domain/entities/user_entity.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/entities/twitter_post_comment_entity.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/entities/twitter_post_entity.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/comment_react_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/comment_reply_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/post_comment_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/post_react_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/twitter_report_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/bloc/twitter_bloc.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/widgets/build_twitter_document_card.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/widgets/twitter_post_card.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/widgets/twitter_post_comments.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class TwitterView extends StatefulWidget {
  const TwitterView({super.key});
  @override
  State<TwitterView> createState() => _TwitterViewState();
}

class _TwitterViewState extends State<TwitterView> {
  @override
  void initState() {
    // context.read<TwitterCubit>().loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          // mainCategoryId: 2,
          body: BlocBuilder<UserCubit, BasicState<UserEntity>>(
              builder: (context, state) {
            UserEntity? userData = state.data;
            return context.read<UserCubit>().isLoggedIn
                ? _buildTwitterWidget(userData!)
                : _buildGlobalTwitterWidget();
          }),
        ),
        PositionedDirectional(
          bottom: 10,
          end: 10,
          child: FloatingActionButton(
            backgroundColor: Colors.red,
            onPressed: () {
              if (context.read<UserCubit>().isLoggedIn) {
                context.push(Routes.CREATEPOST, extra: 'twitter');
              } else {
                context.push(Routes.LOGIN);
              }
            },
            shape: const CircleBorder(),
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTwitterTitle() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Label(
        text: LocaleKeys.Tweets.localize,
        style: Styles.headerText(),
      ),
    );
  }

  Widget _buildTwitterWidget(UserEntity userData) {
    return BlocProvider<TwitterCubit>(
      create: (_) => serviceLocator()..loadData(),
      child:
          BlocConsumer<TwitterCubit, TwitterState>(listener: (context, state) {
        if (state.status == StateStatus.error) {
          showErrorMessage(
            context,
            getFailureMessage(
              state.failure!,
              context,
            ),
          );
        }
      }, builder: (context, state) {
        final controller = context.read<TwitterCubit>();
        return RefreshIndicator(
          onRefresh: () async => controller.onRefresh(),
          child: CustomScrollView(
            slivers: [
              // _buildTwitterTitle(),
              // const BuildTwitterDocumentCard(),
              // Expanded(child: TwitterGlobalPosts(userData: userData!,)),

              // SliverToBoxAdapter(
              //   child: _buildTwitterTitle(),
              // ),
              const SliverToBoxAdapter(
                child: BuildTwitterDocumentCard(),
              ),
              PagedSliverList<int, TwitterPostEntity>(
                pagingController: controller.postsPagingController,
                builderDelegate: PagedChildBuilderDelegate<TwitterPostEntity>(
                  noItemsFoundIndicatorBuilder: (context) {
                    return Center(
                      child: Text(
                        LocaleKeys.noPosts.localize,
                        style: Styles.mediumText(),
                      ),
                    );
                  },
                  itemBuilder: (context, item, index) {
                    final user = context.read<UserCubit>().state.data;
                    return Padding(
                      padding:  EdgeInsets.only(bottom: 30.h),
                      child: TwitterPostCard(
                        post: controller.postsPagingController.itemList![index],
                        postShare: controller.postsPagingController.itemList![index].postShare,
                        onReact: () async {
                          var result = await controller.onReact(
                              params: TwitterPostReactParams(
                                  postId: controller
                                      .postsPagingController.itemList![index].id,
                                  react: 'love'));
                          if (result == true) {
                            if (controller.postsPagingController.itemList?[index]
                                    .isReact ==
                                true) {
                              controller.postsPagingController.itemList?[index]
                                  .isReact = false;
                              controller.postsPagingController.itemList?[index]
                                  .loveCount = (controller.postsPagingController
                                      .itemList![index].loveCount! -
                                  1);
                            } else {
                              controller.postsPagingController.itemList?[index]
                                  .isReact = true;
                              controller.postsPagingController.itemList?[index]
                                  .loveCount = (controller.postsPagingController
                                      .itemList![index].loveCount! +
                                  1);
                            }
                          }
                        },
                        shareSuccess: state.shareSuccess,
                        onShare: () {
                          controller.onShare(
                            postId: controller.postsPagingController
                                        .itemList![index].isShared ==
                                    true
                                ? controller.postsPagingController
                                    .itemList![index].mainPost!.id
                                : controller
                                    .postsPagingController.itemList![index].id,
                          );
                          if (state.shareSuccess == true) {
                            showSuccessMessage(context,
                                LocaleKeys.postSharedSuccessfully.localize);
                          }
                          setState(() {});
                        },
                        showPostComments: (String v) {
                          print(
                              "mainId ${controller.postsPagingController.itemList![index].id}");
                          bottomSheet(
                            context: context,
                            isScrollControlled: true,
                            widget: BlocProvider.value(
                              value: serviceLocator<TwitterCubit>()
                                ..loadComments(
                                    context,
                                    controller.postsPagingController
                                        .itemList![index].id),
                              child: TwitterPostComments(
                                comments: const [],
                                postId: controller
                                    .postsPagingController.itemList![index].id,
                                user: user,
                                onAddComment: (TwitterPostCommentParams params) =>
                                    controller.onPostComment(params: params),
                                onAddReply:
                                    (TwitterCommentReplyParams params) async {
                                  return await controller.onCommentReply(
                                      params: params);
                                },
                                onCommentReact:
                                    (TwitterCommentReactParams params) {
                                  controller.onCommentReact(params: params);
                                },
                                onGetReplies: (String id,
                                    TwitterPostCommentEntity comment) async {},
                                newCommentId: '',
                                state: state,
                                onReport: (TwitterReportParams params) {
                                  controller.onReport(params);
                                },
                                onEditComment:
                                    (TwitterPostCommentParams params) async {
                                  return await controller.editComment(
                                      params: params);
                                },
                                onDeleteComment: (id) async =>
                                    await controller.deleteComment(
                                        context: context,
                                        commentId: id,
                                        postId: controller.postsPagingController
                                            .itemList![index].id,
                                        from: 'posts'),
                              ),
                            ),
                          );
                        },
                        getPost: () {},
                        onReport: (TwitterReportParams params) {
                          controller.onReport(params);
                        },
                        deletePost: (String id) {
                          controller.deletePost(context: context, postId: id);
                        },
                        hidePost: (String id) {
                          controller.hidePost(context: context, postId: id);
                        },
                        onDeleteComment: (String id) async {
                          return await controller.deleteComment(
                              context: context,
                              commentId: id,
                              postId: 'postId',
                              from: 'details');
                        },
                        onEditComment: (params) async =>
                            await controller.editComment(params: params),
                      ),
                    );
                  },
                  noMoreItemsIndicatorBuilder: (context) => Container(),
                  firstPageProgressIndicatorBuilder: (context) =>
                      const CupertinoActivityIndicator(),
                  newPageProgressIndicatorBuilder: (context) =>
                      const CupertinoActivityIndicator(),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildGlobalTwitterWidget() {
    return BlocProvider<TwitterCubit>(
      create: (_) => serviceLocator()..loadGlobalData(),
      child:
          BlocConsumer<TwitterCubit, TwitterState>(listener: (context, state) {
        if (state.status == StateStatus.error) {
          showErrorMessage(
            context,
            getFailureMessage(
              state.failure!,
              context,
            ),
          );
        }
      }, builder: (context, state) {
        final controller = context.read<TwitterCubit>();
        return RefreshIndicator(
          onRefresh: () async => controller.onGlobalRefresh(),
          child: CustomScrollView(
            slivers: [
              // SliverToBoxAdapter(
              //   child: _buildTwitterTitle(),
              // ),
              const SliverToBoxAdapter(
                child: BuildTwitterDocumentCard(),
              ),
              PagedSliverList<int, TwitterPostEntity>(
                pagingController: controller.globalPostsPagingController,
                builderDelegate: PagedChildBuilderDelegate<TwitterPostEntity>(
                  noItemsFoundIndicatorBuilder: (context) {
                    return Center(
                      child: Text(
                        LocaleKeys.noPosts.localize,
                        style: Styles.mediumText(),
                      ),
                    );
                  },
                  itemBuilder: (context, item, index) {
                    final user = context.read<UserCubit>().state.data;
                    return TwitterPostCard(
                      post: controller
                          .globalPostsPagingController.itemList![index],
                      postShare: controller
                          .globalPostsPagingController.itemList![index].postShare!,
                      onReact: () async {
                        var result = await controller.onReact(
                            params: TwitterPostReactParams(
                                postId: controller.globalPostsPagingController
                                    .itemList![index].id,
                                react: 'love'));
                        if (result == true) {
                          if (controller.globalPostsPagingController
                                  .itemList?[index].isReact ==
                              true) {
                            controller.globalPostsPagingController
                                .itemList?[index].isReact = false;
                            controller.globalPostsPagingController
                                .itemList?[index].loveCount = (controller
                                    .globalPostsPagingController
                                    .itemList![index]
                                    .loveCount! -
                                1);
                          } else {
                            controller.globalPostsPagingController
                                .itemList?[index].isReact = true;
                            controller.globalPostsPagingController
                                .itemList?[index].loveCount = (controller
                                    .globalPostsPagingController
                                    .itemList![index]
                                    .loveCount! +
                                1);
                          }
                        }
                      },
                      shareSuccess: state.shareSuccess,
                      onShare: () {
                        controller.onShare(
                          postId: controller.globalPostsPagingController
                                      .itemList![index].isShared ==
                                  true
                              ? controller.globalPostsPagingController
                                  .itemList![index].mainPost!.id
                              : controller.globalPostsPagingController
                                  .itemList![index].id,
                        );
                        if (state.shareSuccess == true) {
                          showSuccessMessage(context,
                              LocaleKeys.postSharedSuccessfully.localize);
                        }
                        setState(() {});
                      },
                      showPostComments: (String v) {
                        print(
                            "mainId ${controller.globalPostsPagingController.itemList![index].id}");
                        bottomSheet(
                          context: context,
                          isScrollControlled: true,
                          widget: BlocProvider.value(
                            value: serviceLocator<TwitterCubit>()
                              ..loadComments(
                                  context,
                                  controller.globalPostsPagingController
                                      .itemList![index].id),
                            child: TwitterPostComments(
                              comments: const [],
                              postId: controller.globalPostsPagingController
                                  .itemList![index].id,
                              user: user,
                              onAddComment: (TwitterPostCommentParams params) =>
                                  controller.onPostComment(params: params),
                              onAddReply:
                                  (TwitterCommentReplyParams params) async {
                                return await controller.onCommentReply(
                                    params: params);
                              },
                              onCommentReact:
                                  (TwitterCommentReactParams params) {
                                controller.onCommentReact(params: params);
                              },
                              onGetReplies: (String id,
                                  TwitterPostCommentEntity comment) async {},
                              newCommentId: '',
                              state: state,
                              onReport: (TwitterReportParams params) {
                                controller.onReport(params);
                              },
                              onEditComment:
                                  (TwitterPostCommentParams params) async {
                                return await controller.editComment(
                                    params: params);
                              },
                              onDeleteComment: (id) async =>
                                  await controller.deleteComment(
                                      context: context,
                                      commentId: id,
                                      postId: controller
                                          .globalPostsPagingController
                                          .itemList![index]
                                          .id,
                                      from: 'posts'),
                            ),
                          ),
                        );
                      },
                      getPost: () {},
                      onReport: (TwitterReportParams params) {
                        controller.onReport(params);
                      },
                      deletePost: (String id) {
                        controller.deletePost(context: context, postId: id);
                      },
                      hidePost: (String id) {
                        controller.hidePost(context: context, postId: id);
                      },
                      onDeleteComment: (String id) async {
                        return await controller.deleteComment(
                            context: context,
                            commentId: id,
                            postId: 'postId',
                            from: 'details');
                      },
                      onEditComment: (params) async =>
                          await controller.editComment(params: params),
                    );
                  },
                  noMoreItemsIndicatorBuilder: (context) => Container(),
                  firstPageProgressIndicatorBuilder: (context) =>
                      const CupertinoActivityIndicator(),
                  newPageProgressIndicatorBuilder: (context) =>
                      const CupertinoActivityIndicator(),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
