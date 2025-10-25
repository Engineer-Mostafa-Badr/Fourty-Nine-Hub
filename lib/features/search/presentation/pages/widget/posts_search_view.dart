import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/search/domain/use_case/fetch_search_use_case.dart';
import 'package:fourtyninehub/features/search/presentation/controller/cubit/search_cubit.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/cubit/social_posts_cubit.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/normal_post_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../common/models/public/pagination_params.dart';
import '../../../../../core/widget/custom_loading_search_widget.dart';
import '../../../../../core/widget/olx_pagination/banner.dart';
import '../../../../../core/widget/olx_pagination/olx_pagination_widget.dart';
import '../../../../account_taps/wallet/presentation/widgets/custom_empty_widget.dart';

class PostsSearchView extends StatefulWidget {
  const PostsSearchView({super.key});

  @override
  State<PostsSearchView> createState() => _PostsSearchViewState();
}

class _PostsSearchViewState extends State<PostsSearchView> {
  // late final ScrollController _scrollController;
  late final SearchCubit _cubit;
  static const _scrollThreshold = 200.0;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<SearchCubit>();
    // _scrollController = ScrollController()..addListener(_onScroll);
  }

  /* void _onScroll() async {
    final max = _scrollController.position.maxScrollExtent;
    final current = _scrollController.position.pixels;
    if (current >= max - _scrollThreshold &&
        !_cubit.isLoadingPostsSearchMore &&
        _cubit.hasMorePostsSearchData) {
      final prefs = await SharedPreferences.getInstance();
      final filter = prefs.getString('filter') ?? '';
      final params = SearchParams(
        search: _cubit.searchController.text.trim(),
        filter: filter,
        params: PaginationParams(page: _cubit.postsSearchPage),
      );
      _cubit.getPaginatedPostsSearch(params: params);
    }
  }*/

/*  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }*/

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        final posts = _cubit.postsSearch;
        if (_cubit.searchController.text.trim().isEmpty) {
          return CustomEmptyWidget.searchInitial(context: context);
        }
        // Handle loading state
        if (state.status == SearchStates.loading) {
          return const Center(
            // child: CustomCircularProgressIndicator(),
            child: CustomLoadingSearchWidget(),
          );
        }

        if (posts.isEmpty) {
          return CustomEmptyWidget(
            label: LocaleKeys.noResultsFound.localize,
          );
        }

        // Handle success state
        if (state.status == SearchStates.success) {
          final posts = state.posts;
          if (posts == null || posts.isEmpty) {
            return CustomEmptyWidget(
              label: LocaleKeys.noResultsFound.localize,
            );
          }
          print("${posts.length}");
          print("${posts.first}");
          print("${posts.first.content}");
          print("${posts.first.name}");
          print(posts.first.user.firstName);
          print(posts.first.id);
          return OlxPaginationWidget(
            scrollController: ScrollController(),
            itemsPerPage: 2,
            loadPage: (page) async {
              {
                final prefs = await SharedPreferences.getInstance();
                final filter = prefs.getString('filter') ?? '';
                final params = SearchParams(
                  search: _cubit.searchController.text.trim(),
                  filter: filter,
                  params: PaginationParams(page: _cubit.postsSearchPage),
                );
                _cubit.getPaginatedPostsSearch(params: params);
              }
            },
            banners: bannersList,
            items: List.generate(
              posts.length,
              (index) {
                return BlocConsumer<SocialPostsCubit, SocialPostsState>(
                  listener: (context, state) {},
                  builder: (context, state) {
                    return NormalPostScreen(
                      postEntity: posts[index],
                    );
                  },
                );

                return ListTile(
                  title: Text(posts[index].user.firstName),
                );
              },
            ),
          );
          /*return ListView.builder(
            controller: _scrollController, // Add this line
            itemCount: posts.length,
            itemBuilder: (context, index) {
              return BlocConsumer<SocialPostsCubit, SocialPostsState>(
                listener: (context, state) {},
                builder: (context, state) {
                  return NormalPostScreen(
                    postEntity: posts[index],
                  );
                },
              );

              return ListTile(
                title: Text(posts[index].user.firstName),
              );
            },
          );*/
        }

        // Handle error state
        if (state.status == SearchStates.error) {
          return CustomEmptyWidget(
            label: LocaleKeys.noResultsFound.localize,
          );
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
            return const Center(child: CustomCircularProgressIndicator());
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
