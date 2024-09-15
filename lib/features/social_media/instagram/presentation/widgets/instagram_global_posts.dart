import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/iconAppButton.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/text_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/social_image_viewer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/cubit/instagram_cubit.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/insta_reel_card.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/instagram_post_comments.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/post_entity.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/add_reply_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/post_comment_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/post_react_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/posts/facebook_advirtesement_card.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class InstagramGlobalPosts extends StatefulWidget {
  const InstagramGlobalPosts({super.key, required this.scrollController});
  final ScrollController scrollController;

  @override
  State<InstagramGlobalPosts> createState() => _InstagramGlobalPostsState();
}

class _InstagramGlobalPostsState extends State<InstagramGlobalPosts> {
  @override
  void dispose() {
    widget.scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<InstagramCubit>(
      create: (_) => serviceLocator()..loadGlobalData(),
      child: BlocConsumer<InstagramCubit, InstagramState>(
          listener: (context, state) {
        if (state.status == StateStatus.error) {
          showErrorMessage(
            context,
            getFailureMessage(
              state.failure ?? UnknownFailure(''),
              context,
            ),
          );
        }
      }, builder: (context, state) {
        final controller = context.read<InstagramCubit>();
        return RefreshIndicator(
          onRefresh: () => controller.refreshGlobalPosts(),
          child: CustomScrollView(
            controller: widget.scrollController,
            slivers: [
              // const SliverToBoxAdapter(
              //   child: ChatStories(),
              // ),
              PagedSliverList<int, PostEntity>(
                pagingController: controller.globalFeedPagingController,
                builderDelegate: PagedChildBuilderDelegate<PostEntity>(
                    noItemsFoundIndicatorBuilder: (context) {
                      print(controller
                          .globalFeedPagingController.itemList?.length);
                      return Center(
                        child: Text(
                          LocaleKeys.noPosts.localize,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.sp,
                          ),
                        ),
                      );
                    },
                    itemBuilder: (context, item, index) {
                      final pageController = PageController();
                      if (controller.globalFeedPagingController.itemList?[index]
                              .type ==
                          'advertisement') {
                        return FacebookAdvertisementCard(
                          post: controller
                              .globalFeedPagingController.itemList![index],
                        );
                      } else if (controller.globalFeedPagingController
                              .itemList?[index].type ==
                          'facebook_post') {
                        return Padding(
                          padding: const EdgeInsetsDirectional.only(
                            start: 10.0,
                            end: 10,
                            top: 0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Sizer(),
                              _buildMainAccountHeader(
                                  post: controller.globalFeedPagingController
                                      .itemList![index],
                                  context: context),
                              const Sizer(),
                              SizedBox(
                                height: kToolbarHeight * 5,
                                child: PageView.builder(
                                    controller: pageController,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: controller
                                        .globalFeedPagingController
                                        .itemList![index]
                                        .images!
                                        .length,
                                    onPageChanged: (i) {
                                      controller.changeIndex(i);
                                    },
                                    itemBuilder: (context, i) {
                                      return SocialImageViewer(
                                        image: controller
                                            .globalFeedPagingController
                                            .itemList![index]
                                            .images![i],
                                        index: i + 1,
                                        length: controller
                                            .globalFeedPagingController
                                            .itemList![index]
                                            .images!
                                            .length,
                                        onDoubleTap: () {
                                          controller.globalFeedPagingController
                                                  .itemList?[index].isLove =
                                              !controller
                                                  .globalFeedPagingController
                                                  .itemList![index]
                                                  .isLove!;
                                          setState(() {});
                                        },
                                      );
                                    }),
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              if (controller.globalFeedPagingController
                                      .itemList![index].images!.length >
                                  1) ...[
                                Center(
                                  child: SizedBox(
                                    height: 8.h,
                                    child: ListView.separated(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: controller
                                            .globalFeedPagingController
                                            .itemList![index]
                                            .images!
                                            .length,
                                        separatorBuilder: (context, index) =>
                                            const Sizer(
                                              width: 3,
                                            ),
                                        itemBuilder: (context, index) {
                                          return CircleAvatar(
                                            radius: 4,
                                            backgroundColor:
                                                state.pageIndex == index
                                                    ? AppColors.SECONDARY_COLOR
                                                    : AppColors.PRIMARY_COLOR,
                                          );
                                        }),
                                  ),
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                              ],
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          IconAppButton(
                                            icon: controller
                                                        .globalFeedPagingController
                                                        .itemList?[index]
                                                        .isLove ==
                                                    true
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            onPressed: () async {
                                              if (context
                                                  .read<UserCubit>()
                                                  .isLoggedIn) {
                                                print('object');
                                                var reacted =
                                                    await controller.onReact(
                                                  params: PostReactParams(
                                                    postId: controller
                                                        .globalFeedPagingController
                                                        .itemList![index]
                                                        .id,
                                                    react: 'love',
                                                  ),
                                                );
                                                if (reacted == true) {
                                                  controller
                                                          .globalFeedPagingController
                                                          .itemList?[index]
                                                          .isLove =
                                                      !controller
                                                          .globalFeedPagingController
                                                          .itemList![index]
                                                          .isLove!;
                                                  if (controller
                                                          .globalFeedPagingController
                                                          .itemList?[index]
                                                          .isLove ==
                                                      false) {
                                                    controller
                                                        .globalFeedPagingController
                                                        .itemList?[index]
                                                        .loveCount = (controller
                                                            .globalFeedPagingController
                                                            .itemList![index]
                                                            .loveCount! -
                                                        1);
                                                  } else {
                                                    controller
                                                        .globalFeedPagingController
                                                        .itemList?[index]
                                                        .loveCount = (controller
                                                            .globalFeedPagingController
                                                            .itemList![index]
                                                            .loveCount! +
                                                        1);
                                                  }
                                                }
                                                setState(() {});
                                              } else {
                                                context.push(Routes.LOGIN);
                                              }
                                            },
                                            color: controller
                                                        .globalFeedPagingController
                                                        .itemList?[index]
                                                        .isLove ==
                                                    true
                                                ? Colors.red
                                                : Colors.grey,
                                            size: 25,
                                          ),
                                          const Sizer(
                                            width: 5,
                                          ),
                                          Label(
                                            text: controller
                                                    .globalFeedPagingController
                                                    .itemList?[index]
                                                    .loveCount
                                                    .toString() ??
                                                '',
                                            style: Styles.mediumText(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const Sizer(),
                                          IconAppButton(
                                            icon: Icons
                                                .chat_bubble_outline_rounded,
                                            onPressed: () {
                                              if (context
                                                  .read<UserCubit>()
                                                  .isLoggedIn) {
                                                bottomSheet(
                                                    context: context,
                                                    isScrollControlled: true,
                                                    widget: BlocProvider.value(
                                                      value: serviceLocator<
                                                          InstagramCubit>()
                                                        ..loadComments(
                                                            context,
                                                            controller
                                                                .globalFeedPagingController
                                                                .itemList![
                                                                    index]
                                                                .id),
                                                      child:
                                                          InstagramPostComments(
                                                        postId: controller
                                                            .globalFeedPagingController
                                                            .itemList![index]
                                                            .id,
                                                        onCommentReply:
                                                            (ReplyOnCommentParams
                                                                params) async {
                                                          var result =
                                                              await controller
                                                                  .replyOnComment(
                                                            params: ReplyOnCommentParams(
                                                                postId: params
                                                                    .postId,
                                                                content: params
                                                                    .content,
                                                                commentId: params
                                                                    .commentId),
                                                          );
                                                          var currentPost = controller
                                                              .globalFeedPagingController
                                                              .itemList
                                                              ?.firstWhere(
                                                                  (element) =>
                                                                      element
                                                                          .id ==
                                                                      params
                                                                          .postId);
                                                          currentPost
                                                                  ?.commentsCount =
                                                              (currentPost
                                                                      .commentsCount! +
                                                                  1);
                                                          return result;
                                                        },
                                                        onAddComment:
                                                            (PostCommentParams
                                                                params) async {
                                                          var result =
                                                              await controller
                                                                  .onPostComment(
                                                                      params:
                                                                          params);
                                                          return result;
                                                        },
                                                        onDeleteComment:
                                                            (String id) async {
                                                          return await controller
                                                              .deleteComment(
                                                                  context:
                                                                      context,
                                                                  commentId: id,
                                                                  postId: controller
                                                                      .globalFeedPagingController
                                                                      .itemList![
                                                                          index]
                                                                      .id,
                                                                  from: 'feed');
                                                          // print(result);
                                                        },
                                                        onDeleteReply:
                                                            (String id) async {
                                                          return await controller
                                                              .deleteComment(
                                                                  context:
                                                                      context,
                                                                  commentId: id,
                                                                  postId: controller
                                                                      .globalFeedPagingController
                                                                      .itemList![
                                                                          index]
                                                                      .id,
                                                                  from: 'feed');
                                                        },
                                                        onEditComment:
                                                            (PostCommentParams
                                                                params) async {
                                                          var result =
                                                              await controller
                                                                  .editComment(
                                                                      params:
                                                                          params);
                                                          return result;
                                                        },
                                                      ),
                                                    ));
                                              } else {
                                                context.push(Routes.LOGIN);
                                              }
                                            },
                                            color: Colors.grey,
                                            size: 25,
                                          ),
                                          const Sizer(
                                            width: 5,
                                          ),
                                          Label(
                                            text: controller
                                                    .globalFeedPagingController
                                                    .itemList?[index]
                                                    .commentsCount
                                                    .toString() ??
                                                '',
                                            style: Styles.mediumText(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Sizer(
                                height: 5.h,
                              ),
                              if (controller.globalFeedPagingController
                                  .itemList![index].content!.isNotEmpty)
                                Label(
                                    text: controller.globalFeedPagingController
                                            .itemList?[index].content ??
                                        ''),
                              if (controller.globalFeedPagingController
                                  .itemList![index].content!.isEmpty) ...[
                                InkWell(
                                    onTap: () => context.push(Routes.LOGIN),
                                    child: Label(text: LocaleKeys.showComments.localize))
                              ],
                              if (controller.globalFeedPagingController
                                      .itemList![index].content!.isEmpty &&
                                  (controller.globalFeedPagingController
                                          .itemList![index].firstComment !=
                                      null))
                                RichText(
                                    text: TextSpan(children: [
                                  TextSpan(
                                      text:
                                          '${controller.globalFeedPagingController.itemList?[index].firstComment?.firstName} ${controller.globalFeedPagingController.itemList?[index].firstComment?.lastName}\t\t',
                                      recognizer: TapGestureRecognizer()
                                        ..onTap =
                                            () => context.push(Routes.LOGIN),
                                      style: Styles.mediumText(
                                          color: Colors.black)),
                                  TextSpan(
                                      text: controller
                                                  .globalFeedPagingController
                                                  .itemList![index]
                                                  .firstComment ==
                                              null
                                          ? ''
                                          : controller
                                              .globalFeedPagingController
                                              .itemList?[index]
                                              .firstComment
                                              ?.content,
                                      style: Styles.mediumText(
                                          color: Colors.grey)),
                                ])),
                              RichText(
                                  text: TextSpan(children: [
                                TextSpan(
                                    text: controller.globalFeedPagingController
                                        .itemList?[index].sinceTime,
                                    style:
                                        Styles.mediumText(color: Colors.grey)),
                              ]))
                            ],
                          ),
                        );
                      } else {
                        return Column(
                          children: [
                            Container(
                              height: 5.h,
                              width: double.infinity,
                              color: AppColors.DIVIDER_GRAY_COLOR2,
                            ),
                            Container(
                              color: Colors.black,
                              height: 300.h,
                              width: double.infinity,
                              child: InstagramReelCard(
                                item: controller.globalFeedPagingController
                                    .itemList![index],
                              ),
                            ),
                            Container(
                              height: 5.h,
                              width: double.infinity,
                              color: AppColors.DIVIDER_GRAY_COLOR2,
                            ),
                          ],
                        );
                      }
                    },
                    noMoreItemsIndicatorBuilder: (context) => Container(),
                    firstPageProgressIndicatorBuilder: (context) => Container(
                        margin: const EdgeInsets.only(top: 150),
                        child: const CupertinoActivityIndicator()),
                    newPageProgressIndicatorBuilder: (context) =>
                        const CupertinoActivityIndicator()),
              )
            ],
          ),
        );
      }),
    );
  }

  Widget _buildMainAccountHeader({
    required BuildContext context,
    required PostEntity post,
  }) {
    return Row(
      children: [
        InkWell(
          onTap: () {
            if (context.read<UserCubit>().isLoggedIn) {
              context.push(Routes.OTHERSACCOUNT, extra: post.user.id);
            } else {
              context.push(Routes.LOGIN);
            }
          },
          child: CircleAvatar(
            backgroundColor: Colors.white,
            backgroundImage: NetworkImage((post.user.image != null)
                ? post.user.image ?? ''
                : UIConst.profilePlaceHolder),
          ),
        ),
        const Sizer(),
        Expanded(
            child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    if (context.read<UserCubit>().isLoggedIn) {
                      context.push(Routes.INSTAGRAMPROFILE,
                          extra: post.user.id);
                    } else {
                      context.push(Routes.LOGIN);
                    }
                  },
                  child: TextAppButton(
                      style: TextStyle(color: Theme.of(context).primaryColor),
                      label: post.user.firstName,
                      onPressed: () {
                        if (context.read<UserCubit>().isLoggedIn) {
                          context.push(Routes.INSTAGRAMPROFILE,
                              extra: post.user.id);
                        } else {
                          context.push(Routes.LOGIN);
                        }
                      }),
                ),
                RichText(
                    text: TextSpan(children: [
                  TextSpan(
                      text: post.sinceTime,
                      style: Styles.mediumText(color: Colors.grey)),
                  const WidgetSpan(
                      child: Icon(
                    Icons.group,
                    size: 14,
                    color: Colors.grey,
                  ))
                ]))
              ],
            ),
            // _buildActivityFeelingWidget(post),
          ],
        )),
      ],
    );
  }
}
