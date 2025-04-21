import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/search/domain/use_case/fetch_search_use_case.dart';
import 'package:fourtyninehub/features/search/presentation/controller/cubit/search_cubit.dart';
import 'package:fourtyninehub/features/search/presentation/pages/widget/build_item_post_search.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/post_entity.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/add_reply_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/post_comment_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/post_react_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/cubit/social_posts_cubit.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/pages/post_details_page.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/normal_post_screen.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/posts/facebook_post_comments.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostsSearchView extends StatefulWidget {
  const PostsSearchView({super.key, required this.params});

  final SearchParams params;

  @override
  State<PostsSearchView> createState() => _PostsSearchViewState();
}

class _PostsSearchViewState extends State<PostsSearchView> {
  late ScrollController _scrollController;
  late SearchCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<SearchCubit>();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  Future<void> _onScroll() async {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final prefs = await SharedPreferences.getInstance();
      String? filter = prefs.getString('filter');
      SearchParams searchParams = SearchParams(
          filter: filter,
          params: widget.params.params,
          search: widget.params.search);
      context.read<SearchCubit>().getPaginatedPostsSearch(params: searchParams);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        // Handle loading state
        if (state.status == SearchStates.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        // Handle success state
        if (state.status == SearchStates.success) {
          final posts = state.posts;
          if (posts == null || posts.isEmpty) {
            return Center(child: Text('No posts found.'));
          }
          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(posts[index].user.firstName),
              );
            },
          );
        }

        // Handle error state
        if (state.status == SearchStates.error) {
          return Center(child: Text('Error: Something went wrong.'));
        }

        // Fallback if no state matches
        return const Center(child: Text('Something went wrong.'));
      },
    );


  }
}
/*
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 10.w),
      child: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) {
          print("${context.read<SearchCubit>().postsSearch.length}");
          if (state.status == SearchStates.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          final controller = context.read<SearchCubit>();
          if (controller.searchController.text.isNotEmpty) {
            return ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.all(0),
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.postsSearch.length ?? 0,
              itemBuilder: (context, i) {
                var post = controller.postsSearch[i];
                return BlocProvider(
                  create: (context) => serviceLocator<SocialPostsCubit>(),
                  child: NormalPostScreen(
                    postEntity: post,
                  ),
                );
              },
            );
            // return ListView.builder(
            //   controller: _scrollController,
            //   physics: const AlwaysScrollableScrollPhysics(),
            //   itemCount: controller.postsSearch.length,
            //   itemBuilder: (context, index) {
            //     final user = context.read<UserCubit>().state.data;
            //     return Column(
            //       children: [
            //         NormalPostScreen(
            //           postEntity: controller.postsSearch[index],
            //         ),
            //         // BuildItemPostSearch(
            //         //   deletePost: (String postId) => controller.deletePost(
            //         //       context: context, postId: postId),
            //         //   hidePost: (String postId) => controller.hidePost(
            //         //       context: context, postId: postId),
            //         //   post: controller.postsSearch[index],
            //         //   onReact: (PostReactParams item) =>
            //         //       controller.onReact(params: item, from: 'posts'),
            //         //   showPostComments: (String v) {
            //         //     bottomSheet(
            //         //         context: context,
            //         //         isScrollControlled: true,
            //         //         widget: BlocProvider.value(
            //         //           value: serviceLocator<SocialPostsCubit>(),
            //         //             // ..loadPostCommentsData(context: context, postId: controller.postsSearch[index].id),
            //         //           child: FacebookPostComments(
            //         //             postId: controller.postsSearch[index].id,
            //         //             onAddComment: (PostCommentParams params) {
            //         //               return controller.onPostComment(
            //         //                   params: params, from: 'feed');
            //         //             },
            //         //             onCommentReply:
            //         //                 (ReplyOnCommentParams params) {
            //         //               return controller.replyOnComment(
            //         //                 params: ReplyOnCommentParams(
            //         //                     postId: params.postId,
            //         //                     content: params.content,
            //         //                     commentId: params.commentId),
            //         //                 from: 'feed',
            //         //               );
            //         //             },
            //         //             onDeleteComment: (String id) async {
            //         //               return await controller.deleteComment(
            //         //                   context: context,
            //         //                   commentId: id,
            //         //                   postId: controller
            //         //                       .postsSearch[index]
            //         //                       .id,
            //         //                   from: 'feed');
            //         //               // print(result);
            //         //             },
            //         //             onDeleteReply: (String id) async {
            //         //               return await controller.deleteComment(
            //         //                   context: context,
            //         //                   commentId: id,
            //         //                   postId: controller
            //         //                       .postsSearch[index]
            //         //                       .id,
            //         //                   from: 'feed');
            //         //             },
            //         //             from: 'feed',
            //         //             onEditComment:
            //         //                 (PostCommentParams params) async {
            //         //               var result = await controller.editComment(
            //         //                   params: params);
            //         //               return result;
            //         //             },
            //         //           ),
            //         //         ));
            //         //   },
            //         //   showPostDetails: (PostEntity post) => bottomSheet(
            //         //       context: context,
            //         //       isScrollControlled: true,
            //         //       widget: BlocProvider.value(
            //         //         value: serviceLocator<SocialPostsCubit>()
            //         //           ..loadPostDetails(
            //         //               context,
            //         //               controller.postsSearch[index].isShared ==
            //         //                   true
            //         //                   ? controller.postsSearch[index].mainPost!.id
            //         //                   : controller.postsSearch[index].id),
            //         //         child: PostDetailsPage(
            //         //           comments: const [],
            //         //           postId: controller.postsSearch[index].id,
            //         //           deletePost: (String postId) =>
            //         //               controller.deletePost(
            //         //                   context: context, postId: postId),
            //         //           hidePost: (String postId) => controller
            //         //               .hidePost(context: context, postId: postId),
            //         //           onAddComment: (PostCommentParams params) =>
            //         //               controller.onPostComment(
            //         //                   params: params, from: 'details'),
            //         //           onReact: (params) => controller.onReact(
            //         //               params: params, from: 'posts'),
            //         //           showPostComments: (postId) {},
            //         //           showPostDetails: (PostEntity post) {},
            //         //           // post: controller.searchPagingPostsController.itemList![index],
            //         //
            //         //           onCommentReply: (ReplyOnCommentParams params) {
            //         //             return controller.replyOnComment(
            //         //               params: ReplyOnCommentParams(
            //         //                   postId: params.postId,
            //         //                   content: params.content,
            //         //                   commentId: params.commentId),
            //         //               from: 'details',
            //         //             );
            //         //           },
            //         //           onDeleteComment: (String id) async {
            //         //             return await controller.deleteComment(
            //         //                 context: context,
            //         //                 commentId: id,
            //         //                 postId: controller
            //         //                     .postsSearch[index]
            //         //                     .id,
            //         //                 from: 'feed');
            //         //             // print(result);
            //         //           },
            //         //           onDeleteReply: (String id) async {
            //         //             return await controller.deleteComment(
            //         //                 context: context,
            //         //                 commentId: id,
            //         //                 postId: controller
            //         //                     .postsSearch[index]
            //         //                     .id,
            //         //                 from: 'feed');
            //         //           },
            //         //           onEditComment:
            //         //               (PostCommentParams params) async {
            //         //             var result = await controller.editComment(
            //         //                 params: params);
            //         //             return result;
            //         //           },
            //         //         ),
            //         //       )),
            //         //   isMyPost: controller.postsSearch[index].user !=
            //         //       null
            //         //       ? (user?.id ==
            //         //       controller.postsSearch[index].user.id)
            //         //       : false,
            //         //   onShare: (String id) {
            //         //     controller.onShare(postId: id);
            //         //   },
            //         //   from: 'posts',
            //         //   index: index,
            //         // ),
            //         Container(
            //           width: double.infinity,
            //           height: 5.h,
            //           color: AppColors.TXTFIELD_GRAY_COLOR2,
            //         ),
            //       ],
            //     );
            //   },
            // );
          }
          return Center(
            child: Text(
              LocaleKeys.noPosts.localize,
              style: Styles.mediumText(),
            ),
          );
        },
      ),
    );

 */