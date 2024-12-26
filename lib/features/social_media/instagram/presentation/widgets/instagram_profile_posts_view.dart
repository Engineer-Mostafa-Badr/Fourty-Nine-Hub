import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/iconAppButton.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/text_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/social_image_viewer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
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
import 'package:snapping_bottom_sheet/snapping_bottom_sheet.dart';

class InstagramProfilePostsView extends StatefulWidget {
  const InstagramProfilePostsView({
    super.key,
    required this.initialImage,
    required this.posts,
  });

  final PostEntity initialImage;
  final List<PostEntity> posts;

  @override
  State<InstagramProfilePostsView> createState() =>
      _InstagramProfilePostsViewState();
}

class _InstagramProfilePostsViewState extends State<InstagramProfilePostsView> {
  final commentTextController = TextEditingController();
  final SheetController sheetController = SheetController();
  bool _isExpanded = false;
  ScrollController scrollController = ScrollController();

  void showAsBottomSheet(
      {required Widget child, required Widget footer}) async {
    final result = await showSnappingBottomSheet(context, builder: (context) {
      return SnappingBottomSheetDialog(
        controller: sheetController,
        minHeight: MediaQuery.of(context).size.height * 0.7,
        elevation: 8,
        cornerRadius: 10,
        snapSpec: const SnapSpec(
          snap: true,
          snappings: [1.0, 0.7, 1.0],
          positioning: SnapPositioning.relativeToAvailableSpace,
        ),
        // footerBuilder: (context,snap)=>footer,
        extendBody: true,

        builder: (context, state) {
          return child;
        },
      );
    });

    print(result); // This is the result.
  }

  // @override
  // void dispose() {
  //   scrollController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(
        label: LocaleKeys.posts.localize,
      ),
      body: BlocProvider<InstagramCubit>(
        create: (BuildContext context) => serviceLocator()..loadData(),
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
          List<PostEntity> sortedPosts = [widget.initialImage] +
              widget.posts
                  .where((post) => post != widget.initialImage)
                  .toList();

          return RefreshIndicator(
            onRefresh: () async => controller.onRefresh(),
            child: ListView.separated(
              itemBuilder: (context, index) {
                final pageController = PageController();
                if (sortedPosts[index].type == 'advertisement') {
                  return FacebookAdvertisementCard(
                    post: sortedPosts[index],
                  );
                } else if (sortedPosts[index].type == 'facebook_post') {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Sizer(),
                      Padding(
                        padding:
                            EdgeInsetsDirectional.symmetric(horizontal: 20.w),
                        child: _buildMainAccountHeader(
                            post: sortedPosts[index], context: context),
                      ),
                      const Sizer(),
                      SizedBox(
                        height: kToolbarHeight * 7,
                        child: PageView.builder(
                            controller: pageController,
                            scrollDirection: Axis.horizontal,
                            itemCount: sortedPosts[index].images!.length,
                            // itemCount: controller.feedPagingController
                            //     .itemList![index].images!.length,
                            onPageChanged: (i) {
                              controller.changeIndex(i);
                            },
                            itemBuilder: (context, i) {
                              return SocialImageViewer(
                                image: sortedPosts[index].images![i],
                                index: i + 1,
                                length: sortedPosts[index].images!.length,
                                onDoubleTap: () {
                                  sortedPosts[index].isLove =
                                      !sortedPosts[index].isLove;
                                  setState(() {});
                                },
                              );
                            }),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      if (sortedPosts[index].images!.length > 1)
                        Center(
                          child: SizedBox(
                            height: 10.h,
                            child: ListView.separated(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: sortedPosts[index].images!.length,
                                separatorBuilder: (context, index) =>
                                    const Sizer(
                                      width: 3,
                                    ),
                                itemBuilder: (context, index) {
                                  return CircleAvatar(
                                    radius: 10.r,
                                    backgroundColor: state.pageIndex == index
                                        ? AppColors.SECONDARY_COLOR
                                        : Theme.of(context).primaryColor,
                                  );
                                }),
                          ),
                        ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Padding(
                        padding:
                            EdgeInsetsDirectional.symmetric(horizontal: 20.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  IconAppButton(
                                    icon: sortedPosts[index].isLove == true
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    onPressed: () async {
                                      var reacted = await controller.onReact(
                                        params: PostReactParams(
                                          postId: sortedPosts[index].id,
                                          react: 'love',
                                        ),
                                      );
                                      if (reacted == true) {
                                        sortedPosts[index].isLove =
                                            !sortedPosts[index].isLove;
                                        if (sortedPosts[index].isLove ==
                                            false) {
                                          sortedPosts[index].loveCount =
                                              (sortedPosts[index].loveCount -
                                                  1);
                                        } else {
                                          sortedPosts[index].loveCount =
                                              (sortedPosts[index].loveCount +
                                                  1);
                                        }
                                      }
                                      setState(() {});
                                    },
                                    color: sortedPosts[index].isLove == true
                                        ? Colors.red
                                        : Colors.grey,
                                    size: 25,
                                  ),
                                  Sizer(
                                    width: 10.w,
                                  ),
                                  Label(
                                    text:
                                        sortedPosts[index].loveCount.toString(),
                                    style: Styles.mediumText(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const Sizer(),
                                  IconAppButton(
                                    icon: FontAwesomeIcons.comment,
                                    onPressed: () {
                                      // if (!serviceLocator<UserCubit>()
                                      //     .isLoggedIn) {
                                      //   context.push(Routes.LOGIN);
                                      // } else {
                                      //   showCommentsBottomSheetInstagram(
                                      //       context,
                                      //       commentCount: controller.feedPagingController
                                      //           .itemList?[index].commentsCount
                                      //           .toString() ??
                                      //           '',
                                      //       comment: state.postComments![index],
                                      //       );
                                      // }
                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        isDismissible: true,
                                        backgroundColor: Colors.transparent,
                                        builder: (context) {
                                          return BlocProvider.value(
                                            value:
                                                serviceLocator<InstagramCubit>()
                                                  ..loadComments(context,
                                                      sortedPosts[index].id),
                                            child: GestureDetector(
                                              behavior: HitTestBehavior.opaque,
                                              onTap: () {
                                                FocusScope.of(context)
                                                    .unfocus();
                                              },
                                              child: InstagramPostComments(
                                                postId: sortedPosts[index].id,
                                                commentCount: sortedPosts[index]
                                                    .commentsCount
                                                    .toString(),
                                                onCommentReply:
                                                    (ReplyOnCommentParams
                                                        params) async {
                                                  var result = await controller
                                                      .replyOnComment(
                                                    params:
                                                        ReplyOnCommentParams(
                                                            postId:
                                                                params.postId,
                                                            content:
                                                                params.content,
                                                            commentId: params
                                                                .commentId),
                                                  );
                                                  var currentPost = sortedPosts
                                                      .firstWhere((element) =>
                                                          element.id ==
                                                          params.postId);
                                                  currentPost.commentsCount =
                                                      (currentPost
                                                              .commentsCount +
                                                          1);
                                                  return result;
                                                },
                                                onAddComment: (PostCommentParams
                                                    params) async {
                                                  var result = await controller
                                                      .onPostComment(
                                                          params: params);
                                                  return result;
                                                },
                                                onDeleteComment:
                                                    (String id) async {
                                                  return await controller
                                                      .deleteComment(
                                                          context: context,
                                                          commentId: id,
                                                          postId:
                                                              sortedPosts[index]
                                                                  .id,
                                                          from: 'feed');
                                                  // print(result);
                                                },
                                                onDeleteReply:
                                                    (String id) async {
                                                  return await controller
                                                      .deleteComment(
                                                          context: context,
                                                          commentId: id,
                                                          postId:
                                                              sortedPosts[index]
                                                                  .id,
                                                          from: 'feed');
                                                },
                                                onEditComment:
                                                    (PostCommentParams
                                                        params) async {
                                                  var result = await controller
                                                      .editComment(
                                                          params: params);
                                                  return result;
                                                },
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    color: Colors.grey,
                                    size: 25,
                                  ),
                                  Sizer(
                                    width: 20.w,
                                  ),
                                  Label(
                                    text: sortedPosts[index]
                                        .commentsCount
                                        .toString(),
                                    style: Styles.mediumText(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            const Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Sizer(
                        height: 5.h,
                      ),
                      if (sortedPosts[index].content!.isNotEmpty)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsetsDirectional.symmetric(
                                    horizontal: 20.w),
                                child: RichText(
                                  text: WidgetSpan(
                                      child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _isExpanded = !_isExpanded;
                                      });
                                    },
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            sortedPosts[index].content ?? '',
                                            textAlign: _isArabic(
                                                    sortedPosts[index]
                                                            .content ??
                                                        '')
                                                ? TextAlign.right
                                                : TextAlign.left,
                                            style: Styles.mediumText(
                                                fontSize: 60.sp),
                                            maxLines: _isExpanded ? null : 3,
                                            overflow: _isExpanded
                                                ? null
                                                : TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                                ),
                              ),
                            ),
                          ],
                        ),
                      // if (sortedPosts[index]
                      //     .content!.isEmpty) ...[
                      //   InkWell(
                      //       onTap: () {
                      //         showModalBottomSheet(
                      //             context: context,
                      //             isScrollControlled: true,
                      //             backgroundColor: Colors.transparent,
                      //             builder: (context) {
                      //               return Stack(
                      //                 alignment:
                      //                     AlignmentDirectional.bottomCenter,
                      //                 children: [
                      //                   Container(
                      //                       color: Colors.transparent),
                      //                   DraggableScrollableSheet(
                      //                     initialChildSize:
                      //                         isKeyboardVisible(context)
                      //                             ? 0.9
                      //                             : 0.6,
                      //                     minChildSize: 0.4,
                      //                     maxChildSize: 0.9,
                      //                     expand: false,
                      //                     builder:
                      //                         (context, scrollController) {
                      //                       return Container(
                      //                         decoration: BoxDecoration(
                      //                           color: context.isDarkMode
                      //                               ? Colors.grey[900]
                      //                               : Colors.white,
                      //                           borderRadius:
                      //                               const BorderRadius.only(
                      //                             topLeft:
                      //                                 Radius.circular(20),
                      //                             topRight:
                      //                                 Radius.circular(20),
                      //                           ),
                      //                         ),
                      //                         child: Column(
                      //                           children: <Widget>[
                      //                             Expanded(
                      //                               child:
                      //                                   BlocProvider.value(
                      //                                 value: serviceLocator<
                      //                                     InstagramCubit>()
                      //                                   ..loadComments(
                      //                                       context,
                      //                                       controller
                      //                                           .feedPagingController
                      //                                           .itemList![
                      //                                               index]
                      //                                           .id),
                      //                                 child:
                      //                                     InstagramPostComments(
                      //                                       commentCount: controller.feedPagingController
                      //                                           .itemList?[index].commentsCount
                      //                                           .toString() ??
                      //                                           '',
                      //                                   isShown: true,
                      //                                   postId: controller
                      //                                       .feedPagingController
                      //                                       .itemList![
                      //                                           index]
                      //                                       .id,
                      //                                   onCommentReply:
                      //                                       (ReplyOnCommentParams
                      //                                           params) async {
                      //                                     var result =
                      //                                         await controller
                      //                                             .replyOnComment(
                      //                                       params: ReplyOnCommentParams(
                      //                                           postId: params
                      //                                               .postId,
                      //                                           content: params
                      //                                               .content,
                      //                                           commentId:
                      //                                               params
                      //                                                   .commentId),
                      //                                     );
                      //                                     var currentPost = controller
                      //                                         .feedPagingController
                      //                                         .itemList
                      //                                         ?.firstWhere((element) =>
                      //                                             element
                      //                                                 .id ==
                      //                                             params
                      //                                                 .postId);
                      //                                     currentPost
                      //                                             ?.commentsCount =
                      //                                         (currentPost
                      //                                                 .commentsCount +
                      //                                             1);
                      //                                     return result;
                      //                                   },
                      //                                   onAddComment:
                      //                                       (PostCommentParams
                      //                                           params) async {
                      //                                     var result = await controller
                      //                                         .onPostComment(
                      //                                             params:
                      //                                                 params);
                      //                                     return result;
                      //                                   },
                      //                                   onDeleteComment:
                      //                                       (String
                      //                                           id) async {
                      //                                     return await controller.deleteComment(
                      //                                         context:
                      //                                             context,
                      //                                         commentId: id,
                      //                                         postId: controller
                      //                                             .feedPagingController
                      //                                             .itemList![
                      //                                                 index]
                      //                                             .id,
                      //                                         from: 'feed');
                      //                                   },
                      //                                   onDeleteReply:
                      //                                       (String
                      //                                           id) async {
                      //                                     return await controller.deleteComment(
                      //                                         context:
                      //                                             context,
                      //                                         commentId: id,
                      //                                         postId: controller
                      //                                             .feedPagingController
                      //                                             .itemList![
                      //                                                 index]
                      //                                             .id,
                      //                                         from: 'feed');
                      //                                   },
                      //                                   onEditComment:
                      //                                       (PostCommentParams
                      //                                           params) async {
                      //                                     var result =
                      //                                         await controller
                      //                                             .editComment(
                      //                                                 params:
                      //                                                     params);
                      //                                     return result;
                      //                                   },
                      //                                 ),
                      //                               ),
                      //                             ),
                      //                             Divider(
                      //                                 color:
                      //                                     Colors.grey[800]),
                      //                             Row(
                      //                               children: [
                      //                                 const ProfileImage(
                      //                                   accountId: 0,
                      //                                   userId: '',
                      //                                 ),
                      //                                 const Sizer(),
                      //                                 Expanded(
                      //                                     child:
                      //                                         TextFormField(
                      //                                   maxLines: null,
                      //                                   controller:
                      //                                       commentTextController,
                      //                                   onChanged: (v) {
                      //                                     setState(() {});
                      //                                   },
                      //                                   style: Styles
                      //                                       .headerText(
                      //                                           fontSize:
                      //                                               26),
                      //                                   decoration:
                      //                                       InputDecoration(
                      //                                     fillColor:
                      //                                         Colors.white,
                      //                                     contentPadding:
                      //                                         const EdgeInsets
                      //                                             .all(5),
                      //                                     hintText:
                      //                                         '${LocaleKeys.typeYourComment.localize} ....',
                      //                                     hintStyle: Styles
                      //                                         .mediumText(),
                      //                                   ),
                      //                                 )),
                      //                                 const Sizer(),
                      //                                 IconAppButton(
                      //                                     icon: Icons.send,
                      //                                     size: 20,
                      //                                     isCircle: true,
                      //                                     onPressed:
                      //                                         () async {
                      //                                       CommentEntity data = await controller.onPostComment(
                      //                                           params: PostCommentParams(
                      //                                               content:
                      //                                                   commentTextController
                      //                                                       .text,
                      //                                               postId: controller
                      //                                                   .feedPagingController
                      //                                                   .itemList![index]
                      //                                                   .id));
                      //
                      //                                       controller
                      //                                           .commentsPagingController
                      //                                           .itemList
                      //                                           ?.insert(
                      //                                         0,
                      //                                         CommentModel(
                      //                                           id: data.id,
                      //                                           content:
                      //                                               commentTextController
                      //                                                   .text,
                      //                                           post: controller
                      //                                               .feedPagingController
                      //                                               .itemList![
                      //                                                   index]
                      //                                               .id,
                      //                                           createdAt:
                      //                                               DateTime
                      //                                                   .now(),
                      //                                           loveCount: data
                      //                                               .loveCount,
                      //                                           angryCount:
                      //                                               data.angryCount,
                      //                                           likesCount:
                      //                                               data.likesCount,
                      //                                           repliesCount:
                      //                                               data.repliesCount,
                      //                                           sadCount: data
                      //                                               .sadCount,
                      //                                           wowCount: data
                      //                                               .wowCount,
                      //                                           isAngry:
                      //                                               false,
                      //                                           isLikes:
                      //                                               false,
                      //                                           isLove:
                      //                                               false,
                      //                                           isSad:
                      //                                               false,
                      //                                           isWow:
                      //                                               false,
                      //                                           user:
                      //                                               TwitterUserEntity(
                      //                                             id: user!
                      //                                                 .id,
                      //                                             firstName:
                      //                                                 user.firstName,
                      //                                             lastName:
                      //                                                 user.lastName,
                      //                                             createdAt:
                      //                                                 DateTime
                      //                                                     .now(),
                      //                                             image:
                      //                                                 user.profilePicture ??
                      //                                                     '',
                      //                                             email:
                      //                                                 user.email ??
                      //                                                     '',
                      //                                             isDocumented:
                      //                                                 false,
                      //                                           ),
                      //                                         ),
                      //                                       );
                      //                                       commentTextController
                      //                                           .clear();
                      //                                       FocusScope.of(
                      //                                               context)
                      //                                           .unfocus();
                      //                                       setState(() {});
                      //                                     })
                      //                               ],
                      //                             )
                      //                           ],
                      //                         ),
                      //                       );
                      //                     },
                      //                   ),
                      //                 ],
                      //               );
                      //             });
                      //       },
                      //       child: Label(
                      //           text: LocaleKeys.showComments.localize))
                      // ],
                      if (sortedPosts[index].content!.isEmpty &&
                          (sortedPosts[index].firstComment != null))
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.w, vertical: 10.h),
                          child: RichText(
                              text: TextSpan(children: [
                            TextSpan(
                                text:
                                    '${sortedPosts[index].firstComment?.firstName} ${sortedPosts[index].firstComment?.lastName}\t\t',
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => context.push(
                                      Routes.INSTAGRAMPROFILE,
                                      extra: sortedPosts[index].user.id),
                                style: Styles.mediumText()),
                            TextSpan(
                                text: sortedPosts[index].firstComment == null
                                    ? ''
                                    : sortedPosts[index].firstComment?.content,
                                style: Styles.mediumText(
                                  color: context.isDarkMode
                                      ? AppColors.LIGHT_GRAY_COLOR
                                      : AppColors.DARK_GRAY_COLOR,
                                )),
                          ])),
                        ),
                      Padding(
                        padding:
                            EdgeInsetsDirectional.symmetric(horizontal: 20.w),
                        child: Text(sortedPosts[index].sinceTime,
                            style: Styles.mediumText(
                                color: AppColors.GREY_NORMAL_COLOR)),
                      ),
                    ],
                  );
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                            EdgeInsetsDirectional.symmetric(horizontal: 20.w),
                        child: _buildMainAccountHeader(
                            post: sortedPosts[index], context: context),
                      ),
                      const Sizer(),
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
                          item: sortedPosts[index],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.symmetric(
                            horizontal: 20.w, vertical: 10.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  IconAppButton(
                                    icon: sortedPosts[index].isLove == true
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    onPressed: () async {
                                      var reacted = await controller.onReact(
                                        params: PostReactParams(
                                          postId: sortedPosts[index].id,
                                          react: 'love',
                                        ),
                                      );
                                      if (reacted == true) {
                                        sortedPosts[index].isLove =
                                            !sortedPosts[index].isLove;
                                        if (sortedPosts[index].isLove ==
                                            false) {
                                          sortedPosts[index].loveCount =
                                              (sortedPosts[index].loveCount -
                                                  1);
                                        } else {
                                          sortedPosts[index].loveCount =
                                              (sortedPosts[index].loveCount +
                                                  1);
                                        }
                                      }
                                      setState(() {});
                                    },
                                    color: sortedPosts[index].isLove == true
                                        ? Colors.red
                                        : Colors.grey,
                                    size: 25,
                                  ),
                                  Sizer(
                                    width: 10.w,
                                  ),
                                  Label(
                                    text:
                                        sortedPosts[index].loveCount.toString(),
                                    style: Styles.mediumText(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const Sizer(),
                                  IconAppButton(
                                    icon: FontAwesomeIcons.comment,
                                    onPressed: () {
                                      // if (!serviceLocator<UserCubit>()
                                      //     .isLoggedIn) {
                                      //   context.push(Routes.LOGIN);
                                      // } else {
                                      //   showCommentsBottomSheetInstagram(
                                      //       context,
                                      //       commentCount: controller.feedPagingController
                                      //           .itemList?[index].commentsCount
                                      //           .toString() ??
                                      //           '',
                                      //       comment: state.postComments![index],
                                      //       );
                                      // }
                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        isDismissible: true,
                                        backgroundColor: Colors.transparent,
                                        builder: (context) {
                                          return BlocProvider.value(
                                            value:
                                                serviceLocator<InstagramCubit>()
                                                  ..loadComments(context,
                                                      sortedPosts[index].id),
                                            child: GestureDetector(
                                              behavior: HitTestBehavior.opaque,
                                              onTap: () {
                                                FocusScope.of(context)
                                                    .unfocus();
                                              },
                                              child: InstagramPostComments(
                                                postId: sortedPosts[index].id,
                                                commentCount: sortedPosts[index]
                                                    .commentsCount
                                                    .toString(),
                                                onCommentReply:
                                                    (ReplyOnCommentParams
                                                        params) async {
                                                  var result = await controller
                                                      .replyOnComment(
                                                    params:
                                                        ReplyOnCommentParams(
                                                            postId:
                                                                params.postId,
                                                            content:
                                                                params.content,
                                                            commentId: params
                                                                .commentId),
                                                  );
                                                  var currentPost = sortedPosts
                                                      .firstWhere((element) =>
                                                          element.id ==
                                                          params.postId);
                                                  currentPost.commentsCount =
                                                      (currentPost
                                                              .commentsCount +
                                                          1);
                                                  return result;
                                                },
                                                onAddComment: (PostCommentParams
                                                    params) async {
                                                  var result = await controller
                                                      .onPostComment(
                                                          params: params);
                                                  return result;
                                                },
                                                onDeleteComment:
                                                    (String id) async {
                                                  return await controller
                                                      .deleteComment(
                                                          context: context,
                                                          commentId: id,
                                                          postId:
                                                              sortedPosts[index]
                                                                  .id,
                                                          from: 'feed');
                                                  // print(result);
                                                },
                                                onDeleteReply:
                                                    (String id) async {
                                                  return await controller
                                                      .deleteComment(
                                                          context: context,
                                                          commentId: id,
                                                          postId:
                                                              sortedPosts[index]
                                                                  .id,
                                                          from: 'feed');
                                                },
                                                onEditComment:
                                                    (PostCommentParams
                                                        params) async {
                                                  var result = await controller
                                                      .editComment(
                                                          params: params);
                                                  return result;
                                                },
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    color: Colors.grey,
                                    size: 25,
                                  ),
                                  Sizer(
                                    width: 20.w,
                                  ),
                                  Label(
                                    text: sortedPosts[index]
                                        .commentsCount
                                        .toString(),
                                    style: Styles.mediumText(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            const Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [],
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (sortedPosts[index].content!.isNotEmpty)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsetsDirectional.symmetric(
                                    horizontal: 20.w),
                                child: RichText(
                                  text: WidgetSpan(
                                      child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _isExpanded = !_isExpanded;
                                      });
                                    },
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            sortedPosts[index].content ?? '',
                                            textAlign: _isArabic(
                                                    sortedPosts[index]
                                                            .content ??
                                                        '')
                                                ? TextAlign.right
                                                : TextAlign.left,
                                            style: Styles.mediumText(
                                                fontSize: 60.sp),
                                            maxLines: _isExpanded ? null : 3,
                                            overflow: _isExpanded
                                                ? null
                                                : TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                                ),
                              ),
                            ),
                          ],
                        ),
                      Padding(
                        padding:
                            EdgeInsetsDirectional.symmetric(horizontal: 20.w),
                        child: Text(sortedPosts[index].sinceTime,
                            style: Styles.mediumText(
                                color: AppColors.GREY_NORMAL_COLOR)),
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
              separatorBuilder: (context, index) => const Sizer(),
              itemCount: sortedPosts.length,
            ),
          );
        }),
      ),
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
            context.push(Routes.INSTAGRAMPROFILE, extra: post.user.id);
          },
          child: CircleAvatar(
            radius: 32.r,
            backgroundColor: Colors.white,
            backgroundImage: NetworkImage(
                (post.user.image != null && post.user.image.isNotEmpty)
                    ? post.user.image
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
                    context.push(Routes.INSTAGRAMPROFILE, extra: post.user.id);
                  },
                  child: TextAppButton(
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 30.sp),
                      label: "${post.user.firstName} ${post.user.lastName}",
                      onPressed: () {
                        context.push(Routes.INSTAGRAMPROFILE,
                            extra: post.user.id);
                      }),
                ),
              ],
            ),
            // _buildActivityFeelingWidget(post),
          ],
        )),
      ],
    );
  }

  bool _isArabic(String text) {
    final arabicRegex = RegExp(r'[\u0600-\u06FF]');
    return arabicRegex.hasMatch(text);
  }
}
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
// import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
// import 'package:fourtyninehub/common/widgets/stateless/buttons/iconAppButton.dart';
// import 'package:fourtyninehub/common/widgets/stateless/buttons/text_button.dart';
// import 'package:fourtyninehub/common/widgets/stateless/images/social_image_viewer.dart';
// import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
// import 'package:fourtyninehub/core/enums/base_status_enum.dart';
// import 'package:fourtyninehub/core/error/failure.dart';
// import 'package:fourtyninehub/core/extensions/context_extension.dart';
// import 'package:fourtyninehub/core/extensions/string_extension.dart';
// import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
// import 'package:fourtyninehub/core/messages/messages.dart';
// import 'package:fourtyninehub/features/social_media/chat/chat_view/presentation/widgets/chat_stories.dart';
// import 'package:fourtyninehub/features/social_media/instagram/presentation/cubit/instagram_cubit.dart';
// import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/insta_reel_card.dart';
// import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/instagram_post_comments.dart';
// import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/instagram_suggest_people.dart';
// import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/post_entity.dart';
// import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/add_reply_usecase.dart';
// import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/post_comment_usecase.dart';
// import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/post_react_usecase.dart';
// import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/posts/facebook_advirtesement_card.dart';
// import 'package:fourtyninehub/features/social_media/stories/presentation/cubit/stories_cubit.dart';
// import 'package:fourtyninehub/res/style/app_colors.dart';
// import 'package:fourtyninehub/res/style/const.dart';
// import 'package:fourtyninehub/res/style/styles.dart';
// import 'package:fourtyninehub/routes/routes.dart';
// import 'package:fourtyninehub/service_locator/service_locator.dart';
// import 'package:go_router/go_router.dart';
// import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
// import 'package:snapping_bottom_sheet/snapping_bottom_sheet.dart';
//
// class InstagramProfilePostsView extends StatefulWidget {
//   const InstagramProfilePostsView({
//     super.key, required this.initialImage, required this.posts,
//   });
//   final PostEntity initialImage;
//   final List<PostEntity> posts;
//
//
//   @override
//   State<InstagramProfilePostsView> createState() => _InstagramProfilePostsViewState();
// }
//
// class _InstagramProfilePostsViewState extends State<InstagramProfilePostsView> {
//   final commentTextController = TextEditingController();
//   final SheetController sheetController = SheetController();
//   bool _isExpanded = false;
//   ScrollController scrollController = ScrollController();
//
//   void showAsBottomSheet(
//       {required Widget child, required Widget footer}) async {
//     final result = await showSnappingBottomSheet(context, builder: (context) {
//       return SnappingBottomSheetDialog(
//         controller: sheetController,
//         minHeight: MediaQuery.of(context).size.height * 0.7,
//         elevation: 8,
//         cornerRadius: 10,
//         snapSpec: const SnapSpec(
//           snap: true,
//           snappings: [1.0, 0.7, 1.0],
//           positioning: SnapPositioning.relativeToAvailableSpace,
//         ),
//         // footerBuilder: (context,snap)=>footer,
//         extendBody: true,
//
//         builder: (context, state) {
//           return child;
//         },
//       );
//     });
//
//     print(result); // This is the result.
//   }
//
//   // @override
//   // void dispose() {
//   //   scrollController.dispose();
//   //   super.dispose();
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: BackAppBar(
//         label: LocaleKeys.posts.localize,
//       ),
//       body: BlocProvider<InstagramCubit>(
//         create: (BuildContext context) =>serviceLocator()..loadData(),
//         child: BlocConsumer<InstagramCubit, InstagramState>(
//             listener: (context, state) {
//               if (state.status == StateStatus.error) {
//                 showErrorMessage(
//                   context,
//                   getFailureMessage(
//                     state.failure ?? UnknownFailure(''),
//                     context,
//                   ),
//                 );
//               }
//             }, builder: (context, state) {
//           final controller = context.read<InstagramCubit>();
//           List<PostEntity> sortedPosts = [widget.initialImage] + widget.posts.where((post) => post != widget.initialImage).toList();
//
//           return RefreshIndicator(
//             onRefresh: () async => controller.onRefresh(),
//             child: CustomScrollView(
//               controller: scrollController,
//               slivers: [
//                 // SliverToBoxAdapter(
//                 //   child: BlocProvider<StoryCubit>(
//                 //     create: (_) => serviceLocator()
//                 //       ..fetchStories()
//                 //       ..getMutedStories(),
//                 //     child: const ChatStories(),
//                 //   ),
//                 // ),
//                 // //hey ahmed dont forget this part
//                 // SliverToBoxAdapter(
//                 //   child: BlocProvider<InstagramCubit>(
//                 //     create: (_) => serviceLocator()..loadInstaSuggestedPeople(),
//                 //     child: const InstagramSuggestPeople(),
//                 //   ),
//                 // ),
//                 PagedSliverList<int, PostEntity>(
//                   pagingController: controller.feedPagingController,
//                   builderDelegate: PagedChildBuilderDelegate<PostEntity>(
//                     noItemsFoundIndicatorBuilder: (context) {
//                       return Center(
//                         child: Text(
//                           LocaleKeys.noPosts.localize,
//                           style: TextStyle(
//                             color: context.isDarkMode
//                                 ? AppColors.LIGHT_COLOR
//                                 : AppColors.DARK_BLUE_COLOR,
//                             fontSize: 18.sp,
//                           ),
//                         ),
//                       );
//                     },
//                     itemBuilder: (context, item, index) {
//                       final pageController = PageController();
//                       if (sortedPosts[index].type ==
//                           'advertisement') {
//                         return FacebookAdvertisementCard(
//                           post: sortedPosts[index],
//                         );
//                       } else if (controller
//                           .feedPagingController.itemList?[index].type ==
//                           'facebook_post') {
//                         return Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Sizer(),
//                             Padding(
//                               padding:
//                               EdgeInsetsDirectional.symmetric(horizontal: 20.w),
//                               child: _buildMainAccountHeader(
//                                   post: controller
//                                       .feedPagingController.itemList![index],
//                                   context: context),
//                             ),
//                             const Sizer(),
//                             SizedBox(
//                               height: kToolbarHeight * 7,
//                               child: PageView.builder(
//                                   controller: pageController,
//                                   scrollDirection: Axis.horizontal,
//                                   itemCount: controller.feedPagingController
//                                       .itemList![index].images!.length,
//                                   onPageChanged: (i) {
//                                     controller.changeIndex(i);
//                                   },
//                                   itemBuilder: (context, i) {
//                                     return SocialImageViewer(
//                                       image: controller.feedPagingController
//                                           .itemList![index].images![i],
//                                       index: i + 1,
//                                       length: controller.feedPagingController
//                                           .itemList![index].images!.length,
//                                       onDoubleTap: () {
//                                         controller.feedPagingController
//                                             .itemList?[index].isLove =
//                                         !controller.feedPagingController
//                                             .itemList![index].isLove;
//                                         setState(() {});
//                                       },
//                                     );
//                                   }),
//                             ),
//                             SizedBox(
//                               height: 10.h,
//                             ),
//                             if (sortedPosts[index]
//                                 .images!.length >
//                                 1)
//                               Center(
//                                 child: SizedBox(
//                                   height: 10.h,
//                                   child: ListView.separated(
//                                       shrinkWrap: true,
//                                       scrollDirection: Axis.horizontal,
//                                       itemCount: controller.feedPagingController
//                                           .itemList![index].images!.length,
//                                       separatorBuilder: (context, index) =>
//                                       const Sizer(
//                                         width: 3,
//                                       ),
//                                       itemBuilder: (context, index) {
//                                         return CircleAvatar(
//                                           radius: 10.r,
//                                           backgroundColor: state.pageIndex == index
//                                               ? AppColors.SECONDARY_COLOR
//                                               : Theme.of(context).primaryColor,
//                                         );
//                                       }),
//                                 ),
//                               ),
//                             SizedBox(
//                               height: 10.h,
//                             ),
//                             Padding(
//                               padding:
//                               EdgeInsetsDirectional.symmetric(horizontal: 20.w),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Expanded(
//                                     child: Row(
//                                       mainAxisAlignment: MainAxisAlignment.start,
//                                       children: [
//                                         IconAppButton(
//                                           icon: controller.feedPagingController
//                                               .itemList?[index].isLove ==
//                                               true
//                                               ? Icons.favorite
//                                               : Icons.favorite_border,
//                                           onPressed: () async {
//                                             var reacted = await controller.onReact(
//                                               params: PostReactParams(
//                                                 postId: controller
//                                                     .feedPagingController
//                                                     .itemList![index]
//                                                     .id,
//                                                 react: 'love',
//                                               ),
//                                             );
//                                             if (reacted == true) {
//                                               controller.feedPagingController
//                                                   .itemList?[index].isLove =
//                                               !controller.feedPagingController
//                                                   .itemList![index].isLove;
//                                               if (controller.feedPagingController
//                                                   .itemList?[index].isLove ==
//                                                   false) {
//                                                 controller
//                                                     .feedPagingController
//                                                     .itemList?[index]
//                                                     .loveCount = (controller
//                                                     .feedPagingController
//                                                     .itemList![index]
//                                                     .loveCount -
//                                                     1);
//                                               } else {
//                                                 controller
//                                                     .feedPagingController
//                                                     .itemList?[index]
//                                                     .loveCount = (controller
//                                                     .feedPagingController
//                                                     .itemList![index]
//                                                     .loveCount +
//                                                     1);
//                                               }
//                                             }
//                                             setState(() {});
//                                           },
//                                           color: controller.feedPagingController
//                                               .itemList?[index].isLove ==
//                                               true
//                                               ? Colors.red
//                                               : Colors.grey,
//                                           size: 25,
//                                         ),
//                                         Sizer(
//                                           width: 10.w,
//                                         ),
//                                         Label(
//                                           text: controller.feedPagingController
//                                               .itemList?[index].loveCount
//                                               .toString() ??
//                                               '',
//                                           style: Styles.mediumText(
//                                               fontWeight: FontWeight.bold),
//                                         ),
//                                         const Sizer(),
//                                         IconAppButton(
//                                           icon: FontAwesomeIcons.comment,
//                                           onPressed: () {
//                                             // if (!serviceLocator<UserCubit>()
//                                             //     .isLoggedIn) {
//                                             //   context.push(Routes.LOGIN);
//                                             // } else {
//                                             //   showCommentsBottomSheetInstagram(
//                                             //       context,
//                                             //       commentCount: controller.feedPagingController
//                                             //           .itemList?[index].commentsCount
//                                             //           .toString() ??
//                                             //           '',
//                                             //       comment: state.postComments![index],
//                                             //       );
//                                             // }
//                                             showModalBottomSheet(
//                                               context: context,
//                                               isScrollControlled: true,
//                                               isDismissible: true,
//                                               backgroundColor: Colors.transparent,
//                                               builder: (context) {
//                                                 return BlocProvider.value(
//                                                   value: serviceLocator<
//                                                       InstagramCubit>()
//                                                     ..loadComments(
//                                                         context,
//                                                         controller
//                                                             .feedPagingController
//                                                             .itemList![index]
//                                                             .id),
//                                                   child: GestureDetector(
//                                                     behavior:
//                                                     HitTestBehavior.opaque,
//                                                     onTap: () {
//                                                       FocusScope.of(context)
//                                                           .unfocus();
//                                                     },
//                                                     child: InstagramPostComments(
//                                                       postId: controller
//                                                           .feedPagingController
//                                                           .itemList![index]
//                                                           .id,
//                                                       commentCount: controller
//                                                           .feedPagingController
//                                                           .itemList?[index]
//                                                           .commentsCount
//                                                           .toString() ??
//                                                           '',
//                                                       onCommentReply:
//                                                           (ReplyOnCommentParams
//                                                       params) async {
//                                                         var result =
//                                                         await controller
//                                                             .replyOnComment(
//                                                           params:
//                                                           ReplyOnCommentParams(
//                                                               postId:
//                                                               params.postId,
//                                                               content: params
//                                                                   .content,
//                                                               commentId: params
//                                                                   .commentId),
//                                                         );
//                                                         var currentPost = controller
//                                                             .feedPagingController
//                                                             .itemList
//                                                             ?.firstWhere(
//                                                                 (element) =>
//                                                             element.id ==
//                                                                 params.postId);
//                                                         currentPost?.commentsCount =
//                                                         (currentPost
//                                                             .commentsCount +
//                                                             1);
//                                                         return result;
//                                                       },
//                                                       onAddComment:
//                                                           (PostCommentParams
//                                                       params) async {
//                                                         var result =
//                                                         await controller
//                                                             .onPostComment(
//                                                             params: params);
//                                                         return result;
//                                                       },
//                                                       onDeleteComment:
//                                                           (String id) async {
//                                                         return await controller
//                                                             .deleteComment(
//                                                             context: context,
//                                                             commentId: id,
//                                                             postId: controller
//                                                                 .feedPagingController
//                                                                 .itemList![
//                                                             index]
//                                                                 .id,
//                                                             from: 'feed');
//                                                         // print(result);
//                                                       },
//                                                       onDeleteReply:
//                                                           (String id) async {
//                                                         return await controller
//                                                             .deleteComment(
//                                                             context: context,
//                                                             commentId: id,
//                                                             postId: controller
//                                                                 .feedPagingController
//                                                                 .itemList![
//                                                             index]
//                                                                 .id,
//                                                             from: 'feed');
//                                                       },
//                                                       onEditComment:
//                                                           (PostCommentParams
//                                                       params) async {
//                                                         var result =
//                                                         await controller
//                                                             .editComment(
//                                                             params: params);
//                                                         return result;
//                                                       },
//                                                     ),
//                                                   ),
//                                                 );
//                                               },
//                                             );
//                                           },
//                                           color: Colors.grey,
//                                           size: 25,
//                                         ),
//                                         Sizer(
//                                           width: 20.w,
//                                         ),
//                                         Label(
//                                           text: controller.feedPagingController
//                                               .itemList?[index].commentsCount
//                                               .toString() ??
//                                               '',
//                                           style: Styles.mediumText(
//                                               fontWeight: FontWeight.bold),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   const Expanded(
//                                     child: Row(
//                                       mainAxisAlignment: MainAxisAlignment.end,
//                                       children: [],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             Sizer(
//                               height: 5.h,
//                             ),
//                             if (sortedPosts[index]
//                                 .content!.isNotEmpty)
//                               Row(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Expanded(
//                                     child: Padding(
//                                       padding: EdgeInsetsDirectional.symmetric(
//                                           horizontal: 20.w),
//                                       child: RichText(
//                                         text: WidgetSpan(child: GestureDetector(
//                                           onTap: () {
//                                             setState(() {
//                                               _isExpanded = !_isExpanded;
//                                             });
//                                           },
//                                           child: Row(
//                                             children: [
//                                               Expanded(
//                                                 child: Text(
//                                                   sortedPosts[index].content ?? '',
//                                                   textAlign: _isArabic(sortedPosts[index]
//                                                       .content ??
//                                                       '')
//                                                       ? TextAlign.right
//                                                       : TextAlign.left,
//                                                   style: Styles.mediumText(
//                                                       fontSize: 60.sp),
//                                                   maxLines: _isExpanded ? null : 3,
//                                                   overflow: _isExpanded
//                                                       ? null
//                                                       : TextOverflow.ellipsis,
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         )),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             // if (sortedPosts[index]
//                             //     .content!.isEmpty) ...[
//                             //   InkWell(
//                             //       onTap: () {
//                             //         showModalBottomSheet(
//                             //             context: context,
//                             //             isScrollControlled: true,
//                             //             backgroundColor: Colors.transparent,
//                             //             builder: (context) {
//                             //               return Stack(
//                             //                 alignment:
//                             //                     AlignmentDirectional.bottomCenter,
//                             //                 children: [
//                             //                   Container(
//                             //                       color: Colors.transparent),
//                             //                   DraggableScrollableSheet(
//                             //                     initialChildSize:
//                             //                         isKeyboardVisible(context)
//                             //                             ? 0.9
//                             //                             : 0.6,
//                             //                     minChildSize: 0.4,
//                             //                     maxChildSize: 0.9,
//                             //                     expand: false,
//                             //                     builder:
//                             //                         (context, scrollController) {
//                             //                       return Container(
//                             //                         decoration: BoxDecoration(
//                             //                           color: context.isDarkMode
//                             //                               ? Colors.grey[900]
//                             //                               : Colors.white,
//                             //                           borderRadius:
//                             //                               const BorderRadius.only(
//                             //                             topLeft:
//                             //                                 Radius.circular(20),
//                             //                             topRight:
//                             //                                 Radius.circular(20),
//                             //                           ),
//                             //                         ),
//                             //                         child: Column(
//                             //                           children: <Widget>[
//                             //                             Expanded(
//                             //                               child:
//                             //                                   BlocProvider.value(
//                             //                                 value: serviceLocator<
//                             //                                     InstagramCubit>()
//                             //                                   ..loadComments(
//                             //                                       context,
//                             //                                       controller
//                             //                                           .feedPagingController
//                             //                                           .itemList![
//                             //                                               index]
//                             //                                           .id),
//                             //                                 child:
//                             //                                     InstagramPostComments(
//                             //                                       commentCount: controller.feedPagingController
//                             //                                           .itemList?[index].commentsCount
//                             //                                           .toString() ??
//                             //                                           '',
//                             //                                   isShown: true,
//                             //                                   postId: controller
//                             //                                       .feedPagingController
//                             //                                       .itemList![
//                             //                                           index]
//                             //                                       .id,
//                             //                                   onCommentReply:
//                             //                                       (ReplyOnCommentParams
//                             //                                           params) async {
//                             //                                     var result =
//                             //                                         await controller
//                             //                                             .replyOnComment(
//                             //                                       params: ReplyOnCommentParams(
//                             //                                           postId: params
//                             //                                               .postId,
//                             //                                           content: params
//                             //                                               .content,
//                             //                                           commentId:
//                             //                                               params
//                             //                                                   .commentId),
//                             //                                     );
//                             //                                     var currentPost = controller
//                             //                                         .feedPagingController
//                             //                                         .itemList
//                             //                                         ?.firstWhere((element) =>
//                             //                                             element
//                             //                                                 .id ==
//                             //                                             params
//                             //                                                 .postId);
//                             //                                     currentPost
//                             //                                             ?.commentsCount =
//                             //                                         (currentPost
//                             //                                                 .commentsCount +
//                             //                                             1);
//                             //                                     return result;
//                             //                                   },
//                             //                                   onAddComment:
//                             //                                       (PostCommentParams
//                             //                                           params) async {
//                             //                                     var result = await controller
//                             //                                         .onPostComment(
//                             //                                             params:
//                             //                                                 params);
//                             //                                     return result;
//                             //                                   },
//                             //                                   onDeleteComment:
//                             //                                       (String
//                             //                                           id) async {
//                             //                                     return await controller.deleteComment(
//                             //                                         context:
//                             //                                             context,
//                             //                                         commentId: id,
//                             //                                         postId: controller
//                             //                                             .feedPagingController
//                             //                                             .itemList![
//                             //                                                 index]
//                             //                                             .id,
//                             //                                         from: 'feed');
//                             //                                   },
//                             //                                   onDeleteReply:
//                             //                                       (String
//                             //                                           id) async {
//                             //                                     return await controller.deleteComment(
//                             //                                         context:
//                             //                                             context,
//                             //                                         commentId: id,
//                             //                                         postId: controller
//                             //                                             .feedPagingController
//                             //                                             .itemList![
//                             //                                                 index]
//                             //                                             .id,
//                             //                                         from: 'feed');
//                             //                                   },
//                             //                                   onEditComment:
//                             //                                       (PostCommentParams
//                             //                                           params) async {
//                             //                                     var result =
//                             //                                         await controller
//                             //                                             .editComment(
//                             //                                                 params:
//                             //                                                     params);
//                             //                                     return result;
//                             //                                   },
//                             //                                 ),
//                             //                               ),
//                             //                             ),
//                             //                             Divider(
//                             //                                 color:
//                             //                                     Colors.grey[800]),
//                             //                             Row(
//                             //                               children: [
//                             //                                 const ProfileImage(
//                             //                                   accountId: 0,
//                             //                                   userId: '',
//                             //                                 ),
//                             //                                 const Sizer(),
//                             //                                 Expanded(
//                             //                                     child:
//                             //                                         TextFormField(
//                             //                                   maxLines: null,
//                             //                                   controller:
//                             //                                       commentTextController,
//                             //                                   onChanged: (v) {
//                             //                                     setState(() {});
//                             //                                   },
//                             //                                   style: Styles
//                             //                                       .headerText(
//                             //                                           fontSize:
//                             //                                               26),
//                             //                                   decoration:
//                             //                                       InputDecoration(
//                             //                                     fillColor:
//                             //                                         Colors.white,
//                             //                                     contentPadding:
//                             //                                         const EdgeInsets
//                             //                                             .all(5),
//                             //                                     hintText:
//                             //                                         '${LocaleKeys.typeYourComment.localize} ....',
//                             //                                     hintStyle: Styles
//                             //                                         .mediumText(),
//                             //                                   ),
//                             //                                 )),
//                             //                                 const Sizer(),
//                             //                                 IconAppButton(
//                             //                                     icon: Icons.send,
//                             //                                     size: 20,
//                             //                                     isCircle: true,
//                             //                                     onPressed:
//                             //                                         () async {
//                             //                                       CommentEntity data = await controller.onPostComment(
//                             //                                           params: PostCommentParams(
//                             //                                               content:
//                             //                                                   commentTextController
//                             //                                                       .text,
//                             //                                               postId: controller
//                             //                                                   .feedPagingController
//                             //                                                   .itemList![index]
//                             //                                                   .id));
//                             //
//                             //                                       controller
//                             //                                           .commentsPagingController
//                             //                                           .itemList
//                             //                                           ?.insert(
//                             //                                         0,
//                             //                                         CommentModel(
//                             //                                           id: data.id,
//                             //                                           content:
//                             //                                               commentTextController
//                             //                                                   .text,
//                             //                                           post: controller
//                             //                                               .feedPagingController
//                             //                                               .itemList![
//                             //                                                   index]
//                             //                                               .id,
//                             //                                           createdAt:
//                             //                                               DateTime
//                             //                                                   .now(),
//                             //                                           loveCount: data
//                             //                                               .loveCount,
//                             //                                           angryCount:
//                             //                                               data.angryCount,
//                             //                                           likesCount:
//                             //                                               data.likesCount,
//                             //                                           repliesCount:
//                             //                                               data.repliesCount,
//                             //                                           sadCount: data
//                             //                                               .sadCount,
//                             //                                           wowCount: data
//                             //                                               .wowCount,
//                             //                                           isAngry:
//                             //                                               false,
//                             //                                           isLikes:
//                             //                                               false,
//                             //                                           isLove:
//                             //                                               false,
//                             //                                           isSad:
//                             //                                               false,
//                             //                                           isWow:
//                             //                                               false,
//                             //                                           user:
//                             //                                               TwitterUserEntity(
//                             //                                             id: user!
//                             //                                                 .id,
//                             //                                             firstName:
//                             //                                                 user.firstName,
//                             //                                             lastName:
//                             //                                                 user.lastName,
//                             //                                             createdAt:
//                             //                                                 DateTime
//                             //                                                     .now(),
//                             //                                             image:
//                             //                                                 user.profilePicture ??
//                             //                                                     '',
//                             //                                             email:
//                             //                                                 user.email ??
//                             //                                                     '',
//                             //                                             isDocumented:
//                             //                                                 false,
//                             //                                           ),
//                             //                                         ),
//                             //                                       );
//                             //                                       commentTextController
//                             //                                           .clear();
//                             //                                       FocusScope.of(
//                             //                                               context)
//                             //                                           .unfocus();
//                             //                                       setState(() {});
//                             //                                     })
//                             //                               ],
//                             //                             )
//                             //                           ],
//                             //                         ),
//                             //                       );
//                             //                     },
//                             //                   ),
//                             //                 ],
//                             //               );
//                             //             });
//                             //       },
//                             //       child: Label(
//                             //           text: LocaleKeys.showComments.localize))
//                             // ],
//                             if (sortedPosts[index]
//                                 .content!.isEmpty &&
//                                 (sortedPosts[index]
//                                     .firstComment !=
//                                     null))
//                               Padding(
//                                 padding:  EdgeInsets.symmetric(horizontal: 20.w,vertical: 10.h),
//                                 child: RichText(
//                                     text: TextSpan(children: [
//                                       TextSpan(
//                                           text:
//                                           '${sortedPosts[index].firstComment?.firstName} ${sortedPosts[index].firstComment?.lastName}\t\t',
//                                           recognizer: TapGestureRecognizer()
//                                             ..onTap = () => context.push(
//                                                 Routes.INSTAGRAMPROFILE,
//                                                 extra: controller.feedPagingController
//                                                     .itemList?[index].user.id),
//                                           style: Styles.mediumText()),
//                                       TextSpan(
//                                           text: controller.feedPagingController
//                                               .itemList![index].firstComment ==
//                                               null
//                                               ? ''
//                                               : controller.feedPagingController
//                                               .itemList?[index].firstComment?.content,
//                                           style: Styles.mediumText(
//                                             color: context.isDarkMode
//                                                 ? AppColors.LIGHT_GRAY_COLOR
//                                                 : AppColors.DARK_GRAY_COLOR,
//                                           )),
//                                     ])),
//                               ),
//                             Padding(
//                               padding:
//                               EdgeInsetsDirectional.symmetric(horizontal: 20.w),
//                               child: Text(
//                                   sortedPosts[index]
//                                       .sinceTime ??
//                                       '',
//                                   style: Styles.mediumText(
//                                       color: AppColors.GREY_NORMAL_COLOR)),
//                             ),
//                           ],
//                         );
//                       } else {
//                         return Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Padding(
//                               padding:
//                               EdgeInsetsDirectional.symmetric(horizontal: 20.w),
//                               child: _buildMainAccountHeader(
//                                   post: controller
//                                       .feedPagingController.itemList![index],
//                                   context: context),
//                             ),
//                             const Sizer(),
//                             Container(
//                               height: 5.h,
//                               width: double.infinity,
//                               color: AppColors.DIVIDER_GRAY_COLOR2,
//                             ),
//                             Container(
//                               color: Colors.black,
//                               height: 300.h,
//                               width: double.infinity,
//                               child: InstagramReelCard(
//                                 item: controller
//                                     .feedPagingController.itemList![index],
//                               ),
//                             ),
//                             Padding(
//                               padding:
//                               EdgeInsetsDirectional.symmetric(horizontal: 20.w,vertical: 10.h),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Expanded(
//                                     child: Row(
//                                       mainAxisAlignment: MainAxisAlignment.start,
//                                       children: [
//                                         IconAppButton(
//                                           icon: controller.feedPagingController
//                                               .itemList?[index].isLove ==
//                                               true
//                                               ? Icons.favorite
//                                               : Icons.favorite_border,
//                                           onPressed: () async {
//                                             var reacted = await controller.onReact(
//                                               params: PostReactParams(
//                                                 postId: controller
//                                                     .feedPagingController
//                                                     .itemList![index]
//                                                     .id,
//                                                 react: 'love',
//                                               ),
//                                             );
//                                             if (reacted == true) {
//                                               controller.feedPagingController
//                                                   .itemList?[index].isLove =
//                                               !controller.feedPagingController
//                                                   .itemList![index].isLove;
//                                               if (controller.feedPagingController
//                                                   .itemList?[index].isLove ==
//                                                   false) {
//                                                 controller
//                                                     .feedPagingController
//                                                     .itemList?[index]
//                                                     .loveCount = (controller
//                                                     .feedPagingController
//                                                     .itemList![index]
//                                                     .loveCount -
//                                                     1);
//                                               } else {
//                                                 controller
//                                                     .feedPagingController
//                                                     .itemList?[index]
//                                                     .loveCount = (controller
//                                                     .feedPagingController
//                                                     .itemList![index]
//                                                     .loveCount +
//                                                     1);
//                                               }
//                                             }
//                                             setState(() {});
//                                           },
//                                           color: controller.feedPagingController
//                                               .itemList?[index].isLove ==
//                                               true
//                                               ? Colors.red
//                                               : Colors.grey,
//                                           size: 25,
//                                         ),
//                                         Sizer(
//                                           width: 10.w,
//                                         ),
//                                         Label(
//                                           text: controller.feedPagingController
//                                               .itemList?[index].loveCount
//                                               .toString() ??
//                                               '',
//                                           style: Styles.mediumText(
//                                               fontWeight: FontWeight.bold),
//                                         ),
//                                         const Sizer(),
//                                         IconAppButton(
//                                           icon: FontAwesomeIcons.comment,
//                                           onPressed: () {
//                                             // if (!serviceLocator<UserCubit>()
//                                             //     .isLoggedIn) {
//                                             //   context.push(Routes.LOGIN);
//                                             // } else {
//                                             //   showCommentsBottomSheetInstagram(
//                                             //       context,
//                                             //       commentCount: controller.feedPagingController
//                                             //           .itemList?[index].commentsCount
//                                             //           .toString() ??
//                                             //           '',
//                                             //       comment: state.postComments![index],
//                                             //       );
//                                             // }
//                                             showModalBottomSheet(
//                                               context: context,
//                                               isScrollControlled: true,
//                                               isDismissible: true,
//                                               backgroundColor: Colors.transparent,
//                                               builder: (context) {
//                                                 return BlocProvider.value(
//                                                   value: serviceLocator<
//                                                       InstagramCubit>()
//                                                     ..loadComments(
//                                                         context,
//                                                         controller
//                                                             .feedPagingController
//                                                             .itemList![index]
//                                                             .id),
//                                                   child: GestureDetector(
//                                                     behavior:
//                                                     HitTestBehavior.opaque,
//                                                     onTap: () {
//                                                       FocusScope.of(context)
//                                                           .unfocus();
//                                                     },
//                                                     child: InstagramPostComments(
//                                                       postId: controller
//                                                           .feedPagingController
//                                                           .itemList![index]
//                                                           .id,
//                                                       commentCount: controller
//                                                           .feedPagingController
//                                                           .itemList?[index]
//                                                           .commentsCount
//                                                           .toString() ??
//                                                           '',
//                                                       onCommentReply:
//                                                           (ReplyOnCommentParams
//                                                       params) async {
//                                                         var result =
//                                                         await controller
//                                                             .replyOnComment(
//                                                           params:
//                                                           ReplyOnCommentParams(
//                                                               postId:
//                                                               params.postId,
//                                                               content: params
//                                                                   .content,
//                                                               commentId: params
//                                                                   .commentId),
//                                                         );
//                                                         var currentPost = controller
//                                                             .feedPagingController
//                                                             .itemList
//                                                             ?.firstWhere(
//                                                                 (element) =>
//                                                             element.id ==
//                                                                 params.postId);
//                                                         currentPost?.commentsCount =
//                                                         (currentPost
//                                                             .commentsCount +
//                                                             1);
//                                                         return result;
//                                                       },
//                                                       onAddComment:
//                                                           (PostCommentParams
//                                                       params) async {
//                                                         var result =
//                                                         await controller
//                                                             .onPostComment(
//                                                             params: params);
//                                                         return result;
//                                                       },
//                                                       onDeleteComment:
//                                                           (String id) async {
//                                                         return await controller
//                                                             .deleteComment(
//                                                             context: context,
//                                                             commentId: id,
//                                                             postId: controller
//                                                                 .feedPagingController
//                                                                 .itemList![
//                                                             index]
//                                                                 .id,
//                                                             from: 'feed');
//                                                         // print(result);
//                                                       },
//                                                       onDeleteReply:
//                                                           (String id) async {
//                                                         return await controller
//                                                             .deleteComment(
//                                                             context: context,
//                                                             commentId: id,
//                                                             postId: controller
//                                                                 .feedPagingController
//                                                                 .itemList![
//                                                             index]
//                                                                 .id,
//                                                             from: 'feed');
//                                                       },
//                                                       onEditComment:
//                                                           (PostCommentParams
//                                                       params) async {
//                                                         var result =
//                                                         await controller
//                                                             .editComment(
//                                                             params: params);
//                                                         return result;
//                                                       },
//                                                     ),
//                                                   ),
//                                                 );
//                                               },
//                                             );
//                                           },
//                                           color: Colors.grey,
//                                           size: 25,
//                                         ),
//                                         Sizer(
//                                           width: 20.w,
//                                         ),
//                                         Label(
//                                           text: controller.feedPagingController
//                                               .itemList?[index].commentsCount
//                                               .toString() ??
//                                               '',
//                                           style: Styles.mediumText(
//                                               fontWeight: FontWeight.bold),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   const Expanded(
//                                     child: Row(
//                                       mainAxisAlignment: MainAxisAlignment.end,
//                                       children: [],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             if (sortedPosts[index]
//                                 .content!.isNotEmpty)
//                               Row(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Expanded(
//                                     child: Padding(
//                                       padding: EdgeInsetsDirectional.symmetric(
//                                           horizontal: 20.w),
//                                       child: RichText(
//                                         text: WidgetSpan(child: GestureDetector(
//                                           onTap: () {
//                                             setState(() {
//                                               _isExpanded = !_isExpanded;
//                                             });
//                                           },
//                                           child: Row(
//                                             children: [
//                                               Expanded(
//                                                 child: Text(
//                                                   sortedPosts[index].content ?? '',
//                                                   textAlign: _isArabic(sortedPosts[index]
//                                                       .content ??
//                                                       '')
//                                                       ? TextAlign.right
//                                                       : TextAlign.left,
//                                                   style: Styles.mediumText(
//                                                       fontSize: 60.sp),
//                                                   maxLines: _isExpanded ? null : 3,
//                                                   overflow: _isExpanded
//                                                       ? null
//                                                       : TextOverflow.ellipsis,
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         )),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             Padding(
//                               padding:
//                               EdgeInsetsDirectional.symmetric(horizontal: 20.w),
//                               child: Text(
//                                   sortedPosts[index]
//                                       .sinceTime ??
//                                       '',
//                                   style: Styles.mediumText(
//                                       color: AppColors.GREY_NORMAL_COLOR)),
//                             ),
//                             Container(
//                               height: 5.h,
//                               width: double.infinity,
//                               color: AppColors.DIVIDER_GRAY_COLOR2,
//                             ),
//                           ],
//                         );
//                       }
//                     },
//                     noMoreItemsIndicatorBuilder: (context) => Container(),
//                     firstPageProgressIndicatorBuilder: (context) =>
//                     const CupertinoActivityIndicator(),
//                     newPageProgressIndicatorBuilder: (context) =>
//                     const CupertinoActivityIndicator(),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         }),
//       ),
//     );
//   }
//
//   Widget _buildMainAccountHeader({
//     required BuildContext context,
//     required PostEntity post,
//   }) {
//     return Row(
//       children: [
//         InkWell(
//           onTap: () {
//             context.push(Routes.INSTAGRAMPROFILE, extra: post.user.id);
//           },
//           child: CircleAvatar(
//             radius: 32.r,
//             backgroundColor: Colors.white,
//             backgroundImage: NetworkImage(
//                 (post.user.image != null && post.user.image.isNotEmpty)
//                     ? post.user.image
//                     : UIConst.profilePlaceHolder),
//           ),
//         ),
//         const Sizer(),
//         Expanded(
//             child: Row(
//               children: [
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     InkWell(
//                       onTap: () {
//                         context.push(Routes.INSTAGRAMPROFILE, extra: post.user.id);
//                       },
//                       child: TextAppButton(
//                           style: TextStyle(
//                               color: Theme.of(context).primaryColor,
//                               fontSize: 30.sp),
//                           label: "${post.user.firstName} ${post.user.lastName}",
//                           onPressed: () {
//                             context.push(Routes.INSTAGRAMPROFILE,
//                                 extra: post.user.id);
//                           }),
//                     ),
//                   ],
//                 ),
//                 // _buildActivityFeelingWidget(post),
//               ],
//             )),
//       ],
//     );
//   }
//
//   bool _isArabic(String text) {
//     final arabicRegex = RegExp(r'[\u0600-\u06FF]');
//     return arabicRegex.hasMatch(text);
//   }
// }
