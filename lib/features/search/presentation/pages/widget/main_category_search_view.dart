import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';
import 'package:fourtyninehub/features/search/domain/use_case/fetch_search_use_case.dart';
import 'package:fourtyninehub/features/search/presentation/controller/cubit/search_cubit.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../common/models/public/pagination_params.dart';
import 'build_Item_search_main_category.dart';

//MainCategorySearchView


class MainCategorySearchView extends StatefulWidget {
  const MainCategorySearchView({Key? key}) : super(key: key);


  @override
  State<MainCategorySearchView> createState() => _MainCategorySearchViewState();
}

class _MainCategorySearchViewState extends State<MainCategorySearchView> {
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
            controller: _scrollController, // Add this line
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



// class MainCategorySearchView extends StatefulWidget {
//   const MainCategorySearchView({super.key,});
//   // final SearchParams params;
//
//   @override
//   State<MainCategorySearchView> createState() => _MainCategorySearchViewState();
// }
//
// class _MainCategorySearchViewState extends State<MainCategorySearchView> {
//
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
//     if (_scrollController.position.pixels >=
//         _scrollController.position.maxScrollExtent - 200) {
//       final prefs = await SharedPreferences.getInstance();
//       String? filter = prefs.getString('filter');
//       SearchParams searchParams = SearchParams(
//           filter: filter,
//           params: widget.params.params,
//           search: widget.params.search
//       );
//       context.read<SearchCubit>().getPaginatedSearch(
//           params:searchParams);
//     }
//   }
//
//   @override
//   void dispose() {
//     _scrollController.removeListener(_onScroll);
//     _scrollController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 10.w),
//       child: BlocBuilder<SearchCubit, SearchState>(
//         builder: (context, state) {
//           // if(state.status ==SearchStates.loading){
//           //   return const Center(child: CircularProgressIndicator());
//           // }
//           final controller = context.read<SearchCubit>();
//           if (controller.searchController.text.isNotEmpty) {
//             return ListView.builder(
//               controller: _scrollController,
//               physics: const AlwaysScrollableScrollPhysics(),
//               itemCount: controller.paginatedSearch.length,
//               itemBuilder: (context, index) {
//                 return InkWell(
//                   onTap: () {
//                     context.push(Routes.SUBCATEGORIES,
//                         extra: controller.paginatedSearch[index]);
//                   },
//                   child: Padding(
//                     padding: const EdgeInsets.only(bottom: 8.0),
//                     child: BuildItemSearchMainCategory(
//                       category: controller.paginatedSearch[index],
//                       onFavorite: () async {
//                         var result = await controller
//                             .toggleFavoriteMedicalService(controller.paginatedSearch[index].id);
//                         print("result$result");
//                         return result;
//                       },
//                     ),
//                   ),
//                 );
//               },
//             );
//           }
//           return Center(
//             child: Text(
//               LocaleKeys.noData.localize,
//               style: Styles.mediumText(),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
