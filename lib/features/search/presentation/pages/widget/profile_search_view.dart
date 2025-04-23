import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/features/search/domain/entity/user_search_entity.dart';
import 'package:fourtyninehub/features/search/domain/use_case/fetch_search_use_case.dart';
import 'package:fourtyninehub/features/search/presentation/controller/cubit/search_cubit.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../common/models/public/pagination_params.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';



class ProfileSearchView extends StatefulWidget {
  const ProfileSearchView({Key? key}) : super(key: key);

  @override
  State<ProfileSearchView> createState() => _ProfileSearchViewState();
}

class _ProfileSearchViewState extends State<ProfileSearchView> {
  late final ScrollController _scrollController;
  late final SearchCubit _cubit;
  static const _scrollThreshold = 200.0;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<SearchCubit>();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  void _onScroll() async {
    final max = _scrollController.position.maxScrollExtent;
    final current = _scrollController.position.pixels;
    if (current >= max - _scrollThreshold &&
        !_cubit.isLoadingUsersSearchMore &&
        _cubit.hasMoreUsersSearchData) {
      final prefs = await SharedPreferences.getInstance();
      final filter = prefs.getString('filter') ?? '';
      final params = SearchParams(
        search: _cubit.searchController.text.trim(),
        filter: filter,
        params: PaginationParams(page: _cubit.usersSearchPage),
      );
      _cubit.getPaginatedUserSearch(params: params);
    }
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 4.w),
      child: BlocBuilder<SearchCubit, SearchState>(
        buildWhen: (prev, curr) =>
        prev.userSearch != curr.userSearch || prev.status != curr.status,
        builder: (context, state) {
          // Loading first page
          if (state.status == SearchStates.loading && _cubit.usersSearch.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          // No results
          if (_cubit.usersSearch.isEmpty) {
            return Center(
              child: Text(
                LocaleKeys.noData.localize,
                style: Styles.mediumText(),
              ),
            );
          }
          // Display list + loader at bottom
          return ListView.builder(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: _cubit.usersSearch.length + (_cubit.isLoadingUsersSearchMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index >= _cubit.usersSearch.length) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              final user = _cubit.usersSearch[index];
              return InkWell(
                onTap: () => Navigator.pushNamed(
                  context,
                  Routes.OTHERSACCOUNT,
                  arguments: user.id,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      ClipOval(
                        child: Image.network(
                          user.image?.isNotEmpty == true
                              ? user.image!
                              : 'https://via.placeholder.com/150',
                          width: 12.w,
                          height: 12.w,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${user.firstName} ${user.lastName}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              '@${user.username}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward,
                        color: AppColors.GREY_NORMAL_COLOR,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}


// class _ProfileSearchViewState extends State<ProfileSearchView> {
//   late ScrollController _scrollController;
//   late SearchCubit _cubit;
//
//   @override
//   void initState() {
//     super.initState();
//     _cubit = context.read<SearchCubit>();
//     _scrollController = ScrollController()..addListener(_onScroll);
//   }
//
//   Future<void> _onScroll() async {
//
//     if (_scrollController.position.pixels >=
//         _scrollController.position.maxScrollExtent - 200) {
//       final prefs = await SharedPreferences.getInstance();
//       String? filter = prefs.getString('filter');
//       SearchParams searchParams = SearchParams(
//           filter: filter,
//           params: widget.params.params,
//           search: widget.params.search
//       );
//       context.read<SearchCubit>().getPaginatedUserSearch(
//           params:searchParams);
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 30.w),
//       child: BlocBuilder<SearchCubit, SearchState>(
//         builder: (BuildContext context, state) {
//           // if(state.status ==SearchStates.loading){
//           //   return const Center(child: CircularProgressIndicator());
//           // }
//           final controller = context.read<SearchCubit>();
//           if (controller.searchController.text.isNotEmpty) {
//             return ListView.builder(
//               controller: _scrollController,
//               physics: const AlwaysScrollableScrollPhysics(),
//               itemCount: controller.usersSearch.length,
//               itemBuilder: (context, index) {
//                 var data = controller.usersSearch[index];
//                 // final user = context.read<UserCubit>().state.data;
//                 return InkWell(
//                   onTap: () {
//                     context.push(Routes.OTHERSACCOUNT, extra: data.id);
//                   },
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           spacing: 8,
//                           children: [
//                             SizedBox(
//                               width: 65,
//                               height: 65,
//                               child: ClipOval(
//                                 child: Image.network(
//                                   data.image?.isNotEmpty == true
//                                       ? data.image!
//                                       : 'https://via.placeholder.com/150', // fallback placeholder image
//                                   errorBuilder: (context, error, stackTrace) {
//                                     return Image.network('https://via.placeholder.com/150'); // fallback if URL fails to load
//                                   },
//                                   fit: BoxFit.cover,
//                                 ),
//                               ),
//                             ),
//                            Expanded(child:  Column(
//                              crossAxisAlignment: CrossAxisAlignment.start,
//                              children: [
//                                Label(text:"${data.firstName} ${data.lastName}",
//                                  style: const TextStyle(
//                                    fontSize: 18,
//                                    fontWeight: FontWeight.w600,
//                                  ),
//                                ),
//                                Label(text:"${data.username}",
//                                  style: const TextStyle(
//                                    fontSize: 14,
//                                    fontWeight: FontWeight.w300,
//                                  ),
//                                ),
//                              ],
//                            ),),
//                           ],
//                         ),
//                         // BuildItemPostSearch(
//                         //   deletePost: (String postId) => controller.deletePost(
//                         //       context: context, postId: postId),
//                         //   hidePost: (String postId) => controller.hidePost(
//                         //       context: context, postId: postId),
//                         //   post: controller.postsSearch[index],
//                         //   onReact: (PostReactParams item) =>
//                         //       controller.onReact(params: item, from: 'posts'),
//                         //   showPostComments: (String v) {
//                         //     bottomSheet(
//                         //         context: context,
//                         //         isScrollControlled: true,
//                         //         widget: BlocProvider.value(
//                         //           value: serviceLocator<SocialPostsCubit>(),
//                         //           // ..loadPostCommentsData(context: context, postId: controller.postsSearch[index].id),
//                         //           child: FacebookPostComments(
//                         //             postId: controller.postsSearch[index].id,
//                         //             onAddComment: (PostCommentParams params) {
//                         //               return controller.onPostComment(
//                         //                   params: params, from: 'feed');
//                         //             },
//                         //             onCommentReply:
//                         //                 (ReplyOnCommentParams params) {
//                         //               return controller.replyOnComment(
//                         //                 params: ReplyOnCommentParams(
//                         //                     postId: params.postId,
//                         //                     content: params.content,
//                         //                     commentId: params.commentId),
//                         //                 from: 'feed',
//                         //               );
//                         //             },
//                         //             onDeleteComment: (String id) async {
//                         //               return await controller.deleteComment(
//                         //                   context: context,
//                         //                   commentId: id,
//                         //                   postId: controller
//                         //                       .postsSearch[index]
//                         //                       .id,
//                         //                   from: 'feed');
//                         //               // print(result);
//                         //             },
//                         //             onDeleteReply: (String id) async {
//                         //               return await controller.deleteComment(
//                         //                   context: context,
//                         //                   commentId: id,
//                         //                   postId: controller
//                         //                       .postsSearch[index]
//                         //                       .id,
//                         //                   from: 'feed');
//                         //             },
//                         //             from: 'feed',
//                         //             onEditComment:
//                         //                 (PostCommentParams params) async {
//                         //               var result = await controller.editComment(
//                         //                   params: params);
//                         //               return result;
//                         //             },
//                         //           ),
//                         //         ));
//                         //   },
//                         //   showPostDetails: (PostEntity post) => bottomSheet(
//                         //       context: context,
//                         //       isScrollControlled: true,
//                         //       widget: BlocProvider.value(
//                         //         value: serviceLocator<SocialPostsCubit>()
//                         //           ..loadPostDetails(
//                         //               context,
//                         //               controller.postsSearch[index].isShared ==
//                         //                   true
//                         //                   ? controller.postsSearch[index].mainPost!.id
//                         //                   : controller.postsSearch[index].id),
//                         //         child: PostDetailsPage(
//                         //           comments: const [],
//                         //           postId: controller.postsSearch[index].id,
//                         //           deletePost: (String postId) =>
//                         //               controller.deletePost(
//                         //                   context: context, postId: postId),
//                         //           hidePost: (String postId) => controller
//                         //               .hidePost(context: context, postId: postId),
//                         //           onAddComment: (PostCommentParams params) =>
//                         //               controller.onPostComment(
//                         //                   params: params, from: 'details'),
//                         //           onReact: (params) => controller.onReact(
//                         //               params: params, from: 'posts'),
//                         //           showPostComments: (postId) {},
//                         //           showPostDetails: (PostEntity post) {},
//                         //           // post: controller.searchPagingPostsController.itemList![index],
//                         //
//                         //           onCommentReply: (ReplyOnCommentParams params) {
//                         //             return controller.replyOnComment(
//                         //               params: ReplyOnCommentParams(
//                         //                   postId: params.postId,
//                         //                   content: params.content,
//                         //                   commentId: params.commentId),
//                         //               from: 'details',
//                         //             );
//                         //           },
//                         //           onDeleteComment: (String id) async {
//                         //             return await controller.deleteComment(
//                         //                 context: context,
//                         //                 commentId: id,
//                         //                 postId: controller
//                         //                     .postsSearch[index]
//                         //                     .id,
//                         //                 from: 'feed');
//                         //             // print(result);
//                         //           },
//                         //           onDeleteReply: (String id) async {
//                         //             return await controller.deleteComment(
//                         //                 context: context,
//                         //                 commentId: id,
//                         //                 postId: controller
//                         //                     .postsSearch[index]
//                         //                     .id,
//                         //                 from: 'feed');
//                         //           },
//                         //           onEditComment:
//                         //               (PostCommentParams params) async {
//                         //             var result = await controller.editComment(
//                         //                 params: params);
//                         //             return result;
//                         //           },
//                         //         ),
//                         //       )),
//                         //   isMyPost: controller.postsSearch[index].user !=
//                         //       null
//                         //       ? (user?.id ==
//                         //       controller.postsSearch[index].user.id)
//                         //       : false,
//                         //   onShare: (String id) {
//                         //     controller.onShare(postId: id);
//                         //   },
//                         //   from: 'posts',
//                         //   index: index,
//                         // ),
//                         // Container(
//                         //   width: double.infinity,
//                         //   height: 5.h,
//                         //   color: AppColors.TXTFIELD_GRAY_COLOR2,
//                         // ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             );
//           }
//           // else
//           // if (controller.searchController.text.isNotEmpty) {
//           //   return PagedListView<int, UserSearchEntity>(
//           //     pagingController: controller.searchPagingUserController,
//           //     builderDelegate: PagedChildBuilderDelegate<UserSearchEntity>(
//           //       noItemsFoundIndicatorBuilder: (context) {
//           //         return Center(
//           //           child: Text(
//           //             LocaleKeys.noData.localize,
//           //             style: Styles.mediumText(),
//           //           ),
//           //         );
//           //       },
//           //       itemBuilder: (context, item, index) {
//           //         return InkWell(
//           //             onTap: () {
//           //               context.push(Routes.OTHERSACCOUNT, extra: item.id);
//           //             },
//           //             child: buildItem(item));
//           //       },
//           //       noMoreItemsIndicatorBuilder: (context) => Container(),
//           //       firstPageProgressIndicatorBuilder: (context) =>
//           //           const CupertinoActivityIndicator(),
//           //       newPageProgressIndicatorBuilder: (context) =>
//           //           const CupertinoActivityIndicator(),
//           //     ),
//           //   );
//           // }
//           return Center(
//             child: Text(LocaleKeys.noResultsFound.localize),
//           );
//         },
//       ),
//     );
//   }
//
//   Widget buildItem(UserSearchEntity model) => Padding(
//         padding: EdgeInsets.only(
//           bottom: 15.h,
//         ),
//         child: Row(
//           children: [
//             Container(
//               height: 65.h,
//               width: 65.w,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 image: DecorationImage(
//                   fit: BoxFit.cover,
//                   image: NetworkImage(model.image ?? Assets.logo),
//                 ),
//               ),
//             ),
//             const Sizer(),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Label(text: '${model.firstName} ${model.lastName}'),
//                 Label(
//                   text: 'Friend',
//                   style: Styles.smallText(
//                     color: AppColors.GREY_NORMAL_COLOR,
//                   ),
//                 ),
//               ],
//             ),
//             const Spacer(),
//             const Icon(
//               Icons.arrow_forward,
//               color: AppColors.GREY_NORMAL_COLOR,
//             )
//           ],
//         ),
//       );
// }
